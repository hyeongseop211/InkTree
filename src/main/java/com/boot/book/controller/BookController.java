package com.boot.book.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.book.dto.BookDTO;
import com.boot.book.dto.BookRecordDTO;
import com.boot.book.dto.ReviewDTO;
import com.boot.book.dto.ReviewStatsDTO;
import com.boot.book.service.BookRecommendService;
import com.boot.book.service.BookReviewService;
import com.boot.book.service.BookService;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.z_page.criteria.UserBookBorrowingCriteriaDTO;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;
import com.boot.z_util.otherMVC.service.UtilService;

@Controller
public class BookController {

	private final BoardCommentServiceImpl boardCommentServiceImpl;

	@Autowired
	private BookService service;
	@Autowired
	private BookRecommendService bookRecommendService;
	@Autowired
	private UtilService utilService;

	BookController(BoardCommentServiceImpl boardCommentServiceImpl) {
		this.boardCommentServiceImpl = boardCommentServiceImpl;
	}

	@RequestMapping("/book_insert")
	public String insertBook(HttpServletRequest request, @RequestParam HashMap<String, String> param) {
		service.insertBook(param);

		return "admin/admin_view";
	}

	@RequestMapping("/update_book")
	public String updateBookView(@RequestParam HashMap<String, String> param, BookDTO book, Model model,
			HttpServletRequest request) {
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

		if (user == null || user.getUserAdmin() != 1) {
			return "main";
		}
		book = service.bookDetailInfo(param);
		System.out.println("book : " + book);
		model.addAttribute("book", book);
		return "book/book_update";
	}

	@RequestMapping("/update_book_ok")
	public String updateBook(@RequestParam HashMap<String, String> param) {
		System.out.println("param : " + param);
		service.updateBook(param);
		return "main";
	}

	@RequestMapping("/book_search_view")
	public String searchBookView(@ModelAttribute("searchBookCriteriaDTO") SearchBookCriteriaDTO searchBookCriteriaDTO,
			@RequestParam(value = "majorCategory", required = false) String majorCategory,
			@RequestParam(value = "subCategory", required = false) String subCategory, Model model) {

		// amount가 0이면 기본값 설정
		if (searchBookCriteriaDTO.getAmount() <= 0) {
			searchBookCriteriaDTO.setAmount(10);
		}

		// 서비스 메서드 호출
		List<BookDTO> list = service.searchBookInfo(searchBookCriteriaDTO, majorCategory, subCategory);

		int total = service.getSearchBookTotalCount(searchBookCriteriaDTO, majorCategory, subCategory);

		model.addAttribute("bookList", list);
		model.addAttribute("total", total);
		model.addAttribute("pageMaker", new PageDTO(total, searchBookCriteriaDTO));

		return "book/book_search";
	}

	@RequestMapping("/book_delete")
	public ResponseEntity<String> bookDelete(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		if (user == null || user.getUserAdmin() != 1) {
			return ResponseEntity.status(HttpStatus.CONFLICT).body("noUser");
		}

		param.put("userNumber", String.valueOf(user.getUserNumber()));

		try {
			service.deleteBook(param);
			return ResponseEntity.ok("successDelete");
		} catch (Exception e) {
			e.printStackTrace();

			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("unexpectedServerError");
		}
	}

	@RequestMapping("/book_borrow")
	public ResponseEntity<String> bookBorrow(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

		if (user == null) {
			return ResponseEntity.status(HttpStatus.CONFLICT).body("noUser");
		}

		param.put("userNumber", String.valueOf(user.getUserNumber()));

		try {
			service.bookBorrow(param);
			return ResponseEntity.ok("successBorrow");
		} catch (Exception e) {
			e.printStackTrace();
			String msg = (e.getMessage() != null) ? e.getMessage() : "";

			if (msg.contains("ORA-20001")) {
				return ResponseEntity.status(HttpStatus.CONFLICT).body("userInfoError");
			} else if (msg.contains("ORA-20002")) {
				return ResponseEntity.status(HttpStatus.CONFLICT).body("userCanBorrowOver");
			} else if (msg.contains("ORA-20004")) {
				return ResponseEntity.status(HttpStatus.CONFLICT).body("alreadyBorrow");
			}

			// ❗ 조건 다 안 맞을 때를 위한 기본 응답
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("unexpectedServerError");
		}
	}

	@RequestMapping("/book_return")
	public String bookReturn(@RequestParam HashMap<String, String> param, HttpServletRequest request, Model model) {
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		if (user == null) {
			return "redirect:main"; // 로그인 안 되어 있으면 메인으로 이동
		}
		int userNumber = user.getUserNumber();

		param.put("userNumber", String.valueOf(userNumber)); // 사용자 번호를 param에 추가
		try {
			service.bookReturn(param);
		} catch (Exception e) {
			e.printStackTrace(); // 개발 시 에러 확인용
			// db에서 발생한 사용자 정의 예외 처리

			String message = e.getMessage();
			if (message != null && message.contains("ORA-20004")) {
				model.addAttribute("return_errorMsg", "대출 정보가 존재하지 않아 반납할 수 없습니다.");
			} else {
				model.addAttribute("return_errorMsg", "알 수 없는 오류: " + message);
			}
			return "mypage";
		}
		model.addAttribute("return_successMSG", "도서 반납이 성공적으로 완료되었습니다!");
		return "user/mypage";
	}

	@RequestMapping("/user_book_recommend")
	public String bookRecomm(HttpServletRequest request, @RequestParam HashMap<String, String> param, Model model) {

		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		param.put("userNumber", String.valueOf(user.getUserNumber()));
		int majorCategoryNumber = Integer.parseInt(bookRecommendService.CategoryNum(param));

		int rn = 0;
		ArrayList<BookDTO> top3Borrow = bookRecommendService.Top3Borrow();
		ArrayList<BookDTO> Top5Recommend = null;
		ArrayList<BookDTO> Top5Random = null;
		if (majorCategoryNumber == 0) {
			Top5Recommend = null;
			Top5Random = null;
			param.put("majorCategoryNumber", String.valueOf(majorCategoryNumber));
			param.put("rn", String.valueOf(rn));
		}
		if (majorCategoryNumber == 1) {
			rn = 3;
			param.put("majorCategoryNumber", String.valueOf(majorCategoryNumber));
			param.put("rn", String.valueOf(rn));
		}
		if (majorCategoryNumber == 2) {
			rn = 2;
			param.put("majorCategoryNumber", String.valueOf(majorCategoryNumber));
			param.put("rn", String.valueOf(rn));
		}
		if (majorCategoryNumber >= 3) {
			rn = 1;
			param.put("majorCategoryNumber", String.valueOf(majorCategoryNumber));
			param.put("rn", String.valueOf(rn));
		}

		Top5Recommend = bookRecommendService.Top5Recommend(param);
		Top5Random = bookRecommendService.Top5Random(param);

		System.out.println("majorCategoryNumber : " + majorCategoryNumber);

		// 전체 리스트 내용 출력
		System.out.println("Top3 대출 도서: " + top3Borrow);
		System.out.println("Top5 추천 도서: " + Top5Recommend); // 소분류
		System.out.println("Top5 랜덤 도서: " + Top5Random); // 대분류

		model.addAttribute("top3Borrow", top3Borrow);
		model.addAttribute("Top5Recommend", Top5Recommend);
		model.addAttribute("Top5Random", Top5Random);

		return "book/user_book_recommend";
	}

	@RequestMapping("/user_book_borrowing")
	public String bookBorrow(HttpServletRequest request, @RequestParam HashMap<String, String> param, Model model,
			UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO,
			@RequestParam(required = false) String activeTab) {
		BasicUserDTO dto = (BasicUserDTO) request.getAttribute("user");

		param.put("userNumber", String.valueOf(dto.getUserNumber()));

		// 대출 중인 도서 목록을 가져오기 위한 별도의 DTO 생성
		// 페이지네이션 없이 모든 대출 중인 도서를 가져오기 위함
		UserBookBorrowingCriteriaDTO borrowedCriteria = new UserBookBorrowingCriteriaDTO();
		borrowedCriteria.setPageNum(1); // 항상 첫 페이지 (전체 데이터)
		borrowedCriteria.setAmount(100); // 충분히 큰 수로 설정하여 모든 대출 중인 도서를 가져옴

		// 대출 중인 도서는 항상 모두 가져옴 (페이지네이션 없이)
		ArrayList<BookRecordDTO> bookBorrowedList = service.bookBorrowed(borrowedCriteria, param);

		// 대출 기록은 페이지네이션 적용
		ArrayList<BookRecordDTO> bookBorrowList = service.bookRecord(userBookBorrowingCriteriaDTO, param);

		int userBorrowedBooks = utilService.getUserBorrowed(param);
		int userRecord = utilService.getUserRecord(param);
		int userOver = utilService.getUserOver(param);
		int userRecordCount = utilService.getBookRecordCount(param);

		model.addAttribute("bookBorrowedList", bookBorrowedList);
		model.addAttribute("bookBorrowList", bookBorrowList);
		model.addAttribute("userBorrowedBooks", userBorrowedBooks);
		model.addAttribute("userRecord", userRecord);
		model.addAttribute("userOver", userOver);
		model.addAttribute("userRecordCount", userRecordCount);

		System.out.println("userBorrowedBooks => " + bookBorrowedList);
		
		// 활성 탭 정보 모델에 추가 (없으면 기본값은 'borrowed')
		model.addAttribute("activeTab", activeTab != null ? activeTab : "borrowed");

		// 대출 기록에 대한 페이지네이션 정보만 설정
		int recordTotal = service.getRecordTotalCount(userBookBorrowingCriteriaDTO,
				Integer.parseInt(param.get("userNumber")));
		model.addAttribute("pageMaker", new PageDTO(recordTotal, userBookBorrowingCriteriaDTO));

		return "book/user_book_borrowing";
	}


}
