package com.boot.chat.dao;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.chat.dto.ChatRoomResponse;


@Mapper
public interface ChatRoomDAO {

	// 채팅방 생성
	void insertChatRoom(ChatRoomResponse chatRoom);

	// 채팅방 조회
	ChatRoomResponse selectChatRoomById(Long roomId);

	// 특정 사용자의 모든 채팅방 조회
	List<ChatRoomResponse> selectChatRoomsByUser(Long userNumber);

	// 특정 게시글과 사용자 간의 채팅방 조회
	ChatRoomResponse selectChatRoomByPostAndUsers(@Param("postId") Long postId, @Param("sellerNumber") Long sellerNumber,
			@Param("buyerNumber") Long buyerNumber);

	// 채팅방 마지막 메시지 시간 업데이트
	void updateLastMessageAt(@Param("roomId") Long roomId, @Param("lastMessageAt") LocalDateTime lastMessageAt);

	// 채팅방 상태 업데이트
	void updateChatRoomStatus(@Param("roomId") Long roomId, @Param("status") String status);

	// 채팅방 삭제
	void deleteChatRoom(Long roomId);

	// 채팅방 목록 조회 (추가 정보 포함)
	List<Map<String, Object>> selectChatRoomsWithDetails(Long userNumber);

	Map<String, Object> selectUserInfo(Long userNumber);
}