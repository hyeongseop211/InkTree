package com.boot.user.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.user.dao.AdminActivityLogDAO;
import com.boot.user.dto.AdminActivityLogDTO;
import com.boot.z_page.criteria.AdminActivityLogCriteriaDTO;



@Service
public class AdminActivityLogServiceImpl implements AdminActivityLogService {
    
    @Autowired
    private SqlSession sqlSession;
    
    @Override
    public void createActivityLog(AdminActivityLogDTO log) {
        AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        
        // 로그 시간이 설정되지 않았으면 현재 시간 설정
        if (log.getLogDate() == null) {
            log.setLogDate(LocalDateTime.now());
        }
        
        try {
            dao.insertActivityLog(log);
        } catch (Exception e) {
            // 오류 발생 시 로그만 기록하고 예외는 삼킴 (사용자 흐름에 영향 없도록)
            e.printStackTrace();
        }
    }
    
    @Override
    public void createActivityLog(String activityType, String actorType, int actorId, 
                                 String actorName, String targetName, String description) {
    	AdminActivityLogDTO log = new AdminActivityLogDTO();
        log.setActivityType(activityType);
        log.setActorType(actorType);
        log.setActorId(actorId);
        log.setActorName(actorName);
        log.setTargetName(targetName);
        log.setDescription(description);
        log.setLogDate(LocalDateTime.now());
        
        createActivityLog(log);
    }
    // @Override
    // public void createActivityLog(int activityType, int actorType, int actorId, 
    //                              String actorName, String targetName, String description) {
    //     ActivityLogDTO log = new ActivityLogDTO();

    //     String activityTypeStr = "";
       
    //     switch (activityType) {
    //         case 1:
    //             activityTypeStr = "book_add";
    //             break;
    //         case 2:
    //             activityTypeStr = "book_delete";
    //             break;
    //         case 3:
    //             activityTypeStr = "book_borrow";
    //             break;
    //         case 4:
    //             activityTypeStr = "book_return";
    //             break;
    //         case 5:
    //             activityTypeStr = "user_add";
    //             break;
    //         case 6:
    //             activityTypeStr = "notice_add";
    //             break;
    //         case 7:
    //             activityTypeStr = "notice_delete";
    //             break;
    //         default:
    //             break;
    //     }

    //     String actorTypeStr = "";
    //     switch (actorType) {
    //         case 1:
    //             actorTypeStr = "admin";
    //             break;
    //         case 2:
    //             actorTypeStr = "user";
    //             break;

    //         default:
    //             break;
    //     }

    
    @Override
    public void addActivityLog(AdminActivityLogDTO log) {
        createActivityLog(log);
    }
    
    @Override
    public ArrayList<AdminActivityLogDTO> getRecentActivities(int limit) {
        AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        return dao.getRecentActivities(limit);
    }
    
    @Override
    public ArrayList<AdminActivityLogDTO> getActivitiesByType(String activityType, int limit) {
    	AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        return dao.getActivitiesByType(activityType, limit);
    }
    
    @Override
    public ArrayList<AdminActivityLogDTO> getAllActivities(HashMap<String, Object> params) {
    	AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        return dao.getAllActivities(params);
    }
    
    @Override
    public int getTotalLogCount() {
    	AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        return dao.getTotalLogCount();
    }
    
    @Override
    public ArrayList<AdminActivityLogDTO> getAllActivities(AdminActivityLogCriteriaDTO cri) {
    	AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        return dao.getAllActivities(cri);
    }
    
    @Override
    public int getTotalLogCount(AdminActivityLogCriteriaDTO cri) {
    	AdminActivityLogDAO dao = sqlSession.getMapper(AdminActivityLogDAO.class);
        return dao.getTotalLogCount(cri);
    }
} 