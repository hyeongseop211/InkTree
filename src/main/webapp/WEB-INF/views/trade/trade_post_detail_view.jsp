<%@page import="com.boot.user.dto.UserDTO" %>
<%@page import="com.boot.trade.dto.TradePostDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거래 게시글 상세 - 잉크트리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/resources/css/trade_post_detail_view.css">
</head>

<body>
			<jsp:include page="../header.jsp" />

    <div class="container">
        <div class="trade-detail-container">
            <!-- 상단 네비게이션 -->
            <div class="detail-nav">
<!--                <a href="board_view?pageNum=${param.pageNum}&amount=${param.amount}" class="back-link">-->
                <a href="trade_post_view?pageNum=${param.pageNum}&amount=${param.amount}&status=${param.status}&sort=${param.sort}" class="back-link">
                    <i class="fas fa-arrow-left"></i> 목록으로 돌아가기
                </a>
                <div class="post-info">
                    <span class="post-date">
                        <c:set var="dateStr" value="${post.createdAt}" />
                        <c:if test="${not empty dateStr}">
                            <c:choose>
                                <c:when test="${fn:length(dateStr) > 10}">
                                    ${fn:substring(dateStr, 0, 10)}
                                </c:when>
                                <c:otherwise>
                                    ${dateStr}
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </span>
                    <span class="post-views"><i class="fas fa-eye"></i> ${post.viewCount}</span>
                </div>
            </div>

            <!-- 게시글 헤더 -->
            <div class="post-header">
                <div class="post-title-container">
                    <h1 class="post-title">${post.title}</h1>
                    <div class="post-status ${post.status == 'AVAILABLE' ? 'available' : post.status == 'RESERVED' ? 'reserved' : 'sold'}">
                        ${post.status == 'AVAILABLE' ? '판매중' : post.status == 'RESERVED' ? '예약중' : '판매완료'}
                    </div>
                </div>
                <div class="post-price"><fmt:formatNumber value="${post.price}" pattern="#,###" />원</div>
            </div>

            <!-- 카테고리 및 위치 정보 -->
            <div class="post-meta">
                <div class="post-categories">
                    <span class="category-label">카테고리:</span>
                    <span class="category-item">${post.bookMajorCategory}</span>
                    <c:if test="${not empty post.bookSubCategory}">
                        <span class="category-divider">></span>
                        <span class="category-item">${post.bookSubCategory}</span>
                    </c:if>
                </div>
                <div class="post-location">
                    <i class="fas fa-map-marker-alt"></i> ${post.location}
                </div>
            </div>

            <!-- 판매자 정보 -->
            <div class="seller-info">
                <div class="seller-profile">
                    <div class="seller-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="seller-details">
                        <div class="seller-name">${post.userName}</div>
                        <div class="seller-rating">
                            <i class="fas fa-star"></i>
                            <c:choose>
                                <c:when test="${not empty sellerRating}">
                                    <fmt:formatNumber value="${sellerRating}" pattern="#.#" /> (${sellerReviewCount})
                                </c:when>
                                <c:otherwise>
                                    평가 없음
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
				
				<c:if test="${user != null && user.userNumber != post.userNumber}">
				    <div class="action-buttons">
				        <button class="like-button ${isLiked ? 'active' : ''}" onclick="toggleLike(${post.postID})">
				            <i class="fas fa-heart"></i> 관심등록
				        </button>
						<a href="trade_chat?postID=${post.postID}&sellerNumber=${post.userNumber}&buyerNumber=${user.userNumber}" class="chat-btn">
						    <i class="fas fa-comment"></i> 채팅하기
						</a>
				    </div>
				</c:if>
            </div>

            <!-- 게시글 내용 -->
            <div class="post-content">
                ${post.content}
            </div>

            <!-- 관심, 조회수, 채팅수 정보 -->
            <div class="post-stats">
                <c:if test="${user != null && user.userNumber != post.userNumber}">
                    <button class="like-btn ${isLiked ? 'active' : ''}" onclick="toggleLike(${post.postID})">
                        <i class="fas fa-heart"></i> 관심 ${likeCount}
                    </button>
                </c:if>
                <c:if test="${user == null || user.userNumber == post.userNumber}">
                    <div class="stat-item">
                        <i class="fas fa-heart"></i> 관심 ${likeCount}
                    </div>
                </c:if>
                <div class="stat-item">
                    <i class="fas fa-eye"></i> 조회 ${post.viewCount}
                </div>
                <div class="stat-item">
                    <i class="fas fa-comment"></i> 채팅 ${chatCount}
                </div>
            </div>

            <!-- 작성자 또는 관리자만 볼 수 있는 버튼 -->
            <c:if test="${user != null && (user.userNumber == post.userNumber || user.userAdmin == 1)}">
                <div class="post-actions">
                    <button class="action-btn edit-btn" onclick="location.href='trade_post_update?postID=${post.postID}'">
                        <i class="fas fa-edit"></i> 수정하기
                    </button>
                    <button class="action-btn delete-btn" onclick="confirmDelete(${post.postID})">
                        <i class="fas fa-trash"></i> 삭제하기
                    </button>
			            <c:if test="${user != null && (user.userNumber == post.userNumber)}">
	                        <div class="status-change-container">
	                            <button class="action-btn status-btn" onclick="toggleStatusDropdown()">
	                                <i class="fas fa-tag"></i> 상태 변경
	                            </button>
	                            <div class="status-dropdown" id="statusDropdown">
	                                <div class="status-option ${post.status == 'AVAILABLE' ? 'active' : ''}" 
	                                     onclick="changeStatus(${post.postID}, 'AVAILABLE')">
	                                    판매중
	                                </div>
	                                <div class="status-option ${post.status == 'RESERVED' ? 'active' : ''}" 
	                                     onclick="changeStatus(${post.postID}, 'RESERVED')">
	                                    예약중
	                                </div>
	                                <div class="status-option ${post.status == 'SOLD' ? 'active' : ''}" 
	                                     onclick="changeStatus(${post.postID}, 'SOLD')">
	                                    판매완료
	                                </div>
	                            </div>
	                        </div>
						</c:if>
                </div>
            </c:if>

            <!-- 판매중인 다른 게시글 섹션 -->
            <div class="related-posts-section">
                <h3 class="section-title">
                    <i class="fas fa-tags"></i> 판매중인 다른 게시글
                </h3>
                
                <div class="related-posts-grid">
                    <c:if test="${empty availablePosts}">
                        <div class="no-related-posts">
                            <p>판매중인 다른 게시글이 없습니다.</p>
                        </div>
                    </c:if>
                    
                    <c:forEach items="${availablePosts}" var="availablePost">
                        <div class="related-post-item">
<!--                            <a href="trade_post_detail_view?postID=${availablePost.postID}" class="related-post-link">-->
                            <a href="trade_post_detail_view?postID=${availablePost.postID}&pageNum=${param.pageNum}&amount=${param.amount}" class="related-post-link">
                                <div class="related-post-image">

                                </div>
                                <div class="related-post-info">
                                    <h4 class="related-post-title">${availablePost.title}</h4>
                                    <div class="related-post-price"><fmt:formatNumber value="${availablePost.price}" pattern="#,###" />원</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div class="modal" id="deleteModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>게시글 삭제</h3>
                <span class="close-modal" onclick="closeDeleteModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p>정말 이 게시글을 삭제하시겠습니까?</p>
                <p class="warning-text">삭제된 게시글은 복구할 수 없습니다.</p>
            </div>
            <div class="modal-footer">
                <button class="cancel-btn" onclick="closeDeleteModal()">취소</button>
                <button class="confirm-btn" onclick="deletePost()">삭제</button>
            </div>
        </div>
    </div>


    <!-- 페이지 이동을 위한 폼 -->
    <form id="actionForm" method="get">
        <input type="hidden" name="postID" value="${post.postID}">
        <input type="hidden" name="pageNum" value="${param.pageNum}">
        <input type="hidden" name="amount" value="${param.amount}">
        <c:if test="${not empty param.type}">
            <input type="hidden" name="type" value="${param.type}">
        </c:if>
        <c:if test="${not empty param.keyword}">
            <input type="hidden" name="keyword" value="${param.keyword}">
        </c:if>
        <c:if test="${not empty param.bookMajorCategory}">
            <input type="hidden" name="bookMajorCategory" value="${param.bookMajorCategory}">
        </c:if>
        <c:if test="${not empty param.bookSubCategory}">
            <input type="hidden" name="bookSubCategory" value="${param.bookSubCategory}">
        </c:if>
    </form>

    <script>
        // 게시글 삭제 확인 모달 표시
        function confirmDelete(postID) {
            document.getElementById('deleteModal').style.display = 'flex';
        }

        // 게시글 삭제 모달 닫기
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
        }

        // 게시글 삭제 실행
        function deletePost() {
            const postID = ${post.postID};
            
            $.ajax({
                type: "post",
                url: "trade_post_delete",
                data: { postID: postID },
                success: function(response) {
                    if (response.success) {
                        alert("게시글이 삭제되었습니다.");
                        // location.href = "trade_post_view?pageNum=${param.pageNum}&amount=${param.amount}";
                        location.href = "trade_post_view";
                    } else {
                        alert("게시글 삭제에 실패했습니다: " + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("게시글 삭제 중 오류가 발생했습니다.");
                    console.error("Error:", error);
                }
            });
        }

        // 상태 드롭다운 토글
        function toggleStatusDropdown() {
            const dropdown = document.getElementById('statusDropdown');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
            
            // 외부 클릭 시 드롭다운 닫기
            document.addEventListener('click', function closeDropdown(e) {
                if (!e.target.closest('.status-change-container')) {
                    dropdown.style.display = 'none';
                    document.removeEventListener('click', closeDropdown);
                }
            });
        }

        // 게시글 상태 변경
        function changeStatus(postID, status) {
            $.ajax({
                type: "post",
                url: "update_trade_status",
                data: { 
                    postID: postID,
                    status: status
                },
                success: function(response) {
                    if (response.success) {
                        alert("상태가 변경되었습니다.");
                        location.reload();
                    } else {
                        alert("상태 변경에 실패했습니다: " + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("상태 변경 중 오류가 발생했습니다.");
                    console.error("Error:", error);
                }
            });
        }

        // 관심 상품 토글
		function toggleLike(postID) {
		    $.ajax({
		        type: "post",
		        url: "trade_post_favorite",
		        data: { 
		            postID: postID
		        },
		        success: function(response) {
		            if (response.success) {
		                // 현재 URL 가져오기
		                let currentUrl = window.location.href;
		                
		                // URL에 skipViewCount 파라미터 추가
		                if (currentUrl.includes('?')) {
		                    if (currentUrl.includes('skipViewCount=')) {
		                        // 이미 skipViewCount 파라미터가 있는 경우
		                        window.location.reload();
		                    } else {
		                        // 다른 파라미터는 있지만 skipViewCount는 없는 경우
		                        window.location.href = currentUrl + '&skipViewCount=true';
		                    }
		                } else {
		                    // 파라미터가 없는 경우
		                    window.location.href = currentUrl + '?skipViewCount=true';
		                }
		            } else {
		                alert("관심 상품 등록/해제에 실패했습니다: " + response.message);
		            }
		        },
		        error: function(xhr, status, error) {
		            if (xhr.status === 401) {
		                alert("로그인이 필요합니다.");
		            } else {
		                alert("관심 상품 등록/해제 중 오류가 발생했습니다.");
		                console.error("Error:", error);
		            }
		        }
		    });
		}

        // 페이지 로드 시 실행
        document.addEventListener('DOMContentLoaded', function() {
            // ESC 키로 모달 닫기
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    closeDeleteModal();
                    closeChatModal();
                }
            });
            

            // 이미지 로드 오류 처리
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.onerror = function() {
                    this.src = '/resources/images/no-image.png';
                };
            });
        });
    </script>
</body>

</html>