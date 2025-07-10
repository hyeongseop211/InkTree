package com.boot.book.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.book.dto.BookDTO;
import com.boot.z_page.criteria.WishlistCriteriaDTO;

@Mapper
public interface WishlistDAO {
    // 이미 위시리스트에 있는지 확인 (boolean 반환으로 변경)
    boolean isAlreadyInWishlist(@Param("userNumber") int userNumber, @Param("bookNumber") int bookNumber);
    
    // 위시리스트에 추가 (void 반환으로 변경)
    void addToWishlist(@Param("userNumber") int userNumber, @Param("bookNumber") int bookNumber);
    
    // 위시리스트에서 삭제 (void 반환으로 변경)
    void removeFromWishlist(@Param("userNumber") int userNumber, @Param("bookNumber") int bookNumber);
    
    // 위시리스트 조회 (WishlistCriteriaDTO와 HashMap 파라미터로 변경)
    List<BookDTO> getWishlist(@Param("criteria") WishlistCriteriaDTO criteria, @Param("param") HashMap<String, Object> param);
    
    // 위시리스트 개수 조회 (HashMap 파라미터로 변경)
    int getWishlistCount(@Param("param") HashMap<String, Object> param);
}
