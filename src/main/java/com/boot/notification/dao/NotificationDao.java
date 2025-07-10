package com.boot.notification.dao;

import com.boot.notification.dto.NotificationDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NotificationDao {
    // 시퀀스에서 다음 ID 조회
    int getNextId();

    // 알림 삽입
    void insertNotification(NotificationDto notification);

    // 특정 사용자의 미전송 알림 조회
    List<NotificationDto> selectUnsentByUserNumber(int userNumber);

    // 특정 사용자의 모든 알림 조회 (페이지네이션)
    List<NotificationDto> selectAllByUserNumber(@Param("userNumber") int userNumber,
                                                @Param("offset") int offset,
                                                @Param("limit") int limit);

    // 특정 사용자의 읽지 않은 알림 수 조회
    int countUnreadByUserNumber(int userNumber);

    // 특정 알림 상세 조회
    NotificationDto selectNotificationById(int id);

    // 알림을 보낸 상태로 변경
    void markAsSent(int id);

    // 알림을 읽음 상태로 변경
    void markAsRead(int id);

    // 알림 타입별 조회
    List<NotificationDto> selectByUserNumberAndType(@Param("userNumber") int userNumber,
                                                    @Param("type") String type);

    // 알림 제목으로 검색
    List<NotificationDto> searchByTitle(@Param("userNumber") int userNumber,
                                        @Param("keyword") String keyword);

    // 특정 사용자의 알림 모두 읽음 처리
    void markAllAsRead(int userNumber);

    // 오래된 알림 삭제 (특정 날짜 이전)
    void deleteOldNotifications(@Param("days") int days);

    // 완전히 삭제
    void deleteNotification(int id);


}
