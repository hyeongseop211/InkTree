package com.boot.chat.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.chat.dao.ChatMessageDAO;
import com.boot.chat.dao.ChatRoomDAO;
import com.boot.chat.dto.ChatMessageRequest;
import com.boot.chat.dto.ChatMessageResponse;
import com.boot.chat.dto.ChatRoomRequest;
import com.boot.chat.dto.ChatRoomResponse;

import com.boot.chat.service.ChatService;

@Service
public class ChatServiceImpl implements ChatService {

	@Autowired
	private ChatRoomDAO chatRoomDAO;

	@Autowired
	private ChatMessageDAO chatMessageDAO;

	@Autowired
	private SimpMessagingTemplate messagingTemplate;

    /**
     * 사용자의 모든 채팅방에서 읽지 않은 메시지 총 개수 조회
     */
    public int countTotalUnreadMessagesByUser(Long userNumber) {
        try {
            System.out.println("countTotalUnreadMessagesByUser 호출: userNumber=" + userNumber);
            int count = chatMessageDAO.countTotalUnreadMessagesByUser(userNumber);
//            System.out.println("조회된 읽지 않은 메시지 수: " + count);
            return count;
        } catch (Exception e) {
            System.err.println("countTotalUnreadMessagesByUser 오류: " + e.getMessage());
            e.printStackTrace();
            // 테스트를 위해 임시로 1 반환 (실제 환경에서는 0 반환)
            return 0;
        }
    }

    /**
     * 활성 채팅방을 제외한 읽지 않은 메시지 수 조회
     */
    public int countUnreadMessagesExcludeActiveRoom(Long userNumber, Long activeRoomId) {
        try {
//            System.out.println("countUnreadMessagesExcludeActiveRoom 호출: userNumber=" + userNumber + ", activeRoomId=" + activeRoomId);
            int count = chatMessageDAO.countUnreadMessagesExcludeActiveRoom(userNumber, activeRoomId);
//            System.out.println("조회된 읽지 않은 메시지 수: " + count);
            return count;
        } catch (Exception e) {
            System.err.println("countUnreadMessagesExcludeActiveRoom 오류: " + e.getMessage());
            e.printStackTrace();
            // 테스트를 위해 임시로 1 반환 (실제 환경에서는 0 반환)
            return 0;
        }
    }
	/**
	 * 특정 메시지까지 읽음 상태 업데이트
	 */
	// 모든 메시지 읽음 처리
	public void markAllMessagesAsRead(Long roomId, Long userNumber) {
		chatMessageDAO.markAllMessagesAsRead(roomId, userNumber);
	}

	// 특정 메시지까지 읽음 처리
	public void markMessageAsRead(Long roomId, Long messageId, Long userNumber) {
		chatMessageDAO.markMessageAsRead(roomId, messageId, userNumber);
	}

	/**
	 * 메시지를 저장하고 상대방에게 전송
	 */
	@Override
	@Transactional
	public ChatMessageResponse saveAndSendMessage(ChatMessageRequest request) {

	    System.out.println("===== 메시지 저장 요청 =====");
	    System.out.println("roomId: " + request.getRoomId());
	    System.out.println("senderNumber: " + request.getSenderNumber());
	    System.out.println("message: " + request.getMessage());

	    // 1. 채팅방 정보 조회
	    ChatRoomResponse chatRoom = chatRoomDAO.selectChatRoomById(request.getRoomId());
	    if (chatRoom == null) {
	        throw new RuntimeException("존재하지 않는 채팅방입니다.");
	    }

	    // 2. 메시지 객체 생성
	    ChatMessageResponse chatMessage = new ChatMessageResponse();
	    chatMessage.setRoomId(request.getRoomId());
	    chatMessage.setSenderNumber(request.getSenderNumber());
	    chatMessage.setMessage(request.getMessage());
	    chatMessage.setReadStatus("UNREAD");
	    chatMessage.setCreatedAt(LocalDateTime.now());

	    // 3. 수신자 번호 설정 - 송신자가 판매자면 구매자에게, 구매자면 판매자에게
	    Long senderNumber = request.getSenderNumber();
	    Long sellerNumber = chatRoom.getSellerNumber();
	    Long buyerNumber = chatRoom.getBuyerNumber();
	    
	    // 송신자와 판매자/구매자 비교하여 수신자 결정
	    Long receiverNumber;
	    if (senderNumber.equals(sellerNumber)) {
	        // 송신자가 판매자인 경우, 수신자는 구매자
	        receiverNumber = buyerNumber;
	        System.out.println("송신자(판매자): " + senderNumber + ", 수신자(구매자): " + receiverNumber);
	    } else if (senderNumber.equals(buyerNumber)) {
	        // 송신자가 구매자인 경우, 수신자는 판매자
	        receiverNumber = sellerNumber;
	        System.out.println("송신자(구매자): " + senderNumber + ", 수신자(판매자): " + receiverNumber);
	    } else {
	        // 송신자가 채팅방의 판매자나 구매자가 아닌 경우 (오류 상황)
	        throw new RuntimeException("메시지 송신자가 채팅방의 판매자나 구매자가 아닙니다.");
	    }
	    
	    // 수신자 번호 설정
	    chatMessage.setReceiverNumber(receiverNumber);

	    // 4. 메시지 저장
	    chatMessageDAO.insertChatMessage(chatMessage);

	    // 5. 채팅방 마지막 메시지 시간 업데이트
	    chatRoomDAO.updateLastMessageAt(request.getRoomId(), LocalDateTime.now());

	    // 6. 응답 메시지 생성
	    ChatMessageResponse response = new ChatMessageResponse();
	    response.setMessageId(chatMessage.getMessageId());
	    response.setRoomId(chatMessage.getRoomId());
	    response.setSenderNumber(chatMessage.getSenderNumber());
	    response.setReceiverNumber(chatMessage.getReceiverNumber()); // 수신자 번호 설정
	    response.setMessage(chatMessage.getMessage());
	    response.setReadStatus(chatMessage.getReadStatus());
	    response.setCreatedAt(chatMessage.getCreatedAt());

	    // 7. 발신자 이름 설정 (사용자 정보 조회)
	    Map<String, Object> userInfo = chatRoomDAO.selectUserInfo(chatMessage.getSenderNumber());
	    if (userInfo != null) {
	        response.setSenderName((String) userInfo.get("userName"));
	    }

	    // 8. 상대방에게 메시지 전송
	    messagingTemplate.convertAndSendToUser(receiverNumber.toString(), "/queue/messages", response);

	    // 9. 채팅방 구독자들에게 메시지 전송
	    messagingTemplate.convertAndSend("/topic/room/" + request.getRoomId(), response);

	    return response;
	}

	/**
	 * 채팅방 생성
	 */
	@Override
	@Transactional
	public ChatRoomResponse createChatRoom(ChatRoomRequest request) {
		System.out.println("===== 채팅방 생성 요청 =====");
		System.out.println("postId: " + request.getPostId());
		System.out.println("sellerNumber: " + request.getSellerNumber());
		System.out.println("buyerNumber: " + request.getBuyerNumber());

		// 1. 판매자와 구매자가 USERINFO 테이블에 존재하는지 확인
		Map<String, Object> seller = chatRoomDAO.selectUserInfo(request.getSellerNumber());
		Map<String, Object> buyer = chatRoomDAO.selectUserInfo(request.getBuyerNumber());

		System.out.println("판매자 정보: " + seller);
		System.out.println("구매자 정보: " + buyer);

		if (seller == null) {
			throw new RuntimeException("판매자가 존재하지 않습니다: " + request.getSellerNumber());
		}

		if (buyer == null) {
			throw new RuntimeException("구매자가 존재하지 않습니다: " + request.getBuyerNumber());
		}

		// 2. 기존 채팅방 조회
		ChatRoomResponse existingRoom = chatRoomDAO.selectChatRoomByPostAndUsers(request.getPostId(), request.getSellerNumber(),
				request.getBuyerNumber());

		if (existingRoom != null) {
			System.out.println("기존 채팅방 발견: " + existingRoom.getRoomId());
			return existingRoom;
		}

		// 3. 새 채팅방 생성
		ChatRoomResponse chatRoom = new ChatRoomResponse();
		chatRoom.setPostId(request.getPostId());
		chatRoom.setSellerNumber(request.getSellerNumber());
		chatRoom.setBuyerNumber(request.getBuyerNumber());
		chatRoom.setCreatedAt(LocalDateTime.now());
		chatRoom.setLastMessageAt(LocalDateTime.now());
		chatRoom.setStatus("ACTIVE");

		System.out.println("새 채팅방 생성 시도: " + chatRoom);

		try {
			chatRoomDAO.insertChatRoom(chatRoom);
			System.out.println("채팅방 생성 성공: " + chatRoom.getRoomId());
		} catch (Exception e) {
			System.err.println("채팅방 생성 실패: " + e.getMessage());
			e.printStackTrace();
			throw e;
		}

		// 4. 시스템 메시지 추가 (선택적)
		// 시스템 메시지 추가를 일단 주석 처리하여 채팅방 생성만 테스트
		/*
		 * ChatMessage systemMessage = new ChatMessage();
		 * systemMessage.setRoomId(chatRoom.getRoomId());
		 * systemMessage.setSenderNumber(request.getSellerNumber()); // 판매자를 발신자로 설정
		 * systemMessage.setMessage("채팅방이 생성되었습니다.");
		 * systemMessage.setReadStatus("READ");
		 * systemMessage.setCreatedAt(LocalDateTime.now());
		 * 
		 * try { chatMessageDAO.insertChatMessage(systemMessage);
		 * System.out.println("시스템 메시지 추가 성공"); } catch (Exception e) {
		 * System.err.println("시스템 메시지 추가 실패: " + e.getMessage()); e.printStackTrace();
		 * // 시스템 메시지 추가 실패해도 채팅방은 생성된 상태로 유지 }
		 */

		return chatRoom;
	}

	/**
	 * 채팅방 입장 처리
	 */
	@Override
	@Transactional
	public ChatMessageResponse joinChatRoom(Long roomId, Long userNumber) {

		// 1. 이전 메시지 읽음 상태 업데이트
		chatMessageDAO.updateReadStatus(roomId, userNumber);

		// 2. 채팅방 정보 조회
		ChatRoomResponse chatRoom = chatRoomDAO.selectChatRoomById(roomId);
		if (chatRoom == null) {
			throw new RuntimeException("존재하지 않는 채팅방입니다.");
		}

		// 3. 시스템 메시지 생성 (선택적)
//        ChatMessageResponse response = new ChatMessageResponse();
//        response.setRoomId(roomId);
//        response.setSenderNumber(0L); // 시스템 메시지
//        response.setSenderName("System");
//        response.setMessage(userNumber + "님이 입장했습니다.");
//        response.setCreatedAt(LocalDateTime.now());

//        return response;
		return null;
	}

	/**
	 * 사용자별 채팅방 목록 조회
	 */
	@Override
	public List<ChatRoomResponse> getChatRoomsByUser(Long userNumber) {
		// 1. 채팅방 목록 조회 (추가 정보 포함)
		List<Map<String, Object>> roomsWithDetails = chatRoomDAO.selectChatRoomsWithDetails(userNumber);

		System.out.println("조회된 채팅방 수: " + roomsWithDetails.size());
		for (Map<String, Object> room : roomsWithDetails) {
			System.out.println("채팅방 데이터: " + room);
		}
		List<ChatRoomResponse> result = new ArrayList<>();

		// 2. 응답 객체로 변환
		for (Map<String, Object> room : roomsWithDetails) {
			ChatRoomResponse response = new ChatRoomResponse();

			// 각 필드 설정 시 로그 추가
			System.out.println("roomId: " + room.get("roomId") + ", 타입: "
					+ (room.get("roomId") != null ? room.get("roomId").getClass().getName() : "null"));

			// null 체크를 추가하여 안전하게 변환
			if (room.get("roomId") != null) {
				response.setRoomId(((Number) room.get("roomId")).longValue());
				System.out.println("roomId 설정 완료: " + response.getRoomId());
			}

			if (room.get("postId") != null) {
				response.setPostId(((Number) room.get("postId")).longValue());
			}

			// String 타입 필드는 그대로 설정 (null이어도 괜찮음)
			response.setPostTitle((String) room.get("postTitle"));

			// 가격 정보 설정 (null 체크 추가)
			if (room.get("postPrice") != null) {
				response.setPostPrice(((Number) room.get("postPrice")).intValue());
			}

			response.setPostStatus((String) room.get("postStatus"));

			// 판매자/구매자 정보 설정 (null 체크 추가)
			if (room.get("sellerNumber") != null) {
				response.setSellerNumber(((Number) room.get("sellerNumber")).longValue());
			}

			response.setSellerName((String) room.get("sellerName"));

			if (room.get("buyerNumber") != null) {
				response.setBuyerNumber(((Number) room.get("buyerNumber")).longValue());
			}

			response.setBuyerName((String) room.get("buyerName"));

			// 날짜 정보 설정 - oracle.sql.TIMESTAMP를 LocalDateTime으로 변환
			if (room.get("createdAt") != null) {
				Object createdAtObj = room.get("createdAt");
				try {
					if (createdAtObj instanceof java.sql.Timestamp) {
						response.setCreatedAt(((java.sql.Timestamp) createdAtObj).toLocalDateTime());
					} else if (createdAtObj instanceof oracle.sql.TIMESTAMP) {
						// oracle.sql.TIMESTAMP에서 java.sql.Timestamp로 변환 후 LocalDateTime으로 변환
						java.sql.Timestamp timestamp = ((oracle.sql.TIMESTAMP) createdAtObj).timestampValue();
						response.setCreatedAt(timestamp.toLocalDateTime());
					}
				} catch (Exception e) {
					System.err.println("createdAt 변환 중 오류: " + e.getMessage());
					e.printStackTrace();
				}
			}

			// lastMessageAt 필드 처리
			if (room.get("lastMessageAt") != null) {
				Object lastMessageAtObj = room.get("lastMessageAt");
				try {
					LocalDateTime lastMsgTime = null;
					if (lastMessageAtObj instanceof java.sql.Timestamp) {
						lastMsgTime = ((java.sql.Timestamp) lastMessageAtObj).toLocalDateTime();
					} else if (lastMessageAtObj instanceof oracle.sql.TIMESTAMP) {
						java.sql.Timestamp timestamp = ((oracle.sql.TIMESTAMP) lastMessageAtObj).timestampValue();
						lastMsgTime = timestamp.toLocalDateTime();
					}

					if (lastMsgTime != null) {
						response.setLastMessageTime(lastMsgTime);
						response.setLastMessageAt(lastMsgTime);
					}
				} catch (Exception e) {
					System.err.println("lastMessageAt 변환 중 오류: " + e.getMessage());
					e.printStackTrace();
				}
			}

			// 마지막 메시지 설정
			response.setLastMessage((String) room.get("lastMessage"));

			// 읽지 않은 메시지 수 설정 (null 체크 추가)
			if (room.get("unreadCount") != null) {
				response.setUnreadCount(((Number) room.get("unreadCount")).intValue());
			} else {
				response.setUnreadCount(0); // 기본값 설정
			}

			result.add(response);
		}

		return result;
	}

	/**
	 * 메시지 읽음 상태 업데이트
	 */
	@Override
	@Transactional
	public int updateMessageReadStatus(Long roomId, Long userNumber) {
		return chatMessageDAO.updateReadStatus(roomId, userNumber);
	}

	/**
	 * 채팅방 상태 업데이트
	 */
	@Override
	@Transactional
	public boolean updateChatRoomStatus(Long roomId, String status) {
		try {
			chatRoomDAO.updateChatRoomStatus(roomId, status);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}



	/**
	 * 채팅방별 메시지 조회 - 페이징 추가
	 */
	@Override
	public List<ChatMessageResponse> getChatMessagesByRoom(Long roomId) {
		// 1. 채팅방 메시지 조회 - 최근 메시지부터 일정 개수만 조회
		List<ChatMessageResponse> messages = chatMessageDAO.selectChatMessagesByRoomId(roomId);
		List<ChatMessageResponse> result = new ArrayList<>();

		// 2. 응답 객체로 변환
		for (ChatMessageResponse message : messages) {
			ChatMessageResponse response = new ChatMessageResponse();
			response.setMessageId(message.getMessageId());
			response.setRoomId(message.getRoomId());
			response.setSenderNumber(message.getSenderNumber());

			// 발신자 정보 조회 및 설정
			if (message.getSenderName() == null || message.getSenderName().isEmpty()) {
				Map<String, Object> sender = chatRoomDAO.selectUserInfo(message.getSenderNumber());
				if (sender != null) {
					response.setSenderName((String) sender.get("userName"));
				} else {
					response.setSenderName("알 수 없음");
				}
			} else {
				response.setSenderName(message.getSenderName());
			}

			response.setMessage(message.getMessage());
			response.setReadStatus(message.getReadStatus());
			response.setCreatedAt(message.getCreatedAt());

			result.add(response);
		}

		return result;
	}
}