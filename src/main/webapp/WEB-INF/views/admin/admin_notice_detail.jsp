<%@page import="com.boot.user.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${notice.noticeTitle} - 공지사항</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="/resources/css/admin_notice_detail.css">
<script src="/resources/js/admin_notice_datail.js"></script>
</head>
<body>
    <jsp:include page="../header.jsp" />
	
	<div class="container">
	    <div class="notice-header">
	        <c:choose>
	            <c:when test="${notice.noticeCategory == 'important'}">
	                <span class="notice-category category-important">중요 공지</span>
	            </c:when>
	            <c:when test="${notice.noticeCategory == 'event'}">
	                <span class="notice-category category-event">이벤트</span>
	            </c:when>
	            <c:when test="${notice.noticeCategory== 'info'}">
	                <span class="notice-category category-info">안내</span>
	            </c:when>
	            <c:when test="${notice.noticeCategory== 'update'}">
	                <span class="notice-category category-update">업데이트</span>
	            </c:when>
	        </c:choose>
	        
	        <h1 class="notice-title">${notice.noticeTitle}</h1>
	        
	        <div class="notice-meta">
	            <div class="meta-left">
	                <div class="meta-item">
	                    <i class="fas fa-user meta-icon"></i>
	                    <span>${notice.noticeWriter}</span>
	                </div>
	                <div class="meta-item">
	                    <i class="fas fa-calendar meta-icon"></i>
	                    <span>${notice.noticeRegdate}</span>
	                </div>
	            </div>
	            <div class="meta-item">
	                <i class="fas fa-eye meta-icon"></i>
	                <span>조회수 ${notice.noticeViews}</span>
	            </div>
	        </div>
	    </div>
	    
	    <div class="notice-content">
	        <div class="content-text">
	            ${notice.noticeContent}
	        </div>
	    </div>
	    
<%-- 	    <c:if test="${not empty notice.attachments}"> --%>
<!-- 	        <div class="notice-attachments"> -->
<!-- 	            <h3 class="attachments-title"> -->
<!-- 	                <i class="fas fa-paperclip"></i> 첨부파일 -->
<!-- 	            </h3> -->
<!-- 	            <ul class="attachment-list"> -->
<%-- 	                <c:forEach items="${notice.attachments}" var="attachment"> --%>
<!-- 	                    <li class="attachment-item"> -->
<%-- 	                        <a href="/download?fileId=${attachment.id}" class="attachment-link"> --%>
<!-- 	                            <i class="fas fa-file attachment-icon"></i> -->
<%-- 	                            <span>${attachment.originalName}</span> --%>
<%-- 	                            <span>(${attachment.fileSize}KB)</span> --%>
<!-- 	                        </a> -->
<!-- 	                    </li> -->
<%-- 	                </c:forEach> --%>
<!-- 	            </ul> -->
<!-- 	        </div> -->
<%-- 	    </c:if> --%>
	    
	    <div class="notice-actions">
	        <a href="/admin_notice" class="action-btn list-btn">
	            <i class="fas fa-list"></i> 목록으로
	        </a>
	        
			<c:if test="${requestScope.user != null and requestScope.user.userAdmin == 1}">
			    <div class="admin-actions">
			        <a href="/admin_update?noticeNum=${notice.noticeNum}" class="action-btn edit-btn">
			            <i class="fas fa-edit"></i> 수정하기
			        </a>
			        <a href="#" onclick="confirmDelete(${notice.noticeNum}); return false;" class="action-btn delete-btn">
			            <i class="fas fa-trash"></i> 삭제하기
			        </a>
			    </div>
			</c:if>

	    </div>
	    
	    <div class="notice-navigation">
	        <c:if test="${not empty prevNotice}">
	            <div class="nav-item">
	                <span class="nav-label">
	                <i class="fas fa-chevron-up"></i>이전글
	                </span>
	                <a href="/admin_notice_detail?noticeNum=${prevNotice.noticeNum}" class="nav-link">${prevNotice.noticeTitle}</a>
	                <span class="nav-date"><fmt:formatDate value="${prevNotice.noticeRegdate}" pattern="yyyy-MM-dd"/></span>
	            </div>
	        </c:if>
	        <c:if test="${not empty nextNotice}">
	            <div class="nav-item">
	                <span class="nav-label">
	                <i class="fas fa-chevron-down"></i>다음글
	                </span>
	                <a href="/admin_notice_detail?noticeNum=${nextNotice.noticeNum}" class="nav-link">${nextNotice.noticeTitle}</a>
	                <span class="nav-date"><fmt:formatDate value="${nextNotice.noticeRegdate}" pattern="yyyy-MM-dd"/></span>
	            </div>
	        </c:if>
	    </div>
	</div>
	
	<script>
	    function confirmDelete(noticeNum) {
	        if (confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
	            location.href = '/admin_delete?noticeNum=' + noticeNum;
	        }
	    }
	</script>
</body>
</html>

