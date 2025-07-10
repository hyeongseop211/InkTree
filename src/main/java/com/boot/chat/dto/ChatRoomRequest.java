package com.boot.chat.dto;

import lombok.Data;

@Data
public class ChatRoomRequest {
    private Long postId;
    private Long sellerNumber;
    private Long buyerNumber;
    private String postTitle;
}