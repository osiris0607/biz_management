package com.lxpantos.forwarding.fwd.edi.process;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lxpantos.forwarding.fwd.edi.service.FwdCustBlEdiRegService;
import com.lxpantos.framework.annotation.Process;
import com.lxpantos.framework.vo.DataItem;

@Process
public class SCSEA4004Process {
    
    @Autowired
    FwdCustBlEdiRegService fwdCustBlEdiRegService;
    
    /***
     * LGE HBL 조회
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    public DataItem selectLgEPreBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.selectLgEPreBl(param);
    }
    /***
     * LGE HBL 전송
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem sendLgEPreBl(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.sendLgEPreBl(param);
    }
    /***
     * LGEPreBL이미지저장
     * @param param
     * @param meta
     * @author 박종세
     * @return
     */
    @Transactional
    public DataItem saveLgEPreBlImg(DataItem param, DataItem meta) {
        return fwdCustBlEdiRegService.saveLgEPreBlImg(param);
    }
}
