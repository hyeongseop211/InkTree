package com.boot.z_util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.boot.z_util.otherMVC.service.UtilService;


@Component
public class ServerStartupListener implements ApplicationListener<ContextRefreshedEvent> {

    @Autowired
    private UtilService service;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        // 서버 시작 시 모든 세션 정보 삭제
    	service.clearAllSessions();
        System.out.println("서버 시작: 모든 세션 정보가 삭제되었습니다.");
    }
}