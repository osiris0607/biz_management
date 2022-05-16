<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var choicedExpertList;
	var isChangeExpertList = false;

	$(document).ready(function() {
		searchReceptionDetail();
		searchExpertList(1);
	});

	function searchReceptionDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/reception/detail");
		comAjax.setCallback(getReceptionCB);
		comAjax.addParam("reception_id", $("#reception_id").val());
		comAjax.ajax();
	}

	var choicedExpertList;
	function getReceptionCB(data){
		var receptionDetail = data.result_data;
		console.log(receptionDetail);
		// 기관 정보
		$("#announcement_title").html("<span>" + receptionDetail.announcement_title + "</span>");
		$("#announcement_type_name").html("<span>" + receptionDetail.announcement_type_name + "</span>");
		$("#institution_name").html("<span>" + receptionDetail.institution_name + "</span>");
		$("#researcher_name").html("<span>" + receptionDetail.researcher_name + "</span>");
		$("#researcher_institution_department").html("<span>" + receptionDetail.researcher_institution_department + "</span>");
		$("#researcher_institution_position").html("<span>" + receptionDetail.researcher_institution_position + "</span>");
		$("#researcher_mobile_phone").html("<span>" + receptionDetail.researcher_mobile_phone + "</span>");
		$("#researcher_email").html("<span>" + receptionDetail.researcher_email + "</span>");
		
		// 선택된 전문가를 희망 전문가 영역에 그린다.
		choicedExpertList = receptionDetail.choiced_expert_list;
		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		$.each(choicedExpertList, function(key, value) {
			str += "<tr>";
			str += "	 <td><span>" + (index+1) + "</span></td>";
			str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";;
			str += "	<td><span>" + value.research + "</span></td>";
			str += "	<td><span>" + value.name + "</span></td>";
			str += "	<td><span>" + value.institution_name + "</span></td>";
			str += "	<td><span>" + value.institution_department + "</span></td>";
			str += "	<td><span>" + value.mobile_phone + "</span></td>";
			str += "	<td><span>" + value.email + "</span></td>";
			if ( gfn_isNull(value.member_id) == false) {
				str += "	<td><span>전문가 풀</span></td>";
			} else {
				str += "	<td><span>직접 입력</span></td>";
			}
			str += "	<td><button type='button' class='gray_btn del_btn' onclick='deleteExpert(\"" + index + "\")'>삭제</button></td>";
			str += "</tr>";
			
			index++;
		});
		body.append(str);
	}	

	function deleteExpert(index) {
		isChangeExpertList = true;
		choicedExpertList.splice(index, 1);
		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		$.each(choicedExpertList, function(key, value) {
			str += "<tr>";
			str += "	 <td><span>" + (index+1) + "</span></td>";
			str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";;
			str += "	<td><span>" + value.research + "</span></td>";
			str += "	<td><span>" + value.name + "</span></td>";
			str += "	<td><span>" + value.institution_name + "</span></td>";
			str += "	<td><span>" + value.institution_department + "</span></td>";
			str += "	<td><span>" + value.mobile_phone + "</span></td>";
			str += "	<td><span>" + value.email + "</span></td>";
			if ( gfn_isNull(value.member_id) == false) {
				str += "	<td><span>전문가 풀</span></td>";
			} else {
				str += "	<td><span>직접 입력</span></td>";
			}
			str += "	<td><button type='button' class='gray_btn del_btn' onclick='deleteExpert(\"" + index + "\")'>삭제</button></td>";
			str += "</tr>";
			
			index++;
		});
		body.append(str);
	}

	
	function searchExpertList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/member/expert/search/paging");
		comAjax.setCallback(searchExpertListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "LARGE DESC");
		var temp = $("#search_text").val();
		comAjax.addParam("search_text", $("#search_text").val());
		
		comAjax.ajax(); 
	}	

	var expertList;
	function searchExpertListCB(data) {
		console.log(data);
	
		var body = $("#expert_list_body");
		body.empty();
		if ( data.result_data == null || data.result_data.length == 0 ) {
			$("#total_count").html("[총 <span class='fw500 font_blue'>0</span>건]");
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : data.result_data.length,
					eventName : "searchExpert"
				};
	
			gfnRenderPaging(params);
			
			var str = "";
			var index = 0;
			expertList = data.result_data;
			$.each(expertList, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<input type='checkbox' id='checkbox_" + index + "' name='expert_checkbox' value='" + value.member_id + "'>";
				str += "		<label for='checkbox_" + index + "' class='checkbox_a2'>&nbsp;</label>";
				str += "	</td>";
				str += "	<td>";
				if ( gfn_isNull(value.large) == true ){
					str += "		<span class='fl mr5'>" + "없음" + "</span> ";
				}
				else {
					str += "		<span class='fl mr5'>" + value.large + "</span>";
				}
				str += "			<span class='fl mr5'>&gt;</span>";
				if ( gfn_isNull(value.middle) == true ){
					str += "		<span class='fl mr5'>" + "없음" + "</span>";
				}
				else {
					str += "		<span class='fl mr5'>" + value.middle + "</span>";
				}
				str += "			<span class='fl mr5'>&gt;</span>";
				if ( gfn_isNull(value.small) == true ){
					str += "		<span class='fl mr5'>" + "없음" + "</span>";
				}
				else {
					str += "		<span class='fl mr5'>" + value.small + "</span>";
				}
				str += "	</td>";
				str += "	<td>" + value.research + "</td>";
				str += "	<td>" + value.name + "</td>";
				str += "	<td>" + value.university + "</td>";
				str += "	<td>" + value.department + "</td>";
				str += "	<td>" + value.mobile_phone + "</td>";
				str += "	<td>" + value.email + "</td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);
		}
	}

	
	function choiceExpert() {
		if ( $("input:checkbox[name='expert_checkbox']:checked").length == 0) {
			alert("먼저 전문가를 선택해 주시기 바랍니다.");
			return;
		}
		// 이미 선택된 전문가는 다시 선택하지 못한다.
		var isOK = true;
		$("input:checkbox[name='expert_checkbox']:checked").each(function () {
			var temp = $(this).val();
			for (var i=0; i<choicedExpertList.length; i++) {
				if ( choicedExpertList[i].member_id == $(this).val() ){
					isOK = false;
					break;
				}
			}
		});
		if ( isOK == false) {
			alert("이미 선택된 전문가가 있습니다. 다시 선택해 주시기 바랍니다.");
			return;
		}
		// 선택된 전문가를 희망 전문가 영역에 그린다.
		var body = $("#choiced_expert_list_body");
		var str = "";
		var index = 0;
		body.empty();
		$("input:checkbox[name='expert_checkbox']:checked").each(function () {
			var memberId= $(this).val();
			$.each(expertList, function(key, value) {
				if ( value.member_id ==  memberId ){
					var expert = new Object();
					
					var str = "";
					if ( gfn_isNull(value.large) == true ){
						str += "없음";
					} else {
						str += value.large;
					}
					str += " > ";
					if ( gfn_isNull(value.middle) == true ){
						str += "없음";
					} else {
						str += value.middle;
					}
					str += " > ";
					if ( gfn_isNull(value.small) == true ){
						str += "없음";
					} else {
						str += value.small;
					}
					
					expert.member_id = value.member_id;
					expert.national_science = str;
					expert.research = value.research;
					expert.name = value.name;
					expert.institution_name = value.university;
					expert.institution_department = value.department;
					expert.mobile_phone = value.mobile_phone;
					expert.email = value.email;
					
					choicedExpertList.push(expert);
				}
			});
		});

		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		$.each(choicedExpertList, function(key, value) {
			str += "<tr>";
			str += "	 <td><span>" + (index+1) + "</span></td>";
			str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";;
			str += "	<td><span>" + value.research + "</span></td>";
			str += "	<td><span>" + value.name + "</span></td>";
			str += "	<td><span>" + value.institution_name + "</span></td>";
			str += "	<td><span>" + value.institution_department + "</span></td>";
			str += "	<td><span>" + value.mobile_phone + "</span></td>";
			str += "	<td><span>" + value.email + "</span></td>";
			if ( gfn_isNull(value.member_id) == false) {
				str += "	<td><span>전문가 풀</span></td>";
			} else {
				str += "	<td><span>직접 입력</span></td>";
			}
			str += "	<td><button type='button' class='gray_btn del_btn' onclick='deleteExpert(\"" + index + "\")'>삭제</button></td>";
			str += "</tr>";
			
			index++;
		});
		body.append(str);

		isChangeExpertList = true;
		$('.expert_add_popup_box').fadeOut(350);
	}

	function confirmExpert() {
		if (confirm('변경된 전문가 정보가 저장됩니다. 저장하시겠습니까?')) {
			var formData = new FormData();
			var expertString = JSON.stringify(choicedExpertList);
			formData.append("reception_id", $("#reception_id").val());
			formData.append("choiced_expert_info_list_json", expertString);
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/reception/tech/match/expert/modification",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			        	alert("전문가 정보 변경에 성공했습니다.");
			        	isChangeExpertList = false;
			        } else {
			        	alert("전문가 정보 변경에 실패했습니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	var mailSMSContents;
	function searchMailSMSContents() {
		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/tech/match/emailSMS/detail",
		    processData: false,
		    contentType: false,
		    async : false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( jsonData.result_data != null && jsonData.result_data.length > 0 ) {
        				mailSMSContents = jsonData.result_data;
   				 	} else {
       					alert("전송할 메일/SMS 내용이 없습니다. 먼저 메일/SMS 전송 내용을 세팅하고 이용하여 주시기 바랍니다.");
    				}
		        } else {
		        	alert("전송할 메일/SMS 내용이 없습니다. 먼저 메일/SMS 전송 내용을 세팅하고 이용하여 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function sendMail() {
		$('.expertintention_emailsend_popup_box').fadeOut(350);

		// 전문가를 추가 / 삭제 시 실제 DB에 저장되는 것은 아니다.
		// 따라서 추가 / 삭제가 있을시에 검토 완료 버튼을 눌러 DB에 저장되도록 한다.
		if ( isChangeExpertList ) {
			alert("전문가 리스트가 변경되었습니다. 변경된 정보를 확인하기 위해 검토완료 버튼을 눌러주시기 바랍니다. ");
			return;
		}
		
		// 가장 최근의 전송 메일 내용을 가져온다. 
		searchMailSMSContents();
		if ( mailSMSContents == null || mailSMSContents.length <= 0 ) {
			return;
		}
		
		var formData = new FormData();
		// 전송에 성공한 경우 해당 접수의 상태를 바꾸기 위해 필요하다. 매칭 진행 중으로 바뀐다.
		// Expert Review에서의 Reception Status는 항상 'D0000004' 매칭 신청 시 이다. 
		// Expert Review Button은 'D0000004' 매칭 신청 시에만 활성화 된다.
		formData.append("reception_id", $("#reception_id").val() );
		formData.append("reception_status", "D0000004" );
		// 전송할 메일 내용 
		$.each(mailSMSContents, function(key, value) {
			if (value.type == "email") {
				formData.append("title", value.title);
				formData.append("comment", value.comment);
				formData.append("link", value.link);
				formData.append("sender", value.sender);
			}
		});
		// 전송할 대상 			
		var expertIdList = new Array();
		var toMailList = new Array();
		$.each(choicedExpertList, function(key, value) {
			expertIdList.push(value.member_id);
			toMailList.push(value.email);
		});

		formData.append("expert_member_ids", expertIdList);
		formData.append("to_mail", toMailList);
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/tech/match/emailSMS/sendMail",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	alert("메일 전송에 성공하였습니다.");
		        	location.href="/admin/fwd/reception/match/main"; 
		        	
		        } else {
		        	alert("메일 전송에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function sendSMS() {
		var formData = new FormData();
		if (confirm('SMS을 전송하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/reception/tech/match/emailSMS/sendSMS",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			        	alert("전문가 정보 변경에 성공했습니다.");
			        } else {
			        	alert("전문가 정보 변경에 실패했습니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

</script>

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<div class="container" id="content">
	<h2 class="hidden">컨텐츠 화면</h2>
		<div class="sub">
			<!--left menu 서브 메뉴-->     
			<div id="lnb">
		       <div class="lnb_area">
                   <!-- 레프트 메뉴 서브 타이틀 -->	
			       <div class="lnb_title_area">
				       <h2 class="title">접수관리</h2>
				   </div>
                   <!--// 레프트 메뉴 서브 타이틀 -->						   
				   <div class="lnb_menu_area">	
				       <ul class="lnb_menu">
					       <li class="on"><a href="/admin/fwd/reception/main" title="접수관리">접수관리</a></li>
						   <li class="menu2depth">
							   	<ul>
								   <li class="active"><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
								   <li><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
								   <li><a href="/admin/fwd/reception/proposal/main">기술제안</a></li>
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
					       <li><a href="/admin/fwd/reception/main"><i class="nav-icon fa fa-home"></i></a></li>
						   <li>접수관리</li>
						   <li><strong>기술매칭</strong></li>
					   </ul>	
					  <!--//페이지 경로-->
					  <!--페이지타이틀-->
					   <h3 class="title_area">기술매칭</h3>
					  <!--//페이지타이틀-->
				    </div>
	   			</div>
					   
				<div class="contents_view">                              
					        <!--상단 목록-->
					<div style="overflow-x:auto;">
					   <table class="list">
						   <caption>접수 목록</caption>     
						   <colgroup>
							   <col style="width:20%">
							   <col style="width:10%">
							   <col style="width:20%">
							   <col style="width:5%">
							   <col style="width:15%">
							   <col style="width:5%">
							   <col style="width:10%">
							   <col style="width:15%">
						   </colgroup>
						   <thead>
							   <tr>
								   <th scope="col">공모명</th>
								   <th scope="col">구분</th>
								   <th scope="col">기관명</th>
								   <th scope="col">성명</th>
								   <th scope="col">부서</th>
								   <th scope="col">직책</th>
								   <th scope="col">휴대전화</th>
								   <th scope="col">이메일</th>
							   </tr>
						   </thead>
						   <tbody>
								<tr>
									<td id="announcement_title"></td>
									<td id="announcement_type_name"></td>
									<td id="institution_name"></td>
									<td id="researcher_name"></td>
									<td id="researcher_institution_department"></td>
									<td id="researcher_institution_position"></td>
									<td id="researcher_mobile_phone"></td>
									<td id="researcher_email"></td>
								</tr>
						   </tbody>
						</table>                         
					</div>
			    	<!--//상단 목록-->

						    <!--희망전문가-->
				    <div class="list_search_table mt30">
					    <div class="view_top_area clearfix mt30">
					        <h4 class="fl sub_title_h4">희망 전문가</h4>	
							<button type="button" class="blue_btn fr mr5 mt10 expert_add_popup_open">전문가 추가</button>
				        </div>
					    <div class="table_count_area">								   
					        <div style="overflow-x:auto;">
						       <table class="list th_c hope_expert">
							       <caption>희망 전문가</caption>     
							       <colgroup>										     
									   <col style="width: 5%" />
									   <col style="width: 23%" />
									   <col style="width: 10%" />
									   <col style="width: 10%" />
									   <col style="width: 10%" />
									   <col style="width: 10%" />
									   <col style="width: 10%" />
									   <col style="width: 15%" />
									   <col style="width: 7%" />
								       <col style="width: 8%" />
							       </colgroup>
							       <thead>
								       <tr>											       
										   <th scope="col">순위</th>
										   <th scope="col">국가과학기술분류</th>
										   <th scope="col">연구분야</th>
										   <th scope="col">성명</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">선택 구분</th>
									       <th scope="col">삭제</th>
								       </tr>
							       </thead>
							       <tbody id="expert_body"></tbody>
								</table>   
								<!--//검색 결과-->                           
							</div> 							   
						   					   
						   <div class="fr clearfix mt65">
						   		<button type="button" class="gray_btn2 fl mr5" onclick="javascript:history.go(-1);">이전</button>										    
							    <button type="button" class="gray_btn2 fl" onclick="confirmExpert();">검토 완료</button>			
						   </div>
 						   <div class="fr mr10 clearfix expert_button_box mt50">									    
							    <span class="fl mt5 mr20">전문가 참여 의향 조사</span>									   
								<button type="button" class="blue_btn fl mr5 expertintention_emailsend_popup_open mail_btn">E-mail</button>
								<button type="button" class="blue_btn fl expertintention_smssend_popup_open sms_btn">SMS</button><br>					
						   </div>
					    </div>
								<!--//list_search_table-->
			        </div><!--content view-->
		   		</div>
				<!--//contents_view--> 
	   	</div>
	   <!--//sub--> 
	</div>
	<!--//container-->
</div>


<!--전문가 추가 팝업-->
<div class="expert_add_popup_box">
   <div class="popup_bg"></div>
   <div class="expert_add_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">전문가 추가</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <div class="popup_txt">
		       <h4 class="sub_title_h4 mb10">전문가 검색</h4>
			   <div class="list_search_top_area clearfix">
				   <label for="kyword" class="fl list_search_title ta_r mr10 w_8">키워드</label>
				   <input type="text" class="form-control w82 fl mr5" id="search_text"/>
				   <button type="button" class="fr blue_btn mr5" onclick="searchExpertList(1);">검색</button>							
			   </div>

			   <h4 class="sub_title_h4 mb10">전문가 검색 결과</h4>
			   <div style="overflow-x:auto;">
				   <table class="list th_c expert_add_searchlist">
					   <caption>리스트 화면</caption>  
					   <colgroup>
						   <col style="width:5%">
						   <col style="width:15%">
						   <col style="width:10%">
						   <col style="width:10%">
						   <col style="width:15%">
						   <col style="width:15%">
						   <col style="width:10%">
						   <col style="width:15%">
					   </colgroup>
					   <thead>
						   <tr>
						       <th scope="col" colspan="8">전문가 정보</th>									   
						   </tr>								   
						   <tr>
							   <th scope="col">
								 <!-- <input type="checkbox" id="allCheck2"/><label for="allCheck2" class="checkbox_a2">&nbsp;</label> -->
							   </th>
							   <th>국가과학기술분류</th>
							   <th>연구분야</th>
							   <th>성명</th>
							   <th>기관명</th>
							   <th>부서</th>
							   <th>휴대전화</th>
							   <th>이메일</th>
						   </tr>
					   </thead>
					   <tbody id="expert_list_body"></tbody>
				   </table>   
				   <!--페이지 네비게이션-->
                         <!--페이지 네비게이션-->
					   <input type="hidden" id="pageIndex" name="pageIndex"/>
					   <div class="page" id="pageNavi"></div>  
						<!--//페이지 네비게이션-->
				   <!--//페이지 네비게이션-->
				   <!--//검색 결과-->                           
			   </div>
		   </div>
		   <div class="popup_button_area_center">
			   <button type="button" class="blue_btn mr5" onclick="choiceExpert();">확인</button>					   			   
		   </div>
	   </div>
   </div>
</div>
  <!--//전문가 추가 조사 팝업-->
  
<!--전문가 참여 의향 조사 팝업 - email-->
<div class="expertintention_emailsend_popup_box">
   <div class="popup_bg"></div>
   <div class="expertintention_emailsend_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">전문가 참여 의향 조사</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <div class="popup_txt"><span>[알림]</span>
			   <p class="font_w">전문가 참여 의향 조사 실시</p>
			   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 기존에 세팅해 놓은 문구로 전문가에게 <span class="font_blue" style="display:inline-block">email</span>이 발송됩니다.<br />발송하시겠습니까?</p>
		   </div>
		   <div class="popup_button_area_center">
		       <button type="button" class="blue_btn mr5" onclick="sendMail();">발송하기</button>
			   <button type="button" class="gray_btn popup_close_btn">취소</button>					   
		   </div>
	   </div>
   </div>
</div>
  <!--//전문가 참여 의향 조사 팝업 - email-->

  <!--전문가 참여 의향 조사 팝업-->
<div class="expertintention_smssend_popup_box">
   <div class="popup_bg"></div>
   <div class="expertintention_smssend_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">전문가 참여 의향 조사</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <div class="popup_txt"><span>[알림]</span>
			   <p class="font_w">전문가 참여 의향 조사 실시</p>
			   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 기존에 세팅해 놓은 문구로 전문가에게 <span class="font_blue" style="display:inline-block">SMS</span>가 발송됩니다.<br />발송하시겠습니까?</p>
		   </div>
		   <div class="popup_button_area_center">
		   		<button type="button" class="blue_btn mr5" onclick="sendSMS();">발송하기</button>
			    <button type="button" class="gray_btn popup_close_btn">취소</button>					   
		   </div>
	   </div>
   </div>
</div>
