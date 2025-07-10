package com.boot.book.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.book.dao.WishlistDAO;
import com.boot.book.dto.BookDTO;
import com.boot.z_page.criteria.WishlistCriteriaDTO;

@Service
public class WishlistServiceImpl implements WishlistService {
	@Autowired
	private WishlistDAO wishlistDao;

	@Override
	public String addWishlist(int userNumber, int bookNumber) {
		try {
			System.out.println("WishlistServiceImpl.addWishlist 호출됨");
			System.out.println("userNumber: " + userNumber + ", bookNumber: " + bookNumber);

			if (wishlistDao.isAlreadyInWishlist(userNumber, bookNumber)) {
				System.out.println("이미 위시리스트에 존재함");
				return "already";
			}

			wishlistDao.addToWishlist(userNumber, bookNumber);
			System.out.println("위시리스트에 추가 성공");
			return "Success";
		} catch (Exception e) {
			System.err.println("위시리스트 추가 서비스 오류: " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	@Override
	public List<BookDTO> Wishlist(int userNumber, int page) {
		WishlistCriteriaDTO criteria = new WishlistCriteriaDTO();
		criteria.setPage(page);
		HashMap<String, Object> param = new HashMap<>();
		param.put("userNumber", userNumber);
		return wishlistDao.getWishlist(criteria, param);
	}

	@Override
	public int WishlistCount(int userNumber) {
		HashMap<String, Object> param = new HashMap<>();
		param.put("userNumber", userNumber);
		return wishlistDao.getWishlistCount(param);
	}

	@Override
	public String removeWishlist(int userNumber, int bookNumber) {
		try {
			System.out.println("WishlistServiceImpl.removeWishlist 호출됨");
			System.out.println("userNumber: " + userNumber + ", bookNumber: " + bookNumber);

			boolean exists = wishlistDao.isAlreadyInWishlist(userNumber, bookNumber);
			if (!exists) {
				System.out.println("위시리스트에 존재하지 않음");
				return "not_exists";
			}

			wishlistDao.removeFromWishlist(userNumber, bookNumber);
			System.out.println("위시리스트에서 삭제 성공");
			return "Success";
		} catch (Exception e) {
			System.err.println("위시리스트 삭제 서비스 오류: " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
}
