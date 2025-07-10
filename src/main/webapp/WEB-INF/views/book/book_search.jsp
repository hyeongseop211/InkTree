<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>도서 검색 - 잉크 트리</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/book_search.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/board_view.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">
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
    <jsp:include page="../header.jsp" />

	<div class="container">
		<div class="search-header">
			<h1 class="search-title">
				<i class="fas fa-book"></i> 도서 검색
			</h1>

			<form class="search-form" id="search-form" method="get">
				<!-- 메인 검색창 -->
				<div class="search-main">
<!--					<input type="text" class="search-input-main" id="searchKeyword"-->
<!--						name="searchKeyword" value="${param.searchKeyword}"-->
<!--						placeholder="도서명, 저자, ISBN 또는 출판사를 입력하세요">-->
					<input type="text" class="search-input-main" id="keyword"
					       name="keyword" value="${pageMaker.searchBookCriteriaDTO.keyword}"
					       placeholder="도서명, 저자, ISBN 또는 출판사를 입력하세요">
					<button type="button" class="search-button-main"
						onclick="fn_submit()">
						<i class="fas fa-search"></i>
					</button>
				</div>

				<!-- 필터 옵션 -->
				<div class="search-filters">
<!--					<div class="search-filter">-->
<!--						<label class="filter-label" for="searchType">검색 유형</label> <select-->
<!--							class="filter-select" id="searchType" name="searchType">-->
<!--							<option value="title"-->
<!--								${param.searchType == 'title' ? 'selected' : ''}>도서명</option>-->
<!--							<option value="author"-->
<!--								${param.searchType == 'author' ? 'selected' : ''}>저자</option>-->
<!--							<option value="isbn"-->
<!--								${param.searchType == 'isbn' ? 'selected' : ''}>ISBN</option>-->
<!--							<option value="publisher"-->
<!--								${param.searchType == 'publisher' ? 'selected' : ''}>출판사</option>-->
<!--						</select>-->
<!--					</div>-->
					<div class="search-filter">
			            <label class="filter-label" for="type">검색 유형</label>
			            <select class="filter-select" id="type" name="type">
			                <option value="T" ${pageMaker.searchBookCriteriaDTO.type eq 'T' ? 'selected' : ''}>도서명</option>
			                <option value="A" ${pageMaker.searchBookCriteriaDTO.type eq 'A' ? 'selected' : ''}>저자</option>
			                <option value="I" ${pageMaker.searchBookCriteriaDTO.type eq 'I' ? 'selected' : ''}>ISBN</option>
			                <option value="P" ${pageMaker.searchBookCriteriaDTO.type eq 'P' ? 'selected' : ''}>출판사</option>
			            </select>
			        </div>

					<div class="search-filter">
						<label class="filter-label" for="majorCategory">대분류</label> <select
							class="filter-select" id="majorCategory" name="majorCategory">
							<option value="">전체</option>
							<option value="000-총류"
								${param.majorCategory == '000' ? 'selected' : ''}>000 -
								총류</option>
							<option value="100-철학"
								${param.majorCategory == '100' ? 'selected' : ''}>100 -
								철학</option>
							<option value="200-종교"
								${param.majorCategory == '200' ? 'selected' : ''}>200 -
								종교</option>
							<option value="300-사회학"
								${param.majorCategory == '300' ? 'selected' : ''}>300 -
								사회학</option>
							<option value="400-자연과학"
								${param.majorCategory == '400' ? 'selected' : ''}>400 -
								자연과학</option>
							<option value="500-기술과학"
								${param.majorCategory == '500' ? 'selected' : ''}>500 -
								기술과학</option>
							<option value="600-예술"
								${param.majorCategory == '600' ? 'selected' : ''}>600 -
								예술</option>
							<option value="700-언어"
								${param.majorCategory == '700' ? 'selected' : ''}>700 -
								언어</option>
							<option value="800-문학"
								${param.majorCategory == '800' ? 'selected' : ''}>800 -
								문학</option>
							<option value="900-역사"
								${param.majorCategory == '900' ? 'selected' : ''}>900 -
								역사</option>
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
<!--				<input type="hidden" name="pageNum" value="1">-->
<!--				<input type="hidden" name="amount" value="${pageMaker.criteriaDTO.amount}">-->
			</form>
			<form id="actionForm" action="book_search_view" method="get">
			    <input type="hidden" name="pageNum" value="${pageMaker.searchBookCriteriaDTO.pageNum}">
			    <input type="hidden" name="amount" value="${pageMaker.searchBookCriteriaDTO.amount}">
			    <input type="hidden" name="type" value="${pageMaker.searchBookCriteriaDTO.type}">
			    <input type="hidden" name="keyword" value="${pageMaker.searchBookCriteriaDTO.keyword}">
			    <input type="hidden" name="majorCategory" value="${param.majorCategory}">
			    <input type="hidden" name="subCategory" value="${param.subCategory}">
			</form>
		</div>

		<div class="results-container">
			<div class="results-header">
				<h2 class="results-title">
					검색 결과 <span class="results-count">${total}권</span>
				</h2>

				<div class="results-sort">
					<button class="sort-button active" onclick="sortBooks('latest')">최신순</button>
					<button class="sort-button" onclick="sortBooks('title')">제목순</button>
					<button class="sort-button" onclick="sortBooks('popular')">인기순</button>
				</div>
			</div>

			<c:choose>
				<c:when test="${empty bookList}">
					<div class="no-results">
						<i class="fas fa-search"></i>
						<p>검색 결과가 없습니다.</p>
						<p>다른 검색어로 다시 시도해보세요.</p>
					</div>
				</c:when>
				<c:otherwise>
					<div class="book-grid">
						<c:forEach items="${bookList}" var="book">
							<div class="book-card">
								<div class="book-cover">
									<!-- 실제 구현 시 도서 이미지 경로를 사용해야함 -->
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
						</c:forEach>
					</div>

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
								<li class="paginate_button ${pageMaker.searchBookCriteriaDTO.pageNum==num ? 'active' : ''}">
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
					<form id="actionForm" action="board_view" method="get">
						<input type="hidden" name="pageNum" value="${pageMaker.searchBookCriteriaDTO.pageNum}">
						<input type="hidden" name="amount" value="${pageMaker.searchBookCriteriaDTO.amount}">
					</form>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<script>
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
		
		// 페이징처리
		var actionForm = $("#actionForm");

		// 페이지번호 처리
		// 페이지네이션 링크 클릭 이벤트 처리
		$(".paginate_button a").on("click", function(e) {
		    e.preventDefault();
		    
		    // 현재 URL 가져오기
		    var url = new URL(window.location.href);
		    var params = new URLSearchParams(url.search);
		    
		    // 페이지 번호 설정
		    params.set("pageNum", $(this).attr("href"));

		    // 새 URL로 이동
		    window.location.href = url.pathname + "?" + params.toString();
		});

		// 게시글 처리
		$(".move_link").on("click", function (e) {
		    e.preventDefault();
		    console.log("move_link click");
		    console.log("@# click => " + $(this).attr("href"));

		    var targetBno = $(this).attr("href");

		    // 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 게시글 클릭 할 때 &boardNo=번호 게속 누적되는 거 방지)
		    var bno = actionForm.find("input[name='boardNo']").val();
		    if (bno != "") {
		        actionForm.find("input[name='boardNo']").remove();
		    }

		    // "content_view?boardNo=${dto.boardNo}"를 actionForm로 처리
		    actionForm.append("<input type='hidden' name='boardNo' value='" + targetBno + "'>");
		    // actionForm.submit();
		    // 컨트롤러에 content_view로 찾아감
		    actionForm.attr("action", "board_detail_view").submit();
		});

		// 검색처리
		var searchForm = $("#search-form");

		$("#search-form button").on("click", function () {
		    // alert("검색");

		    // 키워드 입력 받을 조건
<!--		    if (searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='keyword']").val()) {-->
<!--		        alert("키워드를 입력하세요.");-->
<!--		        return false;-->
<!--		    }-->

		    // searchForm.find("input[name='pageNum']").val("1"); // 검색 시 1페이지로 이동
		    searchForm.attr("action", "board_view").submit();
		}); // end of searchForm click

		// type 콤보박스 변경
		$("#search-form select").on("change", function () {
		    if (searchForm.find("option:selected").val() == "") {
		        // 키워드를 널값으로 변경
		        searchForm.find("input[name='keyword']").val("");
		    }
		}); // end of searchForm click 2
		
    </script>
</body>
</html>