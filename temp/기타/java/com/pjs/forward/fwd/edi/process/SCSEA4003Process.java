package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4003Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LGE HBL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgEHblInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgEHblInfo(param);
    }
    /***
     * LGE HBL India 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgEHblInfoIndia(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgEHblInfoIndia(param);
        
    }
    /***
     * LGE 트럭 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgECarInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgECarInfo(param);
    }
    /***
     * LGE HBL전송 정보 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgEHblSendInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgEHblSendInfo(param);
    }
    
    /***
     * LLGEHBL전송 응답 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgEHblSendAns(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgEHblSendAns(param);
    }
    /***
     * LGE HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgEHbl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgEHbl(param);
    }
    /***
     * LGE HBL India 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgEHblIndia(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgEHblIndia(param);
    }
    /***
     * LGE HBL India 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgECarInfo(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgECarInfo(param);
    }

}
