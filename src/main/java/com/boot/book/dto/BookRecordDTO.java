package com.boot.book.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookRecordDTO {
	private int recordNumber;
	private int userNumber;
	private int bookNumber;
	private String bookTitle;
	private String bookWrite;
	private String bookBorrowDate;
	private String bookReturnDate;
}
