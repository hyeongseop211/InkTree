<%@page import="com.boot.book.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 관심 도서 - 잉크 트리</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<link rel="stylesheet" type="text/css"
	href="/resources/css/book_wishlist.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/board_view.css">
<script type="text/javascript">
	// 위시리스트에서 책 삭제 함수
	function removeFromWishlist(event, bookNumber) {
		// 이벤트 버블링 방지
		event.stopPropagation();
		
		$.ajax({
			type: "post",
			url: "/remove_wishlist",
			data: {
				bookNumber: bookNumber
			},
			dataType: "text",
			success: function(response) {
				console.log("위시리스트 삭제 응답:", response);
				if (response === "Success") {
					// 버튼 스타일 변경
					const statusBtn = event.target;
					statusBtn.classList.add('removed');
					statusBtn.innerHTML = '<i class="fas fa-check"></i> 삭제 완료';
					
					// 카드에 삭제된 상태 표시
					const bookItem = statusBtn.closest('.book-item');
					bookItem.classList.add('removed-item');
				} else if (response === "not_exists") {
					alert("이미 위시리스트에서 삭제되었습니다.");
				} else if (response === "Not_login") {
					alert("로그인이 필요합니다.");
				} else {
					alert("오류가 발생했습니다: " + response);
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				console.error('위시리스트 삭제 오류:', xhr.status);
				console.error('상태:', textStatus);
				console.error('에러:', errorThrown);
				alert("서버 오류가 발생했습니다.");
			}
		});
	}
	
	// 애니메이션 효과 처리 함수
	function initializePageEffects() {
		// 애니메이션 효과 추가
		const bookItems = document.querySelectorAll('.book-item');
		bookItems.forEach((item, index) => {
			setTimeout(() => {
				item.classList.add('show');
			}, 100 * index);
		});
		
		// 알림 메시지 처리
		const errorMsg = "${errorMsg}";
		
		if (errorMsg && errorMsg !== "") {
			alert(errorMsg);
		}
	}
	
	// 페이지 로드 시 실행
	window.addEventListener('DOMContentLoaded', function() {
		initializePageEffects();
	});
</script>
</head>
<body>
    <jsp:include page="../header.jsp" />
	
	<div class="container">
    <div class="borrowed-header">
        <div class="header-content">
            <h2 class="borrowed-title">
                <span class="title-icon"><i class="fas fa-heart"></i></span>
                내 찜한 도서 목록
            </h2>
            <p class="borrowed-subtitle">찜한 도서들을 모아놓은 공간입니다. 마음에 드는 책이 있으면 대출해보세요!</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty wishlist}">
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-box-open"></i></div>
                <div class="empty-message">아직 관심 도서가 없습니다.</div>
                <a href="/" class="btn-outline"><i class="fas fa-home"></i> 홈으로 돌아가기</a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="book-list">
                <c:forEach var="book" items="${wishlist}">
                    <div class="book-item show" onclick="location.href='/book_detail?bookNumber=${book.bookNumber}'" style="cursor: pointer;">
                        <div class="status-borrowed" onclick="removeFromWishlist(event, '${book.bookNumber}')">찜 완료</div>
                        <div class="book-cover">
                            <div class="book-cover-placeholder">📖</div>
                        </div>
                        <div class="book-info">
                            <div class="book-title">${book.bookTitle}</div>
                            <div class="book-author">${book.bookWrite}</div>
                            <div class="book-dates">
                                <span class="book-pub"><strong>출판사:</strong> ${book.bookPub}</span>
                                <span class="book-category"><strong>카테고리:</strong> ${book.bookMajorCategory}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 페이징 영역 -->
            <div class="div_page">
                <ul>
                    <c:if test="${pageMaker.prev}">
                        <li class="paginate_button">
                            <a href="?page=${pageMaker.startPage - 1}">&laquo;</a>
                        </li>
                    </c:if>

                    <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="i">
                        <li class="paginate_button ${pageMaker.wishlistCriteriaDTO.page == i ? 'active' : ''}">
                            <a href="?page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${pageMaker.next}">
                        <li class="paginate_button">
                            <a href="?page=${pageMaker.endPage + 1}">&raquo;</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>