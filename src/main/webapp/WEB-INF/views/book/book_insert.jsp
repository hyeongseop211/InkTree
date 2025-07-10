<!-- <%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%> -->
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>도서 등록</title>
<link rel="stylesheet" type="text/css"
	href="/resources/css/book_insert.css">
<!-- <link rel="stylesheet" type="text/css" href="/css/book_insert.css"> -->
<script src="/resources/js/book_insert.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<script type="text/javascript">
	function fn_submit() {
	    const form = document.getElementById("frm"); 
	    // 유효성 검사 실행
	    if (!form.checkValidity()) {
	        form.reportValidity();  // 브라우저 기본 경고창 띄움
	        return;  // 중단
	    }
		var formData = $("#frm").serialize();//form 요소 자체

		//비동기 전송방식의 jquery 함수
		$.ajax({
			type : "post",
			data : formData,
			url : "book_insert",
			success : function(data) {
				alert("저장완료");
				location.href = "admin_view"
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
	<form id="frm">
		<h1>도서 등록 페이지</h1>

		<!-- 1행: ISBN -->
		<div class="form-row">
			<div class="input-group">
				<label>ISBN<input type="text" name="bookIsbn" required
					placeholder="ISBN을 입력하세요">
				</label>
			</div>
		</div>
		<!-- 			2행 :제목 -->
		<div class="form-row">
			<div class="input-group">
				<label> 제목<input type="text" name="bookTitle" required
					placeholder="도서 제목을 입력하세요">
				</label>
			</div>
		</div>
		<!-- 			<br> -->
		<!-- 3행: 내용 -->
		<div class="form-group">
			<label>도서 설명</label>
			<div class="input-container">
				<textarea name="bookComent" required placeholder="도서 설명을 입력해주세요"
					oninvalid="this.setCustomValidity('책의 간략한 내용을 입력해주세요')"
					oninput="setCustomValidity('')"></textarea>
			</div>
		</div>
		<!-- 			<br> -->
		<!-- 4행: 저자와 출판사-->
		<div class="form-row">
			<div class="input-group">
				<label> 저자<input type="text" name="bookWrite" required
					placeholder="저자 이름을 입력하세요">
				</label>
			</div>
			<div class="input-group">
				<label> 출판사<input type="text" name="bookPub" required
					placeholder="출판사 이름을 입력하세요">
				</label>
			</div>
		</div>
		<!-- 5행 재고 발행일 -->
		<div class="form-row">
			<div class="input-group">
				<label> 재고<input type="number" name="bookCount" required
					min="1" placeholder="보유 재고 수량을 입력하세요">
				</label>
			</div>
			<div class="input-group">
				<label> 발행일<input type="date" name="bookDate" required>
				</label>
			</div>
		</div>
		<!-- 			<br> -->
		<!-- 대분류 선택 -->
		<!-- 6행: 카테고리(대분류)와 카테고리(소분류) -->
		<div class="form-row category-row">
			<div class="input-group">
				<label> 카테고리(대분류) <select id="majorCategory"
					name="bookMajorCategory" required onchange="updateSubCategories()">
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
		</div>
		<!-- 소분류 선택 -->
		<div class="form-row category-row">
			<label> 카테고리(소분류) <select id="subCategory"
				name="bookSubCategory" required>
					<option value="">소분류를 선택하세요</option>
			</select>
			</label>
		</div>
		<br>
		<div class="form-button">
			<!--       <input type="submit" value="등록"> -->
			<input class="btn" type="button" value="등록" onclick="fn_submit()">
			<button type="reset">초기화</button>
			<button type="button" onclick="history.back()">취소</button>
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
