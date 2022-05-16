package com.anchordata.webframework.controller.admin.execution;



import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
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

import com.anchordata.webframework.service.execution.ExecutionSearchVO;
import com.anchordata.webframework.service.execution.ExecutionService;
import com.anchordata.webframework.service.execution.ExecutionVO;


@Controller("AdminExecutionController")
public class AdminExecutionController {
	
	@Autowired
	private ExecutionService executionService;
	
	/**
	*  협약 메인 Page
	*/
	@RequestMapping("/admin/fwd/execution/main")
	public ModelAndView fwdMain(@ModelAttribute ExecutionVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("execution/main.admin");
		return mv;
	}
	/**
	*  협약 상세 Page
	*/
	@RequestMapping("/admin/fwd/execution/search/detail")
	public ModelAndView fwdDetail(@ModelAttribute ExecutionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("execution/detail.admin");
		return mv;
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 수행  List
	*/
	@RequestMapping("/admin/api/execution/search/paging")
		public ModelAndView searchPagingList(@ModelAttribute ExecutionSearchVO vo, ModelAndView mv) throws Exception {
		List<ExecutionVO> resList = executionService.searchPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("total_count", resList.get(0).getTotal_count());
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
	@RequestMapping("/admin/api/execution/search/detail")
	public ModelAndView detail(@ModelAttribute ExecutionSearchVO vo, ModelAndView mv) throws Exception {
		ExecutionVO result = executionService.searchDetail(vo);
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
	* 변경
	*/
	@RequestMapping("/admin/api/execution/changeHistory/registration")
	public ModelAndView modification(@ModelAttribute ExecutionVO vo, ModelAndView mv) throws Exception {
		int result = executionService.changeHistoryRegistration(vo);
		if (result > 0 ) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
		
	}

	/*
	* 엑셀 다운로드
	*/
	@RequestMapping("/admin/api/execution/excelDownload")
	public void excelDownload(@ModelAttribute ExecutionSearchVO vo, HttpServletResponse response) throws Exception {
		//전체 회원 정보 
		List<ExecutionVO> resList = executionService.searchExcelDownload(vo);
		
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
	    cell.setCellValue("접수번호");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("과제번호");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("사업명");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("공고명");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("기술명");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구기관");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구책임자");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구기간");
	    cell = row.createCell(8);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("연구비");
	    cell = row.createCell(9);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("중간보고서");
	    cell = row.createCell(10);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("최종보고서");
	    cell = row.createCell(11);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("변경이력");
	    
	    // 데이터 부분 생성
	    for(ExecutionVO listVO : resList) {
	        row = sheet.createRow(rowNo++);
	        
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getReception_reg_number());

	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAgreement_reg_number() );

	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_business_name());
	        
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_title());
	        
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getTech_info_name());
	        
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getInstitution_name());
	        
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearcher_name());
	        
	        cell = row.createCell(7);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearch_date());
	        
	        cell = row.createCell(8);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearch_funds());
	        
	        cell = row.createCell(9);
	        cell.setCellStyle(bodyStyle);
	        if ( StringUtils.isEmpty(listVO.getMiddle_report_date()))
	        {
	        	cell.setCellValue("미제출");
	        }
	        else
	        {
	        	cell.setCellValue("제출(" + listVO.getMiddle_report_date() + ")");
	        }
	        
	        cell = row.createCell(10);
	        cell.setCellStyle(bodyStyle);
	        if ( StringUtils.isEmpty(listVO.getFinal_report_date()))
	        {
	        	cell.setCellValue("미제출");
	        }
	        else
	        {
	        	cell.setCellValue("제출(" + listVO.getFinal_report_date() + ")");
	        }
	        
	        cell = row.createCell(11);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getChanges_count());
	        
	        
	    }
	    
	    // 컨텐츠 타입과 파일명 지정
	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename=execution_info.xls");

	    // 엑셀 출력
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	

	
	
}
