package com.boot.z_util;

import java.util.Scanner;


public class ConsoleCommandListener implements Runnable {

    @Override
    public void run() {
        try (Scanner scanner = new Scanner(System.in)) {
            while (true) {
                String command = scanner.nextLine().trim();

                if ("현접".equals(command)) {
                    ConnectionTracker.printConnections();
                } else {
                    System.out.println("not command" + command);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void start() {
        Thread consoleThread = new Thread(new ConsoleCommandListener());
        consoleThread.setDaemon(true);
        consoleThread.start();
    }
}
