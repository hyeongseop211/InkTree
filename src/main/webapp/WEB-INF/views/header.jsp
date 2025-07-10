<%@page import="com.boot.user.dto.UserDTO" %>
<%@page import="com.boot.notification.dto.NotificationDto" %>
<%@page import="com.boot.notification.service.NotificationService" %>
<%@page import="org.springframework.web.context.WebApplicationContext" %>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@page import="java.util.List" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.LocalDateTime" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>잉크트리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/resources/css/header.css">
    <script>
        window.addEventListener("unload", function() {
            navigator.sendBeacon("/disconnect");
        });
    </script>
</head>
<body>
<%
    UserDTO user = (UserDTO) session.getAttribute("loginUser");
    String currentPage = request.getRequestURI();
    // Spring의 NotificationService를 가져오기 위한 코드
    WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    NotificationService notificationService = context.getBean(NotificationService.class);

    // 사용자별 알림 데이터와 읽지 않은 알림 개수
    List<NotificationDto> notifications = null;
    int unreadCount = 0;

    if (user != null) {
        // 실제 DB에서 사용자 알림 데이터 가져오기
        notifications = notificationService.getAllNotifications(user.getUserNumber(), 1, 10);
        // 읽지 않은 알림 개수 가져오기
        unreadCount = notificationService.countUnreadNotifications(user.getUserNumber());
    }

    // 날짜 포맷팅 함수
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    DateTimeFormatter todayFormatter = DateTimeFormatter.ofPattern("HH:mm");

    // 오늘 날짜
    LocalDateTime today = LocalDateTime.now();

%>
<c:set var="currentPage" value="${requestScope['javax.servlet.forward.request_uri']}" />

    <header class="top-header">
        <div class="header-container">
            <div class="logo-section">
                <a href="/" class="logo-link">
                    <div class="logo-icon">
                        <i class="fa-solid fa-book-open"></i>
                    </div>
                    <span class="logo-text">잉크트리</span>
                </a>
            </div>

            <nav class="nav-links" id="navLinks">
				<a href="/" class="nav-link ${currentPage == '/' ? 'active' : ''}">
				    <i class="nav-icon fa-solid fa-house"></i>
				    <span>메인</span>
				</a>
                <a href="/admin_notice" class="nav-link ${currentPage == '/admin_notice' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-bullhorn"></i>
                    <span>공지사항</span>
                </a>
                <a href="/board_view" class="nav-link ${currentPage == '/board_view' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-clipboard-list"></i>
                    <span>게시판</span>
                </a>
                <a href="/trade_post_view" class="nav-link ${currentPage == '/trade_post_view' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-cart-shopping"></i>
                    <span>거래게시판</span>
                </a>
                <!-- 상단 채팅 메뉴 제거 - 하단 오른쪽 버튼으로 통합 -->
            </nav>

            <div class="user-menu">
				<c:choose>
				    <c:when test="${user != null}">

                <!-- 알림 드롭다운 추가 -->
                <div class="notification-dropdown" id="notificationDropdown">
                    <div class="notification-icon" id="notificationToggle">
                        <i class="fa-solid fa-bell"></i>
                        <% if (unreadCount > 0) { %>
                        <span class="notification-badge"><%=unreadCount%></span>
                        <% } %>
                    </div>


                    <div class="notification-menu">
                        <div class="notification-header">
                            <h3>알림</h3>
                        </div>
                        <div class="notification-list">
                            <% if (notifications == null || notifications.isEmpty()) { %>
                            <div class="no-notifications">
                                새로운 알림이 없습니다.
                            </div>
                            <% } else { %>
                            <% for (NotificationDto notification : notifications) {
                                // 날짜 포맷팅 - 오늘이면 시간만, 아니면 날짜와 시간
                                String formattedDate;
                                if (notification.getCreatedAt().toLocalDate().equals(today.toLocalDate())) {
                                    formattedDate = "오늘 " + notification.getCreatedAt().format(todayFormatter);
                                } else {
                                    formattedDate = notification.getCreatedAt().format(formatter);
                                }
                            %>
                            <div class="notification-item <%= notification.isRead() ? "read" : "unread" %>"
                                 data-id="<%= notification.getId() %>"
                                 data-url="<%= notification.getUrl() != null ? notification.getUrl() : "" %>"
                                 data-type="<%= notification.getType() %>">
                                <div class="notification-icon-wrapper">
                                    <% if ("BOOK_RETURN".equals(notification.getType())) { %>
                                    <i class="fa-solid fa-book"></i>
                                    <% } else if ("BOOK_BORROW".equals(notification.getType())) { %>
                                    <i class="fa-solid fa-book-open-reader"></i>
                                    <% } else if ("NOTICE".equals(notification.getType())) { %>
                                    <i class="fa-solid fa-bullhorn"></i>
                                    <% } else if ("COMMENT".equals(notification.getType())) { %>
                                    <i class="fa-solid fa-comment"></i>
                                    <% } else { %>
                                    <i class="fa-solid fa-bell"></i>
                                    <% } %>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title"><%= notification.getTitle() %></div>
                                    <div class="notification-message"><%= notification.getMessage() %></div>
                                    <div class="notification-time"><%= formattedDate %></div>
                                </div>
                            </div>
                            <% } %>
                            <% } %>
                        </div>
                        <div class="notification-footer">
                            <button class="mark-all-read" id="markAllAsRead">
                                <i class="fa-solid fa-check-double"></i> 모두 읽음
                            </button>
                        </div>
                    </div>
                </div>

                <div class="user-dropdown" id="userDropdown">
					<button class="dropdown-toggle" id="dropdownToggle">
					    <div class="user-avatar">
					        ${fn:substring(user.userName, 0, 1)}
					    </div>
					    <span class="user-name">${user.userName} 님</span>
					    <span class="toggle-icon"><i class="fa-solid fa-chevron-down"></i></span>
					</button>
                    <div class="dropdown-menu">
						<div class="dropdown-header">
						    <div class="dropdown-header-bg"></div>
						    <div class="dropdown-header-content">
						        <div class="user-avatar large">
						            ${fn:substring(user.userName, 0, 1)}
						        </div>
						        <div class="header-info">
						            <div class="header-name">${user.userName} 님</div>
						            <div class="header-email">${user.userEmail}</div>
						        </div>
						    </div>
						</div>

                        <div class="dropdown-menu-container">
                            <div class="dropdown-section">
                                <div class="dropdown-section-title">내 계정</div>
                                <a href="mypage" class="dropdown-item">
                                    <div class="dropdown-icon-wrapper">
                                        <i class="dropdown-icon fa-solid fa-user"></i>
                                    </div>
                                    <div class="dropdown-item-content">
                                        <div class="dropdown-item-title">마이페이지</div>
                                        <div class="dropdown-item-description">계정 정보 및 활동 내역 확인</div>
                                    </div>
                                </a>
                            </div>

                            <div class="dropdown-section">
                                <div class="dropdown-section-title">서비스</div>
                                <a href="/book_wishlist" class="dropdown-item">
                                    <div class="dropdown-icon-wrapper">
                                        <i class="dropdown-icon fa-solid fa-heart"></i>
                                    </div>
                                    <div class="dropdown-item-content">
                                        <div class="dropdown-item-title">북마크</div>
                                        <div class="dropdown-item-description">내가 찜한 도서 목록</div>
                                    </div>
                                </a>
								<a href="/trade_post_favorite_view" class="dropdown-item">
								    <div class="dropdown-icon-wrapper">
								        <i class="dropdown-icon fa-solid fa-store"></i>
								    </div>
								    <div class="dropdown-item-content">
								        <div class="dropdown-item-title">중고도서 북마크</div>
								        <div class="dropdown-item-description">거래게시판을 통해 찜한 도서 목록</div>
								    </div>
								</a>
								<a href="/user_book_borrowing" class="dropdown-item">
								    <div class="dropdown-icon-wrapper">
								        <i class="dropdown-icon fa-solid fa-book-open-reader"></i>
								    </div>
								    <div class="dropdown-item-content">
								        <div class="dropdown-item-title">대출기록</div>
								        <div class="dropdown-item-description">반납 & 대출 기록</div>
								    </div>
								</a>
                            </div>

                                <c:if test="${user.userAdmin == 1}">
                            <div class="dropdown-section">
                                <div class="dropdown-section-title">관리자</div>
                                <a href="admin_view" class="dropdown-item admin-item">
                                    <div class="dropdown-icon-wrapper">
                                        <i class="dropdown-icon fa-solid fa-gear"></i>
                                    </div>
                                    <div class="dropdown-item-content">
                                        <div class="dropdown-item-title">관리자모드 <span class="admin-badge">Admin</span></div>
                                        <div class="dropdown-item-description">사이트 관리 및 설정</div>
                                    </div>
                                </a>
                            </div>
                                </c:if>
                        </div>

                        <div class="dropdown-footer">
                            <a href="/privacy" class="dropdown-footer-link">개인정보처리방침</a>
                            <a href="/logout" class="logout-button">
                                <i class="fa-solid fa-right-from-bracket"></i>
                                로그아웃
                            </a>
                        </div>
                    </div>
                </div>
				</c:when>
				<c:otherwise>
                <div class="auth-buttons">
                    <a href="/loginForm" class="auth-link login-link">
                        <i class="fa-solid fa-right-to-bracket"></i> 로그인
                    </a>
                    <a href="/joinForm" class="auth-link register-link">
                        <i class="fa-solid fa-user-plus"></i> 회원가입
                    </a>
                </div>
				    </c:otherwise>
				</c:choose>
            </div>
        </div>
    </header>

	<c:if test="${user != null}">
    <!-- 채팅 버튼 (알림 표시 포함) -->
    <button class="chatbot-btn" id="chatbot-button">
        <i class="fas fa-comment-dots"></i>
        <span id="chatNotification" class="chat-notification"></span>
    </button>
    
    <!-- 채팅 선택 메뉴 -->
    <div class="chat-menu" id="chat-menu">
        <a href="javascript:void(0)" class="chat-menu-item" id="ai-chat-option">
            <i class="fas fa-robot"></i> AI 채팅
        </a>
        <a href="/chat_list" class="chat-menu-item">
            <i class="fas fa-comments"></i> 일반 채팅<span id="chatMenuNotification" class="chat-menu-notification"></span>
        </a>
    </div>
	
	<!-- 토큰 만료 시간 관리 컴포넌트 -->
	<c:if test="${user != null}">
	<div class="token-expiry-manager" id="tokenExpiryManager">
	    <div class="token-card">
	        <div class="token-header">
	            <div class="token-title">
	                <i class="fas fa-clock"></i> 세션 만료 시간
	            </div>
	            <div class="token-actions">
	                <button id="extendTokenBtn" class="token-extend-btn">
	                    <i class="fas fa-sync-alt"></i> 연장하기
	                </button>
	                <button id="toggleTokenBtn" class="token-toggle-btn">
	                    <i class="fas fa-chevron-up"></i>
	                </button>
	            </div>
	        </div>
	        
	        <div class="token-body" id="tokenBody">
	            <div class="token-info">
	                <span>남은 시간</span>
	                <span id="remainingTime">--:--</span>
	            </div>
	            
	            <div class="progress-container">
	                <div id="progressBar" class="progress-bar"></div>
	            </div>
	            
	            <div class="token-expiry">
	                <span>* 시간이 만료되면 자동으로 로그아웃됩니다.</span>
	            </div>
	        </div>
	    </div>
	    
	    <!-- 접힌 상태일 때 표시될 미니 타이머 -->
	    <div class="token-mini" id="tokenMini">
	        <i class="fas fa-clock"></i> <span id="miniRemainingTime">--:--</span>
	    </div>
	</div>
	</c:if>
    
    <!-- AI 챗봇 컨테이너 -->
    <div class="chatbot-container" id="ai-chatbot-container">
        <div class="chatbot-header">
            <h3>AI 채팅 상담</h3>
            <button class="close-btn"><i class="fas fa-times"></i></button>
        </div>
        <div class="chatbot-messages">
            <div class="message bot">
                안녕하세요! 무엇을 도와드릴까요?
            </div>
        </div>
        <div class="chatbot-input">
            <input type="text" placeholder="메시지를 입력하세요...">
            <button class="send-btn"><i class="fas fa-paper-plane"></i></button>
        </div>
    </div>
    
	</c:if>

	<script src="/resources/js/token_manager.js"></script>
    <script>
        // 알림 확인 함수
        function checkChatNotifications() {
            <% if (user != null) { %>
            console.log('알림 확인 함수 실행 중...');
            
            // 직접 XMLHttpRequest 사용
            var xhr = new XMLHttpRequest();
            xhr.open('GET', '/check_new_messages?t=' + new Date().getTime(), true); // 캐시 방지를 위한 타임스탬프 추가
            xhr.setRequestHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
            xhr.setRequestHeader('Pragma', 'no-cache');
            xhr.setRequestHeader('Expires', '0');
            
            xhr.onload = function() {
                if (xhr.status >= 200 && xhr.status < 300) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        console.log('받은 데이터:', data);
                        
                        var chatNotification = document.getElementById('chatNotification');
						var chatMenuNotification = document.getElementById('chatMenuNotification');
						
                        if (!chatNotification) {
                            console.error('chatNotification 요소를 찾을 수 없습니다');
                            return;
                        }
                        
                        if (data && data.success && data.unreadCount > 0) {
                            // 알림 배지 표시
                            chatNotification.textContent = data.unreadCount;
                            chatNotification.style.display = 'flex';
                            chatNotification.classList.add('has-new');
                            chatMenuNotification.textContent = data.unreadCount;
                            chatMenuNotification.style.display = 'flex';
                            chatMenuNotification.classList.add('has-new');
                            console.log('알림 표시: ' + data.unreadCount + '개의 읽지 않은 메시지');
                        } else {
                            chatNotification.style.display = 'none';
                            chatNotification.classList.remove('has-new');
                            chatMenuNotification.style.display = 'none';
                            chatMenuNotification.classList.remove('has-new');
                            console.log('읽지 않은 메시지 없음 또는 데이터 오류:', data);
                        }
                    } catch (e) {
                        console.error('JSON 파싱 오류:', e, '원본 텍스트:', xhr.responseText);
                    }
                } else {
                    console.error('서버 응답 오류:', xhr.status, xhr.statusText);
                }
            };
            
            xhr.onerror = function() {
                console.error('네트워크 오류 발생');
            };
            
            xhr.send();
            <% } %>
        }

        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM 로드됨');
            
            // 알림 배지 초기화
            var chatNotification = document.getElementById('chatNotification');
            if (chatNotification) {
                // 초기 상태 명시적 설정
                chatNotification.style.display = 'none';
                console.log('알림 배지 초기화 완료');
            }
            var chatMenuNotification = document.getElementById('chatMenuNotification');
            if (chatMenuNotification) {
                // 초기 상태 명시적 설정
                chatMenuNotification.style.display = 'none';
                console.log('알림 배지 초기화 완료');
            }

            // 즉시 알림 확인 실행
            setTimeout(checkChatNotifications, 1000);

            // 주기적으로 알림 확인 (3초마다)
            setInterval(checkChatNotifications, 3000);
            
            // 사용자 드롭다운 메뉴
            const dropdownToggle = document.getElementById('dropdownToggle');
            const userDropdown = document.getElementById('userDropdown');

            if (dropdownToggle && userDropdown) {
                dropdownToggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    userDropdown.classList.toggle('active');
                });

                // 외부 클릭 시 드롭다운 닫기
                document.addEventListener('click', function(e) {
                    if (userDropdown && !userDropdown.contains(e.target)) {
                        userDropdown.classList.remove('active');
                    }
                });
            }

            // 헤더 스크롤 효과
            const header = document.querySelector('.top-header');
            window.addEventListener('scroll', function() {
                if (window.scrollY > 10) {
                    header.classList.add('scrolled');
                } else {
                    header.classList.remove('scrolled');
                }
            });

            // 초기 스크롤 위치 확인
            if (window.scrollY > 10) {
                header.classList.add('scrolled');
            }
            
            // 채팅 관련 요소
            const chatButton = document.getElementById('chatbot-button');
            const chatMenu = document.getElementById('chat-menu');
            const aiChatOption = document.getElementById('ai-chat-option');
            const aiChatbotContainer = document.getElementById('ai-chatbot-container');
            const closeButton = document.querySelector('.close-btn');
            const sendButton = document.querySelector('.send-btn');
            const messageInput = document.querySelector('.chatbot-input input');
            const messagesContainer = document.querySelector('.chatbot-messages');

            if (chatButton) {
                // 채팅 버튼 클릭 시 메뉴 표시
                chatButton.addEventListener('click', function(e) {
                    e.stopPropagation();
                    chatMenu.classList.toggle('active');
                    // AI 챗봇이 열려있으면 닫기
                    if (aiChatbotContainer.classList.contains('active')) {
                        aiChatbotContainer.classList.remove('active');
                    }
                });
                
                // AI 채팅 옵션 클릭
                if (aiChatOption) {
                    aiChatOption.addEventListener('click', function(e) {
                        e.preventDefault();
                        chatMenu.classList.remove('active');
                        aiChatbotContainer.classList.add('active');
                    });
                }

                // X 버튼으로 AI 챗봇 닫기
                if (closeButton) {
                    closeButton.addEventListener('click', function() {
                        aiChatbotContainer.classList.remove('active');
                    });
                }

                // 메시지 전송 함수
                function sendMessage() {
                    const message = messageInput.value.trim();
                    if (message) {
                        // 사용자 메시지 추가
                        const userMessage = document.createElement('div');
                        userMessage.className = 'message user';
                        userMessage.textContent = message;
                        messagesContainer.appendChild(userMessage);

                        // 입력창 비우기
                        messageInput.value = '';

                        // 스크롤을 가장 아래로
                        messagesContainer.scrollTop = messagesContainer.scrollHeight;
                        
                        // 서버에 메시지 전송
                        fetch('/chatbot/ask', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ message: message })
                        })
                        .then(res => res.json())
                        .then(data => {
                            const botMessage = document.createElement('div');
                            botMessage.className = 'message bot';
                            botMessage.textContent = data.reply;
                            messagesContainer.appendChild(botMessage);
                            messagesContainer.scrollTop = messagesContainer.scrollHeight;
                        })
                        .catch(error => {
                            console.error('챗봇 응답 오류:', error);
                            
                            // 오류 발생 시 기본 응답
                            const errorMessage = document.createElement('div');
                            errorMessage.className = 'message bot';
                            errorMessage.textContent = "죄송합니다. 일시적인 오류가 발생했습니다.";
                            messagesContainer.appendChild(errorMessage);
                            messagesContainer.scrollTop = messagesContainer.scrollHeight;
                        });
                    }
                }

                // 전송 버튼 클릭 이벤트
                if (sendButton) {
                    sendButton.addEventListener('click', sendMessage);
                }

                // Enter 키 입력 이벤트
                if (messageInput) {
                    messageInput.addEventListener('keypress', function(e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            sendMessage();
                        }
                    });
                }

                // 외부 클릭 시 메뉴와 챗봇 닫기
                document.addEventListener('click', function(e) {
                    if (!chatButton.contains(e.target) && 
                        !chatMenu.contains(e.target) && 
                        !aiChatbotContainer.contains(e.target)) {
                        chatMenu.classList.remove('active');
                        aiChatbotContainer.classList.remove('active');
                    }
                });
            }
        });

        // 채팅 메시지 읽음 처리 후 알림 업데이트 함수
        function updateChatNotifications() {
            checkChatNotifications();
        }
        
        // 전역으로 함수 노출
        window.updateChatNotifications = updateChatNotifications;

        // 전역 이벤트 리스너 추가
        window.addEventListener('chat-read', function() {
            updateChatNotifications();
        });
    </script>
<script>
    const processedNotifications = new Set();

    document.addEventListener('DOMContentLoaded', function() {
<!--        console.log('페이지 로드: 기존 알림 ID 저장');-->

        // 서버에서 가져온 초기 알림 ID를 기록
        const notificationItems = document.querySelectorAll('.notification-item');
        notificationItems.forEach(item => {
            if (item.dataset.id) {
                processedNotifications.add(parseInt(item.dataset.id));
                console.log(`초기 알림 ID 기록:`+item.dataset.id);
            }
        });

        // 알림 드롭다운 기능
        const notificationToggle = document.getElementById('notificationToggle');
        const notificationDropdown = document.getElementById('notificationDropdown');

        if (notificationToggle && notificationDropdown) {
            notificationToggle.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                notificationDropdown.classList.toggle('active');



                // 알림 목록이 표시될 때 항상 이벤트 리스너 설정 - 중요
                setTimeout(() => {
                    setupNotificationListeners();
                }, 100);
            });
        }



        // '모두 읽음' 버튼 기능 --모두 읽음 364
        const markAllAsReadBtn = document.getElementById('markAllAsRead');
        if (markAllAsReadBtn) {
            markAllAsReadBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                <% if (user != null) { %>

                // 서버에 모든 알림을 읽음 처리하는 요청
                fetch('/notifications/read-all/<%= user.getUserNumber() %>', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // 성공 시 알림 뱃지 제거
                            const badge = document.querySelector('.notification-badge');
                            if (badge) {
                                badge.remove();
                            }

                            // 모든 알림 항목을 읽음 상태로 변경
                            const unreadItems = document.querySelectorAll('.notification-item.unread');
                            unreadItems.forEach(item => {
                                item.classList.remove('unread');
                                item.classList.add('read');
                            });
                        }
                    })
                    .catch(error => {
                        console.error('알림 모두 읽음 처리 중 오류 발생:', error);
                    });
                <% } %>
            });
        }
        // 초기 알림 리스너 설정
        setupNotificationListeners();


        // 알림 목록이 동적으로 변경될 때를 감지하는 MutationObserver 설정
        const notificationList = document.querySelector('.notification-list');
        if (notificationList) {
            const observer = new MutationObserver(function() {
                setTimeout(() => {
                    setupNotificationListeners();
                }, 100);
            });

            observer.observe(notificationList, {
                childList: true,
                subtree: true
            });
        }

        // SSE 알림 연결 설정
        <% if (user != null) { %>
        connectToNotificationStream(<%= user.getUserNumber() %>);
        <% } %>
    });

    // 새 알림 추가 함수 -535line
    function addNewNotification(notification) {
        if (processedNotifications.has(notification.id)) {
            console.log('알림 중복 차단:', notification.id);
            return;
        }
        processedNotifications.add(notification.id);


        const notificationList = document.querySelector('.notification-list');
        const noNotifications = document.querySelector('.no-notifications');

        // '알림 없음' 메시지 제거
        if (noNotifications) {
            noNotifications.remove();
        }

        // 날짜 포맷팅
        const now = new Date();
        const createdAt = new Date(notification.createdAt);

        let formattedDate;
        if (now.toDateString() === createdAt.toDateString()) {
            // 오늘 날짜인 경우
            const hours = createdAt.getHours().toString().padStart(2, '0');
            const minutes = createdAt.getMinutes().toString().padStart(2, '0');
            formattedDate = `오늘 `+hours+`:`+minutes;
        } else {
            // 다른 날짜인 경우
            const year = createdAt.getFullYear();
            const month = (createdAt.getMonth() + 1).toString().padStart(2, '0');
            const day = createdAt.getDate().toString().padStart(2, '0');
            const hours = createdAt.getHours().toString().padStart(2, '0');
            const minutes = createdAt.getMinutes().toString().padStart(2, '0');
            formattedDate = ``+year+`-`+month+`-`+day+` `+ hours+`:`+minutes;
        }

        // 알림 타입에 따른 아이콘 결정
        let iconClass;
        switch (notification.type) {
            case 'BOOK_RETURN':
                iconClass = 'fa-book';
                break;
            case 'BOOK_BORROW':
                iconClass = 'fa-book-open-reader';
                break;
            case 'NOTICE':
                iconClass = 'fa-bullhorn';
                break;
            case 'COMMENT':
                iconClass = 'fa-comment';
                break;
            default:
                iconClass = 'fa-bell';
        }

        // 새 알림 요소 생성
        const newNotificationElement = document.createElement('div');
        newNotificationElement.className = 'notification-item unread';
        newNotificationElement.dataset.id = notification.id;
        newNotificationElement.dataset.url = notification.url || '';
        newNotificationElement.dataset.type = notification.type;

        const icon_Class = iconClass;
        const notification_title = notification.title;
        const notification_message = notification.message;
        const notification_time = formattedDate;


        newNotificationElement.innerHTML = `
                <div class="notification-icon-wrapper">
                    <i class="fa-solid `+icon_Class+`"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">`+notification_title+`</div>
                    <div class="notification-message">`+notification_message+`</div>
                    <div class="notification-time">`+notification_time+`</div>
                </div>
            `;

        // 목록의 맨 위에 새 알림 추가
        if (notificationList.firstChild) {
            notificationList.insertBefore(newNotificationElement, notificationList.firstChild);
        } else {
            notificationList.appendChild(newNotificationElement);
        }

        // 새 알림 추가 후 이벤트 리스너 재설정 (중요)
        setTimeout(() => {
            setupNotificationListeners();
        }, 100);
    }
    <% if (user != null) { %>
    const user_number =(<%= user.getUserNumber() %>);
    <% } %>
    // 알림 뱃지 업데이트 함수 -570line
    function updateNotificationBadge() {
        console.log('알림 뱃지 업데이트 시도');
        fetch(`/notifications/unread-count/`+user_number)
            .then(response => response.json())
            .then(data => {
                const notificationIcon = document.querySelector('.notification-icon');
                let badge = document.querySelector('.notification-badge');

                console.log('읽지 않은 알림 수:', data.count);

                // 읽지 않은 알림이 있는 경우
                if (data.count > 0) {
                    // 뱃지가 없으면 새로 생성
                    if (!badge) {
                        badge = document.createElement('span');
                        badge.className = 'notification-badge';
                        notificationIcon.appendChild(badge);
                    }

                    // 개수 업데이트
                    badge.textContent = data.count;
                } else {
                    // 읽지 않은 알림이 없는 경우 뱃지 제거
                    if (badge) {
                        badge.remove();
                    }
                }
            })
            .catch(error => {
                console.error('알림 개수 업데이트 오류:', error);
            });
    }
</script>
<script>
    // 알림 항목 이벤트 설정 함수 (새로 추가)
    function setupNotificationListeners() {
        console.log('알림 이벤트 리스너 설정 중...');

        // 알림 항목 클릭 이벤트 - 읽음 처리 및 페이지 이동
        const notificationItems = document.querySelectorAll('.notification-item');
        console.log(notificationItems.length+`개의 알림 항목 발견`);

        // 모든 알림 항목 선택
        notificationItems.forEach(item => {
            notificationItems.forEach(item => {
                // 기존 이벤트 리스너 제거 (중복 방지)
                item.removeEventListener('click', handleNotificationClick);

                // 새 이벤트 리스너 추가
                item.addEventListener('click', handleNotificationClick);
            });
            // 이미 이벤트가 등록되어 있는지 확인 (중복 방지)
            if (!item.hasAttribute('data-event-attached')) {
                item.setAttribute('data-event-attached', 'true');

                item.addEventListener('click', function() {
                    const notificationId = this.dataset.id;
                    const notificationUrl = this.dataset.url;

                    console.log(`알림 클릭: ID=`+notificationId+` URL=`+notificationUrl+``);

                    // 이미 읽은 알림이 아닌 경우에만 읽음 처리
                    if (!this.classList.contains('read')) {
                        // 읽음 상태로 변경
                        this.classList.remove('unread');
                        this.classList.add('read');

                        // 서버에 읽음 처리 요청
                        fetch(`/notifications/`+notificationId+`/read`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            }
                        })
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error(`HTTP error! Status: ${response.status}`);
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data.success) {
                                    console.log(`알림 ID: ${notificationId} 읽음 처리 완료`);

                                    // 읽지 않은 알림 수 업데이트
                                    updateNotificationBadge();
                                } else {
                                    console.error(`알림 ID: ${notificationId} 읽음 처리 실패`);
                                }
                            })
                            .catch(error => {
                                console.error('알림 읽음 처리 오류:', error);
                            });
                    }

                    // URL이 있으면 해당 페이지로 이동
                    if (notificationUrl && notificationUrl.trim() !== '') {
                        window.location.href = notificationUrl;
                    }
                });
            }
        });
    }
</script>
<script>


    // 알림 항목 클릭 처리 함수
    function handleNotificationClick(event) {
        const item = event.currentTarget;
        const id = item.dataset.id;
        const url = item.dataset.url;



        // 이미 읽은 알림은 처리하지 않음
        if (item.classList.contains('read')) {
            // URL이 있으면 해당 URL로 이동
            if (url && url !== 'null' && url !== 'undefined' && url !== '') {
                window.location.href = url;
            }
            return;
        }

        // 알림을 읽음 상태로 변경
        fetch(`/notifications/`+id+`/read`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // UI 업데이트 - 읽음 상태로 변경
                    item.classList.remove('unread');
                    item.classList.add('read');

                    // 알림 뱃지 카운트 업데이트
                    updateNotificationBadge();

                    // URL이 있으면 해당 URL로 이동
                    if (url && url !== 'null' && url !== 'undefined' && url !== '') {
                        window.location.href = url;
                    }
                }
            })
            .catch(error => {
                console.error('알림 읽음 처리 오류:', error);
            });
    }

    // SSE 이벤트 핸들러 수정 -1048line
    function connectToNotificationStream(userNumber) {
        const savedUserNumber = userNumber;

        console.log('SSE 연결 시도, 사용자 번호:', savedUserNumber);
        const sseUrl = `/notifications/stream/` + savedUserNumber;
        console.log("URL", sseUrl);
        const eventSource = new EventSource(sseUrl);

        // 연결 성공 이벤트
        eventSource.addEventListener('connect', function(event) {
            console.log('알림 서버에 연결됨:', event.data);
        });

        // 새 알림 이벤트
        eventSource.addEventListener('notification', function(event) {
            try {
                const notification = JSON.parse(event.data);
                console.log('새 알림 도착:', notification);

                // 새 알림 추가
                addNewNotification(notification);
                // 새 알림 추가 후 뱃지 갱신 시도
                console.log('알림 뱃지 업데이트 시도');
                updateNotificationBadge();

            } catch (error) {
                console.error('알림 데이터 처리 오류:', error);
            }
        });

        // 오류 이벤트
        eventSource.onerror = function(error) {
            console.error('알림 연결 오류:', error);

            // 연결 종료 후 재연결 시도
            eventSource.close();
            setTimeout(() => {
                console.log('알림 서버에 재연결 시도... 사용자 번호:', savedUserNumber);
                connectToNotificationStream(userNumber);
            }, 5000);
        };

        // 페이지 언로드 시 연결 종료
        window.addEventListener('beforeunload', function() {
            eventSource.close();
        });
    }
</script>


</body>
</html>