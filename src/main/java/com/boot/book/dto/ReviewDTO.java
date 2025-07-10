package com.boot.book.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewDTO {
	private int reviewId;           // 리뷰 ID
    private int bookNumber;         // 도서 번호
    private int userNumber;         // 사용자 번호
    private String reviewTitle;     // 리뷰 제목
    private String reviewContent;   // 리뷰 내용
    private int reviewRating;       // 리뷰 평점
    private Date reviewDate;        // 리뷰 작성일
    private Date reviewModifiedDate; // 리뷰 수정일
    private String reviewStatus;    // 리뷰 상태
    
    // 추가 필드 - 화면 표시용
    private String userName;        // 사용자 이름
    private boolean helpfulByCurrentUser; // 현재 사용자가 도움됨 표시했는지 여부
    private int helpfulCount;       // 도움됨 수
    
}
