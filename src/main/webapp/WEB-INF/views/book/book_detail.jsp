<%@page import="com.boot.book.dto.BookDTO"%>
<%@page import="com.boot.user.dto.UserDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.bookTitle} - 도서 상세</title>
    
    <!-- 폰트 및 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/resources/css/board_view.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/book_detail.css">
</head>

<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-book-open"></i> 도서 상세
            </h1>
            <a href="javascript:history.back()" class="back-link">
                <i class="fas fa-arrow-left"></i> 목록으로 돌아가기
            </a>
        </div>

        <div class="book-detail fade-in">
            <!-- 좌측 사이드바 -->
            <div class="book-sidebar">
				<div class="book-title-container">
				    <h2 class="book-title">${book.bookTitle}</h2>

				    <c:if test="${not empty requestScope.user and requestScope.user.userAdmin == 1}">
				        <div class="admin-menu-container">
				            <button type="button" class="admin-menu-button" onclick="toggleAdminMenu()" aria-label="관리자 메뉴">
				                <i class="fa-solid fa-gear"></i>
				            </button>
				            <div class="admin-menu-dropdown" id="adminMenuDropdown">
				                <a href="/update_book?bookNumber=${book.bookNumber}" class="admin-menu-item">
				                    <i class="fas fa-edit"></i> 도서 정보 수정
				                </a>
				                <button type="button" class="admin-menu-item danger" onclick="confirmDelete(${book.bookNumber})">
				                    <i class="fas fa-trash"></i> 도서 삭제
				                </button>
				            </div>
				        </div>
				    </c:if>
				</div>

                
                <p class="book-author">${book.bookWrite}</p>
                
                <div class="book-categories">
                    <span class="book-category">${book.bookMajorCategory}</span>
                    <c:if test="${not empty book.bookSubCategory}">
                        <span class="book-category">${book.bookSubCategory}</span>
                    </c:if>
                </div>
                
                <div class="book-image-section">
                    <div class="book-cover">
                        <!-- 실제 구현 시 도서 이미지 경로를 사용해야함 -->
                        <!-- <img src="/resources/images/books/${book.bookNumber}.jpg" alt="${book.bookTitle}" 
                            onerror="this.style.display='none'; document.getElementById('placeholder-${book.bookNumber}').style.display='flex';"> -->
                        <div class="book-cover-placeholder" id="placeholder-${book.bookNumber}">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>

                    <div class="book-status">
                        <div class="status-badge ${book.bookCount > 0 ? 'available' : 'unavailable'}">
                            <c:choose>
                                <c:when test="${book.bookCount > 0}">
                                    <i class="fas fa-check-circle"></i> 대출 가능
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-times-circle"></i> 대출 불가
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="status-badge count-badge">
                            <i class="fas fa-book"></i> 보유: ${book.bookCount}권
                        </div>
                        <div class="status-badge count-badge">
                            <i class="fas fa-chart-line"></i> 대출: ${book.bookBorrowcount}회
                        </div>
                    </div>

                    <div class="book-info-grid">
                        <div class="book-meta-item">
                            <span class="meta-label">출판사</span>
                            <span class="meta-value">${book.bookPub}</span>
                        </div>
                        <div class="book-meta-item">
                            <span class="meta-label">출판일</span>
                            <span class="meta-value">
                                <fmt:formatDate value="${book.bookDate}" pattern="yyyy.MM.dd" />
                            </span>
                        </div>
                        <div class="book-meta-item">
                            <span class="meta-label">ISBN</span>
                            <span class="meta-value">${book.bookIsbn}</span>
                        </div>
                    </div>

                    <div class="book-actions">
                        <c:choose>
                            <c:when test="${book.bookCount > 0}">
                                <button class="action-button primary-button" onclick="borrowBook(${book.bookNumber})">
                                    <i class="fas fa-hand-holding"></i> 대출하기
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button class="action-button primary-button" disabled>
                                    <i class="fas fa-hand-holding"></i> 대출 불가
                                </button>
                            </c:otherwise>
                        </c:choose>
						<button class="action-button secondary-button" onclick="addToWishlist('${book.bookNumber}')">
						    <i class="fas fa-heart"></i> 위시리스트에 추가
						</button>
                    </div>
                </div>
            </div>

            <!-- 우측 콘텐츠 영역 -->
            <div class="book-content">
                <div class="tabs">
                    <ul class="tab-list" role="tablist">
                        <li class="tab-item active" role="tab" aria-selected="true" data-tab="description">도서 소개</li>
                        <li class="tab-item" role="tab" aria-selected="false" data-tab="reviews">리뷰 및 평점</li>
                    </ul>

                    <div class="tab-content">
                        <div id="description" class="tab-panel active" role="tabpanel">
                            <div class="book-description">
                                <p>${book.bookComent}</p>
                            </div>
                        </div>

                        <div id="reviews" class="tab-panel" role="tabpanel">
                            <div class="reviews-section">
								<div class="review-stats">
								    <div class="average-rating">
								        <div class="rating-value">${reviewStats.averageRating}</div>
								        <div class="rating-stars">
								            <c:forEach begin="1" end="5" var="i">
								                <c:choose>
								                    <c:when test="${i <= Math.floor(reviewStats.averageRating)}">
								                        <i class="fas fa-star"></i>
								                    </c:when>
								                    <c:when test="${i == Math.ceil(reviewStats.averageRating) && reviewStats.averageRating % 1 != 0}">
								                        <i class="fas fa-star-half-alt"></i>
								                    </c:when>
								                    <c:otherwise>
								                        <i class="far fa-star"></i>
								                    </c:otherwise>
								                </c:choose>
								            </c:forEach>
								        </div>
								        <div class="rating-count">총 ${reviewStats.totalReviews}개 리뷰</div>
								    </div>
								    <div class="rating-distribution">
								        <div class="rating-bar">
								            <span class="rating-label">5</span>
								            <div class="rating-progress">
								                <div class="rating-progress-fill" style="width: ${reviewStats.fiveStarPercentage}%"></div>
								            </div>
								            <span class="rating-percent">${reviewStats.fiveStarPercentage}%</span>
								        </div>
								        <div class="rating-bar">
								            <span class="rating-label">4</span>
								            <div class="rating-progress">
								                <div class="rating-progress-fill" style="width: ${reviewStats.fourStarPercentage}%"></div>
								            </div>
								            <span class="rating-percent">${reviewStats.fourStarPercentage}%</span>
								        </div>
								        <div class="rating-bar">
								            <span class="rating-label">3</span>
								            <div class="rating-progress">
								                <div class="rating-progress-fill" style="width: ${reviewStats.threeStarPercentage}%"></div>
								            </div>
								            <span class="rating-percent">${reviewStats.threeStarPercentage}%</span>
								        </div>
								        <div class="rating-bar">
								            <span class="rating-label">2</span>
								            <div class="rating-progress">
								                <div class="rating-progress-fill" style="width: ${reviewStats.twoStarPercentage}%"></div>
								            </div>
								            <span class="rating-percent">${reviewStats.twoStarPercentage}%</span>
								        </div>
								        <div class="rating-bar">
								            <span class="rating-label">1</span>
								            <div class="rating-progress">
								                <div class="rating-progress-fill" style="width: ${reviewStats.oneStarPercentage}%"></div>
								            </div>
								            <span class="rating-percent">${reviewStats.oneStarPercentage}%</span>
								        </div>
								    </div>
								</div>

                                <div class="review-form">
                                    <h3 class="form-title">리뷰 작성하기</h3>
                                    <form id="reviewForm">
										<input type="hidden" name="reviewId" id="reviewId" value="">
										<input type="hidden" name="bookNumber" id="bookNumberInput" value="${book.bookNumber}">
                                        <div class="form-group">
<!--                                            <label class="form-label">평점</label>-->
                                            <div class="rating-input">
                                                <i class="far fa-star" data-rating="1"></i>
                                                <i class="far fa-star" data-rating="2"></i>
                                                <i class="far fa-star" data-rating="3"></i>
                                                <i class="far fa-star" data-rating="4"></i>
                                                <i class="far fa-star" data-rating="5"></i>
                                            </div>
                                            <input type="hidden" name="rating" id="ratingInput" value="0">
                                        </div>
                                        <div class="form-group">
<!--                                            <label class="form-label" for="reviewTitle">제목</label>-->
                                            <input type="text" class="form-control" id="reviewTitle" name="title" placeholder="리뷰 제목을 입력하세요" required>
                                        </div>
                                        <div class="form-group">
<!--                                            <label class="form-label" for="reviewContent">내용</label>-->
                                            <textarea class="form-control" id="reviewContent" name="content" placeholder="리뷰 내용을 입력하세요" required></textarea>
                                        </div>
										<div class="form-actions">
											<button type="button" class="action-button secondary-button" onclick="resetReviewForm()">초기화</button>
										    <button type="button" class="action-button primary-button" onclick="submitReview()">리뷰 등록</button>
										</div>
                                    </form>
                                </div>

								<div class="reviews-list">
									<!-- 리뷰 목록 반복 -->
									<c:forEach var="review" items="${reviewList}">
										<div class="review-card">
											<input type="hidden" class="review-id-hidden" value="${review.reviewId}">
											    <div class="review-header">
											        <div class="reviewer-info">
											            <div class="reviewer-name-date">
											                <span class="reviewer-name">${review.userName}</span>
											                <span class="review-date"><fmt:formatDate value="${review.reviewDate}" pattern="yyyy-MM-dd" /></span>
											            </div>
											        </div>
											        <div class="review-actions-top">
											            <span class="helpful-container">
															<i class="${review.helpfulByCurrentUser ? 'fas' : 'far'} fa-thumbs-up review-action-icon like ${review.helpfulByCurrentUser ? 'active' : ''}" 
															   onclick="markHelpful(${review.reviewId}, this)" 
															   title="도움됨"></i>
											                <span class="helpful-count">${review.helpfulCount}</span>
											            </span>
											            <c:if test="${user.userNumber == review.userNumber || user.userAdmin == 1}">
											                <i class="fas fa-edit review-action-icon edit" 
											                   title="수정"></i>
											                <i class="fas fa-trash-alt review-action-icon delete" 
											                   onclick="confirmDeleteReview(${review.reviewId})" 
											                   title="삭제"></i>
											            </c:if>
											        </div>
											    </div>
										    <div class="review-rating">
										        <c:forEach begin="1" end="5" var="i">
										            <c:choose>
										                <c:when test="${i <= review.reviewRating}">
										                    <i class="fas fa-star"></i>
										                </c:when>
										                <c:otherwise>
										                    <i class="far fa-star"></i>
										                </c:otherwise>
										            </c:choose>
										        </c:forEach>
										    </div>
										    
										    <div class="review-title-rating">
										        <h4 class="review-title">${review.reviewTitle}</h4>
										    </div>
										    
										    <div class="review-content">
										        <p>${review.reviewContent}</p>
										    </div>
										</div>
									</c:forEach>

									<!-- <h3>${pageMaker}</h3> -->

									<div class="div_page">
									    <ul>
									        <c:if test="${pageMaker.prev}">
									            <li class="paginate_button">
									                <a href="${pageMaker.startPage - 1}">
									                    <i class="fas fa-caret-left"></i>
									                </a>
									            </li>
									        </c:if>

									        <c:forEach var="num" begin="${pageMaker.startPage}"
									            end="${pageMaker.endPage}">
									            <li
									                class="paginate_button ${pageMaker.noticeCriteriaDTO.pageNum==num ? 'active' : ''}">
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
									<form id="actionForm" action="book_detail" method="get">
									    <input type="hidden" name="pageNum" value="${pageMaker.noticeCriteriaDTO.pageNum}">
									    <input type="hidden" name="amount" value="${pageMaker.noticeCriteriaDTO.amount}">
									    <input type="hidden" name="bookNumber" value="${book.bookNumber}">
									    <c:if test="${not empty pageMaker.noticeCriteriaDTO.type}">
									        <input type="hidden" name="type" value="${pageMaker.noticeCriteriaDTO.type}">
									    </c:if>
									    <c:if test="${not empty pageMaker.noticeCriteriaDTO.keyword}">
									        <input type="hidden" name="keyword" value="${pageMaker.noticeCriteriaDTO.keyword}">
									    </c:if>
									</form>
									<!-- 리뷰가 없는 경우 메시지 표시 -->
									<c:if test="${empty reviewList}">
									    <div class="no-reviews">
									        <div class="no-reviews-content">
									            <div class="no-reviews-icon">
									                <i class="fas fa-comment-slash"></i>
									            </div>
									            <h3 class="no-reviews-title">아직 등록된 리뷰가 없습니다</h3>
									            <p class="no-reviews-message">이 책에 대한 첫 번째 리뷰를 작성해보세요!</p>
									        </div>
									    </div>
									</c:if>
									
								</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 알림 모달 -->
    <div id="alertModal" class="modal">
        <div class="modal-content">
            <div id="modalIcon" class="modal-icon success">
                <i class="fas fa-check-circle"></i>
            </div>
            <h3 id="modalTitle" class="modal-title">알림</h3>
            <p id="modalMessage" class="modal-message"></p>
            <div class="modal-actions">
                <button id="modalButton" class="action-button primary-button" onclick="closeModal()">확인</button>
            </div>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon error">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 class="modal-title">도서 삭제</h3>
            <p class="modal-message">정말로 이 도서를 삭제하시겠습니까?</p>
            <div class="modal-actions">
                <button class="action-button secondary-button" onclick="closeDeleteModal()">취소</button>
                <button class="action-button danger-button" onclick="deleteBook()">삭제</button>
            </div>
        </div>
    </div>
    
    <!-- 리뷰 삭제 확인 모달 -->
    <div id="deleteReviewModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon error">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 class="modal-title">리뷰 삭제</h3>
            <p class="modal-message">정말로 이 리뷰를 삭제하시겠습니까?</p>
            <div class="modal-actions">
                <button class="action-button secondary-button" onclick="closeDeleteReviewModal()">취소</button>
                <button class="action-button danger-button" onclick="deleteReview()">삭제</button>
            </div>
        </div>
    </div>

    <!-- 폼 (AJAX 요청용) -->
    <form id="borrowForm" style="display: none;">
        <input type="hidden" name="bookNumber" id="borrowBookNumber" value="">
    </form>

    <form id="deleteForm" style="display: none;">
        <input type="hidden" name="bookNumber" id="deleteBookNumber" value="">
    </form>
    
    <input type="hidden" id="deleteReviewId" value="">

    <script>
		const isLoggedIn = ${requestScope.user != null ? 'true' : 'false'};
		// 리뷰 수정 관련 JavaScript 코드 - 별 아이콘 유지 버전
		$(document).ready(function() {
		    // 리뷰 수정 버튼 클릭 이벤트
		    $(document).on('click', '.review-action-icon.edit', function(e) {
		        e.preventDefault();
		        
		        // 리뷰 카드와 리뷰 ID 찾기
		        var reviewCard = $(this).closest('.review-card');
		        var reviewId = reviewCard.find('.review-id-hidden').val();
		        
		        console.log('수정 버튼 클릭, 리뷰 ID:', reviewId);
		        
		        // 현재 리뷰 데이터 가져오기
		        var reviewTitle = reviewCard.find('.review-title').text().trim();
		        var reviewContent = reviewCard.find('.review-content p').text().trim();
		        
		        // 별점 계산 - 채워진 별의 개수 세기
		        var reviewRating = reviewCard.find('.review-rating .fas.fa-star').length;
		        console.log('현재 별점:', reviewRating);
		        
		        // 원래 내용 저장 (취소 시 복원용)
		        reviewCard.data('originalTitle', reviewTitle);
		        reviewCard.data('originalContent', reviewContent);
		        reviewCard.data('originalRating', reviewRating);
		        
		        // 리뷰 제목을 입력 필드로 변경
		        var titleInput = $('<input>').attr({
		            'type': 'text',
		            'class': 'edit-review-title',
		            'value': reviewTitle,
		            'placeholder': '리뷰 제목'
		        });
		        reviewCard.find('.review-title').empty().append(titleInput);
		        
		        // 리뷰 내용을 텍스트 영역으로 변경
		        var contentTextarea = $('<textarea>').attr({
		            'class': 'edit-review-content',
		            'placeholder': '리뷰 내용'
		        }).text(reviewContent);
		        reviewCard.find('.review-content').empty().append(contentTextarea);
		        
		        // 별점 편집 UI 추가 - 별 아이콘 방식
		        var ratingDiv = $('<div>').attr('class', 'edit-rating');
		        
		        // 별점 값을 저장할 hidden input 추가
		        var ratingInput = $('<input>').attr({
		            'type': 'hidden',
		            'id': 'edit-rating-value',
		            'value': reviewRating
		        });
		        
		        // 별 아이콘 추가
		        for (var i = 1; i <= 5; i++) {
		            var starClass = (i <= reviewRating) ? 'fas fa-star' : 'far fa-star';
		            var star = $('<i>').attr({
		                'class': starClass + ' edit-star',
		                'data-value': i
		            });
		            ratingDiv.append(star);
		        }
		        
		        reviewCard.find('.review-rating').empty().append(ratingDiv).append(ratingInput);
		        
		        // 별점 클릭 이벤트 바인딩
		        reviewCard.find('.edit-star').on('click', function() {
		            var value = $(this).data('value');
		            console.log('별점 클릭:', value);
		            
		            // 별점 UI 업데이트
		            reviewCard.find('.edit-star').each(function(index) {
		                if (index < value) {
		                    $(this).removeClass('far').addClass('fas');
		                } else {
		                    $(this).removeClass('fas').addClass('far');
		                }
		            });
		            
		            // 별점 값 저장
		            reviewCard.find('#edit-rating-value').val(value);
		        });
		        
		        // 수정 완료/취소 버튼 추가
		        var cancelButton = $('<button>').attr({
		            'type': 'button',
		            'class': 'action-button secondary-button cancel-edit'
		        }).text('취소');
		        
		        var saveButton = $('<button>').attr({
		            'type': 'button',
		            'class': 'action-button primary-button save-edit',
		            'data-review-id': reviewId
		        }).text('저장');
		        
		        var actionsDiv = $('<div>').attr('class', 'edit-actions')
		            .append(cancelButton)
		            .append(saveButton);
		        
		        reviewCard.find('.review-content').append(actionsDiv);
		        
		        // 수정 모드 표시
		        reviewCard.addClass('editing');
		    });
		    
		    // 취소 버튼 클릭 이벤트
		    $(document).on('click', '.cancel-edit', function() {
		        var reviewCard = $(this).closest('.review-card');
		        
		        // 원래 데이터 복원
		        var originalTitle = reviewCard.data('originalTitle');
		        var originalContent = reviewCard.data('originalContent');
		        var originalRating = reviewCard.data('originalRating');
		        
		        // 제목 복원
		        reviewCard.find('.review-title').html(originalTitle);
		        
		        // 내용 복원
		        reviewCard.find('.review-content').html('<p>' + originalContent + '</p>');
		        
		        // 별점 복원
		        var ratingHtml = '';
		        for (var i = 1; i <= 5; i++) {
		            if (i <= originalRating) {
		                ratingHtml += '<i class="fas fa-star"></i>';
		            } else {
		                ratingHtml += '<i class="far fa-star"></i>';
		            }
		        }
		        reviewCard.find('.review-rating').html(ratingHtml);
		        
		        // 수정 모드 해제
		        reviewCard.removeClass('editing');
		    });
		    
		    // 저장 버튼 클릭 이벤트 - AJAX 직접 사용
		    $(document).on('click', '.save-edit', function() {
		        var reviewCard = $(this).closest('.review-card');
		        var reviewId = $(this).data('review-id');
		        
		        // 수정된 데이터 가져오기
		        var editedTitle = reviewCard.find('.edit-review-title').val();
		        var editedContent = reviewCard.find('.edit-review-content').val();
		        
		        // 별점 값 가져오기
		        var editedRating = parseInt(reviewCard.find('#edit-rating-value').val());
		        console.log('저장할 별점:', editedRating);
		        
		        // 유효성 검사
		        if (!editedTitle || !editedTitle.trim()) {
		            alert('리뷰 제목을 입력해주세요.');
		            return;
		        }
		        
		        if (!editedContent || !editedContent.trim()) {
		            alert('리뷰 내용을 입력해주세요.');
		            return;
		        }
		        
		        // 별점 유효성 검사
		        if (isNaN(editedRating) || editedRating < 1 || editedRating > 5) {
		            alert('유효한 별점을 선택해주세요.');
		            return;
		        }
		        
		        // AJAX로 전송
		        $.ajax({
		            type: "post",
		            url: "updateReview",
		            data: {
		                reviewId: reviewId,
		                reviewTitle: editedTitle,
		                reviewContent: editedContent,
		                reviewRating: editedRating,
		                bookNumber: $('input[name="bookNumber"]').val()
		            },
		            success: function(response) {
		                console.log('서버 응답:', response);
		                
		                if (response.success) {
		                    // 성공 시 UI 업데이트
		                    reviewCard.find('.review-title').html(editedTitle);
		                    reviewCard.find('.review-content').html('<p>' + editedContent + '</p>');
		                    
		                    // 별점 업데이트
		                    var ratingHtml = '';
		                    for (var i = 1; i <= 5; i++) {
		                        if (i <= editedRating) {
		                            ratingHtml += '<i class="fas fa-star"></i>';
		                        } else {
		                            ratingHtml += '<i class="far fa-star"></i>';
		                        }
		                    }
		                    reviewCard.find('.review-rating').html(ratingHtml);
		                    
		                    // 수정 모드 해제
		                    reviewCard.removeClass('editing');
		                    
		                    // 성공 메시지 표시
		                    showModal('success', '리뷰 수정 완료', '리뷰가 성공적으로 수정되었습니다.');
		                } else {
		                    showModal('error', '수정 실패', response.message || '리뷰 수정에 실패했습니다.');
		                }
		            },
		            error: function(xhr, status, error) {
		                console.error("AJAX 오류:", status, error);
		                
		                var errorMessage = '리뷰 수정 중 오류가 발생했습니다.';
		                try {
		                    var response = JSON.parse(xhr.responseText);
		                    if (response.message) {
		                        errorMessage = response.message;
		                    }
		                } catch (e) {
		                    console.error('JSON 파싱 오류:', e);
		                }
		                
		                showModal('error', '오류 발생', errorMessage);
		            }
		        });
		    });
		    
		    // 별점 표시를 위한 CSS 추가
		    var starRatingStyles = `
		    .edit-rating {
		        margin-bottom: 15px;
		    }
		    .edit-star {
		        cursor: pointer;
		        font-size: 20px;
		        color: #ffc107;
		        margin-right: 5px;
		        transition: all 0.2s ease;
		    }
		    .edit-star:hover {
		        transform: scale(1.2);
		    }
		    .edit-actions {
		        display: flex;
		        justify-content: flex-end;
		        gap: 10px;
		        margin-top: 15px;
		    }
		    .cancel-edit, .save-edit {
		        padding: 6px 12px;
		        font-size: 14px;
		    }
		    `;
		    
		    // 스타일 태그가 이미 있는지 확인
		    if (!$('#starRatingStyles').length) {
		        $('<style id="starRatingStyles">' + starRatingStyles + '</style>').appendTo('head');
		    }
		});
		
		
		
		
		
		
		
		
		
		
		// 페이징처리
		var actionForm = $("#actionForm");

		// 페이징처리 - AJAX로 변경하여 새로고침 방지
		$(".paginate_button a").on("click", function (e) {
		    e.preventDefault();
		    console.log("페이지 클릭");
		    
		    // 페이지 번호 가져오기
		    const pageNum = $(this).attr("href");
		    
		    // 현재 활성화된 탭을 세션 스토리지에 저장
		    sessionStorage.setItem("activeTab", "reviews");
		    
		    // 페이지 번호 업데이트
		    actionForm.find("input[name='pageNum']").val(pageNum);
			// 현재 활성화된 탭을 세션 스토리지에 저장
			sessionStorage.setItem("activeTab", "reviews");
		    // AJAX 요청으로 리뷰 목록만 업데이트
		    $.ajax({
		        type: "get",
		        url: "book_detail",
		        data: actionForm.serialize(),
		        success: function(response) {
		            // 응답에서 리뷰 목록 부분만 추출
		            const reviewsHtml = $(response).find('.reviews-list').html();
		            const paginationHtml = $(response).find('.div_page').html();
		            
		            // 리뷰 목록과 페이지네이션 업데이트
		            $('.reviews-list').html(reviewsHtml);
		            $('.div_page').html(paginationHtml);
		            
		            // 페이지네이션 이벤트 다시 바인딩
		            bindPaginationEvents();
		            
		            // 현재 페이지 버튼 활성화
		            $('.paginate_button').removeClass('active');
		            $(`.paginate_button a[href="${pageNum}"]`).parent().addClass('active');
		        },
		        error: function() {
		            showModal('error', '오류 발생', '페이지 로드 중 오류가 발생했습니다.');
		        }
		    });
		});

		// 페이지네이션 이벤트 바인딩 함수 개선
		function bindPaginationEvents() {
		    $(".paginate_button a").off("click").on("click", function (e) {
		        e.preventDefault();
		        console.log("페이지 클릭");
		        
		        // 페이지 번호 가져오기
		        const pageNum = $(this).attr("href");
		        console.log("클릭한 페이지 번호:", pageNum);
		        
		        // 현재 활성화된 탭을 세션 스토리지에 저장
		        sessionStorage.setItem("activeTab", "reviews");
		        
		        // 페이지 번호 업데이트
		        actionForm.find("input[name='pageNum']").val(pageNum);
		        
		        // AJAX 요청으로 리뷰 목록만 업데이트
		        $.ajax({
		            type: "get",
		            url: "book_detail",
		            data: actionForm.serialize(),
		            success: function(response) {
		                // 응답에서 리뷰 목록 부분만 추출
		                const reviewsHtml = $(response).find('.reviews-list').html();
		                const paginationHtml = $(response).find('.div_page').html();
		                
		                // 리뷰 목록과 페이지네이션 업데이트
		                $('.reviews-list').html(reviewsHtml);
		                $('.div_page').html(paginationHtml);
		                
		                // 페이지네이션 이벤트 다시 바인딩
		                bindPaginationEvents();
		                
		                // 현재 페이지 버튼 활성화
		                $('.paginate_button').removeClass('active');
		                $(`.paginate_button a[href="${pageNum}"]`).parent().addClass('active');
		                
		                // 도움됨 버튼 상태 업데이트
		                updateHelpfulButtonsUI();
		            },
		            error: function() {
		                showModal('error', '오류 발생', '페이지 로드 중 오류가 발생했습니다.');
		            }
		        });
		    });
		}

		// 도움됨 버튼 UI 업데이트 함수
		function updateHelpfulButtonsUI() {
		    // 모든 도움됨 버튼 확인
		    $('.review-card').each(function() {
		        const likeButton = $(this).find('.review-action-icon.like');
		        
		        // 서버에서 받은 active 클래스 확인
		        if (likeButton.hasClass('active')) {
		            // 아이콘 클래스 업데이트 (far -> fas)
		            likeButton.removeClass('far').addClass('fas');
		        } else {
		            // 아이콘 클래스 업데이트 (fas -> far)
		            likeButton.removeClass('fas').addClass('far');
		        }
		    });
		}

		// 도움됨 버튼 기능 개선
		function markHelpful(reviewId, element) {
		    // 로그인 확인
			if (!isLoggedIn) {
			    showModal('error', '로그인 필요', '도움됨 기능은 로그인 후 이용 가능합니다.');
			    return;
			}
		    
		    // 이미 활성화된 경우 취소, 아니면 활성화
		    const isActive = $(element).hasClass('active');
		    
		    $.ajax({
		        type: "post",
		        url: isActive ? "review_unhelpful" : "review_helpful",
		        data: { reviewId: reviewId },
		        success: function(response) {
		            if (response.success) {
		                // UI 업데이트
		                if (isActive) {
		                    // 도움됨 취소
		                    $(element).removeClass('active fas').addClass('far');
		                } else {
		                    // 도움됨 추가
		                    $(element).removeClass('far').addClass('fas active');
		                }
		                
		                // 도움됨 개수 업데이트
		                const helpfulCountElement = $(element).closest('.helpful-container').find('.helpful-count');
		                if (helpfulCountElement.length > 0) {
		                    helpfulCountElement.text(response.helpfulCount);
		                }
		                
		                // 로컬 스토리지에 상태 저장 (선택적)
		                saveHelpfulState(reviewId, !isActive);
		            } else {
		                showModal('error', '오류 발생', response.message || '도움됨 처리 중 오류가 발생했습니다.');
		            }
		        },
		        error: function(xhr) {
		            let errorMessage = '서버 통신 중 오류가 발생했습니다.';
		            try {
		                const response = JSON.parse(xhr.responseText);
		                if (response.message) {
		                    errorMessage = response.message;
		                }
		            } catch (e) {
		                console.error('JSON 파싱 오류:', e);
		            }
		            showModal('error', '오류 발생', errorMessage);
		        }
		    });
		}

		// 로컬 스토리지에 도움됨 상태 저장 (선택적)
		function saveHelpfulState(reviewId, isHelpful) {
		    const userNumber = ${user.userNumber};
		    const storageKey = `helpful_${userNumber}`;
		    
		    // 기존 데이터 가져오기
		    let helpfulData = JSON.parse(localStorage.getItem(storageKey) || '{}');
		    
		    // 리뷰 ID를 키로 사용하여 상태 저장
		    helpfulData[reviewId] = isHelpful;
		    
		    // 로컬 스토리지에 저장
		    localStorage.setItem(storageKey, JSON.stringify(helpfulData));
		}

		// 로컬 스토리지에서 도움됨 상태 복원 (선택적)
		function restoreHelpfulState() {
		    const userNumber = ${user.userNumber};
		    const storageKey = `helpful_${userNumber}`;
		    
		    // 저장된 데이터 가져오기
		    const helpfulData = JSON.parse(localStorage.getItem(storageKey) || '{}');
		    
		    // 모든 도움됨 버튼에 상태 적용
		    $('.review-card').each(function() {
		        const reviewId = $(this).find('.review-id-hidden').val();
		        const likeButton = $(this).find('.review-action-icon.like');
		        
		        // 서버에서 받은 active 클래스 확인
		        if (likeButton.hasClass('active')) {
		            // 아이콘 클래스 업데이트 (far -> fas)
		            likeButton.removeClass('far').addClass('fas');
		        } 
		        // 로컬 스토리지에 저장된 상태 확인 (서버 상태가 우선)
		        else if (helpfulData[reviewId]) {
		            likeButton.addClass('active');
		            likeButton.removeClass('far').addClass('fas');
		        }
		    });
		}

		// 페이지 로드 시 이벤트 바인딩 및 초기화
		$(document).ready(function() {
		    // 페이지네이션 이벤트 바인딩
		    bindPaginationEvents();
		    
		    // 현재 페이지 번호 가져오기
		    const currentPage = actionForm.find("input[name='pageNum']").val();
		    
		    // 현재 페이지 버튼 활성화
		    if (currentPage) {
		        $('.paginate_button').each(function() {
		            const link = $(this).find('a');
		            if (link.length && link.attr('href') === currentPage) {
		                $(this).addClass('active');
		            }
		        });
		    }
		    
		    // 도움됨 버튼 UI 업데이트
		    updateHelpfulButtonsUI();
		    
		    // 로컬 스토리지에서 도움됨 상태 복원 (선택적)
		    restoreHelpfulState();
		});

		// 도움됨 버튼 클래스 수정 (JSP 코드 수정 필요)
		// <i class="far fa-thumbs-up review-action-icon like ${review.helpfulByCurrentUser ? 'active' : ''}" 
		// 위 코드를 아래와 같이 수정:
		// <i class="${review.helpfulByCurrentUser ? 'fas' : 'far'} fa-thumbs-up review-action-icon like ${review.helpfulByCurrentUser ? 'active' : ''}"

		// 페이지 로드 시 페이지네이션 이벤트 바인딩
		$(document).ready(function() {
		    bindPaginationEvents();
		});
        
        // 페이지 로드 시 탭 상태 복원
        document.addEventListener('DOMContentLoaded', function() {
            // 세션 스토리지에서 활성 탭 확인
            const activeTab = sessionStorage.getItem("activeTab");
            if (activeTab === "reviews") {
                // 리뷰 탭 활성화
                document.querySelectorAll('.tab-item').forEach(tab => {
                    tab.classList.remove('active');
                    if (tab.dataset.tab === 'reviews') {
                        tab.classList.add('active');
                    }
                });
                
                // 리뷰 패널 표시
                document.querySelectorAll('.tab-panel').forEach(panel => {
                    panel.classList.remove('active');
                    if (panel.id === 'reviews') {
                        panel.classList.add('active');
                    }
                });
                
                // 세션 스토리지 초기화 (수동 탭 변경 시 문제 방지)
                sessionStorage.removeItem("activeTab");
            }
        });
        
        // 탭 기능
        document.querySelectorAll('.tab-item').forEach(tab => {
            tab.addEventListener('click', () => {
                // 활성 탭 변경
                document.querySelectorAll('.tab-item').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                
                // 탭 패널 변경
                document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));
                document.getElementById(tab.dataset.tab).classList.add('active');
                
                // 탭 변경 시 세션 스토리지 초기화
                sessionStorage.removeItem("activeTab");
            });
        });

        // 관리자 햄버거 메뉴 토글
        function toggleAdminMenu() {
            const dropdown = document.getElementById('adminMenuDropdown');
            if (dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
            } else {
                dropdown.style.display = 'block';
                
                // 외부 클릭 시 메뉴 닫기
                document.addEventListener('click', closeMenuOnClickOutside);
            }
        }
        
        // 외부 클릭 시 메뉴 닫기 함수
        function closeMenuOnClickOutside(event) {
            const dropdown = document.getElementById('adminMenuDropdown');
            const button = document.querySelector('.admin-menu-button');
            
            if (!dropdown.contains(event.target) && !button.contains(event.target)) {
                dropdown.style.display = 'none';
                document.removeEventListener('click', closeMenuOnClickOutside);
            }
        }

        // 별점 선택 기능
        document.querySelectorAll('.rating-input i').forEach(star => {
            star.addEventListener('click', () => {
                const rating = parseInt(star.dataset.rating);
                document.getElementById('ratingInput').value = rating;
                
                // 별점 UI 업데이트
                document.querySelectorAll('.rating-input i').forEach((s, index) => {
                    if (index < rating) {
                        s.className = 'fas fa-star';
                    } else {
                        s.className = 'far fa-star';
                    }
                });
            });
            
            // 호버 효과
            star.addEventListener('mouseenter', () => {
                const rating = parseInt(star.dataset.rating);
                
                document.querySelectorAll('.rating-input i').forEach((s, index) => {
                    if (index < rating) {
                        s.className = 'fas fa-star';
                    } else {
                        s.className = 'far fa-star';
                    }
                });
            });
            
            star.addEventListener('mouseleave', () => {
                const currentRating = parseInt(document.getElementById('ratingInput').value);
                
                document.querySelectorAll('.rating-input i').forEach((s, index) => {
                    if (index < currentRating) {
                        s.className = 'fas fa-star';
                    } else {
                        s.className = 'far fa-star';
                    }
                });
            });
        });

        // 리뷰 폼 초기화
        function resetReviewForm() {
            document.getElementById('reviewForm').reset();
            document.getElementById('ratingInput').value = 0;
            document.getElementById('reviewId').value = '';
            document.querySelectorAll('.rating-input i').forEach(star => {
                star.className = 'far fa-star';
            });
            document.querySelector('.form-title').textContent = '리뷰 작성하기';
            document.querySelector('.form-actions button.primary-button').textContent = '리뷰 등록';
        }

		// 리뷰 제출
		function submitReview() {
		    // 폼에서 값 가져오기
		    const reviewId = document.getElementById('reviewId').value;
		    const bookNumber = document.getElementById('bookNumberInput').value;
		    const rating = document.getElementById('ratingInput').value;
		    const title = document.getElementById('reviewTitle').value;
		    const content = document.getElementById('reviewContent').value;
		    
		    if (rating === '0') {
		        showModal('error', '평점 필요', '리뷰를 등록하려면 평점을 선택해주세요.');
		        return;
		    }
		    
		    // 수정 또는 등록 여부에 따라 URL 결정
		    const url = reviewId ? "updateReview" : "insertReview";
		    
		    console.log("전송 데이터:", {
		        reviewId: reviewId,
		        bookNumber: bookNumber,
		        reviewRating: rating,
		        reviewTitle: title,
		        reviewContent: content
		    });
		    
		    // AJAX 요청으로 리뷰 등록/수정
		    $.ajax({
		        type: "post",
		        url: url,
		        data: {
		            reviewId: reviewId,
		            bookNumber: bookNumber,
		            reviewRating: rating,
		            reviewTitle: title,
		            reviewContent: content
		        },
		        success: function(response) {
		            console.log("응답:", response);
		            if (response.success) {
		                showModal('success', reviewId ? '리뷰 수정 완료' : '리뷰 등록 완료', response.message);
		                resetReviewForm();
		                
		                // 1.5초 후 페이지 새로고침하여 리뷰 목록 갱신
		                setTimeout(function() {
		                    // 리뷰 탭 상태 유지를 위해 세션 스토리지에 저장
		                    sessionStorage.setItem("activeTab", "reviews");
		                    location.reload();
		                }, 1500);
		            } else {
		                showModal('error', '오류 발생', response.message || '처리 중 오류가 발생했습니다.');
		            }
		        },
		        error: function(xhr, status, error) {
		            console.error("AJAX 오류:", status, error);
		            console.error("응답:", xhr.responseText);
		            
		            let errorMessage = '서버 통신 중 오류가 발생했습니다.';
		            
		            try {
		                if (xhr.responseJSON && xhr.responseJSON.message) {
		                    errorMessage = xhr.responseJSON.message;
		                } else if (xhr.responseText) {
		                    try {
		                        const response = JSON.parse(xhr.responseText);
		                        if (response.message) {
		                            errorMessage = response.message;
		                        }
		                    } catch (e) {
		                        // JSON 파싱 실패 시 원본 텍스트 사용
		                        console.error("JSON 파싱 오류:", e);
		                    }
		                }
		            } catch (e) {
		                console.error("응답 처리 오류:", e);
		            }
		            
		            showModal('error', '오류 발생', errorMessage);
		        }
		    });
		}
        

		// 별점 표시를 위한 CSS 추가
		function addStarRatingStyles() {
		    const style = `
		    .edit-rating {
		        margin-bottom: 15px;
		    }
		    .edit-star {
		        cursor: pointer;
		        font-size: 20px;
		        color: #ffc107;
		        margin-right: 5px;
		        transition: all 0.2s ease;
		    }
		    .edit-star:hover {
		        transform: scale(1.2);
		    }
		    .edit-actions {
		        display: flex;
		        justify-content: flex-end;
		        gap: 10px;
		        margin-top: 15px;
		    }
		    .cancel-edit, .save-edit {
		        padding: 6px 12px;
		        font-size: 14px;
		    }
		    `;
		    
		    // 스타일 태그가 이미 있는지 확인
		    if (!$('#starRatingStyles').length) {
		        $('<style id="starRatingStyles">' + style + '</style>').appendTo('head');
		    }
		}

		// 페이지 로드 시 스타일 추가
		$(document).ready(function() {
		    addStarRatingStyles();
		});
        // 리뷰 삭제 확인 모달 표시
        function confirmDeleteReview(reviewId) {
            // 삭제 확인 모달 표시
            document.getElementById('deleteReviewId').value = reviewId;
            document.getElementById('deleteReviewModal').classList.add('show');
        }

        // 리뷰 삭제 실행
        function deleteReview() {
            const reviewId = document.getElementById('deleteReviewId').value;
            
            $.ajax({
                type: "post",
                url: "deleteReview",
                data: { reviewId: reviewId },
                success: function(response) {
                    if (response.success) {
                        showModal('success', '삭제 완료', '리뷰가 성공적으로 삭제되었습니다.');
                        // 페이지 새로고침 또는 리뷰 목록 갱신
                        setTimeout(() => {
                            // 리뷰 탭 상태 유지를 위해 세션 스토리지에 저장
                            sessionStorage.setItem("activeTab", "reviews");
                            location.reload();
                        }, 1500);
                    } else {
                        showModal('error', '삭제 실패', response.message || '리뷰 삭제에 실패했습니다.');
                    }
                },
                error: function() {
                    showModal('error', '오류 발생', '서버 통신 중 오류가 발생했습니다.');
                }
            });
            
            // 삭제 확인 모달 닫기
            closeDeleteReviewModal();
        }

        // 리뷰 삭제 모달 닫기
        function closeDeleteReviewModal() {
            document.getElementById('deleteReviewModal').classList.remove('show');
        }

        // 대출하기
        function borrowBook(bookNumber) {
            document.getElementById('borrowBookNumber').value = bookNumber;
            
            $.ajax({
                type: "post",
                url: "book_borrow",
                data: $("#borrowForm").serialize(),
                success: function(responseText) {
                    if (responseText === "successBorrow") {
                        showModal('success', '대출 완료', '도서 대출이 성공적으로 완료되었습니다!');
                    } else {
                        showModal('error', '오류 발생', '알 수 없는 응답: ' + responseText);
                    }
                },
                error: function(xhr) {
                    const msg = xhr.responseText;
                    let errorTitle = '오류 발생';
                    let errorMessage = '알 수 없는 오류가 발생했습니다.';
                    
                    switch (msg) {
                        case "noUser":
                            errorTitle = '로그인 필요';
                            errorMessage = '로그인이 필요한 서비스입니다.';
                            break;
                        case "userInfoError":
                            errorMessage = '회원 정보가 올바르지 않아 대출에 실패했습니다.';
                            break;
                        case "userCanBorrowOver":
                            errorTitle = '대출 제한';
                            errorMessage = '대출 가능 권수를 초과했습니다.';
                            break;
                        case "alreadyBorrow":
                            errorTitle = '대출 중복';
                            errorMessage = '이미 대출 중인 도서입니다.';
                            break;
                    }
                    
                    showModal('error', errorTitle, errorMessage);
                }
            });
        }

		// 위시리스트에 추가
		        function addToWishlist(bookNumber) {
		            // 로그인 확인
					if (!isLoggedIn) {
					    showModal('error', '로그인 필요', '위시리스트 기능은 로그인 후 이용 가능합니다.');
					    return;
					}
		            console.log("위시리스트 추가 요청 - bookNumber: " + bookNumber);
		            
		           $.ajax({
		            type: "post",
		            url: "/add_wishlist",
		            data: {
		                bookNumber: bookNumber
		            },
		            dataType: "text", // 응답 데이터 타입을 명시적으로 지정
		            success: function(response) {
		                console.log("위시리스트 응답:", response);
		                if (response === "Success") {
		                    showModal('success', '위시리스트 추가', '도서가 위시리스트에 추가되었습니다.');
		                } else if (response === "already") {
		                    showModal('info', '이미 추가됨', '이미 위시리스트에 추가된 도서입니다.');
		                } else if (response === "Not_login") {
		                    showModal('error', '로그인 필요', '위시리스트 기능은 로그인 후 이용 가능합니다.');
		                } else {
		                    showModal('error', '오류 발생', '알 수 없는 응답: ' + response);
		                }
		            },
		            error: function(xhr, textStatus, errorThrown) {
		                console.error('위시리스트 추가 오류:', xhr.status);
		                console.error('상태:', textStatus);
		                console.error('에러:', errorThrown);
		                showModal('error', '오류 발생', '서버 오류가 발생했습니다.');
		            }
		            
		           });
		        }

        // 도서 삭제 확인
        function confirmDelete(bookNumber) {
            document.getElementById('deleteBookNumber').value = bookNumber;
            document.getElementById('deleteModal').classList.add('show');
        }

        // 도서 삭제 실행
        function deleteBook() {
            $.ajax({
                type: "post",
                url: "book_delete",
                data: $("#deleteForm").serialize(),
                success: function(responseText) {
                    if (responseText === "successDelete") {
                        showModal('success', '삭제 완료', '도서가 성공적으로 삭제되었습니다.');
                        // 삭제 후 목록 페이지로 이동
                        setTimeout(function() {
                            location.href = "book_search_view?searchKeyword=&searchType=title&majorCategory=&subCategory=";
                        }, 1500);
                    } else {
                        showModal('error', '삭제 실패', '도서 삭제에 실패했습니다: ' + responseText);
                    }
                },
                error: function(xhr) {
                    showModal('error', '오류 발생', '서버 오류가 발생했습니다.');
                }
            });
            closeDeleteModal();
        }

        // 모달 표시
        function showModal(type, title, message) {
            const modal = document.getElementById('alertModal');
            const icon = document.getElementById('modalIcon');
            const iconElement = icon.querySelector('i');
            
            document.getElementById('modalTitle').textContent = title;
            document.getElementById('modalMessage').textContent = message;
            
            if (type === 'success') {
                icon.className = 'modal-icon success';
                iconElement.className = 'fas fa-check-circle';
            } else {
                icon.className = 'modal-icon error';
                iconElement.className = 'fas fa-exclamation-circle';
            }
            
            modal.classList.add('show');
        }

        // 모달 닫기
        function closeModal() {
            document.getElementById('alertModal').classList.remove('show');
            
            // 성공 메시지인 경우 페이지 새로고침
            if (document.getElementById('modalIcon').classList.contains('success')) {
                location.reload();
            }
        }

        // 삭제 모달 닫기
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }

        // 페이지 로드 시 알림 처리
        document.addEventListener('DOMContentLoaded', function() {
            <c:if test="${not empty errorMsg}">
                showModal('error', '오류 발생', "${errorMsg}");
            </c:if>
            
            <c:if test="${not empty successMSG}">
                showModal('success', '대출 완료', "${successMSG}");
            </c:if>
        });
    </script>
</body>
</html>
