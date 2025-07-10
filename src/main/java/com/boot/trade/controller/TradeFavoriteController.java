package com.boot.trade.controller;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.trade.dto.TradeFavoriteDTO;
import com.boot.trade.service.TradeFavoriteService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;

@Controller
public class TradeFavoriteController {

    private final BoardCommentServiceImpl boardCommentServiceImpl;

	@Autowired
	private TradeFavoriteService service;

    TradeFavoriteController(BoardCommentServiceImpl boardCommentServiceImpl) {
        this.boardCommentServiceImpl = boardCommentServiceImpl;
    }

	// 관심목록 페이지 조회
	@GetMapping("/trade_post_favorite_view")
	public String FavoriteView(SearchBookCriteriaDTO criteriaDTO, Model model, HttpServletRequest request) {
		// 로그인 체크
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

		// 상태 필터 기본값 설정
		if (criteriaDTO.getStatus() == null || criteriaDTO.getStatus().isEmpty()) {
			criteriaDTO.setStatus("all");
		}

		// 정렬 기본값 설정
		if (criteriaDTO.getSort() == null || criteriaDTO.getSort().isEmpty()) {
			criteriaDTO.setSort("latest");
		}

		// 관심목록 조회
		List<TradeFavoriteDTO> favoriteItems = service.getFavoriteWithPaging(criteriaDTO);
		System.out.println(favoriteItems.size());
		for(int i=0;i<favoriteItems.size();i++) {
			System.out.println("favoriteItems["+i+"] : " + favoriteItems.get(i));
		}

        int total = service.getTotalCount(criteriaDTO);
        model.addAttribute("pageMaker", new PageDTO(total, criteriaDTO));
		// 모델에 데이터 추가
		model.addAttribute("favoriteItems", favoriteItems);
		model.addAttribute("totalItems", total);

		return "trade/trade_post_favorite_view";
	}

	// 관심목록 추가 (AJAX)
	@PostMapping("/add_Favorite")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> addFavorite(@RequestBody TradeFavoriteDTO FavoriteDTO,
			HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();

		// 로그인 체크
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		if (user == null) {
			response.put("success", false);
			response.put("message", "로그인이 필요한 서비스입니다.");
			return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
		}

		// 사용자 번호 설정
		FavoriteDTO.setUserNumber(user.getUserNumber());

		// 이미 추가된 항목인지 체크
		if (service.checkFavorite(FavoriteDTO)) {
			response.put("success", false);
			response.put("message", "이미 관심목록에 추가된 상품입니다.");
			return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
		}

		// 관심목록 추가
		boolean result = service.addFavorite(FavoriteDTO);

		if (result) {
			response.put("success", true);
			response.put("message", "관심목록에 추가되었습니다.");
			return new ResponseEntity<>(response, HttpStatus.OK);
		} else {
			response.put("success", false);
			response.put("message", "관심목록 추가에 실패했습니다.");
			return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	// 관심목록 삭제 (AJAX)
	@PostMapping("/remove_favorite")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> removeFavorite(@RequestBody TradeFavoriteDTO FavoriteDTO,
			HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();

		// 로그인 체크
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		if (user == null) {
			response.put("success", false);
			response.put("message", "로그인이 필요한 서비스입니다.");
			return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
		}

		// 사용자 번호 설정
		FavoriteDTO.setUserNumber(user.getUserNumber());

		// 관심목록 삭제
		boolean result = service.removeFavorite(FavoriteDTO);

		if (result) {
			response.put("success", true);
			response.put("message", "관심목록에서 삭제되었습니다.");
			return new ResponseEntity<>(response, HttpStatus.OK);
		} else {
			response.put("success", false);
			response.put("message", "관심목록 삭제에 실패했습니다.");
			return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}
