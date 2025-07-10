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
    <title>거래 게시판 - 잉크트리</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/trade_post_view.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="/resources/js/trade_post_view.js"></script>
</head>

<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="trade-container">
            <div class="trade-header">
                <h1 class="trade-title"><i class="fas fa-exchange-alt"></i> 거래 게시판</h1>
                <div class="trade-actions">
                    <c:if test="${not empty user}">
                        <button class="write-button" onclick="location.href='/trade_post_write'">
                            <i class="fas fa-pen"></i> 판매글 작성
                        </button>
                    </c:if>
                </div>
            </div>

<!--            <div class="trade-info-banner">-->
<!--                <div class="info-item">-->
<!--                    <i class="fas fa-clipboard-list"></i>-->
<!--                    <span>총 상품 <strong>${totalPosts}</strong>개</span>-->
<!--                </div>-->
<!--                <div class="info-item">-->
<!--                    <i class="fas fa-shopping-cart"></i>-->
<!--                    <span>거래 완료 <strong>${soldCount}</strong>건</span>-->
<!--                </div>-->
<!--            </div>-->

			<div class="search-section">
			    <form id="searchForm" method="get">
			        <!-- 검색 입력 필드 (가로로 길게) -->
			        <div class="search-input-wrapper">
						<input type="text" class="search-input" id="keyword" name="keyword" 
						       value="${pageMaker.searchBookCriteriaDTO.keyword}" 
						       placeholder="제목으로 검색">
			            <button type="submit" class="search-button">
			                <i class="fas fa-search"></i>
			            </button>
			        </div>
			        
			        <!-- 필터 라벨 행 -->
			        <div class="filter-labels-row">
<!--			            <div class="filter-label">검색 유형</div>-->
			            <div class="filter-label">대분류</div>
			            <div class="filter-label">중분류</div>
			        </div>
			        
			        <!-- 필터 선택 행 -->
			        <div class="filters-row">
			            <!-- 검색 유형 -->
<!--			            <select class="filter-select" id="type" name="type">-->
<!--			                <option value="T" ${pageMaker.searchBookCriteriaDTO.type eq 'T' ? 'selected' : ''}>도서명</option>-->
<!--			                <option value="A" ${pageMaker.searchBookCriteriaDTO.type eq 'A' ? 'selected' : ''}>저자</option>-->
<!--			                <option value="I" ${pageMaker.searchBookCriteriaDTO.type eq 'I' ? 'selected' : ''}>ISBN</option>-->
<!--			                <option value="P" ${pageMaker.searchBookCriteriaDTO.type eq 'P' ? 'selected' : ''}>출판사</option>-->
<!--			            </select>-->
			            
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
			        <input type="hidden" name="pageNum" value="1">
			        <input type="hidden" name="amount" value="${pageMaker.searchBookCriteriaDTO.amount}">
			        <input type="hidden" name="status" value="${param.status}">
			        <input type="hidden" name="sort" value="${param.sort}">
			    </form>
			</div>

            <div class="filter-options">
                <div class="filter-option ${param.status == 'all' || param.status == null ? 'active' : ''}" onclick="changeFilter('all')">전체</div>
                <div class="filter-option ${param.status == 'available' ? 'active' : ''}" onclick="changeFilter('available')">판매중</div>
                <div class="filter-option ${param.status == 'reserved' ? 'active' : ''}" onclick="changeFilter('reserved')">예약중</div>
                <div class="filter-option ${param.status == 'sold' ? 'active' : ''}" onclick="changeFilter('sold')">판매완료</div>
            </div>

            <div class="sort-options">
                <div class="sort-option ${param.sort == 'latest' || param.sort == null ? 'active' : ''}" onclick="changeSort('latest')">최신순</div>
                <div class="sort-option ${param.sort == 'lowPrice' ? 'active' : ''}" onclick="changeSort('lowPrice')">낮은가격순</div>
                <div class="sort-option ${param.sort == 'highPrice' ? 'active' : ''}" onclick="changeSort('highPrice')">높은가격순</div>
                <div class="sort-option ${param.sort == 'views' ? 'active' : ''}" onclick="changeSort('views')">조회순</div>
            </div>

            <div class="trade-grid">
                <c:if test="${empty postList}">
                    <div class="empty-message">등록된 상품이 없습니다.</div>
                </c:if>

                <c:forEach items="${postList}" var="post" varStatus="status">
                    <div class="trade-item ${post.status == 'SOLD' ? 'sold' : post.status == 'RESERVED' ? 'reserved' : ''}">
<!--                        <a href="trade_post_detail_view?postID=${post.postID}&pageNum=${pageMaker.searchBookCriteriaDTO.pageNum}&amount=${pageMaker.searchBookCriteriaDTO.amount}${not empty pageMaker.searchBookCriteriaDTO.type ? '&type='.concat(pageMaker.searchBookCriteriaDTO.type) : ''}${not empty pageMaker.searchBookCriteriaDTO.keyword ? '&keyword='.concat(pageMaker.searchBookCriteriaDTO.keyword) : ''}" class="trade-link">-->
						<c:choose>
						    <c:when test="${empty param.status && empty param.sort}">
						        <a href="trade_post_detail_view?postID=${post.postID}&pageNum=${pageMaker.searchBookCriteriaDTO.pageNum}&amount=${pageMaker.searchBookCriteriaDTO.amount}&status=all&sort=latest" class="trade-link">
						    </c:when>
						    <c:when test="${empty param.status}">
						        <a href="trade_post_detail_view?postID=${post.postID}&pageNum=${pageMaker.searchBookCriteriaDTO.pageNum}&amount=${pageMaker.searchBookCriteriaDTO.amount}&status=all&sort=${param.sort}" class="trade-link">
						    </c:when>
						    <c:when test="${empty param.sort}">
						        <a href="trade_post_detail_view?postID=${post.postID}&pageNum=${pageMaker.searchBookCriteriaDTO.pageNum}&amount=${pageMaker.searchBookCriteriaDTO.amount}&status=${param.status}&sort=latest" class="trade-link">
						    </c:when>
						    <c:otherwise>
						        <a href="trade_post_detail_view?postID=${post.postID}&pageNum=${pageMaker.searchBookCriteriaDTO.pageNum}&amount=${pageMaker.searchBookCriteriaDTO.amount}&status=${param.status}&sort=${param.sort}" class="trade-link">
						    </c:otherwise>
						</c:choose>
							<input type="hidden" value="">
<!--                        <a href="trade_post_detail_view?postID=${post.postID}" class="trade-link">-->
                            <div class="trade-image">

                                <c:if test="${post.status == 'SOLD'}">
                                    <div class="status-overlay sold">판매완료</div>
                                </c:if>
                                <c:if test="${post.status == 'RESERVED'}">
                                    <div class="status-overlay reserved">예약중</div>
                                </c:if>
                            </div>
                            <div class="trade-info">
                                <h3 class="trade-title">${post.title}
                                </h3>
								<div class="book-categories">
									<span class="book-category">${post.bookMajorCategory}</span>
									<c:if test="${not empty post.bookSubCategory}">
										<span class="book-category">${post.bookSubCategory}</span>
									</c:if>
								</div>
                                <div class="trade-price"><fmt:formatNumber value="${post.price}" pattern="#,###" />원</div>
                                <div class="trade-meta">
                                    <span class="trade-location"><i class="fas fa-map-marker-alt"></i> ${post.location}</span>
                                    <span class="trade-time">
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
                                </div>

                                <div class="trade-seller">
                                    <i class="fas fa-user"></i> ${post.userName}
                                </div>
                            </div>
                        </a>
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
            <form id="actionForm" action="trade_post_view" method="get">
                <input type="hidden" name="pageNum" value="${pageMaker.searchBookCriteriaDTO.pageNum}">
                <input type="hidden" name="amount" value="${pageMaker.searchBookCriteriaDTO.amount}">
                <input type="hidden" name="status" value="${param.status}">
                <input type="hidden" name="sort" value="${param.sort}">
                <c:if test="${not empty pageMaker.searchBookCriteriaDTO.type}">
                    <input type="hidden" name="type" value="${pageMaker.searchBookCriteriaDTO.type}">
                </c:if>
                <c:if test="${not empty pageMaker.searchBookCriteriaDTO.keyword}">
                    <input type="hidden" name="keyword" value="${pageMaker.searchBookCriteriaDTO.keyword}">
                </c:if>
                <c:if test="${not empty param.bookMajorCategory}">
                    <input type="hidden" name="bookMajorCategory" value="${param.bookMajorCategory}">
                </c:if>
                <c:if test="${not empty param.bookSubCategory}">
                    <input type="hidden" name="bookSubCategory" value="${param.bookSubCategory}">
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

                actionForm.find("input[name='pageNum']").val($(this).attr("href"));
                actionForm.submit();
            });

            // 검색처리
            var searchForm = $("#searchForm");

            $("#searchForm button").on("click", function (e) {
                e.preventDefault();
                // 키워드 입력 받을 조건
                //if (searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='keyword']").val()) {
                  //  alert("키워드를 입력하세요.");
                    //return false;
                //}

                searchForm.find("input[name='pageNum']").val("1"); // 검색 시 1페이지로 이동
                searchForm.submit();
            });

            // type 콤보박스 변경
            $("#searchForm select").on("change", function () {
                if (searchForm.find("option:selected").val() == "") {
                    // 키워드를 널값으로 변경
                    searchForm.find("input[name='keyword']").val("");
                }
            });

            // 필터 변경
            function changeFilter(status) {
                actionForm.find("input[name='status']").val(status);
                actionForm.find("input[name='pageNum']").val("1");
                actionForm.submit();
            }

            // 정렬 변경
            function changeSort(sort) {
                actionForm.find("input[name='sort']").val(sort);
                actionForm.find("input[name='pageNum']").val("1");
                actionForm.submit();
            }
            
            // 대분류에 따른 소분류 옵션 변경
            $(document).ready(function() {
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
            });
        </script>
    </div>
</body>

</html>