<%@page import="com.boot.user.dto.UserDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 대출 도서 - 잉크 트리</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
<link rel="stylesheet" type="text/css"
	href="/resources/css/user_book_borrowing.css">
<link rel="stylesheet" type="text/css"
	href="/resources/css/board_view.css">
<script type="text/javascript">
	function return_submit(button) {
		const form = button.closest("form");
		if (!form.checkValidity()) {
			form.reportValidity();
			return;
		}

		const formData = $(form).serialize();

		$.ajax({
			type : "post",
			data : formData,
			url : "book_return",
			success : function(data) {
				alert("정상적으로 반납되었습니다.");
				location.href = "user_book_borrowing";
			},
			error : function() {
				alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
			}
		});
	}
	
	function showHistoryTab(tabId, event) {
		// 이벤트 버블링 방지
		if (event) {
			event.preventDefault();
		}
		
		// 모든 탭 버튼에서 active 클래스 제거
		const tabButtons = document.querySelectorAll('.tab-button');
		tabButtons.forEach(button => {
			button.classList.remove('active');
		});
		
		// 클릭된 버튼에 active 클래스 추가
		if (event && event.currentTarget) {
			event.currentTarget.classList.add('active');
		} else {
			// 탭 ID에 따라 해당 버튼 찾아서 활성화
			var tabButton = document.querySelector(`.tab-button[data-tab="${tabId}"]`);
			if (tabButton) {
				tabButton.classList.add('active');
			} else {
				// 선택자가 작동하지 않을 경우 대체 방법
				if (tabId === 'borrowed') {
					document.querySelector('.tab-button:first-child').classList.add('active');
				} else if (tabId === 'returnRecord') {
					document.querySelector('.tab-button:last-child').classList.add('active');
				}
			}
		}
		
		// 모든 탭 컨텐츠 숨기기
		const tabContents = document.querySelectorAll('.tab-content');
		tabContents.forEach(content => {
			content.classList.remove('active');
		});
		
		// 선택된 탭 컨텐츠 표시
		document.getElementById(tabId).classList.add('active');
	}
	
	// 애니메이션 및 알림 메시지 처리만 수행하는 함수
	function initializePageEffects() {
		// 애니메이션 효과 추가
		const bookItems = document.querySelectorAll('.book-item');
		bookItems.forEach((item, index) => {
			setTimeout(() => {
				item.classList.add('show');
			}, 100 * index);
		});
		
		// 알림 메시지 처리
		const errorMsg = "${errorMsg}";
		const successMsg = "${return_successMSG}";
		const returnErrorMsg = "${return_errorMsg}";
		
		if (errorMsg && errorMsg !== "") {
			alert(errorMsg);
		}
		
		if (successMsg && successMsg !== "") {
			alert(successMsg);
		}
		
		if (returnErrorMsg && returnErrorMsg !== "") {
			alert(returnErrorMsg);
		}
	}
	
	// 페이지 로드 시 실행 - 탭 초기화는 제거하고 애니메이션만 실행
	window.addEventListener('DOMContentLoaded', function() {
		initializePageEffects();
	});
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
	<div class="container">
		<div class="borrowed-header">
			<div class="header-content">
				<h1 class="borrowed-title">
					<span class="title-icon"><i class="fas fa-book-reader"></i></span>
					<span class="title-text">내 대출 도서</span>
				</h1>
				<p class="borrowed-subtitle">현재 대출 중인 도서 목록과 반납 예정일을 확인하세요.<br>
					도서대출 기간은 최대 30일입니다.</p>
			</div>

			<div class="borrowed-stats">
				<div class="stat-card">
					<div class="stat-icon">
						<i class="fas fa-book"></i>
					</div>
					<div class="stat-info">
						<div class="stat-value"><%=borrowingCount%></div>
						<div class="stat-title">대출 중인 도서</div>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon warning">
						<i class="fas fa-exclamation-circle"></i>
					</div>
					<div class="stat-info">
						<div class="stat-value">${userOver + 2}</div>
						<div class="stat-title">연체 도서</div>
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-icon success">
						<i class="fas fa-check-circle"></i>
					</div>
					<div class="stat-info">
						<div class="stat-value">${userRecord}</div>
						<div class="stat-title">총 대출 이력</div>
					</div>
				</div>
			</div>
		</div>

		<!-- 탭 컨테이너 -->
		<div class="tab-container">
			<div class="tab-buttons">
				<button type="button" class="tab-button active" data-tab="borrowed" onclick="showHistoryTab('borrowed', event)">
					<i class="fas fa-book-open"></i> 대출 중인 도서
				</button>
				<button type="button" class="tab-button" data-tab="returnRecord" onclick="showHistoryTab('returnRecord', event)">
					<i class="fas fa-history"></i> 대출 기록
				</button>
			</div>

			<!-- 대출 중인 도서 탭 -->
			<div id="borrowed" class="tab-content active">
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
									<span>대출일: ${book.bookBorrowDate}</span> 
									<span>반납예정일: ${book.bookReturnDate}</span>
								</div>
							</div>
							<div class="book-status">
								<div class="status-borrowed">대출 중</div>
								<form class="returnForm" style="margin-top: auto; width: 100%;">
									<input type="hidden" name="bookNumber" value="${book.bookNumber}">
									<button type="button" class="return-button" onclick="return_submit(this)">
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
					<div class="empty-message">현재 대출 중인 도서가 없습니다</div>
					<a href="book_search_view" class="btn-outline"> 
						<i class="fas fa-search"></i> 도서 검색하기
					</a>
				</div>
				<%
				}
				%>
				
			</div>

			<!-- 대출 기록 탭 -->
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
									<span>대출일: ${bookBorrowRecord.bookBorrowDate}</span> 
									<span>반납일: ${bookBorrowRecord.bookReturnDate}</span>
								</div>
							</div>
							<div class="book-status">
								<div class="status-badge returned">
									<i class="fas fa-check-circle"></i> 반납 완료
								</div>
								<a href="/book_detail?bookNumber=${bookBorrowRecord.bookNumber}" class="return-button" style="background-color: var(--secondary-color);">
									<i class="fas fa-info-circle"></i> 상세정보
								</a>
							</div>
						</div>
					</c:forEach>
				</div>
				<%
				} else {
				%>
				<div class="empty-state">
					<div class="empty-icon">
						<i class="fas fa-history"></i>
					</div>
					<div class="empty-message">대출 기록이 없습니다</div>
					<a href="book_search_view" class="btn-outline"> 
						<i class="fas fa-search"></i> 도서 검색하기
					</a>
				</div>
				<%
				}
				%>
				<!-- <h3>${pageMaker}</h3> -->

				<div class="div_page">
					<ul>
						<c:if test="${pageMaker.prev}">
							<li class="paginate_button">
								<a href="${pageMaker.startPage - 1}">
									<i class="fas fa-caret-left"></i>
								</a>
							</li>
						</c:if>

						<c:forEach var="num" begin="${pageMaker.startPage}"
							end="${pageMaker.endPage}">
							<li
								class="paginate_button ${pageMaker.userBookBorrowingCriteriaDTO.pageNum==num ? 'active' : ''}">
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
				<form id="actionForm" action="user_book_borrowing" method="get">
					<input type="hidden" name="pageNum"
						value="${pageMaker.userBookBorrowingCriteriaDTO.pageNum}">
					<input type="hidden" name="amount" value="${pageMaker.userBookBorrowingCriteriaDTO.amount}">
					<c:if test="${not empty pageMaker.userBookBorrowingCriteriaDTO.type}">
						<input type="hidden" name="type" value="${pageMaker.userBookBorrowingCriteriaDTO.type}">
					</c:if>
					<c:if test="${not empty pageMaker.userBookBorrowingCriteriaDTO.keyword}">
						<input type="hidden" name="keyword"
							value="${pageMaker.userBookBorrowingCriteriaDTO.keyword}">
					</c:if>
				</form>
			</div>
		</div>


	</div>
	<script>
// 페이징처리
var actionForm = $("#actionForm");

// 페이지번호 처리
$(".paginate_button a").on("click", function (e) {
    e.preventDefault();
    console.log("click했음");
    
    // 페이지 번호 설정
    actionForm.find("input[name='pageNum']").val($(this).attr("href"));
    
    // 현재 활성화된 탭 정보 저장
    var activeTab = "returnRecord"; // 페이지네이션은 대출 기록 탭에만 있으므로
    
    // 폼에 활성 탭 정보 추가
    if (actionForm.find("input[name='activeTab']").length > 0) {
        actionForm.find("input[name='activeTab']").val(activeTab);
    } else {
        actionForm.append("<input type='hidden' name='activeTab' value='" + activeTab + "'>");
    }
    
    // 폼 제출
    actionForm.attr("action", "user_book_borrowing").submit();
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
    actionForm.attr("action", "board_detail_view").submit();
});

// 페이지 로드 시 탭 초기화 - 여기서만 탭 초기화 수행
$(document).ready(function() {
    // URL에서 activeTab 파라미터 확인
    const urlParams = new URLSearchParams(window.location.search);
    const activeTab = urlParams.get('activeTab');
    
    // activeTab 파라미터가 있는 경우에만 해당 탭 활성화, 없으면 기본 탭(borrowed) 유지
    if (activeTab === 'returnRecord') {
        showHistoryTab('returnRecord', null);
    } else {
        // 기본값은 '대출 중인 도서' 탭
        showHistoryTab('borrowed', null);
    }
    
    // 세션 스토리지 초기화 (필요 없는 경우 제거)
    sessionStorage.removeItem('activeTab');
});
		</script>
</body>
</html>