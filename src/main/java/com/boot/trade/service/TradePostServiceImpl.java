package com.boot.trade.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.trade.dao.TradePostDAO;
import com.boot.trade.dto.TradePostDTO;

@Service
public class TradePostServiceImpl implements TradePostService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public void tradePostWrite(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		System.out.println("paramserIm @# +>" + param);
		dao.tradePostWrite(param);
	}

	@Override
	public ArrayList<TradePostDTO> tradePostView(SearchBookCriteriaDTO criteriaDTO) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		ArrayList<TradePostDTO> list = dao.tradePostView(criteriaDTO);
		return list;
	}

	@Override
	public TradePostDTO tradePostDetailView(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		TradePostDTO dto = dao.tradePostDetailView(param);
		return dto;
	}

	@Override
	public void tradePostModify(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		dao.tradePostModify(param);
	}

	@Override
	public void tradePostDelete(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		dao.tradePostDelete(param);
	}

	@Override
	public void tradePostHit(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		dao.tradePostHit(param);
	}

	@Override
	public boolean tradePostCheckFavorite(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		return dao.tradePostCheckFavorite(param) > 0;
	}

	@Override
	public void tradePostAddFavorite(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		dao.tradePostAddFavorite(param);
	}

	@Override
	public void tradePostRemoveFavorite(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		dao.tradePostRemoveFavorite(param);
	}

	@Override
	public int getTotalCount(SearchBookCriteriaDTO criteriaDTO) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		int total = dao.getTotalCount(criteriaDTO);
		return total;
	}

	@Override
	public void updateTradeStatus(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		dao.updateTradeStatus(param);
	}

	@Override
	public ArrayList<TradePostDTO> getAvailablePosts(HashMap<String, String> param) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		return dao.getAvailablePosts(param);
	}

	@Override
	public int getLikeCountByPostID(int postID) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		return dao.getLikeCountByPostID(postID);
	}

	@Override
	public int getChatCountByPostID(int postID) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		return dao.getChatCountByPostID(postID);
	}

	@Override
	public TradePostDTO getTradePostById(Long postID) {
		TradePostDAO dao = sqlSession.getMapper(TradePostDAO.class);
		return dao.getTradePostById(postID);
	}
}