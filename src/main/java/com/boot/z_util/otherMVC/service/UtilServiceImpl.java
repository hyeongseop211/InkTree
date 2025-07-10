package com.boot.z_util.otherMVC.service;

import java.util.*;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.z_util.otherMVC.dao.UtilDAO;



@Service
public class UtilServiceImpl implements UtilService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public int getTotalBooks() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getTotalBooks();
	}

	@Override
	public int getTotalUsers() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getTotalUsers();
	}

	@Override
	public int getBorrowedBooks() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getBorrowedBooks();
	}

	@Override
	public int getOverdueBooks() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getOverdueBooks();
	}

	@Override
	public int getUserOver(HashMap<String, String> param) {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getUserOver(param);
	}

	@Override
	public int getUserBorrowed(HashMap<String, String> param) {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getUserBorrowed(param);
	}

	@Override
	public int getUserRecord(HashMap<String, String> param) {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getUserRecord(param);
	}
	
	@Override
	public int getBookRecordCount(HashMap<String, String> param) {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getBookRecordCount(param);
	}

	@Override
	public void clearAllSessions() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
	    dao.clearAllSessions();
	}
}
