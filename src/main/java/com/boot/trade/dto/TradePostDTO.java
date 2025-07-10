package com.boot.trade.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TradePostDTO {
    private int postID;
    private int userNumber;
    private String userName;
    private String title;
    private String content;
    private int price;
    private String bookMajorCategory;
    private String bookSubCategory;
    private String status;
    private String location;
    private int viewCount;
    private String createdAt;
    private String updatedAt;
    private int favoriteCount;
    private int commentCount;
}