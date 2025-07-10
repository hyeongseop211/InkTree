package com.boot.user.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.user.dto.AdminActivityLogDTO;
import com.boot.user.service.AdminActivityLogService;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.AdminActivityLogCriteriaDTO;
import com.boot.z_util.AdminActivityTypeManager;
import com.boot.z_util.AdminActivityTypeManager.FilterOption;



@Controller
public class AdminActivityLogController {
    
    @Autowired
    private AdminActivityLogService adminActivityLogService;
    
    // 활동 로그 전체 보기 페이지
    @RequestMapping("/activity_log")
    public String viewActivityLog(Model model, 
                                 @RequestParam(defaultValue = "1") int pageNum,
                                 @RequestParam(defaultValue = "10") int amount,
                                 @RequestParam(required = false) String filter) {
        
        // 페이징 및 필터링을 위한 Criteria 객체 생성
        AdminActivityLogCriteriaDTO cri = new AdminActivityLogCriteriaDTO(pageNum, amount);
        
        // 필터 옵션 적용
        if(filter != null) {
            for(FilterOption option : AdminActivityTypeManager.getFilterOptions()) {
                if(option.getCode().equals(filter)) {
                    cri.setCategoryFilter(option.getCategoryFilter());
                    cri.setActorType(option.getActorFilter());
                    break;
                }
            }
        }
        
        // 활동 로그 목록 조회
        ArrayList<AdminActivityLogDTO> logList = adminActivityLogService.getAllActivities(cri);
        model.addAttribute("logList", logList);
        
        // 페이징 처리를 위한 총 로그 수 조회
        int totalLogs = adminActivityLogService.getTotalLogCount(cri);
        model.addAttribute("pageMaker", new PageDTO(totalLogs, pageNum, amount));
        
        // 필터 옵션을 모델에 추가
        model.addAttribute("filterOptions", AdminActivityTypeManager.getFilterOptions());
        model.addAttribute("criteria", cri);
        model.addAttribute("activityTypeManager", new AdminActivityTypeManager());
        
        return "admin/admin_activity_log";
    }
} 