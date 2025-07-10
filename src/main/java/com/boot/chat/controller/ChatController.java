package com.boot.chat.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.chat.dto.ChatMessageRequest;
import com.boot.chat.dto.ChatMessageResponse;
import com.boot.chat.dto.ChatRoomRequest;
import com.boot.chat.dto.ChatRoomResponse;
import com.boot.chat.service.ChatService;
import com.boot.trade.dto.TradePostDTO;
import com.boot.trade.service.TradePostService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;

@Controller
public class ChatController {

    private final BoardCommentServiceImpl boardCommentServiceImpl;

    @Autowired
    private ChatService chatService;
    
    @Autowired
    private TradePostService tradePostService;

    ChatController(BoardCommentServiceImpl boardCommentServiceImpl) {
        this.boardCommentServiceImpl = boardCommentServiceImpl;
    } // 게시글 정보를 가져오기 위한 서비스
    
    @GetMapping("/trade_chat")
    public String tradeChat(@RequestParam("postID") Long postId,
                           @RequestParam("sellerNumber") Long sellerNumber,
                           @RequestParam(value = "buyerNumber", required = false) Long buyerNumber,
                           Model model, HttpServletRequest request ) {
        
        // 로그인 확인
        BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        
        // buyerNumber가 없으면 현재 로그인한 사용자의 번호를 사용
        if (buyerNumber == null) {
            buyerNumber = (long) user.getUserNumber();
        }
        
        // 로그인 사용자가 판매자인 경우 처리
        if (user.getUserNumber() == sellerNumber && buyerNumber == sellerNumber) {
            // 오류 메시지 표시
            model.addAttribute("errorMessage", "자신에게 채팅을 보낼 수 없습니다.");
            return "error/error_page";
        }
        
        // 게시글 정보 조회
        TradePostDTO post = tradePostService.getTradePostById(postId);
        if (post == null) {
            model.addAttribute("errorMessage", "존재하지 않는 게시글입니다.");
            return "error/error_page";
        }
        
        // 채팅방 생성 또는 조회
        ChatRoomRequest chatRoomRequest = new ChatRoomRequest();
        chatRoomRequest.setPostId(postId);
        chatRoomRequest.setSellerNumber(sellerNumber);
        chatRoomRequest.setBuyerNumber(buyerNumber);
        chatRoomRequest.setPostTitle(post.getTitle());
        
        try {
        	ChatRoomResponse chatRoom = chatService.createChatRoom(chatRoomRequest);
            
            // 채팅방 메시지 조회
            List<ChatMessageResponse> messages = chatService.getChatMessagesByRoom(chatRoom.getRoomId());
            
            // 메시지 읽음 상태 업데이트
            chatService.updateMessageReadStatus(chatRoom.getRoomId(), (long) user.getUserNumber());
            
            model.addAttribute("chatRoom", chatRoom);
            model.addAttribute("messages", messages);
            model.addAttribute("post", post);
            model.addAttribute("user", user);
            
            return "trade/trade_chat";
        } catch (Exception e) {
            System.err.println("채팅방 생성 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("errorMessage", "채팅방 생성 중 오류가 발생했습니다.");
            return "error/error_page";
        }
    }
    
    @PostMapping("/send_message")
    @ResponseBody
    public ResponseEntity<?> sendMessage(@RequestParam("roomId") Long roomId,
                                        @RequestParam("content") String content,
                                        HttpServletRequest requestS) {
    	BasicUserDTO user = (BasicUserDTO) requestS.getAttribute("user");

        try {
            // 메시지 저장
            ChatMessageRequest request = new ChatMessageRequest();
            request.setRoomId(roomId);
            request.setSenderNumber((long) user.getUserNumber());
            request.setMessage(content);
            
            ChatMessageResponse response = chatService.saveAndSendMessage(request);
            
            return ResponseEntity.ok(Map.of("success", true, "message", response));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "메시지 전송 중 오류가 발생했습니다."));
        }
    }
    
    /**
     * 채팅 목록 페이지로 이동
     */
    @GetMapping("/chat_list")
    public String chatListPage(HttpServletRequest request, Model model) {
    	BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
        if (user == null) {
            return "redirect:/";
        }
        
        // 사용자의 채팅방 목록 조회
        List<ChatRoomResponse> chatRooms = chatService.getChatRoomsByUser((long) user.getUserNumber());
        
        System.out.println("채팅방 목록 조회 결과: " + chatRooms.size() + "개");
        for (ChatRoomResponse room : chatRooms) {
            System.out.println("채팅방: " + room);
        }
        
        model.addAttribute("chatRooms", chatRooms);
        model.addAttribute("user", user);
        
        return "trade/trade_chat_list";
    }
    
 // ChatController.java의 수정 부분

    @GetMapping("/check_new_messages")
    @ResponseBody
    public ResponseEntity<?> checkNewMessages(HttpServletRequest request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 로그인 사용자 정보 가져오기
        	BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            Long userNumber = (long) user.getUserNumber();
            
            // 세션에서 활성 채팅방 ID 가져오기
            Long activeRoomId = (Long) session.getAttribute("activeRoomId");
            
            // 디버깅 로그 추가
//            System.out.println("사용자 번호: " + userNumber);
//            System.out.println("활성 채팅방 ID: " + activeRoomId);
            
            // 읽지 않은 메시지 수 조회
            int unreadCount;
            try {
                if (activeRoomId != null) {
                    unreadCount = chatService.countUnreadMessagesExcludeActiveRoom(userNumber, activeRoomId);
                } else {
                    unreadCount = chatService.countTotalUnreadMessagesByUser(userNumber);
                }
//                System.out.println("DB에서 조회한 읽지 않은 메시지 수: " + unreadCount);
            } catch (Exception e) {
                System.err.println("메시지 수 조회 중 오류: " + e.getMessage());
                e.printStackTrace();
                unreadCount = 0;
            }
            
//            System.out.println("unreadCount" + unreadCount);
//            // 테스트를 위해 임시로 1 이상의 값 설정 (실제 환경에서는 주석 처리)
//            unreadCount = Math.max(1, unreadCount);
//            System.out.println("최종 반환할 읽지 않은 메시지 수: " + unreadCount);
            
            response.put("success", true);
            response.put("unreadCount", unreadCount);
            
            return ResponseEntity.ok()
                .header("Cache-Control", "no-cache, no-store, must-revalidate")
                .header("Pragma", "no-cache")
                .header("Expires", "0")
                .body(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "알림 확인 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    
    /**
     * 새 메시지 가져오기
     */
    @GetMapping("/get_new_messages")
    @ResponseBody
    public Map<String, Object> getNewMessages(
            @RequestParam("roomId") Long roomId,
            @RequestParam(value = "lastMessageId", defaultValue = "0") Long lastMessageId,
            HttpServletRequest request) {
        
    	BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        
        // 새 메시지 조회
        List<ChatMessageResponse> messages = chatService.getChatMessagesByRoom(roomId);
        
        // 메시지 읽음 상태 업데이트
        chatService.updateMessageReadStatus(roomId, (long) user.getUserNumber());
        
        return Map.of("success", true, "messages", messages);
    }
    
    @PostMapping("/mark_all_messages_read")
    @ResponseBody
    public ResponseEntity<?> markAllMessagesRead(@RequestParam("roomId") Long roomId, 
                                                @RequestParam("userNumber") Long userNumber) {
        try {
            // 해당 채팅방의 모든 읽지 않은 메시지를 읽음 처리
            chatService.markAllMessagesAsRead(roomId, userNumber);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
    @PostMapping("/mark_message_read")
    @ResponseBody
    public ResponseEntity<?> markMessageRead(@RequestParam("roomId") Long roomId,
                                            @RequestParam("messageId") Long messageId,
                                            @RequestParam("userNumber") Long userNumber) {
        try {
            // 특정 메시지를 읽음 처리
            chatService.markMessageAsRead(roomId, messageId, userNumber);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
    
 // 활성 채팅방 설정 컨트롤러 메서드
    @PostMapping("/set_active_room")
    public ResponseEntity<?> setActiveRoom(@RequestParam("roomId") Long roomId, HttpSession session) {
        try {
            // 세션에 활성 채팅방 ID 저장
            session.setAttribute("activeRoomId", roomId);
//            System.out.println("활성 채팅방 설정: " + roomId);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "활성 채팅방 설정 중 오류가 발생했습니다."));
        }
    }

    // 활성 채팅방 정보 제거 컨트롤러 메서드
    @PostMapping("/clear_active_room")
    public ResponseEntity<?> clearActiveRoom(HttpSession session) {
        try {
            // 세션에서 활성 채팅방 ID 제거
            session.removeAttribute("activeRoomId");
            System.out.println("활성 채팅방 정보 제거");
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "활성 채팅방 정보 제거 중 오류가 발생했습니다."));
        }
    }
}