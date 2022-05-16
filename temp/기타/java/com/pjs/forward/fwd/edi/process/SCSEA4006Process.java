package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4006Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LGD 수입 HBL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgdImpHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgdImpHbl(param);
    }
    /***
     * LGD 수입 HBL 전송/응답 정보조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgdImpHblSendResponseInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgdImpHblSendResponseInfo(param);
    }
    /***
     *  LGD 수입항공 HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgdImpAirHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgdImpAirHbl(param);
    }
    /***
     *  LGD 수입해상 HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgdImpSeaHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgdImpSeaHbl(param);
    }
    
    
    

}
