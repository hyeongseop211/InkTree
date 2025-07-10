package com.boot.notification.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotificationDto {
    private int id; // 알림 ID
    private int userNumber; // 사용자 번호
    private String message; // 메시지
    private LocalDateTime createdAt; // 생성일
    private boolean sent; // 보내졌는지
    private boolean read; // 읽혔는지
    private String title; // 알림 제목
    private String url; // 알림 클릭시 연결될 URL
    private String type; // 알림 타입
    
    private boolean toAll; // 전체 알림인지
}
