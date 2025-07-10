package com.boot.book.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.book.dto.BookDTO;

public interface BookRecommendDAO {
	public ArrayList<BookDTO> Top5Recommend(HashMap<String, String> param);

	public ArrayList<BookDTO> Top3Borrow();

	public ArrayList<BookDTO> Top5Random(HashMap<String, String> param);

	public String CategoryNum(HashMap<String, String> param);
}
