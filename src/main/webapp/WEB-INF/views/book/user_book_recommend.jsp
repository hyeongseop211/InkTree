<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>도서 추천</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<link rel="stylesheet" type="text/css"
	href="/resources/css/user_book_recommend.css">
</head>
<body>
    <jsp:include page="../header.jsp" />

	<div class="container">
		<div class="recommendation-header">
			<div class="header-content">
				<h1 class="recommendation-title">
					<span class="title-icon"><i class="fas fa-book-reader"></i></span>
					<span class="title-text">맞춤 도서 추천 시스템</span>
				</h1>
				<p class="recommendation-subtitle">${loginUser.userName}님의 관심
					카테고리와 인기 도서를 기반으로 추천해드립니다.</p>
			</div>
		</div>

		<!-- 인기 대출 도서 폼 -->
		<form class="popular-form">
			<div class="form-header">
				<h2 class="form-title">
					<span class="title-icon"><i class="fas fa-star"></i></span> <span
						class="title-text">인기 대출 도서</span>
				</h2>
				<p class="form-description">가장 많이 대출된 인기 도서를 확인해보세요.</p>
			</div>

			<div class="book-carousel">
				<c:forEach items="${top3Borrow}" var="book" varStatus="status">
				<div class="book-card">
					<div class="book-cover">
						<img src="/resources/images/book1.png" alt="책1"
							style="width: 100%; height: 75%; object-fit: contain;">
						<div class="book-info">
							<div class="info-row">
								<div class="book-title" style="font-size: 20px; color: black; font-weight: bold;">제목 : ${book.bookTitle}</div>
								<div class="book-author">저자 : ${book.bookWrite}</div>
							</div>
							<div class="book-category">장르 : ${book.bookMajorCategory}</div>
							<div class="book-date">출판일 : ${book.bookDate}</div>
						</div>
					</div>
				</div>
				 </c:forEach>
			</div>
		</form>
		<!-- 주 카테고리 추천 폼 -->
		<form class="category-form">
			<div class="form-header">
				<h2 class="form-title">
					<span class="title-icon"><i class="fas fa-bookmark"></i></span> <span
						class="title-text">${topMajorCategory} 당신을 위한 추천</span>
				</h2>
				<p class="form-description">${loginUser.userName}님이 가장 많이 읽은 주요
					카테고리 기반 추천 도서입니다.</p>
			</div>

			<div class="book-carousel">
				<c:if test="${empty Top5Random}">
					<div class="empty-state">
						<div class="empty-icon">
							<i class="fas fa-book"></i>
						</div>
						<div class="empty-message">대출 기록이 없습니다</div>
						<a href="book_search_view" class="btn-outline">
							<i class="fas fa-search"></i> 도서 검색하기
						</a>
					</div>
				</c:if>
				<c:if test="${not empty Top5Random}">
				                 <c:forEach items="${Top5Recommend}" var="book">
									 <div class="book-card">
										 <div class="book-cover">
											 <img src="/resources/images/book1.png" alt="책1"
												  style="width: 100%; height: 75%; object-fit: contain;">
											 <div class="book-info">
												 <div class="info-row">
													 <div class="book-title" style="font-size: 20px; color: black; font-weight: bold;">제목 : ${book.bookTitle}</div>
													 <div class="book-author">저자 : ${book.bookWrite}</div>
												 </div>
												 <div class="book-category">장르 : ${book.bookSubCategory}</div>
												 <div class="book-date">출판일 : ${book.bookDate}</div>
											 </div>
										 </div>
									 </div>
				</c:forEach>

				</c:if>
			</div>
		</form>

		<!-- 서브 카테고리 추천 폼 -->
		<c:if test="${not empty Top5Random}">
		<form class="category-form">
			<div class="form-header">
				<h2 class="form-title">
					<span class="title-icon"><i class="fas fa-tags"></i></span> <span
						class="title-text">${topSubCategory} 이런 건 어떠세요</span>
				</h2>
				<p class="form-description">${loginUser.userName}님이 관심이 있을 수도 있는
					책리스트 입니다.</p>
			</div>

			<div class="book-carousel">

				<c:if test="${not empty Top5Random}">
				<c:forEach items="${Top5Random}" var="book">
					<div class="book-card">
						<div class="book-cover">
							<img src="/resources/images/book1.png" alt="책1"
								 style="width: 100%; height: 75%; object-fit: contain;">
							<div class="book-info">
								<div class="info-row">
									<div class="book-title" style="font-size: 20px; color: black; font-weight: bold;">제목 : ${book.bookTitle}</div>
									<div class="book-author">저자 : ${book.bookWrite}</div>
								</div>
								<div class="book-category">장르 : ${book.bookMajorCategory}</div>
								<div class="book-date">출판일 : ${book.bookDate}</div>
							</div>
						</div>
					</div>
				</c:forEach>

				</c:if>
			</div>
		</form>
		</c:if>
	</div>
</body>
</html>
