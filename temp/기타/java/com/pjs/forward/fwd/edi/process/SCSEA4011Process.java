package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4011Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * 라인프렌즈 전송 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLfsSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLfsSendInfo(param);
    }
    /***
     * LGLS 전송 요청 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLglsReqSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLglsReqSendInfo(param);
    }
    /***
     * LGLS 전송 응답 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLglsResSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLglsResSendInfo(param);
    }
    /***
     * 라인프렌즈 HBL전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLfsHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLfsHbl(param);
    }
    
    
    

}
