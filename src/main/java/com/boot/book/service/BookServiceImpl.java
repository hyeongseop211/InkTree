package com.boot.book.service;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.book.dao.BookDAO;
import com.boot.book.dto.BookDTO;
import com.boot.book.dto.BookRecordDTO;
import com.boot.book.dto.ReviewDTO;
import com.boot.book.dto.ReviewHelpfulDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.z_page.criteria.UserBookBorrowingCriteriaDTO;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;
import com.boot.user.service.AdminActivityLogService;

@Service
public class BookServiceImpl implements BookService {
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private HttpServletRequest request;
	@Autowired
	private AdminActivityLogService adminActivityLogService;

	@Override
	public void insertBook(HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

		if (user.getUserAdmin() == 1) {
			dao.insertBook(param);
			
			// 활동 로그 추가
			String bookTitle = param.get("bookTitle");
			String description = "\"" + bookTitle + "\" 도서가 등록되었습니다.";
			adminActivityLogService.createActivityLog(
				"book_add", 
				"admin", 
				user.getUserNumber(), 
				user.getUserName(), 
				bookTitle, 
				description
			);
		} else {
			System.out.println("Not Admin access");
		}
	}

	@Override
	public void updateBook(HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

		if (user.getUserAdmin() == 1) {
			dao.updateBook(param);
			
			// 활동 로그 추가
			String bookTitle = param.get("bookTitle");
			String description = "\"" + bookTitle + "\" 도서가 수정되었습니다.";
			adminActivityLogService.createActivityLog(
				"book_modify", 
				"admin", 
				user.getUserNumber(), 
				user.getUserName(), 
				bookTitle, 
				description
			);
		} else {
			System.out.println("Not Admin access");
		}
	}

	@Override
	public ArrayList<BookDTO> mainBookInfo() {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		ArrayList<BookDTO> list = dao.mainBookInfo();
		return list;
	}

	@Override
	public int getSearchBookTotalCount(SearchBookCriteriaDTO criteria, String majorCategory, String subCategory) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		return dao.getSearchBookTotalCount(criteria, majorCategory, subCategory);
	}

	@Override
	public ArrayList<BookDTO> searchBookInfo(SearchBookCriteriaDTO criteria, String majorCategory, String subCategory) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		return dao.searchBookInfo(criteria, majorCategory, subCategory);
	}

	@Override
	public BookDTO bookDetailInfo(HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		BookDTO dto = dao.bookDetailInfo(param);
		return dto;
	}

	@Override
	public void bookBorrow(HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		dao.bookBorrow(param);

		// 활동 로그 추가
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		
		// 도서 정보 가져오기
		String bookNumber = param.get("bookNumber");
		HashMap<String, String> bookParam = new HashMap<>();
		bookParam.put("bookNumber", bookNumber);
		BookDTO book = dao.bookDetailInfo(bookParam);
		
		if (book != null) {
			String bookTitle = book.getBookTitle();
			String userName = user.getUserName();
			String description = userName + " 회원이 \"" + bookTitle + "\" 도서를 대출했습니다.";
			
			String actorType = user.getUserAdmin() == 1 ? "admin" : "user";
			adminActivityLogService.createActivityLog(
				"book_borrow", 
				actorType, 
				user.getUserNumber(), 
				user.getUserName(), 
				bookTitle, 
				description
			);
		}

	}

	@Override
	public void bookReturn(HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		dao.bookReturn(param);

		// 활동 로그 추가
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		
		// 도서 정보 가져오기
		String bookNumber = param.get("bookNumber");
		HashMap<String, String> bookParam = new HashMap<>();
		bookParam.put("bookNumber", bookNumber);
		BookDTO book = dao.bookDetailInfo(bookParam);
		
		if (book != null) {
			String bookTitle = book.getBookTitle();
			String userName = user.getUserName();
			String description = userName + " 회원이 \"" + bookTitle + "\" 도서를 반납했습니다.";
			
			String actorType = user.getUserAdmin() == 1 ? "admin" : "user";
			adminActivityLogService.createActivityLog(
				"book_return", 
				actorType, 
				user.getUserNumber(), 
				user.getUserName(), 
				bookTitle, 
				description
			);
		}
	}

	@Override
	public ArrayList<BookRecordDTO> bookBorrowed(UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO,
			HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		return dao.bookBorrowed(userBookBorrowingCriteriaDTO, param);
	}

	@Override
	public ArrayList<BookRecordDTO> bookRecord(UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO,
			HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		return dao.bookRecord(userBookBorrowingCriteriaDTO, param);
	}

	@Override
	public void deleteBook(HashMap<String, String> param) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		
		// 도서 정보 가져오기
		String bookNumber = param.get("bookNumber");
		HashMap<String, String> bookParam = new HashMap<>();
		bookParam.put("bookNumber", bookNumber);
		BookDTO book = dao.bookDetailInfo(bookParam);
		
		// 도서 삭제
		dao.deleteBook(param);
		
		// 활동 로그 추가
		if (book != null) {
			String bookTitle = book.getBookTitle();
			String description = "\"" + bookTitle + "\" 도서가 삭제되었습니다.";
			adminActivityLogService.createActivityLog(
				"book_delete", 
				"admin", 
				user.getUserNumber(), 
				user.getUserName(), 
				bookTitle, 
				description
			);
		}

	}

	@Override
	public int getBorrowedTotalCount(UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO, int userNumber) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		int total = dao.getBorrowedTotalCount(userBookBorrowingCriteriaDTO, userNumber);
		return total;
	}

	@Override
	public int getRecordTotalCount(UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO, int userNumber) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		int total = dao.getRecordTotalCount(userBookBorrowingCriteriaDTO, userNumber);
		return total;
	}

}