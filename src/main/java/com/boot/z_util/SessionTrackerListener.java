package com.boot.z_util;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Optional;

public class SessionTrackerListener implements HttpSessionListener {
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        String ip = (String) se.getSession().getAttribute("clientIp");
        if (ip != null) {
            ConnectionTracker.removeIp(ip);
            System.out.println("session exit : " + ip);
        }
    }
}
