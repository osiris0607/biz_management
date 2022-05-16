package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4012Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LG상사수출 BL 조회 요청
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgiElecSalesInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgiElecSalesInfo(param);
    }
    /***
     * LG상사의 수출 BL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgiElecSalesInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgiElecSalesInfo(param);
    }
    
    
    

}
