<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅 - 잉크트리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/resources/css/trade_chat.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="container">
        <div class="chat-container">
            <!-- 채팅 헤더 -->
            <div class="chat-header">
<!--                <a href="trade_post_detail_view?postID=${post.postID}" class="back-link">-->
<!--                    <i class="fas fa-arrow-left"></i> 게시글로 돌아가기-->
<!--                </a>-->
                <a href="chat_list" class="back-list">
                    <i class="fas fa-arrow-left"></i> 목록
                </a>
                <div class="chat-title">
                    <c:choose>
                        <c:when test="${user.userNumber == chatRoom.buyerNumber}">
                            판매자와의 대화
                        </c:when>
                        <c:otherwise>
                            구매자와의 대화
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 게시글 정보 -->
					<a href="trade_post_detail_view?postID=${post.postID}&pageNum=1&amount=8&status=&sort=" class="back-link">
<!--			            <div class="post-info-bar">-->
			                <div class="post-thumbnail">
			                    <!-- 게시글 썸네일 이미지 -->
			                </div>
			                <div class="post-details">
			                    <div class="post-title">${post.title}</div>
									<div class="price-status-row">
									    <div class="post-price">
									        <fmt:formatNumber value="${post.price}" pattern="#,###" />원
									    </div>
									    <div class="post-status 
									        ${post.status == 'AVAILABLE' ? 'available' : post.status == 'RESERVED' ? 'reserved' : 'sold'}">
									        ${post.status == 'AVAILABLE' ? '판매중' : post.status == 'RESERVED' ? '예약중' : '판매완료'}
									    </div>
									</div>							
			                </div>
<!--			            </div>-->
					</a>
            
            <!-- 채팅 메시지 영역 -->
			<div class="chat-messages" id="chatMessages">
			    <c:set var="prevDate" value="" />
			    <c:forEach items="${messages}" var="msg">
			        <c:set var="messageDate" value="${msg.createdAt.format(DateTimeFormatter.ofPattern('yyyy-MM-dd'))}" />
			        
			        
			        <c:if test="${messageDate ne prevDate}">
			            <div class="date-divider">${messageDate}</div>
			            <c:set var="prevDate" value="${messageDate}" />
			        </c:if>
			        
			        <div class="message ${msg.senderNumber == user.userNumber ? 'my-message' : 'other-message'}" 
			             data-message-id="${msg.messageId}" 
			             data-message-date="${messageDate}">
			            <div class="message-content">${msg.message}</div>
			            <div class="message-time">
			                ${msg.createdAt.format(DateTimeFormatter.ofPattern("HH:mm"))}
			            </div>
			        </div>
			    </c:forEach>
			</div>
            
            <!-- 메시지 입력 영역 -->
            <div class="chat-input-container">
                <textarea id="messageInput" placeholder="메시지를 입력하세요..." class="chat-input"></textarea>
                <button id="sendButton" class="send-button">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>
    
    <script>
		// 현재 채팅방 ID와 사용자 번호 설정
		var currentRoomId = ${chatRoom.roomId};
		var currentUserNumber = ${user.userNumber}; // 현재 로그인한 사용자 번호
		var stompClient = null;

		// 페이지 로드 시 실행
		$(document).ready(function() {
		    // 현재 보고 있는 채팅방 정보 서버에 저장
		    setActiveRoom(currentRoomId);
		    
		    // WebSocket 연결
		    connect();
		    
		    // 채팅 영역 스크롤을 맨 아래로 이동
		    scrollToBottom();
		    
		    // 페이지를 떠날 때 활성 채팅방 정보 제거
		    $(window).on('beforeunload', function() {
		        clearActiveRoom();
		    });
		    
		    // 전송 버튼 클릭 시 메시지 전송
		    $('#sendButton').click(sendMessage);
		    
		    // 엔터키 입력 시 메시지 전송 (Shift+Enter는 줄바꿈)
		    $('#messageInput').keydown(function(e) {
		        if (e.keyCode === 13 && !e.shiftKey) {
		            e.preventDefault();
		            sendMessage();
		        }
		    });
		    
		    // 10초마다 새 메시지 확인 (WebSocket 연결 실패 시 대비)
		    setInterval(checkNewMessages, 10000);
		});

		// 현재 보고 있는 채팅방 정보 서버에 저장
		function setActiveRoom(roomId) {
		    $.ajax({
		        url: '/set_active_room',
		        type: 'POST',
		        data: {
		            roomId: roomId
		        },
		        success: function(response) {
		            console.log('활성 채팅방 설정 성공');
		            // 알림 업데이트
		            if (window.updateChatNotifications) {
		                window.updateChatNotifications();
		            }
		        },
		        error: function(error) {
		            console.error('활성 채팅방 설정 실패', error);
		        }
		    });
		}

		// 활성 채팅방 정보 제거
		function clearActiveRoom() {
		    $.ajax({
		        url: '/clear_active_room',
		        type: 'POST',
		        async: false, // 페이지 이동 전에 요청이 완료되도록 동기 요청
		        success: function(response) {
		            console.log('활성 채팅방 정보 제거 성공');
		        },
		        error: function(error) {
		            console.error('활성 채팅방 정보 제거 실패', error);
		        }
		    });
		}

		// 모든 메시지 읽음 처리 함수
		function markAllMessagesAsRead() {
		    $.ajax({
		        url: '/mark_all_messages_read',
		        type: 'POST',
		        data: {
		            roomId: currentRoomId,
		            userNumber: currentUserNumber
		        },
		        success: function(response) {
		            console.log('모든 메시지 읽음 처리 성공');
		            // 알림 업데이트
		            if (window.updateChatNotifications) {
		                window.updateChatNotifications();
		            }
		        },
		        error: function(error) {
		            console.error('모든 메시지 읽음 처리 실패', error);
		        }
		    });
		}

		// 특정 메시지 읽음 처리 함수
		function markMessageAsRead(messageId) {
		    $.ajax({
		        url: '/mark_message_read',
		        type: 'POST',
		        data: {
		            roomId: currentRoomId,
		            messageId: messageId,
		            userNumber: currentUserNumber
		        },
		        success: function(response) {
		            console.log('메시지 읽음 처리 성공');
		            // 알림 업데이트
		            if (window.updateChatNotifications) {
		                window.updateChatNotifications();
		            }
		        },
		        error: function(error) {
		            console.error('메시지 읽음 처리 실패', error);
		        }
		    });
		}

		// 스크롤을 맨 아래로 이동하는 함수
		function scrollToBottom() {
		    var chatMessages = $('.chat-messages');
		    chatMessages.scrollTop(chatMessages[0].scrollHeight);
		}

		// 페이지 가시성 변경 감지 (탭 전환 등)
		document.addEventListener('visibilitychange', function() {
		    if (!document.hidden) {
		        // 페이지가 다시 보이게 되면 모든 메시지 읽음 처리
		        markAllMessagesAsRead();
		    }
		});

		// WebSocket 연결
		function connect() {
		    console.log('WebSocket 연결 시도...');
		    const socket = new SockJS('/ws-chat');
		    stompClient = Stomp.over(socket);
		    
		    // 디버깅을 위한 로그 활성화
		    stompClient.debug = function(str) {
		        console.log('STOMP: ' + str);
		    };
		    
		    stompClient.connect({}, function(frame) {
		        console.log('WebSocket 연결 성공: ' + frame);
		        
		        // 채팅방에 들어왔을 때 모든 메시지 읽음 처리
		        markAllMessagesAsRead();
		        
		        // 채팅방 구독
		        stompClient.subscribe('/topic/room/' + currentRoomId, function(message) {
		            console.log('채팅방 메시지 수신:', message);
		            try {
		                const messageData = JSON.parse(message.body);
		                console.log('파싱된 메시지 데이터:', messageData);
		                displayMessage(messageData);
		                
		                // 내가 보낸 메시지가 아닌 경우에만 읽음 처리
		                if (messageData.senderNumber != currentUserNumber) {
		                    // 새 메시지 즉시 읽음 처리
		                    markMessageAsRead(messageData.messageId);
		                }
		            } catch (e) {
		                console.error('메시지 파싱 오류:', e);
		                console.log('원본 메시지:', message.body);
		            }
		        });
		        
		        // 개인 메시지 구독
		        stompClient.subscribe('/user/' + currentUserNumber + '/queue/messages', function(message) {
		            console.log('개인 메시지 수신:', message);
		            try {
		                const messageData = JSON.parse(message.body);
		                console.log('파싱된 메시지 데이터:', messageData);
		                displayMessage(messageData);
		                
		                // 내가 보낸 메시지가 아닌 경우에만 읽음 처리
		                if (messageData.senderNumber != currentUserNumber) {
		                    // 새 메시지 즉시 읽음 처리
		                    markMessageAsRead(messageData.messageId);
		                }
		            } catch (e) {
		                console.error('메시지 파싱 오류:', e);
		                console.log('원본 메시지:', message.body);
		            }
		        });
		        
		        // 채팅방 입장 메시지 전송
		        joinRoom();
		        
		    }, function(error) {
		        // 연결 오류 처리
		        console.error('WebSocket 연결 오류:', error);
		        alert('실시간 채팅 연결에 실패했습니다. 페이지를 새로고침하거나 나중에 다시 시도해주세요.');
		    });
		}

		// 채팅방 입장
		function joinRoom() {
		    if (stompClient && stompClient.connected) {
		        stompClient.send("/app/chat.join/" + currentRoomId, {}, JSON.stringify({
		            senderNumber: currentUserNumber,
		            message: "입장했습니다."
		        }));
		    }
		}

		// 날짜 포맷팅 함수
		/*function formatDateTime(date) {
		    const year = date.getFullYear();
		    const month = String(date.getMonth() + 1).padStart(2, '0');
		    const day = String(date.getDate()).padStart(2, '0');
		    const hours = String(date.getHours()).padStart(2, '0');
		    const minutes = String(date.getMinutes()).padStart(2, '0');
		    
		    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
		}*/
		function formatDate(date) {
		    const year = date.getFullYear();
		    const month = String(date.getMonth() + 1).padStart(2, '0');
		    const day = String(date.getDate()).padStart(2, '0');
		    
		    return year + '-' + month + '-' + day;
		}
		// 시간 포맷팅 함수 - 시간만 반환 (HH:MM)
		function formatTime(date) {
		    const hours = String(date.getHours()).padStart(2, '0');
		    const minutes = String(date.getMinutes()).padStart(2, '0');
		    
		    return hours + ':' + minutes;
		}

		// 메시지 표시 함수 수정
		function displayMessage(messageData) {
		    // 메시지 ID가 없는 경우 처리
		    if (!messageData.messageId) {
		        console.error('메시지 ID가 없습니다:', messageData);
		        // 임시 ID 생성
		        messageData.messageId = 'temp-' + new Date().getTime();
		    }
		    
		    // 이미 표시된 메시지는 건너뛰기
		    if (isMessageDisplayed(messageData.messageId)) {
		        console.log('이미 표시된 메시지:', messageData.messageId);
		        return;
		    }
		    
		    console.log('새 메시지 표시:', messageData.messageId);
		    
		    // 메시지 표시
		    const messageClass = messageData.senderNumber == currentUserNumber ? 'my-message' : 'other-message';
		    const messageTime = messageData.createdAt ? new Date(messageData.createdAt) : new Date();
		    const messageDate = formatDate(messageTime);
		    
		    // 날짜 구분선이 필요한지 확인
		    const needDateDivider = checkIfNeedDateDivider(messageDate);
		    
		    // 날짜 구분선이 필요하면 추가
		    if (needDateDivider) {
		        const dateDividerHtml = '<div class="date-divider">' + messageDate + '</div>';
		        $('#chatMessages').append(dateDividerHtml);
		    }
		    
		    // 메시지 HTML 생성
		    const messageHtml = 
		        '<div class="message ' + messageClass + '" data-message-id="' + messageData.messageId + '" data-message-date="' + messageDate + '">' +
		        '<div class="message-content">' + messageData.message + '</div>' +
		        '<div class="message-time">' + formatTime(messageTime) + '</div>' +
		        '</div>';
		    
		    $('#chatMessages').append(messageHtml);
		    scrollToBottom();
		    
		    // 내가 보낸 메시지가 아닌 경우 읽음 처리
		    if (messageData.senderNumber != currentUserNumber) {
		        markMessageAsRead(messageData.messageId);
		    }
		}
		
		// 날짜 구분선이 필요한지 확인하는 함수
		function checkIfNeedDateDivider(messageDate) {
		    // 첫 번째 메시지인 경우
		    if ($('.message').length === 0) {
		        return true;
		    }
		    
		    // 마지막 메시지의 날짜 가져오기
		    const lastMessageDate = $('.message').last().data('message-date');
		    
		    // 날짜가 다르면 구분선 필요
		    return lastMessageDate !== messageDate;
		}
		
		// 메시지가 이미 표시되었는지 확인
		function isMessageDisplayed(messageId) {
		    return $('.message[data-message-id="' + messageId + '"]').length > 0;
		}

		// 메시지 전송 함수
		function sendMessage() {
		    const messageInput = $('#messageInput');
		    const message = messageInput.val().trim();
		    
		    if (message !== '') {
		        // WebSocket을 통해 메시지 전송
		        if (stompClient && stompClient.connected) {
		            stompClient.send("/app/chat.sendMessage/" + currentRoomId, {}, JSON.stringify({
		                senderNumber: currentUserNumber,
		                message: message
		            }));
		            
		            // 입력창 비우기
		            messageInput.val('');
		        } else {
		            // WebSocket 연결이 없는 경우 AJAX로 대체
		            $.ajax({
		                type: 'POST',
		                url: 'send_message',
		                data: {
		                    roomId: currentRoomId,
		                    content: message
		                },
		                success: function(response) {
		                    if (response.success) {
		                        // 메시지 추가
		                        const messageHtml = 
		                            '<div class="message my-message" data-message-id="' + response.message.messageId + '">' +
		                            '<div class="message-content">' + message + '</div>' +
		                            '<div class="message-time">' + formatDateTime(new Date()) + '</div>' +
		                            '</div>';
		                        
		                        $('#chatMessages').append(messageHtml);
		                        
		                        // 입력창 비우기 및 스크롤 아래로
		                        messageInput.val('');
		                        scrollToBottom();
		                    } else {
		                        alert('메시지 전송에 실패했습니다: ' + response.message);
		                    }
		                },
		                error: function() {
		                    alert('메시지 전송 중 오류가 발생했습니다.');
		                }
		            });
		        }
		    }
		}

		// 새 메시지 처리 함수
		function handleNewMessage(message) {
		    // 메시지 표시
		    displayMessage(message);
		    
		    // 내가 보낸 메시지가 아닌 경우에만 읽음 처리
		    if (message.senderNumber != currentUserNumber) {
		        // 새 메시지 즉시 읽음 처리
		        markMessageAsRead(message.messageId);
		    }
		    
		    // 스크롤을 맨 아래로 이동
		    scrollToBottom();
		}

		// 주기적으로 새 메시지 확인 (WebSocket 연결 실패 시 대비)
		function checkNewMessages() {
		    if (!stompClient || !stompClient.connected) {
		        $.ajax({
		            type: 'GET',
		            url: 'get_new_messages',
		            data: {
		                roomId: currentRoomId,
		                lastMessageId: getLastMessageId()
		            },
		            success: function(response) {
		                if (response.success && response.messages.length > 0) {
		                    // 새 메시지 추가
		                    response.messages.forEach(function(msg) {
		                        // 이미 표시된 메시지는 건너뛰기
		                        if (!isMessageDisplayed(msg.messageId)) {
		                            // 메시지 시간 및 날짜 처리
		                            const messageTime = new Date(msg.createdAt);
		                            const messageDate = formatDate(messageTime);
		                            
		                            // 날짜 구분선이 필요한지 확인
		                            const needDateDivider = checkIfNeedDateDivider(messageDate);
		                            
		                            // 날짜 구분선이 필요하면 추가
		                            if (needDateDivider) {
		                                const dateDividerHtml = '<div class="date-divider">' + messageDate + '</div>';
		                                $('#chatMessages').append(dateDividerHtml);
		                            }
		                            
		                            // 메시지 클래스 결정
		                            const messageClass = msg.senderNumber == currentUserNumber ? 'my-message' : 'other-message';
		                            const messageHtml = 
		                                '<div class="message ' + messageClass + '" data-message-id="' + msg.messageId + '" data-message-date="' + messageDate + '">' +
		                                '<div class="message-content">' + msg.message + '</div>' +
		                                '<div class="message-time">' + formatTime(messageTime) + '</div>' +
		                                '</div>';
		                            $('#chatMessages').append(messageHtml);
		                            
		                            // 내가 보낸 메시지가 아닌 경우 읽음 처리
		                            if (msg.senderNumber != currentUserNumber) {
		                                markMessageAsRead(msg.messageId);
		                            }
		                        }
		                    });
		                    
		                    // 스크롤 아래로
		                    scrollToBottom();
		                }
		            }
		        });
		    }
		}

		// 마지막 메시지 ID 가져오기
		function getLastMessageId() {
		    const lastMessage = $('.message').last().data('message-id');
		    return lastMessage || 0;
		}
    </script>
</body>
</html>