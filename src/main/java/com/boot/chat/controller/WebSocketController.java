package com.boot.chat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import com.boot.chat.dto.ChatMessageRequest;
import com.boot.chat.dto.ChatMessageResponse;
import com.boot.chat.service.ChatService;

@Controller
public class WebSocketController {

    @Autowired
    private ChatService chatService;

    @MessageMapping("/chat.sendMessage/{roomId}")
    @SendTo("/topic/room/{roomId}")
    public ChatMessageResponse sendMessage(@DestinationVariable Long roomId, 
                                          @Payload ChatMessageRequest chatMessageRequest,
                                          SimpMessageHeaderAccessor headerAccessor) {
        // 메시지 저장 및 처리
        chatMessageRequest.setRoomId(roomId);
        return chatService.saveAndSendMessage(chatMessageRequest);
    }

    @MessageMapping("/chat.join/{roomId}")
    @SendTo("/topic/room/{roomId}")
    public ChatMessageResponse joinRoom(@DestinationVariable Long roomId,
                                       @Payload ChatMessageRequest chatMessageRequest,
                                       SimpMessageHeaderAccessor headerAccessor) {
        // 사용자 정보를 WebSocket 세션에 저장
        headerAccessor.getSessionAttributes().put("username", chatMessageRequest.getSenderNumber());
        headerAccessor.getSessionAttributes().put("roomId", roomId);
        
        // 채팅방 입장 처리
        return chatService.joinChatRoom(roomId, chatMessageRequest.getSenderNumber());
    }
}