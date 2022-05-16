package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4008Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * GS 칼텍스 BL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectGsctexBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectGsctexBl(param);
    }
    /***
     *  크레텍 책임 BL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectCretRsbtyBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectCretRsbtyBl(param);
    }
    /***
     *  GS 칼텍스 BL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendGsctexBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendGsctexBl(param);
    }
    /***
     *  크레텍 책임 BL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendCretRsbtyBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendCretRsbtyBl(param);
    }
    
    
    

}
