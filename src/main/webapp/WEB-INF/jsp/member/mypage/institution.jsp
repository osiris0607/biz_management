<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var	isCheckRegNo = false;
	var	existInstitution = false;
	var	isFirstSearchInstitution = true;
	var	isRegInstitutionResult = false;
	var	isRegRepresentativeResult = false;

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
						
		initDepratmentType();
		searchInstitution();
		searchRepresentative();
	});


	function searchInstitution() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
		comAjax.setCallback(getInstitutionCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.ajax();
	}
	
	function getInstitutionCB(data){
		// 데이터가 없으면 Return
		if ( data.result == null || data.result.reg_no == "") {
			// 최초 화면 로딩시가 아니면 사업자번호 검색 버튼을 누른것이다.
			// 사업자 번호 존재 여부를 찾는다. 사업자 번호가 없으면 팝업을 띄운다.
			if ( isFirstSearchInstitution == false) {
				// 데이터 존재 여부를 떠나서 사업자번호 검색은 한 것이다.
				isCheckRegNo = true;

				$("#reg_no_err").html("<span class='font_blue'>" + $("#reg_no").val() + "</span> 은<br/>기관으로 등록되어 있지 않습니다.<br/>기관정보를 직접 입력해 주세요.");
				$('.mypage_company_name_popup_box, .mypage_company_name_popup_box .popup_bg').fadeIn(350);
			}
			return;
		}

		isCheckRegNo = true;
		existInstitution = true;
		
		$("input:radio[name=expert_department_type]:input[value='" + data.result.type + "']").prop("checked", true);
		$("#reg_no").val(data.result.reg_no);
		$("#mypage_company_name").val(data.result.name);
		$("#address").val(data.result.address);
		$("#address_detail").val(data.result.address_detail);
		var phoneList = data.result.phone.split("-");
		$("#phone_1").val(phoneList[0]);
		$("#phone_2").val(phoneList[1]);
		$("#phone_3").val(phoneList[2]);
		$("#representative_name").val(data.result.representative_name);
		$("#industry_type").val(data.result.industry_type);
		$("#business_type").val(data.result.business_type);
		$("#foundation_date").val(data.result.foundation_date);
		$("input:radio[name=foundation_type_radio]:input[value='" + data.result.foundation_type + "']").prop("checked", true);
		$("input:radio[name=company_class_radio]:input[value='" + data.result.company_class + "']").prop("checked", true);
		$("input:radio[name=company_type_radio]:input[value='" + data.result.company_type + "']").prop("checked", true);
		$("input:radio[name=lab_exist_yn_radio]:input[value='" + data.result.lab_exist_yn + "']").prop("checked", true);
		$("#employee_no").val(data.result.employee_no.toString().money());
		$("#total_sales").val(data.result.total_sales.toString().money());
		$("#capital_1").val(data.result.capital_1.toString().money());
		$("#capital_2").val(data.result.capital_2.toString().money());
		$("#capital_3").val(data.result.capital_3.toString().money());
		$("#department").val(data.result.department);
		$("#position").val(data.result.position);

		if ( isFirstSearchInstitution == true ){
			$("#not_exist_text").hide();
			toggleText();
		}
	}
	
	 
	function institutionRegistration(){
		if (isCheckRegNo == false && existInstitution == false) {
			showPopup("사업자 등록번호를 먼저 검색해 주시기 바랍니다.","등록 안내");
			// 	return;
		}
		
		var chkVal = ["reg_no", "mypage_company_name", "address", "phone_1", "phone_2", "phone_3", 
				  "representative_name", "industry_type", "business_type", "foundation_date",
				  "employee_no", "total_sales", "capital_1", "capital_2", "capital_3",
				  "department", "position"];
	  
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.","등록 안내");
				$("#" + chkVal[i]).focus();
				return false;
			}
		} 
		
		var formData = new FormData();
		formData.append("member_id",'${member_id}');
		formData.append("type", $("input:radio[name=expert_department_type]:checked").val());
		formData.append("reg_no", $("#reg_no").val());
		formData.append("name", $("#mypage_company_name").val());
		formData.append("address", $("#address").val());
		formData.append("address_detail", $("#address_detail").val());
		var tempStr = $("#phone_1").val() + "-" + $("#phone_2").val() + "-" + $("#phone_3").val();
		formData.append("phone", tempStr);
		formData.append("representative_name", $("#representative_name").val());
		formData.append("industry_type", $("#industry_type").val());
		formData.append("business_type", $("#business_type").val());
		formData.append("foundation_date", $("#foundation_date").val());
		formData.append("foundation_type", $("input:radio[name=foundation_type_radio]:checked").val());
		formData.append("company_class", $("input:radio[name=company_class_radio]:checked").val());
		formData.append("company_type", $("input:radio[name=company_type_radio]:checked").val());
		formData.append("lab_exist_yn", $("input:radio[name=lab_exist_yn_radio]:checked").val());
		formData.append("employee_no", $("#employee_no").val().replace(/\,/gi,""));
		formData.append("total_sales", $("#total_sales").val().replace(/\,/gi,""));
		formData.append("capital_1", $("#capital_1").val().replace(/\,/gi,""));
		formData.append("capital_2", $("#capital_2").val().replace(/\,/gi,""));
		formData.append("capital_3", $("#capital_3").val().replace(/\,/gi,""));
		var temp = $("#department").val();
		temp = $("#position").val();
		formData.append("department", $("#department").val());
		formData.append("position", $("#position").val());

		$.ajax({
		    type : "POST",
		    url : "/member/api/mypage/institution/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result != 0) {
		        	showPopup("기관 정보 등록에 성공했습니다.","등록 안내");
		        	isRegInstitutionResult = true;
		        } else {
		        	showPopup("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.","등록 안내");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function searchRepresentative() {
		if ( existInstitution == false ){
			$("#list_body").empty();
			var str = "<tr>" + "<td colspan='5'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			return;
		}
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/representative/search/all'/>");
		comAjax.setCallback(getRepresentativeCB);
		comAjax.addParam("reg_no", $("#reg_no").val());
		comAjax.ajax();
	}

	function getRepresentativeCB(data){
		var body = $("#list_body");
		body.empty();
		if (data.result.length == 0) {
			var str = "<tr>" + "<td colspan='5'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var index = 1;
			var str = "";

			$.each(data.result, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>";
				str += "		<input type='checkbox' id='mypage_company_ceo_check_" + index +"' name='ceo_delete_radio' class='fl ml10' value='" + value.representative_id + "'/>";
				str += "		<label for='mypage_company_ceo_check_" + index +"' style='padding-left:21px'>&nbsp;</label>";
				str += "	</td>";
				str += "	<td>"+ index + "</td>";
				str += "	<td>"+ value.name + "</td>";
				str += "	<td>"+ value.mobile_phone + "</td>";
				str += "	<td class='last'>"+ value.email + "</td>";
				index++;
			});
			body.append(str);
		}
	}

	function representativeRegistration(){
		var chkVal = ["ceo_name", "mobile_phone_2", "mobile_phone_3", "email1", "email2"];
	  
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.","등록 안내");
				$("#" + chkVal[i]).focus();
				return false;
			}
		} 

		var mailAddress;
		if ( gfn_isNull($("#email1").val()) == false && gfn_isNull($("#email2").val()) == false){
			mailAddress = $("#email1").val() + "@" + $("#email2").val();
		}
		else if (gfn_isNull($("#email1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
			mailAddress =  $("#email1").val() + "@" + $("select[name=selectEmail]").val();
		}
		else {
    		showPopup("메일은(는) 필수입력입니다.", "등록 안내");
			return;
		}

		console.log("$('#reg_no').val() = " + $("#reg_no").val());
		
		var formData = new FormData();
		formData.append("member_id",'${member_id}');
		formData.append("reg_no", $("#reg_no").val());
		formData.append("name", $("#ceo_name").val());
		temp = $("#mobile_phone_selector").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val();
		formData.append("mobile_phone", temp);
		formData.append("email", mailAddress);
		
		$.ajax({
		    type : "POST",
		    url : "/member/api/mypage/representative/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result > 0) 
	        	{
		        	showPopup("대표자 등록에 성공했습니다.","대표자 등록 안내");
		        	isRegRepresentativeResult = true;
		        } 
		        else if ( jsonData.result == -2 )
		        {
		        	showPopup("기등록된 대표자 정보 입니다. 다시 시도해 주시기 바랍니다.","대표자 등록 안내")
		        }
		        else
		        {
		        	showPopup("대표자 등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.","대표자 등록 안내");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function representativeWithdrawal() {
		var deleteIdArr = new Array();
		$("input[name='ceo_delete_radio']:checked").each(function() {
			deleteIdArr.push($(this).val());
		});
		if ( deleteIdArr.length == 0 ) {
			showPopup("삭제 할 대표자를 선택 주시기 바랍니다.","대표자 삭제 안내");
			return;
		}
		
		if (confirm('삭제 하시겠습니까?')) {
			var formData = new FormData();
			formData.append("delete_representative_id_list", deleteIdArr);
			
			$.ajax({
			    type : "POST",
			    url : "/member/api/mypage/representative/withdrawal",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result != 0) {
				        location.reload();
			        } else {
			        	showPopup("대표자 삭제에 실패하였습니다. 다시 시도해 주시기 바랍니다.","대표자 삭제 안내");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	
	function checkRegNo() {
		if ( $("#reg_no").val() == "" ) {
			showPopup("사업자 번호를 먼저 입력해 주시기 바랍니다.","등록 안내");
			return;
		}

		isFirstSearchInstitution = false;
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/search/regNo'/>");
		comAjax.setCallback(getInstitutionCB);
		comAjax.addParam("reg_no", $("#reg_no").val());
		comAjax.ajax();
	}
	
	// 개인별 소속 유형를 만든다.
	function initDepratmentType(){
		$("#depratment_type").empty();

		var index = 1;
		var str = "";
       	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000004'}">
				if (index == 1) {
					str += "<input type='radio' id='expert_company_type_radio' name='expert_department_type' value='${code.detail_id}' checked >";
				}
				else {
					str += "<input type='radio' id='expert_company_type_radio' name='expert_department_type' value='${code.detail_id}'>";
				}
				
				str += "<label for='expert_company_type_radio'>${code.name}</label>";
				index++;
			</c:if>
		</c:forEach>
		$("#depratment_type").append(str);
	}


	// 주소 검색
	function execPostCode() {
		new daum.Postcode({
            oncomplete: function(data) {
               // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

               // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
               var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
               var extraRoadAddr = ''; // 도로명 조합형 주소 변수

               // 법정동명이 있을 경우 추가한다. (법정리는 제외)
               // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
               if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                   extraRoadAddr += data.bname;
               }
               // 건물명이 있고, 공동주택일 경우 추가한다.
               if(data.buildingName !== '' && data.apartment === 'Y'){
                  extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
               }
               // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
               if(extraRoadAddr !== ''){
                   extraRoadAddr = ' (' + extraRoadAddr + ')';
               }
               // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
               if(fullRoadAddr !== ''){
                   fullRoadAddr += extraRoadAddr;
               }

               // 우편번호와 주소 정보를 해당 필드에 넣는다.
               $("#zipcode").val(data.zonecode);
               $("#address").val(fullRoadAddr);
               
               /* document.getElementById('signUpUserPostNo').value = data.zonecode; //5자리 새우편번호 사용
               document.getElementById('signUpUserCompanyAddress').value = fullRoadAddr;
               document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
           }
        }).open();
	}

	function initInstitution(){
		initDepratmentType();
		$("#reg_no").val("");
		$("#mypage_company_name").val("");
		$("#address").val("");
		$("#address_detail").val("");
		$("#phone_1").val("");
		$("#phone_2").val("");
		$("#phone_3").val("");
		$("#representative_name").val("");
		$("#industry_type").val("");
		$("#business_type").val("");
		$("#foundation_date").val("");
		$("#mypage_company_classification_of_establishment1").prop("checked", true);
		$("#mypage_company_class1").prop("checked", true);
		$("#mypage_company_other_class1").prop("checked", true);
		$("#mypage_company_or_lab1").prop("checked", true);

		$("#employee_no").val("");
		$("#total_sales").val("");
		$("#capital_1").val("");
		$("#capital_2").val("");
		$("#capital_3").val("");	
	}

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function addCEORegForm() {
		if ( existInstitution == false) {
			showPopup("연관된 사업자 번호가 없습니다. 사업자를 먼저 선택해 주시기 바랍니다.","대표자 등록 안내");
			return;
		}
		ceotoggleText();
	}

	function initCEOInfo() {
		$("#ceo_name").val("");
		$("#mobile_phone_2").val("");
		$("#mobile_phone_3").val("");
		$("#email1").val("");
		$("#email2").val("");
		$("#selectEmail option:eq(0)").prop("selected", true);
	}

	function commonPopupConfirm(){
		if ( isRegInstitutionResult == true || isRegRepresentativeResult == true) {
			location.reload();
		}
	}

</script>

<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area clearfix">
				<h3 class="hidden">기관정보관리</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>마이페이지</li>
						<li>기관정보관리</li>
					</ul>
				</div>
				<div id="lnb" class="fl">
					<!-- lnb_area -->	
					<div class="lnb_area">
						<!-- lnb_title_area -->	
						<div class="lnb_title_area">
							<h2 class="title">마이페이지</h2>
						</div>
						<!--// lnb_title_area -->
						<!-- lnb_menu_area -->
						<div class="lnb_menu_area">
							<!-- lnb_menu -->	
							<ul class="lnb_menu">
								<li>
									<a href="/member/fwd/mypage/institution" title="기관정보관리"  class="active"><span>기관정보관리</span></a>									
								</li>
								<li>
									<a href="/member/fwd/mypage/main" title="개인정보관리 페이지로 이동"><span>개인정보관리</span></a>									
								</li>
								<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/expert" title="전문가 참여 현황" ><span>전문가 참여 현황</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="평가위원정보관리" ><span>평가위원 정보 관리</span></a>				
									</li>
								</sec:authorize>
								<li>
									<a href="/member/fwd/mypage/report" title="나의 수행과제 현황 관리 페이지로 이동"><span>나의 수행과제 현황 관리</span></a>									
								</li>
							</ul>
							<!--// lnb_menu -->
						</div><!--//lnb_menu_area-->
					</div><!--//lnb_area-->
				</div>
				<!--//lnb-->
				<div class="sub_right_contents fl">
					<h3>기관정보관리</h3>
					
					<!--기본정보-->
					<div>									
						<div class="mypage_company_box">										
							<div class="mypage_tab_con_box">											
								<h4>기관 정보</h4>
								<p class="company_signup_popup_open_info" id="not_exist_text">등록된 기관 정보가 없습니다. 기관정보를 등록해 주세요.</p>
								<button type="button" class="blue_btn fr w100 company_signup_popup_open mb10" title="기관 정보 등록" id="demo2">기관 정보 등록</button>
								<div class="mypage_company_area add_company_signup_box" style='display: none' id='demo'>
									<div class="table_area">
										<!--기관정보-->
										<table class="write fixed">
											<caption>기관 정보</caption>
											<colgroup>
												<col style="width: 20%;">
												<col style="width: 80%;">
											</colgroup>
											<tbody>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>소속기관 유형</span>
													</th>
													<td id="depratment_type">
													</td> 
												</tr>									  
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="reg_no">사업자 등록번호</label></span>
													</th>
													<td class="clearfix">
														<!--span>000-00-00000</span-->
														<input type="text" class="form-control input-sm mr5 fl" name="reg_no" id="reg_no" placeholder="숫자만 입력하세요." oninput="numberOnlyInput(this);" title="사업자 등록번호"/>
														<button type="button" class="blue_btn2 fl" title="검색" onclick="checkRegNo();">검색</button>	
													</td>
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="mypage_company_name">기관명</label></span>
													</th>
													<td>
													    <!--span>000기관</span-->
														<input type="text" id="mypage_company_name" class="form-control w60 fl mr5" disabled title="기관명"/>
														<input type="checkbox" id="mypage_company_name_check" class="fl" />									
														<label for="mypage_company_name_check" class="fl mr5 mt10">직접 입력</label><span class="font_blue fl mr5" style="margin-top:14px">(기관 검색 불가인 경우)</span>														
													</td> 
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="address">주소</label></span>
													</th>
													<td>
														<!--span>서울시 강남구 대치동 304-4번지</span-->
														<input type="text" id="address" class="form-control w60 fl mr5" disabled title="주소" />
														<label for="address_detail" class="hidden">주소</label>
														<input type="text" id="address_detail" class="form-control w30 fl mr5" />
														<button type="button" class="gray_btn2 fl" title="검색" onclick="execPostCode();">검색</button>
														
													</td> 
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="mypage_company_company_tel">전화</label></span>
													</th> 
													<td>
														<label for="phone_1" class="hidden">전화</label>
														<input type="number" id="phone_1" maxlength="3" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화">
														<span style="display:block;" class="fl mc8">-</span>
														<label for="phone_2" class="hidden">전화</label>
														<input type="number" id="phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화">
														<span style="display:block;" class="fl mc8 ls">-</span>
														<label for="phone_3" class="hidden">전화</label>
														<input type="number" id="phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화">
													</td>
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="representative_name">대표자명</label></span>
													</th> 
													<td><input type="text" id="representative_name" class="form-control w_20" placeholder="" title="대표자명"></td>
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="industry_type">업종</label></span>
													</th> 
													<td>
														<input type="text" id="industry_type" class="form-control w_34" title="업종">
													</td>
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="business_type">업태</label></span>
													</th> 
													<td>
														<input type="text" id="business_type" class="form-control w_34" title="업태"/>
													</td>
												</tr>
												<tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>
														<label for="foundation_date">설립일</label></span>
													</th> 
													<td>
														<div class="datepicker_area fl mr5">
															<input type="text" id="foundation_date" class="datepicker form-control w_14 mr5 ls" title="설립일"/>
														</div>
													</td> 
											   </tr>
											   <tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>설립 구분</span>
													</th> 
													<td>
														<input type="radio" id="mypage_company_classification_of_establishment1" name="foundation_type_radio" value="D0000001" checked />
														<label for="mypage_company_classification_of_establishment1">영리</label>
														<input type="radio" id="mypage_company_classification_of_establishment2" name="foundation_type_radio" value="D0000002"/>
														<label for="mypage_company_classification_of_establishment2">비영리</label>								
													</td> 
											   </tr>
											   <tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>기업 분류</span>
													</th> 
													<td>
														<input type="radio" id="mypage_company_class1" name="company_class_radio" value="D0000001" checked />
														<label for="mypage_company_class1">대기업</label>
														<input type="radio" id="mypage_company_class2" name="company_class_radio" value="D0000002" />
														<label for="mypage_company_class2">중견기업</label>	
														<input type="radio" id="mypage_company_class3" name="company_class_radio" value="D0000003" />
														<label for="mypage_company_class3">중소기업</label>
														<input type="radio" id="mypage_company_class4" name="company_class_radio" value="D0000004" />
														<label for="mypage_company_class4">기타</label>	
													</td> 
											   </tr>
											   <tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>기업 유형</span>
													</th> 
													<td>
														<input type="radio" id="mypage_company_other_class1" name="company_type_radio" value="D0000001" checked />
														<label for="mypage_company_other_class1">여성기업</label>
														<input type="radio" id="mypage_company_other_class2" name="company_type_radio" value="D0000002" />
														<label for="mypage_company_other_class2">장애인기업</label>	
														<input type="radio" id="mypage_company_other_class3" name="company_type_radio" value="D0000003" />
														<label for="mypage_company_other_class3">사회적기업</label>
														<input type="radio" id="mypage_company_other_class4" name="company_type_radio" value="D0000004" />
														<label for="mypage_company_other_class4">해당 없음</label>	
													</td> 
											   </tr>
											   <tr>
													<th scope="row">
														<span class="icon_box"><span class="necessary_icon">*</span>기업부설연구소 유무</span></th> 
													<td>
														<input type="radio" id="mypage_company_or_lab1" name="lab_exist_yn_radio" value="Y" checked />
														<label for="mypage_company_or_lab1">있음</label>
														<input type="radio" id="mypage_company_or_lab2" name="lab_exist_yn_radio" value="N" />
														<label for="mypage_company_or_lab2">없음</label>	
													</td> 
											   </tr>
											   <tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
														<label for="employee_no">종업원수</label></span></th>
													<td>
														<input type="text" onkeyup="makeMoneyWithComma(this);" id="employee_no" class="form-control w_10 fl mr5 ls won_comma" title="종업원수">
														<span class="fl mt10">(명)</span>
													</td>
											   </tr>
											   <tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
														<label for="total_sales">자본금</label></span></th> 
													<td><input type="text" onkeyup="makeMoneyWithComma(this);" id="total_sales" class="form-control w_18 fl mr5 ls won_comma" title="매출액">
														<span class="fl mt10">(만원)</span>
													</td> 
											   </tr>
											   <tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>매출액(최근3년)</span></th> 
													<td>
														<div class="2018_box fl mr20">
															<label for="capital_1" class="hidden">2018년</label>
															<input type="text" onkeyup="makeMoneyWithComma(this);" id="capital_1" class="form-control w_18 fl mr5 ls won_comma" title="자본금">
															<span class="fl mt10">(만원)</span>
														</div>
														<div class="2019_box fl mr20">
															<label for="capital_2" class="hidden">2019년</label>
															<input type="text" onkeyup="makeMoneyWithComma(this);" id="capital_2" class="form-control w_18 fl mr5 ls won_comma" placeholder="입력" title="자본금">
															<span class="fl mt10">(만원)</span>
														</div>
														<div class="2020_box">
															<label for="capital_3" class="hidden">2020년</label>
															<input type="text" onkeyup="makeMoneyWithComma(this);" id="capital_3" class="form-control w_18 fl mr5 ls won_comma" placeholder="입력" title="자본금"	>
															<span class="fl mt10">(원)</span>
														</div>
													</td> 
											   </tr>
											   <tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="department">부서</label></span></th>
													<td>
														<input type="text" id="department" class="form-control w34 fl d_input" placeholder="" title="부서"/>
													</td>	
												</tr>
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="position">직책</label></span></th>
													<td>
														<input type="text" id="position" class="form-control w34 fl d_input" placeholder="" title="직책"/>
													</td>	
												</tr>
											</tbody>
										</table>
									</div><!--table area-->
									<div class="btn_box fr mt10 mb20">
										<button type="button" title="초기화" class="gray_btn fl mr5" onclick="initInstitution();">초기화</button>
										<button type="button" title="저장" class="blue_btn fr company_signup_popup_save_box_open" onclick="institutionRegistration();">저장</button>
									</div>
									<!--//기관정보-->	
									<!--대표자-->
									<div>									
										<div class="mypage_tab_box">										
											<div class="mypage_company_con_box">
												<h4>대표자 정보</h4>
												<div class="fr mb10">
													<button type="button" title="추가" class="blue_btn2 fl mr5 ceo_add_cell_btn" id="ceo_add_cell_btn" onclick="addCEORegForm();">추가</button>
													<button type="button" title="삭제" class="gray_btn fl" onclick="representativeWithdrawal();">삭제</button>
												</div>
												<div class="table_area">
													<table class="list fixed">
														<caption>대표자 정보</caption>
														<colgroup>
															<col style="width: 5%;">
															<col style="width: 10%;">
															<col style="width: 20%;">
															<col style="width: 25%;">
															<col style="width: 40%;">
														</colgroup>
														<thead>
															<tr>
																<th scope="col" class="first">선택</th>
																<th scope="col">번호</th>
																<th scope="col">성명</th>
																<th scope="col">휴대전화</th>
																<th scope="col">이메일</th>
															</tr>
														</thead>
														<tbody id="list_body">
														</tbody>
													</table>
												</div>

												<div class="ceo_write_step list" id="ceo_add" style="display:none">
													<h4>대표자 등록</h4>									
													<div class="table_area">
														<table class="write fixed">
														<caption>대표자 등록</caption>
															<colgroup>
																<col style="width: 30%;">																		
																<col style="width: 70%;">
															</colgroup>
															<tbody>
																<tr>
																	<th scope="row">
																		<span class="icon_box"><span class="necessary_icon">*</span><label for="ceo_name">성명</label></span>
																	</th>
																	<td>
																		<input type="text" class="form-control input-sm mr5 fl" name="ceo_name" id="ceo_name" title="대표자명"/>
																	</td>	
																</tr>									  
																<tr>
																	<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="mobile_phone_selector">휴대전화</label></span></th>
																	<td class="clearfix">
																		<select name="mobile_phone_1" id="mobile_phone_selector" class="w_8 fl">
																			<option value="010">010</option>
																		</select>
																		<span style="display:block;" class="fl mc8">-</span>
																		<label for="mobile_phone_2" class="hidden">전화</label>
																		<input type="tel" id="mobile_phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="대표자 휴대전화"/>
																		<span style="display:block;" class="fl mc8">-</span>
																		<label for="mobile_phone_3" class="hidden">전화</label>
																		<input type="tel" id="mobile_phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="재표자 휴대전화"/>
																	</td>
																</tr>
																<tr>
																	<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
																		<label for="email1">이메일</label></span></th>
																	<td>
																		<input type="text" name="email1" id="email1" class="form-control w_20 fl" title="대표자 이메일"/>
																		<span class="fl ml1 mr1 pt10 mail_f">@</span>
																		<label for="email2" class="hidden">이메일</label>
																		<input type="text" name="email2" id="email2" class="form-control w_18 fl" disabled title="재표자 이메일"/>
																		<label for="selectEmail" class="hidden">이메일</label>
																		<select name="selectEmail" id="selectEmail" class="fl ml5 in_wp200 ace-select"> 
																		   <option value="0">------선택------</option> 
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
															</tbody>
														</table>																										
													</div>									
													<div class="btn_box fr mt10 mb5">
														<button type="button" title="초기화" class="gray_btn fl mr5" onclick="initCEOInfo();">초기화</button>
														<button type="button" title="저장" class="blue_btn fr company_signup_popup_save_box_open" onclick="representativeRegistration();">저장</button>
													</div>									
												</div>									
											</div>										
										</div>									
									</div>
									<!--//대표자-->
								</div>
							</div>
							
							
						</div>	
						
					</div>
					<!--//기본정보-->	
								
				</div><!--//sub_right_contents-->
			</div><!--//content_area-->
		</div><!--//sub_contents-->
	</section><!--//content-->
</div>
 <!--//contents--> 
 
 
 <!--기관명검색 팝업-->
<div class="mypage_company_name_popup_box">
	<div class="popup_bg"></div>
	<div class="mypage_company_name_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관명 검색</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0" id="reg_no_err"><span class="font_blue">000-00-00000</span> 은<br />기관으로 등록되어 있지 않습니다.<br />기관정보를 직접 입력해 주세요.</p>
			<!--있을경우-->
			<!--p tabindex="0">
				<input type="radio" id="mypage_company_name_radio" name="mypage_company_name_radio">
				<label for="mypage_company_name_radio">이노싱크컨설팅</label>
			</p-->
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn">확인</button>
			</div>	
		</div>
	</div>			
</div>

<!--기관정보등록 팝업-->
<div class="company_signup_popup_box">
	<div class="popup_bg"></div>
	<div class="company_signup_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관 정보 등록</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn company_signup_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">기관정보의 최초 등록 시</span>, 등록자의 대표자가 아닌 경우 임시 대표자로 설정됩니다.<br />로그인한 인증서와 동일한 <span class="font_blue">사업자번호의 기관만 등록, 수정</span>이 가능합니다.</p>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn company_signup_popup_close_btn" onclick="toggleText()">확인</button>
			</div>	
		</div>
	</div>			
</div>
<!--//기관정보등록 팝업-->

<!--사업자 등록번호 팝업-->
<div class="companynumber_popup_box">
	<div class="popup_bg"></div>
	<div class="companynumber_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">미등록 기관 등록</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn companynumber_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p tabindex="0">미등록 기관입니다.<br />미등록 기관의 경우 등록해 주세요.<br />
				기업의 경우, <span class="font_blue">사업자등록번호로 중복 확인</span> 부탁 드립니다.</p>
				<ul>
					<li class="clearfix mb5"><label for="notsignup_companyname" class="w45 fl ta_r mr10">미등록 기관명 </label>
						<input type="text" id="notsignup_companyname" class="form-control w50 fl" /></li>
					<li class="clearfix"><label for="li_number2" class="w45 fl ta_r mr10">미등록 기관 사업자 등록번호 </label>
						<input type="text" class="form-control input-sm mr5 w30 fl" name="li_number2" id="li_number2" placeholder="숫자만 입력" maxlength="12"><button type="button" class="gray_btn fl notsignup_test_company_number" title="중복확인">중복확인</button></li>
					<li>
				</ul>
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn companynumber_popup_close_btn ">등록</button>
			</div>								
		</div>
	</div>				 
</div>
<!--//사업자 등록번호 팝업-->	

<!--공통 팝업-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>


<script>			
	//달력
	$(".datepicker").datepicker({  
		  showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
		  //buttonImage: "/application/db/jquery/images/calendar.gif", // 버튼 이미지
		  buttonText	: false, 
		  buttonImageOnly: false, // 버튼에 있는 이미지만 표시한다.
		  changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
		  changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
		  minDate: '-100y', // 현재날짜로부터 100년이전까지 년을 표시한다.
		  nextText: '다음 달', // next 아이콘의 툴팁.
		  prevText: '이전 달', // prev 아이콘의 툴팁.
		  numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
		  stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
		  yearRange: 'c-100:c+10', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
		  showButtonPanel: true, // 캘린더 하단에 버튼 패널을 표시한다. ( ...으로 표시되는부분이다.) 
		  currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
		  closeText: '닫기',  // 닫기 버튼 패널
		  dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
		  showAnim: "slide", //애니메이션을 적용한다.  
		  showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
		  dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
		  monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
	  });
</script>

