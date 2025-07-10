<%@page import="com.boot.user.dto.UserDTO" %>
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
				<!DOCTYPE html>
				<html>

				<head>
					<meta charset="UTF-8">
					<meta name="viewport" content="width=device-width, initial-scale=1.0">
					<link rel="stylesheet"
						href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
					<link rel="stylesheet" type="text/css" href="/resources/css/admin_notice.css">
					<link rel="stylesheet" type="text/css" href="/resources/css/board_view.css">
					<script src="/resources/js/admin_notice.js"></script>
					<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
					<title>공지사항 - 도서관리 시스템</title>
				</head>

				<body>
    <jsp:include page="../header.jsp" />

					<div class="container">
<!--						<div class="page-header">-->
<!--							<h1 class="page-title">공지사항</h1>-->
<!--							<p class="page-description">잉크트리의 중요 소식과 업데이트 정보를 확인하세요.</p>-->
<!--						</div>-->

						<div class="notice-stats">
							<div class="stat-card">
								<div class="stat-icon blue">
									<i class="fas fa-bullhorn"></i>
								</div>

								<div class="stat-info">
									<div class="stat-value">${countAll}</div>
									<div class="stat-label">전체 공지</div>
								</div>
							</div>

							<div class="stat-card">
								<div class="stat-icon red">
									<i class="fas fa-exclamation-circle"></i>
								</div>
								<div class="stat-info">
									<div class="stat-value">${countImportant}</div>
									<div class="stat-label">중요 공지</div>
								</div>
							</div>

							<div class="stat-card">
								<div class="stat-icon green">
									<i class="fas fa-calendar-alt"></i>
								</div>
								<div class="stat-info">
									<div class="stat-value">${countEvent}</div>
									<div class="stat-label">이벤트</div>
								</div>
							</div>

							<div class="stat-card">
								<div class="stat-icon yellow">
									<i class="fas fa-clock"></i>
								</div>
								<div class="stat-info">
									<div class="stat-value">${countUpdate}</div>
									<div class="stat-label">업데이트</div>
								</div>
							</div>
						</div>

						<div class="notice-controls">

							<c:if test="${requestScope.user != null and requestScope.user.userAdmin == 1}">
							    <a href="admin_notice_write" class="write-btn">
							        <i class="fas fa-pen"></i> 공지사항 작성
							    </a>
							</c:if>
						</div>

						<c:choose>
							<c:when test="${not empty noticeList}">
								<c:forEach items="${noticeList}" var="notice">
									<div class="notice-card">
										<a href="/admin_notice_detail?noticeNum=${notice.noticeNum}"
											class="notice-link">
											<div class="notice-content">
												<c:choose>
													<c:when test="${notice.noticeCategory == 'important'}">
														<span class="notice-category category-important">중요 공지</span>
													</c:when>
													<c:when test="${notice.noticeCategory == 'event'}">
														<span class="notice-category category-event">이벤트</span>
													</c:when>
													<c:when test="${notice.noticeCategory == 'info'}">
														<span class="notice-category category-info">안내</span>
													</c:when>
													<c:when test="${notice.noticeCategory == 'update'}">
														<span class="notice-category category-update">업데이트</span>
													</c:when>
												</c:choose>

												<h3 class="notice-title">
													${notice.noticeTitle}
												</h3>

												<p class="notice-excerpt">${notice.noticeContent }</p>

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
														<span>${notice.noticeViews}</span>
													</div>
												</div>
											</div>
										</a>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<div class="notice-empty">
									<div class="empty-icon">
										<i class="fas fa-clipboard"></i>
									</div>
									<div class="empty-text">등록된 공지사항이 없습니다.</div>
								</div>
							</c:otherwise>
						</c:choose>

<!--						<h3>${pageMaker}</h3>-->

						<div class="div_page">
							<ul>
								<c:if test="${pageMaker.prev}">
									<li class="paginate_button">
										<a href="${pageMaker.startPage - 1}">
											<i class="fas fa-caret-left"></i>
										</a>
									</li>
								</c:if>

								<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
									<li class="paginate_button ${pageMaker.noticeCriteriaDTO.pageNum==num ? 'active' : ''}">
										<a href="${num}">
											${num}
										</a>
									</li>
								</c:forEach>

								<c:if test="${pageMaker.next}">
									<li class="paginate_button">
										<a href="${pageMaker.endPage+1}">
											<i class="fas fa-caret-right"></i>
										</a>
									</li>
								</c:if>
							</ul>
						</div>
						<form id="actionForm" action="admin_notice" method="get">
							<input type="hidden" name="pageNum" value="${pageMaker.noticeCriteriaDTO.pageNum}">
							<input type="hidden" name="amount" value="${pageMaker.noticeCriteriaDTO.amount}">
							<c:if test="${not empty pageMaker.noticeCriteriaDTO.type}">
								<input type="hidden" name="type" value="${pageMaker.noticeCriteriaDTO.type}">
							</c:if>
							<c:if test="${not empty pageMaker.noticeCriteriaDTO.keyword}">
								<input type="hidden" name="keyword" value="${pageMaker.noticeCriteriaDTO.keyword}">
							</c:if>
						</form>
					</div>
					<script>
						// 페이징처리
						var actionForm = $("#actionForm");

						// 페이지번호 처리
						$(".paginate_button a").on("click", function (e) {
							e.preventDefault();
							console.log("click했음");
							console.log("@# href => " + $(this).attr("href"));

							// actionForm.find("input[name='pageNum']").val(this).attr("href");
							actionForm.find("input[name='pageNum']").val($(this).attr("href"));

							// 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 페이지 클릭 할 때 content_view2가 작동되는 것을 해결)
							actionForm.attr("action", "admin_notice").submit();
						}); // end of paginate_button click

						// 게시글 처리
						$(".move_link").on("click", function (e) {
							e.preventDefault();
							console.log("move_link click");
							console.log("@# click => " + $(this).attr("href"));

							var targetBno = $(this).attr("href");

							// 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 게시글 클릭 할 때 &boardNo=번호 게속 누적되는 거 방지)
							var bno = actionForm.find("input[name='noticeNum']").val();
							if (bno != "") {
								actionForm.find("input[name='noticeNum']").remove();
							}

							// "content_view?boardNo=${dto.boardNo}"를 actionForm로 처리
							actionForm.append("<input type='hidden' name='noticeNum' value='" + targetBno + "'>");
							// actionForm.submit();
							// 컨트롤러에 content_view로 찾아감
							actionForm.attr("action", "admin_notice_detail").submit();
						});
					</script>
				</body>

				</html>