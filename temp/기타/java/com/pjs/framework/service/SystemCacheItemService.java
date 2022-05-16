package com.lxpantos.framework.service;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.lxpantos.framework.dao.CachedDao;
import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;

@Service
public class SystemCacheItemService {
    private static final Logger logger = LoggerFactory.getLogger(SystemCacheItemService.class);

    @Value("#{systemProperties['env']}")
    String env;

    @Resource(name = "mainDao")
    private CachedDao mainDao;

    @Resource(name = "redisMessageStoreDao")
    private RedisDao redisMessageStoreDao;

    @SuppressWarnings("unchecked")
    public void reloadCachedItems() {
        List<DataItem> list = mainDao.selectList("com.sysmsg.sysmsgmgnt.inqSysMsgListAll", new DataItem());
        for (DataItem item : Util.emptyIfNull(list)) {
            redisMessageStoreDao.getCommand().hset(item.getString("sysMsgId"), item.getString("msgLocaleCd"), item.getString("msgCont"));
        }

        list = mainDao.selectList("com.sysmsg.sysmsgmgnt.inqSysWordListAll", new DataItem());
        for (DataItem item : Util.emptyIfNull(list)) {
            redisMessageStoreDao.getCommand().hset(item.getString("sysMsgId"), item.getString("msgLocaleCd"), item.getString("msgCont"));
        }

        list = mainDao.selectList("com.system.selectInterfaceItemAll", new DataItem());
        for (DataItem item : Util.emptyIfNull(list)) {
            redisMessageStoreDao.getCommand().set(item.getString("ifId"), item.toJson());
        }
        
        list = mainDao.selectList("com.system.selectMenuProgramMappsAll", new DataItem());
        for (DataItem item : Util.emptyIfNull(list)) {
            redisMessageStoreDao.getCommand().set(item.getString("menuId"), item.toJson());
        }  
    }
}
