package com.boot.z_page.criteria;

import lombok.Data;

@Data
public class WishlistCriteriaDTO {
    // 페이징 관련 필드
    private int page; // 게시글 페이지 번호
    private int commentPageNum; // 댓글 페이지 번호
    private int amount; // 페이지당 글 갯수
    
    // 검색 및 필터링 관련 필드
    private String type;
    private String keyword;
    private String bookMajorCategory;
    private String bookSubCategory;
    
    // 기본 생성자
    public WishlistCriteriaDTO() {
        this(1, 1, 8);
    }
    
    // 페이지와 댓글 페이지, 표시 개수 지정 생성자
    public WishlistCriteriaDTO(int page, int commentPageNum, int amount) {
        this.page = page <= 0 ? 1 : page;
        this.commentPageNum = commentPageNum <= 0 ? 1 : commentPageNum;
        this.amount = amount <= 0 ? 8 : amount;
    }
    
    // 페이지와 표시 개수만 지정하는 생성자
    public WishlistCriteriaDTO(int page, int amount) {
        this(page, 1, amount);
    }
    
    // 시작 행 계산 메서드
    public int getStartRow() {
        return (page - 1) * amount;
    }
}