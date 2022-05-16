<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	var isCheckId = false;

	$(document).ready(function() {
		// email Select
	 	$("#selectEmail").change(function(){
	 		if ( $("#selectEmail").val() == "1" ) {
				$("#email2").attr("disabled", false);
				$("#email2").val("");
			}
			else {
				$("#email2").attr("disabled", true);
				if ( $("#selectEmail").val() != "0" ) {
					$("#email2").val($("#selectEmail").val());
				}
				else {
					$("#email2").val("");
				}
			}
		});
		
	});
	
	function registration(){
		if ( isCheckId == false) {
			alert("이이디 중복체크를 해 주시기 바랍니다.");
			return;
		}
	
		var chkVal = ["member_id", "name", "pwd", "pwd_confirm","mobile_phone_1", "mobile_phone_2", "mobile_phone_3", "address", "address_detail" ];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		if ( $("#member_id").val().length < 4  ) {
			alert("아이디는 4자리 이상이어야 합니다.");
			return;
		}
		if ( $("#member_id").val().isEngNum() == false  ) {
			alert("아이디는 영어 숫자만 가능 합니다.");
			return;
		}


		if ( $("#pwd").val() != $("#pwd_confirm").val() ) {
			alert("비밀번호와  비밀번호 확인 값이 다릅니다.");
			return;
		}

		var reg = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
		var txt = $("#pwd").val();
		if( !reg.test(txt) ) {
		    alert("비밀번호는 영문, 숫자, 특수문자(@$!%*#?&) 조합하여 8자리 이상이어야 합니다.");
		    return false;
		}
		
		var mailAddress;
		if ( gfn_isNull($("#email1").val()) == false && gfn_isNull($("#email2").val()) == false){
			mailAddress = $("#email1").val() + "@" + $("#email2").val();
		}
		else if (gfn_isNull($("#email1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
			mailAddress =  $("#email1").val() + "@" + $("select[name=selectEmail]").val();
		}
		else {
			alert("메일은(는) 필수입력입니다.");
			return;
		}


		var formData = new FormData();
		// admin 권한인 경우
		if ( $("#member_write_class").is(':checked') ) {
			formData.append("auth_level_admin", "Y");
			formData.append("auth_level_manager", "N");
		} else {
			if ( $("#merber_class_check1").is(':checked') == false && $("#merber_class_check2").is(':checked') == false ) {
				alert("평가관리자를 선택해 주시기 바랍니다.");
				return;
			}

			formData.append("institution_type", "D0000007");
			formData.append("auth_level_admin", "N");
			formData.append("auth_level_manager", "Y");
			
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
		}
		// Member 정보
		formData.append("name", $("#name").val());
		formData.append("member_id", $("#member_id").val());
		formData.append("pwd", $("#pwd").val());
		temp = $("#mobile_phone_1").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val();
		formData.append("mobile_phone", temp);
		formData.append("email", mailAddress);
		formData.append("department", $("#department").val());
		formData.append("position", $("#position").val());

		 if(confirm("등록하시겠습니까?")){
			 $.ajax({
		    	type : "POST",
			    url : "/admin/api/member/manager/registration",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true ) {
			        	alert("등록 성공 하였습니다.");
			        	location.href='/admin/fwd/member/manager/main';
			        } else {
			        	alert("등록 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		 }
	}
	
	function checkId(){
		if ( $("#member_id").val() == null || $("#member_id").val() == "") {
		 	alert("아이디를 먼저 입력하시기 바랍니다.");
			return;
		}
		if ( $("#member_id").val().length < 4  ) {
			alert("아이디는 4자리 이상이어야 합니다.");
			return;
		}
		if ( $("#member_id").val().isEngNum() == false  ) {
			alert("아이디는 영어 숫자만 가능 합니다.");
			return;
		}
		
		var formData = new FormData();
		formData.append("member_id", $("#member_id").val());
	
		$.ajax({
		    type : "POST",
		    url : "/user/api/member/check/id",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		    	if (jsonData.result == "SUCCESS") {
		    		isCheckId = true;
		    		alert("해당 아이디는 사용 가능합니다.");
		    	}
		    	else {
		    		isCheckId = false;
		    		alert("해당 아이디는 중복 됩니다. 다른 아이디로 다시 입력해 주시기 바랍니다.");
		    	}
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
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
							       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>회원관리</li>
								   <li>관리자 or 내부평가위원</li>
								   <li><strong>관리자 계정추가</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">관리자 계정추가</h3>
							  <!--//페이지타이틀-->
						    </div>
					    </div>

					   <!--관리자 or 내부평가위원 view-->
                       <div class="view_top_area clearfix">
					       <h4 class="fl sub_title_h4">기본정보</h4>
					   </div>
                       <table class="list2">
						   <caption>관리자 추가 기본정보</caption> 
						   <colgroup>
							   <col style="width: 20%" />
							   <col style="width: 80%" />
						   </colgroup>
						   <thead>
						   	    <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>구분</span></th> 
								   <td>
								       <div class="fl mr20">
									       <input type="radio" name="member_write_class" id="member_write_class" value="D0000001" checked onclick="$('#auth_menu_tr').hide();">
									       <label for="member_write_class">총괄관리자</label>
									   </div>
									   <div class="fl mr10">
									       <input type="radio" name="member_write_class" id="member_write_class2" onclick="$('#auth_menu_tr').show();">
									       <label for="member_write_class2">평가관리자</label>
									   </div>
									   <div class="layer fl clearfix" style="display: none;margin-top:1px">									   	   
										   <div class="fl mr5">
											   <input type="checkbox" id="merber_class_check1" value="D0000002">
											   <label for="merber_class_check1">평가간사</label>
										   </div>
										   <div class="fl">
											   <input type="checkbox" id="merber_class_check2" value="D0000003">
											   <label for="merber_class_check2">연구간사</label>
										   </div>
									   </div>
								   </td>								   
							   </tr>	
						   </thead>
						   <tbody>
							   <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="name">성명</label></span></th>
								   <td><input type="text" id="name" class="form-control w_18 fl" /></td> 
							   </tr>					  
							   <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="member_id">아이디</label></span></th>
								   <td class="clearfix">									   
									   <input type="text" id="member_id" class="form-control w_40 fl" />
									   <button type="button" class="gray_btn2 fl ml5 id_check_btn mr10" onclick="checkId();">중복확인</button>
									   <span class="fl lh_15"><span class="font_red">영문, 숫자</span> 포함하여 <span class="font_red">4자리</span> 이상</span>							   
								   </td> 
							   </tr>
							   <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="pwd">비밀번호</label></span></th>
								   <td>
								   		<input type="password" id="pwd" title="비밀번호" class="form-control w_40 fl mr10" />
								   		<span class="fl lh_15"><span class="font_red">영문, 숫자, 특수문자(@$!%*#?&)</span> 조합하여 <span class="font_red">8자리 이상</span></span> 
								   	</td>
							   </tr>
				   
							   <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="pwd_confirm">비밀번호 확인</label></span></th> 
								   <td>
								   		<input type="password" id="pwd_confirm" title="비밀번호확인" class="form-control w_40 fl mr10" />
								  	 	<span class="fl lh_15"><span class="font_red">영문, 숫자, 특수문자(@$!%*#?&)</span> 조합하여 <span class="font_red">8자리 이상</span></span>
						  	 		</td>
							   </tr>
							   <tr id="auth_menu_tr" style="display:none">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="member_write_menu">메뉴별 권한</label></span></th> 
								   <td>
									   <input type="checkbox" id="have_menu_all">
									   <label for="have_menu_all" class="mr5">전체</label>&nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_announcement_menu_yn" name="membermanagersettings">
									   <label for="auth_announcement_menu_yn"  class="mr5">공고관리</label>&nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_reception_menu_yn" name="membermanagersettings">
									   <label for="auth_reception_menu_yn"  class="mr5">접수관리</label>&nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_evaluation_menu_yn" name="membermanagersettings">
									   <label for="auth_evaluation_menu_yn"  class="mr5">평가관리</label>&nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_execution_menu_yn" name="membermanagersettings">
									   <label for="auth_execution_menu_yn" class="mr5">수행관리</label>&nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_agreement_menu_yn" name="membermanagersettings">
									   <label for="auth_agreement_menu_yn" class="mr5">협약관리</label> &nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_calculate_menu_yn" name="membermanagersettings">
									   <label for="auth_calculate_menu_yn" class="mr5">정산관리</label>&nbsp;&nbsp;&nbsp;
									   <input type="checkbox" id="auth_notice_menu_yn" name="membermanagersettings">
									   <label for="auth_notice_menu_yn"  class="mr5">알림·정보관리</label>&nbsp;&nbsp;&nbsp;
								   </td>
							   </tr>
							   <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="phone_number">전화번호</label></span></th> 
								   <td>
								       <form name="phone_number" class="clearfix">
										   <input type="tel" maxlength="3" id="mobile_phone_1" title="휴대전화" class="form-control  w_5-5 fl">
										   <span style="display:block;" class="fl mc8">-</span>
										   <input type="tel" maxlength="4" id="mobile_phone_2" title="휴대전화" class="form-control brc-on-focusd-inline-block w_6 fl">
										   <span style="display:block;" class="fl mc8">-</span>
										   <input type="tel" maxlength="4" id="mobile_phone_3" title="휴대전화" class="form-control brc-on-focusd-inline-block w_6 fl">
									   </form>
								   </td>
							   </tr>
							   <tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="str_email">이메일</label></span></th> 
								   <td>
								       <input type="text" name="email1" id="email1" class="form-control w_20 fl" />
										<span class="fl ml1 mr1 pt10 mail_f">@</span>
										<input type="text" name="email2" id="email2" class="form-control w_18 fl" disabled />
										<label for="email2" class="hidden">이메일</label>
										<label for="selectEmail" class="hidden">이메일 선택</label>
								  	 	<select name="selectEmail" id="selectEmail" class="fl ml5 w_18 ace-select"> 
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
								   <th scope="row"><label for="department">부서</label></th>
								   <td>
								       <input type="text" id="department" class="form-control w_40" />
								   </td> 
							   </tr>
							   <tr>
								   <th scope="row"><label for="position">직책</label></th> 
								   <td><input type="text" id="position" class="form-control w_40" /></td>
							   </tr>							  
						   </tbody>
					   </table>                       
					   <!--//회원관리 view-->
					   <div class="fr mt30 clearfix">
					       <button type="button" class="blue_btn member_manager_assi_view_revise_popup_open mr5 fl" onclick="registration();">등록</button>
	                       <button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/member/manager/main'">목록</button>
					   </div>					   
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
            