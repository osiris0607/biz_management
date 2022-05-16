package com.lxpantos.system.config;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.LazyConnectionDataSourceProxy;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.lxpantos.framework.dao.BigQueryDao;
import com.lxpantos.framework.dao.CachedDao;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import devonframe.dataaccess.mybatis.factory.CommonDaoSqlSessionFactory;
import devonframe.dataaccess.mybatis.factory.CommonDaoSqlSessionFactoryBean;

@Configuration
@EnableTransactionManagement
public class DBMainConfig {
    private static final Logger logger = LoggerFactory.getLogger(DBMainConfig.class);

    @Primary
    @Bean("mainDataSourceProperties")
    @ConfigurationProperties(prefix = "spring.main.datasource")
    public DataSourceProperties dataSourceProperties() {
        DataSourceProperties properties = new DataSourceProperties();
        return properties;
    }
    
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource.hikari")
    public HikariConfig hikariConfig() {
        return new HikariConfig();
    }
    
    @Autowired
    HikariConfig cfg;
    
    @Bean(name = "mainDataSource")
    @Qualifier("mainDataSource")
    @Primary
    public DataSource dataSource(@Qualifier("mainDataSourceProperties") DataSourceProperties properties) {
//        return new LazyConnectionDataSourceProxy(properties.initializeDataSourceBuilder().build());
        cfg.setUsername(properties.getUsername());
        cfg.setPassword(properties.getPassword());
        cfg.setJdbcUrl(properties.getUrl());
        cfg.setDriverClassName(properties.getDriverClassName());
        cfg.setPoolName(properties.getName());
        return new LazyConnectionDataSourceProxy(new HikariDataSource(cfg));
    }

    @Bean(name = "mainSessionFactory")
    @Primary
    public CommonDaoSqlSessionFactory sqlSessionFactory(@Qualifier("mainDataSource") DataSource dataSource, ApplicationContext applicationContext) throws Exception {
        CommonDaoSqlSessionFactoryBean bean = new CommonDaoSqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        return (CommonDaoSqlSessionFactory) bean.getObject();
    }

    @Bean(name = "mainDao")
    @Primary
    public CachedDao dao() {
        return new CachedDao("mainSqlSession");
    }
    
    @Bean( name = "bigQueryDao") 
    public BigQueryDao bigQueryDao() {
        return new BigQueryDao();
    }
}
