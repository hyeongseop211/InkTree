<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %> <%@ page
import="java.time.format.DateTimeFormatter" %> <%
pageContext.setAttribute("dateFormatter",
java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")); %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>채팅 목록 - 잉크트리</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      type="text/css"
      href="/resources/css/trade_chat_list.css"
    />
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
  </head>
  <body>
    <jsp:include page="../header.jsp" />

    <div class="container">
      <div class="chat-list-container">
        <h1 class="page-title">채팅 목록</h1>

        <c:if test="${empty chatRooms}">
          <div class="no-chats">
            <i class="fas fa-comments"></i>
            <p>진행 중인 채팅이 없습니다.</p>
          </div>
        </c:if>

        <c:if test="${not empty chatRooms}">
<div class="chat-rooms">
  <c:forEach items="${chatRooms}" var="room">
    <a href="trade_chat?postID=${room.postId}&sellerNumber=${room.sellerNumber}&buyerNumber=${room.buyerNumber}" class="chat-room-item">
      <div class="chat-info">
        <div class="chat-header">
          <div class="chat-user-time">
            <span class="chat-user">
              <c:choose>
                <c:when test="${loginUser.userNumber == room.sellerNumber}">
                  ${room.buyerName}
                </c:when>
                <c:otherwise>${room.sellerName}</c:otherwise>
              </c:choose>
            </span>
            <span class="chat-time">마지막 채팅 : ${room.lastMessageTime.format(dateFormatter)}</span>
          </div>

          <div class="post-info">
            <span class="post-title">${room.postTitle}</span>
            <span class="post-price">
              <fmt:formatNumber value="${room.postPrice}" pattern="#,###" />원
            </span>
            <span class="post-status 
              ${room.postStatus == 'AVAILABLE' ? 'available' : room.postStatus == 'RESERVED' ? 'reserved' : 'sold'}">
              ${room.postStatus == 'AVAILABLE' ? '판매중' : room.postStatus == 'RESERVED' ? '예약중' : '판매완료'}
            </span>
          </div>
        </div>
        <div class="chat-preview">${room.lastMessage}</div>
      </div>

        <div class="chat-badge-wrapper">
            <c:if test="${room.unreadCount > 0}">
            <div class="unread-badge">${room.unreadCount}</div>
            </c:if>
        </div>
    </a>
  </c:forEach>
</div>

        </c:if>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 읽지 않은 메시지 수 확인
        function checkUnreadMessages() {
          $.ajax({
            type: "GET",
            url: "check_new_messages",
            success: function (response) {
              if (response.success && response.unreadCount > 0) {
                // 헤더의 채팅 아이콘에 알림 표시 (header.jsp에 구현 필요)
                $("#chatNotification").text(response.unreadCount).show();
              } else {
                $("#chatNotification").hide();
              }
            },
          });
        }

        // 페이지 로드 시 확인
        checkUnreadMessages();

        // 30초마다 새 메시지 확인
        setInterval(checkUnreadMessages, 30000);
      });
    </script>
  </body>
</html>
