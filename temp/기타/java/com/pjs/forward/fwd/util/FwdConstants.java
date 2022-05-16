package com.lxpantos.forwarding.fwd.util;

/**
 * 포워딩(FW)에서 상수로 사용할 값들을 정의한다. 주석 필수
 * 변수명은 반드시 대문자_대문자_... 의 형대로 static 변수로 만든다.
 * FW_컬럼명 - 기본
 * FW_테이블_컬럼명 - 필요시
 */

public class FwdConstants {

    public static final String FW_FC_GBN_STEP = "STEPID"; // ?

    /* 항공 */
    public static final String FWD_AWB_STOCK_STAT_CD = "0271"; //AWB NO STOCK 상태 CLAS ID
    public static final String FWD_AWB_STOCK_STAT_USABLE = "1"; //사용가능
    public static final String FWD_AWB_STOCK_STAT_BOOKED = "2"; //예약중
    public static final String FWD_AWB_STOCK_STAT_USED = "3";  // 사용중
    public static final String FWD_AWB_STOCK_STAT_VOID = "4";  // 미사용중(AWB 채번 후 BL 생성 안함)
    public static final String FWD_AWB_STOCK_STAT_UNUSABLE = "5"; // 사용불가

    public static final String FWD_AIR_BL_NO_STOCK_MBL_SPR_CD = "0272"; //AWB NO STOCK 유형 CLAS ID
    public static final String FWD_AIR_CONSOL = "CONSOL"; // CONSOL
    public static final String FWD_AIR_DECONSOL = "DECONSOL"; // DECONSOL

    public static final String FWD_AIR_STEP_EXE_INIT = "100";// 실행착수
    public static final String FWD_AIR_STEP_BL_CHG = "120";// BL전환
    public static final String FWD_AIR_STEP_WM_REAL = "125";// 중량실측
    public static final String FWD_AIR_STEP_HBL_CLOSE = "130";// HBL 마감
    public static final String FWD_AIR_STEP_HBL_PRINT = "150";// HBL 발행
    public static final String FWD_AIR_STEP_CONSOL = "200";// 특정 MBL로 Consol된 시점
    public static final String FWD_AIR_STEP_DECONSOL = "205";// DEConsol된 시점(Deconsol시 HBL의 상태를 HBL생성상태(110)로 변경하기 위한 임시 상태 (20211213)
    public static final String FWD_AIR_STEP_CONSOL_CLOSE = "210";// MBL의 Consol Close된 시점
    public static final String FWD_AIR_STEP_MBL_CLOSE = "240";// MBL의 중량 마감처리 시점
    public static final String FWD_AIR_STEP_MBL_PRINT = "250";// 선적용 MBL 발행시점
    public static final String FWD_AIR_STEP_FIELD_CLOSE = "260";// Field Close
    public static final String FWD_AIR_STEP_ROLECONF_TRD = "310";// Role Confirm(중계)
    public static final String FWD_AIR_STEP_ROLECONF_IMP = "315";// Role Confirm(도착)
    public static final String FWD_AIR_STEP_EXP_MFST = "400";// 수출적하목록신고
    public static final String FWD_AIR_STEP_IMP_MFST = "410";// 수입적하목록신고
    public static final String FWD_AIR_STEP_SHPR_BL_SEND = "500";// 송화주BL전송
    public static final String FWD_AIR_STEP_CNEE_BL_CLOSE = "510";// 수화주BL전송

    public static final String FWD_AIR_TODO_POPUP_USE_YN  = "Y";
    public static final String FWD_AIR_REPORT_DG_SIGN  = "ozp://air/img/36206.gif";


    /* BL 상태 */
    public static final String FWD_AIR_STEP_HBL_REG = "110";// HBL생성
    public static final String FWD_AIR_STEP_HBL_CHG = "120";// BL NO 변경
    public static final String FWD_AIR_STEP_WGT_CLOSE = "130"; // WGT 변경
    public static final String FWD_AIR_STEP_BL_SWITCH = "160";// SWITCH
    public static final String FWD_AIR_STEP_ONBR_CLOSE = "300"; // ONBR 변경
    public static final String FWD_AIR_STEP_ARR_CLOSE = "320"; // ARR 변경
    public static final String FWD_AIR_STEP_BL_MODIFY = "330";// 수입BL변경
    public static final String FWD_AIR_STEP_ETA_CHG = "340";// ETA 변경

    public static final String FWD_BLSPRCD_H = "H"; // BL구분코드 HBL
    public static final String FWD_BLSPRCD_D = "D"; // BL구분코드 DBL

    /* MAWB 코드 */
    public static final String FWD_MAWB_STOCK_STATUS_CD = "0271"; // MAWB Stock 상태코드
    public static final String FWD_MAWB_STOCK_STATUS_USABLE = "1";
    public static final String FWD_MAWB_STOCK_STATUS_BOOKED = "2";
    public static final String FWD_MAWB_STOCK_STATUS_USED = "3";
    public static final String FWD_MAWB_STOCK_STATUS_VOID = "4";
    public static final String FWD_MAWB_STOCK_STATUS_UNUSABLE = "5";

    public static final String FWD_MAWB_TYPE_CD = "0272"; // MAWB종류코드
    public static final String FWD_COMPANY_CD = "0240"; // COMPANY 코드
    public static final String FWD_PRT_BUY_RATE_KIND_CD = "0283";// RATE CLASS 코드
    public static final String FWD_BUY_WGT_UNIT_CD = "0075";// 중량 단위 코드
    public static final String FWD_BIZ_UNIT_CD = "0025"; // BIZ_UNIT_CD
    public static final String FWD_BOUND_CD = "0319";
    public static final String FWD_MSTR_WRK_GRP_CD = "0299";

    /* 항공 여기까지 */


    /* 해상 */
    public static final String FWD_OC_STEP_ONBR_CLOSE = "300"; // ONBR 변경
    public static final String FWD_OC_STEP_EXE_INIT = "100";// 실행착수
    public static final String FWD_OC_STEP_HBL_REG = "110";// HBL생성
    public static final String FWD_OC_STEP_BL_SWITCH = "160";// SWITCH
    public static final String FWD_OC_STEP_BL_MODIFY = "330";// 수입BL변경
    public static final String FWD_OC_STEP_ETA_CHG = "340";// ETA 변경
    public static final String FWD_OC_STEP_BL_CHG = "120";// BL전환
    public static final String FWD_OC_STEP_HBL_PRINT = "150";// HBL 발행
    public static final String FWD_OC_STEP_MBL_REG = "230";// MBL생성
    public static final String FWD_OC_STEP_MBL_CLOSE = "305";// MBL Close
    public static final String FWD_OC_STEP_ARR_CLOSE = "320";// Arrival Close
    public static final String FWD_OC_STEP_EXP_MFST = "400";// 수출적하목록신고
    public static final String FWD_OC_STEP_IMP_MFST = "410";// 수입적하목록신고

    public static final String OC_STEP_HBL_CLOSE = "130";// HBL 마감
    public static final String OC_STEP_EXE_INIT = "100";// 실행착수
    public static final String OC_STEP_HBL_REG = "110";// HBL생성
    public static final String OC_STEP_BL_CHG = "120";// BL전환
    public static final String OC_STEP_HBL_PRINT = "150";// HBL 발행
    public static final String OC_STEP_BL_SWITCH = "160";// SWITCH
    public static final String OC_STEP_SR_REG = "220";// SR생성
    public static final String OC_STEP_MBL_REG = "230";// MBL생성
    public static final String OC_STEP_ONBR_CLOSE = "300";// OnBoard Close
    public static final String OC_STEP_MBL_CLOSE = "305";// MBL Close
    public static final String OC_STEP_ROLECONF_TRD = "310";// Role Confirm(중계)
    public static final String OC_STEP_ROLECONF_IMP = "315";// Role Confirm(도착)
    public static final String OC_STEP_ARR_CLOSE = "320";// Arrival Close
    public static final String OC_STEP_ETA_CHG = "340";// ETA 변경
    public static final String OC_STEP_EXP_MFST = "400";// 수출적하목록신고
    public static final String OC_STEP_IMP_MFST = "410";// 수입적하목록신고
    public static final String OC_STEP_SHPR_BL_SEND = "500";// 송화주BL전송
    public static final String OC_STEP_CNEE_BL_CLOSE = "510"; // 수화주BL전송

    public static final String FWD_SEA_HBL_REPORT_CD = "0574";// HBL Report
    public static final String FWD_AIR_MBL_REPORT_CD = "0533"; // 항공 MBL 리포트 양식
    public static final String FWD_AIR_HBL_REPORT_CD = "0572"; // 항공 HBL 리포트 양식
    public static final String FWD_SEA_BL_REPORT_LIST_CD = "1356";// Sea BL Report List
    public static final String FWD_SEA_MBL_REPORT_CD = "0573";//MBL Report List


    public static final String FWD_EXT_SPR_CD_SEA = "OC"; // 해상
    public static final String FWD_EXT_SPR_CD_AIR = "AR"; // 항공
    public static final String FWD_EXT_SPR_CD_EXP = "EX"; // 특송
    public static final String FWD_EXT_SPR_CD_RAIL = "RL"; // 철도

    public static final String FWD_CARR_HANJIN = "1005815"; // 한진해운

    public static final String FWD_SR_IF_GUBUN = "6LJ"; // SR 인터페이스 구분 코드
    public static final String FWD_DSR_IF_GUBUN = "340"; // DSR 인터페이스 구분 코드

    public static final String FWD_IF_GUBUN_SEND = "9"; // 인터페이스 구분 최초수신
    public static final String FWD_IF_GUBUN_RESEND = "4"; // 인터페이스 구분 재수신
    public static final String FWD_IF_GUBUN_CANCEL = "1"; // 인터페이스 구분 취소

    public static final String FWD_SO_UI_SPR_CD_NOMAL = "NE";
    public static final String FWD_SO_UI_SPR_CD_DBL = "DE";

    /* 해상 여기까지 */

    /* 공통 */
    public static final String FWD_LADG_TYPE = "0064"; // 적재유형코드(2012.01.30 / '0036' 삭제예정으로 '0064' 로변경)
    public static final String FWD_INCOTERMSCD = "0007"; // INCOT코드
    public static final String FWD_REFNUM_SPRCD = "0048"; // 참조번호구분코드
    public static final String FWD_PRT_KIND_CD = "0245"; // 발행종류코드

    public static final String TASK_SPR_EXP = "EXP"; // 역할구분 선적지
    public static final String TASK_SPR_IMP = "IMP"; // 역할구분 도착지
    public static final String TASK_SPR_TRD = "TRD"; // 역할구분 중계지
    public static final String TASK_SPR_ADJ = "ADJ"; // 역할구분 정산지

    public static final String GRID_CHECKED = "Y"; //그리드 체크 박스 체크
    public static final String GRID_NONCHECKED = "N"; //그리드 체크 박스 체크 해제

    public static final String SYS_CD_FW = "FW"; // 템코드 - 포워딩
    public static final String COMMON_Y = "Y"; // 공통 Y:N
    public static final String COMMON_N = "N";
    public static final String FWD_ROUTE_SPRCD = "0076"; // ROUTE
    public static final String FWD_CNTR_SIZE_CD = "0228"; // CNTR_TYPE_CD 컨테이너 크기유형
    public static final String FWD_CNTR_TYPE_CD = "0232"; // CNTR_TYPE_CD 컨테이너 타입코드
    public static final String FWD_LDNGCOND_CD = "0130";
    public static final String FWD_FRGTTERM_CD = "0122"; // 운임지급조건코드

    public static final String FWD_CORP_KR = "A100";
    public static final String FWD_CORP_UL = "E200";

    public static final String FWD_MNSFT_TERM_TYPE = "0130"; // 적하양하TERM유형

    public static final String FW_BOUND_CD = "0319";
    /* 공통 여기까지 */


    public static final String FWD_POL_LEAD_TIME = "1099";

    public static final String FWD_FC_GBN_STEP = "STEPID";


    public static final String FWD_RMK_SPRCD = "0050"; //적요구분코드


    public static final String FWD_OC_RAIL_SYNC = "295"; // 해상철송동기화

    /** 통합SUB종류코드 - 참조번호 */
    public static final String INTG_SUB_TYPE_REF = "REF";

    public static final String FWD_LGE_BIZPTNR_GRP_CD = "1001001";

    public static final String FWD_TASK_SPRCD = "0031"; // 역할구분

    public static final String FWD_OFICR_SPRCD = "0047"; // 담당자구분코드

    public static final String FWD_UNIT_CD = "0134"; // 단위코드

    public static final String FWD_TS_TYPECD = "0238"; // 환적유형코드

    public static final String FWD_ADDSVC_SPRCD = "0049"; // 부가서비스구분코드

    public static final String FWD_INTG_UNIT_CD = "0405";

    public static final String FWD_BULK_TYPE_CD = "0065";

    public static final String FWD_HBL_CNTR_DUP = "1171";

    public static final String FWD_NOT_USE_PTNR = "1091";

    public static final String FWD_FNS_PTNR_CD = "1170";

    public static final String FWD_MNFST_MDF_TYPE = "1107";

    public static final String FWD_MNFST_PIC_TYPE = "1108";

    public static final String FWD_MNFST_MDF_ATCL = "1109";

    public static final String FWD_MNFST_MDF_RESN = "1110";

    public static final String FWD_SERVONE_RPRS_BIZPTNR_CD = "1004292";


    //거래처 그룹
    public static final String BIZPTNR_GRP_CD_LGE = "1001001";
    public static final String BIZPTNR_GRP_CD_LGC = "1001010";
    public static final String BIZPTNR_GRP_CD_LGES = "1008002"; // LGES Group Code // [프로젝트]LGC 전지사업부 분사 (LGES)
    public static final String BIZPTNR_CD_LGC_HQ = "2000210"; // (주)엘지화학/본사 - 특송 Department 필수 위해 추가
    public static final String BIZPTNR_CD_LGES_HQ = "2240609"; // LGES Main


}
