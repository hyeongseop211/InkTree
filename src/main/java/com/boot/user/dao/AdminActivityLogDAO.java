package com.boot.user.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.boot.user.dto.AdminActivityLogDTO;
import com.boot.z_page.criteria.AdminActivityLogCriteriaDTO;



@Mapper
public interface AdminActivityLogDAO {
    // 로그 추가
    public void insertActivityLog(AdminActivityLogDTO log);
    
    // 최근 로그 가져오기 (개수 제한)
    public ArrayList<AdminActivityLogDTO> getRecentActivities(int limit);
    
    // 특정 유형의 활동 로그만 가져오기
    public ArrayList<AdminActivityLogDTO> getActivitiesByType(String activityType, int limit);
    
    // 모든 로그 가져오기 (페이징 처리)
    public ArrayList<AdminActivityLogDTO> getAllActivities(HashMap<String, Object> params);
    
    // 총 로그 수 가져오기
    public int getTotalLogCount();
    
    // 모든 로그 가져오기 (Criteria 객체 활용)
    public ArrayList<AdminActivityLogDTO> getAllActivities(AdminActivityLogCriteriaDTO cri);
    
    // 총 로그 수 가져오기 (필터링 적용)
    public int getTotalLogCount(AdminActivityLogCriteriaDTO cri);
} 