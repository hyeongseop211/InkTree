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

public interface BookRecommendService {

	public ArrayList<BookDTO> Top5Recommend(HashMap<String, String> param);

	public ArrayList<BookDTO> Top3Borrow();

	public ArrayList<BookDTO> Top5Random(HashMap<String, String> param);

	public String CategoryNum(HashMap<String, String> param);

}
