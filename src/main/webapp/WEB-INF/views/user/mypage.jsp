<%@page import="com.boot.user.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 - 잉크 트리</title>
<link rel="stylesheet" type="text/css"
	href="/resources/css/mypage.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="/resources/js/mypage.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	// 페이지 로드 시 성공 메시지 표시
	window.onload = function() {
		<c:if test="${not empty successMsg}">
			alert("${successMsg}");
		</c:if>
	};

	function return_submit(button) {
		const form = button.closest("form"); // 해당 버튼의 form
		if (!form.checkValidity()) {
			form.reportValidity();
			return;
		}

		const formData = $(form).serialize(); // 개별 form 기준으로 serialize

		$.ajax({
			type : "post",
			data : formData,
			url : "book_return",
			success : function(data) {
				alert("정상적으로 반납되었습니다.");
				location.href = "mypage"; // 새로고침
			},
			error : function() {
				alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
			}
		});
	}
</script>
</head>
<body>
	<jsp:include page="../header.jsp" />

	<%
	Object userBorrowedBooksObj = request.getAttribute("userBorrowedBooks"); // 유저 현재 빌린 수
	Object userBeforReturnCountObj = request.getAttribute("userRecord"); // 빌리자마자 올라가는 borrow 수
	Object userRecordCountObj = request.getAttribute("userRecordCount"); // 반납하면 올라가는 borrow 수
	int borrowingCount = 0; // 유저 현재 빌린 수
	int recordCount = 0; // 빌리자마자 올라가는 수
	int afterReturnCount = 0; // 반납하면 올라가는 수

	if (userBorrowedBooksObj != null) {
		try {
			borrowingCount = Integer.parseInt(String.valueOf(userBorrowedBooksObj));
		} catch (NumberFormatException e) {
			// 변환 실패 시 기본값 유지
		}
	}
	if (userBeforReturnCountObj != null) {
		try {
			recordCount = Integer.parseInt(String.valueOf(userBeforReturnCountObj));
		} catch (NumberFormatException e) {
			// 변환 실패 시 기본값 유지
		}
	}
	if (userRecordCountObj != null) {
		try {
			afterReturnCount = Integer.parseInt(String.valueOf(userRecordCountObj));
		} catch (NumberFormatException e) {
			// 변환 실패 시 기본값 유지
		}
	}
	// 연체 도서 수 (예시 데이터)
	int overdueCount = 0;
	%>

	<div class="mypage-container">
		<!-- <div class="mypage-header">
			<h1 class="mypage-title">마이페이지</h1>
			<p class="mypage-subtitle">회원 정보 및 도서 대출 현황을 확인하실 수 있습니다.</p>
		</div> -->

		<div class="mypage-content">
			<div class="profile-sidebar">
				<div class="profile-header">
					<div class="profile-avatar">${fn:substring(user.userName, 0, 1)}</div>
					<div class="profile-name">${user.userName}
						님
					</div>
					<div class="profile-id">${user.userId}</div>
				</div>

				<div class="profile-menu">
					<div class="menu-item" onclick="showTab('profile', event)">
						<i class="fas fa-user"></i> <span>내 정보</span>
					</div>
					<!-- <div class="menu-item" onclick="showTab('books', event)">
						<i class="fas fa-book"></i> <span>대출 현황 & 기록</span>
					</div> -->
					<div class="menu-item" onclick="showTab('update', event)">
						<i class="fas fa-pen-to-square"></i> <span>정보 수정</span>
					</div>
					<div class="menu-item" onclick="showTab('password', event)">
						<i class="fas fa-lock"></i> <span>비밀번호 변경</span>
					</div>
				</div>
			</div>

			<div class="content-section">
				<div id="profile-tab" class="tab-content">
					<div class="section-header">
						<h2 class="section-title">내 정보</h2>
					</div>

					<div class="stats-container">
						<div class="stat-card">
							<div class="stat-icon">
								<i class="fas fa-book"></i>
							</div>
							<div class="stat-value"><%=borrowingCount%></div>
							<div class="stat-title">대출 중인 도서</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon">
								<i class="fas fa-exclamation-circle"></i>
							</div>
							<div class="stat-value">${userOver + 2}</div>
							<div class="stat-title">연체 도서</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon">
								<i class="fas fa-clock"></i>
							</div>
							<div class="stat-value">${userRecord}</div>
							<div class="stat-title">총 대출 이력</div>
						</div>
					</div>

					<div class="info-grid">
					    <div class="info-item">
					        <div class="info-label">이름</div>
					        <div class="info-value">${user.userName}</div>
					    </div>

					    <div class="info-item">
					        <div class="info-label">아이디</div>
					        <div class="info-value">${user.userId}</div>
					    </div>

					    <div class="info-item">
					        <div class="info-label">이메일</div>
					        <div class="info-value">${user.userEmail}</div>
					    </div>

					    <div class="info-item">
					        <div class="info-label">전화번호</div>
					        <div class="info-value">${user.userTel}</div>
					    </div>

					    <div class="info-item">
					        <div class="info-label">생년월일</div>
					        <div class="info-value">${user.userBirth}</div>
					    </div>

					    <div class="info-item">
					        <div class="info-label">가입일</div>
					        <div class="info-value">${user.userRegdate}</div>
					    </div>
					</div>

					<div class="info-item">
					    <div class="info-label">주소</div>
					    <div class="info-value">
					        ${user.userZipCode} ${user.userAddress}
					        <c:if test="${not empty userDetailAddress}">
					            ${userDetailAddress}
					        </c:if>
					    </div>
					</div>
				</div>

				<div id="books-tab" class="tab-content">
					<div class="section-header">
						<h2 class="section-title">대출 현황</h2>
					</div>

					<div class="tab-container">
						<div class="tab-buttons">
							<button class="tab-button"
								onclick="showHistoryTab('borrowed', event)">대출 중</button>
							<button class="tab-button"
								onclick="showHistoryTab('returnRecord', event)">대출 기록</button>
						</div>

						<div id="borrowed" class="tab-content">
							<%
							if (borrowingCount > 0) {
							%>
							<div class="book-list">
								<c:forEach var="book" items="${bookBorrowedList}">
									<div class="book-item">
										<div class="book-cover">
											<div class="book-cover-placeholder">
												<i class="fas fa-book"></i>
											</div>
										</div>
										<div class="book-info">
											<div class="book-title">${book.bookTitle}</div>
											<div class="book-author">${book.bookWrite}</div>
											<div class="book-dates">
												<span>대출일 : ${book.bookBorrowDate}</span> <span>반납예정일
													: ${book.bookReturnDate}</span>
											</div>
										</div>
										<div class="book-status status-borrowed">대출 중</div>
										<div class="book-status status-return">
											<form class="returnForm"
												style="display: inline-block; margin-top: 10px;">
												<input type="hidden" name="bookNumber"
													value="${book.bookNumber}">
												<button type="button" class="return-button"
													onclick="return_submit(this)">
													<i class="fas fa-undo-alt"></i> 반납하기
												</button>
											</form>
										</div>
									</div>
								</c:forEach>
							</div>
							<%
							} else {
							%>
							<div class="empty-state">
								<div class="empty-icon">
									<i class="fas fa-book"></i>
								</div>
								<div class="empty-message">현재 대출 중인 도서가 없습니다.</div>
								<a href="book_search_view" class="btn btn-outline"> <i
									class="fas fa-search"></i> 도서 검색하기
								</a>
							</div>
							<%
							}
							%>
						</div>
						<!-- 대출기록 -->
						<div id="returnRecord" class="tab-content">
							<%
							if (afterReturnCount > 0) {
							%>
							<div class="book-list">
								<c:forEach var="bookBorrowRecord" items="${bookBorrowList}">
									<div class="book-item">
										<div class="book-cover">
											<div class="book-cover-placeholder">
												<i class="fas fa-book"></i>
											</div>
										</div>
										<div class="book-info">
											<div class="book-title">${bookBorrowRecord.bookTitle}</div>
											<div class="book-author">${bookBorrowRecord.bookWrite}</div>
											<div class="book-dates">
												<span>대출일 : ${bookBorrowRecord.bookBorrowDate}</span> <span>반납일
													: ${bookBorrowRecord.bookReturnDate}</span>
											</div>
										</div>
									</div>
								</c:forEach>
							</div>
							<%
							} else {
							%>
							<div class="empty-state">
								<div class="empty-icon">
									<i class="fas fa-book"></i>
								</div>
								<div class="empty-message">대출 기록이 없습니다.</div>
								<a href="book_search_view" class="btn btn-outline"> <i
									class="fas fa-search"></i> 도서 검색하기
								</a>
							</div>
							<%
							}
							%>
						</div>
					</div>
				</div>
				
				<!-- 정보 수정 탭 추가 -->
				<div id="update-tab" class="tab-content">
					<div class="section-header">
						<h2 class="section-title">정보 수정</h2>
						<div class="section-subtitle">회원 정보를 수정하려면 현재 비밀번호를 입력해주세요.</div>
					</div>
					
					<form id="updateUserForm" method="post" action="userUpdate">
					    <input type="hidden" name="userNumber" value="${user.userName}">
					    <input type="hidden" name="userId" value="${user.userId}">
						
						<!-- 비밀번호 확인 섹션 추가 -->
						<div class="password-verification" style="margin-bottom: 30px; padding: 20px; background-color: var(--primary-lighter); border-radius: var(--border-radius); border: 1px solid var(--primary-light);">
						    <div class="info-label" style="margin-bottom: 15px; color: var(--primary-dark); font-weight: 600;">
						        <i class="fas fa-shield-alt" style="margin-right: 8px;"></i> 보안 확인
						    </div>
						    <div style="background-color: white; padding: 15px; border-radius: var(--border-radius-sm);">
						        <div class="info-label">현재 비밀번호</div>
						        <input type="password" id="updateCurrentPassword" name="userPw" class="form-input" placeholder="현재 비밀번호를 입력해주세요" required>
						        <div class="info-description" style="font-size: 13px; color: var(--gray-500); margin-top: 8px;">
						            * 회원 정보 보호를 위해 현재 비밀번호를 확인합니다.
						        </div>
						    </div>
						</div>
						
						<div class="info-grid">
							<div class="info-item">
								<div class="info-label">이름</div>
								<input type="text" name="userName" class="form-input" value="${user.userName}" required>
							</div>
							
							<div class="info-item">
								<div class="info-label">아이디</div>
								<div class="info-value">${user.userId}</div>
							</div>
							
							<div class="info-item">
								<div class="info-label">이메일</div>
								<input type="email" name="userEmail" class="form-input" value="${user.userEmail}" required>
							</div>
							
							<div class="info-item">
								<div class="info-label">전화번호</div>
								<input type="tel" name="userTel" class="form-input" value="${user.userTel}" 
									pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" placeholder="010-0000-0000" required>
							</div>
							
							<div class="info-item">
								<div class="info-label">생년월일</div>
								<input type="date" name="userBirth" class="form-input" value="${user.userBirth}" required>
							</div>
							
							<div class="info-item">
								<div class="info-label">가입일</div>
								<div class="info-value">${user.userRegdate}</div>
							</div>
						</div>
						
						<div class="address-section" style="margin-top: 20px;">
							<div class="info-item" style="grid-column: span 2;">
								<div class="info-label">우편번호</div>
								<div style="display: flex; gap: 10px;">
									<input type="text" name="userZipCode" id="userZipCode" class="form-input" 
										value="${user.userZipCode}" style="flex: 1;" readonly>
									<button type="button" onclick="execDaumPostcode()" class="btn btn-outline" style="white-space: nowrap;">
										<i class="fas fa-search"></i> 주소 찾기
									</button>
								</div>
							</div>
							
							<div class="info-item" style="grid-column: span 2;">
								<div class="info-label">주소</div>
								<input type="text" name="userAddress" id="userAddress" class="form-input" 
									value="${user.userAddress}" readonly>
							</div>
							
							<div class="info-item" style="grid-column: span 2;">
								<div class="info-label">상세주소</div>
								<input type="text" name="userDetailAddress" id="userDetailAddress" class="form-input" 
									value="${user.userDetailAddress}">
							</div>
						</div>
						
						<div class="action-buttons">
						    <button type="submit" class="btn btn-primary">
						        <i class="fas fa-check"></i> 정보 수정 완료
						    </button>
						</div>
					</form>
				</div>

				<div id="password-tab" class="tab-content">
					<div class="section-header">
						<h2 class="section-title">비밀번호 변경</h2>
					</div>
					<form id="passwordChangeForm" onsubmit="return false;">
					    <input type="hidden" name="userNumber" value="${user.userNumber}">
					    <div class="info-grid" style="grid-template-columns: 1fr;">
					        <div class="info-item">
					            <div class="info-label">현재 비밀번호</div>
					            <input type="password" id="currentPassword" name="userPw" class="form-input" required>
					            <div id="passwordError" style="color: var(--danger); font-size: 13px; margin-top: 5px;"></div>
					        </div>

					        <div class="info-item">
					            <div class="info-label">새 비밀번호</div>
					            <input type="password" id="newPassword" name="userNewPw" class="form-input" required>
					            <div class="info-label" style="margin-top: 5px; font-size: 12px; color: var(--gray-500);">*
					                8자 이상, 영문, 숫자, 특수문자 조합</div>
					        </div>

					        <div class="info-item">
					            <div class="info-label">새 비밀번호 확인</div>
					            <input type="password" id="confirmPassword" name="userNewPwCheck" class="form-input" required>
					            <div id="passwordError" style="color: var(--danger); font-size: 13px; margin-top: 5px;"></div>
					        </div>
					    </div>

					    <div class="action-buttons">
					        <button type="button" onclick="changePassword()" class="btn btn-primary">
					            <i class="fas fa-check"></i> 비밀번호 변경
					        </button>
					    </div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<c:if test="${not empty errorMsg}">
		<script>
			alert("${errorMsg}");
		</script>
	</c:if>
	<c:if test="${not empty return_successMSG}">
		<script>
			alert("${return_successMSG}");
		</script>
	</c:if>
	<c:if test="${not empty return_errorMsg}">
		<script>
			alert("${return_errorMsg}");
		</script>
	</c:if>
	
	<script>
		// 주소 검색 기능
		function execDaumPostcode() {
			new daum.Postcode({
				oncomplete: function(data) {
					document.getElementById('userZipCode').value = data.zonecode;
					document.getElementById('userAddress').value = data.address;
					document.getElementById('userDetailAddress').focus();
				}
			}).open();
		}
		
		// 비밀번호 변경 함수
		function changePassword() {
			const form = document.getElementById('passwordChangeForm');
			if (!form.checkValidity()) {
				form.reportValidity();
				return;
			}
			
			// 비밀번호 유효성 검사
			const newPassword = document.getElementById('newPassword').value;
			const confirmPassword = document.getElementById('confirmPassword').value;
			
			// 비밀번호 일치 여부 확인
			if (newPassword !== confirmPassword) {
				alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
				return;
			}
			
			// 비밀번호 복잡성 검사 (8자 이상, 영문, 숫자, 특수문자 조합)
			const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
			if (!passwordRegex.test(newPassword)) {
				alert("비밀번호는 8자 이상이며, 영문, 숫자, 특수문자를 모두 포함해야 합니다.");
				return;
			}
			
			// AJAX로 비밀번호 변경 요청
			const formData = $(form).serialize();
			$.ajax({
				type: "post",
				data: formData,
				url: "userPwUpdate",
				success: function(data) {
					alert("비밀번호가 성공적으로 변경되었습니다.");
					// 폼 초기화
					form.reset();
					// 내 정보 탭으로 이동
					showTab('profile', event);
				},
				error: function() {
					alert("비밀번호 변경 중 오류가 발생했습니다. 현재 비밀번호를 확인하거나 잠시 후 다시 시도해주세요.");
				}
			});
		}
	</script>
</body>
</html>