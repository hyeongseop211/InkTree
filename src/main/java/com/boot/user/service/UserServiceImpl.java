package com.boot.user.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.boot.user.dao.UserDAO;
import com.boot.user.dto.UserDTO;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	@Autowired
	private AdminActivityLogService activityLogService;

	@Override
	public int userJoin(HashMap<String, String> param) {
		int re = -1;
		UserDAO dao = sqlSession.getMapper(UserDAO.class);

		// 비밀번호 암호화
		String rawPassword = param.get("userPw");
		String encodedPassword = passwordEncoder.encode(rawPassword);
		param.put("userPw", encodedPassword);

		re = dao.userJoin(param);

		// 회원가입 성공 시 활동 로그 추가
		if (re == 1) {
			String userName = param.get("userName");
			String userId = param.get("userId");
			String description = userName + "(" + userId + ") 회원이 가입했습니다.";

			activityLogService.createActivityLog("user_add", "user", 0, // 새 회원은 userNumber가 없으므로 0으로 설정
					userName, userId, description);
		}

		return re;
	}

	@Override
	public ArrayList<UserDTO> userLogin(HashMap<String, String> param) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		ArrayList<UserDTO> list = dao.userLogin(param);
		return list;
	}

	@Override
	public UserDTO checkId(HashMap<String, String> param) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		UserDTO dto = dao.checkId(param);
		return dto;
	}

	@Override
	public UserDTO getUserInfo(HashMap<String, String> param) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		UserDTO dto = dao.getUserInfo(param);
		return dto;
	}

	@Override
	public int updateUserInfo(HashMap<String, String> param) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int re = dao.updateUserInfo(param);

		// 사용자 정보 수정 시 활동 로그 추가
		if (re == 1) {
			String userName = param.get("userName");
			String userId = param.get("userId");
			String userNumber = param.get("userNumber");

			if (userNumber == null || userNumber.isEmpty()) {
				// userNumber가 없을 경우 userId로 회원 정보 조회
				UserDTO userDTO = dao.findByUserId(userId);
				if (userDTO != null) {
					userNumber = String.valueOf(userDTO.getUserNumber());
				}
			}

			int userNumberInt = 0;
			try {
				userNumberInt = Integer.parseInt(userNumber);
			} catch (NumberFormatException e) {
				// 변환 실패 시 기본값 0
			}

			String description = userName + "(" + userId + ") 회원의 정보가 수정되었습니다.";

			activityLogService.createActivityLog("user_modify", "user", userNumberInt, userName, userId, description);
		}

		return re;
	}

//	@Override
//	public int updateUserPwInfo(HashMap<String, String> param) {
//		UserDAO dao = sqlSession.getMapper(UserDAO.class);
//		int re = dao.updateUserPwInfo(param);
//		return re;
//	}
	@Override
	public int updateUserPwInfo(HashMap<String, String> param) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		// 새 비밀번호 암호화 - 명시적으로 확인
		if (!param.containsKey("encodedPassword")) {
			String newPassword = param.get("userNewPw");
			String encodedPassword = passwordEncoder.encode(newPassword);
			param.put("encodedPassword", encodedPassword);
		}

		int re = dao.updateUserPwInfo(param);

		// 비밀번호 변경 시 활동 로그 추가
		if (re == 1) {
			String userNumber = param.get("userNumber");

			// 회원 정보 조회
			HashMap<String, String> userParam = new HashMap<>();
			userParam.put("userNumber", userNumber);
			UserDTO userDTO = dao.getUserInfo(userParam);

			if (userDTO != null) {
				String userName = userDTO.getUserName();
				String userId = userDTO.getUserId();
				String description = userName + "(" + userId + ") 회원의 비밀번호가 변경되었습니다.";

				activityLogService.createActivityLog("user_modify", "user", Integer.parseInt(userNumber), userName,
						userId, description);
			}
		}

		return re;
	}

	@Override
	public boolean verifyPassword(HashMap<String, String> param) {
		try {
			// 필요한 파라미터 검증
			if (!param.containsKey("userId") || !param.containsKey("userPw")) {
				return false;
			}

			UserDAO dao = sqlSession.getMapper(UserDAO.class);
			// 1. 사용자 ID로 사용자 정보 조회 (암호화된 비밀번호 포함)
			UserDTO user = dao.getUserInfo(param);

			// 2. 사용자가 존재하지 않으면 false 반환
			if (user == null) {
				return false;
			}

			String rawPassword = param.get("userPw");
			// 3. BCryptPasswordEncoder를 사용하여 비밀번호 일치 여부 확인
			// matches 메서드는 평문 비밀번호와 암호화된 비밀번호를 비교
			return passwordEncoder.matches(rawPassword, user.getUserPw());
		} catch (Exception e) {
			// 로깅 추가
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean checkEmail(String email) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int count = dao.checkEmail(email);
		return count > 0;
	}

	@Override
	public List<UserDTO> findAllUserNumber() {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		List<UserDTO> users = dao.findAllUserNumber();
		return users;
	}

}
