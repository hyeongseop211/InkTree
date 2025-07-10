<%@page import="com.boot.board.dto.BoardDTO" %>
   <%@page import="com.boot.user.dto.UserDTO" %>
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
               <% UserDTO user=(UserDTO) session.getAttribute("loginUser"); BoardDTO board=(BoardDTO)
                  request.getAttribute("board"); %>
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
                              <h3>
                                 관리자<%=user.getUserName()%>
                              </h3>
                              <p>
                                 <%=user.getUserEmail()%>
                              </p>
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
                                 <i class="ri-file-add-line"></i>
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
                              <li class="activity-item">
                                 <div class="activity-icon">
                                    <i class="ri-book-add-line"></i>
                                 </div>
                                 <div class="activity-details">
                                    <h4>새 도서 등록</h4>
                                    <p>"클린 코드" 도서가 등록되었습니다.</p>
                                    <span class="activity-time">오늘 14:25</span>
                                 </div>
                              </li>

                              <li class="activity-item">
                                 <div class="activity-icon">
                                    <i class="ri-user-add-line"></i>
                                 </div>
                                 <div class="activity-details">
                                    <h4>새 회원 가입</h4>
                                    <p>김철수 회원이 가입했습니다.</p>
                                    <span class="activity-time">오늘 11:30</span>
                                 </div>
                              </li>

                              <li class="activity-item">
                                 <div class="activity-icon">
                                    <i class="ri-bookmark-line"></i>
                                 </div>
                                 <div class="activity-details">
                                    <h4>도서 대출</h4>
                                    <p>이영희 회원이 "자바의 정석" 도서를 대출했습니다.</p>
                                    <span class="activity-time">오늘 10:15</span>
                                 </div>
                              </li>

                              <li class="activity-item">
                                 <div class="activity-icon">
                                    <i class="ri-notification-line"></i>
                                 </div>
                                 <div class="activity-details">
                                    <h4>공지사항 등록</h4>
                                    <p>"도서관 휴관 안내" 공지사항이 등록되었습니다.</p>
                                    <span class="activity-time">어제 16:40</span>
                                 </div>
                              </li>

                              <li class="activity-item">
                                 <div class="activity-icon">
                                    <i class="ri-book-read-line"></i>
                                 </div>
                                 <div class="activity-details">
                                    <h4>도서 반납</h4>
                                    <p>박지민 회원이 "데이터베이스 개론" 도서를 반납했습니다.</p>
                                    <span class="activity-time">어제 15:20</span>
                                 </div>
                              </li>
                           </ul>
                        </div>

                     </main>
                  </div>
            </body>

            </html>