package com.boot.book.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewHelpfulDTO {
    private int helpfulId;
    private int reviewId;
    private int userNumber;
    private Date helpfulDate;
}