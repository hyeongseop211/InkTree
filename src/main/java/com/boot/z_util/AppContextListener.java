package com.boot.z_util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("AppContextListener reset");
        ConsoleCommandListener.start(); 
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("AppContextListener exit");
    }
}
