package com.boot.z_page.criteria;

import lombok.Data;

@Data
public class AdminActivityLogCriteriaDTO {
    private int pageNum; // 페이지 번호
    private int amount; // 페이지당 로그 갯수
    private String activityType; // 정확한 활동 유형
    private String categoryFilter; // 카테고리 필터 (book, user, notice 등)
    private String actorType; // 수행자 유형 필터

    public AdminActivityLogCriteriaDTO() {
        this(1, 10);
    }

    public AdminActivityLogCriteriaDTO(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }
} 