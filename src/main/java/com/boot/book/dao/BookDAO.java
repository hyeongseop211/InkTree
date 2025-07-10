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

public interface BookDAO {
	public void insertBook(HashMap<String, String> param);

	public void updateBook(HashMap<String, String> param);

	public ArrayList<BookDTO> mainBookInfo();

	public int getSearchBookTotalCount(@Param("criteria") SearchBookCriteriaDTO criteria,
			@Param("majorCategory") String majorCategory, @Param("subCategory") String subCategory);

	public ArrayList<BookDTO> searchBookInfo(@Param("criteria") SearchBookCriteriaDTO criteria,
			@Param("majorCategory") String majorCategory, @Param("subCategory") String subCategory);

	public BookDTO bookDetailInfo(HashMap<String, String> param);

	public void bookBorrow(HashMap<String, String> param);

	public void bookReturn(HashMap<String, String> param);

	public int getBorrowedCount(HashMap<String, String> param);

	public int getOverdueCount(HashMap<String, String> param);

	public int getReturnedCount(HashMap<String, String> param);

	public ArrayList<BookDTO> isReturned(HashMap<String, String> param);

	public ArrayList<BookRecordDTO> bookBorrowed(
			@Param("criteria") UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO,
			@Param("param") HashMap<String, String> param);

	public ArrayList<BookRecordDTO> bookRecord(
			@Param("criteria") UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO,
			@Param("param") HashMap<String, String> param);

	public void deleteBook(HashMap<String, String> param);

	public int getBorrowedTotalCount(@Param("criteria") UserBookBorrowingCriteriaDTO criteria,
			@Param("userNumber") int userNumber);

	public int getRecordTotalCount(@Param("criteria") UserBookBorrowingCriteriaDTO criteria,
			@Param("userNumber") int userNumber);
}
