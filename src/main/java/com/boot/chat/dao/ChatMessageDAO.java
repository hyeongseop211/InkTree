package com.boot.chat.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.chat.dto.ChatMessageResponse;

@Mapper
public interface ChatMessageDAO {
	// 모든 메시지 읽음 처리
	public void markAllMessagesAsRead(Long roomId, Long userNumber);

	// 특정 메시지까지 읽음 처리
	public void markMessageAsRead(Long roomId, Long messageId, Long userNumber);

	// 메시지 저장
	void insertChatMessage(ChatMessageResponse chatMessage);

	// 채팅방의 모든 메시지 조회
	List<ChatMessageResponse> selectChatMessagesByRoomId(Long roomId);

	// 메시지 읽음 상태 업데이트
	int updateReadStatus(@Param("roomId") Long roomId, @Param("userNumber") Long userNumber);

	// 읽지 않은 메시지 수 조회
	int countUnreadMessages(@Param("roomId") Long roomId, @Param("userNumber") Long userNumber);

	// 특정 채팅방의 마지막 메시지 조회
	ChatMessageResponse selectLastMessageByRoomId(Long roomId);

	// 메시지 삭제
	void deleteChatMessage(Long messageId);

	// 채팅방의 모든 메시지 삭제
	void deleteChatMessagesByRoomId(Long roomId);

	int countTotalUnreadMessagesByUser(Long userNumber);

	int countUnreadMessagesExcludeActiveRoom(@Param("userNumber") Long userNumber, @Param("activeRoomId") Long activeRoomId);
}