package com.boot.notification.controller;

import com.boot.notification.dto.NotificationDto;
import com.boot.notification.service.NotificationService;
import com.boot.user.dto.UserDTO;
import com.boot.user.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@RestController
@RequestMapping("/notifications")
@Slf4j
public class NotificationController {
    private final NotificationService notificationService;
    private final Map<Integer, List<SseEmitter>> userEmitters = new ConcurrentHashMap<>();

    @Autowired
    private UserService userService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }
    /*
     * SSE 연결 설정
     */
    @GetMapping(value = "/stream/{userNumber}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamNotifications(@PathVariable int userNumber) {
        log.info("사용자 {} SSE 연결 요청", userNumber);

        SseEmitter emitter = new SseEmitter(120_000L);

        List<SseEmitter> userEmitterList = userEmitters.computeIfAbsent(userNumber,
                k -> new CopyOnWriteArrayList<>());
        userEmitterList.add(emitter);

        emitter.onCompletion(() -> {
            userEmitterList.remove(emitter);
            log.info("사용자 {} SSE 연결 종료", userNumber);
        });

        emitter.onTimeout(() -> {
            userEmitterList.remove(emitter);
            log.info("사용자 {} SSE 연결 타임아웃", userNumber);
            emitter.complete();
        });

        emitter.onError((e) -> {
            userEmitterList.remove(emitter);
            log.error("사용자 {} SSE 연결 에러: {}", userNumber, e.getMessage());
            emitter.complete();
        });

        try {
            // 연결 확인 이벤트 전송
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("SSE 연결이 성공적으로 설정되었습니다."));

            // 미전송 알림 처리
            new Thread(() -> {
                try {
                    List<NotificationDto> notifications = notificationService.getUnsentNotifications(userNumber);

                    if (!notifications.isEmpty()) {
                        log.info("사용자 {}에게 {} 개의 미전송 알림이 있습니다", userNumber, notifications.size());

                        for (NotificationDto noti : notifications) {
                            emitter.send(SseEmitter.event()
                                    .name("notification")
                                    .data(noti));

                            notificationService.markAsSent(noti.getId());
                        }
                    }
                } catch (Exception e) {
                    log.error("미전송 알림 처리 중 오류 발생: {}", e.getMessage());
                    emitter.completeWithError(e);
                }
            }).start();

        } catch (IOException e) {
            log.error("초기 이벤트 전송 중 오류 발생: {}", e.getMessage());
            emitter.completeWithError(e);
        }

        return emitter;
    }


    /**
     * 새 알림 생성
     */
    @PostMapping
    public ResponseEntity<NotificationDto> createNotification(@RequestBody NotificationDto dto) {
        log.info("알림 생성 요청: {}", dto);
        NotificationDto createdNoti = null;
        if(dto.isToAll()) {
            List<UserDTO> users = userService.findAllUserNumber();
            for(UserDTO user : users) {
                dto.setUserNumber(user.getUserNumber());
                createdNoti =   notificationService.createDetailedNotification(dto);
            }
        }
        else {

        // 새 알림 생성
        createdNoti = notificationService.createDetailedNotification(dto);
        }

        // 연결된 클라이언트에 알림 전송
        sendToConnectedClients(createdNoti);

        return ResponseEntity.ok(createdNoti);
    }

    /**
     * 간단한 알림 생성
     */
    @PostMapping("/simple")
    public ResponseEntity<Map<String, Object>> createSimpleNotification(
            @RequestParam int userNumber,
            @RequestParam String message,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String type) {

        NotificationDto dto = new NotificationDto();
        dto.setUserNumber(userNumber);
        dto.setMessage(message);
        dto.setTitle(title != null ? title : "알림");
        dto.setType(type != null ? type : "INFO");
        dto.setSent(false);
        dto.setRead(false);
        dto.setCreatedAt(LocalDateTime.now());

        NotificationDto createdNoti = notificationService.createDetailedNotification(dto);

        // 연결된 클라이언트에 알림 전송
        sendToConnectedClients(createdNoti);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("id", createdNoti.getId());

        return ResponseEntity.ok(response);
    }

    /**
     * 알림 읽음 처리
     */
    @PostMapping("/{id}/read")
    public ResponseEntity<Map<String, Object>> markAsRead(@PathVariable int id) {
        notificationService.markAsRead(id);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);

        return ResponseEntity.ok(response);
    }

    /**
     * 모든 알림 읽음 처리
     */
    @PostMapping("/read-all/{userNumber}")
    public ResponseEntity<Map<String, Object>> markAllAsRead(@PathVariable int userNumber) {
        notificationService.markAllAsRead(userNumber);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);

        return ResponseEntity.ok(response);
    }

    /**
     * 사용자별 알림 목록 조회
     */
    @GetMapping("/user/{userNumber}")
    public ResponseEntity<List<NotificationDto>> getUserNotifications(
            @PathVariable int userNumber,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        List<NotificationDto> notifications = notificationService.getAllNotifications(userNumber, page, size);
        return ResponseEntity.ok(notifications);
    }

    /**
     * 읽지 않은 알림 수 조회
     */
    @GetMapping("/unread-count/{userNumber}")
    public ResponseEntity<Map<String, Object>> getUnreadCount(@PathVariable int userNumber) {
        int count = notificationService.countUnreadNotifications(userNumber);

        Map<String, Object> response = new HashMap<>();
        response.put("count", count);

        return ResponseEntity.ok(response);
    }

    /**
     * 알림 삭제
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteNotification(@PathVariable int id) {
        notificationService.deleteNotification(id);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);

        return ResponseEntity.ok(response);
    }


    /**
     * 연결된 클라이언트에 알림 전송
     */
    private void sendToConnectedClients(NotificationDto notification) {
        List<SseEmitter> emitters = userEmitters.get(notification.getUserNumber());
        if (emitters != null && !emitters.isEmpty()) {
            log.info("사용자 {}에게 알림 전송 시도", notification.getUserNumber());

            emitters.removeIf(emitter -> {
                try {
                    emitter.send(SseEmitter.event()
                            .name("notification")
                            .data(notification));
                    return false; // 유지
                } catch (IOException e) {
                    log.error("알림 전송 중 오류 발생: {}", e.getMessage());
                    return true; // 제거
                }
            });
        }
    }

}