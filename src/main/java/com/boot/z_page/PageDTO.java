package com.boot.z_page;


import com.boot.z_page.criteria.AdminActivityLogCriteriaDTO;
import com.boot.z_page.criteria.CriteriaDTO;
import com.boot.z_page.criteria.NoticeCriteriaDTO;
import com.boot.z_page.criteria.SearchBookCriteriaDTO;
import com.boot.z_page.criteria.UserBookBorrowingCriteriaDTO;
import com.boot.z_page.criteria.WishlistCriteriaDTO;

import lombok.Data;

@Data
public class PageDTO {
   private int startPage;// 시작페이지:1, 11 . . .
   private int endPage;// 끝페이지:10, 20 . . .
   private boolean prev, next;
   private int total;
   private CriteriaDTO criteriaDTO;
   private NoticeCriteriaDTO noticeCriteriaDTO;
   private UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO;
   private SearchBookCriteriaDTO searchBookCriteriaDTO;
   private WishlistCriteriaDTO wishlistCriteriaDTO;
   private AdminActivityLogCriteriaDTO adminActivityLogCriteriaDTO;
   

   public PageDTO(int total, CriteriaDTO criteriaDTO) {
      this.total = total;
      this.criteriaDTO = criteriaDTO;

      // ex> 3페이지 = (3 / 10) -> 0.3 -> (1 * 10) = 10(끝페이지)
      // ex> 11페이지 = (11 / 10) -> 1.1 -> (2 * 10) = 20(끝페이지)
      // Math.ceil => 올림
      this.endPage = (int) (Math.ceil(criteriaDTO.getPageNum() / 10.0)) * 10;

      // ex> 10-9=1페이지
      // ex> 20-9=11페이지
      this.startPage = this.endPage - 9;

      // ex> total: 300, 현재 페이지: 3 -> endPage: 10 => 300*1.0 / 10 => 30 페이지
      // ex> total: 70, 현재 페이지: 3 -> endPage: 10 => 70*1.0 / 10 => 7 페이지
      int realEnd = (int) (Math.ceil((total * 1.0) / criteriaDTO.getAmount()));

      // ex> 7페이지 <= 10페이지 : endPage = 7페이지(realEnd)
      if (realEnd <= this.endPage) {
         this.endPage = realEnd;
      }

      // 1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
      this.prev = this.startPage > 1;

      // ex> 10페이지 < 30페이지
      this.next = this.endPage < realEnd;
   }
   
   public PageDTO(int total, NoticeCriteriaDTO noticeCriteriaDTO) {
	      this.total = total;
	      this.noticeCriteriaDTO = noticeCriteriaDTO;

	      // ex> 3페이지 = (3 / 10) -> 0.3 -> (1 * 10) = 10(끝페이지)
	      // ex> 11페이지 = (11 / 10) -> 1.1 -> (2 * 10) = 20(끝페이지)
	      // Math.ceil => 올림
	      this.endPage = (int) (Math.ceil(noticeCriteriaDTO.getPageNum() / 10.0)) * 10;

	      // ex> 10-9=1페이지
	      // ex> 20-9=11페이지
	      this.startPage = this.endPage - 9;

	      // ex> total: 300, 현재 페이지: 3 -> endPage: 10 => 300*1.0 / 10 => 30 페이지
	      // ex> total: 70, 현재 페이지: 3 -> endPage: 10 => 70*1.0 / 10 => 7 페이지
	      int realEnd = (int) (Math.ceil((total * 1.0) / noticeCriteriaDTO.getAmount()));

	      // ex> 7페이지 <= 10페이지 : endPage = 7페이지(realEnd)
	      if (realEnd <= this.endPage) {
	         this.endPage = realEnd;
	      }

	      // 1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
	      this.prev = this.startPage > 1;

	      // ex> 10페이지 < 30페이지
	      this.next = this.endPage < realEnd;
	   }
   
   public PageDTO(int total, UserBookBorrowingCriteriaDTO userBookBorrowingCriteriaDTO) {
	   this.total = total;
	   this.userBookBorrowingCriteriaDTO = userBookBorrowingCriteriaDTO;
	   
	   // ex> 3페이지 = (3 / 10) -> 0.3 -> (1 * 10) = 10(끝페이지)
	   // ex> 11페이지 = (11 / 10) -> 1.1 -> (2 * 10) = 20(끝페이지)
	   // Math.ceil => 올림
	   this.endPage = (int) (Math.ceil(userBookBorrowingCriteriaDTO.getPageNum() / 10.0)) * 10;
	   
	   // ex> 10-9=1페이지
	   // ex> 20-9=11페이지
	   this.startPage = this.endPage - 9;
	   
	   // ex> total: 300, 현재 페이지: 3 -> endPage: 10 => 300*1.0 / 10 => 30 페이지
	   // ex> total: 70, 현재 페이지: 3 -> endPage: 10 => 70*1.0 / 10 => 7 페이지
	   int realEnd = (int) (Math.ceil((total * 1.0) / userBookBorrowingCriteriaDTO.getAmount()));
	   
	   // ex> 7페이지 <= 10페이지 : endPage = 7페이지(realEnd)
	   if (realEnd <= this.endPage) {
		   this.endPage = realEnd;
	   }
	   
	   // 1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
	   this.prev = this.startPage > 1;
	   
	   // ex> 10페이지 < 30페이지
	   this.next = this.endPage < realEnd;
   }
   
   
   public PageDTO(int total, SearchBookCriteriaDTO searchBookCriteriaDTO) {
	   this.total = total;
	   this.searchBookCriteriaDTO = searchBookCriteriaDTO;
	   
	   // ex> 3페이지 = (3 / 10) -> 0.3 -> (1 * 10) = 10(끝페이지)
	   // ex> 11페이지 = (11 / 10) -> 1.1 -> (2 * 10) = 20(끝페이지)
	   // Math.ceil => 올림
	   this.endPage = (int) (Math.ceil(searchBookCriteriaDTO.getPageNum() / 10.0)) * 10;
	   
	   // ex> 10-9=1페이지
	   // ex> 20-9=11페이지
	   this.startPage = this.endPage - 9;
	   
	   // ex> total: 300, 현재 페이지: 3 -> endPage: 10 => 300*1.0 / 10 => 30 페이지
	   // ex> total: 70, 현재 페이지: 3 -> endPage: 10 => 70*1.0 / 10 => 7 페이지
	   int realEnd = (int) (Math.ceil((total * 1.0) / searchBookCriteriaDTO.getAmount()));
	   
	   // ex> 7페이지 <= 10페이지 : endPage = 7페이지(realEnd)
	   if (realEnd <= this.endPage) {
		   this.endPage = realEnd;
	   }
	   
	   // 1페이지보다 크면 존재 -> 참이고 아님 거짓으로 없음
	   this.prev = this.startPage > 1;
	   
	   // ex> 10페이지 < 30페이지
	   this.next = this.endPage < realEnd;
   }
   
   // 위시리스트 페이징
   public PageDTO(int total, WishlistCriteriaDTO wishlistCriteriaDTO) {
      this.total = total;
      this.wishlistCriteriaDTO = wishlistCriteriaDTO;

      this.endPage = (int) (Math.ceil(wishlistCriteriaDTO.getPage() / 10.0)) * 10;
      this.startPage = this.endPage - 9;

      int realEnd = (int) (Math.ceil((total * 1.0) / wishlistCriteriaDTO.getAmount()));

      if (realEnd <= this.endPage) {
         this.endPage = realEnd;
      }

      this.prev = this.startPage > 1;
      this.next = this.endPage < realEnd;
   }
   
   // 활동 로그 페이징을 위한 생성자
   public PageDTO(int total, AdminActivityLogCriteriaDTO adminActivityLogCriteriaDTO) {
      this.total = total;
      this.adminActivityLogCriteriaDTO = adminActivityLogCriteriaDTO;

      this.endPage = (int) (Math.ceil(adminActivityLogCriteriaDTO.getPageNum() / 10.0)) * 10;
      this.startPage = this.endPage - 9;

      int realEnd = (int) (Math.ceil((total * 1.0) / adminActivityLogCriteriaDTO.getAmount()));

      if (realEnd <= this.endPage) {
         this.endPage = realEnd;
      }

      this.prev = this.startPage > 1;
      this.next = this.endPage < realEnd;
   }
   
   // 활동 로그 간단 페이징 (page, size만 사용)
   public PageDTO(int total, int page, int size) {
      this.total = total;
      
      this.endPage = (int) (Math.ceil(page / 10.0)) * 10;
      this.startPage = this.endPage - 9;

      int realEnd = (int) (Math.ceil((total * 1.0) / size));

      if (realEnd <= this.endPage) {
         this.endPage = realEnd;
      }

      this.prev = this.startPage > 1;
      this.next = this.endPage < realEnd;
   }
}