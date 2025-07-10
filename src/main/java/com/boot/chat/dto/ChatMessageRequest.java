package com.boot.chat.dto;

import java.time.LocalDateTime;

import lombok.Data;

//클라이언트로부터 받는 메시지
@Data
public class ChatMessageRequest {
    private Long roomId;
    private Long senderNumber;
    private String message;    // content 대신 message 필드명 사용
    private LocalDateTime createdAt; // sentAt 대신 createdAt 필드명 사용
 
}
