package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4002Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LGC HBL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgCHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgCHbl(param);
        
    }
    
    /***
     * LGC HBL 운임조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgCHblFrgh(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgCHblFrgh(param);
        
    }
    /***
     * LGC HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgCHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgCHbl(param);
        
    }
    
    

}
