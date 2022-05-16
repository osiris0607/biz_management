package com.lxpantos;


import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import devonboot.common.DevOnApplication;
import devonboot.common.annotation.DevOnBootApplication;

@DevOnBootApplication
public class ForwardingApplication extends SpringBootServletInitializer {
    
    public static void main(String[] args) {
        String env = System.getProperty("env");
        
        if (env == null) {
            env = "local";
            System.setProperty("env", env);
        }
        System.setProperty("GOOGLE_APPLICATION_CREDENTIALS", "C:\\Pantos_NFF\\workspace\\forwarding-service\\src\\main\\resources\\gcp\\pjt-pantos-nff-dev-2106-1-33de6ec7446e.json");
        System.setProperty("spring.config.name", "application_" + env);
        DevOnApplication.run(ForwardingApplication.class, args);
    }
    
}
