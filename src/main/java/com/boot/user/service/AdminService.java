package com.boot.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.boot.board.dto.NoticeDTO;
import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;


public interface AdminService {
	public void NoticeWrite(HashMap<String, String> param);

	public ArrayList<NoticeDTO> NoticeView(NoticeCriteriaDTO noticeCriteriaDTO);

	public NoticeDTO NoticeDetailView(HashMap<String, String> param);

	public void NoticeModify(HashMap<String, String> param);

	public void NoticeDelete(HashMap<String, String> param);

	public int getTotalCount(NoticeCriteriaDTO noticeCriteriaDTO);

	public Map<String, Integer> getAllCategoryCounts();
}
