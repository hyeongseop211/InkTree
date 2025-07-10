package com.boot.trade.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.trade.dto.TradePostDTO;

public interface TradePostService {
	public void tradePostWrite(HashMap<String, String> param);

	public ArrayList<TradePostDTO> tradePostView(SearchBookCriteriaDTO criteriaDTO);

	public TradePostDTO tradePostDetailView(HashMap<String, String> param);

	public void tradePostModify(HashMap<String, String> param);

	public void tradePostDelete(HashMap<String, String> param);

	public void tradePostHit(HashMap<String, String> param);

	public boolean tradePostCheckFavorite(HashMap<String, String> param);

	public void tradePostAddFavorite(HashMap<String, String> param);

	public void tradePostRemoveFavorite(HashMap<String, String> param);

	public int getTotalCount(SearchBookCriteriaDTO criteriaDTO);

	public void updateTradeStatus(HashMap<String, String> param);

	// 판매중인 다른 게시글 조회
	ArrayList<TradePostDTO> getAvailablePosts(HashMap<String, String> param);

	// 게시글의 좋아요 수 조회
	int getLikeCountByPostID(int postID);

	// 게시글의 채팅 수 조회
	int getChatCountByPostID(int postID);
	
	// 채팅용
    TradePostDTO getTradePostById(Long postID);
}