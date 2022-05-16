package com.anchordata.webframework.base.common.config;

import org.apache.ibatis.javassist.tools.reflect.Sample;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix="spring")
public class ServerConfig {
	private String servers;
    private Sample obj;
}
