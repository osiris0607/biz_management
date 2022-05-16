package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4005Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LGD HBL 정보조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgdHblInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgdHblInfo(param);
    }
    /***
     * LGD HBL 전송 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgdHblSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgdHblSendInfo(param);
    }
    /***
     *  LGD 트럭 정보조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgdCarInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgdCarInfo(param);
    }
    /***
     *  LGD HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgdHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgdHbl(param);
    }
    
    
    
    

}
