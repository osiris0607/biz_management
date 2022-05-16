<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>


	$(document).ready(function() {
		<sec:authorize access="hasRole('ROLE_SUPER_ADMIN')">
			$("#auth_btn").show();
			$("#reg_btn").show();
		</sec:authorize>
	
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/member/manager/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "LOGIN_DATE DESC");

		if ( $("#member_manager_list_search_merber_class option:selected").val() == "option2" ) {
			comAjax.addParam("auth_level_admin", "Y");
			comAjax.addParam("auth_level_manager", "N");
		}
		if ( $("#member_manager_list_search_merber_class option:selected").val() == "option3" ) {

			if ( $("#merber_class_check1").is(':checked') == false && $("#merber_class_check2").is(':checked') == false ) {
				alert("평가관리자를 선택해 주시기 바랍니다.");
				return;
			}

			comAjax.addParam("auth_level_admin", "N");
			comAjax.addParam("auth_level_manager", "Y");

			if ( $("#merber_class_check1").is(':checked') ) {
				comAjax.addParam("evaluation_manager_yn", "Y");
			} else {
				comAjax.addParam("evaluation_manager_yn", "N");
			}

			if ( $("#merber_class_check2").is(':checked') ) {
				comAjax.addParam("research_manager_yn", "Y");
			} else {
				comAjax.addParam("research_manager_yn", "N");
			}
		}

		if ( gfn_isNull($("#department_selector").val()) == false ) {
			comAjax.addParam("department", $("#department_selector").val());
		}
		comAjax.addParam( $("#search_selector").val(), $("#search_text").val());
		comAjax.ajax();
	}
	
	
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			$("#search_count").html("&#91;총 <span class='font_blue'>" + total + "</span>건&#93;");
			var str = "<tr>" + "<td colspan='9'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPaging(params);

		   $("#search_count").html("&#91;총 <span class='font_blue'>" + total + "</span>건&#93;");
			var departmentList = [];
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				// 검색 시 부서의 Select List를 만들기 위해 중복 데이터를 제거한다.
				if(gfn_isNull(value.department) == false && departmentList.indexOf(value.department) == -1 ){
					departmentList.push(value.department);
				}
				
				str += "<tr>";
				if ( value.auth_level_admin == "Y" ) {
					str += "	<td><input type='checkbox' onclick='checkMe(this)' class='checkbox_member_manager_table' member_id='" + value.member_id + "' member_type='admin' /><label>&nbsp;</label></td>";
					str += "	<td>총괄관리자</td>";
				} else {
					str += "	<td><input type='checkbox' onclick='checkMe(this)' class='checkbox_member_manager_table' member_id='" + value.member_id + "' member_type='manager' /><label>&nbsp;</label></td>";
					str += "	<td>평가관리자</td>";
				}
				str += "	<td>"+ value.department +"</td>";
				str += "	<td>"+ value.position +"</td>";
				str += "	<td>"+ value.name +"</td>";
				str += "	<td><span><a href='/admin/fwd/member/manager/detail?member_id=" + value.member_id + "' class='link_text_underline'>" + value.member_id + "</a></span></td>";
				var authString ="";
				if ( value.auth_announcement_menu_yn == "Y" ) {
					authString += "공고관리<br/>";
				}
				if ( value.auth_reception_menu_yn == "Y" ) {
					authString += "접수관리<br/>";
				}
				if ( value.auth_evaluation_menu_yn == "Y" ) {
					authString += "평가관리<br/>";
				}
				if ( value.auth_execution_menu_yn == "Y" ) {
					authString += "수행관리<br/>";
				}
				if ( value.auth_agreement_menu_yn == "Y" ) {
					authString += "협약관리<br/>";
				}
				if ( value.auth_calculate_menu_yn == "Y" ) {
					authString += "정산관리<br/>";
				}
				if ( value.auth_notice_menu_yn == "Y" ) {
					authString += "알림·정보관리<br/>";
				}
				// 마지막 '<br/>' 삭제
				str += "	<td>"+ authString.substring(0, (authString.length-5)) +"</td>";
				str += "	<td>"+ value.mobile_phone +"</td>";
				str += "	<td>"+ value.email +"</td>";
				str += "	<td>"+ value.login_date +"</td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);

			// 부서 Selector List
			$("#department_selector").empty();
			var str = "<option value=''>전체</option>";
			$.each(departmentList, function(key, value) {
				str += "<option value='" + value + "'>" + value +"</option>";
			});
			$("#department_selector").append(str);
		}
	}

	function checkMe(element) {
		if( $(element).attr("member_type") == "admin" ) {
			alert("총괄관리자의 권한은 수정할 수 없습니다.");
			$(element).prop("checked", false);
			return;
		}
	}

	function initSearch() {
		$("#search_text").val("");
		$("#department_selector option:eq(0)").prop("selected",true);
		$("#search_selector option:eq(0)").prop("selected",true);
		$("#member_manager_list_search_merber_class option:eq(0)").prop("selected",true);
	}

	function prepareSetAuth() {
		// 권한 수정할 관리자 선택 여부
		if ( $(".checkbox_member_manager_table:checked").length <= 0) {
			alert("권한 수정할 관리자를 먼저 선택해 주시기 바랍니다.");
			return;
		}

		$('.member_manager_settings_popup_box').fadeIn(350);
	}

	function setAuth() {
		// 선택된 관리자
		var authList = new Array();
		$(".checkbox_member_manager_table:checked").each(function() {
			var auth = new Object();
			auth.member_id = $(this).attr("member_id");

			var temp = $("#auth_announcement_menu_yn").is(':checked');
			if ( $("#auth_announcement_menu_yn").is(':checked') ) {
				auth.auth_announcement_menu_yn = "Y";
			} else {
				auth.auth_announcement_menu_yn = "N";
			}
			if ( $("#auth_reception_menu_yn").is(':checked') ) {
				auth.auth_reception_menu_yn = "Y";
			} else {
				auth.auth_reception_menu_yn = "N";
			}
			if ( $("#auth_evaluation_menu_yn").is(':checked') ) {
				auth.auth_evaluation_menu_yn = "Y";
			} else {
				auth.auth_evaluation_menu_yn = "N";
			}
			if ( $("#auth_execution_menu_yn").is(':checked') ) {
				auth.auth_execution_menu_yn = "Y";
			} else {
				auth.auth_execution_menu_yn = "N";
			}
			if ( $("#auth_agreement_menu_yn").is(':checked') ) {
				auth.auth_agreement_menu_yn = "Y";
			} else {
				auth.auth_agreement_menu_yn = "N";
			}
			if ( $("#auth_calculate_menu_yn").is(':checked') ) {
				auth.auth_calculate_menu_yn = "Y";
			} else {
				auth.auth_calculate_menu_yn = "N";
			}
			if ( $("#auth_notice_menu_yn").is(':checked') ) {
				auth.auth_notice_menu_yn = "Y";
			} else {
				auth.auth_notice_menu_yn = "N";
			}
			
			authList.push(auth);
		});

		var formData = new FormData();
		formData.append("manager_auth_list_json", JSON.stringify(authList));

 		$.ajax({
		    type : "POST",
		    url : "/admin/api/member/manager/menu/auth/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		        	alert("권한 수정이 완료되었습니다.");
		        	location.reload();
		        } else {
		        	alert("권한 수정에 실패하었습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		}); 
	}

	function selectAllManager() {
		if($("#total_permission").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			alert("총괄 관리자는 모든 메뉴에 권한이 있습니다. 따라서 선택되지 않습니다.");
			$("input.checkbox_member_manager_table[type=checkbox]").each(function() {
				if ( $(this).attr("member_type") == "manager" ) {
					$(this).prop("checked",true);
				}
			});
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$("input.checkbox_member_manager_table[type=checkbox]").prop("checked",false); 
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
						       <h2 class="title">회원관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li><a href="/admin/fwd/member/researcher/main" title="연구자">연구자</a></li>
								   <li><a href="/admin/fwd/member/commissioner/main" title="평가위원">평가위원</a></li>
								   <li><a href="/admin/fwd/member/expert/main" title="전문가">전문가</a></li>
								   <li class="on"><a href="/admin/fwd/member/manager/main" title="관리자 or 내부평가위원">관리자 or 내부평가위원</a></li>
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
							       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>회원관리</li>
								   <li><strong>관리자 or 내부평가위원</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">관리자 or 내부평가위원</h3>
							  <!--//페이지타이틀-->
						    </div>
					   </div>
                       <div class="contents_view">
						   <!--리스트 상단 검색-->
						   <div class="list_search_top_area">
							   <ul class="clearfix list_search_top clearfix">
								   <li class="clearfix">                
									   <label for="member_manager_list_search_merber_class" class="fl list_search_title ta_r mr10 w_8">구분</label>
									   <select name="member_manager_list_search_merber_class" id="member_manager_list_search_merber_class" class="ace-select fl w_18 mr5">
									   	   <option value="">전체</option>
										   <option value="option2">총괄관리자</option>
										   <option value="option3">평가관리자</option>
									   </select>
									   <div class="layer fl">									   	   
										   <div class="fl mt15 mr5">
											   <input type="checkbox" id="merber_class_check1" />
											   <label for="merber_class_check1">평가간사</label>
										   </div>
										   <div class="fl mt15">
											   <input type="checkbox" id="merber_class_check2" />
											   <label for="merber_class_check2">연구간사</label>
										   </div>
									   </div>
								   </li>
								   <li class="clearfix">
									   <label for="department_selector" class="fl list_search_title ta_r mr10 w_8">부서</label>
									   <select name="department_selector" id="department_selector" class="ace-select fl w_22" >
									   </select>
								   </li> 
							   </ul>
							   <ul class="clearfix list_search_top clearfix" style="margin-top: 2px;">
								   <li class="clearfix fln">
									   <label for="search_selector" class="fl list_search_title ta_r mr10 w_8">검색어</label>
									   <select name="search_selector" id="search_selector" class="ace-select fl w_18">
										   <option value="">전체</option>
										   <option value="name">성명</option>
										   <option value="member_id">아이디</option>
									   </select>
									   <input type="text" id="search_text" class="form-control brc-on-focusd-inline-block fl list_search_word_input ml5" style="width: 48%;" />									   
								   </li>								   
							   </ul>
							   <div class="list_search_btn clearfix">								   
								   <button type="button" class="fr gray_btn" onclick="initSearch();">초기화</button>
								   <button type="submit" class="fr blue_btn mr5" onclick="searchList(1);">검색</button>
							   </div>
						   </div>
						   <!--//리스트 상단 검색-->

						   <!--검색 결과-->
						   <div class="list_search_table">
							   <div class="table_count_area">
								   <div class="count_area clearfix">
									   <div class="fl mt15" id="search_count"></div>
									   <div class="fr">
									       <button type="button" id="reg_btn" style="display:none" class="fl blue_btn2 mr5" onclick="location.href='/admin/fwd/member/manager/registration'">계정 추가</button>
									       <button type="button" id="auth_btn" style="display:none" class="fl green_btn mr3" onclick="prepareSetAuth();">권한 설정</button>						       
									   </div>
								   </div>
							   </div>
							   <div style="overflow-x:auto;">
								   <table class="list th_c">
									   <caption>리스트 화면</caption>   
									   <colgroup>
										   <col style="width:5%" />
										   <col style="width:8%" />
										   <col style="width:15%" />
										   <col style="width:7%" />
										   <col style="width:7%" />
										   <col style="width:15%" />
										   <col style="width:8%" />
										   <col style="width:10%" />
										   <col style="width:15%" />
										   <col style="width:10%" />
									   </colgroup>
									   <thead>
										   <tr>
											   <th scope="col">
												   <input id="total_permission" type="checkbox" onclick="selectAllManager();" />
												   <label for="total_permission">권한</label>
											   </th>                                    
											   <th scope="col">구분</th>
											   <th scope="col">부서</th>
											   <th scope="col">직책</th>
											   <th scope="col">성명</th>
											   <th scope="col">아이디</th>
											   <th scope="col">메뉴별 권한</th>
											   <th scope="col">휴대전화</th>
											   <th scope="col">이메일</th>
											   <th scope="col">접속일</th>
										   </tr>
									   </thead>
									   <tbody id="list_body"></tbody>
								   </table>   
								   <!--//검색 결과-->                           
							   </div>  
							   <!--페이지 네비게이션-->
							   <input type="hidden" id="pageIndex" name="pageIndex"/>
							   <div class="page" id="pageNavi"></div>  
						   </div>
						   <!--//list_search_table-->
                       </div><!--//contents view--> 
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
            


			<!--관리자 권한 설정 팝업 - 메뉴별-->
	       <div class="member_manager_settings_popup_box">
			   <div class="popup_bg"></div>
			   <div class="member_manager_settings_popup">
			       <div class="popup_titlebox clearfix">
				       <h4 class="fl">관리자 권한 - 메뉴별 설정</h4>
				       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
				   </div>
				   <div class="popup_txt_area">
					   <p>해당 메뉴를 선택해주세요.</p>
					   <div class="ckeckboxlist_box">
					       <ul class="clearfix">					   
							   <li><input type="checkbox" id="have_menu_all" /><label for="have_menu_all">전체</label></li>
							   <li><input type="checkbox" id="auth_announcement_menu_yn" name="membermanagersettings" /><label for="have_menu_announcement">공고관리</label></li>
							   <li><input type="checkbox" id="auth_reception_menu_yn" name="membermanagersettings" /><label for="have_menu_reception">접수관리</label></li>
							   <li><input type="checkbox" id="auth_evaluation_menu_yn" name="membermanagersettings" /><label for="have_menu_estimation">평가관리</label></li>
							   <li><input type="checkbox" id="auth_execution_menu_yn" name="membermanagersettings" /><label for="have_menu_execute">수행관리</label></li>
							   <li><input type="checkbox" id="auth_agreement_menu_yn" name="membermanagersettings" /><label for="have_menu_agreement">협약관리</label></li>
							   <li><input type="checkbox" id="auth_calculate_menu_yn" name="membermanagersettings" /><label for="have_menu_compute">정산관리</label></li>
							   <li><input type="checkbox" id="auth_notice_menu_yn" name="membermanagersettings" /><label for="have_menu_information">알림&middot;정보관리</label></li>
					       </ul>
					   </div>
					   <!--select id="menu_manager_settings" class="ace-select w100">
						   <option value="전체">전체</option>
						   <option value="공고관리">공고관리</option>
						   <option value="접수관리">접수관리</option>
						   <option value="평가관리">평가관리</option>
						   <option value="수행관리">수행관리</option>
						   <option value="협약관리">협약관리</option>
						   <option value="정산관리">정산관리</option>
						   <option value="알림&middot;정보관리">알림&middot;정보관리</option>
						   <option value="평가위원관리">평가위원관리</option>
						   <option value="회원관리">회원관리</option>
					   </select-->
					   <div class="popup_button_area_center">
						   <button type="button" class="blue_btn mr5 popup_close_btn" onclick="setAuth();">수정</button>
						   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">닫기</button>
					   </div>
				   </div>
			   </div>
		   </div>
		   <!--//관리자 권한 설정 팝업 - 메뉴별-->	        
