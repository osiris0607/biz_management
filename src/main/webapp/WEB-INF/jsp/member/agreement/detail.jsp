<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var institutionName;
	var agreementStatus;

	$(document).ready(function() {
		// 협약 목록
		searchDetail(); 
		// 기관 정보
		searchInstitution();

		$("#file_upload").on("change", addFiles);
	});


	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/agreement/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("agreement_id", "${vo.agreement_id}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
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

		// 연구원 정보
		var index1 = 1;
		var index2 = 1;
		$.each(data.result_data.agreement_researcher_list, function(key, value) {
			// 주관기관 - 연구책임자 
			if ( value.institution_gubun == "주관기관" && value.researcher_gubun == "연구책임자") {
				$("#responsible_companyname").val(value.institution_name);
				$("#responsible_companypartname").val(value.institution_department);
				$("#responsible_companypositionname").val(value.institution_position);
				$("#responsible_name").val(value.name);
				$("#responsible_birthday").val(value.birth);
				$("#responsible_phoneNumber").val(value.hand_phone);
				var emailList = value.email.split("@");
				$("#responsible_email_front").val(emailList[0]);
				$("#responsible_email_back").val(emailList[1]);
				$("#responsible_percent").val(value.participation_rate);
				$("#responsible_startday").val(value.participation_from_date);
				$("#responsible_endday").val(value.participation_tod_date);
			}
			// 주관기관 - 참여연구원
			if ( value.institution_gubun == "주관기관" && value.researcher_gubun == "참여연구원") {
				$("#responsible_chamyeo_companyname" + index1).val(value.institution_name);
				$("#responsible_chamyeo_companypartname" + index1).val(value.institution_department);
				$("#responsible_chamyeo_companypositionname" + index1).val(value.institution_position);
				$("#responsible_chamyeo_name" + index1).val(value.name);
				$("#responsible_chamyeo_birthday" + index1).val(value.birth);
				$("#responsible_chamyeo_phoneNumber" + index1).val(value.hand_phone);
				var emailList = value.email.split("@");
				$("#responsible_chamyeo_email_front" + index1).val(emailList[0]);
				$("#responsible_chamyeo_email_back" + index1).val(emailList[1]);
				$("#responsible_chamyeo_percent" + index1).val(value.participation_rate);
				$("#responsible_chamyeo_startday" + index1).val(value.participation_from_date);
				$("#responsible_chamyeo_endday" + index1).val(value.participation_tod_date);
				$("#responsible_chamyeo_role" + index1).val(value.role);
				index1++;
			}
			// 참여기관 - 연구책임자
			if ( value.institution_gubun.includes("참여기관") && value.researcher_gubun == "연구책임자") {
				$("#chamyeo_responsible_companyname").val(value.institution_name);
				$("#chamyeo_responsible_companypartname").val(value.institution_department);
				$("#chamyeo_responsible_companypositionname").val(value.institution_position);
				$("#chamyeo_responsible_name").val(value.name);
				$("#chamyeo_responsible_birthday").val(value.birth);
				$("#chamyeo_responsible_phoneNumber").val(value.hand_phone);
				var emailList = value.email.split("@");
				$("#chamyeo_responsible_email_front").val(emailList[0]);
				$("#chamyeo_responsible_email_back").val(emailList[1]);
				$("#chamyeo_responsible_percent").val(value.participation_rate);
				$("#chamyeo_responsible_startday").val(value.participation_from_date);
				$("#chamyeo_responsible_endday").val(value.participation_tod_date);
				$("#chamyeo_responsible_role").val(value.role);
			}
			// 참여기관 - 참여연구원
			if ( value.institution_gubun.includes("참여기관") && value.researcher_gubun == "참여연구원") {
				$("#chamyeo_responsible_chamyeo_companyname" + index2).val(value.institution_name);
				$("#chamyeo_responsible_chamyeo_companypartname" + index2).val(value.institution_department);
				$("#chamyeo_responsible_chamyeo_companypositionname" + index2).val(value.institution_position);
				$("#chamyeo_responsible_chamyeo_name" + index2).val(value.name);
				$("#chamyeo_responsible_chamyeo_birthday" + index2).val(value.birth);
				$("#chamyeo_responsible_chamyeo_phoneNumber" + index2).val(value.hand_phone);
				var emailList = value.email.split("@");
				$("#chamyeo_responsible_chamyeo_email_front" + index2).val(emailList[0]);
				$("#chamyeo_responsible_chamyeo_email_back" + index2).val(emailList[1]);
				$("#chamyeo_responsible_chamyeo_percent" + index2).val(value.participation_rate);
				$("#chamyeo_responsible_chamyeo_startday" + index2).val(value.participation_from_date);
				$("#chamyeo_responsible_chamyeo_endday" + index2).val(value.participation_tod_date);
				$("#chamyeo_responsible_chamyeo_role" + index2).val(value.role);
				index2++;
			}
		});
				
		// 연구비 정보
		$("#support_amount1").val(data.result_data.fund_support_amount1);
		$("#support_amount2").val(data.result_data.fund_support_amount2);
		$("#support_amount3").val(data.result_data.fund_support_amount3);
		$("#support_amount4").val(data.result_data.fund_support_amount4);
		$("#cash1").val(data.result_data.fund_cash1);
		$("#cash2").val(data.result_data.fund_cash2);
		$("#cash3").val(data.result_data.fund_cash3);
		$("#cash4").val(data.result_data.fund_cash4);
		$("#hyeonmul1").val(data.result_data.fund_hyeonmul1);
		$("#hyeonmul2").val(data.result_data.fund_hyeonmul2);
		$("#hyeonmul3").val(data.result_data.fund_hyeonmul3);
		$("#hyeonmul4").val(data.result_data.fund_hyeonmul4);
		$("#total_project_cost1").val(data.result_data.fund_total_cost1);
		$("#total_project_cost2").val(data.result_data.fund_total_cost2);
		$("#total_project_cost3").val(data.result_data.fund_total_cost3);
		$("#total_project_cost4").val(data.result_data.fund_total_cost4);

		// 연구비 상세 정보
		var index = 0;
		$("#fund_detail_body tr").each(function(){
			var tr = $(this);
			var trObj = new Object();

			if ( data.result_data.agreement_fund_detail_list != null 
				 && data.result_data.agreement_fund_detail_list.length > index ) {

				var trObj = data.result_data.agreement_fund_detail_list[index];
				tr.find('input:eq(0)').val(trObj.ab_total);
				tr.find('input:eq(1)').val(trObj.ab_total_p);
				tr.find('input:eq(2)').val(trObj.a);
				tr.find('input:eq(3)').val(trObj.a_p);
				tr.find('input:eq(4)').val(trObj.b);
				tr.find('input:eq(5)').val(trObj.b_p);
				tr.find('input:eq(6)').val(trObj.cdef_total);
				tr.find('input:eq(7)').val(trObj.cdef_total_p);
				tr.find('input:eq(8)').val(trObj.c);
				tr.find('input:eq(9)').val(trObj.c_p);
				tr.find('input:eq(10)').val(trObj.d);
				tr.find('input:eq(11)').val(trObj.d_p);
				tr.find('input:eq(12)').val(trObj.e);
				tr.find('input:eq(13)').val(trObj.e_p);
				tr.find('input:eq(14)').val(trObj.f);
				tr.find('input:eq(15)').val(trObj.f_p);
				tr.find('input:eq(16)').val(trObj.g);
				tr.find('input:eq(17)').val(trObj.g_p);
				tr.find('input:eq(18)').val(trObj.total);
				tr.find('input:eq(19)').val(trObj.total_p);

				index++;
			 }
		});

		// 파일 이름
		$("#upload_plan_file_name").text(data.result_data.upload_plan_file_name);
		$("#upload_agreement_file_name").text(data.result_data.upload_agreement_file_name);
		if ( data.result_data.return_upload_files != null) {
	    	uploaded_files = data.result_data.return_upload_files;
	    	$("#fileList").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#fileList").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><span class='d_n'>파일</span><i class='fas fa-times'></i></a></li>");
		    }
		}
		

		institutionName = data.result_data.institution_name;
		agreementStatus = data.result_data.agreement_status;
	}

	function searchInstitution() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
		comAjax.setCallback(searchInstitutionCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}
	
	function searchInstitutionCB(data){
		$("#reg_no").val(data.result.reg_no);
		$("#institution_name").val(institutionName);
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
	}

	// 협약서 저장
	// '1'이면 임시저정 '2'이면 제출
	var finishRegistrationAgreemnt = false;
	function onRegistration(type) {
		// 연구원 정보
		var researcherList = new Array();
		f_getResearcherInfo("bdy_supervision_senior_researcher", "연구책임자", researcherList);
		f_getResearcherInfo("bdy_supervision_researcher", "참여연구원", researcherList);
		f_getResearcherInfo("bdy_senior_researcher", "연구책임자", researcherList);
		f_getResearcherInfo("bdy_researcher", "참여연구원", researcherList);
		// 연구비 상세 정보
		var agreementFundDetailList = new Array();
		$("#fund_detail_body tr").each(function(){
			var tr = $(this);
			var trObj = new Object();

			trObj.type = tr.find('td:eq(0)').text();
			trObj.ab_total = tr.find('input:eq(0)').val();
			trObj.ab_total_p = tr.find('input:eq(1)').val();
			trObj.a = tr.find('input:eq(2)').val();
			trObj.a_p = tr.find('input:eq(3)').val();
			trObj.b = tr.find('input:eq(4)').val();
			trObj.b_p = tr.find('input:eq(5)').val();
			trObj.cdef_total = tr.find('input:eq(6)').val();
			trObj.cdef_total_p = tr.find('input:eq(7)').val();
			trObj.c = tr.find('input:eq(8)').val();
			trObj.c_p = tr.find('input:eq(9)').val();
			trObj.d = tr.find('input:eq(10)').val();
			trObj.d_p = tr.find('input:eq(11)').val();
			trObj.e = tr.find('input:eq(12)').val();
			trObj.e_p = tr.find('input:eq(13)').val();
			trObj.f = tr.find('input:eq(14)').val();
			trObj.f_p = tr.find('input:eq(15)').val();
			trObj.g = tr.find('input:eq(16)').val();
			trObj.g_p = tr.find('input:eq(17)').val();
			trObj.total = tr.find('input:eq(18)').val();
			trObj.total_p = tr.find('input:eq(19)').val();
			
			agreementFundDetailList.push(trObj);
		});

		var formData = new FormData();
		formData.append("agreement_id", "${vo.agreement_id}");
		// 연구원 정보
		formData.append("agreement_researcher_list_json", JSON.stringify(researcherList));
		// 연구비 정보
		formData.append("fund_support_amount1", $("#support_amount1").val());
		formData.append("fund_support_amount2", $("#support_amount2").val());
		formData.append("fund_support_amount3", $("#support_amount3").val());
		formData.append("fund_support_amount4", $("#support_amount4").val());
		formData.append("fund_cash1", $("#cash1").val());
		formData.append("fund_cash2", $("#cash2").val());
		formData.append("fund_cash3", $("#cash3").val());
		formData.append("fund_cash4", $("#cash4").val());
		formData.append("fund_hyeonmul1", $("#hyeonmul1").val());
		formData.append("fund_hyeonmul2", $("#hyeonmul2").val());
		formData.append("fund_hyeonmul3", $("#hyeonmul3").val());
		formData.append("fund_hyeonmul4", $("#hyeonmul4").val());
		formData.append("fund_total_cost1", $("#total_project_cost1").val());
		formData.append("fund_total_cost2", $("#total_project_cost2").val());
		formData.append("fund_total_cost3", $("#total_project_cost3").val());
		formData.append("fund_total_cost4", $("#total_project_cost4").val());

		// 연구비 상세 정보
		formData.append("agreement_fund_detail_list_json", JSON.stringify(agreementFundDetailList));
		// 파일 정보
		if ( $("#upload_plan_file")[0].files[0] != null) {
			formData.append("upload_plan_file", $("#upload_plan_file")[0].files[0]);
		}
		if ( $("#upload_agreement_file")[0].files[0] != null) {
			formData.append("upload_agreement_file", $("#upload_agreement_file")[0].files[0]);
		}
		
		// 새로 업로드된 파일만 업데이트 한다.
 		for (var i=0; i<uploaded_files.length; i++ ) {
 	 		if ( uploaded_files[i] instanceof File )
			formData.append("upload_files", uploaded_files[i]);
		} 
		// 삭제된 파일 리스트 전송
		formData.append("delete_file_list", deleteFileList); 
		

		$.ajax({
		    type : "POST",
		    url : "/member/api/agreement/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( type == '1') {
		        		showPopup("임시저장 되었습니다.", "임시저장 안내닫기");
		        		finishRegistrationAgreemnt = true;
		        		return true;
		        	}
		        } else {
		        	if ( type == '1') {
		        		showPopup("임시저장에 실패하였습니다.", "임시저장 안내닫기");
		        		return false;
		        	}
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		        return false;
		    }
		});
	}

	// 협약서 제출
	var finishSubmitAgreemnt = false;
	function onSubmitAgreemnt() {
		// 협약서 저장
		if ( onRegistration('2') == false ) {
			showPopup("협약서 저출에 실패하였습니다.", "제출 안내닫기");
			return;
		}

		var formData = new FormData();
		formData.append("agreement_id", "${vo.agreement_id}");
		formData.append("agreement_status", "D0000004");
			
		$.ajax({
		    type : "POST",
		    url : "/member/api/agreement/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("협약서 제출이 완료되었습니다.", "협약서 제출안내");
			    	finishSubmitAgreemnt = true;
			    } else {
			    	showPopup("협약서 제출에 실패했습니다. 디시 시도해 주시기 바랍니다.", "협약서 제출안내");
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});

	}

	// 파일 추가
	var uploaded_files = new Array();
	var filesTempArr = new Array();
	function addFiles(e) {
	    var files = e.target.files;
	    var filesArr = Array.prototype.slice.call(files);
	    var filesArrLen = filesArr.length;
	    var filesTempArrLen = uploaded_files.length;

	    for( var i=0; i<filesArrLen; i++ ) {
	    	uploaded_files.push(filesArr[i]);
	        $("#fileList").append("<li>" + filesArr[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + (filesTempArrLen+i)+ "\");'><span class='d_n'>파일</span><i class='fas fa-times'></i></a></li>");
	    }
	    $(this).val('');
	}
	// 파일 삭제
	var deleteFileList = new Array();
	function deleteFile (orderParam) {
		// FILE 이 아닌 경우 이미 기존에 저장한 FILE의 ID 이다. DB에서 삭제하기 위해서 따로 List화 한다.
		if ( !(uploaded_files[orderParam] instanceof File) ) {
			deleteFileList.push(uploaded_files[orderParam].file_id);
		}
		
		uploaded_files.splice(orderParam, 1);
	    var innerHtmlTemp = "";
	    var filesTempArrLen = uploaded_files.length;
	    
	    $("#fileList").empty();
	    for(var i=0; i<filesTempArrLen; i++) {
	    	$("#fileList").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><span class='d_n'>파일</span><i class='fas fa-times'></i></a></li>");
	    }
	}
	

	function f_getResearcherInfo(id, researcherGubun, outList) {
		$("#" + id + " tr").each(function(){
			var tr = $(this);
			var trObj = new Object();

			if ( gfn_isNull(tr.find('input:eq(0)').val()) == false ) {
				trObj.researcher_gubun = researcherGubun;
				trObj.institution_gubun = tr.find('td:eq(1)').text();
				trObj.institution_name = tr.find('input:eq(0)').val();
				trObj.institution_department = tr.find('input:eq(1)').val();
				trObj.institution_position = tr.find('input:eq(2)').val();
				trObj.name = tr.find('input:eq(3)').val();
				trObj.birth = tr.find('input:eq(4)').val();
				trObj.hand_phone = tr.find('input:eq(5)').val();
				trObj.email = tr.find('input:eq(6)').val() + "@" + tr.find('input:eq(7)').val();
				trObj.participation_rate = tr.find('input:eq(8)').val();
				trObj.participation_from_date = tr.find('input:eq(9)').val();
				trObj.participation_tod_date = tr.find('input:eq(10)').val();
				if ( gfn_isNull(tr.find('input:eq(11)').val()) == false ) {
					trObj.role = tr.find('input:eq(11)').val();
				} else {
					trObj.role = "";
				}

				outList.push(trObj);
			}
		});
	}

	// 연구비 정보
	function onSumMoney(element, index) {
		$(element).val($(element).val().replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
		
		var name = $(element).attr("name");
		var totalId = name;

		var total = 0;
	 	$("input[name='" + name +"']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value.replace(",", "");
			}
			total += Number(tempValue);
	 	});
		$("#" + totalId).val(total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		var allTotal =  Number( $("#support_amount" + index).val().replace(",", "") ) +
					    Number( $("#cash" + index).val().replace(",", "") ) +
						Number( $("#hyeonmul" + index).val().replace(",", "") );
		$("#total_project_cost" + index).val(allTotal.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		
		var allTotal_1 =  Number( $("#support_amount1").val().replace(",", "") ) +
						  Number( $("#cash1").val().replace(",", "") ) +
						  Number( $("#hyeonmul1").val().replace(",", "") );
		$("#total_project_cost1").val(allTotal_1.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	}

	// 연구비 상세정보
	function onSumMoneyDetail(element) {
		$(element).val($(element).val().replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
		
		var name = $(element).attr("name");
		var sumId = name;

		var sum = 0;
	 	$("input[name='" + name +"']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value.replace(",", "");
			}
			sum += Number(tempValue);
	 	});
		$("#" + sumId).val(sum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		var totalIdNo = sumId.substring((sumId.length-1));

		var aplusbTotal = Number($("#aplusb_total" + totalIdNo).val().replace(",",""));
		var cdef = Number($("#cdef" + totalIdNo).val().replace(",",""));
		var g = Number($("#g" + totalIdNo).val().replace(",",""));
		var totalCostId = "total_project_detail_cost" + totalIdNo;
		$("#" + totalCostId).val((aplusbTotal+cdef+g).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		aplusbTotal = Number($("#aplusb_total_p" + totalIdNo).val().replace(",",""));
		cdef = Number($("#cdef_p" + totalIdNo).val().replace(",",""));
	 	g = Number($("#g" + totalIdNo + "_p").val().replace(",",""));
		var totalCostPId = "total_project_detail_cost" + totalIdNo + "_p";
		$("#" + totalCostPId).val((aplusbTotal+cdef+g).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	}

	
	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
 		if ( finishSubmitAgreemnt ) {
			$('.send_save_popup_box').fadeOut(350);
	    	location.href = "/member/fwd/agreement/main";
		}

 		if (finishRegistrationAgreemnt) {
 			$('.send_save_popup_box').fadeOut(350);
	    	location.reload();
 		}

		
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}

</script>
            
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>협약</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>협약</li>
						<li>협약</li>
					</ul>
				</div>
				
				
				<!--기관-->
				<div class="content_area copmpany_area" id="copmpany_area">													
					<div class="table_area">
						<h4>과제 정보</h4>	
						<!--과제 정보-->
						<table class="write fixed assignment_info">
							<caption>과제 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
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
						<!--//과제 정보-->								    
						
						<!--기관정보-->
						<div class="clearfix">
							<h4 class="fl sub_title_h4">기관 정보</h4>	
							<!-- <button type="button" class="blue_btn fr mt10 assignment_info_btn fr mt50">수정</button> -->
						</div>
					    <table class="write fixed assignment_info">
							<caption>기관 정보</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>		
							    <tr>
									<th scope="row"><label for="reg_no">사업자등록번호</label></th>
									<td class="clearfix">										
										<input type="text" class="form-control w_18" id="reg_no" maxlength="10" />				
										<script>
											//사업자등록번호 자동입력(-)	
											function licenseNum(str){
											  str = str.replace(/[^0-9]/g, '');
											  var tmp = '';
											  if(str.length < 4){
												  return str;
											  }else if(str.length < 7){
												  tmp += str.substr(0, 3);
												  tmp += '-';
												  tmp += str.substr(3);
												  return tmp;
											  }else{             
												  tmp += str.substr(0, 3);
												  tmp += '-';
												  tmp += str.substr(1, 2);
												  tmp += '-';
												  tmp += str.substr(5);
												  return tmp;
											  }
											  return str;
											}
										 
											var li_number = document.getElementById("reg_no");
											li_number.onkeyup = function(event){
												   event = event || window.event;
												   var _val = this.value.trim();
												   this.value = licenseNum(_val) ;
											};
										</script>			
									</td> 
							    </tr>															       
							    <tr>
									<th scope="row"><label for="institution_name">기관명</label></th>
									<td><input type="text" id="institution_name" class="form-control w40" /></td>
							    </tr>
							    <tr>
									<th scope="row"><label for="address">주소</label></th>
									<td>
										<input type="text" id="address" class="form-control w50 fl mr5" disabled />
										<label for="address_detail" class="hidden">주소</label>
										<input type="text" id="address_detail" class="form-control w30 fl mr5">
										<button type="button" class="gray_btn2 adress_btn">검색</button>
									</td>
							    </tr>
							    <tr>
									<th scope="row"><label for="phone_1">전화</label></th>
									<td>
										<input type="tel" id="phone_1" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl ls" />
										<span style="display:block;" class="fl mc8">-</span>
										<label for="phone_2" class="hidden">전화</label>
										<input type="tel" id="phone_2" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl ls" />
										<span style="display:block;" class="fl mc8 ls">-</span>
										<label for="phone_3" class="hidden">전화</label>
										<input type="tel" id="phone_3" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl ls" />
									</td> 
							    </tr>
							    <tr>
									<th scope="row"><label for="representative_name">대표자명</label></th>
									<td><input type="text" id="representative_name" class="form-control w_18" /></td> 
							    </tr>
							    <tr>
									<th scope="row"><label for="industry_type">업종</label></th>
									<td><input type="text" id="industry_type" class="form-control w_40" /></td> 
							    </tr>
							    <tr>
									<th scope="row"><label for="business_type">업태</label></th>
									<td><input type="text" id="business_type" class="form-control w_40" /></td> 
							    </tr>
							    <tr>
									<th scope="row"><label for="foundation_date">설립일</label></th>
									<td>
										<div class="datepicker_area fl mr5">
											<input type="text" id="foundation_date" class="datepicker form-control w_14 mr5 ls" />
										</div>
									</td> 
								</tr>
								<tr>
									<th scope="row">설립 구분</th>
									<td>
										<input type="radio" id="mypage_company_classification_of_establishment1" name="foundation_type_radio" value="D0000001" checked />
										<label for="mypage_company_classification_of_establishment1">영리</label>
										<input type="radio" id="mypage_company_classification_of_establishment2" name="foundation_type_radio" value="D0000002" />
										<label for="mypage_company_classification_of_establishment2">비영리</label>								
									</td>
								</tr>
								<tr>
									<th scope="row">기업 분류</th>
									<td>
										<input type="radio" id="mypage_company_class1" name="company_class_radio" value="D0000001"/>
										<label for="mypage_company_class1">대기업</label>
										<input type="radio" id="mypage_company_class2" name="company_class_radio" value="D0000002"/>
										<label for="mypage_company_class2">중견기업</label>	
										<input type="radio" id="mypage_company_class3" name="company_class_radio" value="D0000003"/>
										<label for="mypage_company_class3">중소기업</label>
										<input type="radio" id="mypage_company_class4" name="company_class_radio" value="D0000004"/>
										<label for="mypage_company_class4">기타</label>	
									</td>
								</tr>
								<tr>
									<th scope="row">기업 유형</th>
									<td>
										<input type="radio" id="mypage_company_other_class1" name="company_type_radio" value="D0000001"/>
										<label for="mypage_company_other_class1">여성기업</label>
										<input type="radio" id="mypage_company_other_class2" name="company_type_radio" value="D0000002"/>
										<label for="mypage_company_other_class2">장애인기업</label>	
										<input type="radio" id="mypage_company_other_class3" name="company_type_radio" value="D0000003"/>
										<label for="mypage_company_other_class3">사회적기업</label>
										<input type="radio" id="mypage_company_other_class4" name="company_type_radio" value="D0000004"/> 
										<label for="mypage_company_other_class4">해당 없음</label>	
									</td>
								</tr>
								<tr>
									<th scope="row">기업부설연구소 유무</th>
									<td>
										<input type="radio" id="mypage_company_or_lab1" name="lab_exist_yn_radio" value="Y" />
										<label for="mypage_company_or_lab1">있음</label>
										<input type="radio" id="mypage_company_or_lab2" name="lab_exist_yn_radio" value="N" />
										<label for="mypage_company_or_lab2">없음</label>	
									</td>
								</tr>
							</tbody>
						</table>
						<!--//기관정보-->

						<!--주관기관-->
						<!--연구책임자 정보(주관기관)-->
						<div class="view_top_area section1">
							<div class="section_title">주관기관</div>							    
							<div class="view_top_area clearfix">
								<h4 class="fl sub_title_h4">연구책임자 정보</h4>
							</div>
							<div class="table_area">
								<table class="write fixed list responsible">
									<caption>연구책임자 정보</caption> 
									<colgroup>
									   <col style="width: 3%">
									   <col style="width: 5%">
									   <col style="width: 10%">
									   <col style="width: 8%">
									   <col style="width: 6%">
									   <col style="width: 6%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									   <col style="width: 26%">
									   <col style="width: 4%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
									   </tr>
									</thead>
									<tbody id="bdy_supervision_senior_researcher">
										<tr>
											<td>1</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_companyname" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_companyname" /></td>
											<td><label for="responsible_companypartname" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_companypartname" /></td>
											<td><label for="responsible_companypositionname" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_companypositionname" /></td>
											<td><label for="responsible_name" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_name" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_birthday" class="hidden">생년월일</label><input type="text" id="responsible_birthday" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_phoneNumber" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_phoneNumber" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="responsible_email_front" class="hidden">이메일</label>												
													<input type="text" name="str_email" id="responsible_email_front" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_email_back" class="hidden">이메일</label>			
													<input type="text" name="str_email" id="responsible_email_back" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail" class="hidden">이메일</label>		
													<select name="selectEmail" class="fl ace-select d_input w34 selectEmail" id="selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_percent" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_percent" maxlength="3" /><span class="
											fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_startday" class="hidden">참여 시작일</label><input type="text" id="responsible_startday" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_endday" class="hidden">참여 종료일</label><input type="text" id="responsible_endday" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
									   </tr>						       
									</tbody>
								</table>
							</div>
							<!--//연구책임자 정보(주관기관)-->
							
							<!-- 참여연구원 정보-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">참여 연구원 정보</h4>
							</div>
							<div class="table_area" style="overflow-x: scroll;">
								<table class="write fixed list chamyeo">
									<caption>참여 연구원 정보</caption> 
									<colgroup>
									   <col style="width: 3%">
									   <col style="width: 4%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									   <col style="width: 6%">
									   <col style="width: 6%">
									   <col style="width: 8%">
									   <col style="width: 7%">
									   <col style="width: 24%">
									   <col style="width: 4%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									   <col style="width: 6%">
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
										   <th scope="col">역할</th>
									   </tr>
									</thead>
									<tbody id="bdy_supervision_researcher">								       
									   <tr>
											<td>1</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname1" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname1" /></td>
											<td><label for="responsible_chamyeo_companypartname1" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname1" /></td>
											<td><label for="responsible_chamyeo_companypositionname1" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname1" /></td>
											<td><label for="responsible_chamyeo_name1" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name1" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday1" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday1" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber1" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber1" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="responsible_chamyeo_email_front1" class="hidden">이메일</label>													
													<input type="text" name="str_email" id="responsible_chamyeo_email_front1" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>		
													<label for="responsible_chamyeo_email_back1" class="hidden">이메일</label>										
													<input type="text" name="str_email" id="responsible_chamyeo_email_back1" class="form-control fl mb5 w30 str_email mr5" disabled />
													<label for="selectEmail1" class="hidden">이메일</label>				
													<select id="selectEmail1" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td>
												<label for="responsible_chamyeo_percent1" class="hidden">참여율</label>	
												<input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent1" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday1" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday1" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday1" class="hidden">참여종료일</label>	
													<input type="text" id="responsible_chamyeo_endday1" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role1" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role1" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>2</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname2" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname2" /></td>
											<td><label for="responsible_chamyeo_companypartname2" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname2" /></td>
											<td><label for="responsible_chamyeo_companypositionname2" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname2" /></td>
											<td><label for="responsible_chamyeo_name2" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name2" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday2" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday2" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber2" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber2" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="responsible_chamyeo_email_front2" class="hidden">이메일</label>													
													<input type="text" name="str_email" id="responsible_chamyeo_email_front2" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>	
													<label for="responsible_chamyeo_email_back2" class="hidden">이메일</label>										
													<input type="text" name="str_email" id="responsible_chamyeo_email_back2" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail2" class="hidden">이메일</label>
													<select id="selectEmail2" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td>
												<label for="responsible_chamyeo_percent2" class="hidden">참여율</label>
												<input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent2" maxlength="3" /><span class="fl mt5">%</span>
											</td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday2" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday2" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday2" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday2" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role2" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role2" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>3</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname3" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname3" /></td>
											<td><label for="responsible_chamyeo_companypartname3" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname3" /></td>
											<td><label for="responsible_chamyeo_companypositionname3" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname3" /></td>
											<td><label for="responsible_chamyeo_name3" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name3" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday3" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday3" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber3" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber3" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">													
													<label for="responsible_chamyeo_email_front3" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_front3" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_chamyeo_email_back3" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_back3" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail3" class="hidden">이메일</label>	
													<select id="selectEmail3" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent3" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent3" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday3" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday3" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday3" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday3" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role3" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role3" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>4</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname4" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname4" /></td>
											<td><label for="responsible_chamyeo_companypartname4" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname4" /></td>
											<td><label for="responsible_chamyeo_companypositionname4" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname4" /></td>
											<td><label for="responsible_chamyeo_name4" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name4" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday4" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday4" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber4" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber4" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">													
													<label for="responsible_chamyeo_email_front4" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_front4" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_chamyeo_email_back4" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_back4" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail4" class="hidden">이메일</label>
													<select id="selectEmail4" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent4" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent4" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday4" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday4" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday4" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday4" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role4" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role4" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>5</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname5" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname5" /></td>
											<td><label for="responsible_chamyeo_companypartname5" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname5" /></td>
											<td><label for="responsible_chamyeo_companypositionname5" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname5" /></td>
											<td><label for="responsible_chamyeo_name5" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name5" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday5" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday5" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber5" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber5" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">		
													<label for="responsible_chamyeo_email_front5" class="hidden">이메일</label>											
													<input type="text" name="str_email" id="responsible_chamyeo_email_front5" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>	
													<label for="responsible_chamyeo_email_back5" class="hidden">이메일</label>										
													<input type="text" name="str_email" id="responsible_chamyeo_email_back5" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail5" class="hidden">이메일</label>
													<select id="selectEmail5" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent5" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent5" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday5" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday5" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday5" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday5" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role5" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role5" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>6</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname6" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname6" /></td>
											<td><label for="responsible_chamyeo_companypartname6" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname6" /></td>
											<td><label for="responsible_chamyeo_companypositionname6" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname6" /></td>
											<td><label for="responsible_chamyeo_name6" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name6" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday6" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday6" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber6" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber6" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="responsible_chamyeo_email_front6" class="hidden">이메일</label>													
													<input type="text" name="str_email" id="responsible_chamyeo_email_front6" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_chamyeo_email_back6" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_back6" class="form-control fl mb5 w30 str_email mr5" disabled />								
													<label for="selectEmail6" class="hidden">이메일</label>	
													<select id="selectEmail6" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent6" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent6" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday6" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday6" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday6" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday6" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role6" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role6" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>7</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname7" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname7" /></td>
											<td><label for="responsible_chamyeo_companypartname7" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname7" /></td>
											<td><label for="responsible_chamyeo_companypositionname7" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname7" /></td>
											<td><label for="responsible_chamyeo_name7" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name7" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday7" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday7" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber7" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber7" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">
													<label for="responsible_chamyeo_email_front7" class="hidden">이메일</label>														
													<input type="text" name="str_email" id="responsible_chamyeo_email_front7" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_chamyeo_email_back7" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_back7" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail7" class="hidden">이메일</label>
													<select id="selectEmail7" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent7" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent7" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday7" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday7" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday7" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday7" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role7" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role7" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>8</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname8" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname8" /></td>
											<td><label for="responsible_chamyeo_companypartname8" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname8" /></td>
											<td><label for="responsible_chamyeo_companypositionname8" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname8" /></td>
											<td><label for="responsible_chamyeo_name8" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name8" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday8" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday8" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber8" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber8" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">
													<label for="responsible_chamyeo_email_front8" class="hidden">이메일</label>													
													<input type="text" name="str_email" id="responsible_chamyeo_email_front8" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>		
													<label for="responsible_chamyeo_email_back8" class="hidden">이메일</label>									
													<input type="text" name="str_email" id="responsible_chamyeo_email_back8" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail8" class="hidden">이메일</label>
													<select id="selectEmail8" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent8" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent8" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday8" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday8" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday8" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday8" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role8" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role8" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>9</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname9" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname9" /></td>
											<td><label for="responsible_chamyeo_companypartname9" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname9" /></td>
											<td><label for="responsible_chamyeo_companypositionname9" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname9" /></td>
											<td><label for="responsible_chamyeo_name9" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name9" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday9" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday9" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber9" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber9" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="responsible_chamyeo_email_front9" class="hidden">이메일</label>												
													<input type="text" name="str_email" id="responsible_chamyeo_email_front9" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_chamyeo_email_back9" class="hidden">이메일</label>
													<input type="text" name="str_email" id="responsible_chamyeo_email_back9" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="selectEmail9" class="hidden">이메일</label>
													<select id="selectEmail9" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent9" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent9" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday9" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday9" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday9" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday9" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role9" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role9" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>10</td>
											<td><span>주관기관</span></td>
											<td><label for="responsible_chamyeo_companyname10" class="hidden">기관명</label><input type="text" class="form-control w100" id="responsible_chamyeo_companyname10" /></td>
											<td><label for="responsible_chamyeo_companypartname10" class="hidden">부서</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypartname10" /></td>
											<td><label for="responsible_chamyeo_companypositionname10" class="hidden">직책</label><input type="text" class="form-control w100" id="responsible_chamyeo_companypositionname10" /></td>
											<td><label for="responsible_chamyeo_name10" class="hidden">성명</label><input type="text" class="form-control w100" id="responsible_chamyeo_name10" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_birthday10" class="hidden">생년월일</label><input type="text" id="responsible_chamyeo_birthday10" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="responsible_chamyeo_phoneNumber10" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="responsible_chamyeo_phoneNumber10" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">													
													<label for="responsible_chamyeo_email_front10" class="hidden">이메일</label>	
													<input type="text" name="str_email" id="responsible_chamyeo_email_front10" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="responsible_chamyeo_email_back10" class="hidden">이메일</label>	
													<input type="text" name="str_email" id="responsible_chamyeo_email_back10" class="form-control fl mb5 w30 str_email mr5" disabled />	
													<label for="selectEmail10" class="hidden">이메일</label>				
													<select id="selectEmail10" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="responsible_chamyeo_percent10" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="responsible_chamyeo_percent10" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="responsible_chamyeo_startday10" class="hidden">참여시작일</label><input type="text" id="responsible_chamyeo_startday10" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="responsible_chamyeo_endday10" class="hidden">참여종료일</label><input type="text" id="responsible_chamyeo_endday10" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="responsible_chamyeo_role10" class="hidden">역할</label><input type="text" id="responsible_chamyeo_role10" class="form-control w100 ls" />							
											</td>
									   </tr>
									</tbody>
								</table>
							</div>
							<!-- //참여연구원 정보-->										
						</div>								
						<!--//주관기관-->
						
						<!--참여기관-->
						<!--책임연구원책임자 정보-->
						<div class="view_top_area section1">
							<div class="section_title">참여기관</div>							    
							<div class="view_top_area clearfix">
								<h4 class="fl sub_title_h4">책임연구원책임자 정보</h4>
							</div>
							<div class="table_area">
								<table class="write fixed list responsible">
									<caption>책임연구원책임자 정보</caption> 
									<colgroup>
									   <col style="width: 3%">
									   <col style="width: 5%">
									   <col style="width: 10%">
									   <col style="width: 8%">
									   <col style="width: 6%">
									   <col style="width: 6%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									   <col style="width: 26%">
									   <col style="width: 4%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
									   </tr>
									</thead>
									<tbody id="bdy_senior_researcher">								       
									   <tr>
											<td>1</td>
											<td><span>참여기관</span></td>
											<td><label for="chamyeo_responsible_companyname" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_companyname" /></td>
											<td><label for="chamyeo_responsible_companypartname" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_companypartname" /></td>
											<td><label for="chamyeo_responsible_companypositionname" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_companypositionname" /></td>
											<td><label for="chamyeo_responsible_name" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_name" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_birthday" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_birthday" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_phoneNumber" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_phoneNumber" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">		
													<label for="chamyeo_responsible_email_front" class="hidden">이메일</label>											
													<input type="text" name="str_email" id="chamyeo_responsible_email_front" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>	
													<label for="chamyeo_responsible_email_back" class="hidden">이메일</label>											
													<input type="text" name="str_email" id="chamyeo_responsible_email_back" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_selectEmail" class="hidden">이메일</label>
													<select id="chamyeo_selectEmail" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td>
												<label for="chamyeo_responsible_percent" class="hidden">참여율</label>
												<input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_percent" maxlength="3" /><span class="fl mt5">%</span>
											</td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_startday" class="hidden">참여시작일</label>
													<input type="text" id="chamyeo_responsible_startday" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_endday" class="hidden">참여종료일</label>
													<input type="text" id="chamyeo_responsible_endday" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
									   </tr>
									</tbody>
								</table>
							</div>
							<!--//책임연구원책임자 정보-->
							
							<!-- 참여연구원 정보-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">참여 연구원 정보</h4>
							</div>
							<div class="table_area" style="overflow-x: scroll;">
								<table class="write fixed list chamyeo">
									<caption>참여 연구원 정보</caption> 
									<colgroup>
									   <col style="width: 3%">
									   <col style="width: 5%">
									   <col style="width: 8%">
									   <col style="width: 7%">
									   <col style="width: 6%">
									   <col style="width: 6%">
									   <col style="width: 8%">
									   <col style="width: 7%">
									   <col style="width: 24%">
									   <col style="width: 4%">
									   <col style="width: 8%">
									   <col style="width: 8%">
									   <col style="width: 6%">
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
										   <th scope="col">역할</th>
									   </tr>
									</thead>
									<tbody id="bdy_researcher">								       
									   <tr>
											<td>1</td>
											<td><span>참여기관1</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname1" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname1" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname1" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname1" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname1" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname1" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name1" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name1" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday1" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday1" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber1" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber1" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="chamyeo_responsible_chamyeo_email_front1" class="hidden">이메일</label>												
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front1" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back1" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back1" class="form-control fl mb5 w30 str_email mr5" disabled />										
													<label for="chamyeo_email_selectEmail1" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail1" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent1" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent1" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday1" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday1" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday1" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday1" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role1" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role1" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>2</td>
											<td><span>참여기관2</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname2" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname2" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname2" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname2" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname2" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname2" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name2" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name2" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday2" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday2" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber2" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber2" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">		
													<label for="chamyeo_responsible_chamyeo_email_front2" class="hidden">이메일</label>											
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front2" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back2" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back2" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail2" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail2" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent2" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent2" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday2" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday2" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday2" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday2" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role2" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role2" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>3</td>
											<td><span>참여기관3</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname3" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname3" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname3" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname3" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname3" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname3" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name3" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name3" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday3" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday3" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber3" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber3" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="chamyeo_responsible_chamyeo_email_front3" class="hidden">이메일</label>													
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front3" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>		
													<label for="chamyeo_responsible_chamyeo_email_back3" class="hidden">이메일</label>									
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back3" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail3" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail3" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent3" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent3" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday3" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday3" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday3" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday3" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role3" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role3" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>4</td>
											<td><span>참여기관4</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname4" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname4" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname4" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname4" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname4" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname4" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name4" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name4" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday4" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday4" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber4" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber4" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">		
													<label for="chamyeo_responsible_chamyeo_email_front4" class="hidden">이메일</label>											
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front4" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back4" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back4" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail4" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail4" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent4" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent4" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday4" class="hidden">참여시작일</label>
													<input type="text" id="chamyeo_responsible_chamyeo_startday4" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday4" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday4" class="datepicker form-control w_12 ls mr5">
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role4" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role4" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>5</td>
											<td><span>참여기관5</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname5" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname5" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname5" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname5" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname5" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname5" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name5" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name5" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday5" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday5" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber5" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber5" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="chamyeo_responsible_chamyeo_email_front5" class="hidden">이메일</label>												
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front5" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>	
													<label for="chamyeo_responsible_chamyeo_email_back5" class="hidden">이메일</label>										
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back5" class="form-control fl mb5 w30 str_email mr5" disabled />
													<label for="chamyeo_email_selectEmail5" class="hidden">이메일</label>				
													<select id="chamyeo_email_selectEmail5" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent5" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent5" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday5" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday5" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday5" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday5" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role5" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role5" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>6</td>
											<td><span>참여기관6</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname6" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname6" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname6" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname6" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname6" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname6" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name6" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name6" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday6" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday6" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber6" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber6" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="chamyeo_responsible_chamyeo_email_front6" class="hidden">이메일</label>												
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front6" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back6" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back6" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail6" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail6" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent6" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent6" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday6" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday6" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday6" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday6" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role6" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role6" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>7</td>
											<td><span>참여기관7</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname7" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname7" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname7" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname7" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname7" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname7" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name7" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name7" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday7" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday7" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber7" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber7" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">													
													<label for="chamyeo_responsible_chamyeo_email_front7" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front7" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back7" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back7" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail7" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail7" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent7" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent7" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday7" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday7" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday7" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday7" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role7" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role7" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>8</td>
											<td><span>참여기관8</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname8" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname8" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname8" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname8" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname8" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname8" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name8" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name8" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday8" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday8" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber8" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber8" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">
													<label for="chamyeo_responsible_chamyeo_email_front8" class="hidden">이메일</label>														
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front8" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back8" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back8" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail8" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail8" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent8" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent8" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday8" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday8" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday8" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday8" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role8" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role8" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>9</td>
											<td><span>참여기관9</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname9" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname9" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname9" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname9" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname9" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname9" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name9" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name9" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday9" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday9" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber9" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber9" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">	
													<label for="chamyeo_responsible_chamyeo_email_front9" class="hidden">이메일</label>												
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front9" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back9" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back9" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail9" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail9" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent9" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent9" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday9" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday9" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday9" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday9" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role9" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role9" class="form-control w100 ls" />							
											</td>
									   </tr>
									   <tr>
											<td>10</td>
											<td><span>참여기관10</span></td>
											<td><label for="chamyeo_responsible_chamyeo_companyname10" class="hidden">기관명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companyname10" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypartname10" class="hidden">부서</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypartname10" /></td>
											<td><label for="chamyeo_responsible_chamyeo_companypositionname10" class="hidden">직책</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_companypositionname10" /></td>
											<td><label for="chamyeo_responsible_chamyeo_name10" class="hidden">성명</label><input type="text" class="form-control w100" id="chamyeo_responsible_chamyeo_name10" /></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_birthday10" class="hidden">생년월일</label><input type="text" id="chamyeo_responsible_chamyeo_birthday10" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<label for="chamyeo_responsible_chamyeo_phoneNumber10" class="hidden">휴대전화</label><input type="text" class="form-control w100 phoneNumber ls" id="chamyeo_responsible_chamyeo_phoneNumber10" maxlength="13" />
											</td>
											<td>
												<form class="responsible_studies_email">													
													<label for="chamyeo_responsible_chamyeo_email_front10" class="hidden">이메일</label>	
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_front10" class="form-control w30 fl d_input">
													<span class="fl ml1 mr1 pt10 mail_f">@</span>											
													<label for="chamyeo_responsible_chamyeo_email_back10" class="hidden">이메일</label>
													<input type="text" name="str_email" id="chamyeo_responsible_chamyeo_email_back10" class="form-control fl mb5 w30 str_email mr5" disabled />				
													<label for="chamyeo_email_selectEmail10" class="hidden">이메일</label>
													<select id="chamyeo_email_selectEmail10" name="selectEmail" class="fl ace-select d_input w34 selectEmail"> 
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
												</form>
											</td>
											<td><label for="chamyeo_responsible_chamyeo_percent10" class="hidden">참여율</label><input type="text" class="form-control w70 onlynum ls fl mr5" id="chamyeo_responsible_chamyeo_percent10" maxlength="3" /><span class="fl mt5">%</span></td>
											<td>
												<div class="datepicker_area w100">
													<label for="chamyeo_responsible_chamyeo_startday10" class="hidden">참여시작일</label><input type="text" id="chamyeo_responsible_chamyeo_startday10" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>
												<div class="datepicker_area">
													<label for="chamyeo_responsible_chamyeo_endday10" class="hidden">참여종료일</label><input type="text" id="chamyeo_responsible_chamyeo_endday10" class="datepicker form-control w_12 ls mr5" />
												</div>
											</td>
											<td>														
												<label for="chamyeo_responsible_chamyeo_role10" class="hidden">역할</label><input type="text" id="chamyeo_responsible_chamyeo_role10" class="form-control w100 ls" />							
											</td>
									   </tr>
									</tbody>
								</table>
							</div>
							<!-- //참여연구원 정보-->
						</div>								
						<!--//참여기관-->

						<!--연구비 정보-->
						<div class="view_top_area clearfix">
						   <h4 class="fl sub_title_h4">연구비 정보</h4>
						   <!-- <button type="button" class="blue_btn2 fr mt50 add_table_cell">추가</button> -->
						</div>
						<div class="table_area">
							<table class="write fixed list research_cost">										 
								<caption>연구비 정보</caption>		
								<colgroup>
								   <col style="width: 20%">
								   <col style="width: 20%">
								   <col style="width: 20%">
								   <col style="width: 20%">
								   <col style="width: 20%">
								</colgroup>
								<thead>
								   <tr><th scope="col" colspan="5">구분</th></tr>
								   <tr>
									   <th scope="col">&nbsp;</th>
									   <th scope="col">시지원금(A)</th>
									   <th scope="col">민간부담금 현금(B)</th>
									   <th scope="col">민간부담금 현물(C)</th>
									   <th scope="col">총사업비(D=A+B+C)</th>												   
								   </tr>
								</thead>													
								<tbody>	
									<tr>
										<td class="ta_c total_all"><span class="fw_b">총사업비</span></td>
										<td class="total_all">
											<label for="support_amount1" class="hidden">시지원금(A)</label>
											<input type="text" class="form-control w80 ls mb5 money fl mr5" value="0" id="support_amount1" disabled />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td class="total_all">
											<label for="cash1" class="hidden">민간부담금 현금(B)</label>
											<input type="text" class="form-control w80 ls mb5 money fl mr5" value="0" id="cash1" disabled />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td class="total_all">
											<label for="hyeonmul1" class="hidden">민간부담금 현물(C)</label>
											<input type="text" class="form-control w80 ls mb5 money fl mr5" value="0" id="hyeonmul1" disabled />
											<span class="fl mt5">(만원)</span>
										</td>
										<td class="total_all">
											<label for="total_project_cost1" class="hidden">총사업비(D=A+B+C)</label>
											<input type="text" class="form-control w80 ls mb5 money fl mr5" value="0" id="total_project_cost1" disabled />
											<span class="fl mt5">(만원)</span>
										</td>
									</tr>
									<tr>
										<td class="ta_c">주관기관</td>
										<td>
											<label for="support_amount2" class="hidden">시지원금(A)</label>
											<input type="text" onkeyup="onSumMoney(this, 2);" value="0" class="form-control w80 ls mb5 money fl mr5" name="support_amount1" id="support_amount2" />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td>
											<label for="cash2" class="hidden">민간부담금 현금(B)</label>
											<input type="text" onkeyup="onSumMoney(this, 2);" value="0" class="form-control w80 ls mb5 money fl mr5" name="cash1" id="cash2" />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td>
											<label for="hyeonmul2" class="hidden">민간부담금 현물(C)</label>
											<input type="text" onkeyup="onSumMoney(this, 2);" value="0" class="form-control w80 ls mb5 money fl mr5" name="hyeonmul1" id="hyeonmul2" />
											<span class="fl mt5">(만원)</span>
										</td>
										<td>
											<label for="total_project_cost2" class="hidden">총사업비(D=A+B+C)</label>
											<input type="text" onkeyup="onSumMoney(this, 2);" value="0" class="form-control w80 ls mb5 money fl mr5" name="total_project_cost1" id="total_project_cost2" disabled />
											<span class="fl mt5">(만원)</span>
										</td>
									</tr>
									<tr>
										<td class="ta_c">참여기관1</td>
										<td>
											<label for="support_amount3" class="hidden">시지원금(A)</label>
											<input type="text" onkeyup="onSumMoney(this, 3);" value="0" class="form-control w80 ls mb5 money fl mr5" name="support_amount1" id="support_amount3" />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td>
											<label for="cash3" class="hidden">민간부담금 현금(B)</label>
											<input type="text" onkeyup="onSumMoney(this, 3);" value="0" class="form-control w80 ls mb5 money fl mr5" name="cash1" id="cash3" />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td>
											<label for="hyeonmul3" class="hidden">민간부담금 현물(C)</label>
											<input type="text" onkeyup="onSumMoney(this, 3);" value="0" class="form-control w80 ls mb5 money fl mr5" name="hyeonmul1" id="hyeonmul3" />
											<span class="fl mt5">(만원)</span>
										</td>
										<td>
											<label for="total_project_cost3" class="hidden">총사업비(D=A+B+C)</label>
											<input type="text" onkeyup="onSumMoney(this, 3);" value="0" class="form-control w80 ls mb5 money fl mr5" name="total_project_cost1" id="total_project_cost3" disabled />
											<span class="fl mt5">(만원)</span>
										</td>
									</tr>
									<tr>
										<td class="ta_c">참여기관2</td>
										<td>
											<label for="support_amount4" class="hidden">시지원금(A)</label>
											<input type="text" onkeyup="onSumMoney(this, 4);" value="0" class="form-control w80 ls mb5 money fl mr5" name="support_amount1" id="support_amount4" />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td>
											<label for="cash4" class="hidden">민간부담금 현금(B)</label>
											<input type="text" onkeyup="onSumMoney(this, 4);" value="0" class="form-control w80 ls mb5 money fl mr5" name="cash1" id="cash4" />
											<span class="fl mt5">(만원)</span>
										</td> 
										<td>
											<label for="hyeonmul4" class="hidden">민간부담금 현물(C)</label>
											<input type="text" onkeyup="onSumMoney(this, 4);" value="0" class="form-control w80 ls mb5 money fl mr5" name="hyeonmul1" id="hyeonmul4" />
											<span class="fl mt5">(만원)</span>
										</td>
										<td>
											<label for="total_project_cost4" class="hidden">총사업비(D=A+B+C)</label>
											<input type="text" onkeyup="onSumMoney(this, 4);" value="0" class="form-control w80 ls mb5 money fl mr5" name="total_project_cost1" id="total_project_cost4" disabled />
											<span class="fl mt5">(만원)</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- //연구비 정보-->

						<!--연구비 상세정보-->
						<div class="view_top_area clearfix">
						   <h4 class="fl sub_title_h4">연구비 상세정보</h4>
						   <!-- <button type="button" class="blue_btn2 fr mt50 add_table_cell">추가</button> -->
						</div>
						<div class="table_area" style="overflow-x: scroll;">
							<table class="write fixed list research_cost_detail">										 
								<caption>연구비 정보</caption>		
								<colgroup>
								   <col style="width: 5%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 9%">
								   <col style="width: 10%">
								</colgroup>
								<thead>
								   <tr><th scope="col" colspan="11">비목</th></tr>
								   <tr>
									   <th scope="col">&nbsp;</th>
									   <th scope="col" class="total">인건비(A+B)</th>
									   <th scope="col">내부인건비(A)</th>
									   <th scope="col">외부인건비(B)</th>
									   <th scope="col" class="total">경비(C+D+E+F)</th>	
									   <th scope="col">연구장비/재료비(C)</th>	
									   <th scope="col">연구활동비(D)</th>	
									   <th scope="col">위탁사업비(E)</th>	
									   <th scope="col">성과장려비(F)</th>
									   <th scope="col" class="total">간접비(G)</th>
									   <th scope="col" class="total_all">합계(A+B+C+D+E+F+G)</th>
								   </tr>
								</thead>													
								<tbody id="fund_detail_body">	
									<tr>
										<td class="ta_c">총사업비</td>
										<td class="total">
											<label for="aplusb_total1" class="hidden">총사업비 인건비(A+B) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="aplusb_total1" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="aplusb_total_p1" class="hidden">총사업비 인건비(A+B) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="aplusb_total_p1" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="a1" class="hidden">총사업비 내부인건비(A) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total1" id="a1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="a1_p" class="hidden">총사업비 내부인건비(A) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p1" id="a1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="b1" class="hidden">총사업비 외부인건비(B) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total1" id="b1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="b1_p" class="hidden">총사업비 외부인건비(B) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p1" id="b1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="cdef1" class="hidden">총사업비 경비(C+D+E+F) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="cdef1" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="cdef_p1" class="hidden">총사업비 경비(C+D+E+F) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="cdef_p1" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="c1" class="hidden">총사업비 연구장비/재료비(C) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef1" id="c1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="c1_p" class="hidden">총사업비 연구장비/재료비(C) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p1" id="c1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="d1" class="hidden">총사업비 연구활동비(D) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef1" id="d1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="d1_p" class="hidden">총사업비 연구활동비(D) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p1" id="d1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="e1" class="hidden">총사업비 위탁사업비(E) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef1" id="e1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="e1_p" class="hidden">총사업비 위탁사업비(E) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p1" id="e1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="f1" class="hidden">총사업비 성과장려비(F) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef1" id="f1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="f1_p" class="hidden">총사업비 성과장려비(F) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p1" id="f1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="g1" class="hidden">총사업비 간접비(G) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="g1" id="g1" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="g1_p" class="hidden">총사업비 간접비(G) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="g_p1" id="g1_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total_all">
											<label for="total_project_detail_cost1" class="hidden">총사업비 합계(A+B+C+D+E+F+G) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="total_project_detail_cost1" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="total_project_detail_cost1_p" class="hidden">총사업비 합계(A+B+C+D+E+F+G) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="total_project_detail_cost1_p" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
									</tr>
									<tr>
										<td class="ta_c">주관기관</td>
										<td class="total">
											<label for="aplusb_total2" class="hidden">주관기관 인건비(A+B) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="aplusb_total2" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="aplusb_total_p2" class="hidden">주관기관 인건비(A+B) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="aplusb_total_p2" maxlength="3"  disabled />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="a2" class="hidden">주관기관 내부인건비(A) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total2" id="a2" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="a2_p" class="hidden">주관기관 내부인건비(A) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p2" id="a2_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="b2" class="hidden">주관기관 외부인건비(B) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total2" id="b2" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="b2_p" class="hidden">주관기관 외부인건비(B) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p2" id="b2_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="cdef2" class="hidden">주관기관 경비(C+D+E+F) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="cdef2" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="cdef_p2" class="hidden">주관기관 경비(C+D+E+F) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="cdef_p2" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="c2" class="hidden">주관기관 연구장비/재료비(C) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef2" id="c2" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="c2_p" class="hidden">주관기관 연구장비/재료비(C) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p2" id="c2_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="d2" class="hidden">주관기관 연구활동비(D) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef2" id="d2" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="d2_p" class="hidden">주관기관 연구활동비(D) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p2" id="d2_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="e2" class="hidden">주관기관 위탁사업비(E) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef2" id="e2" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="e2_p" class="hidden">주관기관 위탁사업비(E) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p2" id="e2_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="f2" class="hidden">주관기관 성과장려비(F) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef2" id="f2" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="f2_p" class="hidden">주관기관 성과장려비(F) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p2" id="f2_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="g2" class="hidden">주관기관 간접비(G) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="g2" id="g2"  />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="g2_p" class="hidden">주관기관 간접비(G) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="g_p2" id="g2_p" maxlength="3"  />
											<span class="fl mt5">%</span>
										</td>
										<td class="total_all">
											<label for="total_project_detail_cost2" class="hidden">주관기관 합계(A+B+C+D+E+F+G) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="total_project_detail_cost2" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="total_project_detail_cost2_p" class="hidden">주관기관 합계(A+B+C+D+E+F+G) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="total_project_detail_cost2_p" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
									</tr>
									<tr>
										<td class="ta_c">참여기관1</td>
										<td class="total">
											<label for="aplusb_total3" class="hidden">참여기관1 인건비(A+B) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="aplusb_total3" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="aplusb_total_p3" class="hidden">참여기관1 인건비(A+B) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="aplusb_total_p3" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="a3" class="hidden">참여기관1 내부인건비(A) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total3" id="a3" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="a3_p" class="hidden">참여기관1 내부인건비(A) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p3" id="a3_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="b3" class="hidden">참여기관1 외부인건비(B) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total3" id="b3" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="b3_p" class="hidden">참여기관1 외부인건비(B) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p3" id="b3_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="cdef3" class="hidden">참여기관1 경비(C+D+E+F) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="cdef3" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="cdef_p3" class="hidden">참여기관1 경비(C+D+E+F) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="cdef_p3" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="c3" class="hidden">참여기관1 연구장비/재료비(C) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef3" id="c3" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="c3_p" class="hidden">참여기관1 연구장비/재료비(C) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p3" id="c3_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="d3" class="hidden">참여기관1 연구활동비(D) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef3" id="d3" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="d3_p" class="hidden">참여기관1 연구활동비(D) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p3" id="d3_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="e3" class="hidden">참여기관1 위탁사업비(E) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef3" id="e3" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="e3_p" class="hidden">참여기관1 위탁사업비(E) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p3" id="e3_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="f3" class="hidden">참여기관1 성과장려비(F) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef3" id="f3" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="f3_p" class="hidden">참여기관1 성과장려비(F) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p3" id="f3_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="g3" class="hidden">참여기관1 간접비(G) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="g3" id="g3"  />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="g3_p" class="hidden">참여기관1 간접비(G) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="g_p3" id="g3_p" maxlength="3"  />
											<span class="fl mt5">%</span>
										</td>
										<td class="total_all">
											<label for="total_project_detail_cost3" class="hidden">참여기관1 합계(A+B+C+D+E+F+G) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="total_project_detail_cost3" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="total_project_detail_cost3_p" class="hidden">참여기관1 합계(A+B+C+D+E+F+G) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="total_project_detail_cost3_p" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
									</tr>
									<tr>
										<td class="ta_c">참여기관2</td>
										<td class="total">
											<label for="aplusb_total4" class="hidden">참여기관2 인건비(A+B) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="aplusb_total4" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="aplusb_total_p4" class="hidden">참여기관2 인건비(A+B) 만원</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="aplusb_total_p4" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="a4" class="hidden">참여기관2 내부인건비(A) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total4" id="a4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="a4_p" class="hidden">참여기관2 내부인건비(A) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p4" id="a4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td> 
										<td>
											<label for="b4" class="hidden">참여기관2 외부인건비(B) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="aplusb_total4" id="b4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="b4_p" class="hidden">참여기관2 외부인건비(B) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="aplusb_total_p4" id="b4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="cdef4" class="hidden">참여기관2 경비(C+D+E+F) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="cdef4" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="cdef_p4" class="hidden">참여기관2 경비(C+D+E+F) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="cdef_p4" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="c4" class="hidden">참여기관4 연구장비/재료비(C) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef4" id="c4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="c4_p" class="hidden">참여기관4 연구장비/재료비(C) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p4" id="c4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="d4" class="hidden">참여기관2 연구활동비(D) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef4" id="d4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="d4_p" class="hidden">참여기관2 연구활동비(D) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p4" id="d4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="e4" class="hidden">참여기관2 위탁사업비(E) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef4" id="e4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="e4_p" class="hidden">참여기관2 위탁사업비(E) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p4" id="e4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td>
											<label for="f4" class="hidden">참여기관2 성과장려비(F) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="cdef4" id="f4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="f4_p" class="hidden">참여기관2 성과장려비(F) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="cdef_p4" id="f4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total">
											<label for="g4" class="hidden">참여기관2 간접비(G) 만원</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w50 ls mb5 money fl mr5" name="g4" id="g4" />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="g4_p" class="hidden">참여기관2 간접비(G) %</label>
											<input type="text" onkeyup="onSumMoneyDetail(this);" class="form-control w20 onlynum ls fl mr5" name="g_p4" id="g4_p" maxlength="3" />
											<span class="fl mt5">%</span>
										</td>
										<td class="total_all">
											<label for="total_project_detail_cost4" class="hidden">참여기관2 합계(A+B+C+D+E+F+G) 만원</label>
											<input type="text" class="form-control w50 ls mb5 money fl mr5" id="total_project_detail_cost4" disabled />
											<span class="fl mt5 mr10">(만원)</span>
											<label for="total_project_detail_cost4_p" class="hidden">참여기관2 합계(A+B+C+D+E+F+G) %</label>
											<input type="text" class="form-control w20 onlynum ls fl mr5" id="total_project_detail_cost4_p" maxlength="3" disabled />
											<span class="fl mt5">%</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- //연구비 정보-->
						
						<!--제출서류-->
						<h4>제출서류</h4>
						<table class="write fixed documentssubmit">
							<caption>제출서류</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>	
							    <tr>
									<th scope="row">계획서</th>
								    <td>
										<div class="clearfix file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="upload_plan_file">
													<label class="custom-file-label custom-control-label-write-company" id="upload_plan_file_name" for="upload_plan_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>
									</td> 
							    </tr>																	       
								<tr>
									<th scope="row">협약서</th>
								    <td>
										<div class="clearfix file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="upload_agreement_file">
													<label class="custom-file-label custom-control-label-write-company" id="upload_agreement_file_name" for="upload_agreement_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>
									</td> 
								</tr>
								<tr>
								   <th scope="row">기타</th>											    
								   <td>
										<div class="clearfix file_form_txt">
											
										   <!--업로드 버튼-->
										    <div class="filebox2">
												<form id="frm" method="post" action="" enctype="multipart/form-data">
													<label for="file_upload">파일 선택</label>
													<input type="file" id="file_upload" multiple="" class="fl gray_btn2 mr5 hidden">
													<!-- 여기에 파일 목록 태그 추가 -->															
													<ul id="fileList" style="clear:both"></ul>
												</form>
										    </div>	
											<!--//업로드 버튼-->
									    </div>								
								   </td> 
								</tr>											
							</tbody>
				        </table>
						<!--//제출서류-->
						


						<div class="button_box clearfix fr pb20">
							
							<button type="button" class="blue_btn2 fl mr5 save_popup2_open" onclick="onRegistration('1');">임시저장</button>
							<button type="button" class="blue_btn fl mr5 agreement_send_popup_open">제출하기</button>
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/agreement/main'">목록</button>
						</div>
					</div>	<!--//table_area-->							
				</div><!--//content_area-->
				<!--//기관-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>
<!-- //container -->


<!--제출하기 팝업-->
<div class="agreement_send_popup_box">		
	<div class="popup_bg"></div>
	<div class="agreement_send_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">제출 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="popup_titlebox_txt">
				<p><span class="font_blue">[예]</span> 버튼을 누르면 제출이 완료되며, 수정은 불가능합니다.</p>							
				<p>제출 완료 후에는 제출완료 상태이며, 담당자가 제출서류를 확인하여 이상이 없을 경우, <br />
					완료될 예정입니다.</p>
				<p class="font_blue fz_b"><span class="fw500 font_blue">제출하시겠습니까?</span></p>
			</div>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5" onclick="onSubmitAgreemnt();">예</button>
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">아니요</button>
			</div>	
		</div>									
	</div> 
</div>
			<!--//제출하기 팝업-->

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
				<button type="button" class="blue_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>
