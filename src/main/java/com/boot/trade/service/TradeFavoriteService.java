package com.boot.trade.service;

import java.util.List;

import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.trade.dto.TradeFavoriteDTO;

public interface TradeFavoriteService {
    // 관심목록 추가
    public boolean addFavorite(TradeFavoriteDTO wishlistDTO);
    
    // 관심목록 삭제
    public boolean removeFavorite(TradeFavoriteDTO wishlistDTO);
    
    // 관심목록 조회 (페이징, 필터링, 정렬 적용)
    public List<TradeFavoriteDTO> getFavoriteWithPaging(SearchBookCriteriaDTO criteriaDTO);
    
    // 관심목록 총 개수
    public int getTotalCount(SearchBookCriteriaDTO criteriaDTO);
    
    // 관심목록 체크 (이미 추가되었는지 확인)
    public boolean checkFavorite(TradeFavoriteDTO wishlistDTO);
}
