package com.boot.book.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewStatsDTO {
    private int totalReviews;
    private double averageRating;
    
    private int fiveStarPercentage;
    private int fourStarPercentage;
    private int threeStarPercentage;
    private int twoStarPercentage;
    private int oneStarPercentage;
    
    private int fiveStarCount;
    private int fourStarCount;
    private int threeStarCount;
    private int twoStarCount;
    private int oneStarCount;
}