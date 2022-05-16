<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
  
<script type='text/javascript'>
	$(document).ready(function() {
		<sec:authorize access="hasRole('ROLE_SUPER_ADMIN')">
			$("#withdrawal_btn").show();
			$("#modification_btn").show();
			$("#pwd_tr").show();
			$("#pwd_confirm_tr").show();
		</sec:authorize>

		
		// email Select
	 	$("#selectEmail").change(function(){
	 		if ( $("#selectEmail").val() == "1" ) {
				$("#email_2").attr("disabled", false);
				$("#email_2").val("");
			}
			else {
				$("#email_2").attr("disabled", true);
				if ( $("#selectEmail").val() != "0" ) {
					$("#email_2").val($("#selectEmail").val());
				}
				else {
					$("#email_2").val("");
				}
			}
		});		
		
		searchDetail();
		$(".auth_input").prop("disabled", true);
	});

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/member/manager/detail'/>");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("member_id", $("#member_id").val());
		comAjax.addParam("orderby", "LOGIN_DATE DESC");
		comAjax.ajax();
	}

	var memberInfo;
	function searchDetailCB(data){
		memberInfo = data.result_data;
		// 총괄 관리자
		if ( data.result_data.auth_level_admin == "Y") {
			$("#member_write_class1").prop('checked', true);
			$("#have_menu_all").prop('checked', true);
			$("input[name=membermanagersettings]").prop("checked",true);
		// 평가 관리자
		} else if ( data.result_data.auth_level_manager == "Y") {
			$("#member_write_class2").prop('checked', true);
			$("#member_write_class2").trigger("click");
			// 평가 간사
			if (data.result_data.evaluation_manager_yn == "Y") {
				$("#merber_class_check1").prop('checked', true);
			} 
			// 연구 간사
			if (data.result_data.research_manager_yn == "Y") {
				$("#merber_class_check2").prop('checked', true);
			}  
		}
		
		$("#id").html(data.result_data.member_id) ;
		$("#name").val(data.result_data.name) ;
		$("#department").val(data.result_data.department) ;
		$("#position").val(data.result_data.position) ;

		// 메뉴별 권한
		if ( data.result_data.auth_announcement_menu_yn == "Y") {
			$("#auth_announcement_menu_yn").prop('checked', true);
		}
		if ( data.result_data.auth_reception_menu_yn == "Y") {
			$("#auth_reception_menu_yn").prop('checked', true);
		}
		if ( data.result_data.auth_evaluation_menu_yn == "Y") {
			$("#auth_evaluation_menu_yn").prop('checked', true);
		}
		if ( data.result_data.auth_execution_menu_yn == "Y") {
			$("#auth_execution_menu_yn").prop('checked', true);
		}
		if ( data.result_data.auth_agreement_menu_yn == "Y") {
			$("#auth_agreement_menu_yn").prop('checked', true);
		}
		if ( data.result_data.auth_calculate_menu_yn == "Y") {
			$("#auth_calculate_menu_yn").prop('checked', true);
		}
		if ( data.result_data.auth_notice_menu_yn == "Y") {
			$("#auth_notice_menu_yn").prop('checked', true);
		}
		
		var mobilePhoneList = data.result_data.mobile_phone.split("-");
		$("#mobile_phone_1").val(mobilePhoneList[0]);
		$("#mobile_phone_2").val(mobilePhoneList[1]);
		$("#mobile_phone_3").val(mobilePhoneList[2]);
		var emailList = data.result_data.email.split("@");
		$("#email_1").val(emailList[0]);
		$("#email_2").val(emailList[1]);

		var history = "";
		data.result_data.history.forEach(function(value){
			history += value.substring(0, (value.length-2)) + "\r\n";
		});
		
		$("#history").val(history);
	}

	function prepareModification(element) {
		if( $(element).text() == '수정' ) {
            $(element).text('수정완료');	
            $("#pwd").prop("disabled", false);
    		$("#pwd_confirm").prop("disabled", false);

    	 	var condition = $(".d_input").prop( 'disabled' ); 
    	    $(".d_input").prop("disabled", condition ? false : true);

    	    // admin 계정은 기본적으로 모든 권한이다. 수정하지 못하게 한다.
    	    if ( memberInfo.auth_level_admin == "Y" ) {
    	    	$(".auth_input").prop("disabled", true);
       	    } else {
       	    	$(".auth_input").prop("disabled", false);
      	    }
        }
        else {
        	modification();
        }
	}

	function modification(){
		var chkVal = ["name", "mobile_phone_1", "mobile_phone_2", "mobile_phone_3", "email_1", "email_2" ];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		if ( (gfn_isNull($("#pwd").val()) && gfn_isNull($("#pwd_confirm").val()) == false) ||
			 (gfn_isNull($("#pwd").val()) == false && gfn_isNull($("#pwd_confirm").val()))
		 	) {
			alert("비밀번호 / 비밀번호 확인의 데이터는 둘다 있거나 둘다 없어야 합니다.");
			return;
	 	} else if ( (gfn_isNull($("#pwd").val()) == false && gfn_isNull($("#pwd_confirm").val()) == false) ){
	 		if ( $("#pwd").val() != $("#pwd_confirm").val() ) {
				alert("비밀번호와  비밀번호 확인 값이 다릅니다.");
				return false;
			}

			var reg = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
			var txt = $("#pwd").val();
			if( !reg.test(txt) ) {
			    alert("비밀번호는 영문, 숫자, 특수문자(@$!%*#?&) 조합하여 8자리 이상이어야 합니다.");
			    return false;
			}
	 	}

		var mailAddress;
		if ( gfn_isNull($("#email_1").val()) == false && gfn_isNull($("#email_2").val()) == false){
			mailAddress = $("#email_1").val() + "@" + $("#email_2").val();
		}
		else if (gfn_isNull($("#email_1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
			mailAddress =  $("#email_1").val() + "@" + $("select[name=selectEmail]").val();
		}
		else {
			alert("메일은(는) 필수입력입니다.");
			return;
		}

		var formData = new FormData();
		// admin 권한인 경우
		if ( $("#member_write_class1").is(':checked') ) {
			formData.append("auth_level_admin", "Y");
			formData.append("auth_level_manager", "N");
		} else {
			if ( $("#merber_class_check1").is(':checked') == false && $("#merber_class_check2").is(':checked') == false ) {
				alert("평가관리자를 선택해 주시기 바랍니다.");
				return;
			}

			formData.append("auth_level_admin", "N");
			formData.append("auth_level_manager", "Y");
		}

		if ( $("#merber_class_check1").is(':checked') ) {
			formData.append("evaluation_manager_yn", "Y");
		} else {
			formData.append("evaluation_manager_yn", "N");
		}
		if ( $("#merber_class_check2").is(':checked') ) {
			formData.append("research_manager_yn", "Y");
		} else {
			formData.append("research_manager_yn", "N");
		}
		if ( $("#auth_announcement_menu_yn").is(':checked') ) {
			formData.append("auth_announcement_menu_yn", "Y");
		} else {
			formData.append("auth_announcement_menu_yn", "N");
		}
		if ( $("#auth_reception_menu_yn").is(':checked') ) {
			formData.append("auth_reception_menu_yn", "Y");
		} else {
			formData.append("auth_reception_menu_yn", "N");
		}
		if ( $("#auth_evaluation_menu_yn").is(':checked') ) {
			formData.append("auth_evaluation_menu_yn", "Y");
		} else {
			formData.append("auth_evaluation_menu_yn", "N");
		}
		if ( $("#auth_execution_menu_yn").is(':checked') ) {
			formData.append("auth_execution_menu_yn", "Y");
		} else {
			formData.append("auth_execution_menu_yn", "N");
		}
		if ( $("#auth_agreement_menu_yn").is(':checked') ) {
			formData.append("auth_agreement_menu_yn", "Y");
		} else {
			formData.append("auth_agreement_menu_yn", "N");
		}
		if ( $("#auth_calculate_menu_yn").is(':checked') ) {
			formData.append("auth_calculate_menu_yn", "Y");
		} else {
			formData.append("auth_calculate_menu_yn", "N");
		}
		if ( $("#auth_notice_menu_yn").is(':checked') ) {
			formData.append("auth_notice_menu_yn", "Y");
		} else {
			formData.append("auth_notice_menu_yn", "N");
		}

		// Member 정보
		formData.append("name", $("#name").val());
		formData.append("member_id", $("#member_id").val());
		formData.append("pwd", $("#pwd").val());
		formData.append("mobile_phone", $("#mobile_phone_1").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val());
		formData.append("email", mailAddress);
		formData.append("department", $("#department").val());
		formData.append("position", $("#position").val());

	 	if(confirm("수정하시겠습니까?")){
			 $.ajax({
		    	type : "POST",
			    url : "/admin/api/member/manager/modification",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true ) {
			        	alert("수정 성공 하였습니다.");
			        	location.href='/admin/fwd/member/manager/main';
			        } else {
			        	alert("수정 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		 }
	}

	function withdrawal() {
		var formData = new FormData();
		formData.append("member_id", $("#member_id").val());

		if(confirm("삭제하시겠습니까? 삭제된 데이터는 복구되지 않습니다.")){
			 $.ajax({
		    	type : "POST",
			    url : "/admin/api/member/manager/withdrawal",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true ) {
			        	alert("삭제 성공 하였습니다.");
			        	location.href='/admin/fwd/member/manager/main';
			        } else {
			        	alert("삭제 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		 }
	}

</script>

<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />	
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
					    <div class="contents_view sub_view">
						   <!--관리자 or 내부평가위원 view-->
						   <div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">관리자 or 내부평가위원</h4>
							   <!-- <span class="fr"><input type="checkbox" class="checkbox_member_manager_table" /><label>이용 중지</label></span> -->
						   </div>
						   <table class="list2">
							   <caption>관리자 or 내부평가위원</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <thead>
								   <tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>관리자 구분</span></th>
									   <td>
									       <div class="fl mr20">
									           <input type="radio" name="member_write_class" id="member_write_class1" class="checkbox_member_manager_table d_input" onclick="$('.auth_input').prop('disabled', true);$('.auth_input').prop('checked', true);$('#merber_class_check1').prop('checked', false);$('#merber_class_check2').prop('checked', false);" checked disabled />
									           <label for="member_write_class">총괄관리자</label>
									       </div>
										   <div class="fl mr10">
									           <input type="radio" name="member_write_class" id="member_write_class2" class="checkbox_member_manager_table d_input" onclick="$('.auth_input').prop('disabled', false);" disabled />
									           <label for="member_write_class2">평가관리자</label>
										   </div>
										   
										   <div class="layer fl clearfix" style="display: none;margin-top:1px">									   	   
											   <div class="fl mr5">
												   <input type="checkbox" class="d_input" id="merber_class_check1" disabled>
												   <label for="merber_class_check1">평가간사</label>
											   </div>
											   <div class="fl">
												   <input type="checkbox" class="d_input" id="merber_class_check2" disabled>
												   <label for="merber_class_check2">연구간사</label>
											   </div>
										   </div>
									   </td> 
								   </tr>
							   </thead>
							   <tbody>
								   <tr>
									   <th scope="row">아이디</th>
									   <td id="id"><span>abc123</span></td> 
								   </tr>
								   <tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="totalmanager_name">성명</label></span></th>
									   <td><input type="text" title="성명" id="name" class="form-control w_40 d_input" disabled /></td> 
								   </tr>
								   <tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>메뉴별 권한</span></th> 
									   <td>
									   	   <input type="checkbox" id="have_menu_all" class="auth_input" disabled />
									   	   <label for="have_menu_all" class="mr10">전체</label>
										   <input type="checkbox" id="auth_announcement_menu_yn" name="membermanagersettings" class="auth_input" disabled>
										   <label for="have_menu_announcement" class="mr10">공고관리</label>
									       <input type="checkbox" id="auth_reception_menu_yn" name="membermanagersettings" class="auth_input" disabled>
									       <label for="have_menu_reception" class="mr10">접수관리</label>
										   <input type="checkbox" id="auth_evaluation_menu_yn" name="membermanagersettings" class="auth_input" disabled checked>
										   <label for="have_menu_estimation" class="mr10">평가관리</label>
					                       <input type="checkbox" id="auth_execution_menu_yn" name="membermanagersettings" class="auth_input" disabled checked>
					                       <label for="have_menu_execute" class="mr10">수행관리</label>
                                           <input type="checkbox" id="auth_agreement_menu_yn" name="membermanagersettings" class="auth_input" disabled>
                                           <label for="have_menu_agreement" class="mr10">협약관리</label>
										   <input type="checkbox" id="auth_calculate_menu_yn" name="membermanagersettings" class="auth_input" disabled>
										   <label for="have_menu_compute" class="mr10">정산관리</label>
                                           <input type="checkbox" id="auth_notice_menu_yn" name="membermanagersettings" class="auth_input" disabled>
                                           <label for="have_menu_information" class="mr10">알림·정보관리</label>
									   </td>
								   </tr>
								   <tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="totalmanager_cellphone">휴대전화</label></span></th> 
									   <td>
										   <form name="phone_number" class="clearfix">
											   <input type="tel" title="휴대전화" maxlength="3" id="mobile_phone_1" class="form-control  w_5-5 fl d_input" disabled />
											   <span style="display:block;" class="fl mc8">-</span>
											   <input type="tel" title="휴대전화" maxlength="4" id="mobile_phone_2" class="form-control brc-on-focusd-inline-block w_6 fl d_input" disabled />
											   <span style="display:block;" class="fl mc8">-</span>
											   <input type="tel" title="휴대전화" maxlength="4" id="mobile_phone_3" class="form-control brc-on-focusd-inline-block w_6 fl d_input" disabled />
										   </form>
									   </td>
								   </tr>
								   <tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="str_email">이메일</label></span></th>
									   <td>
										   <input type="text" title="이메일" name="email_1" id="email_1" class="form-control w_20 fl d_input" disabled />
										   <span class="fl ml1 mr1 pt10 mail_f">@</span>
										   <input type="text" title="이메일" name="email_2" id="email_2" class="form-control w_18 fl" disabled />
										   <!--이메일 선택-->
										   <select name="selectEmail" id="selectEmail" class="fl ml5 w_20 ace-select d_input" disabled> 
											   <option value="0" selected="">-------선택-------</option> 
											   <option value="1">직접입력</option> 
											   <option value="naver.com">naver.com</option> 
											   <option value="hanmail.net">hanmail.net</option> 
											   <option value="hotmail.com">hotmail.com</option> 
											   <option value="nate.com">nate.com</option> 
											   <option value="yahoo.co.kr">yahoo.co.kr</option> 
											   <option value="empas.com">empas.com</option> 
											   <option value="dreamwiz.com">dreamwiz.com</option> 
											   <option value="freechal.com">freechal.com</option> 
											   <option value="lycos.co.kr">lycos.co.kr</option> 
											   <option value="korea.com">korea.com</option> 
											   <option value="gmail.com">gmail.com</option> 
											   <option value="hanmir.com">hanmir.com</option> 
											   <option value="paran.com">paran.com</option> 
											</select>
									   </td> 
								   </tr>
								   <tr>
									   <th scope="row"><label for="totalmanager_Jobdepartment">부서</label></th> 
									   <td><input type="text" id="department" class="form-control w_40 d_input" disabled /></td>
								   </tr>
								   <tr>
									   <th scope="row"><label for="totalmanager_Jobposition">직책</label></th> 
									   <td><input type="text" id="position" class="form-control w_40 d_input" disabled/></td>
								   </tr>
								<tr id="pwd_tr" style="display:none">
								   <th scope="row"><label for="pwd">비밀번호</label></th>
								   <td>
								   		<input type="password" id="pwd" title="비밀번호" class="form-control w_40 fl mr10" disabled/>
								   		<span class="fl lh_15"><span class="font_red">영문, 숫자, 특수문자(@$!%*#?&)</span> 조합하여 <span class="font_red">8자리 이상</span></span> 
								   	</td>
							   </tr>
				   
							   <tr id="pwd_confirm_tr" style="display:none">
								   <th scope="row"><label for="pwd_confirm">비밀번호 확인</label></th> 
								   <td>
								   		<input type="password" id="pwd_confirm" title="비밀번호확인" class="form-control w_40 fl mr10" disabled/>
								  	 	<span class="fl lh_15"><span class="font_red">영문, 숫자, 특수문자(@$!%*#?&)</span> 조합하여 <span class="font_red">8자리 이상</span></span>
						  	 		</td>
							   </tr>
								   <tr>
									   <th scope="row"><label for="history">접속 이력</label></th>
									   <td>
										   <textarea cols="40" id="history" class="mr10 w_40 fl" style="height:110px" disabled></textarea>
										   <br />
										  <!--  <div class="clearfix w_40 fl mt15">
										   		<input type="checkbox" id="totalmanager_finaldayrecord" class="checkbox_member_manager_table ml5"><label for="totalmanager_finaldayrecord">최종 접속일</label><br />
										   		<button type="button" class="mt5 blue_btn2">접속 이력 조회</button>
										   </div>	 -->							  
									   </td> 
								   </tr>							   
							   </tbody>
						   </table>                       
						   <!--//관리자 or 내부평가위원 view-->
						   <div class="fr mt30 clearfix">
						   		<button type="button" id="withdrawal_btn" style="display:none" class="blue_btn fl mr5" onclick="withdrawal();">삭제</button>
							   	<button type="button" id="modification_btn" style="display:none" class="blue_btn fl mr5" onclick="prepareModification(this);">수정</button>
							   	<button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/member/manager/main'">목록</button>
						   </div>
					   </div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>