<%@page import="com.boot.user.dto.UserDTO" %>
	<%@page import="com.boot.board.dto.BoardDTO" %>
		<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
			<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
				<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
				<!DOCTYPE html >
				
				  <html>

									<head>
										<meta charset="UTF-8">
										<meta name="viewport" content="width=device-width, initial-scale=1.0">
										<title>메트로하우스</title>
										<link rel="stylesheet" type="text/css" href="/resources/css/board_detail.css">
										<link rel="stylesheet"
											href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
										<link
											href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
											rel="stylesheet">
										<script src="/resources/js/board_detail.js"></script>
									</head>

									<body>
    <jsp:include page="../header.jsp" />

										<div class="container">
											<div class="board-container">
												<div class="board-detail">
													<div class="board-header">
														<div class="board-category">
															<a href="/board_view" class="category-link">
																<i class="fas fa-comments"></i> 커뮤니티 게시판
															</a>
														</div>
														<h1 class="board-title">${board.boardTitle}</h1>
														<input type="hidden" id="boardTitle" value="${board.boardTitle}">
														<div class="board-meta">
															<div class="author-info">
																<div class="author-avatar">${fn:substring(board.userName, 0, 1)}</div>
																<div class="author-details">
																	<div class="author-name">${board.userName}</div>
																	<input type="hidden" id="writeUserNumber" value="${board.userNumber}">
																	<div class="post-date">
																		<c:set var="dateStr" value="${board.boardWriteDate}" />
																		<c:if test="${not empty dateStr}">
																			<c:set var="formattedDate" value="${fn:replace(dateStr, '[', '')}" />
																			<c:set var="formattedDate" value="${fn:replace(formattedDate, ']', '')}" />
																			<c:choose>
																				<c:when test="${fn:length(formattedDate) > 16}">
																					${fn:substring(formattedDate, 0, 16)}
																				</c:when>
																				<c:otherwise>
																					${formattedDate}
																				</c:otherwise>
																			</c:choose>
																		</c:if>
																	</div>
																</div>
															</div>
															<div class="post-info">
																<div class="info-item">
																	<i class="fas fa-eye"></i> <span>${board.boardViews}</span>
																</div>
																<div class="info-item">
																	<i class="fas fa-heart"></i> <span
																		id="like-count">${board.boardLikes}</span>
																</div>
															</div>
														</div>
													</div>

													<div class="board-content">${board.boardContent}</div>

													<div class="board-actions">
														<button class="like-button" onclick="likePost(${board.boardNumber})">
															<i class="fas fa-heart"></i> <span>추천</span> <span
																class="like-count">${board.boardLikes}</span>
														</button>

														<div class="action-buttons">
															<% UserDTO user=(UserDTO) session.getAttribute("loginUser"); BoardDTO
																board=(BoardDTO) request.getAttribute("board"); if (user !=null &&
																(user.getUserNumber()==board.getUserNumber() || user.getUserAdmin()==1))
																{ %>
																<button class="action-button edit-button"
																	onclick="location.href='/board_update?boardNumber=${board.boardNumber}'">
																	<i class="fas fa-edit"></i> 수정
																</button>
																<button class="action-button delete-button"
																	onclick="deletePost(${board.boardNumber})">
																	<i class="fas fa-trash"></i> 삭제
																</button>
																<% } %>
<!--																	<button class="action-button list-button" onclick="history.back()">-->
																	<button class="action-button list-button" onclick="goToList()">
																		<i class="fas fa-list"></i> 목록
																	</button>
														</div>
													</div>
												</div>

												<div class="comments-section">
													<h2 class="comments-header">
														<i class="fas fa-comment-dots"></i> 댓글
														<span class="comment-count">${allCount}</span>
													</h2>

													<c:choose>
													    <c:when test="${user != null}">
													        <div class="comment-form">
													            <form id="commentForm" onsubmit="return submitComment(this);">
													                <input type="hidden" name="boardNumber" value="${board.boardNumber}" id="boardNumber">
													                <input type="hidden" name="userNumber" value="${user.userNumber}">
													                <input type="hidden" name="userName" value="${user.userName}" id="commentWriteUserName">
													                <input type="hidden" id="commentWriteUserNumber" value="${user.userNumber}">
													                <input type="hidden" name="commentSubNumber" value="0">
													                <input type="hidden" name="commentSubStepNumber" value="0">
													                <textarea name="commentContent" class="comment-textarea" placeholder="댓글을 작성해주세요"></textarea>
													                <button type="submit" class="comment-submit">
													                    <i class="fas fa-paper-plane"></i> 댓글 작성
													                </button>
													                <div style="clear: both;"></div>
													            </form>
													        </div>
													    </c:when>
													    <c:otherwise>
													        <div class="comment-form login-required">
													            <p>
													                댓글을 작성하려면 <a href="/loginForm">로그인</a>이 필요합니다.
													            </p>
													        </div>
													    </c:otherwise>
													</c:choose>

																<div class="comment-list">
																	<c:if test="${empty commentList}">
																		<div class="no-comments">
																			<i class="fas fa-comment-slash"></i>
																			<p>아직 댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
																		</div>
																	</c:if>

																	<!-- 메인 댓글 표시 -->
																	<c:forEach items="${commentList}" var="comment">
																		<c:if test="${comment.commentSubNumber == 0}">
																			<div class="comment-item"
																				id="comment-${comment.commentNumber}">
																				<div class="comment-header">
																					<div class="comment-author-avatar">
																						${fn:substring(comment.userName, 0, 1)}
																					</div>
																					<div class="comment-content-wrapper">
																						<div class="comment-meta">
																							<div class="comment-author">${comment.userName}
																								<input type="hidden" id="commentUserNumber-${comment.commentNumber}" value="${comment.userNumber}">
																								<span class="comment-date">
																									<c:set var="dateStr" value="${comment.commentWriteDate}" />
																									<c:if test="${not empty dateStr}">
																										<c:set var="formattedDate" value="${fn:replace(dateStr, '[', '')}" />
																										<c:set var="formattedDate" value="${fn:replace(formattedDate, ']', '')}" />
																										<c:choose>
																											<c:when test="${fn:length(formattedDate) > 16}">
																												${fn:substring(formattedDate, 0, 16)}
																											</c:when>
																											<c:otherwise>
																												${formattedDate}
																											</c:otherwise>
																										</c:choose>
																										
																									</c:if>
																								</span>
																								<c:if test="${(loginUser.userNumber == comment.userNumber) || (loginUser.userAdmin == 1)}">
																								    <div class="comment-actions">
																								        <button type="button" class="comment-action-button edit-button" 
																								                onclick="showEditCommentForm(${comment.commentNumber}, '${fn:replace(comment.commentContent, "'", "\\'")}')">
																								            <i class="fas fa-edit"></i> 수정
																								        </button>
																								        <button type="button" class="comment-action-button delete-button" 
																								                onclick="confirmDeleteComment(${comment.commentNumber}, false)">
																								            <i class="fas fa-trash"></i> 삭제
																								        </button>
																								    </div>
																								</c:if>
																							</div>
																						</div>
																						<div class="comment-content">
																							${comment.commentContent}
																						</div>

																					</div>
																				</div>

																				<!-- 답글 버튼 -->
																				<% if (user !=null) { %>
																					<button class="reply-button"
																						onclick="showReplyForm(${comment.commentNumber}, '${comment.userName}', 0)">
																						<i class="fas fa-reply"></i> 답글
																					</button>

																					<!-- 대댓글 작성 폼 -->
																					<div class="reply-form"
																						id="reply-form-${comment.commentNumber}">
																						<form onsubmit="return submitReply(this, ${comment.commentNumber});">
																							<input type="hidden" name="boardNumber"
																								value="${board.boardNumber}"> <input
																								type="hidden" name="userNumber"
																								value="<%=user.getUserNumber()%>">
																							<input type="hidden" name="userName"
																								value="<%=user.getUserName()%>"> <input
																								type="hidden" name="commentSubNumber"
																								value="${comment.commentNumber}">
																							<input type="hidden"
																								name="commentSubStepNumber" value="1">
																							<input type="hidden"
																								id="replyToUser-${comment.commentNumber}"
																								name="replyToUser" value="">
																							<div id="replyToMessage-${comment.commentNumber}"
																								class="reply-to"></div>
																							<textarea name="commentContent"
																								class="reply-textarea"
																								placeholder="답글을 작성해주세요"></textarea>
																							<div class="reply-actions">
																								<button type="button"
																									class="reply-cancel"
																									onclick="hideReplyForm(${comment.commentNumber})">취소</button>
																								<button type="submit"
																									class="reply-submit">
																									<i class="fas fa-paper-plane"></i>
																									답글 작성
																								</button>
																							</div>
																							<div style="clear: both;"></div>
																						</form>
																					</div>
																					<% } %>

																						
																						<c:forEach items="${commentList}" var="reply">
																							<c:if test="${reply.commentSubNumber == comment.commentNumber}">
																								<div class="reply-item" id="comment-${reply.commentNumber}">
																									<div class="reply-indicator">
																										<i class="fas fa-reply fa-flip-horizontal"></i>
																									</div>
																									
																									<input type="hidden" id="replyCommentUserNumber" value="${reply.userNumber}">
																								
																									<div class="comment-header">
																										<div class="comment-author-avatar reply-avatar">
																											${fn:substring(reply.userName, 0, 1)}
																										</div>
																										<div class="comment-content-wrapper">
																											<div class="comment-meta">
																												<div class="comment-author">${reply.userName}
																													<input type="hidden" id="replyUserNumber-${reply.commentNumber}" value="${reply.userNumber}">
																													<input type="hidden" id="replyUserName-${reply.commentNumber}" value="${reply.userName}">
																													
																													<span class="comment-date">
																														<c:set var="dateStr" value="${reply.commentWriteDate}" />
																														<c:if test="${not empty dateStr}">
																															<c:set var="formattedDate" value="${fn:replace(dateStr, '[', '')}" />
																															<c:set var="formattedDate" value="${fn:replace(formattedDate, ']', '')}" />
																															<c:choose>
																																<c:when test="${fn:length(formattedDate) > 16}">
																																	${fn:substring(formattedDate, 0, 16)}
																																</c:when>
																																<c:otherwise>
																																	${formattedDate}
																																</c:otherwise>
																															</c:choose>
																														</c:if>
																													</span>
																													<c:if test="${(loginUser.userNumber == reply.userNumber) || (loginUser.userAdmin == 1)}">
																													    <div class="comment-actions">
																													        <button type="button" class="comment-action-button edit-button" 
																													                onclick="showEditCommentForm(${reply.commentNumber}, '${fn:replace(reply.commentContent, "'", "\\'")}')">
																													            <i class="fas fa-edit"></i> 수정
																													        </button>
																													        <button type="button" class="comment-action-button delete-button" 
																													                onclick="confirmDeleteComment(${reply.commentNumber}, true)">
																													            <i class="fas fa-trash"></i> 삭제
																													        </button>
																													    </div>
																													</c:if>
																												</div>
																											</div>
																											<div class="comment-content">
																												${reply.commentContent}
																											</div>
																										</div>
																									</div>
																								</div>
																							</c:if>
																						</c:forEach>
																			</div>
																		</c:if>
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
																            <li class="paginate_button ${pageMaker.criteriaDTO.commentPageNum==num ? 'active' : ''}">
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
																<form id="actionForm" action="board_detail_view" method="get">
																    <input type="hidden" name="boardNumber" value="${board.boardNumber}">
																    <input type="hidden" name="pageNum" value="${param.pageNum}">
																    <input type="hidden" name="commentPageNum" value="${pageMaker.criteriaDTO.commentPageNum}">
																    <input type="hidden" name="amount" value="${param.amount}">
																    <input type="hidden" name="skipViewCount" value="true">
																    <c:if test="${not empty param.type}">
																        <input type="hidden" name="type" value="${param.type}">
																    </c:if>
																    <c:if test="${not empty param.keyword}">
																        <input type="hidden" name="keyword" value="${param.keyword}">
																    </c:if>
																</form>
												</div>
											</div>
										</div>

										<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
										<script>
											function likePost(boardNumber) {
											    $.ajax({
											        type: "post",
											        url: "/boardLikes",
											        data: { boardNumber: boardNumber },
											        success: (data) => {
											            // 좋아요 수 업데이트
											            const likeCountElements = $(".like-count, #like-count");
											            const currentCount = Number.parseInt(likeCountElements.first().text());
											            
											            if (data === "추천 완료") {
											                // 좋아요 추가
											                likeCountElements.text(currentCount + 1);
											                // 좋아요 버튼 활성화 효과
											                $(".like-button").addClass("active");
											            } else if (data === "추천 취소 완료") {
											                // 좋아요 취소
											                likeCountElements.text(currentCount - 1);
											                // 좋아요 버튼 비활성화 효과
											                $(".like-button").removeClass("active");
											            }
											            
											            console.log(data);
											        },
											        error: (xhr) => {
											            if (xhr.status === 401) {
											                alert("로그인 후 추천을 누르실 수 있습니다.");
											            } else {
											                alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
											            }
											        }
											    });
											}

											function deletePost(boardNumber) {
												if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
													$.ajax({
														type: "post",
														url: "delete_post",
														data: { boardNumber: boardNumber },
														success: (data) => {
															alert("정상적으로 삭제되었습니다.");
															location.href = "board_view";
														},
														error: () => {
															alert("오류 발생");
														}
													});
												}
											}

											// 댓글 작성 AJAX 처리
											function submitComment(form) {
											    // 폼 데이터 가져오기
											    const formData = new FormData(form);
											    const commentData = {};
											    
											    // FormData를 객체로 변환
											    for (let [key, value] of formData.entries()) {
											        commentData[key] = value;
											    }
											    
											    // 빈 댓글 체크
											    if (!commentData.commentContent.trim()) {
											        alert("댓글 내용을 입력해주세요.");
											        return false;
											    }
											    
											    // AJAX 요청
											    $.ajax({
											        type: "post",
											        url: "/comment_write_ok",
											        data: commentData,
											        success: function(response) {
											            // 댓글 입력창 초기화
											            form.querySelector('textarea').value = '';
											            
											            // 조회수 증가 방지를 위해 skipViewCount=true 파라미터 추가하여 새로고침
											            const currentUrl = window.location.href;
											            const url = new URL(currentUrl);
											            url.searchParams.set('skipViewCount', 'true');
											            window.location.href = url.toString();
														commentNotification();
											        },
											        error: function() {
											            alert("댓글 등록 중 오류가 발생했습니다.");
											        }
											    });
											    
											    // 폼 기본 제출 동작 방지
											    return false;
											}
											
											function commentNotification() {
												// 게시글 쓴사람 번호
												const writeUserNumber = document.getElementById('writeUserNumber').value;
												// 댓글 쓴사람 이름
												const commentWriteUserName = document.getElementById('commentWriteUserName').value;
												// 댓글 쓴사람 번호
												const commentWriteUserNumber = document.getElementById('commentWriteUserNumber').value;
												const boardNumber = document.getElementById('boardNumber').value;
												const boardTitle = document.getElementById('boardTitle').value;
												
												if(writeUserNumber != commentWriteUserNumber) {
											    fetch('/notifications', {
											        method: 'POST',
											        headers: {
											            'Content-Type': 'application/json'
											        },
											        body: JSON.stringify({
											            userNumber: writeUserNumber,
											            message: commentWriteUserName + '님이 나의 게시글['+boardTitle+']에 댓글을 남겼습니다.',
											            title: '댓글 알림',
											            type: 'COMMENT',
											            url: '/board_detail_view?boardNumber='+boardNumber,
											            sent: false,
											            read: false,
											            toAll: false // 전체
											        })
											    })
											        .then(function(response) {
											            return response.json();
											        })
											        .then(function(data) {
											            console.log('알림 전송 성공:', data);
											            // 알림 성공 시 별도의 팝업 띄우지 않음 (자동으로 알림이 표시됨)
											        })
											        .catch(function(error) {
											            console.error('알림 전송 실패:', error);

											        });
													}else {
														console.log("같은 사용자")
													}
											}
											// 대댓글 작성 AJAX 처리
											function submitReply(form, commentNumber) {
											    // 폼 데이터 가져오기
											    const formData = new FormData(form);
											    const replyData = {};
											    
											    // FormData를 객체로 변환
											    for (let [key, value] of formData.entries()) {
											        replyData[key] = value;
											    }
											    
											    // 빈 댓글 체크
											    if (!replyData.commentContent.trim()) {
											        alert("답글 내용을 입력해주세요.");
											        return false;
											    }
											    
												
												// 댓글 작성자 번호 가져오기 (댓글 요소에서 직접 가져옴)
												const commentElement = document.getElementById('comment-' + commentNumber);
												// 수정된 부분: ID 선택자를 올바르게 변경
												const commentUserNumberElement = commentElement.querySelector('#commentUserNumber-' + commentNumber);
												const commentUserNumber = commentUserNumberElement ? commentUserNumberElement.value : null;

												// 현재 로그인한 사용자 번호 (답글 작성자)
												const replyUserNumber = replyData.userNumber;

												// 현재 로그인한 사용자 이름 (답글 작성자)
												const replyCommentWriteUserName = replyData.userName;

												// 게시글 번호
												const boardNumber = replyData.boardNumber;
												
												console.log("댓글 작성자 번호: " + commentUserNumber);
												console.log("답글 작성자 번호: " + replyUserNumber);
											    // AJAX 요청
											    $.ajax({
											        type: "post",
											        url: "/comment_write_ok",
											        data: replyData,
											        success: function(response) {
											            // 답글 폼 숨기기
											            hideReplyForm(commentNumber);
											            
														// 알림 전송 (직접 값을 전달)
														if (commentUserNumber && replyUserNumber) {
														    replyCommentNotification(commentUserNumber, replyUserNumber, replyCommentWriteUserName, boardNumber);
														}

														// 페이지 새로고침
														const currentUrl = window.location.href;
														const url = new URL(currentUrl);
														url.searchParams.set('skipViewCount', 'true');
														window.location.href = url.toString();
											        },
											        error: function() {
											            alert("답글 등록 중 오류가 발생했습니다.");
											        }
											    });
											    
											    // 폼 기본 제출 동작 방지
											    return false;
											}
											function replyCommentNotification(commentUserNumber, replyUserNumber, replyCommentWriteUserName, boardNumber) {
											    console.log("댓글 작성자 번호: " + commentUserNumber);
											    console.log("답글 작성자 번호: " + replyUserNumber);
											    
											    if (commentUserNumber !== replyUserNumber) {
											        fetch('/notifications', {
											            method: 'POST',
											            headers: {
											                'Content-Type': 'application/json'
											            },
											            body: JSON.stringify({
											                userNumber: commentUserNumber,
											                message: replyCommentWriteUserName + '님이 나의 댓글에 답글을 남겼습니다.',
											                title: '대댓글 알림',
											                type: 'COMMENT',
											                url: '/board_detail_view?boardNumber='+boardNumber,
											                sent: false,
											                read: false,
											                toAll: false
											            })
											        })
											        .then(function(response) {
											            return response.json();
											        })
											        .then(function(data) {
											            console.log('알림 전송 성공:', data);
											        })
											        .catch(function(error) {
											            console.error('알림 전송 실패:', error);
											        });
											    } else {
											        console.log("같은 사용자이므로 알림을 보내지 않습니다.");
											    }
											}
												
											// 대댓글 폼 표시 (replyToUsername: 답글 대상 사용자, currentStep: 현재 대댓글 단계)
											function showReplyForm(commentNumber, replyToUsername, currentStep) {
												// 모든 대댓글 폼 숨기기
												document.querySelectorAll('.reply-form').forEach(form => {
													form.style.display = 'none';
												});

												// 선택한 댓글의 대댓글 폼 표시
												const replyForm = document.getElementById('reply-form-' + commentNumber);
												replyForm.style.display = 'block';

											}

											// 대댓글 폼 숨기기
											function hideReplyForm(commentNumber) {
												document.getElementById('reply-form-' + commentNumber).style.display = 'none';
											}


											// 페이징처리
											var actionForm = $("#actionForm");

											// 페이지번호 처리
											$(".paginate_button a").on("click", function (e) {
											    e.preventDefault();
											    console.log("click했음");
											    console.log("@# href => " + $(this).attr("href"));

											    // 댓글 페이지 번호 설정 (pageNum 대신 commentPageNum 사용)
											    actionForm.find("input[name='commentPageNum']").val($(this).attr("href"));
											    actionForm.find("input[name='skipViewCount']").val("true");

											    // 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 페이지 클릭 할 때 content_view2가 작동되는 것을 해결)
											    actionForm.attr("action", "board_detail_view").submit();
											}); // end of paginate_button click

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
											
											// 페이지 로드 시 추천 상태 확인
											$(document).ready(function() {
											    // 로그인한 사용자만 확인
											    <% if (user != null) { %>
											        const boardNumber = ${board.boardNumber};
											        
											        $.ajax({
											            type: "get",
											            url: "/checkLikeStatus",
											            data: { boardNumber: boardNumber },
											            success: function(hasLiked) {
											                if (hasLiked === true || hasLiked === "true") {
											                    // 이미 추천한 경우 버튼 활성화 스타일 적용
											                    $(".like-button").addClass("active");
											                }
											            }
											        });
											    <% } %>
											});
											
											// 목록 버튼 클릭 시 게시판 목록으로 이동
											function goToList() {
											    // 현재 URL에서 쿼리 파라미터 가져오기
											    const urlParams = new URLSearchParams(window.location.search);
											    const pageNum = urlParams.get('pageNum') || 1;
											    const amount = urlParams.get('amount') || 10;
											    const type = urlParams.get('type') || '';
											    const keyword = urlParams.get('keyword') || '';
											    
											    let url = "board_view?pageNum=" + pageNum + "&amount=" + amount;
											    
											    if(type && keyword) {
											        url += "&type=" + encodeURIComponent(type) + "&keyword=" + encodeURIComponent(keyword);
											    }
											    
											    // 게시판 목록 페이지로 직접 이동
											    window.location.href = url;
											}
											
											
											
											// 전역 변수로 현재 수정 중인 댓글 번호와 내용 저장
											var currentEditingComment = null;
											var originalCommentContent = null;

											// 댓글 수정 폼 표시
											function showEditCommentForm(commentNumber, commentContent) {
											  console.log("수정 시작: 댓글 번호 =", commentNumber);
											  
											  // 현재 수정 중인 댓글 정보 저장
											  currentEditingComment = commentNumber;
											  originalCommentContent = commentContent;
											  
											  // 댓글 내용 요소 찾기
											  var commentElement = document.getElementById("comment-" + commentNumber);
											  if (!commentElement) {
											    console.error("댓글 요소를 찾을 수 없습니다: comment-" + commentNumber);
											    alert("댓글 요소를 찾을 수 없습니다.");
											    return;
											  }
											  
											  var contentElement = commentElement.querySelector(".comment-content");
											  if (!contentElement) {
											    console.error("댓글 내용 요소를 찾을 수 없습니다");
											    alert("댓글 내용 요소를 찾을 수 없습니다.");
											    return;
											  }
											  
											  // 원래 HTML 내용 저장
											  var originalHtml = contentElement.innerHTML;
											  
											  // HTML 태그 제거하여 순수 텍스트 추출
											  var tempDiv = document.createElement("div");
											  tempDiv.innerHTML = commentContent;
											  var plainText = tempDiv.textContent || tempDiv.innerText || "";
											  
											  console.log("원본 텍스트:", plainText);
											  
											  // 수정 폼 HTML
											  var formHtml = '<div class="edit-form-container">' +
											    '<textarea id="edit-textarea-' + commentNumber + '" class="edit-comment-textarea">' + plainText + '</textarea>' +
											    '<div class="edit-comment-actions">' +
											    '<button type="button" class="cancel-edit-button" onclick="cancelEdit(' + commentNumber + ', \'' + escape(originalHtml) + '\')">취소</button>' +
											    '<button type="button" class="save-edit-button" onclick="saveEdit(' + commentNumber + ')"><i class="fas fa-check"></i> 저장</button>' +
											    '</div></div>';
											  
											  // 내용 교체
											  contentElement.innerHTML = formHtml;
											  
											  // 텍스트 영역에 포커스
											  var textarea = document.getElementById("edit-textarea-" + commentNumber);
											  if (textarea) {
											    console.log("텍스트 영역 찾음:", textarea.id);
											    textarea.focus();
											    textarea.selectionStart = textarea.selectionEnd = textarea.value.length;
											  } else {
											    console.error("텍스트 영역을 찾을 수 없습니다: edit-textarea-" + commentNumber);
											  }
											}

											// 수정 취소
											function cancelEdit(commentNumber, originalHtml) {
											  console.log("수정 취소: 댓글 번호 =", commentNumber);
											  
											  var commentElement = document.getElementById("comment-" + commentNumber);
											  if (!commentElement) {
											    console.error("댓글 요소를 찾을 수 없습니다: comment-" + commentNumber);
											    window.location.reload();
											    return;
											  }
											  
											  var contentElement = commentElement.querySelector(".comment-content");
											  if (!contentElement) {
											    console.error("댓글 내용 요소를 찾을 수 없습니다");
											    window.location.reload();
											    return;
											  }
											  
											  // 원래 내용으로 복원
											  contentElement.innerHTML = unescape(originalHtml);
											  
											  // 전역 변수 초기화
											  currentEditingComment = null;
											  originalCommentContent = null;
											}

											// 수정 내용 저장
											function saveEdit(commentNumber) {
											  console.log("수정 저장: 댓글 번호 =", commentNumber);
											  
											  var textarea = document.getElementById("edit-textarea-" + commentNumber);
											  if (!textarea) {
											    console.error("텍스트 영역을 찾을 수 없습니다: edit-textarea-" + commentNumber);
											    alert("텍스트 영역을 찾을 수 없습니다. 페이지를 새로고침합니다.");
											    window.location.reload();
											    return;
											  }
											  
											  var editedContent = textarea.value;
											  console.log("수정된 내용:", editedContent);
											  
											  // 빈 내용 체크
											  if (!editedContent.trim()) {
											    alert("댓글 내용을 입력해주세요.");
											    textarea.focus();
											    return;
											  }
											  
											  // AJAX 요청으로 댓글 수정
											  $.ajax({
											    type: "post",
											    url: "/bc_modify",
											    data: {
											      commentNumber: commentNumber,
											      commentContent: editedContent
											    },
											    success: function(response) {
											      console.log("수정 성공:", response);
											      alert("댓글이 수정되었습니다.");
											      
											      // 페이지 새로고침 (조회수 증가 방지)
											      var currentUrl = window.location.href;
											      var url = new URL(currentUrl);
											      url.searchParams.set("skipViewCount", "true");
											      window.location.href = url.toString();
											    },
											    error: function(xhr, status, error) {
											      console.error("수정 오류:", error);
											      alert("댓글 수정 중 오류가 발생했습니다.");
											      window.location.reload();
											    }
											  });
											}

											// 댓글 삭제 확인
											function confirmDeleteComment(commentNumber, isReply) {
											  console.log("삭제 확인: 댓글 번호 =", commentNumber, "대댓글 여부 =", isReply);
											  
											  var messageText = isReply ? "이 답글을 삭제하시겠습니까?" : "이 댓글을 삭제하시겠습니까?";
											  var confirmText = isReply ? "답글" : "댓글";
											  
											  if (confirm(messageText + "\n삭제된 " + confirmText + "은 복구할 수 없습니다.")) {
											    deleteComment(commentNumber);
											  }
											}

											// 댓글 삭제 실행
											function deleteComment(commentNumber) {
											  console.log("삭제 실행: 댓글 번호 =", commentNumber);
											  
											  $.ajax({
											    type: "post",
											    url: "/bc_delete",
											    data: {
											      commentNumber: commentNumber
											    },
											    success: function(response) {
											      console.log("삭제 성공:", response);
											      alert("댓글이 삭제되었습니다.");
											      
											      // 페이지 새로고침 (조회수 증가 방지)
											      var currentUrl = window.location.href;
											      var url = new URL(currentUrl);
											      url.searchParams.set("skipViewCount", "true");
											      window.location.href = url.toString();
											    },
											    error: function(xhr, status, error) {
											      console.error("삭제 오류:", error);
											      alert("댓글 삭제 중 오류가 발생했습니다.");
											      window.location.reload();
											    }
											  });
											}

											// 스타일 추가
											document.addEventListener("DOMContentLoaded", function() {
											  var style = document.createElement("style");
											  style.textContent = `
											    /* 댓글 수정/삭제 버튼 스타일 */
											    .comment-actions {
											      display: flex;
											      gap: 8px;
											      margin-left: 10px;
											    }
											    
											    .comment-action-button {
											      background: none;
											      border: none;
											      font-size: 12px;
											      color: #666;
											      cursor: pointer;
											      padding: 2px 6px;
											      border-radius: 4px;
											      transition: all 0.2s ease;
											    }
											    
											    .comment-action-button:hover {
											      background-color: #f0f0f0;
											      color: #333;
											    }
											    
											    .comment-action-button.edit-button:hover {
											      color: #2c73d2;
											    }
											    
											    .comment-action-button.delete-button:hover {
											      color: #e74c3c;
											    }
											    
											    /* 댓글 수정 폼 스타일 */
											    .edit-form-container {
											      width: 100%;
											    }
											    
											    .edit-comment-textarea {
											      width: 100%;
											      min-height: 80px;
											      padding: 8px;
											      border: 1px solid #ddd;
											      border-radius: 4px;
											      resize: vertical;
											      font-family: inherit;
											      font-size: 14px;
											      margin-bottom: 8px;
											    }
											    
											    .edit-comment-actions {
											      display: flex;
											      justify-content: flex-end;
											      gap: 8px;
											    }
											    
											    .cancel-edit-button,
											    .save-edit-button {
											      padding: 6px 12px;
											      border: none;
											      border-radius: 4px;
											      font-size: 13px;
											      cursor: pointer;
											      transition: all 0.2s ease;
											    }
											    
											    .cancel-edit-button {
											      background-color: #f1f1f1;
											      color: #333;
											    }
											    
											    .save-edit-button {
											      background-color: #4a6ee0;
											      color: white;
											    }
											    
											    .cancel-edit-button:hover {
											      background-color: #e0e0e0;
											    }
											    
											    .save-edit-button:hover {
											      background-color: #3a5dc0;
											    }
											  `;
											  document.head.appendChild(style);
											  
											  console.log("댓글 수정/삭제 기능 초기화 완료");
											});
										</script>
									</body>

									</html>
