package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4010Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * 서브원 이미지 수신 목록 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectServeoneImgRecvList(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectServeoneImgRecvList(param);
    }

}
