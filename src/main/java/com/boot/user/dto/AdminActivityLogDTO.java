package com.boot.user.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdminActivityLogDTO {
    private int logId;                 // 로그 ID
    private String activityType;       // 활동 유형 (book_add, user_add, book_borrow, notice_add, book_return, notice_delete, book_delete)
    private String actorType;          // 수행자 유형 (admin or user)
    private int actorId;               // 수행자 ID
    private String actorName;          // 수행자 이름
    private String targetName;         // 대상 이름 (책 제목, 회원 이름 등)
    private String description;        // 활동 설명
    private LocalDateTime logDate;     // 로그 생성 시간
} 