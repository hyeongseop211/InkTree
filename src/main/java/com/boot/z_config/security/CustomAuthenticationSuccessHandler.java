package com.boot.z_config.security;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.boot.user.dto.UserDTO;
import com.boot.user.service.UserService;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    // ApplicationContext를 통해 필요할 때 UserService를 가져오는 방식으로 변경
    @Autowired
    private ApplicationContext applicationContext;
    
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        
        UserService userService = applicationContext.getBean(UserService.class);
        
        // 사용자 정보 조회
        HashMap<String, String> param = new HashMap<>();
        param.put("userId", authentication.getName());
        UserDTO dto = userService.getUserInfo(param);
        
        // 사용자 ID 가져오기
        String userId = dto.getUserId();
        
        // 세션에 사용자 정보 저장
        HttpSession session = request.getSession(true);
        session.setAttribute("loginUser", dto);
        
        // 세션 정보 저장 (필요한 경우 DB에 저장하는 로직 추가)
        HashMap<String, String> sessionParam = new HashMap<>();
        sessionParam.put("userId", userId);
        sessionParam.put("sessionId", session.getId());
        
        // 메인 페이지로 리다이렉트
        response.sendRedirect("/");
    }
}