package com.boot.chat.service;

import java.util.List;

import com.boot.chat.dto.ChatMessageRequest;
import com.boot.chat.dto.ChatMessageResponse;
import com.boot.chat.dto.ChatRoomRequest;
import com.boot.chat.dto.ChatRoomResponse;

/**
 * 채팅 관련 기능을 제공하는 서비스 인터페이스
 */
public interface ChatService {
	// 모든 메시지 읽음 처리
	public void markAllMessagesAsRead(Long roomId, Long userNumber);

	// 특정 메시지까지 읽음 처리
	public void markMessageAsRead(Long roomId, Long messageId, Long userNumber);

	/**
	 * 메시지를 저장하고 상대방에게 전송
	 * 
	 * @param request 메시지 요청 객체
	 * @return 저장된 메시지 응답 객체
	 */
	ChatMessageResponse saveAndSendMessage(ChatMessageRequest request);

	/**
	 * 채팅방 생성
	 * 
	 * @param request 채팅방 생성 요청 객체
	 * @return 생성된 채팅방 객체
	 */
	ChatRoomResponse createChatRoom(ChatRoomRequest request);

	/**
	 * 채팅방 입장 처리
	 * 
	 * @param roomId     채팅방 ID
	 * @param userNumber 사용자 번호
	 * @return 입장 메시지 응답 객체
	 */
	ChatMessageResponse joinChatRoom(Long roomId, Long userNumber);

	int countTotalUnreadMessagesByUser(Long userNumber);

	/**
	 * 사용자별 채팅방 목록 조회
	 * 
	 * @param userNumber 사용자 번호
	 * @return 채팅방 목록
	 */
	List<ChatRoomResponse> getChatRoomsByUser(Long userNumber);

	/**
	 * 채팅방별 메시지 조회
	 * 
	 * @param roomId 채팅방 ID
	 * @return 메시지 목록
	 */
	List<ChatMessageResponse> getChatMessagesByRoom(Long roomId);

	/**
	 * 메시지 읽음 상태 업데이트
	 * 
	 * @param roomId     채팅방 ID
	 * @param userNumber 사용자 번호
	 * @return 업데이트된 메시지 수
	 */
	int updateMessageReadStatus(Long roomId, Long userNumber);

	/**
	 * 채팅방 상태 업데이트
	 * 
	 * @param roomId 채팅방 ID
	 * @param status 변경할 상태
	 * @return 업데이트 성공 여부
	 */
	boolean updateChatRoomStatus(Long roomId, String status);

	public int countUnreadMessagesExcludeActiveRoom(Long userNumber, Long activeRoomId);
}