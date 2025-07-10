package com.boot.book.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.boot.book.dto.BookDTO;
import com.boot.book.dto.BookRecordDTO;
import com.boot.book.dto.ReviewDTO;
import com.boot.book.dto.ReviewHelpfulDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.z_page.criteria.UserBookBorrowingCriteriaDTO;

public interface BookReviewDAO {
	public int checkReview(HashMap<String, String> param);

	public int getReviewCount(@Param("criteria") NoticeCriteriaDTO criteria,
			@Param("param") HashMap<String, String> param);

	// 5개씩 정렬을 위해 NoticeCriteriaDTO 사용
	public ArrayList<ReviewDTO> getReview(@Param("criteria") NoticeCriteriaDTO criteria,
			@Param("param") HashMap<String, String> param);

	public int insertReview(HashMap<String, String> param);

	public int updateReview(ReviewDTO reviewDTO);

	public int deleteReview(ReviewDTO reviewDTO);

	public ReviewDTO getReviewById(int reviewId);

	// 도서별 리뷰 통계 조회 (페이징 없이 모든 리뷰 가져오기)
	public ArrayList<ReviewDTO> getAllReviewsByBookNumber(int bookNumber);

	// 리뷰 도움됨 추가
	int addReviewHelpful(ReviewHelpfulDTO helpfulDTO);

	// 리뷰 도움됨 취소
	int removeReviewHelpful(ReviewHelpfulDTO helpfulDTO);

	// 리뷰 도움됨 여부 확인
	int checkReviewHelpful(ReviewHelpfulDTO helpfulDTO);

	// 리뷰별 도움됨 개수 조회
	int getReviewHelpfulCount(int reviewId);

	public ArrayList<BookDTO> Top5Recommend(HashMap<String, String> param);

	public ArrayList<BookDTO> Top3Borrow();

	public ArrayList<BookDTO> Top5Random(HashMap<String, String> param);

	public String CategoryNum(HashMap<String, String> param);
}
