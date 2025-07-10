package com.boot.chat.dto;

import java.time.LocalDateTime;

import lombok.Data;

//클라이언트에게 보내는 메시지
@Data
public class ChatMessageResponse {
	private Long messageId;
    private Long roomId;
    private Long senderNumber;
    private Long receiverNumber;
    private String senderName; // 조인 결과를 담기 위한 필드
    private String message;
    private String readStatus;
    private LocalDateTime createdAt;
    
    /**
     * 기본 생성자
     * - 새 메시지 생성 시 기본값 설정
     */
    public ChatMessageResponse() {
        this.readStatus = "UNREAD";
        this.createdAt = LocalDateTime.now();
    }
    
    /**
     * 메시지 복사 생성자
     * - 기존 메시지 객체를 복사하여 새 DTO 생성
     */
    public ChatMessageResponse(ChatMessageResponse source) {
        this.messageId = source.messageId;
        this.roomId = source.roomId;
        this.senderNumber = source.senderNumber;
        this.receiverNumber = source.receiverNumber;
        this.senderName = source.senderName;
        this.message = source.message;
        this.readStatus = source.readStatus;
        this.createdAt = source.createdAt;
    }
}