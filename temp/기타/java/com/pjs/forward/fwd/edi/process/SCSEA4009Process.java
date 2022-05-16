package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4009Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * 서브원 전송 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectServeoneSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectServeoneSendInfo(param);
    }
    /***
     * 서브원 전송 요청 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectServeoneReqSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectServeoneReqSendInfo(param);
    }
    /***
     * 서브원 전송 응답 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectServeoneResSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectServeoneResSendInfo(param);
    }
    /***
     * 서브원HBL전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendServeoneHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendServeoneHbl(param);
    }
    
    
    

}
