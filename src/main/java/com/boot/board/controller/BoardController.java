package com.boot.board.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.board.dto.BoardCommentDTO;
import com.boot.board.dto.BoardDTO;
import com.boot.board.service.BoardCommentService;
import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.board.service.BoardService;
import com.boot.z_page.CommentPageDTO;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {

	private final BoardCommentServiceImpl boardCommentServiceImpl;
	@Autowired
	private BoardService service;

	@Autowired
	private BoardCommentService bcService;

	BoardController(BoardCommentServiceImpl boardCommentServiceImpl) {
		this.boardCommentServiceImpl = boardCommentServiceImpl;
	}
	
	@PostMapping("/bc_delete")
	public ResponseEntity<Map<String, Object>> bc_delete(@RequestParam("commentNumber") int commentNumber) {
	    Map<String, Object> response = new HashMap<>();
	    
	    try {
	        HashMap<String, String> param = new HashMap<>();
	        param.put("commentNumber", String.valueOf(commentNumber));
	        
	        // 댓글 상태를 'DELETED'로 변경하는 서비스 호출
	        bcService.bcDelete(param);
	        
	        response.put("success", true);
	        response.put("message", "댓글이 성공적으로 삭제되었습니다.");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "댓글 삭제 중 오류가 발생했습니다: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	@PostMapping("/bc_modify")
	public ResponseEntity<Map<String, Object>> bc_modify(
	        @RequestParam("commentNumber") int commentNumber,
	        @RequestParam("commentContent") String commentContent) {
	    
	    Map<String, Object> response = new HashMap<>();
	    
	    try {
	        HashMap<String, String> param = new HashMap<>();
	        param.put("commentNumber", String.valueOf(commentNumber));
	        param.put("commentContent", commentContent);
	        
	        // 댓글 수정 서비스 호출
	        bcService.bcModify(param);
	        
	        response.put("success", true);
	        response.put("message", "댓글이 성공적으로 수정되었습니다.");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", "댓글 수정 중 오류가 발생했습니다: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

//	@RequestMapping("/board_view")
//	public String boardView(CriteriaDTO criteriaDTO, Model model) {
//		ArrayList<BoardDTO> list = service.boardView(criteriaDTO);
//		int total = service.getTotalCount(criteriaDTO);
//
//		model.addAttribute("currentPage", "board_view"); // 헤더 식별용
//		model.addAttribute("boardList", list);
//		model.addAttribute("pageMaker", new PageDTO(total, criteriaDTO));
//
//		return "board_view";
//	}
	
	@RequestMapping("/board_view")
	public String boardList(Model model, CriteriaDTO criteriaDTO) {
	    // 게시글 목록 조회
	    ArrayList<BoardDTO> list = service.boardView(criteriaDTO);
	    
	    // 각 게시글의 댓글 수 조회
	    Map<Integer, Integer> commentCounts = new HashMap<>();
	    for (BoardDTO board : list) {
	        int boardNumber = board.getBoardNumber();
	        int commentCount = service.getCommentCountByBoardNumber(boardNumber);
	        commentCounts.put(boardNumber, commentCount);
	    }
	    
	    // 모델에 추가
	    model.addAttribute("commentCounts", commentCounts);
	    model.addAttribute("boardList", list);
	    model.addAttribute("currentPage", "board_view"); // 헤더 식별용
	    
	    // 페이징 처리
	    int total = service.getTotalCount(criteriaDTO);
	    model.addAttribute("pageMaker", new PageDTO(total, criteriaDTO));
	    
	    return "board/board_view";
	}

	@RequestMapping("/board_write_ok")
	public String boardViewWrite(@RequestParam HashMap<String, String> param) {

		service.boardWrite(param);

		return "board/board_view";
	}

	@RequestMapping("/delete_post")
	public String boardViewDelete(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
		service.boardDelete(param);
		rttr.addAttribute("pageNum", param.get("pageNum"));
		rttr.addAttribute("amount", param.get("amount"));
		return "board/board_view";
	}

	@RequestMapping("/board_update_ok")
	public String boardViewUpdate(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
		service.boardModify(param);
		rttr.addAttribute("boardNumber", param.get("boardNumber"));
	    rttr.addAttribute("pageNum", param.get("pageNum"));
	    rttr.addAttribute("amount", param.get("amount"));
	    return "redirect:board_detail_view";
	}

	@RequestMapping("/board_update")
	public String boardViewUpdate(@RequestParam HashMap<String, String> param, Model model) {
		BoardDTO dto = service.boardDetailView(param);
		model.addAttribute("board", dto);
		return "board/board_update";
	}

	@RequestMapping("/board_detail_view")
	public String boardViewDetail(@RequestParam HashMap<String, String> param, Model model,
	        CriteriaDTO criteriaDTO,
	        @RequestParam(value = "skipViewCount", required = false) Boolean skipViewCount,
	        @RequestParam(value = "commentPageNum", required = false, defaultValue = "1") int commentPageNum) {
	    
	    // 댓글 페이지 번호 설정
	    criteriaDTO.setCommentPageNum(commentPageNum);
	    
	    if (skipViewCount == null || !skipViewCount) {
	        // 조회수 증가 로직
	        service.boardHit(param);
	    }
	    
	    BoardDTO dto = service.boardDetailView(param);
	    ArrayList<BoardCommentDTO> commentList = bcService.bcView(param, criteriaDTO);
	    System.out.println("test : " + commentList);
	    int total = bcService.getTotalCount(param);
	    int allTotal = bcService.getAllCount(param);

	    model.addAttribute("allCount", allTotal);
	    model.addAttribute("board", dto);
	    model.addAttribute("commentList", commentList);
	    model.addAttribute("pageMaker", new CommentPageDTO(total, criteriaDTO));
	    
	    return "board/board_detail";
	}

	@RequestMapping("/boardLikes")
	public ResponseEntity<String> boardLikes(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
//	    UserDTO user = (UserDTO) session.getAttribute("loginUser");
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
	    if (user == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인필요");
	    }
	    int boardNumber = Integer.parseInt(param.get("boardNumber"));
	    int userNumber = user.getUserNumber();
	    param.put("userNumber", String.valueOf(userNumber));

	    try {
	        // 이미 좋아요를 눌렀는지 확인
	        if (service.boardHasLiked(param)) {
	            // 좋아요 취소 처리
	            service.boardRemoveLike(param);
	            return ResponseEntity.ok("추천 취소 완료");
	        } else {
	            // 좋아요 추가 처리
	            service.boardAddLike(param);
	            return ResponseEntity.ok("추천 완료");
	        }
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류 발생");
	    }
	}

	@RequestMapping("/comment_write_ok")
	public String commentWriteOk(@RequestParam HashMap<String, String> param) {
		String boardNumber = param.get("boardNumber");
		if (param.get("commentContent") == "") {
			// 빈 댓글일 경우에도 skipViewCount=true 파라미터 추가
			return "redirect:/board_detail_view?boardNumber=" + boardNumber + "&skipViewCount=true";
		}
		bcService.bcWrite(param);

		return "redirect:board_detail_view?boardNumber=" + boardNumber + "&skipViewCount=true";
	}
	
	
	// 추천 확인(버튼색반전용)
	@GetMapping("/checkLikeStatus")
	@ResponseBody
	public boolean checkLikeStatus(@RequestParam("boardNumber") int boardNumber, HttpSession session) {
	    UserDTO user = (UserDTO) session.getAttribute("loginUser");
	    if (user == null) {
	        return false;
	    }
	    
	    HashMap<String, String> param = new HashMap<>();
	    param.put("boardNumber", String.valueOf(boardNumber));
	    param.put("userNumber", String.valueOf(user.getUserNumber()));
	    
	    return service.boardHasLiked(param);
	}
	
	
}