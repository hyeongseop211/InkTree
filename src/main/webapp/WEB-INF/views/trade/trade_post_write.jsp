<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="com.boot.user.dto.UserDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>판매글 작성 - 잉크트리</title>
<link rel="stylesheet" type="text/css"
	href="/resources/css/trade_post_write.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css"
	rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
<script src="/resources/js/trade_post_write.js"></script>

</head>
<body>
    <jsp:include page="../header.jsp" />
	<div class="container">
		<div class="board-container">
			<div class="board-form">
				<div class="form-header">
					<h1 class="form-title"><i class="fas fa-tags"></i> 판매글 작성</h1>
					<p class="form-description">판매하실 상품 정보를 입력해주세요. 정확한 정보를 입력하면 더 빠른 거래가 가능합니다.</p>
				</div>

				<form id="frm" enctype="multipart/form-data">
					<input type="hidden" name="userNumber" value="${user.userNumber}"> 
					<input type="hidden" name="userName" value="${user.userName}">
					<input type="hidden" name="content" id="content">

					<div class="form-group">
						<label for="title" class="form-label">제목</label> 
						<input
							type="text" id="title" name="title" class="form-control"
							placeholder="상품 제목을 입력하세요" required>
					</div>
                    
                    <div class="form-row">
                        <div class="form-group form-group-half">
                            <label for="BookMajorCategory" class="form-label">카테고리</label>
                            <select class="form-control" id="BookMajorCategory" name="BookMajorCategory" required>
                                <option value="" disabled selected>카테고리 선택</option>
                                <option value="000-총류">000 - 총류</option>
                                <option value="100-철학">100 - 철학</option>
                                <option value="200-종교">200 - 종교</option>
                                <option value="300-사회학">300 - 사회학</option>
                                <option value="400-자연과학">400 - 자연과학</option>
                                <option value="500-기술과학">500 - 기술과학</option>
                                <option value="600-예술">600 - 예술</option>
                                <option value="700-언어">700 - 언어</option>
                                <option value="800-문학">800 - 문학</option>
                                <option value="900-역사">900 - 역사</option>
                            </select>
                        </div>
                        
                        <div class="form-group form-group-half">
                            <label for="BookSubCategory" class="form-label">세부 카테고리</label>
                            <select class="form-control" id="BookSubCategory" name="BookSubCategory">
                                <option value="">전체</option>
                                <!-- 대분류에 따라 동적으로 변경됩니다 -->
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group form-group-half">
                            <label for="price" class="form-label">가격</label>
                            <div class="price-input-wrapper">
                                <input type="number" id="price" name="price" class="form-control"
                                    placeholder="숫자만 입력" required min="0">
                                <span class="price-unit">원</span>
                            </div>
                        </div>
                        
                        <div class="form-group form-group-half">
                            <label for="location" class="form-label">거래 희망 장소</label>
							<input type="text" id="location" name="location" class="form-control"
							       placeholder="예: 서울특별시 강남구, 2호선 홍대입구역" 
							       value="${addr}" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">상품 이미지</label>
                        <div class="image-upload-container">
                            <div class="image-preview-area" id="imagePreviewArea">
                                <div class="image-upload-placeholder" id="uploadPlaceholder">
                                    <i class="fas fa-camera"></i>
                                    <p>이미지 추가 (최대 5장)</p>
                                    <span class="upload-guide">* 첫번째 사진이 대표 이미지로 사용됩니다</span>
                                </div>
                            </div>
                            <input type="file" id="imageUpload" name="images" multiple accept="image/*" style="display: none;">
                            <button type="button" id="uploadButton" class="btn btn-outline">
                                <i class="fas fa-plus"></i> 이미지 선택
                            </button>
                        </div>
                        <div id="imageError" class="error-message"></div>
                    </div>

					<div class="form-group">
						<label for="editor" class="form-label">상품 설명</label>
						<div id="editor" class="editor-container"></div>
						<div id="contentError" class="error-message"></div>
                        <div class="content-guide">
                            <p><i class="fas fa-info-circle"></i> 상품 설명 작성 팁</p>
                            <ul>
                                <li>구매 시기와 사용 기간</li>
                                <li>제품의 상태 (하자 여부)</li>
                                <li>브랜드 및 모델명</li>
                                <li>거래 방법 (직거래/택배)</li>
                            </ul>
                        </div>
					</div>

					<div class="form-actions">
						<button type="button" class="btn btn-secondary"
							onclick="location.href='trade_post_view'">
							<i class="fas fa-times"></i> 취소
						</button>
						<button type="button" class="btn btn-primary" onclick="fn_submit()">
							<i class="fas fa-check"></i> 등록하기
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		// 이미지 미리보기 처리
        $(document).ready(function() {
            // 이미지 업로드 버튼 클릭 시 파일 선택 창 열기
            $("#uploadButton").click(function() {
                $("#imageUpload").click();
            });
            
            // 이미지 선택 시 미리보기 생성
            $("#imageUpload").change(function() {
                const files = this.files;
                
                // 최대 5개 이미지 제한
                if (files.length > 5) {
                    alert("이미지는 최대 5개까지 업로드 가능합니다.");
                    this.value = "";
                    return;
                }
                
                // 기존 미리보기 초기화
                $("#imagePreviewArea").empty();
                
                // 각 파일에 대한 미리보기 생성
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    
                    // 이미지 파일인지 확인
                    if (!file.type.match('image.*')) {
                        continue;
                    }
                    
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        const previewDiv = $('<div class="image-preview-item"></div>');
                        const img = $('<img>').attr('src', e.target.result);
                        const removeBtn = $('<button type="button" class="remove-image"><i class="fas fa-times"></i></button>');
                        
                        // 삭제 버튼 클릭 이벤트
                        removeBtn.click(function() {
                            previewDiv.remove();
                            
                            // 모든 미리보기가 삭제되면 placeholder 다시 표시
                            if ($("#imagePreviewArea .image-preview-item").length === 0) {
                                $("#imagePreviewArea").append(
                                    '<div class="image-upload-placeholder" id="uploadPlaceholder">' +
                                    '<i class="fas fa-camera"></i>' +
                                    '<p>이미지 추가 (최대 5장)</p>' +
                                    '<span class="upload-guide">* 첫번째 사진이 대표 이미지로 사용됩니다</span>' +
                                    '</div>'
                                );
                            }
                        });
                        
                        previewDiv.append(img);
                        previewDiv.append(removeBtn);
                        $("#imagePreviewArea").append(previewDiv);
                    };
                    
                    reader.readAsDataURL(file);
                }
                
                // placeholder 제거
                $("#uploadPlaceholder").remove();
            });
            
            // 대분류에 따른 소분류 옵션 변경
            $('#BookMajorCategory').on('change', function() {
                const BookMajorCategory = $(this).val();
                const BookSubCategorySelect = $('#BookSubCategory');
                
                // 기존 옵션 제거
                BookSubCategorySelect.html('<option value="">전체</option>');
                
                // 대분류에 따른 소분류 옵션 추가
                if (BookMajorCategory === '000-총류') {
                    addSubCategories(['010-도서관, 서지학', '020-문헌정보학', '030-백과사전', '040-강연, 수필, 연설문집', '050-일반학회, 단체, 박물관', '060-일반전집', '070-신문, 언론, 저널리즘', '080-일반전집, 총서', '090-향토자료']);
                } else if (BookMajorCategory === '100-철학') {
                    addSubCategories(['110-형이상학', '120-인식론, 인과론, 인간학', '130-세계', '140-경학', '150-동양철학, 사상', '160-서양철학', '170-논리학', '180-윤리학', '190-윤리, 도덕교육']);
                } else if (BookMajorCategory === '200-종교') {
                    addSubCategories(['210-비교종교', '220-불교', '230-기독교', '240-도교', '250-천도교', '260-신도', '270-힌두교, 브라만교', '280-회교(이슬람교)', '290-기타 제종교']);
                } else if (BookMajorCategory === '300-사회학') {
                    addSubCategories(['310-통계학', '320-경제학', '330-사회학, 사회문제', '340-정치학', '350-행정학', '360-법학', '370-교육학', '380-풍속, 민속학', '390-국방, 군사학']);
                } else if (BookMajorCategory === '400-자연과학') {
                    addSubCategories(['410-수학', '420-물리학', '430-화학', '440-천문학', '450-지학', '460-생명과학', '470-식물학', '480-동물학', '490-기타 자연과학']);
                } else if (BookMajorCategory === '500-기술과학') {
                    addSubCategories(['510-의학', '520-일반공학, 공학일반', '530-기계공학', '540-전기, 전자공학', '550-건축공학', '560-화학공학', '570-제조업', '580-생활과학', '590-기타 기술과학']);
                } else if (BookMajorCategory === '600-예술') {
                    addSubCategories(['610-건축', '620-조각, 조형예술', '630-회화', '640-서예', '650-사진, 인쇄', '660-음악', '670-공연예술, 매체예술', '680-오락, 스포츠', '690-기타 예술']);
                } else if (BookMajorCategory === '700-언어') {
                    addSubCategories(['710-한국어', '720-중국어', '730-일본어', '740-영어', '750-독일어', '760-프랑스어', '770-스페인어', '780-기타 언어']);
                } else if (BookMajorCategory === '800-문학') {
                    addSubCategories(['810-한국문학', '820-중국문학', '830-일본문학', '840-영어문학', '850-독일문학', '860-프랑스문학', '870-스페인문학', '880-기타 문학']);
                } else if (BookMajorCategory === '900-역사') {
                    addSubCategories(['910-한국사', '920-동양사', '930-서양사', '940-역사이론', '950-지리학', '960-지도, 여행', '970-문화사', '980-민속사', '990-기타 역사']);
                }
            });
            
            // 소분류 옵션 추가 함수
            function addSubCategories(categories) {
                const BookSubCategorySelect = $('#BookSubCategory');
                categories.forEach(category => {
                    const option = $('<option></option>').val(category).text(category);
                    BookSubCategorySelect.append(option);
                });
            }
        });
        
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

		function fn_submit() {
			// 제목 길이 검증
			var titleInput = document.getElementById('title');
			var titleLength = titleInput.value.length;
			var maxTitleLength = 35;

			if (titleLength > maxTitleLength) {
			    alert("제목은 " + maxTitleLength + "자 이내로 입력해주세요. (현재: " + titleLength + "자)");
			    titleInput.focus();
			    return;
			}
            
            // 가격 검증
            var priceInput = document.getElementById('price');
            if (priceInput.value === "" || parseInt(priceInput.value) < 0) {
                alert("유효한 가격을 입력해주세요.");
                priceInput.focus();
                return;
            }
            
            // 카테고리 검증
            var BookMajorCategoryInput = document.getElementById('BookMajorCategory');
            if (BookMajorCategoryInput.value === "") {
                alert("카테고리를 선택해주세요.");
                BookMajorCategoryInput.focus();
                return;
            }
            
            // 거래 장소 검증
            var locationInput = document.getElementById('location');
            if (locationInput.value.trim() === "") {
                alert("거래 희망 장소를 입력해주세요.");
                locationInput.focus();
                return;
            }
            
            // 이미지 검증 (선택사항이지만 권장)
            var imageUpload = document.getElementById('imageUpload');
            if (imageUpload.files.length === 0) {
                if (!confirm("상품 이미지 없이 등록하시겠습니까? 이미지가 있으면 더 빠른 거래가 가능합니다.")) {
                    return;
                }
            }
            
			// 내용 검증
			const content = quill.root.innerHTML;
			const plainText = quill.getText().trim();

			if (plainText.length < 10) {
				document.getElementById('contentError').textContent = '상품 설명은 최소 10자 이상 입력해주세요.';
				return;
			} else {
				document.getElementById('contentError').textContent = '';
			}

			document.getElementById('content').value = content;

			// FormData 객체 생성 (파일 업로드를 위해)
			var formData = new FormData(document.getElementById('frm'));

			$.ajax({
				type: "post",
				url: "trade_post_write_ok",
				data: formData,
				processData: false,  // 필수: FormData 처리 방지
				contentType: false,  // 필수: Content-Type 헤더 설정 방지
				success: function(data) {
					alert("판매글이 등록되었습니다.");
					location.href = "trade_post_view";
				},
				error: function() {
					alert("판매글 등록 중 오류가 발생했습니다.");
				}
			});
		}
		
		// Quill 에디터 초기화
		var quill = new Quill('#editor', {
			theme: 'snow',
			placeholder: '상품 설명을 입력하세요. (구매 시기, 사용 기간, 하자 여부 등)',
			modules: {
				toolbar: [
					[{ 'header': [1, 2, 3, 4, 5, 6, false] }],
					['bold', 'italic', 'underline', 'strike'],
					[{ 'color': [] }, { 'background': [] }],
					[{ 'list': 'ordered' }, { 'list': 'bullet' }],
					[{ 'align': [] }],
					['link', 'image'],
					['clean']
				]
			}
		});
	</script>

</body>
</html>