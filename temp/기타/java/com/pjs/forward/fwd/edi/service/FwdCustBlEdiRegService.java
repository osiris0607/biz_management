package com.lxpantos.forwarding.fwd.edi.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lxpantos.forwarding.fwd.common.service.FwdCommonService;
import com.lxpantos.forwarding.fwd.common.service.FwdKeygenService;
import com.lxpantos.forwarding.fwd.document.service.FwdBlComnMgntService;
import com.lxpantos.forwarding.fwd.util.FwdConstants;
import com.lxpantos.forwarding.sea.util.SeaDateUtils;
import com.lxpantos.framework.dao.CachedDao;
import com.lxpantos.framework.exception.BizException;
import com.lxpantos.framework.threadLocal.SessionThreadLocal;
import com.lxpantos.framework.vo.DataItem;

@Service
public class FwdCustBlEdiRegService {

    private static final Logger logger = LoggerFactory.getLogger(FwdCustBlEdiRegService.class);
    
    @Resource(name = "mainDao")
    private CachedDao mainDao;
    
    @Autowired
    FwdKeygenService fwdKeygenService;
    @Autowired
    FwdCommonService fwdCommonService;
    @Autowired
    FwdBlComnMgntService fwdBlComnMgntService;
    
    
    /**
     * LGCHBL조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgCHbl(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        logger.debug("#### srchDt:"+inData.toJson());
        // CORP_CD
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        String sqlString = "";
        if ( inData.getString("ptnrSprCd").equals("FHN")) {
            sqlString = "fwd.edi.fwdCstComIfMgnt.selectLgCHblFHN";
        } else {
            sqlString = "fwd.edi.fwdCstComIfMgnt.selectLgCHbl";
        }
        
        List<DataItem> outList = mainDao.selectList(sqlString, inData);
//        if ( outList == null || outList.size() == 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_hblList", outList);
        return resObj;
    }
    /**
     * LGCHBL운임조회 - LG화학, LG하우시스 HBL에 대한 운임정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgCHblFrgh(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgCHblFrgh", inData);
//        if ( outList == null || outList.size() == 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_frghList", outList);
        return resObj;
    }
    /**
     * LGCHBL운임조회 - LG화학, LG하우시스 HBL에 대한 운임정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgCHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        // 자료가 없을때 에러가 발생하여 추가 했습니다. 2021-11-18 유상인
        if ( inData != null) {
            for ( DataItem item : inData) {
                // session Data 저장
                item.append("userId", sessionUser.getString("userId"));
                item.append("rstrId", sessionUser.getString("userId"));
                item.append("updrId", sessionUser.getString("userId"));
                item.append("corpCd", sessionUser.getString("corpCd"));
                
                // IHBLMgr.전송가능거래처여부조회
                // 마감시 BL전송할 때 전송가능거래처 여부 체크하기 위해 추가
                item.append("cstSprCd", "LGC");
                DataItem sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", item);
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    // LG화학 전송 건 아닐 경우 LG하우시스로 다시 한번 조회
                    item.replace("cstSprCd", "LGH");
                    sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", item);
                }
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    item.replace("cstSprCd", "LGM");
                    sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", item);
                }
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    // LG하우시스 전송건도 아닐 경우 에러 발생시키지 않고 Skip
                    // [CSR ID:4042849] 2019.05.20 KEUNHEE.HAN 팜한농 조건 추가
                    item.replace("cstSprCd", "FHN");
                    sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", item);
                }
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    item.replace("cstSprCd", "LGES");
                    sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", item);
                }
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    // 팜한농 FHN 전송건도 아닐 경우 에러 발생시키지 않고 Skip
                    // [TODO] 실제 코드이다.. 나중에 복구한다...
                    continue;
                    
                    // [TODO] 아래의 2줄은 삭제한다.
//                    sendBizptnr = new DataItem();
//                    sendBizptnr.put("cstSprCd", "LGC");
                }
                
                // TODO suhan.youn01 환율 관련 처리 추가 확인 필요(초기 설계시 스킵처리) 1.환율이 0인지 체크 2.환율 TTM(전신환매매 기준율)으로 Update

                /* I고객사인터페이스관리Mgr.인터페이스ID채번 */
                DataItem ifIdKeygenCond = new DataItem();
                if ( "LGC".equals(sendBizptnr.getString("cstSprCd")) ) {
                    if ( sendBizptnr.getString("gerpSprCd") != null && !sendBizptnr.getString("gerpSprCd").isEmpty()
                            && sendBizptnr.getString("gerpSprCd").equals("GERP") ) {
                        ifIdKeygenCond.put("inIfId", "b2bFW1213");
                    } else {
                        ifIdKeygenCond.put("inIfId", "b2bFW1210");
                    }
                } else if ( "LGH".equals(sendBizptnr.getString("cstSprCd")) ) {
                    ifIdKeygenCond.put("inIfId", "b2bFW1220");
                } else if ( "LGM".equals(sendBizptnr.getString("cstSprCd")) ) {
                    ifIdKeygenCond.put("inIfId", "b2bFW1212");
                    // [CSR ID:4042849] 2019.05.20 KEUNHEE.HAN 팜한농 조건 추가
                } else if ( "FHN".equals(sendBizptnr.getString("cstSprCd")) ) {
                    ifIdKeygenCond.put("inIfId", "b2bFW1214");
                } else if ( "LGES".equals(sendBizptnr.getString("cstSprCd")) ) {
                    if (sendBizptnr.getString("gerpSprCd") != null && !sendBizptnr.getString("gerpSprCd").isEmpty()
                            && sendBizptnr.getString("gerpSprCd").equals("GERP") ) {
                        /* LGES BL 송신 해외 */
                        ifIdKeygenCond.put("inIfId", "b2bFW1216");
                    } else {
                        /* LGES BL 송신  */
                        ifIdKeygenCond.put("inIfId", "b2bFW1215");
                    }
                }
                ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
                ifIdKeygenCond.put("ifSndrId", "");
                ifIdKeygenCond.put("ifRcvrId", "");
                
                DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
                if (null == ifIdInfo || ifIdInfo.isEmpty() 
                        || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                        || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                        logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                        throw new BizException("ngff.fwd.creatFail", "Interface ID");
                }
                
                String ifId = ifIdInfo.getString("interfaceId");
                logger.debug("#### interfaceId : " + ifId );

                
                /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
                DataItem xmlMSGIdCrt = new DataItem();
                xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
                xmlMSGIdCrt.put("exctSprCd", "FW");
                xmlMSGIdCrt.put("keygenCd", "KLNET");
                xmlMSGIdCrt.put("keygenPrefix", "XPKC");
                xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
                
                DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
                if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                    || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                    throw new BizException("ngff.fwd.creatFail" , "KLNET-XPKC");
                }
                
                String xmlMsgId = xmlMsgIdInfo.getString("keyGenNo");
                logger.debug("#### xmlMsgId : " + xmlMsgId );
                
                /* I고객사인터페이스관리Mgr.LGC인터페이스테이블Cnt조회 */
                int ifCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgCIfTblCnt", item).getInt("cnt");
                
                /* I고객사인터페이스관리Mgr.LGC인터페이스테이블등록 */
                item.put("cnt", ifCnt); // 전송 횟수
                item.put("interfaceId", ifId); 
                if (null != sendBizptnr.getString("gerpSprCd") && !sendBizptnr.getString("gerpSprCd").isEmpty()
                        && "GERP".equals(sendBizptnr.getString("gerpSprCd"))) {
                    item.put("gerpSprCd", sendBizptnr.getString("gerpSprCd")); 
                }
                item.put("xmlMsgId", xmlMsgId); 

                int regCnt = 0;
                // FHN 인 경우
                if ( "FHN".equals(item.getString("ptnrSprCd")) ) {
                    // LGC LOG FILE을 생성하기 위한 Sequence 번호 추출 (FHN 인 경우)
                    DataItem sequenceInfo = new DataItem();
                    sequenceInfo.put("userId", sessionUser.getString("userId"));
                    sequenceInfo.put("exctSprCd", "FW");
                    sequenceInfo.put("keygenCd", "SQ_FW_INT560_02");
                    sequenceInfo.put("keygenPrefix", "CMBLMRPTS");
                    sequenceInfo.put("datePrefix", SeaDateUtils.getLocalDate() );
                    
                    String lgcFileSeq = fwdKeygenService.createFwdAutoNo(sequenceInfo).getString("keyGenNo");
                    item.put("lgcFileSeq", Integer.parseInt(lgcFileSeq));
                    
                    // LGC 인터페이스 테이블 등록할 데이터 추출
                    DataItem selectedValue = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgCIfTblFHNValue", item);
                    // LGC 인터페이스 테이블 등록
                    regCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgCIfTblFHN", selectedValue);
                }
                // FHN 아닌 경우
                else {
                    // LGC LOG FILE을 생성하기 위한 Sequence 번호 추출 (FHN 아닌 경우)
                    DataItem sequenceInfo = new DataItem();
                    sequenceInfo.put("userId", sessionUser.getString("userId"));
                    sequenceInfo.put("exctSprCd", "FW");
                    sequenceInfo.put("keygenCd", "SQ_FW_INT560_02");
                    sequenceInfo.put("keygenPrefix", "IFTMCS");
                    sequenceInfo.put("datePrefix", SeaDateUtils.getLocalDate() );
                    logger.debug("#### datePrefix : " + sequenceInfo.getString("datePrefix") );
                    
                    String lgcFileSeq = fwdKeygenService.createFwdAutoNo(sequenceInfo).getString("keyGenNo");
                    item.put("lgcFileSeq", Integer.parseInt(lgcFileSeq));
                    
                    // LGC 인터페이스 테이블 등록할 데이터 추출
                    DataItem selectedValue = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgCIfTblValue", item);
                    // LGC 인터페이스 테이블 등록
                    regCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgCIfTbl", selectedValue);
                }
                
                if (0 == regCnt) {
                    throw new BizException("ngff.com.save"); // 저장중 에러발생
                }
                
                
                /* HBL Goods 등록 */
                DataItem goodsCntInqVo = new DataItem();
                goodsCntInqVo.put("blId", item.getString("blId"));
                goodsCntInqVo.put("num", 5);

                if ("OC".equals(item.getString("exctSprCd"))) {
                    goodsCntInqVo.put("rmkSprCd", "DESC");
                } else if ("AR".equals(item.getString("exctSprCd"))) {
                    // goodsCntInqVo.setString("rmkSprCd", "DESC");
                    goodsCntInqVo.put("rmkSprCd", "GODS"); // 테스트를 위해 잠시 막음
                }

                int goodsContCnt = 0;
                DataItem result = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContCnt", goodsCntInqVo);
                if ( result != null && !result.isNull("contCnt") ) {
                    goodsContCnt = result.getInt("contCnt");
                }

                for (int j = 1; j <= goodsContCnt; j++) {
                    // HBLGoods등록
                    DataItem hblGoodsVo = new DataItem();
                    hblGoodsVo.put("jdx", j);
                    hblGoodsVo.put("blId", item.getString("blId")); // hbl Id
                    hblGoodsVo.put("interfaceId", ifId);
                    hblGoodsVo.put("xmlMsgId", xmlMsgId);
                    if ("OC".equals(item.getString("exctSprCd"))) {
                        hblGoodsVo.put("rmkSprCd", "DESC");
                    } else if ("AR".equals(item.getString("exctSprCd"))) {
                        hblGoodsVo.put("rmkSprCd", "GODS"); // 테스트를 위해 잠시 막음
                    }
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertHblGoods", hblGoodsVo);
                }
                
                /* HBLMark등록 등록 */
                DataItem markCntInqVo = new DataItem();
                markCntInqVo.put("blId", item.getString("blId"));
                markCntInqVo.put("num", 10);
                if ("OC".equals(item.getString("exctSprCd"))) {
                    markCntInqVo.put("rmkSprCd", "MARK");
                } else if ("AR".equals(item.getString("exctSprCd"))) {
                    markCntInqVo.put("rmkSprCd", "MARK");
                }

                // I통합SUB관리Mgr.통합양식내용 Cnt 조회
                int markContCnt = 0;
                result = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContCnt", markCntInqVo);
                if ( result != null && !result.isNull("contCnt") ) {
                    markContCnt = result.getInt("contCnt");
                }

                for (int j = 1; j <= markContCnt; j++) {
                    // I고객사인터페이스관리Mgr.HBLMark등록
                    DataItem hblMarkVo = new DataItem();
                    hblMarkVo.put("jdx", j);
                    hblMarkVo.put("blId", item.getString("blId")); // hbl Id
                    hblMarkVo.put("interfaceId", ifId);
                    hblMarkVo.put("xmlMsgId", xmlMsgId);
                    if ("OC".equals(item.getString("exctSprCd"))) {
                        hblMarkVo.put("rmkSprCd", "MARK");
                        // hblMarkVo.setString("rmkSprCd", "MKNO");
                    } else if ("AR".equals(item.getString("exctSprCd"))) {
                        hblMarkVo.put("rmkSprCd", "MARK");
                        // hblMarkVo.setString("rmkSprCd", "ACCT");
                    }
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertHblMark", hblMarkVo);
                }
                
                /* HBLCont등록 */
                if ("OC".equals(item.getString("exctSprCd"))) {
                    // I고객사인터페이스관리Mgr.HBLCont등록
                    DataItem hblContVo = new DataItem();
                    hblContVo.put("blId", item.getString("blId")); // hbl Id
                    hblContVo.put("interfaceId", ifId);
                    hblContVo.put("xmlMsgId", xmlMsgId);
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertHblCont", hblContVo);

                    // 마감시 BL전송할 때는 운임을 SUM하지 않고 Skip
                    if (!"AUTO".equals(item.getString("gubun"))) {
                        // I고객사인터페이스관리Mgr. LGC HBL 운임등록
                        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgCHblFrgh", hblContVo);
                        // I고객사인터페이스관리Mgr.LGC HBL 운임상세등록
                        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgCHblFrghDtl", hblContVo);
                    }
                }
                
                /* IHBLMgr.HBL화주 전송 여부 수정*/
                mainDao.update("fwd.document.fwdHbl.updateHblCustSendYn", item);
                
                
             // IBL공통관리Prc.BL진행상태동기화요청
                DataItem blStatHistInfoVo = new DataItem();
                blStatHistInfoVo.put("closYn", "Y");
                blStatHistInfoVo.put("corpCd", item.getString("corpCd"));
                blStatHistInfoVo.put("rstrId", item.getString("rstrId"));
                blStatHistInfoVo.put("statCd", "500");
                blStatHistInfoVo.put("blId", item.getString("blId"));
                blStatHistInfoVo.put("eoNo", item.getString("eoNo"));
                blStatHistInfoVo.put("soNo", item.getString("soNo"));
                blStatHistInfoVo.put("exctSprCd", item.getString("exctSprCd"));
                fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
                prcsCnt++;
            } // For End
        }
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     *  LGE HBL 정보조회 - LG전자 HBL에 대한 정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgEHblInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgEHblInfo", inData);
//        if ( outList == null || outList.size() <= 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     *  LGEHBL전송정보조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgEHblSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgEHblSendInfo", inData);
//        if ( outList == null || outList.size() <= 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_blSendList", outList);
        return resObj;
    }
    /**
     *  LGEHBL전송 응답 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgEHblSendAns(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgEHblSendAns", inData);
//        if ( outList == null || outList.size() <= 0  )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_blResponseList", outList);
        return resObj;
    }
    /**
     *  LGE HBL India 정보조회 - LG전자 HBL에 대한 정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgEHblInfoIndia(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgEHblInfoIndia", inData);
//        if ( outList == null || outList.size() <= 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     *  LGE 트럭 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgECarInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgECarInfo", inData);
//        if ( outList == null || outList.size() <= 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LGE HBL EDI 전송
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgEHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        // 자료가 없을때 에러가 발생하여 추가 했습니다. 2021-11-18 유상인
        if ( inData != null) {
            for ( DataItem blSend : inData) {
                // session Data 저장
                blSend.append("userId", sessionUser.getString("userId"));
                blSend.append("rstrId", sessionUser.getString("userId"));
                blSend.append("updrId", sessionUser.getString("userId"));
                blSend.append("corpCd", sessionUser.getString("corpCd"));
                
                // IHBLMgr.전송가능거래처여부조회
                // 마감시 BL전송할 때 전송가능거래처 여부 체크하기 위해 추가
                if (  (blSend.isNull("gubun") == false) && ("AUTO".equals(blSend.getString("gubun"))) ) {

                    blSend.append("cstSprCd", "LGE");

                    DataItem sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", blSend);
                    
                    if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                        // LG전자 전송 건이 아닐 경우 에러 발생시키지 않고 Skip
                        continue;
                    }
                }
                
                // I고객사인터페이스관리Mgr.전송가능여부조회
                DataItem blSendInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbYn", blSend);
                
                String srNo = blSendInfo.getString("srNo");
                String sendYn = blSendInfo.getString("sendYn");
                String hldsBlYn = blSendInfo.getString("hldsBlYn");
                String csmEoNo = blSendInfo.getString("csmEoNo");
                String eoNo = blSendInfo.getString("eoNo");
                String shprSendYn = blSendInfo.getString("shprSendYn");
                
                if (null == srNo || srNo.isEmpty()) {
                    throw new BizException("ngff.fwd.sendBkValid002"); // SR NO가 없어서 전송할 수 없습니다
                }
                
                if (!(null == csmEoNo || csmEoNo.isEmpty())) {
                    // SO에 CSM (고객제공용 BL)이 존재
                    if (!csmEoNo.equals(eoNo)) {
                        // 고객제공용 BL의 EO와 현재 전송하는 BL의 EO가 다르면 전송하지 않음
                        throw new BizException("ngff.fwd.sendValid015");
                    }
                }
                
                if (FwdConstants.FWD_EXT_SPR_CD_AIR.equals(blSendInfo.getString("exctSprCd"))) {
                    // I고객사인터페이스관리Mgr.항공전송기준조회
                    // 필요없는 기능인듯
                    // LData airSendStn = cstComIfMgntMgr.inqAirSendStn(blSend);
                    // shprSendYn = airSendStn.getString("shprSendYn");
                }
                
                if (FwdConstants.FWD_EXT_SPR_CD_SEA.equals(blSendInfo.getString("exctSprCd"))
                    || "RL".equals(blSendInfo.getString("exctSprCd"))) {
                    if (null == srNo || srNo.isEmpty()) {
                        throw new BizException("ngff.fwd.sendBkValid002"); // SR NO가 없어서 전송할 수 없습니다
                    }
                    // 본사가 아닌 경우 MBL 체크 제외
                    if ("A100".equals(blSend.getString("corpCd"))) {
                        if ("N".equals(sendYn)) {
                            throw new BizException("ngff.fwd.sendValid0011", blSend.getString("blNo")); // MBL NO 없이 전송할 수 없습니다
                        }
                        if ("Y".equals(hldsBlYn)) {
                            throw new BizException("ngff.fwd.sendValid002", blSend.getString("blNo"));
                        }
                    }
                }
                
                // I고객사인터페이스관리Mgr.LGE관계사코드조회
                DataItem afltCdCntVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEAfltCd", blSend);
                // 본사가 아닌 경우 afltCdCntVo EMPTY 면 ERROR
                if (!"A100".equals(blSend.getString("corpCd")) && (null == afltCdCntVo || afltCdCntVo.isEmpty())) {
                    throw new BizException("ngff.fwd.sendValid0096");
                }
                
                // I고객사인터페이스관리Mgr.인터페이스ID채번
                DataItem ifIdKeygenCond = new DataItem();
                String ifItemId = "";
                String cstKindCd = "LGE";
                if ( null != afltCdCntVo && false != afltCdCntVo.isEmpty() && false == afltCdCntVo.isNull("coAfltYn")  &&  null != afltCdCntVo.getString("coAfltYn") && "CN".equals(afltCdCntVo.getString("coAfltYn"))) {
                    ifIdKeygenCond.put("inIfId", "b2bFW1260"); // LGE(CIC)
                    ifItemId = "b2bFW1260";
                } else if ( null != afltCdCntVo && false != afltCdCntVo.isEmpty() && false == afltCdCntVo.isNull("coAfltYn") && null != afltCdCntVo.getString("coAfltYn") && "HLDS".equals(afltCdCntVo.getString("coAfltYn"))) {
                    ifIdKeygenCond.put("inIfId", "b2bFW1271"); // HLDS(CIC) 혜주
                    ifItemId = "b2bFW1271";
                    cstKindCd = "HLDS";
                } else {
                    ifIdKeygenCond.put("inIfId", "b2bFW1270"); // LGE(KIC)
                    ifItemId = "b2bFW1270";
                }
                ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
                ifIdKeygenCond.put("ifSndrId", "");
                ifIdKeygenCond.put("ifRcvrId", "");
                
                // AS-IS Soruce
                // String ifId = cstComIfMgntMgr.getIfId(ifIdKeygenCond).getString("outIfKey");
                // cstComIfMgntMgr.getIfId Query는 SP_CM_SET_EDI_MASTER_S 이다. 이를 구현함
                DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
                if (null == ifIdInfo || ifIdInfo.isEmpty() 
                        || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                        || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                        logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                        throw new BizException("ngff.fwd.creatFail", "Interface ID");
                }
                
                String ifId = ifIdInfo.getString("interfaceId");
                logger.debug("#### interfaceId : " + ifId );

                
                /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
                DataItem xmlMSGIdCrt = new DataItem();
                xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
                xmlMSGIdCrt.put("exctSprCd", "FW");
                xmlMSGIdCrt.put("keygenCd", "LGE_DOC_ID");
                xmlMSGIdCrt.put("keygenPrefix", "PKEHQ");
                xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
                
                DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
                if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                    || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                    throw new BizException("ngff.fwd.creatFail", "LGE_DOC_ID");
                }
                
                String xmlDocumentNo = xmlMsgIdInfo.getString("keyGenNo");
                logger.debug("#### xmlDocumentNo : " + xmlDocumentNo );
                
                
                // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
                DataItem fwIfContVo = new DataItem();
                fwIfContVo.put("blId", blSend.getString("blId"));
                fwIfContVo.put("taskSprCd", "EXP");
                fwIfContVo.put("ifId", ifId);
                fwIfContVo.put("ifSnglId", ifItemId);
                fwIfContVo.put("blNo", blSend.getString("blNo"));
                fwIfContVo.put("corpCd", blSend.getString("corpCd"));
                fwIfContVo.put("cstKindCd", cstKindCd);
                fwIfContVo.put("attrNm1", xmlDocumentNo);
                fwIfContVo.put("rstrId", blSend.getString("rstrId"));
                
                // 포워딩인터페이스상태등록
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
                
                // 포워딩인터페이스로그등록
                // BL_IF_LOG No을 채번한다.
                // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
                DataItem blIflog = new DataItem();
                blIflog.put("userId", sessionUser.getString("userId"));
                blIflog.put("exctSprCd", "FW");
                blIflog.put("keygenCd", "BL_IF_LOG");
                blIflog.put("keygenPrefix", "");
                blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
                DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
                if (null == blIflogInfo || blIflogInfo.isEmpty() 
                    || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(blIflogInfo.getString("rtnCd")) ) {
                    throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
                }
                String blIflogNo = blIflogInfo.getString("keyGenNo");
                logger.debug("#### blIflogNo : " + blIflogNo );
                
                fwIfContVo.put("logNo", blIflogNo);
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
                
                // I고객사인터페이스관리Mgr.LGE인터페이스테이블Cnt조회
                int ifTblCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEIfTblCnt", blSend).getInt("cnt");
                
                // I고객사인터페이스관리Mgr.LGE인터페이스테이블등록
                DataItem lgeIfTblRegVo = new DataItem();
                lgeIfTblRegVo.put("blId", blSend.getString("blId"));
                lgeIfTblRegVo.put("interfaceId", ifId);
                lgeIfTblRegVo.put("xmlDocumentNo", xmlDocumentNo);
                lgeIfTblRegVo.put("rstrId", blSend.getString("rstrId"));
                lgeIfTblRegVo.put("cnt", ifTblCnt);
                lgeIfTblRegVo.put("exctSprCd", blSendInfo.getString("exctSprCd"));
                if (null!=afltCdCntVo && false!=afltCdCntVo.isEmpty() && null!=afltCdCntVo.getString("coAfltYn") && "HLDS".equals(afltCdCntVo.getString("coAfltYn"))) {
                    // HLDS(혜주) 구분자
                    lgeIfTblRegVo.put("hldsYn", "Y");
                } else {
                    lgeIfTblRegVo.put("hldsYn", "N");
                }
                // sendType 값이 없는 경우 Query에서 에러 발생함. Exception 처리함.
                if ( blSend.isNull("sendType") || blSend.getString("sendType").isEmpty() ) {
                    lgeIfTblRegVo.put("sendType", "N");
                } else {
                    lgeIfTblRegVo.put("sendType", blSend.getString("sendType"));
                }
                
                DataItem LgEIfTblInsertedData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEIfTblData", lgeIfTblRegVo);
                
                int regCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEIfTbl", LgEIfTblInsertedData);
                if (regCnt < 1) {
                    throw new BizException("ngff.com.insert"); // 등록된 건이 0건이면 오류
                }

                
                if (FwdConstants.FWD_EXT_SPR_CD_AIR.equals(blSendInfo.getString("exctSprCd"))) {

                    DataItem frmContRowCntInqVo = new DataItem();
                    frmContRowCntInqVo.put("num", 5);
                    frmContRowCntInqVo.put("rmkSprCd", "GODS");
                    frmContRowCntInqVo.put("blId", blSend.getString("blId"));

                    // I통합SUB관리Mgr.통합양식내용RowCnt조회
                    
                    DataItem intgFrmContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", frmContRowCntInqVo);

                    if (null != intgFrmContCnt && false!=intgFrmContCnt.isEmpty() && 0 < intgFrmContCnt.size() && null != intgFrmContCnt.getString("vCnt")) {
                        if (0 < intgFrmContCnt.size()) {
                            for (int j = 1; j <= intgFrmContCnt.getInt("vCnt"); j++) {

                                String vDesc = intgFrmContCnt.getString("vDesc");
                                int jdx = 5 * (j - 1);

                                // I고객사인터페이스관리Mgr.LGEHBLDesc등록
                                DataItem lgEhblDescVo = new DataItem();
                                lgEhblDescVo.put("vDesc", vDesc);
                                lgEhblDescVo.put("interfaceId", ifId);
                                lgEhblDescVo.put("idx", j);
                                lgEhblDescVo.put("jdx", jdx);
                                lgEhblDescVo.put("rstrId", blSend.getString("rstrId"));
                                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblDesc", lgEhblDescVo);
                            }
                        } 
                    }
                    

                    // I통합SUB관리Mgr.통합양식내용RowCnt조회(mark)
                    DataItem markContRowCntInqVo = new DataItem();
                    markContRowCntInqVo.put("num", 10);
                    markContRowCntInqVo.put("rmkSprCd", "MARK");
                    markContRowCntInqVo.put("blId", blSend.getString("blId"));
                    DataItem markContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", markContRowCntInqVo);

                    if (null != markContCnt && false!=markContCnt.isEmpty() && 0 < markContCnt.size() && null != markContCnt.getString("vCnt") ) {
                        if (0 < markContCnt.size()) {
                            for (int j = 1; j <= markContCnt.getInt("vCnt"); j++) {

                                String vDesc = markContCnt.getString("vDesc");
                                int jdx = 5 * (j - 1);

                                // I고객사인터페이스관리Mgr.LGEHBLMark등록
                                DataItem lgEhblMarkVo = new DataItem();
                                lgEhblMarkVo.put("vDesc", vDesc);
                                lgEhblMarkVo.put("interfaceId", ifId);
                                lgEhblMarkVo.put("idx", j);
                                lgEhblMarkVo.put("jdx", jdx);
                                lgEhblMarkVo.put("rstrId", blSend.getString("rstrId"));
                                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblMark", lgEhblMarkVo);
                            }
                        }
                    }
                    
                    

                } else if (FwdConstants.FWD_EXT_SPR_CD_SEA.equals(blSendInfo.getString("exctSprCd"))
                        || "RL".equals(blSendInfo.getString("exctSprCd"))) {

                    DataItem frmContRowCntInqVo = new DataItem();
                    frmContRowCntInqVo.put("num", 5);
                    frmContRowCntInqVo.put("rmkSprCd", "DESC");
                    frmContRowCntInqVo.put("blId", blSend.getString("blId"));

                    // I통합SUB관리Mgr.통합양식내용RowCnt조회
                    DataItem intgFrmContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", frmContRowCntInqVo);

                    if (null != intgFrmContCnt && false!=intgFrmContCnt.isEmpty() && 0 < intgFrmContCnt.size() && null != intgFrmContCnt.getString("vCnt")) {
                        for (int j = 1; j <= intgFrmContCnt.getInt("vCnt"); j++) {

                            String vDesc = "";
                            if ( null != intgFrmContCnt.getString("vDesc") ) {
                                vDesc = intgFrmContCnt.getString("vDesc");
                            } 
                            int jdx = 5 * (j - 1);

                            // I고객사인터페이스관리Mgr.LGEHBLDesc등록
                            DataItem lgEhblDescVo = new DataItem();
                            lgEhblDescVo.put("vDesc", vDesc);
                            lgEhblDescVo.put("interfaceId", ifId);
                            lgEhblDescVo.put("idx", j);
                            lgEhblDescVo.put("jdx", jdx);
                            lgEhblDescVo.put("rstrId", blSend.getString("rstrId"));
                            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblDesc", lgEhblDescVo);
                        }
                    }

                    // I통합SUB관리Mgr.통합양식내용RowCnt조회(mark)
                    DataItem markContRowCntInqVo = new DataItem();
                    markContRowCntInqVo.put("num", 10);
                    markContRowCntInqVo.put("rmkSprCd", "MARK");
                    markContRowCntInqVo.put("blId", blSend.getString("blId"));
                    DataItem markContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", markContRowCntInqVo);

                    if (null != markContCnt && false!=markContCnt.isEmpty() && 0 < markContCnt.size() && null != markContCnt.getString("vCnt") ) {
                        for (int j = 1; j <= markContCnt.getInt("vCnt"); j++) {

                            String vDesc = "";
                            if ( null != markContCnt.getString("vDesc") ) {
                                vDesc = markContCnt.getString("vDesc");
                            } 
                            int jdx = 10 * (j - 1);

                            // I고객사인터페이스관리Mgr.LGEHBLMark등록
                            DataItem lgEhblMarkVo = new DataItem();
                            lgEhblMarkVo.put("vDesc", vDesc);
                            lgEhblMarkVo.put("interfaceId", ifId);
                            lgEhblMarkVo.put("idx", j);
                            lgEhblMarkVo.put("jdx", jdx);
                            lgEhblMarkVo.put("rstrId", blSend.getString("rstrId"));
                            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblMark", lgEhblMarkVo);
                        }
                    }
                }
                
                // I고객사인터페이스관리Mgr.LGEHBL컨테이너등록
                DataItem lgeHblCntrRegVo = new DataItem();
                lgeHblCntrRegVo.put("interfaceId", ifId);
                lgeHblCntrRegVo.put("blId", blSend.getString("blId"));
                lgeHblCntrRegVo.put("rstrId", blSend.getString("rstrId"));

                if ("C".equals(blSend.getString("corpCd").substring(0, 1))) {
                    // 아주의 경우
                    if (FwdConstants.FWD_EXT_SPR_CD_SEA.equals(blSendInfo.getString("exctSprCd"))
                            || "RL".equals(blSendInfo.getString("exctSprCd"))) {

                        if ("F".equals(blSendInfo.getString("ladgTypeCd"))) {
                            DataItem cntrCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEHblCntrCnt", lgeHblCntrRegVo);
                            if (cntrCnt.getInt("cntrQty") == 0) {
                                throw new BizException("ngff.fwd.sendValid0141", blSend.getString("blNo"));
                            }
                        }
                        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblCntr", lgeHblCntrRegVo);
                    }
                } else {
                    // 아주 제외 법인
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblCntr", lgeHblCntrRegVo);
                }
                
                /* IHBLMgr.HBL화주 전송 여부 수정*/
                mainDao.update("fwd.document.fwdHbl.updateHblCustSendYn", blSend);
                
                if (!FwdConstants.FWD_EXT_SPR_CD_RAIL.equals(blSendInfo.getString("exctSprCd"))) { // 철송은 동기화 요청 하지 않음
                 // IBL공통관리Prc.BL진행상태동기화요청
                    DataItem blStatHistInfoVo = new DataItem();
                    blStatHistInfoVo.put("closYn", "Y");
                    blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
                    blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
                    blStatHistInfoVo.put("statCd", "500");
                    blStatHistInfoVo.put("blId", blSend.getString("blId"));
                    blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
                    blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
                    blStatHistInfoVo.put("exctSprCd", blSend.getString("exctSprCd"));
                    fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
                }
                
                prcsCnt++;
            } // For End
        }
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    
    
    /**
     * LGE HBL EDI 전송(인도) - LG전자 수출 HBL을 전송하는 오퍼레이션
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgEHblIndia(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            // IHBLMgr.전송가능거래처여부조회
            // 마감시 BL전송할 때 전송가능거래처 여부 체크하기 위해 추가
            if (  (blSend.isNull("gubun") == false) && ("AUTO".equals(blSend.getString("gubun"))) ) {

                blSend.append("cstSprCd", "LGE");

                DataItem sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", blSend);
                
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    // LG전자 전송 건이 아닐 경우 에러 발생시키지 않고 Skip
                    continue;
                }
            }
            
            // I고객사인터페이스관리Mgr.전송가능여부조회
            DataItem blSendInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbYn", blSend);
            
            String srNo = blSendInfo.getString("srNo");
            String sendYn = blSendInfo.getString("sendYn");
            String hldsBlYn = blSendInfo.getString("hldsBlYn");
            String csmEoNo = blSendInfo.getString("csmEoNo");
            String eoNo = blSendInfo.getString("eoNo");
            String shprSendYn = blSendInfo.getString("shprSendYn");
            
            if (null == srNo || srNo.isEmpty()) {
                throw new BizException("ngff.fwd.sendBkValid002"); // SR NO가 없어서 전송할 수 없습니다
            }
            
            if (!(null == csmEoNo || csmEoNo.isEmpty())) {
                // SO에 CSM (고객제공용 BL)이 존재
                if (!csmEoNo.equals(eoNo)) {
                    // 고객제공용 BL의 EO와 현재 전송하는 BL의 EO가 다르면 전송하지 않음
                    throw new BizException("ngff.fwd.sendValid015");
                }
            }
            
            if (FwdConstants.FWD_EXT_SPR_CD_AIR.equals(blSendInfo.getString("exctSprCd"))) {
                // I고객사인터페이스관리Mgr.항공전송기준조회
                // 필요없는 기능인듯
                // LData airSendStn = cstComIfMgntMgr.inqAirSendStn(blSend);
                // shprSendYn = airSendStn.getString("shprSendYn");
            }
            
            if (FwdConstants.FWD_EXT_SPR_CD_SEA.equals(blSendInfo.getString("exctSprCd"))
                || "RL".equals(blSendInfo.getString("exctSprCd"))) {
                if (null == srNo || srNo.isEmpty()) {
                    throw new BizException("ngff.fwd.sendBkValid002"); // SR NO가 없어서 전송할 수 없습니다
                }
                // 본사가 아닌 경우 MBL 체크 제외
                if ("A100".equals(blSend.getString("corpCd"))) {
                    if ("N".equals(sendYn)) {
                        throw new BizException("ngff.fwd.sendValid0011", blSend.getString("blNo")); // MBL NO 없이 전송할 수 없습니다
                    }
                    if ("Y".equals(hldsBlYn)) {
                        throw new BizException("ngff.fwd.sendValid002", blSend.getString("blNo"));
                    }
                }
            }
            
            // I고객사인터페이스관리Mgr.LGE관계사코드조회
            DataItem afltCdCntVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEAfltCd", blSend);
            // 본사가 아닌 경우 afltCdCntVo EMPTY 면 ERROR
            if (!"A100".equals(blSend.getString("corpCd")) && (null == afltCdCntVo || afltCdCntVo.isEmpty())) {
                throw new BizException("ngff.fwd.sendValid0096");
            }
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            String ifItemId = "";
            String cstKindCd = "LGE";
            if ( null != afltCdCntVo && false != afltCdCntVo.isEmpty() && false == afltCdCntVo.isNull("coAfltYn")  &&  null != afltCdCntVo.getString("coAfltYn") && "CN".equals(afltCdCntVo.getString("coAfltYn"))) {
                ifIdKeygenCond.put("inIfId", "b2bFW1260"); // LGE(CIC)
                ifItemId = "b2bFW1260";
            } else if ( null != afltCdCntVo && false != afltCdCntVo.isEmpty() && false == afltCdCntVo.isNull("coAfltYn") && null != afltCdCntVo.getString("coAfltYn") && "HLDS".equals(afltCdCntVo.getString("coAfltYn"))) {
                ifIdKeygenCond.put("inIfId", "b2bFW1271"); // HLDS(CIC) 혜주
                ifItemId = "b2bFW1271";
                cstKindCd = "HLDS";
            } else {
                ifIdKeygenCond.put("inIfId", "b2bFW1270"); // LGE(KIC)
                ifItemId = "b2bFW1270";
            }
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            
            // AS-IS Soruce
            // String ifId = cstComIfMgntMgr.getIfId(ifIdKeygenCond).getString("outIfKey");
            // cstComIfMgntMgr.getIfId Query는 SP_CM_SET_EDI_MASTER_S 이다. 이를 구현함
            DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifIdInfo || ifIdInfo.isEmpty() 
                    || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            String ifId = ifIdInfo.getString("interfaceId");
            logger.debug("#### interfaceId : " + ifId );

            
            /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
            DataItem xmlMSGIdCrt = new DataItem();
            xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
            xmlMSGIdCrt.put("exctSprCd", "FW");
            xmlMSGIdCrt.put("keygenCd", "LGE_DOC_ID");
            xmlMSGIdCrt.put("keygenPrefix", "PKEHQ");
            xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
            
            DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
            if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "LGE_DOC_ID");
            }
            
            String xmlDocumentNo = xmlMsgIdInfo.getString("keyGenNo");
            logger.debug("#### xmlDocumentNo : " + xmlDocumentNo );
            
            
            // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
            DataItem fwIfContVo = new DataItem();
            fwIfContVo.put("blId", blSend.getString("blId"));
            fwIfContVo.put("taskSprCd", "EXP");
            fwIfContVo.put("ifId", ifId);
            fwIfContVo.put("ifSnglId", ifItemId);
            fwIfContVo.put("blNo", blSend.getString("blNo"));
            fwIfContVo.put("corpCd", blSend.getString("corpCd"));
            fwIfContVo.put("cstKindCd", cstKindCd);
            fwIfContVo.put("attrNm1", xmlDocumentNo);
            fwIfContVo.put("rstrId", blSend.getString("rstrId"));
            
            // 포워딩인터페이스상태등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
            
            // 포워딩인터페이스로그등록
            // BL_IF_LOG No을 채번한다.
            // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
            DataItem blIflog = new DataItem();
            blIflog.put("userId", sessionUser.getString("userId"));
            blIflog.put("exctSprCd", "FW");
            blIflog.put("keygenCd", "BL_IF_LOG");
            blIflog.put("keygenPrefix", "");
            blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
            DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
            if (null == blIflogInfo || blIflogInfo.isEmpty() 
                || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
                || "E".equals(blIflogInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
            }
            String blIflogNo = blIflogInfo.getString("keyGenNo");
            logger.debug("#### blIflogNo : " + blIflogNo );
            
            fwIfContVo.put("logNo", blIflogNo);
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
            
            // I고객사인터페이스관리Mgr.LGE인터페이스테이블Cnt조회
            int ifTblCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEIfTblCnt", blSend).getInt("cnt");
            
            // I고객사인터페이스관리Mgr.LGE인터페이스테이블등록
            DataItem lgeIfTblRegVo = new DataItem();
            lgeIfTblRegVo.put("blId", blSend.getString("blId"));
            lgeIfTblRegVo.put("interfaceId", ifId);
            lgeIfTblRegVo.put("xmlDocumentNo", xmlDocumentNo);
            lgeIfTblRegVo.put("rstrId", blSend.getString("rstrId"));
            lgeIfTblRegVo.put("cnt", ifTblCnt);
            lgeIfTblRegVo.put("exctSprCd", blSendInfo.getString("exctSprCd"));
            if (null!=afltCdCntVo && false!=afltCdCntVo.isEmpty() && null!=afltCdCntVo.getString("coAfltYn") && "HLDS".equals(afltCdCntVo.getString("coAfltYn"))) {
                // HLDS(혜주) 구분자
                lgeIfTblRegVo.put("hldsYn", "Y");
            } else {
                lgeIfTblRegVo.put("hldsYn", "N");
            }
            // sendType 값이 없는 경우 Query에서 에러 발생함. Exception 처리함.
            if ( blSend.isNull("sendType") || blSend.getString("sendType").isEmpty() ) {
                lgeIfTblRegVo.put("sendType", "N");
            } else {
                lgeIfTblRegVo.put("sendType", blSend.getString("sendType"));
            }
            
            DataItem LgEIfTblInsertedDataIndia = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEIfTblDataIndia", lgeIfTblRegVo);
            
            int regCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEIfTblIndia", LgEIfTblInsertedDataIndia);
            if (regCnt < 1) {
                throw new BizException("ngff.com.insert"); // 등록된 건이 0건이면 오류
            }

            
            if (FwdConstants.FWD_EXT_SPR_CD_AIR.equals(blSendInfo.getString("exctSprCd"))) {

                DataItem frmContRowCntInqVo = new DataItem();
                frmContRowCntInqVo.put("num", 5);
                frmContRowCntInqVo.put("rmkSprCd", "GODS");
                frmContRowCntInqVo.put("blId", blSend.getString("blId"));

                // I통합SUB관리Mgr.통합양식내용RowCnt조회
                
                DataItem intgFrmContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", frmContRowCntInqVo);
                if (null != intgFrmContCnt && false!=intgFrmContCnt.isEmpty() && 0 < intgFrmContCnt.size() && null != intgFrmContCnt.getString("vCnt")) {
                    if (0 < intgFrmContCnt.size()) {
                        for (int j = 1; j <= intgFrmContCnt.getInt("vCnt"); j++) {

                            String vDesc = intgFrmContCnt.getString("vDesc");
                            int jdx = 5 * (j - 1);

                            // I고객사인터페이스관리Mgr.LGEHBLDesc등록
                            DataItem lgEhblDescVo = new DataItem();
                            lgEhblDescVo.put("vDesc", vDesc);
                            lgEhblDescVo.put("interfaceId", ifId);
                            lgEhblDescVo.put("idx", j);
                            lgEhblDescVo.put("jdx", jdx);
                            lgEhblDescVo.put("rstrId", blSend.getString("rstrId"));
                            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblDesc", lgEhblDescVo);
                        }
                    }
                }
                

                // I통합SUB관리Mgr.통합양식내용RowCnt조회(mark)
                DataItem markContRowCntInqVo = new DataItem();
                markContRowCntInqVo.put("num", 10);
                markContRowCntInqVo.put("rmkSprCd", "MARK");
                markContRowCntInqVo.put("blId", blSend.getString("blId"));
                DataItem markContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", markContRowCntInqVo);

                
                if (null != markContCnt && false!=markContCnt.isEmpty() && 0 < markContCnt.size() && null != markContCnt.getString("vCnt") ) {
                    if (0 < markContCnt.size()) {
                        for (int j = 1; j <= markContCnt.getInt("vCnt"); j++) {

                            String vDesc = markContCnt.getString("vDesc");
                            int jdx = 5 * (j - 1);

                            // I고객사인터페이스관리Mgr.LGEHBLMark등록
                            DataItem lgEhblMarkVo = new DataItem();
                            lgEhblMarkVo.put("vDesc", vDesc);
                            lgEhblMarkVo.put("interfaceId", ifId);
                            lgEhblMarkVo.put("idx", j);
                            lgEhblMarkVo.put("jdx", jdx);
                            lgEhblMarkVo.put("rstrId", blSend.getString("rstrId"));
                            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblMark", lgEhblMarkVo);
                        }
                    } 
                }
            } else if (FwdConstants.FWD_EXT_SPR_CD_SEA.equals(blSendInfo.getString("exctSprCd"))
                    || "RL".equals(blSendInfo.getString("exctSprCd"))) {

                DataItem frmContRowCntInqVo = new DataItem();
                frmContRowCntInqVo.put("num", 5);
                frmContRowCntInqVo.put("rmkSprCd", "DESC");
                frmContRowCntInqVo.put("blId", blSend.getString("blId"));

                // I통합SUB관리Mgr.통합양식내용RowCnt조회
                DataItem intgFrmContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", frmContRowCntInqVo);

                if (null != intgFrmContCnt && false!=intgFrmContCnt.isEmpty() && 0 < intgFrmContCnt.size() && null != intgFrmContCnt.getString("vCnt")) {
                    for (int j = 1; j <= intgFrmContCnt.getInt("vCnt"); j++) {

                        String vDesc = "";
                        if ( null != intgFrmContCnt.getString("vDesc") ) {
                            vDesc = intgFrmContCnt.getString("vDesc");
                        } 
                        int jdx = 5 * (j - 1);

                        // I고객사인터페이스관리Mgr.LGEHBLDesc등록
                        DataItem lgEhblDescVo = new DataItem();
                        lgEhblDescVo.put("vDesc", vDesc);
                        lgEhblDescVo.put("interfaceId", ifId);
                        lgEhblDescVo.put("idx", j);
                        lgEhblDescVo.put("jdx", jdx);
                        lgEhblDescVo.put("rstrId", blSend.getString("rstrId"));
                        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblDesc", lgEhblDescVo);
                    }
                }

                // I통합SUB관리Mgr.통합양식내용RowCnt조회(mark)
                DataItem markContRowCntInqVo = new DataItem();
                markContRowCntInqVo.put("num", 10);
                markContRowCntInqVo.put("rmkSprCd", "MARK");
                markContRowCntInqVo.put("blId", blSend.getString("blId"));
                DataItem markContCnt = mainDao.select("fwd.document.fwdIntgSubMgnt.selectIntgFrmContRowCnt", markContRowCntInqVo);

                if (null != markContCnt && false!=markContCnt.isEmpty() && 0 < markContCnt.size() && null != markContCnt.getString("vCnt") ) {
                    for (int j = 1; j <= markContCnt.getInt("vCnt"); j++) {

                        String vDesc = "";
                        if ( null != markContCnt.getString("vDesc") ) {
                            vDesc = markContCnt.getString("vDesc");
                        } 
                        int jdx = 10 * (j - 1);

                        // I고객사인터페이스관리Mgr.LGEHBLMark등록
                        DataItem lgEhblMarkVo = new DataItem();
                        lgEhblMarkVo.put("vDesc", vDesc);
                        lgEhblMarkVo.put("interfaceId", ifId);
                        lgEhblMarkVo.put("idx", j);
                        lgEhblMarkVo.put("jdx", jdx);
                        lgEhblMarkVo.put("rstrId", blSend.getString("rstrId"));
                        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblMark", lgEhblMarkVo);
                    }
                }
            }
            
            // I고객사인터페이스관리Mgr.LGEHBL컨테이너등록
            DataItem lgeHblCntrRegVo = new DataItem();
            lgeHblCntrRegVo.put("interfaceId", ifId);
            lgeHblCntrRegVo.put("blId", blSend.getString("blId"));
            lgeHblCntrRegVo.put("rstrId", blSend.getString("rstrId"));
            lgeHblCntrRegVo.put("srNo", blSend.getString("srNo"));

            if ("C".equals(blSend.getString("corpCd").substring(0, 1))) {
                // 아주의 경우
                if (FwdConstants.FWD_EXT_SPR_CD_SEA.equals(blSendInfo.getString("exctSprCd"))
                        || "RL".equals(blSendInfo.getString("exctSprCd"))) {

                    if ("F".equals(blSendInfo.getString("ladgTypeCd"))) {
                        DataItem cntrCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEHblCntrCntIndia", lgeHblCntrRegVo);
                        if (cntrCnt.getInt("cntrQty") == 0) {
                            throw new BizException("ngff.fwd.sendValid0141", blSend.getString("blNo"));
                        }
                    }
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblCntrIndia", lgeHblCntrRegVo);
                }
            } else {
                // 아주 제외 법인
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEHblCntrIndia", lgeHblCntrRegVo);
            }
            
            /* IHBLMgr.HBL화주 전송 여부 수정*/
            mainDao.update("fwd.document.fwdHbl.updateHblCustSendYn", blSend);
            
            if (!FwdConstants.FWD_EXT_SPR_CD_RAIL.equals(blSendInfo.getString("exctSprCd"))) { // 철송은 동기화 요청 하지 않음
             // IBL공통관리Prc.BL진행상태동기화요청
                DataItem blStatHistInfoVo = new DataItem();
                blStatHistInfoVo.put("closYn", "Y");
                blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
                blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
                blStatHistInfoVo.put("statCd", "500");
                blStatHistInfoVo.put("blId", blSend.getString("blId"));
                blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
                blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
                fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            }
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * LGE 트럭 정보 전송 - SO와 CO를 참조해 LG전자 수출 트럭정보를 전송하는 오퍼레이션
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgECarInfo(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blData : inData) {
            // session Data 저장
            blData.append("userId", sessionUser.getString("userId"));
            blData.append("rstrId", sessionUser.getString("userId"));
            blData.append("updrId", sessionUser.getString("userId"));
            blData.append("corpCd", sessionUser.getString("corpCd"));
            
            if (null == blData.getString("blNo") || blData.getString("blNo").isEmpty()) {
                throw new BizException("ngff.com.required", blData.getString("blNo"));
            }
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            String ifItemId = "";
            String cstKindCd = "LGE";
            if ("C600".equals(blData.getString("corpCd"))) {
                ifIdKeygenCond.put("inIfId", "b2bFW1270"); // LGE(CIC)
            } else {
                ifIdKeygenCond.put("inIfId", "b2bFW1260"); // LGE(CIC)
            }
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            
            // AS-IS Soruce
            // String ifId = cstComIfMgntMgr.getIfId(ifIdKeygenCond).getString("outIfKey");
            // cstComIfMgntMgr.getIfId Query는 SP_CM_SET_EDI_MASTER_S 이다. 이를 구현함
            DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifIdInfo || ifIdInfo.isEmpty() 
                    || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            String ifId = ifIdInfo.getString("interfaceId");
            logger.debug("#### interfaceId : " + ifId );

            
            /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
            DataItem xmlMSGIdCrt = new DataItem();
            xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
            xmlMSGIdCrt.put("exctSprCd", "FW");
            xmlMSGIdCrt.put("keygenCd", "LGE_DOC_ID");
            xmlMSGIdCrt.put("keygenPrefix", "PKEHQ");
            xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
            
            DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
            if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "LGE_DOC_ID");
            }
            
            String xmlDocumentNo = xmlMsgIdInfo.getString("keyGenNo");
            logger.debug("#### xmlDocumentNo : " + xmlDocumentNo );
            
            // I고객사인터페이스관리Mgr.LGE인터페이스테이블Cnt조회
            int ifTblCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgECarIfTblCnt", blData).getInt("cnt");
            
            // I고객사인터페이스관리Mgr.LGE인터페이스테이블등록
            DataItem lgeIfTblRegVo = new DataItem();
            lgeIfTblRegVo.put("blId", blData.getString("blId"));
            lgeIfTblRegVo.put("interfaceId", ifId);
            lgeIfTblRegVo.put("xmlDocumentNo", xmlDocumentNo);
            lgeIfTblRegVo.put("rstrId", blData.getString("rstrId"));
            lgeIfTblRegVo.put("cnt", ifTblCnt);
            lgeIfTblRegVo.put("corpCd", blData.getString("corpCd"));
            
            DataItem LgECarIfTblData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgECarIfTblData", lgeIfTblRegVo);
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgECarIfTbl", LgECarIfTblData);
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * LGE PreBL 조회 - LGE PreBL 정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgEPreBl(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        logger.debug("#### srchDt:"+inData.toJson());
        
        if (null != inData.getString("blNo")) {
            String[] blNoList = inData.getString("blNo").split(",");
            List<String> blNoList2 = new ArrayList<String>();

            if (blNoList != null && blNoList.length > 0) {
                for (int i = 0; i < blNoList.length; i++) {
                    if (null != blNoList[i] && !blNoList[i].equals("")) {
                        blNoList2.add(blNoList[i]);
                    }
                }
            }
            if (blNoList2.size() > 0) {
                inData.put("blNoList", blNoList2);
            } else {
                inData.put("blNo", null);
            }
        }
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgEPreBl", inData);
//        if ( outList == null || outList.size() == 0 )
//        {
//            throw new BizException("ngff.fwd.noDataFound");
//        }
        
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LGE Pre BL 전송 - LG전자 PreBL을 전송하는 오퍼레이션
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgEPreBl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blData : inData) {
            // session Data 저장
            blData.append("userId", sessionUser.getString("userId"));
            blData.append("rstrId", sessionUser.getString("userId"));
            blData.append("updrId", sessionUser.getString("userId"));
            blData.append("corpCd", sessionUser.getString("corpCd"));
            
            
            DataItem blSend = blData;
            String attachIncludeYn = "N";

         // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW1340");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            
            // AS-IS Soruce
            // String ifId = cstComIfMgntMgr.getIfId(ifIdKeygenCond).getString("outIfKey");
            // cstComIfMgntMgr.getIfId Query는 SP_CM_SET_EDI_MASTER_S 이다. 이를 구현함
            DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifIdInfo || ifIdInfo.isEmpty() 
                    || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            String ifId = ifIdInfo.getString("interfaceId");
            logger.debug("#### interfaceId : " + ifId );

            
            /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
            DataItem xmlMSGIdCrt = new DataItem();
            xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
            xmlMSGIdCrt.put("exctSprCd", "FW");
            xmlMSGIdCrt.put("keygenCd", "LGE_DOC_ID");
            xmlMSGIdCrt.put("keygenPrefix", "PKEHQ");
            xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
            DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
            if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "LGE_DOC_ID");
            }
            String docId = xmlMsgIdInfo.getString("keyGenNo");
            logger.debug("#### xmlDocumentNo : " + docId );
            
            
            // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
            DataItem fwIfContVo = new DataItem();
            fwIfContVo.put("blId", blSend.getString("blId"));
            fwIfContVo.put("taskSprCd", "IMP");
            fwIfContVo.put("ifId", ifId);
            fwIfContVo.put("ifSnglId", "b2bFW1340");
            fwIfContVo.put("blNo", blSend.getString("blNo"));
            fwIfContVo.put("corpCd", blSend.getString("corpCd"));
            fwIfContVo.put("cstKindCd", "LGE");
            fwIfContVo.put("attrNm1", docId);
            fwIfContVo.put("rstrId", blSend.getString("rstrId"));
            // 포워딩인터페이스상태등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
            
            // 포워딩인터페이스로그등록
            // BL_IF_LOG No을 채번한다.
            // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
            DataItem blIflog = new DataItem();
            blIflog.put("userId", sessionUser.getString("userId"));
            blIflog.put("exctSprCd", "FW");
            blIflog.put("keygenCd", "BL_IF_LOG");
            blIflog.put("keygenPrefix", "");
            blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
            DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
            if (null == blIflogInfo || blIflogInfo.isEmpty() 
                || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
                || "E".equals(blIflogInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
            }
            String blIflogNo = blIflogInfo.getString("keyGenNo");
            logger.debug("#### blIflogNo : " + blIflogNo );
            
            fwIfContVo.put("logNo", blIflogNo);
            // 포워딩인터페이스로그등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
            
            if ( "Error".equals(blSend.getString("sendProcess")) && ("이미지 용량오류".equals(blSend.getString("sendMsg")) 
                 || "이미지 사이즈 8MB 초과".equals(blSend.getString("sendMsg")))) {
                // 이미지 용량오류로 에러난 건은 재전송시에는 이미지 없이 전송함
                attachIncludeYn = "Y";
            }
            
            // EDMS 이미지가 존재하지 않으면 화면에서 파일로 첨부된 이미지가 있는지 확인
            if (null == blSend.getString("blImgYn") || "".equals(blSend.getString("blImgYn"))) {
                DataItem imgCntVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEPreBlImg", blSend);

                if (null == imgCntVo || imgCntVo.isEmpty() || imgCntVo.isNull("cnt") || 1 > imgCntVo.getInt("cnt")) {
                    throw new BizException("ngff.fwd.empty04"); // 이미지가 없습니다.
                } else {
                    attachIncludeYn = "Y";

                    blSend.put("ifId", ifId);
                    // I고객사인터페이스관리Mgr.LGEPreBL이미지파일명수정
                    mainDao.update("fwd.edi.fwdCstComIfMgnt.updateLgEPreBlImgFileNm", blSend);
                }
            }
            
            // I고객사인터페이스관리Mgr.LGEPreBL인터페이스테이블등록
            DataItem regBlIfTblVo = new DataItem();
            regBlIfTblVo.put("interfaceId", ifId);
            regBlIfTblVo.put("empNo", blSend.getString("rstrId"));
            regBlIfTblVo.put("blId", blSend.getString("blId"));
            regBlIfTblVo.put("corpCd", blSend.getString("corpCd"));
            regBlIfTblVo.put("docId", docId);
            regBlIfTblVo.put("attachIncludeYn", attachIncludeYn); // 첨부파일 존재여부
            regBlIfTblVo.put("cGubun", blSend.getString("cGubun")); // [CSR ID:4349890] [LG전자] 중계건에 대한 PreBL 전송 기능 개선
            
            DataItem lgEPreBlIfTblData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEPreBlIfTblData", regBlIfTblVo);
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEPreBlIfTbl", lgEPreBlIfTblData);

            
            if ("OC".equals(blSend.getString("exctSprCd"))) {
                /* 해운처리 */
                // I고객사인터페이스관리Mgr.컨테이너매핑정보조회
                DataItem cntrMpngInfoCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectCntrMpngInfo", blSend);

                if (null == cntrMpngInfoCnt || null == cntrMpngInfoCnt.getString("cntrNullCnt") || cntrMpngInfoCnt.getInt("cntrNullCnt") > 0) {
                    throw new BizException("ngff.fwd.inqBkValid001", "CNTR TYPE CODE");
                }

                // I고객사인터페이스관리Mgr.LGEPreBL컨테이너등록
                DataItem regPreBlCntrVo = new DataItem();
                regPreBlCntrVo.put("interfaceId", ifId);
                regPreBlCntrVo.put("blId", blSend.getString("blId"));
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEPreBlCntr", regPreBlCntrVo);
            }
            
            if ("AR".equals(blSend.getString("exctSprCd"))) {
                // 항공
                if (!"2006865".equals(blSend.getString("cneeCd")) && !"2006866".equals(blSend.getString("cneeCd"))
                        && !"2007009".equals(blSend.getString("cneeCd"))
                        && !"2006864".equals(blSend.getString("cneeCd"))) {
                    // 항공 허브거래처는 INT111 전송 제외

                    // I고객사인터페이스관리Mgr.LGEPreBL참조번호등록
                    DataItem regRefNoVo = new DataItem();
                    regRefNoVo.put("interfaceId", ifId);
                    regRefNoVo.put("blId", blSend.getString("blId"));
                    regRefNoVo.put("exctSprCd", blSend.getString("exctSprCd"));
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEPreBlRefNo", regRefNoVo);
                }
            } else {
                // 해운, 특송
                // I고객사인터페이스관리Mgr.LGEPreBL참조번호등록
                DataItem regRefNoVo = new DataItem();
                regRefNoVo.put("interfaceId", ifId);
                regRefNoVo.put("blId", blSend.getString("blId"));
                regRefNoVo.put("exctSprCd", blSend.getString("exctSprCd"));
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEPreBlRefNo", regRefNoVo);
            }
            
            /* PREBL 자동 전송일 경우 EDMS 첨부 제거 */
            /* [CSR ID:4061675] 미주향 PRE BL 전송 로직 추가건 */
            if (!"PREBLAT".equals(blSend.getString("rstrId"))) {
                // I고객사인터페이스관리Mgr.LGEPreBL이미지전송정보조회
                List<DataItem> imgSendInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgEPreBlImgSendInfo", regBlIfTblVo);
                
                if (null != imgSendInfoList && 0 < imgSendInfoList.size()) {
                    // this.이미지전송요청
                    DataItem imgSendVo = imgSendInfoList.get(0);
                    imgSendVo.put("interfaceId", ifId);
                    imgSendVo.put("ifSingleId", "b2bFW1340");
                    imgSendVo.put("corpCd", blSend.getString("corpCd"));
                    imgSendVo.put("rstrId", blSend.getString("rstrId"));
                    imgSendVo.put("updrId", blSend.getString("rstrId"));
                    this.requestImgSend(imgSendVo);
                }
            }
            
            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "510");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * 이미지전송요청 - 이미지전송요청하는 오퍼레이션
     * @author 박종세
     * @param paramList
     * @return
     */
    public int requestImgSend(DataItem imgSendInfo) {
        int succYn = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertImgSendRqst", imgSendInfo); // I고객사인터페이스관리Mgr.이미지전송요청등록

        // I고객사인터페이스관리Mgr.이미지전송요청상세정보조회
        List<DataItem> imgSendDtlInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectImgSendRqstDtlInfo", imgSendInfo);

        // I고객사인터페이스관리Mgr.이미지전송요청상세등록
        if (null != imgSendDtlInfoList) {
            for (DataItem item : imgSendDtlInfoList) {
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertImgSendRqstDtl", item);
            }
        }

        return succYn;
    }
    /**
     * 이미지전송요청 - 이미지전송요청하는 오퍼레이션
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem saveLgEPreBlImg(DataItem param) {
     // I고객사인터페이스관리Mgr.LGEPreBL이미지저장
        DataItem resObj = new DataItem();
        int prcsCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgEPreBlImg", param);
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * LGD HBL 정보조회 - LG디스플레이 HBL에 대한 정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgdHblInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        if (null != inData.getString("blNo")) {
            String[] blNoList = inData.getString("blNo").split(",");
            List<String> blNoList2 = new ArrayList<String>();

            if (blNoList != null && blNoList.length > 0) {
                for (int i = 0; i < blNoList.length; i++) {
                    if (null != blNoList[i] && !blNoList[i].equals("")) {
                        blNoList2.add(blNoList[i]);
                    }
                }
            }
            if (blNoList2.size() > 0) {
                inData.put("blNoList", blNoList2);
            } else {
                inData.put("blNo", null);
            }
        }
        
        logger.debug("#### srchDt:"+inData.toJson());
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdHblInfo", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LGD HBL 전송 정보 조회 - LG디스플레이 HBL 전송 정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgdHblSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        logger.debug("#### srchDt:"+inData.toJson());
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdHblSendInfo", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LGD 트럭 정보 조회 - SO와 CO정보를 참조하여 LG디스플레이 트럭(중국) 정보를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgdCarInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        if (null != inData.getString("blNo")) {
            String[] blNoList = inData.getString("blNo").split(",");
            List<String> blNoList2 = new ArrayList<String>();

            if (blNoList != null && blNoList.length > 0) {
                for (int i = 0; i < blNoList.length; i++) {
                    if (null != blNoList[i] && !blNoList[i].equals("")) {
                        blNoList2.add(blNoList[i]);
                    }
                }
            }
            if (blNoList2.size() > 0) {
                inData.put("blNoList", blNoList2);
            } else {
                inData.put("blNo", null);
            }
        }
        
        logger.debug("#### srchDt:"+inData.toJson());
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdCarInfo", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LGDHBL전송 
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgdHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            if ("AUTO".equals(blSend.getString("gubun"))) {
                // IHBLMgr.전송가능거래처여부조회
                // 마감시 BL전송할 때 전송가능거래처 여부 체크하기 위해 추가
                blSend.put("cstSprCd", "LGD");

                DataItem sendBizptnr = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbBizptnrYn", blSend);
                if (sendBizptnr  == null || sendBizptnr.isEmpty() || sendBizptnr.isNull("cstSprCd") || sendBizptnr.getString("cstSprCd").isEmpty() ) {
                    // LG디스플레이 전송 건이 아닐 경우 에러 발생시키지 않고 Skip
                    continue;
                }
            }
            
            // I고객사인터페이스관리Mgr.invoice존재여부조회
            DataItem invInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectInvExstYn", blSend);
            if (1 > invInfo.getInt("lnCnt")) {
                throw new BizException("ngff.fwd.sendValid007");
            }
            
            DataItem inqInvNoVo = new DataItem();
            inqInvNoVo.put("invoiceNo", blSend.getString("invoiceNo"));
            inqInvNoVo.put("coSprCd", "02"); // '02' CI/PL
            inqInvNoVo.put("coCstGrpCd", "02"); // '02' LGD
            DataItem mainInvInfo = new DataItem();
            if ("A100".equals(blSend.getString("corpCd"))) {
                // I고객사인터페이스관리Mgr.mainInvoice번호조회
                mainInvInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectMaIninVoIceNo", inqInvNoVo);
                if (null == mainInvInfo || mainInvInfo.isEmpty() || mainInvInfo.isNull("coRecvNo") || mainInvInfo.getString("coRecvNo").isEmpty()) {
                    throw new BizException("ngff.fwd.sendValid008"); // 수신받은 SR정보가 없어서 전송할 수 없습니다.
                }

                // 본사의 경우 미확정건은 전송 불가
                // I고객사인터페이스관리Mgr.CO확정정보조회
                DataItem coConfInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectCoConfInfo", blSend);
                if ("N".equals(coConfInfo.getString("lvConfYn"))) {
                    throw new BizException("ngff.fwd.sendValid005", blSend.getString("invoiceNo"));
                }
            } else {
                // I고객사인터페이스관리Mgr.대표Invoice번호조회
                mainInvInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectRprsInvNo", blSend);
            }
            
            DataItem blVo = new DataItem();
            if (!"A100".equals(blSend.getString("corpCd")) && "TRK".equals(blSend.getString("exctSprCd"))) {
                // 중국 트럭건의 경우 BL이 없기때문에, SO,CO를 참조하여 송신
                // I고객사인터페이스관리Mgr.LGD트럭송신정보조회
                blVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgdCarSndInfo", blSend);
            } else {
                // I고객사인터페이스관리Mgr.HBL정보조회
                blVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectHblInfo", blSend);
            }
            if (null == blVo || blVo.isEmpty()) {
                throw new BizException("ngff.fwd.notFoundHbl"); // HBL이 존재하지 않습니다.
            }
            if (mainInvInfo.isNull("onbrYmd") || blVo.getString("onbrYmd").compareTo(invInfo.getString("lvToday")) > 0) {
                throw new BizException("ngff.fwd.sendValid004", blSend.getString("blNo")); // 선적일 이전에 전송할 수 없습니다.
            }
            if (!"A100".equals(blSend.getString("corpCd")) && !"TRK".equals(blSend.getString("exctSprCd")) && !"RL".equals(blSend.getString("exctSprCd"))) {
                // 중국(트럭제외)의 경우 매핑된 선사가 존재하지 않으면 에러
                // 20160321 철송 로직 추가 철송도 체크에서 제외
                if (null == blVo.getString("lvLineCd") || blVo.getString("lvLineCd").isEmpty()) {
                    throw new BizException("gsi.wrn.fw.sendValid0095", blVo.getString("carrCd"));
                }
            }
            
            
            mainInvInfo.put("corpCd", blSend.getString("corpCd"));
            DataItem ciPlVo = new DataItem();
            if ("A100".equals(blSend.getString("corpCd"))) {
                // I고객사인터페이스관리Mgr.CIPL정보조회
                ciPlVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectCiPlInfo", mainInvInfo);
            } else {
                // I고객사인터페이스관리Mgr.중국CIPL정보조회
                ciPlVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectChnCiPlInfo", mainInvInfo);
            }
            
            
         // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW1120");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            
            DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifIdInfo || ifIdInfo.isEmpty() 
                    || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            String ifId = ifIdInfo.getString("interfaceId");
            logger.debug("#### interfaceId : " + ifId );
            
            
            // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
            DataItem fwIfContVo = new DataItem();
            fwIfContVo.put("blId", blSend.getString("blId"));
            fwIfContVo.put("taskSprCd", "EXP");
            fwIfContVo.put("ifId", ifId);
            fwIfContVo.put("ifSnglId", "b2bFW1120");
            fwIfContVo.put("blNo", blSend.getString("blNo"));
            fwIfContVo.put("corpCd", blSend.getString("corpCd"));
            fwIfContVo.put("cstKindCd", "LGD");
            fwIfContVo.put("attrNm1", blSend.getString("invoiceNo"));
            fwIfContVo.put("rstrId", blSend.getString("rstrId"));
            // 포워딩인터페이스상태등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
            // 포워딩인터페이스로그등록
            // BL_IF_LOG No을 채번한다.
            // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
            DataItem blIflog = new DataItem();
            blIflog.put("userId", sessionUser.getString("userId"));
            blIflog.put("exctSprCd", "FW");
            blIflog.put("keygenCd", "BL_IF_LOG");
            blIflog.put("keygenPrefix", "");
            blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
            DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
            if (null == blIflogInfo || blIflogInfo.isEmpty() 
                || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
                || "E".equals(blIflogInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
            }
            String blIflogNo = blIflogInfo.getString("keyGenNo");
            logger.debug("#### blIflogNo : " + blIflogNo );
            fwIfContVo.put("logNo", blIflogNo);
            // 포워딩인터페이스로그등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
            
            
            // I고객사인터페이스관리Mgr.인터페이스일련번호채번
            DataItem ifSeqKeygenCond = new DataItem();
            ifSeqKeygenCond.put("blNo", blVo.getString("blNo"));
            if ("A100".equals(blSend.getString("corpCd"))) {
                ifSeqKeygenCond.put("invoiceNo", ciPlVo.getString("coNo"));
            } else {
                ifSeqKeygenCond.put("invoiceNo", blSend.getString("invoiceNo"));
            }
            DataItem ifSeq = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectIfSeq", ifSeqKeygenCond);
            if (null == ifSeq || ifSeq.isEmpty() || ifSeq.isNull("lnInterfaceSeqNo") || "".equals(ifSeq.getString("lnInterfaceSeqNo"))) {
                throw new BizException("ngff.fwd.creatFail", "lnInterfaceSeqNo"); // 인터페이스 KEY 추출 ERR
            }
            
            
            if ("A100".equals(blSend.getString("corpCd"))) {
                // FRY의 경우 SHIPPING LINE2는 필수 항목임.
                if ("FRY".equals(ciPlVo.getString("coTrnTypeCd")) && ( blVo.isNull("lvLineCd") || blVo.getString("lvLineCd").isEmpty())) {
                    throw new BizException("ngff.fwd.sendValid0095", blVo.getString("carrCd"));
                }
                if ( blVo.isNull("lvPor") || blVo.getString("lvPor").isEmpty()) {
                    throw new BizException("ngff.fwd.sendValid0091", blVo.getString("porCd"));
                }
                if ( blVo.isNull("lvPol") || blVo.getString("lvPol").isEmpty()) {
                    throw new BizException("ngff.fwd.sendValid0092", blVo.getString("polCd"));
                }
                if ( blVo.isNull("lvPod") || blVo.getString("lvPod").isEmpty()) {
                    throw new BizException("ngff.fwd.sendValid0093", blVo.getString("podCd"));
                }
                if ( blVo.isNull("lvFdest") || blVo.getString("lvFdest").isEmpty()) {
                    throw new BizException("ngff.fwd.sendValid0094", blVo.getString("fdestCd"));
                }
                if ( blVo.isNull("sellCbm") || 0 == blVo.getDouble("sellCbm")) {
                    throw new BizException("ngff.fwd.sendValid010");
                }
                // AIR나 Sea&Air의 경우 Chr W/T가 필수임.
                if ("AIR".equals(ciPlVo.getString("coTrnTypeCd")) || "SAA".equals(ciPlVo.getString("coTrnTypeCd"))) {
                    if (blVo.isNull("sellCbm") || 0 == blVo.getDouble("sellCwt")) {
                        throw new BizException("ngff.fwd.sendValid011");
                    }
                }
            }
            
            // I고객사인터페이스관리Mgr.LGD인터페이스434테이블등록
            DataItem regLgdIf434TblVo = new DataItem();
            regLgdIf434TblVo.put("interfaceId", ifId);
            regLgdIf434TblVo.put("blNo", blVo.getString("blNo"));
            regLgdIf434TblVo.put("interfaceSeqNo", ifSeq.getString("lnInterfaceSeqNo"));
            regLgdIf434TblVo.put("coNo", ciPlVo.getString("coNo"));
            regLgdIf434TblVo.put("coOrgCd", ciPlVo.getString("coOrgCd"));
            regLgdIf434TblVo.put("coInvcYmd", ciPlVo.getString("coInvcYmd"));
            regLgdIf434TblVo.put("coInvcCurCd", ciPlVo.getString("coInvcCurCd"));
            regLgdIf434TblVo.put("coInvcAmt", ciPlVo.getString("coInvcAmt"));
            regLgdIf434TblVo.put("incotCd", ciPlVo.getString("coIncotCd"));
            regLgdIf434TblVo.put("salesPersonId", ciPlVo.getString("coSalesEmpId"));
            regLgdIf434TblVo.put("salesPersonNm", ciPlVo.getString("coSalesEmpNm"));
            regLgdIf434TblVo.put("coTrnTypeCd", ciPlVo.getString("coTrnTypeCd"));
            regLgdIf434TblVo.put("coArrplcTrnTypeCd", ciPlVo.getString("coArrplcTrnTypeCd"));
            regLgdIf434TblVo.put("coShttTrnCnt", ciPlVo.getString("coShttTrnCnt"));
            regLgdIf434TblVo.put("attribute6", blVo.getString("othShippingLine1Code"));
            regLgdIf434TblVo.put("attribute7", blVo.getString("othShippingLine1Code"));
            regLgdIf434TblVo.put("attribute8", blVo.getString("othShippingLine1Code"));

            if (!"A100".equals(blSend.getString("corpCd")) && "TRK".equals(blSend.getString("exctSprCd"))) {
                // 중국 트럭건의 경우
                regLgdIf434TblVo.put("lvLineCd", blVo.getString("coShipln2Cd"));
            } else {
                regLgdIf434TblVo.put("lvLineCd", blVo.getString("lvLineCd"));
            }

            regLgdIf434TblVo.put("curCd", blVo.getString("curCd"));
            regLgdIf434TblVo.put("coShipln1Cd", ciPlVo.getString("coShipln1Cd")); // SHIPPING_LINE1_CODE
            regLgdIf434TblVo.put("coShipln2Cd", ciPlVo.getString("coShipln2Cd")); // SHIPPING_LINE2_CODE (사용안함)
            regLgdIf434TblVo.put("coCarr1Cd", ciPlVo.getString("coCarr1Cd"));
            regLgdIf434TblVo.put("coCarr2Cd", ciPlVo.getString("coCarr2Cd"));

            if (null != blVo.getString("lvPor") && !blVo.getString("lvPor").isEmpty()) { // 중국의 경우 BL의 PORT코드 매핑이 없으면,
                regLgdIf434TblVo.put("lvPor", blVo.getString("lvPor"));
            } else {
                regLgdIf434TblVo.put("lvPor", ciPlVo.getString("lvPorCn"));
            }
            if (null != blVo.getString("lvPol") && !blVo.getString("lvPol").isEmpty()) { // 중국의 경우 BL의 PORT코드 매핑이 없으면,
                regLgdIf434TblVo.put("lvPol", blVo.getString("lvPol"));
            } else {
                regLgdIf434TblVo.put("lvPol", ciPlVo.getString("lvPolCn"));
            }
            if (null != blVo.getString("lvPod") && !blVo.getString("lvPod").isEmpty()) { // 중국의 경우 BL의 PORT코드 매핑이 없으면,
                regLgdIf434TblVo.put("lvPod", blVo.getString("lvPod"));
            } else {
                regLgdIf434TblVo.put("lvPod", ciPlVo.getString("lvPodCn"));
            }
            if (null != blVo.getString("lvFdest") && !blVo.getString("lvFdest").isEmpty()) { // 중국의 경우 BL의 PORT코드 매핑이
                regLgdIf434TblVo.put("lvFdest", blVo.getString("lvFdest"));
            } else {
                regLgdIf434TblVo.put("lvFdest", ciPlVo.getString("lvPdelCn"));
            }

            regLgdIf434TblVo.put("trnTypeCd", blVo.getString("trnTypeCd"));
            regLgdIf434TblVo.put("exctSprCd", blVo.getString("exctSprCd"));
            regLgdIf434TblVo.put("coGwt", ciPlVo.getString("coGwt"));
            regLgdIf434TblVo.put("sellGwt", blVo.getString("sellGwt"));
            regLgdIf434TblVo.put("sellWgtUnitCd", blVo.getString("sellWgtUnitCd"));
            regLgdIf434TblVo.put("coCbm", ciPlVo.getString("coCbm"));
            regLgdIf434TblVo.put("sellCbm", blVo.getString("sellCbm"));
            regLgdIf434TblVo.put("sellCwt", blVo.getString("sellCwt"));
            regLgdIf434TblVo.put("coDomExpSprCd", ciPlVo.getString("coDomExpSprCd"));
            regLgdIf434TblVo.put("coExpDeclNo", ciPlVo.getString("coExpDeclNo"));
            regLgdIf434TblVo.put("coRecvNo", ciPlVo.getString("coRecvNo"));
            regLgdIf434TblVo.put("coInvcReprtYn", ciPlVo.getString("coInvcReprtYn"));
            regLgdIf434TblVo.put("coInvcReprtOrignNo", ciPlVo.getString("coInvcReprtOrignNo"));
            regLgdIf434TblVo.put("coInvcSplitYn", ciPlVo.getString("coInvcSplitYn"));
            regLgdIf434TblVo.put("coInvcSplitOrignNo", ciPlVo.getString("coInvcSplitOrignNo"));
            regLgdIf434TblVo.put("coCombYn", ciPlVo.getString("coCombYn"));
            regLgdIf434TblVo.put("coMltCntFdestYn", ciPlVo.getString("coMltCntFdestYn"));
            regLgdIf434TblVo.put("coMltCntFdestCd", ciPlVo.getString("coMltCntFdestCd"));
            regLgdIf434TblVo.put("onbrYmd", blVo.getString("onbrYmd"));
            regLgdIf434TblVo.put("arrYmd", blVo.getString("arrYmd"));
            regLgdIf434TblVo.put("coShppNm", ciPlVo.getString("coShppNm"));
            regLgdIf434TblVo.put("coShppAddr1", ciPlVo.getString("coShppAddr1"));
            regLgdIf434TblVo.put("coShppAddr2", ciPlVo.getString("coShppAddr2"));
            regLgdIf434TblVo.put("coShppAddr3", ciPlVo.getString("coShppAddr3"));
            regLgdIf434TblVo.put("coShppAddr4", ciPlVo.getString("coShppAddr4"));
            regLgdIf434TblVo.put("coShppAddr5", ciPlVo.getString("coShppAddr5"));
            regLgdIf434TblVo.put("coShppTelNo1", ciPlVo.getString("coShppTelNo1"));
            regLgdIf434TblVo.put("coShppTelNo2", ciPlVo.getString("coShppTelNo2"));
            regLgdIf434TblVo.put("coCneeNm", ciPlVo.getString("coCneeNm"));
            regLgdIf434TblVo.put("coCneeAddr1", ciPlVo.getString("coCneeAddr1"));
            regLgdIf434TblVo.put("coCneeAddr2", ciPlVo.getString("coCneeAddr2"));
            regLgdIf434TblVo.put("coCneeAddr3", ciPlVo.getString("coCneeAddr3"));
            regLgdIf434TblVo.put("coCneeAddr4", ciPlVo.getString("coCneeAddr4"));
            regLgdIf434TblVo.put("coCneeAddr5", ciPlVo.getString("coCneeAddr5"));
            regLgdIf434TblVo.put("coCneeTelNo1", ciPlVo.getString("coCneeTelNo1"));
            regLgdIf434TblVo.put("coCneeTelNo2", ciPlVo.getString("coCneeTelNo2"));
            regLgdIf434TblVo.put("coNtprNm", ciPlVo.getString("coNtprNm"));
            regLgdIf434TblVo.put("coNtprAddr1", ciPlVo.getString("coNtprAddr1"));
            regLgdIf434TblVo.put("coNtprAddr2", ciPlVo.getString("coNtprAddr2"));
            regLgdIf434TblVo.put("coNtprAddr3", ciPlVo.getString("coNtprAddr3"));
            regLgdIf434TblVo.put("coNtprAddr4", ciPlVo.getString("coNtprAddr4"));
            regLgdIf434TblVo.put("coNtprAddr5", ciPlVo.getString("coNtprAddr5"));
            regLgdIf434TblVo.put("coNtprTelNo1", ciPlVo.getString("coNtprTelNo1"));
            regLgdIf434TblVo.put("coNtprTelNo2", ciPlVo.getString("coNtprTelNo2"));
            regLgdIf434TblVo.put("usrId", blSend.getString("rstrId"));
            regLgdIf434TblVo.put("lvFileSeq", ciPlVo.getString("lvFileSeq"));

            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf434Tbl", regLgdIf434TblVo);
            
            
            DataItem lgdRecvVo = new DataItem();
            lgdRecvVo.put("blId", blSend.getString("blId"));
            lgdRecvVo.put("coRecvNo", mainInvInfo.getString("coRecvNo"));

            List<DataItem> lgdRecvDtlInfoList = null;
            if ("A100".equals(blSend.getString("corpCd"))) {
                // I고객사인터페이스관리Mgr.LGD수신상세정보조회
                lgdRecvDtlInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdRecvDtlInfo", lgdRecvVo);  
            } else {
                if ("TRK".equals(blSend.getString("exctSprCd"))) {
                    // 중국 트럭건의 경우
                    // I고객사인터페이스관리Mgr.중국LGD트럭상세정보조회
                    lgdRecvDtlInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectChnLgdCarDtlInfo", lgdRecvVo);
                } else {
                    // 중국 트럭 제외 건
                    // I고객사인터페이스관리Mgr.중국LGD수신상세정보조회
                    lgdRecvDtlInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectChnLgdRecvDtlInfo", lgdRecvVo); 
                }
            }
            
            
            int lgdIf435RegCnt = 0;
            for (int j = 0; j < lgdRecvDtlInfoList.size(); j++) {
                // I고객사인터페이스관리Mgr.LGD인터페이스435테이블등록
                DataItem lgdIf435Vo = lgdRecvDtlInfoList.get(j);

                if ("A100".equals(blSend.getString("corpCd"))) {
                    if (("SEA".equals(ciPlVo.getString("coTrnTypeCd")) || "SAA".equals(ciPlVo.getString("coTrnTypeCd")) || "FRY"
                            .equals(ciPlVo.getString("coTrnTypeCd")))
                            && "FLC".equals(lgdIf435Vo.getString("loadingTypeCode"))) {
                        
                        if (null == lgdIf435Vo || lgdIf435Vo.isEmpty()
                                || lgdIf435Vo.isNull("containerNo") || lgdIf435Vo.getString("containerNo").equals("N/A")) {
                            throw new BizException("ngff.fwd.sendValid0121", blVo.getString("blNo"));
                        }
                        if ( lgdIf435Vo.isNull("containerTypeCode") || lgdIf435Vo.getString("containerTypeCode").isEmpty()) {
                            throw new BizException("gsi.wrn.fw.sendValid0122", blVo.getString("blNo"));
                        }
                    }
                }
                lgdIf435Vo.put("interfaceId", ifId);
                lgdIf435Vo.put("blNo", blVo.getString("blNo"));
                lgdIf435Vo.put("lnInterfaceSqeNo", ifSeq.getString("lnInterfaceSeqNo"));
                lgdIf435Vo.put("usrId", blSend.getString("rstrId"));

                int dtlCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf435Tbl", lgdIf435Vo);
                lgdIf435RegCnt = lgdIf435RegCnt + dtlCnt;
            }
            if (lgdIf435RegCnt < 1) {
                throw new BizException("ngff.fwd.sendValid013", blVo.getString("blNo"));
            }

            if (!"TRK".equals(blSend.getString("exctSprCd"))) {
                // 중국 트럭건의 경우는 BL이 없기때문에 아래 로직 제외
                /* IHBLMgr.HBL화주 전송 여부 수정*/
                mainDao.update("fwd.document.fwdHbl.updateHblCustSendYn", blSend);
                
                // IBL공통관리Prc.BL진행상태동기화요청
                DataItem blStatHistInfoVo = new DataItem();
                blStatHistInfoVo.put("closYn", "Y");
                blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
                blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
                blStatHistInfoVo.put("statCd", "500");
                blStatHistInfoVo.put("blId", blSend.getString("blId"));
                blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
                blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
                fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            }
           
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * LGD 수입 HBL 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgdImpHbl(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdImpHbl", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LGD 수입 HBL 전송/응답 정보조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgdImpHblSendResponseInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> sendList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdImpHblSendInfo", inData);
        resObj.put("dlt_blSendList", sendList);
        
        List<DataItem> responseList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdImpHblAnsInfo", inData);
        resObj.put("dlt_blResponseList", responseList);
        return resObj;
    }
    /**
     * LGD 수입항공 HBL 전송
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgdImpAirHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            
            DataItem invInfo = new DataItem(); // inqInvExstYn에서 return value
            invInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectImpInvExstYn", blSend); // I고객사인터페이스관리Mgr.invoice존재여부조회
            if (1 > invInfo.getInt("lnCnt")) {
                throw new BizException("ngff.fwd.sendValid007");
            }
            
            DataItem sendInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgdImpAirHblInfo", blSend);
            if (null == sendInfo || sendInfo.isEmpty() || sendInfo.isNull("currency") || sendInfo.getString("currency").isEmpty() ) {
                throw new BizException("[Error] HBL NO : " + blSend.getString("blNo") + " [MSG] Required BL Currency.");
            }

            if (null == sendInfo || sendInfo.isEmpty() || sendInfo.isNull("fltVslNm") || sendInfo.getString("currency").isEmpty() ) {
                throw new BizException("[Error] HBL NO : " + blSend.getString("blNo") + " [MSG] Required FLT NO.");
            }
            
            List<DataItem> invoiceList; // inqInvList에서 return value
            invoiceList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectInvList", blSend); // I고객사인터페이스관리Mgr.invoice목록조회
            
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW0460");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            
            DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifIdInfo || ifIdInfo.isEmpty() 
                    || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            String ifId = ifIdInfo.getString("interfaceId");
            blSend.put("ifId", ifId);
            logger.debug("#### interfaceId : " + ifId );
            

            /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
            DataItem xmlMSGIdCrt = new DataItem();
            xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
            xmlMSGIdCrt.put("exctSprCd", "FW");
            xmlMSGIdCrt.put("keygenCd", "CONVERSATION_ID");
            xmlMSGIdCrt.put("keygenPrefix", "");
            xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDate() );
            
            DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
            if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "CONVERSATION_ID");
            }
            
            String conversationId = xmlMsgIdInfo.getString("keyGenNo");
            blSend.put("conversationId", conversationId);
            logger.debug("#### conversationId : " + conversationId );
            
            
            // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
            DataItem fwIfContVo = new DataItem();
            fwIfContVo.put("blId", blSend.getString("blId"));
            fwIfContVo.put("taskSprCd", "IMP");
            fwIfContVo.put("ifId", ifId);
            fwIfContVo.put("ifSnglId", "b2bFW0460");
            fwIfContVo.put("blNo", blSend.getString("blNo"));
            fwIfContVo.put("corpCd", blSend.getString("corpCd"));
            fwIfContVo.put("cstKindCd", "LGD");
            fwIfContVo.put("attrNm1", conversationId);
            fwIfContVo.put("rstrId", blSend.getString("rstrId"));
            
            // 포워딩인터페이스상태등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
            // 포워딩인터페이스로그등록
            // BL_IF_LOG No을 채번한다.
            // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
            DataItem blIflog = new DataItem();
            blIflog.put("userId", sessionUser.getString("userId"));
            blIflog.put("exctSprCd", "FW");
            blIflog.put("keygenCd", "BL_IF_LOG");
            blIflog.put("keygenPrefix", "");
            blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
            DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
            if (null == blIflogInfo || blIflogInfo.isEmpty() 
                || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
                || "E".equals(blIflogInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
            }
            String blIflogNo = blIflogInfo.getString("keyGenNo");
            logger.debug("#### blIflogNo : " + blIflogNo );
            fwIfContVo.put("logNo", blIflogNo);
            // 포워딩인터페이스로그등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
            
            
            // I고객사인터페이스관리Mgr.LGD인터페이스060테이블등록
            try {
                // regLgdIf060Tbl insert Data 조회
                DataItem lgdIf060TblData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgdIf060TblData", blSend);
                // regLgdIf060Tbl insert
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf060Tbl", lgdIf060TblData); 
            } catch (Exception e) {
                throw new BizException("[Error] HBL NO : " + blSend.getString("blNo") + " [MSG]" + e.getMessage());
            }
            
            if (invoiceList != null) {
                for (DataItem invoiceInfo : invoiceList) {
                    invoiceInfo.put("ifId", ifId);
                    invoiceInfo.put("invNo", invoiceInfo.getString("invoiceNo"));
                    invoiceInfo.put("exctSprCd", blSend.getString("exctSprCd"));

                    DataItem outData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectInvDup", invoiceInfo); // I고객사인터페이스관리Mgr.invoice중복조회
                    if (outData.getInt("cnt") > 1) {
                        throw new BizException("HBL NO : " + blSend.getString("blNo") + "\n DUPLICATE INVICE NO : " + invoiceInfo.getString("invoiceNo"));
                    }
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf062Tbl", invoiceInfo); // I고객사인터페이스관리Mgr.LGD인터페이스062테이블등록
                }
            }
            
            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "500");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
           
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * LGD 수입해상 HBL 전송
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgdImpSeaHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            
            DataItem invInfo = new DataItem(); // inqInvExstYn에서 return value
            invInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectImpInvExstYn", blSend); // I고객사인터페이스관리Mgr.invoice존재여부조회
            if (1 > invInfo.getInt("lnCnt")) {
                throw new BizException("ngff.fwd.sendValid007");
            }
            
            
            List<DataItem> invoiceList; // inqInvList에서 return value
            invoiceList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectInvList", blSend); // I고객사인터페이스관리Mgr.invoice목록조회
            
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW1380");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            
            DataItem ifIdInfo = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifIdInfo || ifIdInfo.isEmpty() 
                    || ifIdInfo.isNull("rtnCd") || ifIdInfo.getString("rtnCd").isEmpty() 
                    || "E".equals(ifIdInfo.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifIdInfo.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            String interfaceId = ifIdInfo.getString("interfaceId");
            logger.debug("#### interfaceId : " + interfaceId );
            
            
            /* I고객사인터페이스관리Mgr.XMLMSGID채번 */
            DataItem xmlMSGIdCrt = new DataItem();
            xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
            xmlMSGIdCrt.put("exctSprCd", "FW");
            xmlMSGIdCrt.put("keygenCd", "CONVERSATION_ID");
            xmlMSGIdCrt.put("keygenPrefix", "");
            xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDate() );
            
            DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
            if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "CONVERSATION_ID");
            }
            String conversationId = xmlMsgIdInfo.getString("keyGenNo");
            logger.debug("#### conversationId : " + conversationId );
            
            
            // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
            DataItem fwIfContVo = new DataItem();
            fwIfContVo.put("blId", blSend.getString("blId"));
            fwIfContVo.put("taskSprCd", "IMP");
            fwIfContVo.put("ifId", interfaceId);
            fwIfContVo.put("ifSnglId", "b2bFW1380");
            fwIfContVo.put("blNo", blSend.getString("blNo"));
            fwIfContVo.put("corpCd", blSend.getString("corpCd"));
            fwIfContVo.put("cstKindCd", "LGD");
            fwIfContVo.put("attrNm1", conversationId);
            fwIfContVo.put("rstrId", blSend.getString("rstrId"));
            
            // 포워딩인터페이스상태등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
            // 포워딩인터페이스로그등록
            // BL_IF_LOG No을 채번한다.
            // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
            DataItem blIflog = new DataItem();
            blIflog.put("userId", sessionUser.getString("userId"));
            blIflog.put("exctSprCd", "FW");
            blIflog.put("keygenCd", "BL_IF_LOG");
            blIflog.put("keygenPrefix", "");
            blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
            DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
            if (null == blIflogInfo || blIflogInfo.isEmpty() 
                || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
                || "E".equals(blIflogInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
            }
            String blIflogNo = blIflogInfo.getString("keyGenNo");
            logger.debug("#### blIflogNo : " + blIflogNo );
            fwIfContVo.put("logNo", blIflogNo);
            // 포워딩인터페이스로그등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
            
            
            // I고객사인터페이스관리Mgr.LGD인터페이스061테이블등록
            blSend.put("ifId", interfaceId);
            blSend.put("conversationId", conversationId);
            // regLgdIf061Tbl insert Data 조회
            DataItem lgdIf061TblData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgdIf061TblData", blSend);
            // regLgdIf061Tbl insert
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf061Tbl", lgdIf061TblData); 
            
            
            if (invoiceList != null) {
                for (DataItem invoiceInfo : invoiceList) {
                    invoiceInfo.put("ifId", interfaceId);
                    invoiceInfo.put("invNo", invoiceInfo.getString("invoiceNo"));
                    invoiceInfo.put("exctSprCd", blSend.getString("exctSprCd"));

                    DataItem outData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectInvDup", invoiceInfo); // I고객사인터페이스관리Mgr.invoice중복조회
                    if (outData.getInt("cnt") > 1) {
                        throw new BizException("HBL NO : " + blSend.getString("blNo") + "\n DUPLICATE INVICE NO : " + invoiceInfo.getString("invoiceNo"));
                    }
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf062Tbl", invoiceInfo); // I고객사인터페이스관리Mgr.LGD인터페이스062테이블등록
                }
            }
            
            // inqSeaHblCntrDtl에서 return
            List<DataItem> cntrDtlList; 
            cntrDtlList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgdSeaHblCntrDtl", blSend); // IHBLMgr.해상HBL컨테이너상세조회
            if ( cntrDtlList != null) {
                for (DataItem cntrInfo : cntrDtlList) {
                    cntrInfo.put("ifId", interfaceId);
                    mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgdIf063Tbl", cntrInfo); // I고객사인터페이스관리Mgr.LGD인터페이스063테이블등록
                }
            }
           
            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "500");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     *  LG상사 수출 BL 전송 리스트를 조회하는 오퍼레이션
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgiExpBl(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgiExpBl", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * LG 상사 수출 BL 전송 요청. 해상/항공 공용
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgiExpBl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            
            // I고객사인터페이스관리Mgr.LG상사수출전송가능여부조회
            DataItem blSendPosbYnVo = new DataItem();
            blSendPosbYnVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgiExpSendPosbYn", blSend); 
            if (1 > blSendPosbYnVo.getInt("blCnt")) {
                throw new BizException("ngff.fwd.lgiB2b.noSrcBl");
                // LG상사 전송대상 BL이 아닙니다
            }
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW1130");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            DataItem ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifId || ifId.isEmpty() 
                    || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                    || "E".equals(ifId.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifId.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            String interfaceId = ifId.getString("interfaceId");
            
            // I고객사인터페이스관리Mgr.LG상사수출BL전송설정조회
            // XMLMSGID채번해서 파라미터로 전송. AS-IS에서는 Query에서 직접 채번하고 있음
            DataItem xmlMSGIdCrt = new DataItem();
            xmlMSGIdCrt.put("userId", sessionUser.getString("userId"));
            xmlMSGIdCrt.put("exctSprCd", "FW");
            xmlMSGIdCrt.put("keygenCd", "KLNET");
            xmlMSGIdCrt.put("keygenPrefix", "XPLI");
            xmlMSGIdCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
            DataItem xmlMsgIdInfo = fwdKeygenService.createFwdAutoNo(xmlMSGIdCrt);
            if (null == xmlMsgIdInfo || xmlMsgIdInfo.isEmpty() 
                || xmlMsgIdInfo.isNull("rtnCd") || xmlMsgIdInfo.getString("rtnCd").isEmpty() 
                || "E".equals(xmlMsgIdInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "KLNET-XPLI");
            }
            String xmlMsgId = xmlMsgIdInfo.getString("keyGenNo");
            logger.debug("%%%%% xmlMsgId : " + xmlMsgId );
            
            // FILE_NM채번해서 파라미터로 전송. AS-IS에서는 Query에서 직접 채번하고 있음
            DataItem fileNmCrt = new DataItem();
            fileNmCrt.put("userId", sessionUser.getString("userId"));
            fileNmCrt.put("exctSprCd", "FW");
            fileNmCrt.put("keygenCd", "LGIBLIMAGE");
            fileNmCrt.put("keygenPrefix", blSend.get("blId"));
            fileNmCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
            DataItem fileNmInfo = fwdKeygenService.createFwdAutoNo(fileNmCrt);
            if (null == fileNmInfo || fileNmInfo.isEmpty() 
                || fileNmInfo.isNull("rtnCd") || fileNmInfo.getString("rtnCd").isEmpty() 
                || "E".equals(fileNmInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "LGIBLIMAGE");
            }
            String fileNm = fileNmInfo.getString("keyGenNo");
            logger.debug("#### fileNm : " + fileNm );
            
            blSend.put("xmlMsgId", xmlMsgId);
            blSend.put("fileNm", fileNm);
            DataItem lgiExpBlSetpInfoVo = new DataItem(); // inqLgiExpBlSendSetp에서 return value
            lgiExpBlSetpInfoVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgiExpBlSendSetp", blSend);
            if ( null == lgiExpBlSetpInfoVo || lgiExpBlSetpInfoVo.isEmpty() 
                    || lgiExpBlSetpInfoVo.isNull("srNo") || lgiExpBlSetpInfoVo.getString("srNo").isEmpty() ) {
                throw new BizException("ngff.fwd.sendBkValid002"); // SR NO가 없으면 전송 할 수 없습니다
            }
            
            // I고객사인터페이스관리Mgr.LG상사수출BL기본조회
            DataItem lgiExpBlBasisVo = new DataItem();
            lgiExpBlBasisVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgiExpBlBasis", blSend);             
            lgiExpBlBasisVo.put("interfaceId", interfaceId);
            lgiExpBlBasisVo.put("xmlDocumentNo", lgiExpBlSetpInfoVo.getString("xmlMsgId"));
            if (lgiExpBlBasisVo.getInt("sendCount") == 1) {
                lgiExpBlBasisVo.put("blStatusCode", '9');// 최초전송
            } else {
                lgiExpBlBasisVo.put("blStatusCode", '4');// 정정
            }
            lgiExpBlBasisVo.put("attr1", lgiExpBlSetpInfoVo.getString("fileNm"));
            lgiExpBlBasisVo.put("srNo", lgiExpBlSetpInfoVo.getString("srNo"));
            lgiExpBlBasisVo.put("statusCode", lgiExpBlSetpInfoVo.getString("statusCode"));

            // I고객사인터페이스관리Mgr.LG상사수출BL전송기본등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgiExpBlSendBasis", lgiExpBlBasisVo);
            
            // I고객사인터페이스관리Mgr.LG상사수출BL컨테이너조회
            List<DataItem> lgiExpBlCntrList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgiExpBlCntr", blSend);
            for(DataItem item : lgiExpBlCntrList) {
                item.put("interfaceId", interfaceId);
                item.put("lclFalg", lgiExpBlBasisVo.getString("ladgTypeCd"));
                
                // I고객사인터페이스관리Mgr.LG상사수출BL전송컨테이너등록
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgiExpBlSendCntr", item);
            }
                
            // I고객사인터페이스관리Mgr.LG상사수출BLDesc조회
            List<DataItem> lgiExpBlRmkList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgiExpBlDesc", blSend);
            for(DataItem item : lgiExpBlRmkList) {
                item.put("interfaceId", interfaceId);
                
                // I고객사인터페이스관리Mgr.LG상사수출BL전송Desc등록
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgiExpBlSendDesc", item);
            }
            
            // I고객사인터페이스관리Mgr.LG상사수출BLMark조회
            List<DataItem> lgiExpBlRmkList1 = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgiExpBlMark", blSend);
            for(DataItem item : lgiExpBlRmkList1) {
                item.put("interfaceId", interfaceId);
                
                // I고객사인터페이스관리Mgr.LG상사수출BL전송Mark등록
                mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgiExpBlSendMark", item);
            }
            
            // IHBLMgr.HBL화주전송여부수정
            mainDao.update("fwd.document.fwdHbl.updateHblCustSendYn", blSend);
            
            
            // I고객사인터페이스관리Mgr.LGEPreBL이미지전송정보조회
            List<DataItem> imgSendInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgiBlImgSendInfo", lgiExpBlBasisVo);
            if(imgSendInfoList.size() > 0 ) {
                DataItem item = imgSendInfoList.get(0);
                item.put("interfaceId", interfaceId);
                item.put("ifSingleId", "b2bFW1130");
                item.put("corpCd", blSend.getString("corpCd"));
                this.requestImgSend(item);
            }
            
            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "500");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     *  I고객사인터페이스관리Mgr.GS 칼텍스 BL 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectGsctexBl(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectGsctexBl", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     *  I화주BL EDI등록Prc.크레텍책임BL조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectCretRsbtyBl(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectCretRsbtyBl", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     * GS 칼텍스 BL 전송.
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendGsctexBl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW1070");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            DataItem ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifId || ifId.isEmpty() 
                    || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                    || "E".equals(ifId.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifId.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            // I고객사인터페이스관리Mgr.GS칼텍스BL전송정보조회
            DataItem blVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectGsctexBlSendInfo", blSend);
            if (null == blVo) {
                throw new BizException("ngff.com.error"); // 에러발생
            }
            
            blVo.put("interfaceId", ifId.getString("interfaceId"));
            blVo.put("rstrId", blSend.getString("rstrId"));
            // I고객사인터페이스관리Mgr.GS칼텍스인터페이스테이블등록
            int succYn = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertGsctexIfTbl", blVo);
            if (1 > succYn) {
                throw new BizException("ngff.ism.commonMsg", "BL UPDATE"); // 등록중에러발생
            }
            
            
            // I고객사인터페이스관리Mgr.인터페이스ID채번
            ifIdKeygenCond.put("inIfId", "b2bFW1740");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifId || ifId.isEmpty() 
                    || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                    || "E".equals(ifId.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifId.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            blVo.put("interfaceId", ifId.getString("interfaceId"));
            
            // I고객사인터페이스관리Mgr.GS칼텍스PMIS인터페이스테이블등록
            int succYn1 = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertGsctexPMISIfTbl", blVo);
            if (1 > succYn1) {
                throw new BizException("ngff.ism.commonMsg", "BL UPDATE"); // 등록중에러발생
            }
            
            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "510");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     * 크레텍 책임 BL 전송
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendCretRsbtyBl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
            
            
            // I고객사인터페이스관리Mgr.크레텍책임BL전송정보조회
            DataItem blVo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectCretRsbtyBlSendInfo", blSend);
            if (null == blVo) {
                throw new BizException("ngff.com.error"); // 에러발생
            }
            blVo.put("rstrId", blSend.getString("rstrId"));
            blVo.put("updrId", blSend.getString("updrId"));
            

            // I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", "b2bFW0200");
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            DataItem ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifId || ifId.isEmpty() 
                    || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                    || "E".equals(ifId.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifId.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            blVo.put("interfaceId", ifId.getString("interfaceId"));
            blVo.put("fileNm", blVo.getString("comType") + blVo.getString("blNo") + "_" + ifId.getString("interfaceId") + ".TXT");
            blVo.put("rstrId", blSend.getString("rstrId"));
            // I고객사인터페이스관리Mgr.GS칼텍스인터페이스테이블등록
            int succYn = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertCretRsbtyIfTbl", blVo);
            if (1 > succYn) {
                throw new BizException("ngff.ism.commonMsg", "BL"); // 등록중에러발생
            }
            
            // IHBLMgr.HBL화주전송여부수정
            int succYn1 = mainDao.update("fwd.document.fwdHbl.updateHblCustSendYn", blSend);
            if (1 > succYn1) {
                throw new BizException("ngff.ism.commonMsg", "BL UPDATE"); // 등록중에러발생
            }
            
            // I고객사인터페이스관리Mgr.크레텍책임BL이미지전송정보조회
            List<DataItem> imgSendInfoList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectCretRsbtyBlImgSendInfo", blVo);
            for(DataItem imgSendVo : imgSendInfoList) {
                imgSendVo.put("interfaceId", ifId.getString("interfaceId"));
                imgSendVo.put("ifSingleId", "b2bFW0200");
                imgSendVo.put("corpCd", blSend.getString("corpCd"));

                this.requestImgSend(imgSendVo);
            }
            
            
            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "510");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     *  서브원 전송 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectServeoneSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectServeoneSendInfo", inData);
        resObj.put("dlt_blList", outList);
        return resObj;
    }
    /**
     *  서브원 전송 요청 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectServeoneReqSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectServeoneReqSendInfo", inData);
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    /**
     *  서브원 전송 요청 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectServeoneResSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectServeoneResSendInfo", inData);
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    /**
     *Serveone BL 전송.
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendServeoneHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        DataItem blSend = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( blSend == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        // session Data 저장
        blSend.append("userId", sessionUser.getString("userId"));
        blSend.append("rstrId", sessionUser.getString("userId"));
        blSend.append("updrId", sessionUser.getString("userId"));
        blSend.append("corpCd", sessionUser.getString("corpCd"));
        
        
        // I고객사인터페이스관리Mgr.전송가능여부조회
        DataItem blSendInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbYn", blSend);
        
        // I고객사인터페이스관리Mgr.인터페이스ID채번
        DataItem ifIdKeygenCond = new DataItem();
        String ifItemId = "";
        String cstKindCd = "SRVO";

        if (!"71".equals(blSend.getString("docTypeCd"))) {
            ifIdKeygenCond.put("inIfId", "b2bFW2070"); // LGE(KIC)
            ifItemId = "b2bFW2070";
        } else {
            ifIdKeygenCond.put("inIfId", "b2bFW2040"); // LGE(KIC)
            ifItemId = "b2bFW2040";
        }
        ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
        ifIdKeygenCond.put("ifSndrId", "");
        ifIdKeygenCond.put("ifRcvrId", "");
        DataItem ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
        if (null == ifId || ifId.isEmpty() 
                || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                || "E".equals(ifId.getString("rtnCd")) ) {
                logger.error("#### saveFwdEdiMasterS Error :"+ifId.getString("rtnMsg"));
                throw new BizException("ngff.fwd.creatFail", "Interface ID");
        }
        
        
        // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
        DataItem fwIfContVo = new DataItem();
        fwIfContVo.put("blId", blSend.getString("blId"));
        fwIfContVo.put("taskSprCd", blSend.getString("taskSprCd"));
        fwIfContVo.put("ifId", ifId.getString("interfaceId"));
        fwIfContVo.put("ifSnglId", ifItemId);
        fwIfContVo.put("blNo", blSend.getString("blNo"));
        fwIfContVo.put("corpCd", blSend.getString("corpCd"));
        fwIfContVo.put("cstKindCd", cstKindCd);
        fwIfContVo.put("attrNm1", blSend.getString("srNo"));
        fwIfContVo.put("rstrId", blSend.getString("rstrId"));
        // 포워딩인터페이스상태등록
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
        
        // 포워딩인터페이스로그등록
        // BL_IF_LOG No을 채번한다.
        // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
        DataItem blIflog = new DataItem();
        blIflog.put("userId", sessionUser.getString("userId"));
        blIflog.put("exctSprCd", "FW");
        blIflog.put("keygenCd", "BL_IF_LOG");
        blIflog.put("keygenPrefix", "");
        blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
        
        DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
        if (null == blIflogInfo || blIflogInfo.isEmpty() 
            || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
            || "E".equals(blIflogInfo.getString("rtnCd")) ) {
            throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
        }
        
        String blIflogNo = blIflogInfo.getString("keyGenNo");
        fwIfContVo.put("logNo", blIflogNo);
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
        
        
        // I고객사인터페이스관리Mgr.LGE인터페이스테이블Cnt조회
        int ifTblCnt = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectLgEIfTblCnt", blSend).getInt("cnt");
        
        
        // I고객사인터페이스관리Mgr.LGE인터페이스테이블등록
        DataItem serveOneIfTblRegVo = new DataItem();
        serveOneIfTblRegVo.put("blId", blSend.getString("blId"));
        serveOneIfTblRegVo.put("interfaceId", ifId.getString("interfaceId"));
        serveOneIfTblRegVo.put("rstrId", blSend.getString("rstrId"));
        serveOneIfTblRegVo.put("corpCd", blSend.getString("corpCd"));
        
        if (!"71".equals(blSend.getString("docTypeCd"))) {
            
            DataItem serveoneBlInfoData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectServeoneBlInfoData", serveOneIfTblRegVo); 
            
            int regCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneBlInfo", serveoneBlInfoData);

            if (regCnt < 1) {
                throw new BizException("ngff.com.insert"); // 등록된 건이 0건이면 오류
            }

            // I고객사인터페이스관리Mgr.컨테이너 정보 등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneCntrInfo", serveOneIfTblRegVo);

            // I고객사인터페이스관리Mgr.서브원 참조번호 정보 등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneRefNoInfo", serveOneIfTblRegVo);

            if (!FwdConstants.FWD_EXT_SPR_CD_RAIL.equals(blSendInfo.getString("exctSprCd"))) { // 철송은 동기화 요청 하지 않음

                // IBL공통관리Prc.BL진행상태동기화요청
                DataItem blStatHistInfoVo = new DataItem();
                blStatHistInfoVo.put("closYn", "Y");
                blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
                blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
                blStatHistInfoVo.put("statCd", "500");
                blStatHistInfoVo.put("blId", blSend.getString("blId"));
                blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
                blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
                fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
            }
        } else {
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneChkBlInfo", serveOneIfTblRegVo);
        }
        
        
        // I고객사인터페이스관리Mgr.서브원 참조번호 정보 등록
        DataItem imgInfo = new DataItem();
        imgInfo.put("attr5", blSend.getString("blId"));
        imgInfo.put("rstrId", blSend.getString("rstrId"));
        imgInfo.put("docTypeCd", blSend.getString("docTypeCd"));
        imgInfo.put("docNo", blSend.getString("blNo"));
        imgInfo.put("fileFullPath", blSend.getString("fileFullPath"));
        imgInfo.put("fileName", blSend.getString("fileName"));
        imgInfo.put("fileLength", blSend.getString("fileLength"));
        
        
        // I고객사인터페이스관리Mgr.인터페이스ID채번
        DataItem imgIfIdKeygenCond = new DataItem();
        // String imgIfItemId = "b2bFW2080";
        imgIfIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
        imgIfIdKeygenCond.put("inIfId", "b2bFW2080");
        imgIfIdKeygenCond.put("ifSndrId", "687822338");
        imgIfIdKeygenCond.put("ifRcvrId", "SERVEONE");
        
        DataItem imgIfId = fwdCommonService.saveFwdEdiMasterS(imgIfIdKeygenCond);
        if (null == imgIfId || imgIfId.isEmpty() 
                || imgIfId.isNull("rtnCd") || imgIfId.getString("rtnCd").isEmpty() 
                || "E".equals(imgIfId.getString("rtnCd")) ) {
                logger.error("#### saveFwdEdiMasterS Error :"+imgIfId.getString("rtnMsg"));
                throw new BizException("ngff.fwd.creatFail", "Interface ID");
        }
        
        // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
        DataItem imgFwIfContVo = new DataItem();
        imgFwIfContVo.put("blId", blSend.getString("blId"));
        imgFwIfContVo.put("taskSprCd", blSend.getString("taskSprCd"));
        imgFwIfContVo.put("ifId", imgIfId.getString("interfaceId"));
        imgFwIfContVo.put("ifSnglId", "b2bFW2080");
        imgFwIfContVo.put("blNo", blSend.getString("blNo"));
        imgFwIfContVo.put("corpCd", blSend.getString("corpCd"));
        imgFwIfContVo.put("cstKindCd", cstKindCd);
        imgFwIfContVo.put("attrNm1", blSend.getString("srNo"));
        imgFwIfContVo.put("rstrId", blSend.getString("rstrId"));
        // 포워딩인터페이스상태등록
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", imgFwIfContVo);
        
        // 포워딩인터페이스로그등록
        // BL_IF_LOG No을 채번한다.
        // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
        DataItem blIflog2 = new DataItem();
        blIflog2.put("userId", sessionUser.getString("userId"));
        blIflog2.put("exctSprCd", "FW");
        blIflog2.put("keygenCd", "BL_IF_LOG");
        blIflog2.put("keygenPrefix", "");
        blIflog2.put("datePrefix", SeaDateUtils.getLocalDate() );
        
        DataItem blIflogInfo2= fwdKeygenService.createFwdAutoNo(blIflog2);
        if (null == blIflogInfo2 || blIflogInfo2.isEmpty() 
            || blIflogInfo2.isNull("rtnCd") || blIflogInfo2.getString("rtnCd").isEmpty() 
            || "E".equals(blIflogInfo2.getString("rtnCd")) ) {
            throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
        }
        
        String blIflogNo2 = blIflogInfo2.getString("keyGenNo");
        imgFwIfContVo.put("logNo", blIflogNo2);
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", imgFwIfContVo);
        
        String IfSeq =  mainDao.select("fwd.edi.fwdCstComIfMgnt.selectServeoneIfSeq", imgIfId).getString("interfaceSeq");
        
        imgInfo.put("interfaceId", imgIfId.getString("interfaceId"));
        imgInfo.put("interfaceSeq", IfSeq);
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneImgInfo", imgInfo);
                    
        prcsCnt++;
        
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     *  서브원 이미지 수신 목록 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectServeoneImgRecvList(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectServeoneImgRecvList", inData);
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    /**
     *  라인프렌즈 전송 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLfsSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLfsSendInfo", inData);
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    /**
     *  LGLS 전송 요청 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLglsReqSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLglsReqSendInfo", inData);
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    /**
     *  LGLS 전송 응답 정보 조회
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLglsResSendInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLglsResSendInfo", inData);
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    /**
     * 라인프렌즈 HBL전송
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLfsHbl(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        DataItem blSend = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( blSend == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        // session Data 저장
        blSend.append("userId", sessionUser.getString("userId"));
        blSend.append("rstrId", sessionUser.getString("userId"));
        blSend.append("updrId", sessionUser.getString("userId"));
        blSend.append("corpCd", sessionUser.getString("corpCd"));
        
        
        // I고객사인터페이스관리Mgr.전송가능여부조회
        DataItem blSendInfo = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectSendPosbYn", blSend);
        
        
        // I고객사인터페이스관리Mgr.인터페이스ID채번
        DataItem ifIdKeygenCond = new DataItem();
        String ifItemId = "";
        String cstKindCd = "LFS";

        ifIdKeygenCond.put("inIfId", "b2bFW2072"); // LGE(KIC)
        ifItemId = "b2bFW2072";
        
        ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
        ifIdKeygenCond.put("ifSndrId", "");
        ifIdKeygenCond.put("ifRcvrId", "");
        DataItem ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
        if (null == ifId || ifId.isEmpty() 
                || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                || "E".equals(ifId.getString("rtnCd")) ) {
                logger.error("#### saveFwdEdiMasterS Error :"+ifId.getString("rtnMsg"));
                throw new BizException("ngff.fwd.creatFail", "Interface ID");
        }
        
        
        // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
        DataItem fwIfContVo = new DataItem();
        fwIfContVo.put("blId", blSend.getString("blId"));
        fwIfContVo.put("taskSprCd", blSend.getString("taskSprCd"));
        fwIfContVo.put("ifId", ifId.getString("interfaceId"));
        fwIfContVo.put("ifSnglId", ifItemId);
        fwIfContVo.put("blNo", blSend.getString("blNo"));
        fwIfContVo.put("corpCd", blSend.getString("corpCd"));
        fwIfContVo.put("cstKindCd", cstKindCd);
        fwIfContVo.put("attrNm1", blSend.getString("srNo"));
        fwIfContVo.put("rstrId", blSend.getString("rstrId"));
        fwIfContVo.put("exctSprCd", blSend.getString("exctSprCd"));
        
        // 포워딩인터페이스상태등록
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", fwIfContVo);
        
        // 포워딩인터페이스로그등록
        // BL_IF_LOG No을 채번한다.
        // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
        DataItem blIflog = new DataItem();
        blIflog.put("userId", sessionUser.getString("userId"));
        blIflog.put("exctSprCd", "FW");
        blIflog.put("keygenCd", "BL_IF_LOG");
        blIflog.put("keygenPrefix", "");
        blIflog.put("datePrefix", SeaDateUtils.getLocalDate() );
        
        DataItem blIflogInfo = fwdKeygenService.createFwdAutoNo(blIflog);
        if (null == blIflogInfo || blIflogInfo.isEmpty() 
            || blIflogInfo.isNull("rtnCd") || blIflogInfo.getString("rtnCd").isEmpty() 
            || "E".equals(blIflogInfo.getString("rtnCd")) ) {
            throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
        }
        
        String blIflogNo = blIflogInfo.getString("keyGenNo");
        fwIfContVo.put("logNo", blIflogNo);
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", fwIfContVo);
        
        
        
        
        // I고객사인터페이스관리Mgr.LGE인터페이스테이블등록
        DataItem serveOneIfTblRegVo = new DataItem();
        serveOneIfTblRegVo.put("blId", blSend.getString("blId"));
        serveOneIfTblRegVo.put("interfaceId", ifId.getString("interfaceId"));
        serveOneIfTblRegVo.put("rstrId", blSend.getString("rstrId"));
        serveOneIfTblRegVo.put("corpCd", blSend.getString("corpCd"));
        serveOneIfTblRegVo.put("exctSprCd", blSend.getString("exctSprCd"));
        serveOneIfTblRegVo.put("lfsYn", "Y");
        
        DataItem serveoneBlInfoData = mainDao.select("fwd.edi.fwdCstComIfMgnt.selectServeoneBlInfoData", serveOneIfTblRegVo); 
        int regCnt = mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneBlInfo", serveoneBlInfoData);
        if (regCnt < 1) {
            throw new BizException("ngff.com.insert"); // 등록된 건이 0건이면 오류
        }
        
        // I고객사인터페이스관리Mgr.컨테이너 정보 등록
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneCntrInfo", serveOneIfTblRegVo);
        
        // I고객사인터페이스관리Mgr.서브원 참조번호 정보 등록
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLfsRefNoInfo", serveOneIfTblRegVo);
        
        
        
        if ( !FwdConstants.FWD_EXT_SPR_CD_RAIL.equals(blSendInfo.getString("exctSprCd")) &&
             !FwdConstants.FWD_EXT_SPR_CD_EXP.equals(blSendInfo.getString("exctSprCd"))   
           ) { // 철송은 동기화 요청 하지 않음

            // IBL공통관리Prc.BL진행상태동기화요청
            DataItem blStatHistInfoVo = new DataItem();
            blStatHistInfoVo.put("closYn", "Y");
            blStatHistInfoVo.put("corpCd", blSend.getString("corpCd"));
            blStatHistInfoVo.put("rstrId", blSend.getString("rstrId"));
            blStatHistInfoVo.put("statCd", "500");
            blStatHistInfoVo.put("blId", blSend.getString("blId"));
            blStatHistInfoVo.put("eoNo", blSend.getString("eoNo"));
            blStatHistInfoVo.put("soNo", blSend.getString("soNo"));
            fwdBlComnMgntService.requestBlProgStatSync(blStatHistInfoVo);
        }
        
        
        
        // I고객사인터페이스관리Mgr.인터페이스ID채번
        DataItem imgIfIdKeygenCond = new DataItem();
        // String imgIfItemId = "b2bFW2080";
        String imgCstKindCd = "LFS";
        imgIfIdKeygenCond.put("inIfId", "b2bFW2080");
        imgIfIdKeygenCond.put("ifSndrId", "687822338");
        imgIfIdKeygenCond.put("ifRcvrId", imgCstKindCd);
        
        imgIfIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
        
        DataItem imgIfId = fwdCommonService.saveFwdEdiMasterS_TEMP(imgIfIdKeygenCond);
        if (null == imgIfId || imgIfId.isEmpty() 
                || imgIfId.isNull("rtnCd") || imgIfId.getString("rtnCd").isEmpty() 
                || "E".equals(imgIfId.getString("rtnCd")) ) {
                logger.error("#### saveFwdEdiMasterS Error :"+imgIfId.getString("rtnMsg"));
                throw new BizException("ngff.fwd.creatFail", "Interface ID");
        }
        
        String IfSeq =  mainDao.select("fwd.edi.fwdCstComIfMgnt.selectServeoneIfSeq", imgIfId).getString("interfaceSeq");
        // I고객사인터페이스관리Mgr.서브원 참조번호 정보 등록
        DataItem imgInfo = new DataItem();
        imgInfo.put("attr5", blSend.getString("blId"));
        imgInfo.put("rstrId", blSend.getString("rstrId"));
        imgInfo.put("docTypeCd", blSend.getString("docTypeCd"));
        imgInfo.put("docNo", blSend.getString("blNo"));
        imgInfo.put("exctSprCd", blSend.getString("exctSprCd"));
        imgInfo.put("fileFullPath", blSend.getString("fileFullPath"));
        imgInfo.put("fileName", blSend.getString("fileName"));
        imgInfo.put("fileLength", blSend.getString("fileLength"));
        imgInfo.put("interfaceId", imgIfId.getString("interfaceId") );
        imgInfo.put("interfaceSeq", IfSeq);
        /* 20160725 서브원이랑 동일한 프로그램 사용 */
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneImgInfo", imgInfo); 
        
        
        // I고객사인터페이스관리Mgr.서브원 참조번호 정보 등록
        if (null != blSend.getString("fileName2") && !blSend.getString("fileName2").isEmpty()) {
            IfSeq =  mainDao.select("fwd.edi.fwdCstComIfMgnt.selectServeoneIfSeq", imgIfId).getString("interfaceSeq");
            DataItem imgInfo2 = new DataItem();
            imgInfo2.put("attr5", blSend.getString("blId"));
            imgInfo2.put("rstrId", blSend.getString("rstrId"));
            imgInfo2.put("docTypeCd", blSend.getString("docTypeCd2"));
            imgInfo2.put("docNo", blSend.getString("blNo"));
            imgInfo2.put("fileFullPath", blSend.getString("fileFullPath2"));
            imgInfo.put("exctSprCd", blSend.getString("exctSprCd"));
            imgInfo2.put("fileName", blSend.getString("fileName2"));
            imgInfo2.put("fileLength", blSend.getString("fileLength2"));
            imgInfo2.put("interfaceId", imgIfId.getString("interfaceId"));
            imgInfo2.put("interfaceSeq", IfSeq);
            /* 20160725 서브원이랑 동일한 프로그램 사용 */
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertServeoneImgInfo", imgInfo2); 
        }
        
        // 인터페이스 통합관리 및 응답여부 관리를 위한 오퍼레이션 추가 2013-03-26
        DataItem imgFwIfContVo = new DataItem();
        imgFwIfContVo.put("blId", blSend.getString("blId"));
        imgFwIfContVo.put("taskSprCd", blSend.getString("taskSprCd"));
        imgFwIfContVo.put("ifId", imgIfId.getString("interfaceId"));
        imgFwIfContVo.put("ifSnglId", "b2bFW2080");
        imgFwIfContVo.put("blNo", blSend.getString("blNo"));
        imgFwIfContVo.put("corpCd", blSend.getString("corpCd"));
        imgFwIfContVo.put("cstKindCd", cstKindCd);
        imgFwIfContVo.put("attrNm1", blSend.getString("srNo"));
        imgFwIfContVo.put("rstrId", blSend.getString("rstrId"));
        imgFwIfContVo.put("exctSprCd", blSend.getString("exctSprCd"));
        // 포워딩인터페이스상태등록
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfStatus", imgFwIfContVo);
        
        // 포워딩인터페이스로그등록
        // BL_IF_LOG No을 채번한다.
        // AS-IS Query의  FC_FW_GET_NO('BL_IF_LOG') 해당하는 부분이다.
        DataItem blIflog2 = new DataItem();
        blIflog2.put("userId", sessionUser.getString("userId"));
        blIflog2.put("exctSprCd", "FW");
        blIflog2.put("keygenCd", "BL_IF_LOG");
        blIflog2.put("keygenPrefix", "");
        blIflog2.put("datePrefix", SeaDateUtils.getLocalDate() );
        
        DataItem blIflogInfo2= fwdKeygenService.createFwdAutoNo(blIflog2);
        if (null == blIflogInfo2 || blIflogInfo2.isEmpty() 
            || blIflogInfo2.isNull("rtnCd") || blIflogInfo2.getString("rtnCd").isEmpty() 
            || "E".equals(blIflogInfo2.getString("rtnCd")) ) {
            throw new BizException("ngff.fwd.creatFail", "BL_IF_LOG");
        }
        
        String blIflogNo2 = blIflogInfo2.getString("keyGenNo");
        imgFwIfContVo.put("logNo", blIflogNo2);
        mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertFwdIfLog", imgFwIfContVo);
        
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    /**
     *  LG상사 수출 BL 조회 요청
     * @author 박종세
     * @param param
     * @return
     */
    public DataItem selectLgiElecSalesInfo(DataItem param) {
        DataItem resObj = new DataItem();
        DataItem inData = param.getDataItem("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        inData.append("corpCd", sessionUser.getString("corpCd"));
        
        
        List<DataItem> outList = mainDao.selectList("fwd.edi.fwdCstComIfMgnt.selectLgiElecSalesInfo", inData);
        
        // AS-IS Query의  FC_FW_GET_NO('LGIBLIMAGE', FI.BL_NO)    AS RQST_FILE_NM 부분을 구현한다.
        // 결과 데이터의 BL No를 이용하여 RQST_FILE_NM를 생성한 후에 원래의 데이터에 값을 입력한다.
        for (DataItem item : outList) {
         // FILE_NM채번해서 파라미터로 전송. AS-IS에서는 Query에서 직접 채번하고 있음
            DataItem fileNmCrt = new DataItem();
            fileNmCrt.put("userId", sessionUser.getString("userId"));
            fileNmCrt.put("exctSprCd", "FW");
            fileNmCrt.put("keygenCd", "LGIBLIMAGE");
            fileNmCrt.put("keygenPrefix", item.get("blNo"));
            fileNmCrt.put("datePrefix", SeaDateUtils.getLocalDateTime() );
            DataItem fileNmInfo = fwdKeygenService.createFwdAutoNo(fileNmCrt);
            if (null == fileNmInfo || fileNmInfo.isEmpty() 
                || fileNmInfo.isNull("rtnCd") || fileNmInfo.getString("rtnCd").isEmpty() 
                || "E".equals(fileNmInfo.getString("rtnCd")) ) {
                throw new BizException("ngff.fwd.creatFail", "LGIBLIMAGE");
            }
            logger.debug("#### fileNm : " + fileNmInfo.getString("keyGenNo") );
            item.put("rqstFileNm", fileNmInfo.getString("keyGenNo"));
        }
        
        resObj.put("dlt_resultList", outList);
        return resObj;
    }
    
    
    /**
     * LG상사 수출 BL 전송 요청
     * @author 박종세
     * @param paramList
     * @return
     */
    public DataItem sendLgiElecSalesInfo(DataItem param) {
        int prcsCnt = 0; // 처리 건수
        DataItem resObj = new DataItem();
        List<DataItem> inData = param.getList("inData");
        DataItem sessionUser = SessionThreadLocal.get();
        
        if ( inData == null) {
            resObj.put("prcsCnt", prcsCnt);
            return resObj;
        }
        
        for ( DataItem blSend : inData) {
            
            logger.debug("#### [sendLgiElecSalesInfo] blSend:"+ blSend.toJson());
            // session Data 저장
            blSend.append("userId", sessionUser.getString("userId"));
            blSend.append("rstrId", sessionUser.getString("userId"));
            blSend.append("updrId", sessionUser.getString("userId"));
            blSend.append("corpCd", sessionUser.getString("corpCd"));
         
            // BATCH용 USER ID
            blSend.put("ifSingleId", "b2bFW1131");
            blSend.put("ftpTargetId", "FW");
            
            
            // 1. I고객사인터페이스관리Mgr.인터페이스ID채번
            DataItem ifIdKeygenCond = new DataItem();
            ifIdKeygenCond.put("inIfId", blSend.getString("ifSingleId"));
            ifIdKeygenCond.put("moduleCd", "FWD"); // 각 모듈별 식별자(예 : SMT, FWD, ISM 등)
            ifIdKeygenCond.put("ifSndrId", "");
            ifIdKeygenCond.put("ifRcvrId", "");
            DataItem ifId = fwdCommonService.saveFwdEdiMasterS(ifIdKeygenCond);
            if (null == ifId || ifId.isEmpty() 
                    || ifId.isNull("rtnCd") || ifId.getString("rtnCd").isEmpty() 
                    || "E".equals(ifId.getString("rtnCd")) ) {
                    logger.error("#### srchDt:"+ifId.getString("rtnMsg"));
                    throw new BizException("ngff.fwd.creatFail", "Interface ID");
            }
            
            blSend.put("interfaceId", ifId.getString("interfaceId"));
            blSend.put("blFileName", blSend.getString("rqstFileNm"));
            blSend.put("statusCode", "META");
            blSend.put("atchYn", "Y");
            
            // 2. I고객사인터페이스관리Mgr.LG상사수출BL전송기본등록
            mainDao.insert("fwd.edi.fwdCstComIfMgnt.insertLgiElecSalesEdiSend", blSend);
            
            // 3. 이미지전송요청
            this.requestImgSend(blSend);
            
            
            prcsCnt++;
        } // For End
            
        resObj.put("prcsCnt", prcsCnt);
        return resObj;
    }
    
    
    
    
}
