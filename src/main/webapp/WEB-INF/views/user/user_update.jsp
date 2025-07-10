<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>

<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
<script src="/resources/js/user_update.js"></script>
<link rel="stylesheet" type="text/css"
	href="/resources/css/user_update.css">
</head>

<body>
			<jsp:include page="../header.jsp" />
	<form id="updateForm" method="post" action="userUpdate">
		<h2>회원 정보 수정</h2>
		<input type="hidden" name="userNumber" value="${loginUser.userNumber}" />

		<div>
			<label for="userId">아이디</label> <input type="text" id="userId"
				name="userId" value="${loginUser.userId}" readonly />
		</div>

		<div>
			<label for="userName">이름</label> <input type="text" id="userName"
				name="userName" value="${loginUser.userName}" required readonly />
		</div>

		<div class="form-group">
			<label>이메일 <span class="required-mark">*</span></label> <input
				type="email" name="userEmail" required
				value="${loginUser.userEmail}" placeholder="example@email.com"
				pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
				oninvalid="this.setCustomValidity('올바른 이메일 주소 형식으로 입력해주세요.')"
				oninput="setCustomValidity('')"> <span class="input-hint">이메일
				주소를 입력해주세요.</span> <span class="error-message">올바른 이메일 주소 형식으로
				입력해주세요.</span>
		</div>

		<div class="form-group">
			<label>전화번호 <span class="required-mark">*</span></label> <input
				type="tel" name="userTel" required value="${loginUser.userTel}"
				placeholder="010-0000-0000" pattern="^010-\d{4}-\d{4}$"
				oninvalid="this.setCustomValidity('올바른 전화번호 형식(010-0000-0000)으로 입력해주세요.')"
				oninput="setCustomValidity('')"> <span class="input-hint">010-0000-0000
				형식으로 입력해주세요.</span> <span class="error-message">올바른 전화번호
				형식(010-0000-0000)으로 입력해주세요.</span>
		</div>

		<div class="form-group full-width">
			<label>주소 <span class="required-mark">*</span></label> <input
				type="text" name="userZipCode" id="zipCode" required
				placeholder="우편번호 입력"
				oninvalid="this.setCustomValidity('우편번호를 선택해주세요.')"
				oninput="setCustomValidity('')" readonly
				value="${loginUser.userZipCode}"> <span class="input-hint">우편번호를
				입력해주세요.</span> <span class="error-message">우편번호를 입력해주세요.</span>
			<div class="address-search">
				<input type="text" name="userAddress" id="userAddress" required
					placeholder="도로명 또는 지번 주소 입력"
					oninvalid="this.setCustomValidity('주소를 입력해주세요.')"
					oninput="setCustomValidity('')" readonly
					value="${loginUser.userAddress}">
				<button type="button" onclick="searchAddress()">주소 검색</button>
			</div>
			<span class="input-hint">도로명 또는 지번 주소를 입력해주세요.</span> <span
				class="error-message">주소를 입력해주세요.</span>
		</div>

		<div class="form-group full-width">
			<label>상세 주소</label> <input type="text" name="userDetailAddress"
				placeholder="상세 주소 입력 (선택사항)" value="${loginUser.userDetailAddress}">
			<span class="input-hint">아파트, 동/호수 등 상세 주소를 입력해주세요.</span>
		</div>

		<div>
			<label for="userPassword">현재 비밀번호:</label> <input type="password"
				id="userPw" name="userPw" placeholder="기존 비밀번호를 입력" />
		</div>

		<div>
			<button type="submit">수정 완료</button>
			<button type="reset">초기화</button>
		</div>
	</form>
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
            function searchAddress() {
               new daum.Postcode(
                  {
                     oncomplete: function (data) {
                        // 우편번호와 도로명 주소 설정
                        document.getElementById("zipCode").value = data.zonecode;
                        document.getElementById("userAddress").value = data.roadAddress;
                     }
                  }).open();
            }
    		document.getElementById("updateForm").addEventListener(
    				"submit",
    				function(event) {
    					var userPw = document.getElementById("userPw").value;
    					if(${loginUser.userPw} != userPw)
    					{
    						alert("현재 비밀번호가 일치하지 않습니다.");
    						event.preventDefault();
    						return false;
    					}
    					alert("회원정보 수정 완료!")
    					return true;
    				});
         </script>
</body>

</html>