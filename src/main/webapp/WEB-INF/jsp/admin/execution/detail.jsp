<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var memberId;
	var institutionName;
	var agreementStatus;
	var receptionId;

	$(document).ready(function() {
		displayMain();
		// 평가 목록
		searchDetail(); 
	});

	/*******************************************************************************
	* FUNCTION
	*******************************************************************************/
	// announcement_type과 classification에 따라서 달라지는 화면을 그린다.
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

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/execution/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("execution_id", "${vo.execution_id}");
		comAjax.addParam("announcement_type", "${vo.announcement_type}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#research_info").html("<span>" + data.result_data.institution_name + "/" + data.result_data.researcher_name + "</span>");
		$("#research_date").html("<span>" + data.result_data.research_date + "</span>");
		if ( gfn_isNull(data.result_data.research_funds) ) {
			$("#research_funds").html("<span>0 (만원)</span>");
		} else {
			$("#research_funds").html("<span>" + data.result_data.research_funds + " (만원)</span>");
		}

		// 파일 이름
		$("#middle_report_file_name").text(data.result_data.middle_report_file_name);
		$("#middle_report_file_name").attr("file_id", data.result_data.middle_report_file_id);
		$("#final_report_file_name").text(data.result_data.final_report_file_name);
		$("#middle_report_file_name").attr("file_id", data.result_data.final_report_file_id);
		if ( data.result_data.return_upload_files != null) {
	    	uploaded_files = data.result_data.return_upload_files;
	    	$("#file_list").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#file_list").append("<li><a href='javascript:void(0);' file_id='" + uploaded_files[i].file_id + "' onclick='downloadFile(this)'>" + uploaded_files[i].name + "</a></li>");
		    }
		}

		// 변경 이력
		var body = $("#changes_list_body");
		body.empty();
		var str = "";
		var index = 1;
		if ( gfn_isNull(data.result_data.changes_list) == false ) {
			$.each(data.result_data.changes_list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + index + "</td>";
				str += "	<td>" + value.change_date + "</td>";
				str += "	<td>" + value.changes + "</td>";
				str += "	<td><a href='javascript:void(0);' file_id='" + value.official_notice_file_id + "' onclick='downloadFile(this)'>" + value.official_notice_file_name + "</a></td>";
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	function downloadFile(element) {
		var temp = $(element).attr("file_id");
		location.href = "/util/api/file/download/" + $(element).attr("file_id");
	}


	/*******************************************************************************
	* 컨퍼넌트 이벤트 
	*******************************************************************************/
	// agreement 상태 변경
	function onUpdateChangeHistory(status) {
		var formData = new FormData();
		var isUpdateData = false;
		var objList = new Array();
		
		$('#changes_list_body tr').each(function(){
			var tr = $(this);
			var td = tr.children();
			var temp = $(this).find("input:eq(1)");
			
			if ( gfn_isNull($(this).find("textarea").val()) == false && $(this).find("input:eq(1)")[0].files[0] != null ){
				objList.push($(this).find("textarea").val());
				formData.append("upload_change_files", $(this).find("input:eq(1)")[0].files[0]);
				isUpdateData = true;
			} 
		});

		if ( isUpdateData == false) {
			alert("등록할 변경 이력이 없습니다. 변경 내용과 변경 공문은 필수 입니다.");
			return;
		}

	 	
	 	formData.append("execution_id", "${vo.execution_id}");
		formData.append("change_contents_list", objList);

			
		if ( confirm("등록하시겠습니까?") ) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/execution/changeHistory/registration",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			        	alert("등록 되었습니다.");
        				onMoveExecutionPage('${vo.announcement_type}');
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	function onAddItem() {
		var str = "";
		var index = $("#changes_list_body tr").length + 1;

		str += "<tr>";
		str += "	<td>" + index + "</td>";
		str += "	<td></td>";
		str += "	<td><textarea rows='2' class='w100'></textarea></td>";
		str += "	<td>";
		str += "		<div class='clearfix file_form_txt'>";
		str += "			<div class='filebox bs3-primary'>";
		str += "				<input class='upload-name w50' value='선택된 파일이 없습니다.' disabled='disabled'>";
		str += "				<label for='upload-name' class='hidden'>선택된 파일이 없습니다.</label>";
		str += "				<input type='file' id='ex_filename_" + index + "' onchange='onHistoryFileChange(this);'>";
		str += "				<label for='ex_filename_" + index + "'>찾기</label>";
		str += "			</div>";
		str += "		</div>";
		str += "	</td>";
		str += "</tr>";

		$("#changes_list_body").append(str);	

		//$(".ui-datepicker-trigger").remove();
		//$("input[name=change_date]").removeClass('hasDatepicker').addClass("datepicker");     
	}

	function onHistoryFileChange(element) {
		if(window.FileReader){ // modern browser 
			var filename = $(element)[0].files[0].name; 
		} 
		else {// old IE 
			var filename = $(element).val().split('/').pop().split('\\').pop(); // 파일명만 추출 
		} // 추출한 파일명 삽입 
		$(element).siblings('.upload-name').val(filename); 
	}


	//평가관리 사이트로 이동한다. (기술매칭/기술공모/기술제안)
	function onMoveExecutionPage(evaluationType){
		// 기술매칭/기술공모/기술제안은 URL로 구분
		location.href = "/admin/fwd/execution/main?announcement_type=" + evaluationType;
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
							   <h2 class="title">협약관리</h2>
						   </div>
						   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000005');" title="평가관리">협약관리</a></li>
								   <li class="menu2depth">
									   <ul>
										   <li id="left_menu_match"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000005');">기술매칭</a></li>
										   <li id="left_menu_contest"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000003');">기술공모</a></li>
										   <li id="left_menu_proposal"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000004');">기술제안</a></li>
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
								   <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>협약관리</li>
								   <li><strong class="location_name">기술매칭</strong></li>
								</ul>	
							    <!--//페이지 경로-->
							    <!--페이지타이틀-->
							    <h3 class="title_area location_name">기술매칭</h3>
							    <!--//페이지타이틀-->
						    </div>
					    </div><!--location_area-->
					   					   
						<div class="contents_view agreement_technologymatching_send_view">	
							<!--과제정보-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">과제 정보</h4>
							</div>
							<table class="list2 assignment_info">
							   <caption>과제정보</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <thead>
								    <tr>
									   <th scope="row">과제번호</th>
									   <td id="agreement_reg_number"></td> 
								    </tr>
							   </thead>
							   <tbody>	
									<tr>
									   <th scope="row">사업명</th>
									   <td id="announcement_business_name"></td> 
									</tr>
								   <tr>
									   <th scope="row">공고명</th>
									   <td id="announcement_title"></td> 
								   </tr>
								   <tr>
									   <th scope="row">기술명</th>
									   <td id="tech_info_name"></td> 
								   </tr>
								   <tr>
									   <th scope="row">연구기관/연구책임자</th>
									   <td id="research_info"></td> 
								   </tr>
								   <tr>
									   <th scope="row">연구기간</th>
									   <td id="research_date"></td> 
								   </tr>
								   <tr>
									   <th scope="row">연구비</th>
									   <td id="research_funds"></td> 
								   </tr>
							   </tbody>
							</table>
							<!--//과제정보-->
							
							<!--과제보고서-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">과제 보고서</h4>							  
							</div>
							<table class="list2 docu_mission">
								<caption>과제 보고서</caption> 
								<colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
								</colgroup>
								<thead>
								   <tr>
										<th scope="row">중간보고서</th>
										<td>										
											<div class="file_form_txt">	  
												<a href="javascript:void(0);" download id="middle_report_file_name" onclick='downloadFile(this)'></a>										
											</div>			
										</td> 
									</tr>
								</thead>
								<tbody>																						       
									<tr>
										<th scope="row">최종보고서</th>
										<td>										
											<div class="file_form_txt">
												<a href="javascript:void(0);" download id="final_report_file_name" onclick='downloadFile(this)'></a>												   
											</div>			
										</td> 
									</tr>
									<tr>
										<th scope="row">기타</th>
										<td>										
											<div class="file_form_txt">													   
												<ul id="file_list" style="clear:both"></ul>
											</div>	
										</td> 
									</tr>
								</tbody>
							</table>
							<!--//과제보고서-->
							
							<!--과제변경이력-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">과제 변경 이력</h4>	
							   <button type="button" class="fr gray_btn mt10" onclick="onAddItem();">추가</button>
							</div>
							<table class="list docu_mission">
								<caption>과제 변경 이력</caption> 
								<colgroup>
								   <col style="width: 10%" />
								   <col style="width: 30%" />
								   <col style="width: 30%" />
								   <col style="width: 30%" />
								</colgroup>
								<thead>
								   <tr>
										<th scope="col">번호</th>
										<th scope="col">변경일</th>
										<th scope="col">변경내용</th>
										<th scope="col">변경공문</th>										
									</tr>
								</thead>
								<tbody id="changes_list_body">																						       
									<tr>
										<td>1</td>
										<td><span>2021</span><span>-</span><span>06</span><span>-</span><span>01</span></td> 
										<td>참여연구원 변경</td>
										<td><a href="" download>변경공문.pdf</a></td>
									</tr>
									<tr>
										<td>2</td>
										<td>
											<div class="datepicker_area">
												<input type="text" class="datepicker form-control w_12 ls mr5" />
											</div>
										</td> 
										<td><textarea rows="2" class="w100"></textarea></td>
										<td>
											<div class="clearfix file_form_txt">													   
											   <!--업로드 버튼-->	
											   <div class="filebox bs3-primary">
												  <input class="upload-name w50" value="선택된 파일이 없습니다." id="upload-name" disabled="disabled">
												  <label for="upload-name" class="hidden">선택된 파일이 없습니다.</label>								  
												  <input type="file" id="ex_filename" class="upload-hidden"> 
												  <label for="ex_filename">찾기</label> 
												</div>													   
											   <!--//업로드 버튼-->														   
											</div>
										</td>
									</tr>
									
								</tbody>
							</table>
							<!--//과제변경이력-->


							<div class="button_area mt30 p5">								
								<button type="button" class="gray_btn2 fr" onclick="onMoveExecutionPage('${vo.announcement_type}')">목록</button>
								<button type="button" class="blue_btn fr execute_ok_popup_open mr5" onclick="onUpdateChangeHistory();">등록</button>
							</div>
						</div><!--//contents view-->

                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
<script src="/assets/admin/js/script.js"></script>