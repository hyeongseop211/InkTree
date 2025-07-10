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
</head>
<body>
    <jsp:include page="../header.jsp" />
	
	<div class="container">
        <div class="wishlist-container">
            <div class="wishlist-header">
                <h1 class="wishlist-title"><i class="fas fa-heart"></i> 내 관심 도서</h1>
                <div class="wishlist-actions">
                    <button class="back-button" onclick="location.href='/'">
                        <i class="fas fa-home"></i> 홈으로 돌아가기
                    </button>
                </div>
            </div>

            <div class="search-section">
                <form id="searchForm" method="get" action="/book_wishlist">
                    <!-- 검색 입력 필드 (가로로 길게) -->
					<div class="search-input-wrapper">
					    <input type="text" class="search-input" id="keyword" name="keyword" 
					           value="${param.keyword}" 
					           placeholder="도서 제목으로 검색">
					    <button type="submit" class="search-button">
					        <i class="fas fa-search"></i>
					    </button>
					</div>
                    
                    <!-- 필터 라벨 행 -->
                    <div class="filter-labels-row">
                        <div class="filter-label">대분류</div>
                        <div class="filter-label">중분류</div>
                    </div>
                    
                    <!-- 필터 선택 행 -->
                    <div class="filters-row">
                        <!-- 대분류 -->
                        <select class="filter-select" id="bookMajorCategory" name="bookMajorCategory">
                            <option value="">전체</option>
                            <option value="000-총류" ${param.bookMajorCategory == '000-총류' ? 'selected' : ''}>000 - 총류</option>
                            <option value="100-철학" ${param.bookMajorCategory == '100-철학' ? 'selected' : ''}>100 - 철학</option>
                            <option value="200-종교" ${param.bookMajorCategory == '200-종교' ? 'selected' : ''}>200 - 종교</option>
                            <option value="300-사회학" ${param.bookMajorCategory == '300-사회학' ? 'selected' : ''}>300 - 사회학</option>
                            <option value="400-자연과학" ${param.bookMajorCategory == '400-자연과학' ? 'selected' : ''}>400 - 자연과학</option>
                            <option value="500-기술과학" ${param.bookMajorCategory == '500-기술과학' ? 'selected' : ''}>500 - 기술과학</option>
                            <option value="600-예술" ${param.bookMajorCategory == '600-예술' ? 'selected' : ''}>600 - 예술</option>
                            <option value="700-언어" ${param.bookMajorCategory == '700-언어' ? 'selected' : ''}>700 - 언어</option>
                            <option value="800-문학" ${param.bookMajorCategory == '800-문학' ? 'selected' : ''}>800 - 문학</option>
                            <option value="900-역사" ${param.bookMajorCategory == '900-역사' ? 'selected' : ''}>900 - 역사</option>
                        </select>
                        
                        <!-- 중분류 -->
                        <select class="filter-select" id="bookSubCategory" name="bookSubCategory">
                            <option value="">전체</option>
                            <!-- 대분류에 따라 동적으로 변경됩니다 -->
                        </select>
                    </div>
                    
                    <!-- 히든 필드 -->
                    <input type="hidden" name="page" value="1">
                </form>
            </div>



            <c:choose>
                <c:when test="${empty wishlist}">
                    <div class="empty-message">관심목록에 추가된 도서가 없습니다.</div>
                </c:when>
                <c:otherwise>
                    <div class="wishlist-grid">
                        <c:forEach var="book" items="${wishlist}">
							<div class="wishlist-item" onclick="location.href='/book_detail?bookNumber=${book.bookNumber}'" style="cursor: pointer;">
							    <div class="wishlist-image">
							        <div class="no-image">
							            <i class="fas fa-book"></i>
							        </div>
							    </div>
							    <div class="wishlist-info">
							        <h3 class="wishlist-title">${book.bookTitle}</h3>
							        <div class="book-details">
							            <div class="book-detail-row">저자: ${book.bookWrite}</div>
							            <div class="book-detail-row">출판사: ${book.bookPub}</div>
							            <div class="book-detail-row">출판일: <fmt:formatDate value="${book.bookDate}" pattern="yyyy년 MM월 dd일" /></div>
							        </div>
							        <div class="book-categories">
							            <span class="book-category">${book.bookMajorCategory}</span>
							            <span class="book-category">${book.bookSubCategory}</span>
							        </div>
							    </div>
							    <button class="remove-wishlist-btn" onclick="confirmRemoveFromWishlist(event, ${book.bookNumber})">
							        <i class="fas fa-heart-broken"></i> 관심목록 삭제
							    </button>
							</div>
                        </c:forEach>
                    </div>

                    <!-- 페이징 영역 -->
                    <div class="div_page">
                        <ul>
                            <c:if test="${pageMaker.prev}">
                                <li class="paginate_button">
                                    <a href="${pageMaker.startPage - 1}">
                                        <i class="fas fa-caret-left"></i>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="i">
                                <li class="paginate_button ${pageMaker.wishlistCriteriaDTO.page == i ? 'active' : ''}">
                                    <a href="${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${pageMaker.next}">
                                <li class="paginate_button">
                                    <a href="${pageMaker.endPage + 1}">
                                        <i class="fas fa-caret-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
					<form id="actionForm" action="/book_wishlist" method="get">
					    <input type="hidden" name="page" value="${pageMaker.wishlistCriteriaDTO.page}">
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
                </c:otherwise>
            </c:choose>
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
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon error">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 class="modal-title">삭제 확인</h3>
            <p class="modal-message">정말로 관심목록에서 삭제하시겠습니까?</p>
            <div class="modal-actions">
                <button class="action-button secondary-button" onclick="closeConfirmModal()">취소</button>
                <button class="action-button danger-button" id="confirmDeleteBtn">삭제</button>
            </div>
        </div>
    </div>

    <script>
        // 전역 변수로 삭제할 도서 번호 저장
        let bookNumberToDelete = null;
        
        // 삭제 확인 모달 표시
        function confirmRemoveFromWishlist(event, bookNumber) {
            // 이벤트 버블링 방지
            event.stopPropagation();
            
            // 삭제할 도서 번호 저장
            bookNumberToDelete = bookNumber;
            
            // 삭제 확인 버튼에 이벤트 리스너 추가
            document.getElementById('confirmDeleteBtn').onclick = function() {
                removeFromWishlist(bookNumberToDelete);
                closeConfirmModal();
            };
            
            // 모달 표시
            document.getElementById('confirmModal').classList.add('show');
        }
        
        // 삭제 확인 모달 닫기
        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.remove('show');
        }
        
        // 위시리스트에서 책 삭제 함수
        function removeFromWishlist(bookNumber) {
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
                        showModal('success', '삭제 완료', '도서가 관심목록에서 삭제되었습니다.');
                        // 1.5초 후 페이지 새로고침
                        /*setTimeout(function() {
                            location.reload();
                        }, 1500);*/
                            location.reload();
                    } else if (response === "not_exists") {
                        showModal('error', '삭제 실패', '이미 위시리스트에서 삭제되었습니다.');
                    } else if (response === "Not_login") {
                        showModal('error', '로그인 필요', '로그인이 필요한 서비스입니다.');
                    } else {
                        showModal('error', '오류 발생', '오류가 발생했습니다: ' + response);
                    }
                },
                error: function(xhr, textStatus, errorThrown) {
                    console.error('위시리스트 삭제 오류:', xhr.status);
                    console.error('상태:', textStatus);
                    console.error('에러:', errorThrown);
                    showModal('error', '서버 오류', '서버 오류가 발생했습니다.');
                }
            });
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
        }
        
        // 페이징처리
        var actionForm = $("#actionForm");

        // 페이지번호 처리
		$(".paginate_button a").on("click", function (e) {
		    e.preventDefault();
		    console.log("click했음");
		    console.log("@# href => " + $(this).attr("href"));

		    actionForm.find("input[name='page']").val($(this).attr("href"));
		    actionForm.submit();
		});

        // 검색처리
        var searchForm = $("#searchForm");

        $("#searchForm button").on("click", function (e) {
            e.preventDefault();
            searchForm.find("input[name='page']").val("1"); // 검색 시 1페이지로 이동
            searchForm.submit();
        });
        
        
        // 대분류에 따른 소분류 옵션 변경
        $(document).ready(function() {
            // 애니메이션 효과 추가
            const wishlistItems = document.querySelectorAll('.wishlist-item');
            wishlistItems.forEach((item, index) => {
                setTimeout(() => {
                    item.classList.add('show');
                }, 100 * index);
            });
            
            // 대분류에 따른 소분류 옵션 변경
            $('#bookMajorCategory').on('change', function() {
                const bookMajorCategory = $(this).val();
                const bookSubCategorySelect = $('#bookSubCategory');
                
                // 기존 옵션 제거
                bookSubCategorySelect.html('<option value="">전체</option>');
                
                // 대분류에 따른 소분류 옵션 추가
                if (bookMajorCategory === '000-총류') {
                    addSubCategories(['010-도서관, 서지학', '020-문헌정보학', '030-백과사전', '040-강연, 수필, 연설문집', '050-일반학회, 단체, 박물관', '060-일반전집', '070-신문, 언론, 저널리즘', '080-일반전집, 총서', '090-향토자료']);
                } else if (bookMajorCategory === '100-철학') {
                    addSubCategories(['110-형이상학', '120-인식론, 인과론, 인간학', '130-세계', '140-경학', '150-동양철학, 사상', '160-서양철학', '170-논리학', '180-윤리학', '190-윤리, 도덕교육']);
                } else if (bookMajorCategory === '200-종교') {
                    addSubCategories(['210-비교종교', '220-불교', '230-기독교', '240-도교', '250-천도교', '260-신도', '270-힌두교, 브라만교', '280-회교(이슬람교)', '290-기타 제종교']);
                } else if (bookMajorCategory === '300-사회학') {
                    addSubCategories(['310-통계학', '320-경제학', '330-사회학, 사회문제', '340-정치학', '350-행정학', '360-법학', '370-교육학', '380-풍속, 민속학', '390-국방, 군사학']);
                } else if (bookMajorCategory === '400-자연과학') {
                    addSubCategories(['410-수학', '420-물리학', '430-화학', '440-천문학', '450-지학', '460-생명과학', '470-식물학', '480-동물학', '490-기타 자연과학']);
                } else if (bookMajorCategory === '500-기술과학') {
                    addSubCategories(['510-의학', '520-일반공학, 공학일반', '530-기계공학', '540-전기, 전자공학', '550-건축공학', '560-화학공학', '570-제조업', '580-생활과학', '590-기타 기술과학']);
                } else if (bookMajorCategory === '600-예술') {
                    addSubCategories(['610-건축', '620-조각, 조형예술', '630-회화', '640-서예', '650-사진, 인쇄', '660-음악', '670-공연예술, 매체예술', '680-오락, 스포츠', '690-기타 예술']);
                } else if (bookMajorCategory === '700-언어') {
                    addSubCategories(['710-한국어', '720-중국어', '730-일본어', '740-영어', '750-독일어', '760-프랑스어', '770-스페인어', '780-기타 언어']);
                } else if (bookMajorCategory === '800-문학') {
                    addSubCategories(['810-한국문학', '820-중국문학', '830-일본문학', '840-영어문학', '850-독일문학', '860-프랑스문학', '870-스페인문학', '880-기타 문학']);
                } else if (bookMajorCategory === '900-역사') {
                    addSubCategories(['910-한국사', '920-동양사', '930-서양사', '940-역사이론', '950-지리학', '960-지도, 여행', '970-문화사', '980-민속사', '990-기타 역사']);
                }
            });
            
            // 소분류 옵션 추가 함수
            function addSubCategories(categories) {
                const bookSubCategorySelect = $('#bookSubCategory');
                categories.forEach(category => {
                    const option = $('<option></option>').val(category).text(category);
                    bookSubCategorySelect.append(option);
                });
            }
            
            // 페이지 로드 시 대분류에 따른 소분류 설정
            if ($('#bookMajorCategory').val()) {
                $('#bookMajorCategory').trigger('change');
                
                // URL에서 선택된 소분류가 있으면 선택 상태로 만들기
                const selectedbookSubCategory = '${param.bookSubCategory}';
                if (selectedbookSubCategory) {
                    $('#bookSubCategory').val(selectedbookSubCategory);
                }
            }
            
            // 알림 메시지 처리
            const errorMsg = "${errorMsg}";
            
            if (errorMsg && errorMsg !== "") {
                showModal('error', '오류 발생', errorMsg);
            }
        });
    </script>
</body>
</html>
