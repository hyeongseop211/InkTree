package com.boot.z_util.otherMVC.service;

import java.util.HashMap;

public interface UtilService {
	public int getTotalBooks();

	public int getTotalUsers();

	public int getBorrowedBooks();

	public int getOverdueBooks();

	public int getUserOver(HashMap<String, String> param);

	public int getUserBorrowed(HashMap<String, String> param);

	public int getUserRecord(HashMap<String, String> param);
	
	public int getBookRecordCount(HashMap<String, String> param);
	
	public void clearAllSessions();
}
