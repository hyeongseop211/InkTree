package com.boot.book.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.book.dto.BookDTO;
import com.boot.book.dto.ReviewDTO;
import com.boot.book.dto.ReviewStatsDTO;
import com.boot.book.service.BookReviewService;
import com.boot.book.service.BookService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;

@Controller
public class BookReviewController {
	private final BoardCommentServiceImpl boardCommentServiceImpl;

	@Autowired
	private BookReviewService service;
	@Autowired
	private BookService bookService;

	BookReviewController(BoardCommentServiceImpl boardCommentServiceImpl) {
		this.boardCommentServiceImpl = boardCommentServiceImpl;
	}

	@GetMapping("/get_review")
	@ResponseBody
	public ResponseEntity<?> getReviewById(@RequestParam("reviewId") int reviewId) {
		try {
			ReviewDTO review = service.getReviewById(reviewId);
			if (review == null) {
				Map<String, Object> response = new HashMap<>();
				response.put("success", false);
				response.put("message", "리뷰를 찾을 수 없습니다.");
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
			}
			return ResponseEntity.ok(review);
		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "리뷰 정보를 가져오는 중 오류가 발생했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@PostMapping("/updateReview")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateReview(ReviewDTO reviewDTO, HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			// 로그인 확인
			UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
			if (loginUser == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
			}

			// 사용자 번호 설정
			reviewDTO.setUserNumber(loginUser.getUserNumber());

			// 현재 날짜를 java.sql.Date로 설정
			long millis = System.currentTimeMillis();
			reviewDTO.setReviewModifiedDate(new java.sql.Date(millis));

			// 디버깅을 위한 로그 출력
			System.out.println("수정 요청 데이터: " + reviewDTO);

			// 리뷰 수정 서비스 호출
			int result = service.updateReview(reviewDTO);

			if (result == 1) {
				response.put("success", true);
				response.put("message", "리뷰가 성공적으로 수정되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "리뷰 수정에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "리뷰 수정 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@PostMapping("/deleteReview")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteReview(@RequestParam("reviewId") int reviewId,
			HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();

		try {
			// 로그인 확인
			BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
			if (user == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
			}

			// 관리자 권한 확인 (필요한 경우)
			// if (loginUser.getUserAdmin() != 1) {
			// response.put("success", false);
			// response.put("message", "권한이 없습니다.");
			// return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
			// }

			// ReviewDTO 객체 생성 및 설정
			ReviewDTO reviewDTO = new ReviewDTO();
			reviewDTO.setReviewId(reviewId);
			reviewDTO.setUserNumber(user.getUserNumber());

			// 리뷰 삭제 서비스 호출
			int result = service.deleteReview(reviewDTO);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "리뷰가 성공적으로 삭제되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "리뷰 삭제에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "리뷰 삭제 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@PostMapping("/insertReview")
	public ResponseEntity<Map<String, Object>> insertReview(@RequestParam HashMap<String, String> param,
			HttpServletRequest request) {

		Map<String, Object> response = new HashMap<>();

		try {

			System.out.println("전달된 파라미터: " + param);

			// 로그인 확인
			BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

			if (!param.containsKey("reviewRating") || param.get("reviewRating").trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "평점을 선택해주세요.");
				return ResponseEntity.badRequest().body(response);
			}

			if (!param.containsKey("reviewTitle") || param.get("reviewTitle").trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "제목을 입력해주세요.");
				return ResponseEntity.badRequest().body(response);
			}

			if (!param.containsKey("reviewContent") || param.get("reviewContent").trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "내용을 입력해주세요.");
				return ResponseEntity.badRequest().body(response);
			}

			// 사용자 정보 추가
			param.put("userNumber", String.valueOf(user.getUserNumber()));

			// 이미 리뷰를 작성했는지 확인
		    if (service.checkReview(param) == 1) {
		        response.put("success", false);
		        response.put("message", "이미 이 도서에 대한 리뷰를 작성하셨습니다.");
		        return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
		    }
			// 리뷰 등록
			int result = service.insertReview(param);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "리뷰가 성공적으로 등록되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "리뷰 등록에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@RequestMapping("/book_detail")
	public String bookDetail(NoticeCriteriaDTO noticeCriteriaDTO, @RequestParam HashMap<String, String> param,
			Model model, HttpServletRequest request) {
		System.out.println("param => " + param);
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		model.addAttribute("user", user);
		
		BookDTO dto = bookService.bookDetailInfo(param);

		int total = service.getReviewCount(noticeCriteriaDTO, param);

		List<ReviewDTO> list = service.getReview(noticeCriteriaDTO, param);

		// 리뷰 통계 정보 계산
		ReviewStatsDTO reviewStats = calculateReviewStats(Integer.parseInt(param.get("bookNumber")));
		model.addAttribute("reviewStats", reviewStats);

		model.addAttribute("book", dto);
		model.addAttribute("reviewList", list);
		for (int i = 0; i < list.size(); i++) {
			System.out.println("list[" + i + "] : " + list.get(i));
		}
		model.addAttribute("total", total);
		model.addAttribute("pageMaker", new PageDTO(total, noticeCriteriaDTO));
		return "book/book_detail";
	}

	@PostMapping("/review_helpful")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> addReviewHelpful(@RequestParam("reviewId") int reviewId,
			HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			// 로그인 확인
			UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
			if (loginUser == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
			}

			int userNumber = loginUser.getUserNumber();

			// 도움됨 추가
			boolean result = service.addReviewHelpful(reviewId, userNumber);

			if (result) {
				response.put("success", true);
				response.put("message", "리뷰에 도움됨을 표시했습니다.");
				response.put("helpfulCount", service.getReviewHelpfulCount(reviewId));
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "이미 도움됨을 표시한 리뷰입니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "도움됨 처리 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	@PostMapping("/review_unhelpful")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> removeReviewHelpful(@RequestParam("reviewId") int reviewId,
			HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			// 로그인 확인
			UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
			if (loginUser == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
			}

			int userNumber = loginUser.getUserNumber();

			// 도움됨 취소
			boolean result = service.removeReviewHelpful(reviewId, userNumber);

			if (result) {
				response.put("success", true);
				response.put("message", "리뷰에 도움됨 표시를 취소했습니다.");
				response.put("helpfulCount", service.getReviewHelpfulCount(reviewId));
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "도움됨 표시를 취소할 수 없습니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "도움됨 취소 처리 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 리뷰 통계 계산 메서드
	private ReviewStatsDTO calculateReviewStats(int bookNumber) {
		ReviewStatsDTO stats = new ReviewStatsDTO();

		// 모든 리뷰 가져오기 (페이징 없이)
		ArrayList<ReviewDTO> allReviews = service.getAllReviewsByBookNumber(bookNumber);

		// 전체 리뷰 수
		int totalReviews = allReviews.size();
		stats.setTotalReviews(totalReviews);

		// 리뷰가 없는 경우 기본값 설정
		if (totalReviews == 0) {
			stats.setAverageRating(0);
			stats.setFiveStarPercentage(0);
			stats.setFourStarPercentage(0);
			stats.setThreeStarPercentage(0);
			stats.setTwoStarPercentage(0);
			stats.setOneStarPercentage(0);
			stats.setFiveStarCount(0);
			stats.setFourStarCount(0);
			stats.setThreeStarCount(0);
			stats.setTwoStarCount(0);
			stats.setOneStarCount(0);
			return stats;
		}

		// 평점 합계 및 각 별점 개수 계산
		double ratingSum = 0;
		int fiveStarCount = 0;
		int fourStarCount = 0;
		int threeStarCount = 0;
		int twoStarCount = 0;
		int oneStarCount = 0;

		for (ReviewDTO review : allReviews) {
			int rating = review.getReviewRating();
			ratingSum += rating;

			switch (rating) {
			case 5:
				fiveStarCount++;
				break;
			case 4:
				fourStarCount++;
				break;
			case 3:
				threeStarCount++;
				break;
			case 2:
				twoStarCount++;
				break;
			case 1:
				oneStarCount++;
				break;
			}
		}

		// 평균 평점 계산 (소수점 첫째 자리까지 반올림)
		double averageRating = ratingSum / totalReviews;
		stats.setAverageRating(Math.round(averageRating * 10) / 10.0);

		// 각 별점 개수 설정
		stats.setFiveStarCount(fiveStarCount);
		stats.setFourStarCount(fourStarCount);
		stats.setThreeStarCount(threeStarCount);
		stats.setTwoStarCount(twoStarCount);
		stats.setOneStarCount(oneStarCount);

		// 각 별점 비율 계산 (%)
		stats.setFiveStarPercentage((int) Math.round((double) fiveStarCount / totalReviews * 100));
		stats.setFourStarPercentage((int) Math.round((double) fourStarCount / totalReviews * 100));
		stats.setThreeStarPercentage((int) Math.round((double) threeStarCount / totalReviews * 100));
		stats.setTwoStarPercentage((int) Math.round((double) twoStarCount / totalReviews * 100));
		stats.setOneStarPercentage((int) Math.round((double) oneStarCount / totalReviews * 100));

		return stats;
	}
}
