package com.boot.trade.controller;

import java.util.ArrayList;
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

import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.trade.dto.TradePostDTO;
import com.boot.trade.service.TradePostService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class TradePostController {

    private static final String NULL = null;
	@Autowired
    private TradePostService service;

    @RequestMapping("/trade_post_view")
    public String tradePostList(Model model, SearchBookCriteriaDTO criteriaDTO) {
        // 게시글 목록 조회
        ArrayList<TradePostDTO> list = service.tradePostView(criteriaDTO);
        
        // 모델에 추가
        model.addAttribute("postList", list);
        model.addAttribute("currentPage", "trade_post_view"); // 헤더 식별용
        
        // 페이징 처리
        int total = service.getTotalCount(criteriaDTO);
        model.addAttribute("pageMaker", new PageDTO(total, criteriaDTO));
        
        return "trade/trade_post_view";
    }

    @RequestMapping("/trade_post_write")
    public String tradePostWriteView(Model model, HttpServletRequest request) {
    	BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
    	model.addAttribute("user", user);
    	String userAddress = "";
    	if(user.getUserAddress() != NULL) {
    		userAddress = user.getUserAddress();
    	}
//    	String[] strArr = userAddress.split("구");
//    	
//    	System.out.println("userAddress : " + userAddress);
//    	System.out.println("strArr[0] : " + strArr[0]);
//    	System.out.println("strArr[1] : " + strArr[1]);
//    	System.out.println("indexOf : " + userAddress.indexOf("구"));
//    	System.out.println("subString - indexOf : " + userAddress.substring(0, userAddress.indexOf("구")+1));
    	
    	model.addAttribute("addr", userAddress.substring(0, userAddress.indexOf("구")+1));
        return "trade/trade_post_write";
    }
    @RequestMapping("/trade_post_write_ok")
    public String tradePostWrite(@RequestParam HashMap<String, String> param) {
        service.tradePostWrite(param);
        return "redirect:trade_post_view";
    }

    @PostMapping("/trade_post_delete")
    @ResponseBody
    public Map<String, Object> tradePostDeleteAjax(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
        	BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
            TradePostDTO post = service.tradePostDetailView(param);
            
            // 권한 체크 (작성자 또는 관리자만 삭제 가능)
            if (user == null || (user.getUserNumber() != post.getUserNumber() && user.getUserAdmin() != 1)) {
                response.put("success", false);
                response.put("message", "삭제 권한이 없습니다.");
                return response;
            }
            
            service.tradePostDelete(param);
            response.put("success", true);
            return response;
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return response;
        }
    }

    @RequestMapping("/trade_post_update_ok")
    public String tradePostUpdate(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
    	System.out.println("param : =>" + param);
        service.tradePostModify(param);
        rttr.addAttribute("postID", param.get("postID"));
        rttr.addAttribute("pageNum", param.get("pageNum"));
        rttr.addAttribute("amount", param.get("amount"));
        return "redirect:/trade_post_detail_view";
    }

    @RequestMapping("/trade_post_update")
    public String tradePostUpdateForm(@RequestParam HashMap<String, String> param, Model model) {
        TradePostDTO dto = service.tradePostDetailView(param);
        model.addAttribute("post", dto);
        return "trade/trade_post_update";
    }

    @RequestMapping("/trade_post_detail_view")
    public String tradePostDetail(@RequestParam HashMap<String, String> param, Model model,
            @RequestParam(value = "skipViewCount", required = false) Boolean skipViewCount,
            HttpServletRequest request) {
        
        if (skipViewCount == null || !skipViewCount) {
            // 조회수 증가 로직
            service.tradePostHit(param);
        }
        
        TradePostDTO dto = service.tradePostDetailView(param);
        model.addAttribute("post", dto);
        
        // 관련 게시물(판매중인 다른 게시글) 조회 추가
        
        System.out.println("param : "+param);
        ArrayList<TradePostDTO> availablePosts = service.getAvailablePosts(param);
        model.addAttribute("availablePosts", availablePosts);
        
        // 좋아요 수와 채팅 수 추가
        int likeCount = service.getLikeCountByPostID(Integer.parseInt(param.get("postID")));
        int chatCount = service.getChatCountByPostID(Integer.parseInt(param.get("postID")));
        model.addAttribute("likeCount", likeCount);
        model.addAttribute("chatCount", chatCount);
        
     // 현재 사용자가 좋아요 했는지 확인
        BasicUserDTO user = (BasicUserDTO) request.getAttribute("user"); 
        boolean isLiked = false;
        if (user != null) {
            HashMap<String, String> likeParam = new HashMap<>();
            likeParam.put("postID", param.get("postID"));
            likeParam.put("userNumber", String.valueOf(user.getUserNumber()));
            isLiked = service.tradePostCheckFavorite(likeParam);
        }
        model.addAttribute("isLiked", isLiked);
        
        return "trade/trade_post_detail_view";
    }

    
    
    @RequestMapping("/trade_post_favorite")
    public ResponseEntity<Map<String, Object>> tradePostFavorite(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        
        int postID = Integer.parseInt(param.get("postID"));
        int userNumber = user.getUserNumber();
        param.put("userNumber", String.valueOf(userNumber));

        try {
            // 이미 찜했는지 확인
            if (service.tradePostCheckFavorite(param)) {
                // 찜 취소 처리
                service.tradePostRemoveFavorite(param);
                response.put("success", true);
                response.put("message", "관심 상품에서 제거되었습니다.");
                response.put("action", "removed");
            } else {
                // 찜 추가 처리
                service.tradePostAddFavorite(param);
                response.put("success", true);
                response.put("message", "관심 상품에 추가되었습니다.");
                response.put("action", "added");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    @RequestMapping("/update_trade_status")
    public ResponseEntity<Map<String, Object>> updateTradeStatus(
            @RequestParam HashMap<String, String> param, 
            HttpServletRequest request) {
        
        Map<String, Object> response = new HashMap<>();
        
        BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        
        // 게시글 작성자 확인 로직 필요
        TradePostDTO post = service.tradePostDetailView(param);
        if (post.getUserNumber() != user.getUserNumber()) {
            response.put("success", false);
            response.put("message", "게시글 작성자만 상태를 변경할 수 있습니다.");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
        
        try {
            service.updateTradeStatus(param);
            response.put("success", true);
            response.put("message", "거래 상태가 변경되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}