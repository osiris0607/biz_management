package com.anchordata.webframework.controller.admin.calculation;



import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.agreement.AgreementSearchVO;
import com.anchordata.webframework.service.agreement.AgreementVO;
import com.anchordata.webframework.service.calculation.CalculationSearchVO;
import com.anchordata.webframework.service.calculation.CalculationService;
import com.anchordata.webframework.service.calculation.CalculationVO;


@Controller("AdminCalculationController")
public class AdminCalculationController {
	
	@Autowired
	private CalculationService calculationService;
	
	/**
	*  협약 메인 Page
	*/
	@RequestMapping("/admin/fwd/calculation/main")
	public ModelAndView fwdMain(@ModelAttribute CalculationVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("calculation/main.admin");
		return mv;
	}
	/**
	*  협약 상세 Page
	*/
	@RequestMapping("/admin/fwd/calculation/search/detail")
	public ModelAndView fwdDetail(@ModelAttribute CalculationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("calculation/detail.admin");
		return mv;
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 수행  List
	*/
	@RequestMapping("/admin/api/calculation/search/paging")
		public ModelAndView searchPagingList(@ModelAttribute CalculationSearchVO vo, ModelAndView mv) throws Exception {
		List<CalculationVO> resList = calculationService.searchPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
		} else {
			mv.addObject("result", false);
			mv.addObject("total_count", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  수행 상세
	*/
	@RequestMapping("/admin/api/calculation/search/detail")
	public ModelAndView detail(@ModelAttribute CalculationSearchVO vo, ModelAndView mv) throws Exception {
		CalculationVO result = calculationService.searchDetail(vo);
		if (result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* Status 변경
	*/
	@RequestMapping("/admin/api/calculation/status/modification")
	public ModelAndView modificationStatus(@ModelAttribute CalculationVO vo, ModelAndView mv) throws Exception {
		int result = calculationService.statusModification(vo);
		if (result > 0) {
			mv.addObject( "result", true );
		} else {
			mv.addObject( "result", false );
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	/*
	* 엑셀 다운로드
	*/
	@RequestMapping("/admin/api/calculation/excelDownload")
	public void excelDownload(@ModelAttribute CalculationSearchVO vo, HttpServletResponse response) throws Exception {
		//전체 회원 정보 
		List<CalculationVO> resList = calculationService.searchExcelDownload(vo);
		
		// Make Excel File
		// 워크북 생성
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("평가정보");
	    Row row = null;
	    Cell cell = null;
	    int rowNo = 0;


	    // 테이블 헤더용 스타일
	    CellStyle headStyle = wb.createCellStyle();
	    headStyle.setBorderTop(BorderStyle.THIN);
	    headStyle.setBorderBottom(BorderStyle.THIN);
	    headStyle.setBorderLeft(BorderStyle.THIN);
	    headStyle.setBorderRight(BorderStyle.THIN);

	    // 배경색 노란색
	    headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
	    headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    // 데이터는 가운데 정렬합니다.
	    headStyle.setAlignment(HorizontalAlignment.CENTER);

	    // 데이터용 경계 스타일 테두리만 지정
	    CellStyle bodyStyle = wb.createCellStyle();
	    bodyStyle.setBorderTop(BorderStyle.THIN);
	    bodyStyle.setBorderBottom(BorderStyle.THIN);
	    bodyStyle.setBorderLeft(BorderStyle.THIN);
	    bodyStyle.setBorderRight(BorderStyle.THIN);

	    // 헤더 생성
	    row = sheet.createRow(rowNo++);
	    cell = row.createCell(0);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("과제번호");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("사업명");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("공고명");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("기술명");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구기관");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구책임자");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구기간");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구비");
	    cell = row.createCell(8);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("상태");
	    
	    // 데이터 부분 생성
	    for(CalculationVO listVO : resList) {
	        row = sheet.createRow(rowNo++);
	        
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAgreement_reg_number());

	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_business_name() );

	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_title());
	        
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getTech_info_name());
	        
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getInstitution_name());
	        
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearcher_name());
	        
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearch_date());
	        
	        cell = row.createCell(7);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearch_funds());
	        
	        cell = row.createCell(8);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getCalculation_status());
	    }
	    
	    // 컨텐츠 타입과 파일명 지정
	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename=calculation_info.xls");

	    // 엑셀 출력
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	
	
}
