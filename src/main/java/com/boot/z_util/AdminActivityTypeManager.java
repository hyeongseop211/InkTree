package com.boot.z_util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

public class AdminActivityTypeManager {
    private static final Map<String, ActivityTypeInfo> typeInfoMap = new HashMap<>();
    private static final List<FilterOption> filterOptions = new ArrayList<>();
    
    static {
        // 공지사항 관련 액티비티
        registerType("notice_add", "공지사항 등록", "ri-notification-line", "notice");
        registerType("notice_modify", "공지사항 수정", "ri-edit-line", "notice");
        registerType("notice_delete", "공지사항 삭제", "ri-delete-bin-line", "notice");
        
        // 관리자 도서 관련 액티비티
        registerType("book_add", "도서 등록", "ri-book-open-line", "admin_book");
        registerType("book_modify", "도서 수정", "ri-edit-line", "admin_book");
        registerType("book_delete", "도서 삭제", "ri-delete-bin-line", "admin_book");
        
        // 회원 도서 관련 액티비티
        registerType("book_borrow", "도서 대출", "ri-bookmark-line", "user_book");
        registerType("book_return", "도서 반납", "ri-book-read-line", "user_book");
        
        // 회원 관련 액티비티
        registerType("user_add", "회원 가입", "ri-user-add-line", "user");
        registerType("user_modify", "회원 정보 수정", "ri-user-settings-line", "user");
        
        // 기타 액티비티
        // registerType("trade_post_add", "거래 게시글 등록", "ri-file-text-line", "trade_post");
        
        // 필터 옵션 등록
        addFilterOption("all", "전체", null, null);
        addFilterOption("notice", "공지사항 관련", "notice", null);
        addFilterOption("admin_book", "관리자 도서 관련", "admin_book", null);
        addFilterOption("user_book", "회원 도서 관련", "user_book", null);
        addFilterOption("user", "회원 관련", "user", null);
        // addFilterOption("trade", "거래 관련", "trade_post", null);
    }
    
    
    private static void registerType(String code, String displayName, String iconClass, String category) {
        typeInfoMap.put(code, new ActivityTypeInfo(code, displayName, iconClass, category));
    }
    
    private static void addFilterOption(String code, String displayName, String categoryFilter, String actorFilter) {
        filterOptions.add(new FilterOption(code, displayName, categoryFilter, actorFilter));
    }
    
    public static ActivityTypeInfo getTypeInfo(String typeCode) {
        return typeInfoMap.getOrDefault(typeCode, 
                new ActivityTypeInfo(typeCode, "기타 활동", "ri-information-line", "other"));
    }
    
    public static List<FilterOption> getFilterOptions() {
        return filterOptions;
    }
    
    // 액티비티 타입 정보 클래스
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class ActivityTypeInfo {
        private String code;
        private String displayName;
        private String iconClass;
        private String category;
    }
    
    // 필터 옵션 클래스
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class FilterOption {
        private String code;
        private String displayName;
        private String categoryFilter;
        private String actorFilter;
    }
} 