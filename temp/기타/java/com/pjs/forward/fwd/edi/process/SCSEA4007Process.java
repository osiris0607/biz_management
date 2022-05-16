package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4007Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LGD 수입 HBL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgiExpBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgiExpBl(param);
    }
    /***
     *  LGD 수입항공 HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgiExpBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgiExpBl(param);
    }
    
    

}
