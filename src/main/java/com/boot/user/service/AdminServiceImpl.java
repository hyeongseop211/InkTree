package com.boot.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.board.dao.NoticeDAO;
import com.boot.board.dto.NoticeDTO;
import com.boot.user.dto.UserDTO;
import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;

@Service
public class AdminServiceImpl implements AdminService {
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private AdminActivityLogService activityLogService;
	@Autowired
	private HttpSession session;

	@Override
	public void NoticeWrite(HashMap<String, String> param) {
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
		dao.NoticeWrite(param);

		// 활동 로그 추가
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser != null) {
			String noticeTitle = param.get("noticeTitle");
			String description = "\"" + noticeTitle + "\" 공지사항이 등록되었습니다.";
			
			String actorType = loginUser.getUserAdmin() == 1 ? "admin" : "user";
			activityLogService.createActivityLog(
				"notice_add", 
				actorType, 
				loginUser.getUserNumber(), 
				loginUser.getUserName(), 
				noticeTitle, 
				description
			);
		}
	}

	@Override
	public ArrayList<NoticeDTO> NoticeView(NoticeCriteriaDTO noticeCriteriaDTO) {
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
		ArrayList<NoticeDTO> list = dao.NoticeView(noticeCriteriaDTO);
		return list;
	}

	@Override
	public NoticeDTO NoticeDetailView(HashMap<String, String> param) {
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
		dao.NoticeHit(param);
		NoticeDTO dto = dao.NoticeDetailView(param);
		return dto;
	}

	@Override
	public void NoticeModify(HashMap<String, String> param) {
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
		dao.NoticeModify(param);

		// 활동 로그 추가
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser != null) {
			String noticeTitle = param.get("noticeTitle");
			String description = "\"" + noticeTitle + "\" 공지사항이 수정되었습니다.";
			
			String actorType = loginUser.getUserAdmin() == 1 ? "admin" : "user";
			activityLogService.createActivityLog(
				"notice_modify", 
				actorType, 
				loginUser.getUserNumber(), 
				loginUser.getUserName(), 
				noticeTitle, 
				description
			);
		}
	}

	@Override
	public void NoticeDelete(HashMap<String, String> param) {
		// 공지사항 정보 조회
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
		NoticeDTO notice = dao.NoticeDetailView(param);
		
		// 공지사항 삭제
		dao.NoticeDelete(param);
		
		// 활동 로그 추가
		UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
		if (loginUser != null && notice != null) {
			String noticeTitle = notice.getNoticeTitle();
			String description = "\"" + noticeTitle + "\" 공지사항이 삭제되었습니다.";
			
			String actorType = loginUser.getUserAdmin() == 1 ? "admin" : "user";
			activityLogService.createActivityLog(
				"notice_delete", 
				actorType, 
				loginUser.getUserNumber(), 
				loginUser.getUserName(), 
				noticeTitle, 
				description
			);
		}
	}

	@Override
	public int getTotalCount(NoticeCriteriaDTO noticeCriteriaDTO) {
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
		int total = dao.getTotalCount(noticeCriteriaDTO);
		return total;
	}
	@Override
    public Map<String, Integer> getAllCategoryCounts() {
		NoticeDAO dao = sqlSession.getMapper(NoticeDAO.class);
        return dao.getAllCategoryCounts();
    }
}
