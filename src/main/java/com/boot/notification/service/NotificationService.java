package com.boot.notification.service;

import com.boot.notification.dao.NotificationDao;
import com.boot.notification.dto.NotificationDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
public class NotificationService {
	private final NotificationDao notificationDao;

	public NotificationService(NotificationDao notificationDao) {
		this.notificationDao = notificationDao;
	}

	/**
	 * 새 알림 생성 (기본)
	 */
	@Transactional
	public void createNotification(int userNumber, String message) {
		int id = notificationDao.getNextId();
		NotificationDto dto = new NotificationDto();
		dto.setId(id);
		dto.setUserNumber(userNumber);
		dto.setMessage(message);
		dto.setSent(false);
		dto.setRead(false);
		dto.setType("INFO");
		dto.setTitle("알림");

		notificationDao.insertNotification(dto);
		log.info("알림 생성: 사용자={}, 메시지={}, ID={}", userNumber, message, id);
	}

	/**
	 * 새 알림 생성 (상세)
	 */
	@Transactional
	public NotificationDto createDetailedNotification(NotificationDto dto) {
		int id = notificationDao.getNextId();
		dto.setId(id);

		// 기본값 설정
		if (dto.getCreatedAt() == null) {
			dto.setCreatedAt(LocalDateTime.now());
		}

		if (dto.getType() == null || dto.getType().isEmpty()) {
			dto.setType("INFO");
		}

		notificationDao.insertNotification(dto);
		log.info("상세 알림 생성: 사용자={}, 제목={}, ID={}", dto.getUserNumber(), dto.getTitle(), id);

		return dto;
	}

	/**
	 * 사용자별 미전송 알림 조회
	 */
	public List<NotificationDto> getUnsentNotifications(int userNumber) {
		List<NotificationDto> notifications = notificationDao.selectUnsentByUserNumber(userNumber);
		log.info("미전송 알림 조회: 사용자={}, 개수={}", userNumber, notifications.size());
		return notifications;
	}

	/**
	 * 사용자별 모든 알림 조회 (페이지네이션)
	 */
	public List<NotificationDto> getAllNotifications(int userNumber, int page, int size) {
		int offset = (page - 1) * size;
		return notificationDao.selectAllByUserNumber(userNumber, offset, size);
	}

	/**
	 * 읽지 않은 알림 수 조회
	 */
	public int countUnreadNotifications(int userNumber) {
		return notificationDao.countUnreadByUserNumber(userNumber);
	}

	/**
	 * 특정 알림 조회
	 */
	public NotificationDto getNotificationById(int id) {
		return notificationDao.selectNotificationById(id);
	}

	/**
	 * 알림 전송 상태로 변경
	 */
	@Transactional
	public void markAsSent(int id) {
		notificationDao.markAsSent(id);
		log.info("알림 전송 상태 변경: ID={}", id);
	}

	/**
	 * 알림 읽음 상태로 변경
	 */
	@Transactional
	public void markAsRead(int id) {
		notificationDao.markAsRead(id);
		log.info("알림 읽음 상태 변경: ID={}", id);
	}

	/**
	 * 타입별 알림 조회
	 */
	public List<NotificationDto> getNotificationsByType(int userNumber, String type) {
		return notificationDao.selectByUserNumberAndType(userNumber, type);
	}

	/**
	 * 제목으로 알림 검색
	 */
	public List<NotificationDto> searchNotifications(int userNumber, String keyword) {
		return notificationDao.searchByTitle(userNumber, keyword);
	}

	/**
	 * 모든 알림 읽음 처리
	 */
	@Transactional
	public void markAllAsRead(int userNumber) {
		notificationDao.markAllAsRead(userNumber);
		log.info("모든 알림 읽음 처리: 사용자={}", userNumber);
	}

	/**
	 * 오래된 알림 삭제 (특정 일수 이전)
	 */
	@Transactional
	public void cleanupOldNotifications(int days) {
		notificationDao.deleteOldNotifications(days);
		log.info("{}일 이전 알림 삭제 완료", days);
	}

	/**
	 * 알림 삭제
	 */
	@Transactional
	public void deleteNotification(int id) {
		notificationDao.deleteNotification(id);
		log.info("알림 삭제: ID={}", id);
	}

}