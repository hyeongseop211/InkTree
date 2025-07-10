<%@page import="com.boot.user.dto.UserDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>잉크 트리 - 도서관리 시스템</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="/resources/css/main.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/book_search.css">
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    // 폼 제출 시 엔터 입력을 막고 fn_submit 호출
    $("#search-form").on("submit", function(e) {
        e.preventDefault();  // 새로고침 방지
        fn_submit();         // 검색 함수 호출
    });
});

function fn_submit() {
    var formData = $("#search-form").serialize(); // 모든 폼 요소 직렬화
    $.ajax({
        type: "GET",
        url: "book_search_view",
        data: formData,
        success: function(data) {
            // 결과 페이지로 이동하거나, 결과를 동적으로 처리해도 OK
            location.href = "book_search_view?" + formData;
        },
        error: function(xhr) {
            alert("검색 요청 중 오류가 발생했습니다.");
        }
    });
}
</script>
</head>
<body>
	<jsp:include page="header.jsp" />
	<div class="container">
		<c:choose>
		    <c:when test="${not empty user}">
		<div class="slider-container">
			<div class="image-slider">
				<div class="slide">
					<img src="/resources/images/main1.png" alt="슬라이드 1">
				</div>
				<div class="slide">
					<img src="/resources/images/main2.png" alt="슬라이드 2">
				</div>
				<div class="slide">
					<img src="/resources/images/main3.png" alt="슬라이드 3">
				</div>
				<div class="slide">
					<img src="/resources/images/main4.png" alt="슬라이드 4">
				</div>
				<div class="slide">
					<img src="/resources/images/main5.png" alt="슬라이드 5">
				</div>
			</div>
		</div>

		<div class="welcome-banner">
			<div class="welcome-text">
<h1>안녕하세요, <span>${user.userName}</span>님!</h1>
				<p>잉크 트리 도서관리 시스템에 오신 것을 환영합니다.</p>
			</div>
			<div class="date-display">
				<i class="fas fa-calendar-alt"></i> <span id="current-date">
					<%=new java.text.SimpleDateFormat("yyyy년 MM월 dd일 EEEE", java.util.Locale.KOREAN).format(new java.util.Date())%>
				</span>
			</div>
		</div>

		<div class="container">
			<div class="search-header">
				<h1 class="search-title">
					<i class="fas fa-book"></i> 도서 검색
				</h1>

				<form class="search-form" id="search-form">
					<!-- 메인 검색창 -->
					<div class="search-main">
<!--						<input type="text" class="search-input-main" id="searchKeyword"-->
<!--							name="searchKeyword" value="${param.searchKeyword}"-->
<!--							placeholder="도서명, 저자, ISBN 또는 출판사를 입력하세요">-->
						<input type="text" class="search-input-main" id="keyword"
						       name="keyword" value="${pageMaker.criteriaDTO.keyword}"
						       placeholder="도서명, 저자, ISBN 또는 출판사를 입력하세요">
						<button type="button" class="search-button-main"
							onclick="fn_submit()">
							<i class="fas fa-search"></i>
						</button>
					</div>

					<!-- 필터 옵션 -->
					<div class="search-filters">
						<div class="search-filter">
						    <label class="filter-label" for="type">검색 유형</label>
						    <select class="filter-select" id="type" name="type">
						        <option value="T" ${pageMaker.criteriaDTO.type eq 'T' ? 'selected' : ''}>도서명</option>
						        <option value="A" ${pageMaker.criteriaDTO.type eq 'A' ? 'selected' : ''}>저자</option>
						        <option value="I" ${pageMaker.criteriaDTO.type eq 'I' ? 'selected' : ''}>ISBN</option>
						        <option value="P" ${pageMaker.criteriaDTO.type eq 'P' ? 'selected' : ''}>출판사</option>
						    </select>
						</div>

						<div class="search-filter">
							<label class="filter-label" for="majorCategory">대분류</label> <select
								class="filter-select" id="majorCategory" name="majorCategory">
								<option value="">전체</option>
								<option value="000-총류"
									${param.majorCategory == '000' ? 'selected' : ''}>000
									- 총류</option>
								<option value="100-철학"
									${param.majorCategory == '100' ? 'selected' : ''}>100
									- 철학</option>
								<option value="200-종교"
									${param.majorCategory == '200' ? 'selected' : ''}>200
									- 종교</option>
								<option value="300-사회학"
									${param.majorCategory == '300' ? 'selected' : ''}>300
									- 사회학</option>
								<option value="400-자연과학"
									${param.majorCategory == '400' ? 'selected' : ''}>400
									- 자연과학</option>
								<option value="500-기술과학"
									${param.majorCategory == '500' ? 'selected' : ''}>500
									- 기술과학</option>
								<option value="600-예술"
									${param.majorCategory == '600' ? 'selected' : ''}>600
									- 예술</option>
								<option value="700-언어"
									${param.majorCategory == '700' ? 'selected' : ''}>700
									- 언어</option>
								<option value="800-문학"
									${param.majorCategory == '800' ? 'selected' : ''}>800
									- 문학</option>
								<option value="900-역사"
									${param.majorCategory == '900' ? 'selected' : ''}>900
									- 역사</option>
							</select>
						</div>

						<div class="search-filter">
							<label class="filter-label" for="subCategory">중분류</label> <select
								class="filter-select" id="subCategory" name="subCategory">
								<option value="">전체</option>
								<!-- 대분류에 따라 동적으로 변경될 수 있습니다 -->
							</select>
						</div>
					</div>
				</form>
			</div>

			<!-- Statistics Dashboard -->
			<div class="stats-dashboard">
				<div class="stat-card">
					<div class="stat-icon books">
						<i class="fas fa-book"></i>
					</div>
					<div class="stat-info">
						<h3>전체 도서</h3>
						<div class="number">
							<fmt:formatNumber value="${totalBooks}" type="number" />
						</div>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon users">
						<i class="fas fa-users"></i>
					</div>
					<div class="stat-info">
						<h3>전체 회원</h3>
						<div class="number">
							<fmt:formatNumber value="${totalUsers}" type="number" />
						</div>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon borrowed">
						<i class="fas fa-book-reader"></i>
					</div>
					<div class="stat-info">
						<h3>대출 중인 도서</h3>
						<div class="number">
							<fmt:formatNumber value="${borrowedBooks}" type="number" />
						</div>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon overdue">
						<i class="fas fa-exclamation-circle"></i>
					</div>
					<div class="stat-info">
						<h3>연체 도서</h3>
						<div class="number">
							<fmt:formatNumber value="${overdueBooks}" type="number" />
						</div>
					</div>
				</div>
			</div>

			<!-- Smaller Feature Cards -->
			<div class="feature-section">
				<div class="feature-card">
					<div class="feature-icon">
						<i class="fas fa-book-open"></i>
					</div>
					<div class="feature-content">
						<h3>내 대출 현황</h3>
						<p>현재 대출 중인 도서와 반납 예정일을 확인하세요.</p>
						<!-- 						<a href="mypage?tab=history" class="btn-sm">바로가기</a> -->
						<a href="user_book_borrowing" class="btn-sm">바로가기</a>
					</div>
				</div>

				<div class="feature-card">
					<div class="feature-icon">
						<i class="fas fa-exchange-alt"></i>
					</div>
					<div class="feature-content">
						<h3>도서 대출</h3>
						<p>원하는 도서를 대출하여 이용하세요.</p>
						<a href="book_search_view" class="btn-sm">바로가기</a>
					</div>
				</div>

				<div class="feature-card">
					<div class="feature-icon">
						<i class="fas fa-star"></i>
					</div>
					<div class="feature-content">
						<h3>도서 추천</h3>
						<p>회원님의 관심사에 맞는 도서를 추천해 드립니다.</p>
						<a href="user_book_recommend" class="btn-sm">바로가기</a>
					</div>
				</div>
			</div>

			<!-- Recommended Books -->
			<div class="recommended-books">
				<div class="section-header">
					<h2 class="section-title">
						<i class="fas fa-thumbs-up"></i> 추천 도서
					</h2>
					<a href="/user_book_recommend" class="action-link"> 더보기
						<i class="fas fa-chevron-right"></i>
					</a>
				</div>


				<div class="books-grid">
					<c:forEach var="book" items="${bookList}" varStatus="status">
						<c:if test="${status.index <4}">
							<div class="book-card">
								<div class="book-cover">
									<!-- 									<img src="/pilotpjt/resources/images/book1.jpg" alt="도서 표지" -->
									<!-- 										onerror="this.src='/pilotpjt/resources/images/default-book.jpg'; this.onerror=null;"> -->
									<div class="book-cover-placeholder">
										<i class="fas fa-book"></i>
									</div>
								</div>
								<div class="book-info">
									<h3 class="book-title">${book.bookTitle}</h3>
									<div class="book-author">저자: ${book.bookWrite}</div>
									<div class="book-publisher">출판사: ${book.bookPub}</div>
									<div class="book-date">
										출판일:
										<fmt:formatDate value="${book.bookDate}"
											pattern="yyyy년 MM월 dd일" />
									</div>

									<div class="book-categories">
										<span class="book-category">${book.bookMajorCategory}</span>
										<c:if test="${not empty book.bookSubCategory}">
											<span class="book-category">${book.bookSubCategory}</span>
										</c:if>
									</div>

									<div class="book-status">
										<div
											class="book-availability ${book.bookCount > 0 ? 'available' : 'unavailable'}">
											<c:choose>
												<c:when test="${book.bookCount > 0}">
													<i class="fas fa-check-circle"></i> 대출 가능
                                                </c:when>
												<c:otherwise>
													<i class="fas fa-times-circle"></i> 대출 불가
                                                </c:otherwise>
											</c:choose>
										</div>
										<a href="/book_detail?bookNumber=${book.bookNumber}"
											class="book-detail-button">상세보기</a>
									</div>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</div>
			</div>

			</c:when>
			    <c:otherwise>
			<div class="login-section">
				<h2>잉크트리에 오신 것을 환영합니다</h2>
				<p>
					잉크 트리 도서관리 시스템은 다양한 도서를 검색하고 대출할 수 있는 서비스를 제공합니다.<br>서비스를
					이용하시려면 로그인이 필요합니다.
				</p>
				<a href="/loginForm" class="btn"> <i
					class="fas fa-sign-in-alt"></i> 로그인 하러 가기
				</a>
				<p style="margin-top: 20px;">
					계정이 없으신가요? <a href="joinForm">회원가입</a>
				</p>
			</div>
			</c:otherwise>
			</c:choose>
		</div>


		<script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate statistics numbers
            const statNumbers = document.querySelectorAll('.number');
            
            statNumbers.forEach(number => {
                const finalValue = number.textContent;
                let startValue = 0;
                const duration = 1500;
                const increment = parseInt(finalValue.replace(/,/g, '')) / (duration / 20);
                
                const animateValue = () => {
                    startValue += increment;
                    if (startValue < parseInt(finalValue.replace(/,/g, ''))) {
                        number.textContent = Math.floor(startValue).toLocaleString();
                        requestAnimationFrame(animateValue);
                    } else {
                        number.textContent = finalValue;
                    }
                };
                
                requestAnimationFrame(animateValue);
            });
        });
        // 대분류에 따른 소분류 옵션 변경
        document.getElementById('majorCategory').addEventListener('change', function() {
            const majorCategory = this.value;
            const subCategorySelect = document.getElementById('subCategory');
            
            // 기존 옵션 제거
            subCategorySelect.innerHTML = '<option value="">전체</option>';
            
            // 대분류에 따른 소분류 옵션 추가
if (majorCategory === '000-총류') {
	addSubCategories(['010-도서관, 서지학', '020-문헌정보학', '030-백과사전', '040-강연, 수필, 연설문집', '050-일반학회, 단체, 박물관', '060-일반전집', '070-신문, 언론, 저널리즘', '080-일반전집, 총서', '090-향토자료']);
} else if (majorCategory === '100-철학') {
	addSubCategories(['110-형이상학', '120-인식론, 인과론, 인간학', '130-세계', '140-경학', '150-동양철학, 사상', '160-서양철학', '170-논리학', '180-윤리학', '190-윤리, 도덕교육']);
} else if (majorCategory === '200-종교') {
	addSubCategories(['210-비교종교', '220-불교', '230-기독교', '240-도교', '250-천도교', '260-신도', '270-힌두교, 브라만교', '280-회교(이슬람교)', '290-기타 제종교']);
} else if (majorCategory === '300-사회학') {
	addSubCategories(['310-통계학', '320-경제학', '330-사회학, 사회문제', '340-정치학', '350-행정학', '360-법학', '370-교육학', '380-풍속, 민속학', '390-국방, 군사학']);
} else if (majorCategory === '400-자연과학') {
	addSubCategories(['410-수학', '420-물리학', '430-화학', '440-천문학', '450-지학', '460-생명과학', '470-식물학', '480-동물학', '490-기타 자연과학']);
} else if (majorCategory === '500-기술과학') {
	addSubCategories(['510-의학', '520-일반공학, 공학일반', '530-기계공학', '540-전기, 전자공학', '550-건축공학', '560-화학공학', '570-제조업', '580-생활과학', '590-기타 기술과학']);
} else if (majorCategory === '600-예술') {
	addSubCategories(['610-건축', '620-조각, 조형예술', '630-회화', '640-서예', '650-사진, 인쇄', '660-음악', '670-공연예술, 매체예술', '680-오락, 스포츠', '690-기타 예술']);
} else if (majorCategory === '700-언어') {
	addSubCategories(['710-한국어', '720-중국어', '730-일본어', '740-영어', '750-독일어', '760-프랑스어', '770-스페인어', '780-기타 언어']);
} else if (majorCategory === '800-문학') {
	addSubCategories(['810-한국문학', '820-중국문학', '830-일본문학', '840-영어문학', '850-독일문학', '860-프랑스문학', '870-스페인문학', '880-기타 문학']);
} else if (majorCategory === '900-역사') {
	addSubCategories(['910-한국사', '920-동양사', '930-서양사', '940-역사이론', '950-지리학', '960-지도, 여행', '970-문화사', '980-민속사', '990-기타 역사']);
}


            
            // 현재 URL에서 선택된 소분류가 있으면 선택 상태로 만들기
            const urlParams = new URLSearchParams(window.location.search);
            const selectedSubCategory = urlParams.get('subCategory');
            if (selectedSubCategory) {
                for (let i = 0; i < subCategorySelect.options.length; i++) {
                    if (subCategorySelect.options[i].value === selectedSubCategory) {
                        subCategorySelect.options[i].selected = true;
                        break;
                    }
                }
            }
        });
        
        // 소분류 옵션 추가 함수
        function addSubCategories(categories) {
            const subCategorySelect = document.getElementById('subCategory');
            categories.forEach(category => {
                const option = document.createElement('option');
                option.value = category;
                option.textContent = category;
                subCategorySelect.appendChild(option);
            });
        }
        
        // 페이지 로드 시 대분류에 따른 소분류 설정
        window.addEventListener('DOMContentLoaded', function() {
            const majorCategorySelect = document.getElementById('majorCategory');
            if (majorCategorySelect.value) {
                majorCategorySelect.dispatchEvent(new Event('change'));
            }
        });
        
        // 정렬 기능
        function sortBooks(sortType) {
            // 정렬 버튼 활성화 상태 변경
            document.querySelectorAll('.sort-button').forEach(button => {
                button.classList.remove('active');
            });
            event.target.classList.add('active');
            
            // 실제 구현 시 서버로 정렬 요청을 보내거나 클라이언트에서 정렬 처리
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('sort', sortType);
            window.location.href = currentUrl.toString();
        }
//         슬라이드
        $(document).ready(function() {
        	  // 첫 번째 슬라이드 활성화
        	  $('.slide:first-child').addClass('active');
        	  
        	  // 슬라이드 자동 전환 함수
        	  function nextSlide() {
        	    var currentSlide = $('.slide.active');
        	    var nextSlide = currentSlide.next('.slide').length ? currentSlide.next('.slide') : $('.slide:first-child');
        	    
        	    currentSlide.removeClass('active');
        	    nextSlide.addClass('active');
        	  }
        	  
        	  // 3초마다 슬라이드 전환
        	  setInterval(nextSlide, 3000);
        	});
    </script>
</body>
</html>