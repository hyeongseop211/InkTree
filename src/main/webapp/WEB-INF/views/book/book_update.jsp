<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta charset="UTF-8">
<title>도서 정보 수정</title>
<script src="/resources/js/book_update.js"></script>
<link rel="stylesheet" type="text/css"
	href="/resources/css/book_update.css">
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<script type="text/javascript">
	function fn_submit() {
	    const form = document.getElementById("updateForm"); 
	    // 유효성 검사 실행
	    if (!form.checkValidity()) {
	        form.reportValidity();  // 브라우저 기본 경고창 띄움
	        return;  // 중단
	    }
		var formData = $("#updateForm").serialize();//form 요소 자체

		//비동기 전송방식의 jquery 함수
		$.ajax({
			type : "post",
			data : formData,
			url : "update_book_ok",
			success : function(data) {
				alert("수정완료");
				location.href = "book_detail?bookNumber=" + ${book.bookNumber}
			},
			error : function() {
				alert("오류발생");
			}
		});
	}
</script>
</head>
<body>
    <jsp:include page="../header.jsp" />
	<form id="updateForm">
		<h2>도서 정보 수정</h2>
		<!-- 		1행 도서번호, ISBN -->
		<div>
			<label for="bookNumber">도서번호</label> <input type="number"
				id="bookNumber" name="bookNumber" value="${book.bookNumber}"
				readonly />
		</div>
		<div class="form-group">
			<label>ISBN</label> <input type="text" name="bookIsbn" required
				value="${book.bookIsbn}" placeholder="Isbn을 입력해주세요."
				oninvalid="this.setCustomValidity('올바른 Isbn 형식으로 입력해주세요.')"
				oninput="setCustomValidity('')">
			<!-- 				<span class="input-hint">Isbn을 입력해주세요. -->
			</span> <span class="error-message">Isbn 형식을 입력해주세요.</span>
		</div>
		<!-- 			2행 도서제목 -->
		<div class="form-group">
			<label>도서 제목</label> <input type="text" name="bookTitle" required
				value="${book.bookTitle}" placeholder="도서제목을 입력해주세요."
				oninvalid="this.setCustomValidity('도서제목을 입력해주세요.')"
				oninput="setCustomValidity('')">
			<!-- 			   <span class="input-hint">도서제목을 입력해주세요.</span>  -->
			<span class="error-message">도서제목을 입력해주세요.</span>
		</div>

		<!-- 		3행 도서 설명 -->
		<!-- 				<div class="form-group"> -->
		<!-- 					<label>도서 설명</label>  -->
		<!-- 					<div class="input-container"> -->
		<!-- 					<input type="text" name="bookComent" required -->
		<%-- 						value="${book.bookComent}"  --%>
		<!-- 						oninvalid="this.setCustomValidity('도서설명을 입력해주세요.')" -->
		<!-- 						oninput="setCustomValidity('')" -->
		<!-- 						placeholder="도서설명을 입력해주세요"> -->

		<!-- 					</div> -->
		<!-- 						<span class="input-hint">도서설명을 입력해주세요.</span>  -->
		<!-- 						<span class="error-message">도서설명을 입력해주세요.</span> -->
		<!-- 				</div> -->
		<div class="form-group">
			<label>도서 설명</label>
			<div class="input-container">
				<textarea name="bookComent" required placeholder="도서 설명을 입력해주세요"
					oninvalid="this.setCustomValidity('도서설명을 입력해주세요.')"
					oninput="setCustomValidity('')">${book.bookComent}</textarea>
			</div>
			<span class="error-message">도서설명을 입력해주세요.</span>
		</div>
		<!-- 4행 저자,출판사 -->
		<div class="form-group">
			<label>저자</label> <input type="text" name="bookWrite" required
				value="${book.bookWrite}" placeholder="저자"
				oninvalid="this.setCustomValidity('저자의 이름을 입력해주세요.')"
				oninput="setCustomValidity('')">
			<!-- 				<span class="input-hint">저자의 이름을 입력해주세요.</span>  -->
			<span class="error-message">저자의 이름을 입력해주세요.</span>
		</div>

		<div class="form-group">
			<label>출판사</label> <input type="text" name="bookPub" required
				value="${book.bookPub}" placeholder="출판사"
				oninvalid="this.setCustomValidity('출판사 이름을 입력해주세요.')"
				oninput="setCustomValidity('')">
			<!-- 				<span class="input-hint">출판사 이름을 입력해주세요.</span>  -->
			<span class="error-message">출판사 이름을 입력해주세요.</span>
		</div>
		<!-- 5행 발행일 -->
		<div class="form-group">
			<label>발행일</label> <input type="date" name="bookDate" required
				value="${book.bookDate}" placeholder="발행일"
				oninvalid="this.setCustomValidity('발행일을 입력해주세요.')"
				oninput="setCustomValidity('')">
			<!-- 				<span class="input-hint">발행일을 입력해주세요.</span>  -->
			<span class="error-message">발헹일을 입력해주세요.</span>
		</div>
		<!-- 6행 주 카테고리, 하위 카테고리 -->
		<div class="form-group category-row">
			<label> 카테고리(대분류) <select id="majorCategory"
				name="bookMajorCategory" required>
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
			</label>
		</div>
		<!-- 소분류 선택 -->
		<div class="form-group category-row">
			<label> 카테고리(중분류) <select id="subCategory"
				name="bookSubCategory" required>
					<option value="">전체</option>
			</select>
			</label>
		</div>
		<!-- 7행 재고, 대출횟수(읽기전용) -->
		<div class="form-group">
			<label>재고</label> <input type="number" name="bookCount" required
				min="1" value="${book.bookCount}" placeholder="보유 재고 수량을 입력하세요"
				oninvalid="this.setCustomValidity('보유 재고 수량을 입력해주세요.')"
				oninput="setCustomValidity('')">
			<!-- 				 <span class="input-hint">보유 재고 수량을 입력해주세요.</span>  -->
			<span class="error-message">보유 재고 수량을 입력해주세요.</span>
		</div>
		<div>
			<label for="bookBorrowcount">대출횟수</label> <input type="number"
				id="bookBorrowcount" name="bookBorrowcount"
				value="${book.bookBorrowcount}" readonly />
		</div>
		<!-- 8행 저장 취소 삭제 버튼 -->
		<div>
			<!-- 			<input type="button" onclick="fn_submit()" value="수정 완료"> -->
			<input class="btn" type="button" value="등록" onclick="fn_submit()">
			<button type="reset">초기화</button>
			<button type="button" onclick="history.back()">취소</button>
			<!--                <button type="button" onclick="if(confirm('정말로 모든 도서 정보를 삭제하시겠습니까?')) -->
			<!--             	   location.href='deleteBookInfo.jsp'">삭제</button> -->
		</div>

	</form>

	<script>
    document.getElementById('majorCategory').addEventListener('change', function() {
        const majorCategory = this.value;
        const subCategorySelect = document.getElementById('subCategory');
        
        // 기존 옵션 제거
        subCategorySelect.innerHTML = '<option value="">소분류선택</option>';
        
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
	</script>
</body>
</html>
