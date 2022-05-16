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

	});


	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/calculation/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("calculation_id", "${vo.calculation_id}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
		$("#reception_reg_number").html("<span>" + data.result_data.reception_reg_number + "</span>");
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#research_date").html("<span>" + data.result_data.research_date + "</span>");


		$("#support_fund").val(data.result_data.support_fund);
		$("#cash").val(data.result_data.cash);
		$("#hyeonmul").val(data.result_data.hyeonmul);
		$("#total_cost").val(data.result_data.total_cost);
		
		
		// 파일 이름
		$("#document_file_name").text(data.result_data.document_file_name);
		$("#report_file_name").text(data.result_data.report_file_name);


		// 연구비 상세 정보
		if ( data.result_data.fund_detail_list != null && data.result_data.fund_detail_list.length > 0) {
			$.each(data.result_data.fund_detail_list, function(key, value) {
				$("#fund_detail_body tr").each(function(){
					var tr = $(this);

					if (value.item_name == tr.attr("id")) {
						tr.find('input:eq(0)').val(value.item_plan);
						tr.find('input:eq(1)').val(value.item_excution);
						tr.find('input:eq(2)').val(value.item_balance);
						tr.find('input:eq(3)').val(value.item_total);
						return false;
					}
				});

			});
		}

		if ( gfn_isNull(data.result_data.calculation_status) != "미정산" ) {
			$("#btn_tempSave").hide();
			$("#btn_submitReport").hide();
		}
	}


	// 수행 내역 저장
	// '1'이면 임시저정 '2'이면 제출
	var finishRegistration = false;
	function onRegistration(type) {

		var formData = new FormData();
		formData.append("calculation_id", "${vo.calculation_id}");
		formData.append("support_fund", $("#support_fund").val());
		formData.append("cash", $("#cash").val());
		formData.append("hyeonmul", $("#hyeonmul").val());
		formData.append("total_cost", $("#total_cost").val());

		// 연구비 상세 정보
		var fundDetailList = new Array();
		$("#fund_detail_body tr").each(function(){
			var tr = $(this);
			var trObj = new Object();

			trObj.item_name = tr.attr("id");
			trObj.item_plan = tr.find('input:eq(0)').val();
			trObj.item_excution = tr.find('input:eq(1)').val();
			trObj.item_balance = tr.find('input:eq(2)').val();
			trObj.item_total = tr.find('input:eq(3)').val();
			
			fundDetailList.push(trObj);
		});
		// 연구비 상세 정보
		formData.append("fund_detail_list_json", JSON.stringify(fundDetailList));

		// 파일 정보
		if ( $("#document_file")[0].files[0] != null) {
			formData.append("document_file", $("#document_file")[0].files[0]);
		}
		if ( $("#report_file")[0].files[0] != null) {
			formData.append("report_file", $("#report_file")[0].files[0]);
		}
		

		$.ajax({
		    type : "POST",
		    url : "/member/api/calculation/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( type == '1') {
		        		showPopup("임시저장 되었습니다.", "임시저장 안내닫기");
		        		finishRegistration = true;
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

	// 수행 제출
	var finishSubmit = false;
	function onSubmitExecution() {
		// 협약서 저장
		if ( onRegistration('2') == false ) {
			showPopup("정산서 저출에 실패하였습니다.", "제출 안내닫기");
			return;
		}

		var formData = new FormData();
		formData.append("calculation_id", "${vo.calculation_id}");
		formData.append("calculation_status", "제출완료");
			
		$.ajax({
		    type : "POST",
		    url : "/member/api/calculation/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("정산 제출이 완료되었습니다.", "수행서 제출안내");
			    	finishSubmit = true;
			    } else {
			    	showPopup("정산 제출에 실패했습니다. 디시 시도해 주시기 바랍니다.", "수행서 제출안내");
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});

	}


	// 연구비 정보
	function onSumMoney(element, index) {
		$(element).val($(element).val().replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
		var name = $(element).attr("name");
		var plan = index + "_plan_total";
		var execution = index + "_execution_total";
		var janaeg = index + "_janaeg_total";
		var all = index + "_all_total";

		// 차액 , 총액
		var janaegAllMoney = Number($("#" + plan).val().replace(",", "")) - 
		                     Number($("#" + execution).val().replace(",", ""));
		$("#" + janaeg).val(  janaegAllMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")  );
		$("#" + all).val(  janaegAllMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")  );

		// 부분 금액 합계
		if ( index == "a" || index == "b") {
			var planMoney = Number($("#a_plan_total").val().replace(",", "")) + 
			                Number($("#b_plan_total").val().replace(",", ""));
			$("#ab_plan_total").val(planMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			var executionMoney = Number($("#a_execution_total").val().replace(",", "")) + 
			                     Number($("#b_execution_total").val().replace(",", ""));
			$("#ab_execution_total").val(executionMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			var janaegMoney = Number($("#a_janaeg_total").val().replace(",", "")) + 
			                  Number($("#b_janaeg_total").val().replace(",", ""));
			$("#ab_janaeg_total").val(janaegMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			var allMoney = Number($("#a_all_total").val().replace(",", "")) + 
						   Number($("#b_all_total").val().replace(",", ""));
			$("#ab_all_total").val(allMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		} else {
			var planMoney = Number($("#c_plan_total").val().replace(",", "")) + 
							Number($("#d_plan_total").val().replace(",", "")) +
							Number($("#e_plan_total").val().replace(",", "")) +
							Number($("#f_plan_total").val().replace(",", ""));
			$("#cdef_plan_total").val(planMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			var executionMoney = Number($("#c_execution_total").val().replace(",", "")) + 
								 Number($("#d_execution_total").val().replace(",", "")) +
							 	 Number($("#e_execution_total").val().replace(",", "")) +
								 Number($("#f_execution_total").val().replace(",", ""));
			$("#cdef_execution_total").val(executionMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			var janaegMoney = Number($("#c_janaeg_total").val().replace(",", "")) + 
							  Number($("#d_janaeg_total").val().replace(",", "")) +
						 	  Number($("#e_janaeg_total").val().replace(",", "")) +
							  Number($("#f_janaeg_total").val().replace(",", ""));
			$("#cdef_janaeg_total").val(janaegMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			var allMoney = Number($("#c_all_total").val().replace(",", "")) + 
						   Number($("#d_all_total").val().replace(",", "")) +
					 	   Number($("#e_all_total").val().replace(",", "")) +
						   Number($("#f_all_total").val().replace(",", ""));
			$("#cdef_all_total").val(allMoney.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		}

		// 전체 금액 합계
		var total = 0;
		$("input[name='" + name +"']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value.replace(",", "");
			}
			total += Number(tempValue);
	 	});

		var janaegTotal = 0;
		$("input[name='janaeg']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value.replace(",", "");
			}
			janaegTotal += Number(tempValue);
	 	});

		var allTotal = 0;
		$("input[name='all']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value.replace(",", "");
			}
			allTotal += Number(tempValue);
	 	});

		$("#ag_" + name + "_total").val(total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		$("#ag_janaeg_total").val(janaegTotal.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		$("#ag_all_total").val(allTotal.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	}
	
	
	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
 		if ( finishSubmit ) {
			$('.send_save_popup_box').fadeOut(350);
	    	location.href = "/member/fwd/calculation/main";
		}

 		if (finishRegistration) {
 			$('.send_save_popup_box').fadeOut(350);
	    	location.reload();
 		}

		
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}

</script>
            
<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>정산</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>정산</li>
						<li>정산</li>
					</ul>
				</div>
				
				
				<!--기관-->
				<div class="content_area copmpany_area execute_area" id="copmpany_area">													
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
									<th scope="row">접수번호</th>
								    <td id="reception_reg_number"></td> 
							    </tr>
								<tr>
									<th scope="row">과제번호</th>
								    <td id="agreement_reg_number"></td> 
							    </tr>
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
								    <th scope="row">협약기간</th>
								    <td id="research_date"></td> 
								</tr>											
							</tbody>
				        </table>
						<!--//과제 정보-->								    
						
						<!--연구비 정보-->									
						<h4 class="sub_title_h4">연구비 정보</h4>										
					    <table class="write fixed money">
							<caption>연구비 정보</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>		
							    <tr>
									<th scope="row">시지원금</th>
									<td><label for="support_fund" class="hidden">시지원금</label><input type="text" class="form-control w20 ls mb5 money fl mr5" id="support_fund" />
									<span class="fl mt10">(만원)</span></td> 
							    </tr>															       
							    <tr>
									<th scope="row">민간부담금 현금</th>
									<td><label for="cash" class="hidden">민간부담금 현금</label><input type="text" class="form-control w20 ls mb5 money fl mr5" id="cash" /><span class="fl mt10">(만원)</span></td>
								</tr>
								<tr>
									<th scope="row">민간부담금 현물</th>
									<td><label for="hyeonmul" class="hidden">민간부담금 현물</label><input type="text" class="form-control w20 ls mb5 money fl mr5" id="hyeonmul" /><span class="fl mt10">(만원)</span></td>
							    </tr>
								<tr>
									<th scope="row">총 사업비</th>
									<td><label for="total_cost" class="hidden">총 사업비</label><input type="text" class="form-control w20 ls mb5 money fl mr5" id="total_cost" /><span class="fl mt10">(만원)</span></td>
							    </tr>
								 
							</tbody>
						</table>
						<!--//연구비 정보-->									
						
						
						<!--연구비 상세정보-->
						<h4 class="sub_title_h4">연구비 상세 정보</h4>	
						<table class="write fixed money_detail list">
							<caption>연구비 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">비목</th>
									<th scope="col">계획</th>
									<th scope="col">집행</th>
									<th scope="col">잔액(자동계산)</th>
									<th scope="col">최종</th>
								</tr>
							</thead>
							<tbody id="fund_detail_body">											
								<tr id="ab">
								    <th scope="col" class="ta_c total">인건비(A+B)</th>
								    <td class="total"><label for="ab_plan_total" class="hidden">인건비 계획</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ab_plan_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="ab_execution_total" class="hidden">인건비 집행</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ab_execution_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="ab_janaeg_total" class="hidden">인건비 잔액(자동계산)</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ab_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="ab_all_total" class="hidden">인건비 최종</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ab_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
							    <tr id="a">
								    <th scope="row" class="ta_c">내부인건비(A)</th>
								    <td><label for="a_plan_total" class="hidden">내부인건비 계획</label><input type="text" name="plan" onkeyup="onSumMoney(this, 'a');" class="form-control w80 ls mb5 money fl mr5" id="a_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="a_execution_total" class="hidden">내부인건비 집행</label><input type="text" name="execution" onkeyup="onSumMoney(this, 'a');" class="form-control w80 ls mb5 money fl mr5" id="a_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="a_janaeg_total" class="hidden">내부인건비 잔액(자동계산)</label><input type="text" name="janaeg" class="form-control w80 ls mb5 money fl mr5" id="a_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td><label for="a_all_total" class="hidden">내부인건비 최종</label><input type="text" name="all" class="form-control w80 ls mb5 money fl mr5" id="a_all_total" disabled /><span class="fl mt10">(만원)</span></td>  
							    </tr>
								<tr id="b">
								    <th scope="row" class="ta_c">외부인건비(B)</th>
								    <td><label for="b_plan_total" class="hidden">외부인건비 계획</label><input type="text" name="plan" onkeyup="onSumMoney(this, 'b');" class="form-control w80 ls mb5 money fl mr5" id="b_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="b_execution_total" class="hidden">외부인건비 집행</label><input type="text" name="execution" onkeyup="onSumMoney(this, 'b');" class="form-control w80 ls mb5 money fl mr5" id="b_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="b_janaeg_total" class="hidden">외부인건비  잔액(자동계산)</label><input type="text" name="janaeg" class="form-control w80 ls mb5 money fl mr5" id="b_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td><label for="b_all_total" class="hidden">외부인건비 최종</label><input type="text" name="all" class="form-control w80 ls mb5 money fl mr5" id="b_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
								<tr id="cdef">
								    <th scope="col" class="ta_c total">경비(C+D+E+F)</th>
								    <td class="total"><label for="cdef_plan_total" class="hidden">경비 계획</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="cdef_plan_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="cdef_execution_total" class="hidden">경비 집행</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="cdef_execution_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="cdef_janaeg_total" class="hidden">경비  잔액(자동계산)</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="cdef_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="cdef_all_total" class="hidden">경비 최종</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="cdef_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
								<tr id="c">
								    <th scope="row" class="ta_c">연구장비/재료비(C)</th>
								    <td><label for="c_plan_total" class="hidden">연구장비/재료비 계획</label><input type="text" name="plan" onkeyup="onSumMoney(this, 'c');" class="form-control w80 ls mb5 money fl mr5" id="c_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="c_execution_total" class="hidden">연구장비/재료비 집행</label><input type="text" name="execution" onkeyup="onSumMoney(this, 'c');" class="form-control w80 ls mb5 money fl mr5" id="c_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="c_janaeg_total" class="hidden">연구장비/재료비  잔액(자동계산)</label><input type="text" name="janaeg" class="form-control w80 ls mb5 money fl mr5" id="c_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td><label for="c_all_total" class="hidden">연구장비/재료비 최종</label><input type="text" name="all" class="form-control w80 ls mb5 money fl mr5" id="c_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
								<tr id="d">
								    <th scope="row" class="ta_c">연구활동비(D)</th>
								    <td><label for="d_plan_total" class="hidden">연구활동비 계획</label><input type="text" name="plan" onkeyup="onSumMoney(this, 'd');" class="form-control w80 ls mb5 money fl mr5" id="d_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="d_execution_total" class="hidden">연구활동비 집행</label><input type="text" name="execution" onkeyup="onSumMoney(this, 'd');" class="form-control w80 ls mb5 money fl mr5" id="d_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="d_janaeg_total" class="hidden">연구활동비  잔액(자동계산)</label><input type="text" name="janaeg" class="form-control w80 ls mb5 money fl mr5" id="d_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td><label for="d_all_total" class="hidden">연구활동비 최종</label><input type="text" name="all" class="form-control w80 ls mb5 money fl mr5" id="d_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
								<tr id="e">
								    <th scope="row" class="ta_c">위탁사업비(E)</th>
								    <td><label for="e_plan_total" class="hidden">위탁사업비 계획</label><input type="text" name="plan" onkeyup="onSumMoney(this, 'e');" class="form-control w80 ls mb5 money fl mr5" id="e_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="e_execution_total" class="hidden">위탁사업비 집행</label><input type="text" name="execution" onkeyup="onSumMoney(this, 'e');" class="form-control w80 ls mb5 money fl mr5" id="e_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="e_janaeg_total" class="hidden">위탁사업비 잔액(자동계산)</label><input type="text" name="janaeg" class="form-control w80 ls mb5 money fl mr5" id="e_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td><label for="e_all_total" class="hidden">위탁사업비 최종</label><input type="text" name="all" class="form-control w80 ls mb5 money fl mr5" id="e_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
								<tr id="f">
								    <th scope="row" class="ta_c">성과장려비(F)</th>
								    <td><label for="f_plan_total" class="hidden">성과장려비 계획</label><input type="text" name="plan" onkeyup="onSumMoney(this, 'f');" class="form-control w80 ls mb5 money fl mr5" id="f_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="f_execution_total" class="hidden">성과장려비 집행</label><input type="text" name="execution" onkeyup="onSumMoney(this, 'f');" class="form-control w80 ls mb5 money fl mr5" id="f_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td><label for="f_janaeg_total" class="hidden">성과장려비  잔액(자동계산)</label><input type="text" name="janaeg" class="form-control w80 ls mb5 money fl mr5" id="f_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td><label for="f_all_total" class="hidden">성과장려비 최종</label><input type="text" name="all" class="form-control w80 ls mb5 money fl mr5" id="f_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
								<tr id="g">
								    <th scope="col" class="ta_c total">간접비(G)</th>
								    <td class="total"><label for="g_plan_total" class="hidden">간접비 계획</label><input name="plan" onkeyup="onSumMoney(this, 'g');"  type="text" class="form-control w80 ls mb5 money fl mr5" id="g_plan_total" /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="g_execution_total" class="hidden">간접비 집행</label><input name="execution" onkeyup="onSumMoney(this, 'g');" type="text" class="form-control w80 ls mb5 money fl mr5" id="g_execution_total" /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="g_janaeg_total" class="hidden">간접비  잔액(자동계산)</label><input name="janaeg" type="text" class="form-control w80 ls mb5 money fl mr5" id="g_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total"><label for="g_all_total" class="hidden">간접비 최종</label><input name="all" type="text" class="form-control w80 ls mb5 money fl mr5" id="g_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>
							    <tr id="abcdefg">
								    <th scope="col" class="ta_c total_all">합계(A+B+C+D+E+F+G)</th>
								    <td class="total_all"><label for="ag_plan_total" class="hidden">합계 집행</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ag_plan_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total_all"><label for="ag_execution_total" class="hidden">합계 계획</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ag_execution_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total_all"><label for="ag_janaeg_total" class="hidden">합계  잔액(자동계산)</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ag_janaeg_total" disabled /><span class="fl mt10">(만원)</span></td> 
									<td class="total_all"><label for="ag_all_total" class="hidden">합계 최종</label><input type="text" class="form-control w80 ls mb5 money fl mr5" id="ag_all_total" disabled /><span class="fl mt10">(만원)</span></td> 
							    </tr>	
							</tbody>	
						</table>
						<!--//연구비 상세정보-->
						
						<!--정산서류-->
						<h4 class="sub_title_h4">정산서류</h4>
						<table class="write fixed">
							<caption>정산서류</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>		
							    <tr>
									<th scope="row">정산서류</th>
									<td>										
										<div class="clearfix file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="document_file">
													<label id="document_file_name" class="custom-file-label custom-control-label-write-company" for="document_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>			
									</td> 
							    </tr>															       
							    <tr>
									<th scope="row">정산보고서</th>
									<td>										
										<div class="file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="report_file">
													<label id="report_file_name" class="custom-file-label custom-control-label-write-company" for="report_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>			
									</td> 
							    </tr>											
							</tbody>
						</table>
						<!--//정산서류-->

						<div class="button_box clearfix fr pb20">
							
							<button id="btn_tempSave" type="button" class="blue_btn2 fl mr5" onclick="onRegistration('1');">임시저장</button>
							<button id="btn_submitReport" type="button" class="blue_btn fl mr5 agreement_send_popup_open">제출하기</button>
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/calculation/main'">목록</button>
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
				<button type="submit" class="blue_btn mr5" onclick="onSubmitExecution();">예</button>
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