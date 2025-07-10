package com.boot.book.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.book.dto.BookDTO;
import com.boot.book.dto.BookRecordDTO;
import com.boot.book.dto.ReviewDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.z_page.criteria.UserBookBorrowingCriteriaDTO;

public interface BookReviewService {

	public int checkReview(HashMap<String, String> param);

	public ArrayList<ReviewDTO> getReview(@Param("criteria") NoticeCriteriaDTO criteria,
			@Param("param") HashMap<String, String> param);

	public int getReviewCount(@Param("criteria") NoticeCriteriaDTO criteria,
			@Param("param") HashMap<String, String> param);

	public int insertReview(HashMap<String, String> param);

	public int updateReview(ReviewDTO reviewDTO);

	public int deleteReview(ReviewDTO reviewDTO);

	public ReviewDTO getReviewById(int reviewId);

	// 도서별 리뷰 통계 조회 (페이징 없이 모든 리뷰 가져오기)
	public ArrayList<ReviewDTO> getAllReviewsByBookNumber(int bookNumber);

	// 리뷰 도움됨 추가
	boolean addReviewHelpful(int reviewId, int userNumber);

	// 리뷰 도움됨 취소
	boolean removeReviewHelpful(int reviewId, int userNumber);

	// 리뷰 도움됨 여부 확인
	boolean checkReviewHelpful(int reviewId, int userNumber);

	// 리뷰별 도움됨 개수 조회
	int getReviewHelpfulCount(int reviewId);

}
