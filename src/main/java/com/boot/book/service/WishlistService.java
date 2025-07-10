package com.boot.book.service;

import java.util.List;

import com.boot.book.dto.BookDTO;

public interface WishlistService {
	public String addWishlist(int userNumber, int bookNumber);

	public List<BookDTO> Wishlist(int userNumber, int page);

	public int WishlistCount(int userNumber);

	public String removeWishlist(int userNumber, int bookNumber);

}
