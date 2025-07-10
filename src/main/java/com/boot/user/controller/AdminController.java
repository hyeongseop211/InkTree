package com.boot.user.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.board.dto.NoticeDTO;
import com.boot.board.service.BoardService;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;
import com.boot.user.dto.AdminActivityLogDTO;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.service.AdminActivityLogService;
import com.boot.user.service.AdminService;
import com.boot.z_util.otherMVC.service.UtilService;

@Controller
public class AdminController {
	@Autowired
	private UtilService service;
	@Autowired
	private AdminService admin_service;
	@Autowired
	private BoardService board_service;
	@Autowired
	private AdminActivityLogService activityLogService;

	@RequestMapping("/admin_view")
	public String adminView(Model model, HttpServletRequest request) {
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		// 기본 정보 로딩
		model.addAttribute("totalBooks", service.getTotalBooks());
		model.addAttribute("totalUsers", service.getTotalUsers());
		model.addAttribute("borrowedBooks", service.getBorrowedBooks());
		model.addAttribute("overdueBooks", service.getOverdueBooks());
		model.addAttribute("user", user);
		
		// 최근 활동 로그 가져오기 (5개)
		try {
			ArrayList<AdminActivityLogDTO> recentActivities = activityLogService.getRecentActivities(5);
			model.addAttribute("recentActivities", recentActivities);
		} catch (Exception e) {
			e.printStackTrace();
			// 오류 발생 시 빈 리스트 전달하여 페이지는 정상 로드되도록 함
			model.addAttribute("recentActivities", new ArrayList<AdminActivityLogDTO>());
		}
		
		return "admin/admin_view";
	}


	@RequestMapping("/admin_notice")
	public String adminNoti(Model model, NoticeCriteriaDTO noticeCriteriaDTO) {
		// 페이지네이션된 공지사항 목록 가져오기
		ArrayList<NoticeDTO> list = admin_service.NoticeView(noticeCriteriaDTO);

		// 내용 길이 제한 (기존 코드 유지)
		for (NoticeDTO dto : list) {
			String content = dto.getNoticeContent();
			if (content != null && content.length() > 20) {
				dto.setNoticeContent(content.substring(0, 20) + "...");
			}
		}

		model.addAttribute("noticeList", list);
		model.addAttribute("currentPage", "admin_notice"); // 헤더 식별용

		// 모든 카테고리 카운트를 한 번에 가져오기
		Map<String, Integer> categoryCounts = admin_service.getAllCategoryCounts();

		model.addAttribute("countAll", categoryCounts.get("total"));
		model.addAttribute("countImportant", categoryCounts.get("important"));
		model.addAttribute("countEvent", categoryCounts.get("event"));
		model.addAttribute("countInfo", categoryCounts.get("info"));
		model.addAttribute("countUpdate", categoryCounts.get("update"));

		// 페이징 처리 (기존 코드 유지)
		int total = admin_service.getTotalCount(noticeCriteriaDTO);
		model.addAttribute("pageMaker", new PageDTO(total, noticeCriteriaDTO));

		return "admin/admin_notice";
	}

	@RequestMapping("/admin_notice_write")
	public String adminNoticeWrite() {
		return "admin/admin_notice_write";
	}

	@RequestMapping("/admin_write_ok")
	public String adminNotiWrite(@RequestParam HashMap<String, String> param) {
		admin_service.NoticeWrite(param);
		return "admin/admin_notice";

	}

	@RequestMapping("/admin_delete")
	public String adminNotiDelete(@RequestParam HashMap<String, String> param) {
		admin_service.NoticeDelete(param);
		return "redirect:admin_notice";

	}

	@RequestMapping("/admin_update")
	public String adminNotiUpdate(@RequestParam HashMap<String, String> param, Model model) {
		NoticeDTO dto = admin_service.NoticeDetailView(param);
		model.addAttribute("notice", dto);
		return "admin/admin_notice_update";
	}

	@RequestMapping("/admin_update_ok")
	public String adminNotiUpdateOk(@RequestParam HashMap<String, String> param) {
		admin_service.NoticeModify(param);

		return "redirect:admin_notice";
	}

	@RequestMapping("/admin_notice_detail")
	public String adminNotiDetail(@RequestParam HashMap<String, String> param, Model model) {
		NoticeDTO dto = admin_service.NoticeDetailView(param);
		model.addAttribute("notice", dto);
		return "admin/admin_notice_detail";
	}

	@RequestMapping("/book_insert_view")
	public String insertBookView() {
		return "book/book_insert";
	}

	@RequestMapping("/update_book_view")
	public String updateBook() {
		return "book/book_update";
	}
}