<%@page import="com.boot.user.dto.UserDTO" %>
<%@page import="com.boot.trade.dto.TradePostDTO" %>
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
    <title>거래 게시글 수정 - 잉크트리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/resources/css/trade_post_update.css">
</head>

<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="board-container">
            <div class="board-form">
                <div class="form-header">
                    <h1 class="form-title"><i class="fas fa-edit"></i> 거래 게시글 수정</h1>
                    <p class="form-description">판매하실 상품 정보를 수정해주세요. 정확한 정보를 입력하면 더 빠른 거래가 가능합니다.</p>
                </div>

                <form id="updateForm" action="trade_post_update_ok" method="post">
                    <!-- 히든 필드 -->
                    <input type="hidden" name="postID" value="${post.postID}">
                    <input type="hidden" name="pageNum" value="${param.pageNum}">
                    <input type="hidden" name="amount" value="${param.amount}">
                    <input type="hidden" name="userNumber" value="${post.userNumber}">
                    
                    <!-- 제목 입력 -->
                    <div class="form-group">
                        <label for="title" class="form-label">제목</label>
                        <input type="text" id="title" name="title" class="form-control" value="${post.title}" required>
                    </div>
                    
                    <!-- 카테고리와 가격을 한 줄에 배치 -->
                    <div class="form-row">
                        <div class="form-group form-group-half">
                            <label for="bookMajorCategory" class="form-label">카테고리</label>
                            <select id="bookMajorCategory" name="bookMajorCategory" class="form-control" required>
                                <option value="">대분류 선택</option>
                                <option value="000-총류" ${post.bookMajorCategory == '000-총류' ? 'selected' : ''}>000 - 총류</option>
                                <option value="100-철학" ${post.bookMajorCategory == '100-철학' ? 'selected' : ''}>100 - 철학</option>
                                <option value="200-종교" ${post.bookMajorCategory == '200-종교' ? 'selected' : ''}>200 - 종교</option>
                                <option value="300-사회학" ${post.bookMajorCategory == '300-사회학' ? 'selected' : ''}>300 - 사회학</option>
                                <option value="400-자연과학" ${post.bookMajorCategory == '400-자연과학' ? 'selected' : ''}>400 - 자연과학</option>
                                <option value="500-기술과학" ${post.bookMajorCategory == '500-기술과학' ? 'selected' : ''}>500 - 기술과학</option>
                                <option value="600-예술" ${post.bookMajorCategory == '600-예술' ? 'selected' : ''}>600 - 예술</option>
                                <option value="700-언어" ${post.bookMajorCategory == '700-언어' ? 'selected' : ''}>700 - 언어</option>
                                <option value="800-문학" ${post.bookMajorCategory == '800-문학' ? 'selected' : ''}>800 - 문학</option>
                                <option value="900-역사" ${post.bookMajorCategory == '900-역사' ? 'selected' : ''}>900 - 역사</option>
                            </select>
                        </div>
                        
                        <div class="form-group form-group-half">
                            <label for="bookSubCategory" class="form-label">세부 카테고리</label>
                            <select id="bookSubCategory" name="bookSubCategory" class="form-control">
                                <option value="">전체</option>
                                <!-- 대분류에 따라 동적으로 변경됩니다 -->
                            </select>
                        </div>
                    </div>
                    
                    <!-- 가격과 위치를 한 줄에 배치 -->
                    <div class="form-row">
                        <div class="form-group form-group-half">
                            <label for="price" class="form-label">가격</label>
                            <div class="price-input-wrapper">
                                <input type="number" id="price" name="price" class="form-control" value="${post.price}" min="0" required>
                                <span class="price-unit">원</span>
                            </div>
                        </div>
                        
                        <div class="form-group form-group-half">
                            <label for="location" class="form-label">거래 희망 장소</label>
                            <input type="text" id="location" name="location" class="form-control" value="${post.location}" required>
                        </div>
                    </div>
                    
                    <!-- 상태 선택 -->
                    <div class="form-group">
                        <label class="form-label">상태</label>
                        <div class="status-group">
                            <input type="radio" id="statusAvailable" name="status" value="AVAILABLE" class="status-radio" ${post.status == 'AVAILABLE' ? 'checked' : ''}>
                            <label for="statusAvailable" class="status-label available">판매중</label>
                            
                            <input type="radio" id="statusReserved" name="status" value="RESERVED" class="status-radio" ${post.status == 'RESERVED' ? 'checked' : ''}>
                            <label for="statusReserved" class="status-label reserved">예약중</label>
                            
                            <input type="radio" id="statusSold" name="status" value="SOLD" class="status-radio" ${post.status == 'SOLD' ? 'checked' : ''}>
                            <label for="statusSold" class="status-label sold">판매완료</label>
                        </div>
                    </div>
                    
                    <!-- 내용 입력 -->
                    <div class="form-group">
                        <label for="content" class="form-label">상품 설명</label>
                        <textarea id="content" name="content" class="form-textarea" required>${post.content}</textarea>
                    </div>
                    
                    <!-- 버튼 그룹 -->
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="history.back()">
                            <i class="fas fa-times"></i> 취소
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check"></i> 수정 완료
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
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
                
                // 기존 소분류 선택
                const selectedSubCategory = '${post.bookSubCategory}';
                if (selectedSubCategory) {
                    setTimeout(function() {
                        $('#bookSubCategory').val(selectedSubCategory);
                    }, 100);
                }
            }
            
            // 가격 입력 시 천 단위 콤마 표시
			$("#price").on("input", function() {
			    // 숫자만 입력 가능하도록
			    this.value = this.value.replace(/[^0-9]/g, '');
			    
			    // 10자리 이상 입력 방지
			    if (this.value.length >= 10) {
			        alert("가격은 999,999,999원 이하로 입력해주세요.");
			        this.value = this.value.substring(0, 9);
			    }
			});
            
            // 폼 제출 전 유효성 검사
            $('#updateForm').on('submit', function(e) {
                // 제목 검사
                const title = $('#title').val().trim();
                if (title === '') {
                    alert('제목을 입력해주세요.');
                    $('#title').focus();
                    e.preventDefault();
                    return false;
                }
                
                // 가격 검사
                const price = $('#price').val();
                if (price === '' || isNaN(price) || parseInt(price) < 0) {
                    alert('유효한 가격을 입력해주세요.');
                    $('#price').focus();
                    e.preventDefault();
                    return false;
                }
                
                // 대분류 검사
                const bookMajorCategory = $('#bookMajorCategory').val();
                if (bookMajorCategory === '') {
                    alert('대분류를 선택해주세요.');
                    $('#bookMajorCategory').focus();
                    e.preventDefault();
                    return false;
                }
                
                // 위치 검사
                const location = $('#location').val().trim();
                if (location === '') {
                    alert('거래 위치를 입력해주세요.');
                    $('#location').focus();
                    e.preventDefault();
                    return false;
                }
                
                // 내용 검사
                const content = $('#content').val().trim();
                if (content === '') {
                    alert('내용을 입력해주세요.');
                    $('#content').focus();
                    e.preventDefault();
                    return false;
                }
                
                return true;
            });
        });
    </script>
</body>

</html>