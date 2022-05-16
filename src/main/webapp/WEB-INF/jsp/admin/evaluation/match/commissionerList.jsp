<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {
		
		initSearch();
		searchList(1);
		searchInstitutionTypeCount();
	});

	function initSearch(){
		$("#institution_type_selector").empty();
		var str = "<option value=''>전체</option>";
	   	<c:forEach items="${commonCode}" var="code">
		   	<c:if test="${code.master_id == 'M0000004'}">
				str += '<option value="${code.detail_id}">${code.name}</option>';
			</c:if>
		</c:forEach>
		str += '<option value="D0000007">내부평가위원</option>';
		$("#institution_type_selector").append(str);
		
		$("#national_skill_large_selector").empty();
		var previousName = ""
	    var str = '<option value="">전체</option>';
	   	<c:forEach items="${scienceCategory}" var="code">
			if ( previousName != "${code.large}") {
				str += '<option value="${code.large}">${code.large}</option>';
				previousName =  "${code.large}";
			}
		</c:forEach>
		$("#national_skill_large_selector").append(str);
	}

	function searchInstitutionTypeCount() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/evaluation/match/commissioner/search/institutionTypeCount' />");
		comAjax.setCallback(searchInstitutionTypeCountCB);
		comAjax.ajax();
	}

	var institutionTypeCount ;
	function searchInstitutionTypeCountCB(data) {
		institutionTypeCount = data.result_data;
		var total_commissioner_count = institutionTypeCount.institution_type_personal_count +
		institutionTypeCount.institution_type_company_count + institutionTypeCount.institution_type_school_count + 
		institutionTypeCount.institution_type_commissioner_count + institutionTypeCount.institution_type_department_count + 
		institutionTypeCount.institution_type_etc_count + institutionTypeCount.institution_type_manager_count;
		
		$("span[name='person_count']").html("<span>" + institutionTypeCount.institution_type_personal_count + "</span> 명");
		$("span[name='company_count']").html("<span>" + institutionTypeCount.institution_type_company_count + "</span> 명");
		$("span[name='school_count']").html("<span>" + institutionTypeCount.institution_type_school_count + "</span> 명");
		$("span[name='commissioner_count']").html("<span>" + institutionTypeCount.institution_type_commissioner_count + "</span> 명");
		$("span[name='department_count']").html("<span>" + institutionTypeCount.institution_type_department_count + "</span> 명");
		$("span[name='etc_count']").html("<span>" + institutionTypeCount.institution_type_etc_count + "</span> 명");
		$("span[name='manager_count']").html("<span>" + institutionTypeCount.institution_type_manager_count + "</span> 명");
		$("span[name='total_commissioner_count']").html("<span>" + total_commissioner_count + "</span> 명");
		
	}
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/evaluation/match/commissioner/search/paging' />");
		comAjax.setCallback(searchListCB);
		// 20개씩 검색
		comAjax.addParam("page_row_count", "20");
		// 등록된 평가위원만 검색
		comAjax.addParam("commissioner_status", "D0000004");
		comAjax.addParam("institution_type", $("#institution_type_selector").val());
		comAjax.addParam("national_skill_large", $("#national_skill_large_selector").val());
		comAjax.addParam($("#search_text_selector").val(), $("#search_text").val());
		
		comAjax.addParam("pageIndex", pageNo);
		comAjax.ajax();
	}

	function searchListCB(data) {
		var total = data.totalCount;
		var body = $("#list_all_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='6'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList",
					recordCount : 20
				};
			gfnRenderPaging(params);

			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var managerList = [];
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	 <td><span>" + value.institution_type_name + "</span></td>";
				str += "	 <td><div class='a_c'><span class='mr5'>" + value.national_skill_large + "</span></div></td>";
				str += "	 <td><span>" + value.rnd_class + "</span></td>";
				str += "	 <td><span>" + value.name + "</span></td>";
				str += "	 <td><span>" + value.institution_name + "</span></td>";
				str += "	 <td><span>" + value.remark + "</span></td>";
				str += "</tr>";
			});
			body.append(str);
		}
	}

	function selectCount(element) {
		$(element).val($(element).val().replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
		
		var count = 0;
		var index = $(element).attr("countType");
		if ( index == 0) {
			count = institutionTypeCount.institution_type_personal_count;
		} else if ( index == 1) {
			count = institutionTypeCount.institution_type_company_count;
		} else if ( index == 2) {
			count = institutionTypeCount.institution_type_school_count;
		} else if ( index == 3) {
			count = institutionTypeCount.institution_type_commissioner_count;
		} else if ( index == 4) {
			count = institutionTypeCount.institution_type_department_count;
		} else if ( index == 5) {
			count = institutionTypeCount.institution_type_etc_count;
		} else if ( index == 6) {
			count = institutionTypeCount.institution_type_manager_count;
		}  

		var inputCount = $(element).val();
		if ( gfn_isNull(inputCount) == false && (inputCount > count.toString()) ) {
			alert("입력한 값은 전체 값을 초과 할 수 없습니다.");
			$(element).val("");
			return;
		}

		var total = 0;
	 	$("input[name='select_count']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value;
			}
			total += Number(tempValue);
	 	});

		$("#select_total_commissioner_count").val(total);
	}

	function autoChoiceCommissioner() {
		if ( Number($("#select_total_commissioner_count").val()) <= 0 ){
			alert("자동 추출된 인원이 정해지지 않았습니다.");
			return;
		}

		var formData = new FormData();
		var totalCount = 0;
	 	$("input[name='select_count']").each(function() {
			if ( Number($(this).val()) > 0) {
				var index = $(this).attr("countType");
				if ( index == 0) {
					formData.append("institution_type_personal_count", $(this).val());
					$("#result_person_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				} else if ( index == 1) {
					formData.append("institution_type_company_count", $(this).val());
					$("#result_company_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				} else if ( index == 2) {
					formData.append("institution_type_school_count", $(this).val());
					$("#result_school_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				} else if ( index == 3) {
					formData.append("institution_type_commissioner_count", $(this).val());
					$("#result_commissioner_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				} else if ( index == 4) {
					formData.append("institution_type_department_count", $(this).val());
					$("#result_department_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				} else if ( index == 5) {
					formData.append("institution_type_etc_count", $(this).val());
					$("#result_etc_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				} else if ( index == 6) {
					formData.append("institution_type_manager_count", $(this).val());
					$("#result_manager_count").html("<span>" + $(this).val() + "</span> 명</span>");
					totalCount += Number($(this).val());
				}  
			}
	 	});
	 	$("#result_total_commissioner_count").html("<span>" + totalCount + "</span> 명</span>");
	 	

		 if(confirm("자동 추출 하시겠습니까?")){
			 $.ajax({
		    	type : "POST",
			    url : "/admin/api/evaluation/match/commissioner/search/autoChoice",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true ) {
				        console.log(jsonData.result_data);
			        	alert("추출 성공 하였습니다.");
			        	resultAutoChoiceCommissioner(jsonData);
			        	$('.auto_result_area').fadeIn(350);
			        } else {
			        	alert("추출 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		 }
	}
	
	function resultAutoChoiceCommissioner(data){
		var total = data.totalCount;
		var body = $("#choice_list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='8'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var str = "";
			var index = 1;
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='check'>";
				str += "		<input value='" + value.member_id + "' mobile_phone='" + value.mobile_phone + 
									"' email='" + value.email + "' institution_type='" + value.institution_type + 
									"' id='result_checkbox_" + index + 
									"' type='checkbox' name='final_commissioner' onclick='choiceFinalCommissioner(this);'/>";
				str += "		<label for='result_checkbox_" + index + "'>&nbsp;</label>";
				str += "	</td>";
				str += "	<td><span>" + index + "</span></td>";
				str += "	<td><span>" + value.institution_type_name + "</span></td>";
				str += "	<td><div class='a_c'><span class='mr5'>" + value.national_skill_large + "</span></div></td>";
				str += "	<td><span>" + value.rnd_class + "</span></td>";
				str += "	<td><span>" + value.name + "</span></td>";
				str += "	<td><span>" + value.institution_name + "</span></td>";
				str += "	<td><span>" + value.remark + "</span></td>";
				str += "</tr>";

				index++;
			});
			body.append(str);
		}
	}

	function choiceFinalCommissioner(element) {
		if ( $(element).prop('checked') ) {
			if ( $(element).attr("institution_type") == "D0000001" ) {
				$(final_person_count).val(Number($(final_person_count).val())+1) ;
				$(final_person_count).html("<span>" + $(final_person_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000002" ) {
				$(final_company_count).val(Number($(final_company_count).val())+1) ;
				$(final_company_count).html("<span>" + $(final_company_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000003" ) {
				$(final_school_count).val(Number($(final_school_count).val())+1) ;
				$(final_school_count).html("<span>" + $(final_school_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000004" ) {
				$(final_commissioner_count).val(Number($(final_commissioner_count).val())+1) ;
				$(final_commissioner_count).html("<span>" + $(final_commissioner_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000005" ) {
				$(final_department_count).val(Number($(final_department_count).val())+1) ;
				$(final_department_count).html("<span>" + $(final_department_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000006" ) {
				$(final_etc_count).val(Number($(final_etc_count).val())+1) ;
				$(final_etc_count).html("<span>" + $(final_etc_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000007" ) {
				$(final_manager_count).val(Number($(final_manager_count).val())+1) ;
				$(final_manager_count).html("<span>" + $(final_manager_count).val() + "</span> 명</span>");
			}

		} else { 
			if ( $(element).attr("institution_type") == "D0000001" ) {
				$(final_person_count).val(Number($(final_person_count).val())-1) ;
				$(final_person_count).html("<span>" + $(final_person_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000002" ) {
				$(final_company_count).val(Number($(final_company_count).val())-1) ;
				$(final_company_count).html("<span>" + $(final_company_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000003" ) {
				$(final_school_count).val(Number($(final_school_count).val())-1) ;
				$(final_school_count).html("<span>" + $(final_school_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000004" ) {
				$(final_commissioner_count).val(Number($(final_commissioner_count).val())-1) ;
				$(final_commissioner_count).html("<span>" + $(final_commissioner_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000005" ) {
				$(final_department_count).val(Number($(final_department_count).val())-1) ;
				$(final_department_count).html("<span>" + $(final_department_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000006" ) {
				$(final_etc_count).val(Number($(final_etc_count).val())-1) ;
				$(final_etc_count).html("<span>" + $(final_etc_count).val() + "</span> 명</span>");
			}
			if ( $(element).attr("institution_type") == "D0000007" ) {
				$(final_manager_count).val(Number($(final_manager_count).val())-1) ;
				$(final_manager_count).html("<span>" + $(final_manager_count).val() + "</span> 명</span>");
			}
		}

		var total = 0;
	 	$("span[name='final_count']").each(function() {
			var tempValue = $(this).val();
			//console.log(tempValue);
			total += Number(tempValue);
	 	});

		$("#final_total_commissioner_count").html("<span>" + total + "</span> 명</span>");
	}


	var mailAddresses = "";
	var commissionerMailList = new Array();
	var commissionerList = new Array();
	function prepaerSendMail() {
		if($("input:checkbox[name='final_commissioner']").is(":checked") == false) {
			alert("메일 전송할 평가위원을 선택하여야 합니다.");
			return;
		}
		
		$("input:checkbox[name=final_commissioner]:checked").each(function() {
			mailAddresses += $(this).attr("email") + ";";
			commissionerMailList.push($(this).attr("email"));
			commissionerList.push($(this).val());
		});
		// 마지막 ';' 삭제
		$("#mail_receiver").val(mailAddresses.substring(0, mailAddresses.length-1));
		$('.rating_email_popup_box').fadeIn(350);
	}

	function sendMail() {
		if ( gfn_isNull($("#mail_receiver").val()) ) {
			alert("수신자 메일 주소가 없습니다. 확인 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#mail_title").val()) ) {
			alert("메일 제목을 입력해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#mail_content").val()) ) {
			alert("메일 내용을 입력해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#mail_sender").val()) ) {
			alert("송신자 메일 주소를 설정해야 합니다.");
			return;
		}


		var temp = "${vo.update_evaluation_number_list}";
		var evaluationIDList = temp.replace(" ", "").replace("[","").replace("]","").split(',');
		
		
		if (confirm("메일을 발송하시겠습니까?")) {
			var formData = new FormData();
			formData.append("evaluation_reg_number", "${vo.evaluation_reg_number}" );
			formData.append("evaluation_id_list", evaluationIDList );
			formData.append("commissioner_list", commissionerList);
			formData.append("commissioner_mail_list", commissionerMailList);
			formData.append("mail_title", $("#mail_title").val());
			formData.append("mail_content", $("#mail_content").val());
			formData.append("mail_link", $("#mail_link").val());
			formData.append("mail_sender", $("#mail_sender").val());
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/evaluation/match/commissioner/sendMail",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true ) {
			        	alert("매일 발송에 성공 하였습니다.");
			        	$('.rating_email_popup_box').fadeOut(350);
			        } else {
			        	alert("매일 발송에 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	function moveCommissionerComplete() {
		location.href="/admin/fwd/evaluation/match/commissioner/registComplete?evaluation_reg_number=" + "${vo.evaluation_reg_number}" +
		  "&announcement_type=" + "${vo.announcement_type}" + "&classification=" + "${vo.classification}";

		
		//var updateEvaluationNumberList = "${vo.update_evaluation_number_list}".replace("[","").replace("]","");
		//location.href="/admin/fwd/evaluation/match/commissioner/registComplete?evaluation_reg_number=" + evaluationRegNumber;
	}

	function moveMain() {
		location.href = "/admin/fwd/evaluation/main?announcement_type=" + '${vo.announcement_type}' + "&classification="  + '${vo.classification}';
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
						       <h2 class="title">평가관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->					   
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="/admin/fwd/evaluation/match/main" title="평가관리">평가관리</a></li>
								   <li class="menu2depth">
									   <ul>
										   <li class="active"><a href="/admin/fwd/evaluation/match/main">기술매칭</a></li>
										   <li><a href="">기술공모</a></li>
										   <li><a href="">기술제안</a></li>
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
								   <li>평가관리</li>
								   <li><strong>기술매칭</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">기술매칭</h3>
							  <!--//페이지타이틀-->
						    </div>
					   </div>
					   
                       <div class="contents_view">                           
							<!--<h4 class="sub_title_h4 mb10">접수 목록</h4>    -->
					        <!--접수 목록-->
						    <div class="list_search_top_area">							   
							    <ul class="clearfix list_search_top2 rating_class_list">
								    <li>
										<div class="fl">
											<label for="rating_class_list1" class="fl list_search_title ta_r mr10 w_8">구분</label>
											<select id="institution_type_selector" class="fl ace-select w_20">	
											</select>
										</div>										
								    </li>
								    <li>
										<div class="fl">
											<label for="rating_class_list12" class="fl list_search_title ta_r mr10 w_8">전문분야</label>
											<select id="national_skill_large_selector" class="fl ace-select w_20">	
											</select>
										</div>
									</li>
									<li class="w100">
										<div class="fl">
											<label for="rating_class_list13" class="fl list_search_title ta_r mr10 w_8">검색어</label>
											<select id="search_text_selector" class="fl ace-select w_20">	
												<option value="name">이름</option>
												<option value="institution_name">기관명</option>
												<option value="rnd_class">연구분야</option>
											</select>
										</div>										
										<label for="estimation_search" class="hidden">검색어</label>
										<input type="text" id="search_text" class="form-control brc-on-focusd-inline-block fl w50 ml5" />
									</li>
								</ul>
																
								<div class="list_search_btn clearfix"><button type="submit" class="blue_btn fr" onclick="searchList(1);">조회</button></div>
						    </div>
						    <!--//리스트 상단 검색-->

						    <!--검색 결과-->
						    <div class="list_search_table">
							    <div class="table_count_area">
								    <div class="count_area clearfix">
									    <div class="clearfix">
											<div class="fl mt5" id="search_count">								   
											</div>
											<div class="fr">											    
											    <div class="download fr green_btn"><a href="" download class="ex_down">엑셀 다운로드</a></div>					
									        </div>							   
								        </div>							   
							        </div>
							        <div style="overflow-x:auto;">
								       <table class="list th_c estimation_table">
									       <caption>평가위원 등록</caption>     
									       <colgroup>
												<col style="width: 15%;">
												<col style="width: 15%;">
												<col style="width: 30%;">
												<col style="width: 10%;">
												<col style="width: 15%;">
												<col style="width: 15%;">												
										   </colgroup>
									       <thead>
										       <tr>
											       <th scope="col">구분</th>
											       <th scope="col">분야</th>
											       <th scope="col">연구분야</th>
												   <th scope="col">이름</th>
											       <th scope="col">기관명</th>
											       <th scope="col">비고</th>
										       </tr>
									       </thead>
									       <tbody id="list_all_body">
										   </tbody>
										</table>   
										<!--//검색 결과-->                           
									</div>  
									
								    <!--페이지 네비게이션-->
								    <input type="hidden" id="pageIndex" name="pageIndex"/>
								   	<div class="page" id="pageNavi"></div>  
					   				 <!--//페이지 네비게이션-->

									<!--검색 결과-->
									<div class="table_area clearfix estimation_table_searchresult">
										<table class="list2 fl" style="width:49.5%;">
										   <caption>공고정보</caption> 
										   <colgroup>
											   <col style="width: 20%">
											   <col style="width: 30%">
											   <col style="width: 50%">
										   </colgroup>
										   <tbody>
											   <tr>
												   <th scope="row" rowspan="7">검색 결과</th>
												   <td><span>개인</span></td> 
												   <td><span name="person_count"><span>0</span> 명</span></td> 
											   </tr>
											   <tr>
													<td><span>기업</span></td>
													<td><span name="company_count"><span>0</span> 명</span></td>
											   </tr>
											   <tr>
													<td><span>학교</span></td>
													<td><span name="school_count"><span>0</span> 명</span></td>
											   </tr>
											   <tr>
													<td><span>연구원</span></td>
													<td><span name="commissioner_count"><span>0</span> 명</span></td>
											   </tr>
											   <tr>
													<td><span>공공기관</span></td>
													<td><span name="department_count"><span>0</span> 명</span></td>
											   </tr>
											   <tr>
													<td><span>기타(협/단체 등)</span></td>
													<td><span name="etc_count"><span>0</span> 명</span></td>
											   </tr>
   											   <tr>
													<td><span>내부평가위원</span></td>
													<td><span name="manager_count"><span>0</span> 명</span></td>
											   </tr>
											</tbody>
											<tfoot>
											   <tr>
													<th scope="row" colspan="2">검색 결과</th>
													<td><span name="total_commissioner_count"><span >0</span> 명</span></td>
											   </tr>									   									  
											</tfoot>
										</table>
										<!--//검색 결과-->

										<!--평가위원 추출-->
										<table class="list2 fl" style="width:49.4%;margin-left: 1%;">
										   <caption>평가위원 추출</caption> 
										   <colgroup>
											   <col style="width: 20%">
											   <col style="width: 30%">
											   <col style="width: 50%">
										   </colgroup>
										   <tbody>
											   <tr>
												   <th scope="row" rowspan="7">평가위원 추출</th>
												   <td><span>개인</span></td> 
												   <td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="0" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />															
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="person_count"><span>0</span> 명</span>
														</div>
												   </td> 
											   </tr>
											   <tr>
													<td><span>기업</span></td>
													<td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="1" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="company_count"><span>0</span> 명</span>
													 	</div>
												    </td> 
											   </tr>
											   <tr>
													<td><span>학교</span></td>
													<td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="2" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="school_count"><span>0</span> 명</span>
													 	</div>
												    </td>
											   </tr>
											   <tr>
													<td><span>연구원</span></td>
													<td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="3" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="commissioner_count"><span>0</span> 명</span>
													 	</div>
												    </td>
											   </tr>
											   <tr>
													<td><span>공공기관</span></td>
													<td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="4" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="department_count"><span>0</span> 명</span>
													 	</div>
												    </td>
											    </tr>
											    <tr>
   													<td><span>기타(협/단체 등)</span></td>
													<td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="5" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="etc_count"><span>0</span> 명</span>
													 	</div>
												    </td>
											    </tr>
											    <tr>
   													<td><span>내부평가위원</span></td>
													<td>
														<div class="ta_c clearfix">
															<input name="select_count" countType="6" onkeyup="selectCount(this);" type="text" class="form-control w_10 ls number_t fl" />
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="manager_count"><span>0</span> 명</span>
													 	</div>
												    </td>
											   </tr>
											</tbody>
											<tfoot>
											   <tr>
													<th scope="row" colspan="2">검색 결과</th>
													<td>
														<div class="ta_c clearfix">
															<input id="select_total_commissioner_count" type="text" class="form-control w_10 ls number_t fl" disabled/>
															<span class="fl ml5 mt10">/</span>
															<span class="fl ml5 mt10" name="total_commissioner_count"><span>0</span> 명</span>
													 	</div>
												    </td>
											   </tr>									   									  
											</tfoot>
										</table>
										<!--//평가위원 추출-->
									</div>

									<div class="button_area clearfix">										
										<div class="button_area_fr fr">
											<button type="button" class="blue_btn fl" onclick="autoChoiceCommissioner();">자동 추출</button>										
										</div>
									</div>
									
									
									<!--자동 추출 검색 결과-->

									<div class="auto_result_area">										
										<p>평가위원 랜덤 자동 추출 값입니다.</p>
										<!--검색 결과-->
										<table class="list th_c checkinput_table">
									       <caption>접수 목록</caption>     
									       <colgroup>
												<col style="width: 5%;">
												<col style="width: 5%;">
												<col style="width: 10%;">
												<col style="width: 20%;">
												<col style="width: 30%;">
												<col style="width: 10%;">
												<col style="width: 10%;">
												<col style="width: 10%;">
											
										   </colgroup>
									        <thead>
										       <tr>										  
											       <th scope="col">
												       <input id="auto_result_table_checkboxall" type="checkbox" />
													   <label for="auto_result_table_checkboxall">&nbsp;</label>
												   </th>
											       <th scope="col">No.</th>
											       <th scope="col">구분</th>
												   <th scope="col">분야</th>
												   <th scope="col">키워드</th>
											       <th scope="col">이름</th>
											       <th scope="col">기관명</th>
												   <th scope="col">비고</th>
										       </tr>
									        </thead>
									        <tbody id="choice_list_body">												
										    </tbody>
										</table> 
										 
										<!--검색 결과-->
										<div class="table_area clearfix auto_estimation_table_searchresult">
											<table class="list2 fl" style="width:49.5%;">
												<caption>공고정보</caption> 
											    <colgroup>
												   <col style="width: 20%">
												   <col style="width: 30%">
												   <col style="width: 50%">
											    </colgroup>
												<tbody>
												   <tr>
													   <th scope="row" rowspan="7">검색 결과</th>
													   <td><span>개인</span></td> 
													   <td><span id="result_person_count"><span>0</span> 명</span></td> 
												   </tr>
												   <tr>
														<td><span>기업</span></td>
														<td><span id="result_company_count"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>학교</span></td>
														<td><span id="result_school_count"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>연구원</span></td>
														<td><span id="result_commissioner_count"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>공공기관</span></td>
														<td><span id="result_department_count"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>기타(협/단체 등)</span></td>
														<td><span id="result_etc_count"><span>0</span> 명</span></td>
												   </tr>
	   											   <tr>
														<td><span>내부평가위원</span></td>
														<td><span id="result_manager_count"><span>0</span> 명</span></td>
												   </tr>
												</tbody>
												<tfoot>
												   <tr>
														<th scope="row" colspan="2">검색 결과</th>
														<td><span id="result_total_commissioner_count"><span >0</span> 명</span></td>
												   </tr>									   									  
												</tfoot>
											</table>
											<!--//검색 결과-->

											<!--평가위원 추출-->
											<table class="list2 fl" style="width:49.4%;margin-left: 1%;">
												<caption>평가위원 추출</caption> 
												<colgroup>
												   <col style="width: 20%">
												   <col style="width: 30%">
												   <col style="width: 50%">
											   </colgroup>
											   <tbody>
												   <tr>
													   <th scope="row" rowspan="7">최종 선택 결과</th>
													   <td><span>개인</span></td> 
													   <td><span name="final_count" id="final_person_count" value="0"><span>0</span> 명</span></td> 
												   </tr>
												   <tr>
														<td><span>기업</span></td>
														<td><span name="final_count" id="final_company_count" value="0"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>학교</span></td>
														<td><span name="final_count" id="final_school_count" value="0"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>연구원</span></td>
														<td><span name="final_count" id="final_commissioner_count" value="0"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>공공기관</span></td>
														<td><span name="final_count" id="final_department_count" value="0"><span>0</span> 명</span></td>
												   </tr>
												   <tr>
														<td><span>기타(협/단체 등)</span></td>
														<td><span name="final_count" id="final_etc_count" value="0"><span>0</span> 명</span></td>
												   </tr>
	   											   <tr>
														<td><span>내부평가위원</span></td>
														<td><span name="final_count" id="final_manager_count" value="0"><span>0</span> 명</span></td>
												   </tr>
												</tbody>
												<tfoot>
												   <tr>
														<th scope="row" colspan="2">최종 선택 결과</th>
														<td><span id="final_total_commissioner_count"><span >0</span> 명</span></td>
												   </tr>									   									  
												</tfoot>
											</table>
										<!--//평가위원 추출-->
										</div>

										<div class="bottom_btn_area clearfix">								
											<div class="fr clearfix mt30">										   
											   <!--<button type="button" class="blue_btn2 fl mr5 send_save_popup_preview_open">미리보기</button>-->
											   <button type="button" class="blue_btn fl mr5 mail_btn" onclick="prepaerSendMail();">이메일 발송</button>
											   <button type="button" class="blue_btn fl sms_btn mr5">SMS 보내기</button>											
											   <button type="button" class="blue_btn2 fl mr5" onclick="moveCommissionerComplete();">평가위원 회신 및 확정</button>
											   <button type="button" class="gray_btn2 fl" onclick="moveMain();">목록</button>
										    </div>
									    </div>		
									</div>									
								</div>
						   <!--//list_search_table-->
							</div><!--contents_view-->
						</div>
				   <!--//contents--> 

					</div>
                <!--//sub--> 
				</div>
            
			 </div>
            
<!--이메일 보내기-->
<div class="rating_email_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_email_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">이메일 발송</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<div class="popup_txt">
				<table class="list2">
					<caption>평가위원 추출</caption> 
					<colgroup>												  
					   <col style="width: 20%">
					   <col style="width: 80%">
				   </colgroup>
				   <tbody>
					   <tr>
						   <th scope="row"><label for="rating_mail_receiver">수신자</label></th>
						   <td><input id="mail_receiver" class="form-control w100" type="text" /></td> 
					   </tr>
					  <tr>
						   <th scope="row"><label for="rating_mail_title">발송제목</label></th>
						   <td><input id="mail_title" class="form-control w100" type="text" /></td> 
					   </tr>
					   <tr>
						   <th scope="row"><label for="rating_mail_txt">발송문구</label></th>
						   <td><textarea id="mail_content" rows="10" class="w100"></textarea></td> 
					   </tr>
					   <tr>
						   <th scope="row"><label for="rating_mail_link">참여링크</label></th>
						   <td><input id="mail_link" class="form-control w100" type="text" /></td> 
					   </tr>
					   
					   <tr>
						   <th scope="row"><label for="rating_mail_caller">발신자</label></th>
						   <td><input id="mail_sender" class="form-control w100" type="text" /></td> 
					   </tr>
					</tbody>
				</table>
			</div>					
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" onclick="sendMail();">이메일 발송</button>
			</div>
		</div>
	</div>
</div>
<!--//이메일 보내기-->


<!--이메일 발송 팝업-->
<div class="send_email_popup_box">
   <div class="popup_bg"></div>
   <div class="send_email_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">이메일 발송 안내</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
	   		<div class="popup_txt"><span>[알림]</span>
			   <p class="font_w">이메일 발송</p>
			   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 작성하신 내용으로 <span class="font_blue" style="display:inline-block">email</span>이 발송됩니다.<br>발송하시겠습니까?</p>
		    </div>			   	   
		    <div class="popup_button_area_center">
			   <button type="submit" class="blue_btn mr5 ok_btn">발송하기</button>
			   <button type="button" class="gray_btn popup_close_btn">취소</button>
		    </div>				   
	   </div>
   </div>
  </div>
  <!--//이메일 발송 팝업-->
<script src="/assets/admin/js/script.js"></script>