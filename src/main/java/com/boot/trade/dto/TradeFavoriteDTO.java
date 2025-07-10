package com.boot.trade.dto;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TradeFavoriteDTO {
    private int favoriteId;
    private int userNumber;
    private int postId;
    private Date createdAt;
    
    // 거래 게시글 정보
    private String title;
    private int price;
    private String status; // AVAILABLE, RESERVED, SOLD
    private String location;
    private String bookMajorCategory;
    private String bookSubCategory;
    private String userName; // 판매자 이름
    private Date postCreatedAt; // 게시글 작성일
    private int viewCount; // 조회수
}
