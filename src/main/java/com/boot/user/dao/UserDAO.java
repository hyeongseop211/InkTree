package com.boot.user.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.boot.user.dto.UserDTO;

public interface UserDAO {
	public int userJoin(HashMap<String, String> param);

	public ArrayList<UserDTO> userLogin(HashMap<String, String> param);

	public UserDTO checkId(HashMap<String, String> param);

	public int checkEmail(String email);

	public UserDTO getUserInfo(HashMap<String, String> param);

	public int updateUserInfo(HashMap<String, String> param);

	public int updateUserPwInfo(HashMap<String, String> param);

	public UserDTO findByUserId(String userId);

	public List<UserDTO> findAllUserNumber();

}
