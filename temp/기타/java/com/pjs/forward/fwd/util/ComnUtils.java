package com.lxpantos.forwarding.fwd.util;

import java.util.List;

import org.apache.commons.compress.utils.Lists;

public class ComnUtils {

    public static List<String> changeStringToList(String str) {
        List<String> rtnList = Lists.newArrayList();
         
        
        if (str != null) {
            String[] inArr = str.split(",");
            int arrSize = inArr.length;
            
            if (inArr != null && arrSize > 0) {
                for (int i = 0; i < arrSize; i++) {
                    if (null != inArr[i] && !"".equals(inArr[i])) {
                        rtnList.add(inArr[i].trim());
                    }
                }
            }
            return rtnList;
        }else {
            return null;
        }
        
    }
 

    
}
