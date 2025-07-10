package com.boot.user.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.user.dto.AdminActivityLogDTO;
import com.boot.z_page.criteria.AdminActivityLogCriteriaDTO;


public interface AdminActivityLogService {
    // 로그 생성
    public void createActivityLog(AdminActivityLogDTO log);
    
    // 로그 생성 (파라미터 기반)
    public void createActivityLog(String activityType, String actorType, int actorId, 
                                  String actorName, String targetName, String description);
    
    
    // 로그 추가
    public void addActivityLog(AdminActivityLogDTO log);
    
    // 최근 활동 가져오기
    public ArrayList<AdminActivityLogDTO> getRecentActivities(int limit);
    
    // 특정 유형의 활동 로그만 가져오기
    public ArrayList<AdminActivityLogDTO> getActivitiesByType(String activityType, int limit);
    
    // 모든 로그 가져오기 (페이징 처리)
    public ArrayList<AdminActivityLogDTO> getAllActivities(HashMap<String, Object> params);
    
    // 총 로그 수 가져오기
    public int getTotalLogCount();
    
    // 모든 활동 조회 (Criteria 객체 활용 - 새 메소드)
    public ArrayList<AdminActivityLogDTO> getAllActivities(AdminActivityLogCriteriaDTO cri);
    
    // 총 로그 수 조회 (필터링 적용 - 새 메소드)
    public int getTotalLogCount(AdminActivityLogCriteriaDTO cri);
} 