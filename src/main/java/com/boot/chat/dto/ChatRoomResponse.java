package com.boot.chat.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class ChatRoomResponse {
	// 기본 채팅방 정보 (DB 매핑)
    private Long roomId = 0L;
    private Long postId = 0L;
    private Long sellerNumber = 0L;
    private Long buyerNumber = 0L;
    private LocalDateTime createdAt;
    private LocalDateTime lastMessageAt;
    private String status = "";
    
    // 확장 정보 (조회 결과 및 응답용)
    private String postTitle = "";
    private int postPrice = 0;
    private String postStatus = "";
    private String sellerName = "";
    private String buyerName = "";
    private LocalDateTime lastMessageTime;
    private String lastMessage = "";
    private int unreadCount = 0;
    
    /**
     * 기본 생성자
     */
    public ChatRoomResponse() {
        this.createdAt = LocalDateTime.now();
    }
    
    /**
     * lastMessageTime이 설정될 때 lastMessageAt도 같은 값으로 설정
     * @param lastMessageTime 마지막 메시지 시간
     */
    public void setLastMessageTime(LocalDateTime lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
        this.lastMessageAt = lastMessageTime; // 동기화
    }
    
    /**
     * 현재 사용자가 판매자인지 확인
     * @param userNumber 사용자 번호
     * @return 판매자인 경우 true, 아니면 false
     */
    public boolean isSeller(Long userNumber) {
        return sellerNumber != null && sellerNumber.equals(userNumber);
    }
    
    /**
     * 상대방 이름 조회
     * @param userNumber 현재 사용자 번호
     * @return 상대방 이름
     */
    public String getPartnerName(Long userNumber) {
        return isSeller(userNumber) ? buyerName : sellerName;
    }
    
    /**
     * 상대방 번호 조회
     * @param userNumber 현재 사용자 번호
     * @return 상대방 번호
     */
    public Long getPartnerNumber(Long userNumber) {
        return isSeller(userNumber) ? buyerNumber : sellerNumber;
    }
}