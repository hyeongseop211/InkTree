<%@page import="com.boot.user.dto.UserDTO" %>
   <%@page import="com.boot.user.dto.AdminActivityLogDTO" %>
<%@page import="com.boot.z_page.PageDTO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.boot.z_util.AdminActivityTypeManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서관리 시스템 - 활동 로그</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/resources/css/admin_view.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/board_view.css">
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    
    <style>
        .activity-filter {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .filter-item {
            padding: 8px 12px;
            border-radius: 5px;
            background-color: #f0f0f0;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .filter-item.active {
            background-color: #4a6cf7;
            color: white;
        }
        
        .activity-list-full {
            margin-top: 20px;
        }
        
        .activity-item {
            display: flex;
            padding: 15px;
            border-bottom: 1px solid #eaeaea;
            align-items: flex-start;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .activity-details {
            flex-grow: 1;
        }
        
        .activity-details h4 {
            margin: 0 0 5px 0;
            font-size: 16px;
            font-weight: 600;
        }
        
        .activity-details p {
            margin: 0 0 8px 0;
            color: #555;
        }
        
        .activity-time {
            font-size: 12px;
            color: #777;
        }
        
        .activity-meta {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #777;
        }
        
        .actor-info {
            color: #4a6cf7;
        }
        
    </style>
</head>

<body>
    <% UserDTO user = (UserDTO) session.getAttribute("loginUser"); %>
    <jsp:include page="../header.jsp" />
    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h1>도서관리 시스템</h1>
                <p>관리자 대시보드</p>
            </div>

            <div class="admin-info">
                <div class="admin-avatar">
                    <i class="ri-user-line"></i>
                </div>
                <div class="admin-details">
                    <h3>관리자<%=user.getUserName()%></h3>
                    <p><%=user.getUserEmail()%></p>
                </div>
            </div>

            <nav class="nav-menu">
                <div class="menu-category">대시보드</div>
                <ul class="nav-list">
                    <li class="nav-item"><a href="admin_dashboard" class="nav-link active">
                        <i class="ri-dashboard-line"></i> <span>대시보드</span>
                    </a></li>
                </ul>

                <div class="menu-category">도서 관리</div>
                <ul class="nav-list">
                    <li class="nav-item"><a href="book_insert_view" class="nav-link">
                        <i class="ri-file-add-line"></i> <span>도서 등록</span>
                    </a></li>
                    <li class="nav-item"><a href="book_manage" class="nav-link">
                        <i class="ri-book-line"></i> <span>도서 관리</span>
                    </a></li>
                    <li class="nav-item"><a href="book_category" class="nav-link">
                        <i class="ri-bookmark-line"></i> <span>카테고리 관리</span>
                    </a></li>
                </ul>

                <div class="menu-category">회원 관리</div>
                <ul class="nav-list">
                    <li class="nav-item"><a href="user_manage" class="nav-link">
                        <i class="ri-user-settings-line"></i> <span>회원 관리</span>
                    </a></li>
                    <li class="nav-item"><a href="user_borrow" class="nav-link">
                        <i class="ri-file-list-3-line"></i> <span>대출/반납 관리</span>
                    </a></li>
                </ul>

                <div class="menu-category">콘텐츠 관리</div>
                <ul class="nav-list">
                    <li class="nav-item"><a href="admin_notice_write" class="nav-link">
                        <i class="ri-notification-line"></i> <span>공지사항 등록</span>
                    </a></li>
                    <li class="nav-item"><a href="notice_manage" class="nav-link">
                        <i class="ri-file-list-line"></i> <span>공지사항 관리</span>
                    </a></li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <div class="page-title">
                    <h2>활동 로그</h2>
                    <p>시스템 내 모든 활동 기록을 확인합니다.</p>
                </div>
            </div>

            <!-- 필터 옵션 -->
            <div class="activity-filter">
                <c:forEach items="${filterOptions}" var="option">
                    <div class="filter-item ${param.filter == option.code || (param.filter == null && option.code == 'all') ? 'active' : ''}" 
                         onclick="changeFilter('${option.code}')">
                        ${option.displayName}
                    </div>
                </c:forEach>
            </div>

            <div class="card activity-list-full">
                <c:if test="${empty logList}">
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="ri-information-line"></i>
                        </div>
                        <div class="activity-details">
                            <h4>표시할 활동 로그가 없습니다</h4>
                            <p>시스템 활동이 기록되면 여기에 표시됩니다.</p>
                        </div>
                    </div>
                </c:if>
                
                <c:forEach items="${logList}" var="activity">
                    <c:set var="typeInfo" value="${activityTypeManager.getTypeInfo(activity.activityType)}" scope="request" />
                    <div class="activity-item">
                        <div class="activity-icon">
                            <i class="${typeInfo.iconClass}"></i>
                        </div>
                        <div class="activity-details">
                            <h4>${typeInfo.displayName}</h4>
                            <p>${activity.description}</p>
                            <div class="activity-meta">
                                <span class="activity-time">
                                    <fmt:parseDate value="${activity.logDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedLogDate" type="both" />
                                    <fmt:formatDate value="${parsedLogDate}" pattern="yyyy년 MM월 dd일 HH:mm" var="formattedLogDate" />
                                    ${formattedLogDate}
                                </span>
                                <span class="actor-info">${activity.actorType eq 'admin' ? '어드민' : '회원'} (${activity.actorName})</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <!-- 페이징 처리 -->
            <c:if test="${not empty pageMaker}">
                <div class="div_page">
                    <ul>
                        <c:if test="${pageMaker.prev}">
                            <li class="paginate_button">
                                <a href="${pageMaker.startPage - 1}">
                                    <i class="ri-arrow-left-s-line"></i>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                            <li class="paginate_button ${criteria.pageNum == num ? 'active' : ''}">
                                <a href="${num}">${num}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${pageMaker.next}">
                            <li class="paginate_button">
                                <a href="${pageMaker.endPage + 1}">
                                    <i class="ri-arrow-right-s-line"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </c:if>
            
            <!-- 페이징 처리를 위한 폼 -->
            <form id="actionForm" action="activity_log" method="get">
                <input type="hidden" name="pageNum" value="${criteria.pageNum}">
                <input type="hidden" name="amount" value="${criteria.amount}">
                <input type="hidden" name="filter" value="${param.filter}">
            </form>
        </main>
    </div>
    
    <script>
        $(document).ready(function() {
            // 페이징 처리
            var actionForm = $("#actionForm");
            
            // 페이지번호 처리
            $(".paginate_button a").on("click", function(e) {
                e.preventDefault();
                actionForm.find("input[name='pageNum']").val($(this).attr("href"));
                actionForm.submit();
            });
        });
        
        // 필터 변경
        function changeFilter(filter) {
            var actionForm = $("#actionForm");
            actionForm.find("input[name='filter']").val(filter);
            actionForm.find("input[name='pageNum']").val("1"); // 필터 변경 시 1페이지로
            actionForm.submit();
        }
    </script>
</body>
</html> 