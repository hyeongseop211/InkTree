<%@page import="com.boot.board.dto.BoardDTO" %>
   <%@page import="com.boot.user.dto.UserDTO" %>
      <%@page import="com.boot.user.dto.AdminActivityLogDTO" %>
      <%@page import="java.util.ArrayList" %>
      <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
         <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
               <meta charset="UTF-8">
               <meta name="viewport" content="width=device-width, initial-scale=1.0">
               <title>도서관리 시스템 - 관리자 대시보드</title>
               <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
                  rel="stylesheet">
               <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
               <link rel="stylesheet" type="text/css" href="/resources/css/admin_view.css">
               <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
            </head>

            <body>

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
							<c:if test="${not empty user}">
							  <h3>관리자 ${user.userName}</h3>
							  <p>${user.userEmail}</p>
							</c:if>
                           </div>
                        </div>

                        <nav class="nav-menu">
                           <div class="menu-category">대시보드</div>
                           <ul class="nav-list">
                              <li class="nav-item"><a href="admin_dashboard" class="nav-link active"> <i
                                       class="ri-dashboard-line"></i> <span>대시보드</span>
                                 </a></li>
                           </ul>

                           <div class="menu-category">도서 관리</div>
                           <ul class="nav-list">
                              <li class="nav-item"><a href="book_insert_view" class="nav-link"> <i
                                       class="ri-file-add-line"></i> <span>도서
                                       등록</span>
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
                              <li class="nav-item"><a href="admin_notice_write" class="nav-link"> <i
                                       class="ri-notification-line"></i> <span>공지사항
                                       등록</span>
                                 </a></li>
                              <li class="nav-item"><a href="notice_manage" class="nav-link">
                                    <i class="ri-file-list-line"></i> <span>공지사항 관리</span>
                                 </a></li>
                              <!--                     <li class="nav-item"> -->
                              <!--                         <a href="event_manage" class="nav-link"> -->
                              <!--                             <i class="ri-calendar-event-line"></i> -->
                              <!--                             <span>이벤트 관리</span> -->
                              <!--                         </a> -->
                              <!--                     </li> -->
                           </ul>

                           <!--                 <div class="menu-category">시스템</div> -->
                           <!--                 <ul class="nav-list"> -->
                           <!--                     <li class="nav-item"> -->
                           <!--                         <a href="settings" class="nav-link"> -->
                           <!--                             <i class="ri-settings-line"></i> -->
                           <!--                             <span>환경설정</span> -->
                           <!--                         </a> -->
                           <!--                     </li> -->
                           <!--                     <li class="nav-item"> -->
                           <!--                         <a href="logout" class="nav-link"> -->
                           <!--                             <i class="ri-logout-box-line"></i> -->
                           <!--                             <span>로그아웃</span> -->
                           <!--                         </a> -->
                           <!--                     </li> -->
                           </ul>
                        </nav>
                     </aside>

                     <!-- Main Content -->
                     <main class="main-content">
                        <div class="page-header">
                           <div class="page-title">
                              <h2>관리자 대시보드</h2>
                           </div>
                           <div class="header-actions">
                              <a href="reports" class="btn btn-outline">보고서 생성</a> <a href="settings"
                                 class="btn">환경설정</a>
                           </div>
                        </div>

                        <div class="dashboard-stats">
                           <div class="stat-card">
                              <div class="stat-icon books">
                                 <i class="ri-book-open-line"></i>
                              </div>
                              <div class="stat-details">
                                 <h3>전체 도서</h3>
                                 <div class="number">
                                    <fmt:formatNumber value="${totalBooks}" type="number" />
                                 </div>
                              </div>
                           </div>

                           <div class="stat-card">
                              <div class="stat-icon users">
                                 <i class="ri-user-line"></i>
                              </div>
                              <div class="stat-details">
                                 <h3>전체 회원</h3>
                                 <div class="number">
                                    <fmt:formatNumber value="${totalUsers}" type="number" />
                                 </div>
                              </div>
                           </div>

                           <div class="stat-card">
                              <div class="stat-icon borrowed">
                                 <i class="ri-bookmark-line"></i>
                              </div>
                              <div class="stat-details">
                                 <h3>대출 중인 도서</h3>
                                 <div class="number">
                                    <fmt:formatNumber value="${borrowedBooks}" type="number" />
                                 </div>
                              </div>
                           </div>

                           <div class="stat-card">
                              <div class="stat-icon overdue">
                                 <i class="ri-alarm-warning-line"></i>
                              </div>
                              <div class="stat-details">
                                 <h3>연체 도서</h3>
                                 <div class="number">
                                    <fmt:formatNumber value="${overdueBooks}" type="number" />
                                 </div>
                              </div>
                           </div>
                        </div>


                        <!-- Quick Actions -->
                        <div class="quick-actions">
                           <div class="action-card">
                              <div class="action-icon">
                                 <i class="ri-book-open-line"></i>
                              </div>
                              <h3>도서 등록</h3>
                              <p>새로운 도서를 시스템에 등록합니다.</p>
                              <a href="book_insert_view">등록하기</a>
                           </div>

                           <div class="action-card">
                              <div class="action-icon">
                                 <i class="ri-user-settings-line"></i>
                              </div>
                              <h3>회원 관리</h3>
                              <p>회원 정보를 조회하고 관리합니다.</p>
                              <a href="user_manage">관리하기</a>
                           </div>

                           <div class="action-card">
                              <div class="action-icon">
                                 <i class="ri-notification-line"></i>
                              </div>
                              <h3>공지사항 등록</h3>
                              <p>새로운 공지사항을 등록합니다.</p>
                              <a href="admin_notice_write">등록하기</a>
                           </div>

                           <div class="action-card">
                              <div class="action-icon">
                                 <i class="ri-file-list-3-line"></i>
                              </div>
                              <h3>대출/반납 관리</h3>
                              <p>도서 대출 및 반납을 관리합니다.</p>
                              <a href="user_borrow">관리하기</a>
                           </div>
                        </div>

                        <!-- Recent Activity -->
                        <div class="recent-activity">
                           <div class="section-header">
                              <h3>최근 활동</h3>
                              <a href="activity_log" class="view-all">전체보기</a>
                           </div>

                           <ul class="activity-list">
                              <% if(request.getAttribute("recentActivities") != null) {
                                 ArrayList<AdminActivityLogDTO> recentActivities = (ArrayList<AdminActivityLogDTO>)request.getAttribute("recentActivities");
                                 if(recentActivities != null && !recentActivities.isEmpty()) {
                                    for(AdminActivityLogDTO activity : recentActivities) { 
                                       if(activity != null) {
                                          String iconClass = "";
                                          
                                          // 활동 유형에 따른 아이콘 설정
                                          if(activity.getActivityType() != null) {
                                             switch(activity.getActivityType()) {
                                                case "book_add": iconClass = "ri-book-open-line"; break;
                                                case "user_add": iconClass = "ri-user-add-line"; break;
                                                case "book_borrow": iconClass = "ri-bookmark-line"; break;
                                                case "notice_add": iconClass = "ri-notification-line"; break;
                                                case "book_return": iconClass = "ri-book-read-line"; break;
                                                case "notice_delete": iconClass = "ri-delete-bin-line"; break;
                                                case "book_delete": iconClass = "ri-delete-bin-line"; break;
                                                case "book_modify": iconClass = "ri-edit-line"; break;
                                                case "user_modify": iconClass = "ri-user-settings-line"; break;
                                                case "notice_modify": iconClass = "ri-edit-line"; break;
                                                default: iconClass = "ri-information-line";
                                             }
                                          } else {
                                             iconClass = "ri-information-line";
                                          }
                                          
                                          // 로그 시간 형식 처리
                                          java.time.LocalDateTime logDate = activity.getLogDate();
                                          String displayTime = "";
                                          
                                          if(logDate != null) {
                                             java.time.LocalDateTime now = java.time.LocalDateTime.now();
                                             java.time.LocalDate today = now.toLocalDate();
                                             java.time.LocalDate yesterday = today.minusDays(1);
                                             java.time.LocalDate logDay = logDate.toLocalDate();
                                             
                                             if(logDay.equals(today)) {
                                                displayTime = "오늘 " + String.format("%02d:%02d", logDate.getHour(), logDate.getMinute());
                                             } else if(logDay.equals(yesterday)) {
                                                displayTime = "어제 " + String.format("%02d:%02d", logDate.getHour(), logDate.getMinute());
                                             } else {
                                                displayTime = logDate.getMonthValue() + "월 " + logDate.getDayOfMonth() + "일 " + 
                                                              String.format("%02d:%02d", logDate.getHour(), logDate.getMinute());
                                             }
                                          } else {
                                             displayTime = "날짜 정보 없음";
                                          }
                                 %>
                                    <li class="activity-item">
                                       <div class="activity-icon">
                                          <i class="<%= iconClass %>"></i>
                                       </div>
                                       <div class="activity-details">
                                          <h4><%= activity.getActorType() != null && activity.getActorType().equals("admin") ? "관리자" : "회원" %> <%= activity.getActivityType() != null ? (
                                                   activity.getActivityType().equals("book_add") ? "도서 등록" : 
                                                   activity.getActivityType().equals("user_add") ? "회원 가입" : 
                                                   activity.getActivityType().equals("book_borrow") ? "도서 대출" : 
                                                   activity.getActivityType().equals("notice_add") ? "공지사항 등록" : 
                                                   activity.getActivityType().equals("book_return") ? "도서 반납" : 
                                                   activity.getActivityType().equals("notice_delete") ? "공지사항 삭제" : 
                                                   activity.getActivityType().equals("book_delete") ? "도서 삭제" : 
                                                   activity.getActivityType().equals("book_modify") ? "도서 수정" : 
                                                   activity.getActivityType().equals("user_modify") ? "회원 정보 수정" : 
                                                   activity.getActivityType().equals("notice_modify") ? "공지사항 수정" : 
                                                   "기타 활동"
                                                ) : "기타 활동" %></h4>
                                          <p><%= activity.getDescription() != null ? activity.getDescription() : "" %></p>
                                          <span class="activity-time"><%= displayTime %></span>
                                       </div>
                                    </li>
                                 <% 
                                       }
                                    }
                                 } else {
                                 %>
                                    <li class="activity-item">
                                       <div class="activity-icon">
                                          <i class="ri-information-line"></i>
                                       </div>
                                       <div class="activity-details">
                                          <h4>표시할 활동 로그가 없습니다</h4>
                                          <p>시스템 활동이 기록되면 여기에 표시됩니다.</p>
                                       </div>
                                    </li>
                                 <% 
                                 }
                              } else { 
                                 %>
                                    <li class="activity-item">
                                       <div class="activity-icon">
                                          <i class="ri-information-line"></i>
                                       </div>
                                       <div class="activity-details">
                                          <h4>표시할 활동 로그가 없습니다</h4>
                                          <p>시스템 활동이 기록되면 여기에 표시됩니다.</p>
                                       </div>
                                    </li>
                                 <% 
                              } %>
                           </ul>
                        </div>

                     </main>
                  </div>
            </body>

            </html>