<%@page import="com.boot.user.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>공지사항 작성 - 도서관리 시스템</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="/resources/css/admin_notice_write.css">
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
<script src="/resources/js/admin_notice_write.js"></script>
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="container">
        <div class="notice-form">
            <div class="page-header">
                <h1 class="page-title">공지사항 작성</h1>
                <p class="page-description">도서관리 시스템의 새로운 공지사항을 작성합니다.</p>
            </div>
            
                <form id = "admin_frm">
                <div class="form-group">
                    <label for="category" class="form-label">카테고리</label>
                    <select id="category" name="noticeCategory" class="form-select" required>
                        <option value="" selected disabled hidden>${notice.noticeCategory}</option>
                        <option value="important">중요 공지</option>
                        <option value="event">이벤트</option>
<!--                         <option value="info">안내</option> -->
                        <option value="update">업데이트</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" id="title" name="noticeTitle" class="form-input" placeholder="공지사항 제목을 입력하세요" value="${notice.noticeTitle}" required>
                </div>
                
                <div class="form-group">
                    <label for="editor" class="form-label">내용</label>
                    <input type="hidden" name="noticeContent" id="noticeContent">
                    <input type="hidden" name="noticeNum" id="noticeNum" value="${notice.noticeNum}">                    
                    <div id="editor" class="editor-container">${notice.noticeContent}</div>
                    <div id="contentError" class="error-message"></div>
                </div>
                
<!--                 <div class="form-group"> -->
<!--                     <label class="form-label">첨부파일</label> -->
<!--                     <div id="file-container"> -->
<!--                         <div class="file-input-container"> -->
<!--                             <input type="file" name="attachments" class="file-input"> -->
<!--                         </div> -->
<!--                     </div> -->
<!--                     <button type="button" class="add-file-btn" onclick="addFileInput()"> -->
<!--                         <i class="fas fa-plus"></i> 파일 추가 -->
<!--                     </button> -->
<!--                 </div> -->
                
<!--                 <div class="form-group"> -->
<!--                     <div class="checkbox-group"> -->
<!--                         <input type="checkbox" id="fixed" name="fixed" class="form-checkbox"> -->
<!--                         <label for="fixed" class="checkbox-label">상단 고정</label> -->
<!--                     </div> -->
<!--                 </div> -->
                
                <div class="form-actions">
                    <button type="button" class="action-btn cancel-btn" onclick="location.href='admin_notice'">
                        <i class="fas fa-times"></i> 취소
                    </button>
                    <button type="button" class="action-btn submit-btn" onclick="admin_update()">
                        <i class="fas fa-check"></i> 등록하기
                    </button>
                </div>
            </form>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
	<script type="text/javascript">
		function admin_update() {
			const content = quill.root.innerHTML;
			const plainText = quill.getText().trim();

			// 유효성 검사
			if (plainText.length < 1) {
				document.getElementById('contentError').textContent = '내용은 최소 10자 이상 입력해주세요.';
				return;
			} else {
				document.getElementById('contentError').textContent = '';
			}

			document.getElementById('noticeContent').value = content;

			var formData = $("#admin_frm").serialize();

			$.ajax({
				type : "post",
				url : "admin_update_ok",
				data : formData,
				success : function(data) {
					alert("저장완료");
					location.href = "admin_notice";
				},
				error : function() {
					alert("오류발생");
				}
			});
		}

        // Quill 에디터 초기화 
        var quill = new Quill('#editor', {
            theme: 'snow',
            placeholder: '내용을 입력하세요...',
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