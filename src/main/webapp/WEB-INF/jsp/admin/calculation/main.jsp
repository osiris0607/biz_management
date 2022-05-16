<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		displayMain();
		// 평가 목록
		searchList(1); 
	});

	/*******************************************************************************
	* FUNCTION 명 : displayMain
	* FUNCTION 기능설명 : announcement_type과 classification에 따라서 달라지는 화면을 그린다.
	*******************************************************************************/
	function displayMain() {
		if ( "${vo.announcement_type}" == "D0000005" ) {
			$("#left_menu_match").addClass("active");
			$(".location_name").text("기술매칭");
		} else if ( "${vo.announcement_type}" == "D0000004" ) {
			$("#left_menu_proposal").addClass("active");
			$(".location_name").text("기술재안");
			$("#li_evaluation_match").hide();
		} else if ( "${vo.announcement_type}" == "D0000003" ) {
			$("#left_menu_contest").addClass("active");
			$(".location_name").text("기술공모");
			$("#li_evaluation_match").hide();
		}
	}

	/*******************************************************************************
	* FUNCTION 명 : searchList
	* FUNCTION 기능설명 : 협약 정보 리스트를 가져온다.
	*******************************************************************************/
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/calculation/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE");

		// 연구 기관
		comAjax.addParam("research_date", $("#research_date").val());
		// 상태
		comAjax.addParam("calculation_status", $("#calculation_status_selector").val());
		// 검색어
		comAjax.addParam("search_text", $("#search_text").val());
		// 공고 Type
		comAjax.addParam("announcement_type", "${vo.announcement_type}");
		
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);

		var body = $("#list_body");
		body.empty();
		var total = 0;
		if ( data.result_data != null && data.result_data.length > 0) {
			total = data.result_data[0].total_count;
		}
		if (total == 0) {
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPagingMain(params);
			
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var index = 1;
			var str = "";

			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td><input type='checkbox' name='data_checkbox' status='" + value.calculation_status + "' value=" + value.calculation_id + "><label>&nbsp;</label></td>";
				str += "	<td><span>"+ value.agreement_reg_number + "</span></td>";
				str += "	<td><span>"+ value.announcement_business_name + "</span></td>";
				str += "	<td><span>"+ value.announcement_title + "</span></td>";

				if ( value.calculation_status == "미정산") {
					str += "<td><span>" + value.tech_info_name + "</span></td>";
				} else if ( value.calculation_status == "정산입력") { 
					str += "<td><span>" + value.tech_info_name + "</span></td>";
				} else if ( value.calculation_status == "제출완료") {
					str += "	<td><a href='javascript:void(0)' onclick='onMoveDetail(\"" + value.calculation_id + "\");' class='long_name'><span>"+ value.tech_info_name + "</span></a></td>";
				} else {
					str += "	<td><a href='javascript:void(0)' onclick='onMoveDetail(\"" + value.calculation_id + "\");' class='long_name'><span>"+ value.tech_info_name + "</span></a></td>";
				}
				
				str += "	<td><span>"+ value.institution_name + "</span></td>";
				str += "	<td><span>"+ value.researcher_name + "</span></td>";
				str += "	<td><span>" + value.research_date + "</span></td>";
				str += "	<td><span>" + value.research_funds + "</span></td>";

				if ( value.calculation_status == "미정산") {
					str += "<td><span>" + value.calculation_status + "</span></td>";
				} else if ( value.calculation_status == "정산 입력") { 
					str += "<td><a href='javascript:void(0);' onclick='onMoveDetail(\"" + value.calculation_id + "\");'><span class='font_blue'>" + value.calculation_status + "</span></a></td>";
				} else if ( value.calculation_status == "제출완료") {
					str += "<td><a href='javascript:void(0);' onclick='onMoveDetail(\"" + value.calculation_id + "\");'>제출완료</a></td>";
				} else {
					str += "<td><a href='javascript:void(0);' onclick='onMoveDetail(\"" + value.calculation_id + "\");'><span class='font_blue'>" + value.calculation_status + "</span></a></td>";
				}
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}


	function activateCalculation()
	{
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}

		var isOK = true;
		var activateCalculationIdList = new Array();
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("status") != "미정산" ) {
				alert("미정산된 과제만 활성화 시킬 수 있습니다.");
				isOK = false;
				return false;
			}
			activateCalculationIdList.push( $(this).val() );
		});

		if ( isOK == false) {
			return;
		}

		var formData = new FormData();
		formData.append("activate_calculation_id_list", activateCalculationIdList);
		formData.append("calculation_status", "정산입력");
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/calculation/status/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		            alert("활성화 되었습니다.");
		            location.reload();
		        } else {
		            alert("활성화에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function checkAllBox() {
		if($("#computeallCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".compute_list_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".compute_list_table input[type=checkbox]").prop("checked",false); 
		} 
	}

	/*******************************************************************************
	* 상세 페이지 이동
	*******************************************************************************/
	function onMoveDetail(id) {
		location.href="/admin/fwd/calculation/search/detail?calculation_id=" + id + "&announcement_type=" + "${vo.announcement_type}";
	}

	/*******************************************************************************
	* FUNCTION 명 : onMoveAgreementPage
	* FUNCTION 기능설명 : 평가관리 사이트로 이동한다. (기술매칭/기술공모/기술제안)
	*******************************************************************************/
	function onMoveCalculationPage(evaluationType){
		// 기술매칭/기술공모/기술제안은 URL로 구분
		location.href = "/admin/fwd/calculation/main?announcement_type=" + evaluationType;
	}

	
	function downloadExcelFile() {
		if (confirm('다운로드하시겠습니까?')) {
			location.href = "/admin/api/calculation/excelDownload?announcement_type=${vo.announcement_type}";
		}
	}
	
</script>
            
<div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                   <!--left menu 서브 메뉴-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- 레프트 메뉴 서브 타이틀 -->	
					       <div class="lnb_title_area">
						       <h2 class="title">정산관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->					   
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="javascript:void(0)" onclick="onMoveCalculationPage('D0000005');" title="수행관리">정산관리</a></li>
								   <li class="menu2depth">
									   <ul>
										   <li id="left_menu_match"><a href="javascript:void(0)" onclick="onMoveCalculationPage('D0000005');">기술매칭</a></li>
										   <li id="left_menu_contest"><a href="javascript:void(0)" onclick="onMoveCalculationPage('D0000003');">기술공모</a></li>
										   <li id="left_menu_proposal"><a href="javascript:void(0)" onclick="onMoveCalculationPage('D0000004');">기술제안</a></li>
									   </ul>
								   </li>
							   </ul>				
						   </div>	
					   </div>			
				   </div>
				   <!--left menu 서브 메뉴-->

				   <!--본문시작-->
                   <div class="contents">
                       <div class="location_area">
					       <div class="location_division">
							   <!--페이지 경로-->
					           <ul class="location clearfix">
							       <li><a href="javascript:void(0)" onclick="onMoveCalculationPage('D0000005');"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>정산관리</li>
								   <li><strong class="location_name">기술매칭</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area location_name">기술매칭</h3>
							  <!--//페이지타이틀-->
						   </div>
					   </div>
					   
                       <div class="contents_view">                           
							<!--<h4 class="sub_title_h4 mb10">접수 목록</h4>    -->
					        <!--접수 목록-->
							<div class="list_top_txt">
								<ol>
									<li>1. 협약을 위해 계획서 및 협약내용에 대한 최종 검토가 필요합니다.</li>
									<li>2. 과제를 검색하여, 해당하는 과제의 협약을 위한 상세페이지를 확인할 수 있습니다. </li>
								</ol>
							</div>
						    <div class="list_search_top_area">							   
							    <ul class="clearfix list_search_top2 fl">		
									<li class="clearfix">                
										<label for="computelist_technology_day" class="fl list_search_title ta_r mr10 w_8">연구기간</label>
									    <div class="datepicker_area fl">
											<input type="text" id="research_date" class="datepicker form-control w_12 ls mr5" />
									    </div>									   
								    </li>
									<li class="clearfix">                
									   <label for="compute_technology_type" class="fl list_search_title ta_r mr10 w_8">상태</label>
									   <select name="compute_technology_type" id="calculation_status_selector" class="ace-select fl w_18 mr5">
									   	   <option value="">전체</option>
										   <option value="미정산">미정산</option>
										   <option value="제출완료">제출완료</option>
										   <option value="정산완료">정산완료</option>
									   </select>									   
								    </li>								
									<li class="clearfix">
										<label for="search_text" class="fl list_search_title ta_r w_8">검색어</label>
										<input type="text" id="search_text" class="form-control brc-on-focusd-inline-block fl list_search_word_input ml10" style="width: 482px;" />
									</li>									
								</ul>																
								<div class="list_search_btn clearfix"><button type="button" class="blue_btn fr" onclick="searchList(1);">조회</button></div>
						    </div>
						    <!--//리스트 상단 검색-->

						    <!--검색 결과-->
						    <div class="list_search_table">
							    <div class="table_count_area">
								    <div class="count_area clearfix">
									    <div class="clearfix">											
											<div class="mt5 fl" id="search_count">								   
												[총 <span class="font_blue">0</span>건]
											</div>
											<div class="fr">											    
											    <div class="download fr"><a href="javascript:downloadExcelFile();" class="ex_down green_btn">엑셀 다운로드</a></div>					
									        </div>
								        </div>							   
							        </div>
									<div style="overflow-x:auto;">
										<table class="list th_c compute_list_table">
										   <caption>접수 목록</caption>     
										   <colgroup>
												<col style="width: 5%;">
												<col style="width: 7%;">
												<col style="width: 10%;">
												<col style="width: 12%;">
												<col style="width: 12%;">
												<col style="width: 11%;">
												<col style="width: 10%;">
												<col style="width: 13%;">
												<col style="width: 10%;">
												<col style="width: 10%;">
										   </colgroup>
										   <thead>
												<tr>
												   <th scope="col">
														<input type="checkbox" id="computeallCheck" onclick="checkAllBox()">
														<label for="computeallCheck">&nbsp;</label>
												   </th>
												   <th scope="col">과제번호</th>
												   <th scope="col">사업명</th>
												   <th scope="col">공고명</th>
												   <th scope="col">기술명</th>
												   <th scope="col">연구기관</th>
												   <th scope="col">연구책임자</th>
												   <th scope="col">연구기간</th>
												   <th scope="col">연구비</th>
												   <th scope="col">상태</th>
												</tr>
										   </thead>
										   <tbody id="list_body">
										   </tbody>
										</table>   
										<!--//검색 결과-->   
										
										<div class="button_area mt30 p5">
											<button type="button" class="blue_btn fr" onclick="activateCalculation()">정산 활성화</button>										
										</div>
									</div>  

								    <!--페이지 네비게이션-->
								   	<input type="hidden" id="pageIndex" name="pageIndex"/>
								   	<div class="page" id="pageNavi"></div>  
								    <!--//페이지 네비게이션-->									
									
								</div>
						    </div><!--//list_search_table-->
						</div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>

