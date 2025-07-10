package com.boot.book.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.book.dao.WishlistDAO;
import com.boot.book.dto.BookDTO;
import com.boot.book.service.WishlistServiceImpl;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.WishlistCriteriaDTO;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;

@Controller
public class WishlistController {

	@Autowired
	private WishlistServiceImpl wishlistService;

	@Autowired
	private WishlistDAO wishlistDAO;

	@PostMapping(value = "/add_wishlist", produces = "text/plain;charset=UTF-8")
	public @ResponseBody String addToWishlist(@RequestParam("bookNumber") int bookNumber, HttpServletRequest request) {
		System.out.println("=== 위시리스트 추가 요청 받음 ===");
		System.out.println("bookNumber: " + bookNumber);

		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

		try {

			String result = wishlistService.addWishlist(user.getUserNumber(), bookNumber);
			System.out.println("추가 결과: " + result);
			return result;
		} catch (Exception e) {
			System.err.println("위시리스트 추가 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	@PostMapping(value = "/remove_wishlist", produces = "text/plain;charset=UTF-8")
	public @ResponseBody String removeFromWishlist(@RequestParam("bookNumber") int bookNumber, HttpServletRequest request) {
		System.out.println("=== 위시리스트 삭제 요청 받음 ===");
		System.out.println("bookNumber: " + bookNumber);

		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		try {

			String result = wishlistService.removeWishlist(user.getUserNumber(), bookNumber);
			System.out.println("삭제 결과: " + result);
			return result;
		} catch (Exception e) {
			System.err.println("위시리스트 삭제 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	@PostMapping(value = "/check_wishlist", produces = "text/plain;charset=UTF-8")
	public @ResponseBody String checkWishlist(@RequestParam("bookNumber") int bookNumber, HttpServletRequest request) {
		System.out.println("=== 위시리스트 상태 확인 요청 받음 ===");
		System.out.println("bookNumber: " + bookNumber);

		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		try {
			boolean isInWishlist = wishlistDAO.isAlreadyInWishlist(user.getUserNumber(), bookNumber);
			System.out.println("위시리스트 상태 확인 결과: " + isInWishlist);

			return isInWishlist ? "in_wishlist" : "not_in_wishlist";
		} catch (Exception e) {
			System.err.println("위시리스트 상태 확인 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	@GetMapping("/book_wishlist")
	public String wishlistList(
	        @RequestParam(defaultValue = "1") int page,
	        @RequestParam(required = false) String keyword,
	        @RequestParam(required = false) String bookMajorCategory,
	        @RequestParam(required = false) String bookSubCategory,
	        HttpServletRequest request, Model model) {
	    
	    BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
	    if (user == null)
	        return "redirect:/";

	    WishlistCriteriaDTO criteria = new WishlistCriteriaDTO();
	    criteria.setPage(page);
	    criteria.setKeyword(keyword);
	    criteria.setBookMajorCategory(bookMajorCategory);
	    criteria.setBookSubCategory(bookSubCategory);

	    HashMap<String, Object> param = new HashMap<>();
	    param.put("userNumber", user.getUserNumber());
	    param.put("keyword", keyword);
	    param.put("bookMajorCategory", bookMajorCategory);
	    param.put("bookSubCategory", bookSubCategory);

	    try {
	        List<BookDTO> wishlist = wishlistDAO.getWishlist(criteria, param);
	        int total = wishlistDAO.getWishlistCount(param);
	        
	        System.out.println("위시리스트 디버그 정보 ===================");
	        System.out.println("유저 번호: " + user.getUserNumber());
	        System.out.println("검색어: " + keyword);
	        System.out.println("대분류: " + bookMajorCategory);
	        System.out.println("중분류: " + bookSubCategory);
	        System.out.println("위시리스트 개수: " + (wishlist != null ? wishlist.size() : "null"));
	        System.out.println("전체 개수: " + total);
	        System.out.println("======================================");

	        // 모델에 데이터 추가
	        model.addAttribute("wishlist", wishlist);
	        model.addAttribute("pageMaker", new PageDTO(total, criteria));

	        // 데이터가 비어있는지 확인
	        if (wishlist == null || wishlist.isEmpty()) {
	            System.out.println("위시리스트가 비어있습니다.");
	        }

	        return "book/book_wishlist";
	    } catch (Exception e) {
	        System.err.println("위시리스트 조회 중 오류 발생: " + e.getMessage());
	        e.printStackTrace();

	        // 에러 페이지로 리다이렉트하거나 기본 빈 리스트 표시
	        model.addAttribute("wishlist", new java.util.ArrayList<BookDTO>());
	        model.addAttribute("errorMsg", "위시리스트를 불러오는 중 오류가 발생했습니다.");
	        return "book/book_wishlist";
	    }
	}

}
