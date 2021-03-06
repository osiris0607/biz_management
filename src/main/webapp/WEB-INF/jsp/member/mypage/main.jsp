<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var isModification = false;
	
	$(document).ready(function() {
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

	 	initDepratmentType();
	 	searchDetail();
		
	});

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/detail'/>");
		comAjax.setCallback(getDetailCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.ajax();
	}
	
	function getDetailCB(data){
		$("#name").html("<span>" + data.result.name + "</span>");
		$("input:radio[name=department_type]:input[value='" + data.result.institution_type + "']").prop("checked", true);
		$("#member_id").html("<span>" + data.result.member_id + "</span>");
		var mobilePhoneList = data.result.mobile_phone.split("-");
		$("#mobile_phone_2").val(mobilePhoneList[1]);
		$("#mobile_phone_3").val(mobilePhoneList[2]);
		var emailList = data.result.email.split("@");
		$("#email_1").val(emailList[0]);
		$("#email_2").val(emailList[1]);
		$("#address").val(data.result.address);
		$("#address_detail").val(data.result.address_detail);
		$("#institution_name").val(data.result.university);
		$("#institution_address").val(data.result.lab_address);
		$("#institution_address_detail").val(data.result.lab_address_detail);
		var institutionPhoneList = data.result.lab_phone.split("-");
		$("#phone_1").val(institutionPhoneList[0]);
		$("#phone_2").val(institutionPhoneList[1]);
		$("#phone_3").val(institutionPhoneList[2]);
		$("#department").val(data.result.department);
		$("#position").val(data.result.position);
	}


	function modificaiton(){
		var chkVal = ["mobile_phone_2", "mobile_phone_3", "address", "email_1", "email_2" ];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				showPopup($("#" + chkVal[i]).attr("title") + "???(???) ?????????????????????.","?????? ?????? ??????");
				$("#" + chkVal[i]).focus();
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
    		showPopup("?????????(???) ?????????????????????.", "?????? ?????? ??????");
			return;
		}
		if ( $("input:radio[name=department_type]").is(':checked') == false ) {
    		showPopup("???????????? ????????? ?????? ???????????????.", "?????? ?????? ??????");
    		return;
		}

		var formData = new FormData();
		// Member ??????
		formData.append("department_type", $("input:radio[name=department_type]:checked").val());
		formData.append("member_id", '${member_id}');
		formData.append("pwd", $("#pwd").val());
		temp = $("#mobile_phone_selector").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val();
		formData.append("mobile_phone", temp);
		formData.append("email", mailAddress);
		formData.append("address", $("#address").val());
		formData.append("address_detail", $("#address_detail").val());
		// ?????? ??????		
		formData.append("university", $("#institution_name").val());
		formData.append("lab_address", $("#institution_address").val());
		formData.append("lab_address_detail", $("#institution_address_detail").val());
		var phoneNum = $("#phone_1").val() + "-" + $("#phone_2").val()+ "-" + $("#phone_3").val();
		formData.append("lab_phone", phoneNum);
		formData.append("department", $("#department").val());
		formData.append("position", $("#position").val());

		$.ajax({
		    type : "POST",
		    url : "/member/api/mypage/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	showPopup("?????? ?????? ????????? ??????????????????.","?????? ?????? ?????? ??????");
		        	isModification = true;
		        } else {
		        	showPopup("?????? ?????? ????????? ??????????????????. ?????? ????????? ????????? ????????????.","?????? ?????? ?????? ??????");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});

	}

	function checkPwd() {
		var formData = new FormData();
		formData.append("member_id", '${member_id}');
		formData.append("pwd", $("#check_pwd").val());
			
		$.ajax({
		    type : "POST",
		    url : "/member/api/mypage/check/id",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
			        // ?????? ????????? ???????????? ?????? ??????
		        	$('.company_signup_popup_box, .company_signup_popup_box .popup_bg, .company_signup_popup_open_info').fadeOut(350);
		    		//??????????????? disabled ?????? 
		    		$(".d_input").attr('disabled', false);
		    		$('.member_info_save2, .member_area_table button').css('display', 'block');
		    		$('.member_info_popup_open2').css('display', 'none');
		    		$(".address_detail").attr('disabled', false);
		    		$(".institution_address_detail").attr('disabled', false);
		    		
		        } else {
		        	showPopup("??????????????? ????????????. ?????? ????????? ????????? ????????????.","???????????? ??????");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function newPwdConfirm()
	{
		if ( $("#pwd").val() != $("#pwd_confirm").val() ) {
			alert("???????????????  ???????????? ?????? ?????? ????????????.");
			return;
		}

		var reg = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
		var txt = $("#pwd").val();
		if( !reg.test(txt) ) {
		    alert("??????????????? ??????, ??????, ????????????(@$!%*#?&) ???????????? 8?????? ??????????????? ?????????.");
		    return false;
		}

		$('.pw_change_popup_box, .popup_bg').fadeOut(350);
	}

	// ????????? ?????? ????????? ?????????.
	function initDepratmentType(){
		$("#depratment_type").empty();

		var index = 1;
		var str = "";
       	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000004'}">
				if (index == 1) {
					str += "<input type='radio' id='department_type_radio' name='department_type' value='${code.detail_id}' checked >";
				}
				else {
					str += "<input type='radio' id='department_type_radio' name='department_type' value='${code.detail_id}'>";
				}
				
				str += "<label for='department_type_radio'>${code.name}</label>";
				index++;
			</c:if>
		</c:forEach>
		$("#depratment_type").append(str);
	}

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
		if ( isModification == true) {
			location.reload();
		}
	}

</script>

<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">?????? ????????? ??????</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area clearfix">
				<h3 class="hidden">??????????????????</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">???</i></li>
						<li>???????????????</li>
						<li>??????????????????</li>
					</ul>
				</div>
				<div id="lnb" class="fl">
					<!-- lnb_area -->	
					<div class="lnb_area">
						<!-- lnb_title_area -->	
						<div class="lnb_title_area">
							<h2 class="title">???????????????</h2>
						</div>
						<!--// lnb_title_area -->
						<!-- lnb_menu_area -->
						<div class="lnb_menu_area">
							<!-- lnb_menu -->	
							<ul class="lnb_menu">
								<li>
									<a href="/member/fwd/mypage/institution" title="??????????????????" ><span>??????????????????</span></a>									
								</li>
								<li>
									<a href="/member/fwd/mypage/main" title="?????????????????? ???????????? ??????" class="active"><span>??????????????????</span></a>									
								</li>
								<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/expert" title="????????? ?????? ??????" ><span>????????? ?????? ??????</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="????????????????????????" ><span>???????????? ?????? ??????</span></a>				
									</li>
								</sec:authorize>
								<li>
									<a href="/member/fwd/mypage/report" title="?????? ???????????? ?????? ?????? ???????????? ??????"><span>?????? ???????????? ?????? ??????</span></a>									
								</li>
							</ul>
							<!--// lnb_menu -->
						</div><!--//lnb_menu_area-->
					</div><!--//lnb_area-->
				</div>
				<!--//lnb-->
				<div class="sub_right_contents fl">
					<h3>??????????????????</h3>								
					<!--????????????-->
					<h4>?????? ??????</h4>
					<div class="table_area member_area_table">
						<table class="write fixed">
							<caption>????????? ??????</caption>
							<colgroup>
								<col style="width: 20%;">																		
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">??????</th>
									<td id="name"></td>	
								</tr>									  
								<tr>
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>???????????? ??????</span></th>
									<td id="depratment_type">
									</td>													
								</tr>
								<tr>
									<th scope="row">?????????</th>
									<td class="ls" id="member_id"><span>abc123</span></td>	
								</tr>
								<tr>
									<th scope="row"><label for="pw_check">????????????</label></th>
									<td>
										<input type="password" id="pw_check" class="w_20 fl d_input2" placeholder="********" disabled title="????????????"/>
										<button type="button" class="gray_btn2 fl ml5 pw_change_popup_open d_input" title="??????" style="display:none">??????</button>		
									</td>	
								</tr>
								<tr>
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="mobile_phone_selector">????????????</label></span></th>
									<td class="clearfix">
										<select name="mobile_phone_selector" id="mobile_phone_selector" class="w_8 fl d_input" disabled>
											<option value="010">010</option>
										</select>
										<span style="display:block;" class="fl mc8">-</span>
										<label for="mobile_phone_2" class="hidden">????????????</label>
										<input type="tel" id="mobile_phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" title="????????????" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" disabled placeholder="" />
										<span style="display:block;" class="fl mc8">-</span>
										<label for="mobile_phone_3" class="hidden">????????????</label>
										<input type="tel" id="mobile_phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" title="????????????" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" disabled placeholder="" />
									</td>	
								</tr>
								<tr>
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="email_1">?????????</label></span></th>
									<td>
										<input type="text" name="email_1" id="email_1" class="form-control w_20 fl d_input" disabled placeholder="" title="?????????"/>
										<span class="fl ml1 mr1 pt10 mail_f">@</span>
										<label for="email_2" class="hidden">?????????</label>
										<input type="text" name="email_2" id="email_2" class="form-control w_18 fl" disabled placeholder="" title="?????????"/>
										<label for="selectEmail" class="hidden">?????????</label>
										<select name="selectEmail" id="selectEmail" class="fl ml5 in_wp200 ace-select d_input" disabled> 
										   <option value="0">------??????------</option> 
										   <option value="1">????????????</option> 
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
									<th scope="row">
										<span class="icon_box">
											<span class="necessary_icon">*</span>
											<label for="address">??????</label>
										</span>
									</th>
									<td>
										<input type="text" id="address" class="form-control w60 fl mr5" placeholder="" disabled title="??????"/>
										<label for="address_detail" class="hidden">??????</label>
										<input type="text" id="address_detail" class="form-control w30 fl mr5 d_input" placeholder="" disabled />
										<button type="button" class="gray_btn2 fl d_input" title="??????" style="display:none" onclick="execPostCode('address');">??????</button>												
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="institution_name">?????????</label></th>
									<td>
										<input type="text" id="institution_name" class="form-control w60 fl" placeholder="" disabled />																	
									</td>	
								</tr>
								<tr>
									<th scope="row"><label for="institution_address">?????? ??????</label></th>
									<td>
										<input type="text" id="institution_address" class="form-control w60 fl mr5" placeholder="" disabled title="?????? ??????"/>
										<label for="institution_address_detail" class="hidden">??????</label>
										<input type="text" id="institution_address_detail" class="form-control w30 fl mr5" placeholder="" disabled />		
										<!-- <button type="button" class="gray_btn2 fl" title="??????" style="display:none" onclick="execPostCode('institution_address');">??????</button> -->
									</td>	
								</tr>
								<tr>
									<th scope="row">
										<label for="phone_1">??????</label>
									</th> 
									<td>
										<input type="number" id="phone_1" maxlength="3" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" disabled title="?????? ??????">
										<span style="display:block;" class="fl mc8">-</span>
										<label for="phone_2" class="hidden">??????</label>
										<input type="number" id="phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" disabled title="?????? ??????">
										<span style="display:block;" class="fl mc8 ls">-</span>
										<label for="phone_3" class="hidden">??????</label>
										<input type="number" id="phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" disabled title="?????? ??????">
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="department">??????</label></th>
									<td>
										<input type="text" id="department" class="form-control w34 fl d_input" disabled placeholder="" />
									</td>	
								</tr>
								<tr>
									<th scope="row"><label for="position">??????</label></th>
									<td>
										<input type="text" id="position" class="form-control w34 fl d_input" disabled placeholder="" />
									</td>	
								</tr>
							</tbody>
						</table>
					</div>
					<button type="button" title="???????????? ??????" class="blue_btn fr mt10 mb5 member_info_popup_open2">???????????? ??????</button>
					<button type="button" title="??????" class="blue_btn fr mt10 mb5 member_info_save2" style="display:none" onclick="modificaiton();">??????</button>
					<!--//????????????-->	
				
								
				</div><!--//sub_right_contents-->
			</div><!--//content_area-->
		</div><!--//sub_contents-->

	</section><!--//content-->
</div>
 
 
 <!--???????????? ?????? ??????-->
<div class="member_info_popup_box">
	<div class="popup_bg"></div>
	<div class="member_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">???????????? ??????</h4>
			<a href="javascript:void(0)" title="??????" class="white_font close_btn company_signup_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p tabindex="0">??????????????? ?????? ??? ??????????????????.</p>
				<label for="check_pwd" class="hidden">???????????? ??????</label>
				<input type="password" class="login_form_input w40" id="check_pwd" placeholder="??????????????? ??????????????????." maxlength="20" />	
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" onclick="checkPwd();">??????</button>
			</div>
		</div>						
	</div> 
</div>
<!--//?????????????????? ??????-->

<!--???????????? ?????? ??????-->
<div class="pw_change_popup_box">		
	<div class="popup_bg"></div>
	<div class="pw_change_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">???????????? ??????</h4>
            <a href="javascript:void(0)" onclick="$('.pw_change_popup_box, .popup_bg').fadeOut(350);" title="??????" class="white_font close_btn logout_popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="table_area">
				<table class="write fixed">
					<caption>???????????? ??????</caption>
					<colgroup>
						<col style="width: 40%;">																		
						<col style="width: 60%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><label for="pwd">????????????</label></th>
							<td>
								<input type="password" id="pwd" class="w100" />								
							</td>	
						</tr>									  
						<tr>
							<th scope="row"><label for="pwd_confirm">???????????? ??????</label></th>
							<td>
								<input type="password" id="pwd_confirm" class="w100" />								
							</td>	
						</tr>									
					</tbody>
				</table>
			</div>	
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" onclick="newPwdConfirm();">??????</button>
			</div>
		</div>									
	</div> 
</div>
<!--//???????????? ?????? ??????-->


<!--?????? ??????-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="??????" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" title="??????" onclick="commonPopupConfirm();">??????</button>
			</div>
		</div>						
	</div> 
</div>
