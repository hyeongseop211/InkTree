package com.boot.z_util;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class ConnectionTracker {
    private static final Set<String> connectedIps = Collections.synchronizedSet(new HashSet<>());

    public static void addIp(String ip) {
        connectedIps.add(ip);
    }

    public static void removeIp(String ip) {
        connectedIps.remove(ip);
    }

    public static void printConnections() {
        System.out.println("online IP (" + connectedIps.size() + "):");
        for (String ip : connectedIps) {
            System.out.println(" - " + ip);
        }
    }
}
