<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="ie=edge" />
		<meta name="description" content="신기술접수소 사업평가관리시스템" />
		<meta name="keywords" content="신기술 접수소, 서울 신기술 사업평가관리" />
		<meta property="og:type" content="website" />
		<meta property="og:title" content="신기술접수소 사업평가관리시스템 관리자사이트" />
		<meta property="og:description" content="신기술접수소 사업평가관리시스템 관리자사이트" />
		<title>신기술접수소 사업평가관리시스템</title>		
		<link rel="stylesheet" href="/assets/admin/css/style.css" />
		<link rel="stylesheet" href="/assets/admin/css/lib/solid.min.css" />
		<link rel="stylesheet" href="/assets/admin/css/lib/jquery-ui.min.css" />
		<script src="/assets/admin/js/lib/jquery-1.11.0.min.js"></script>
		<script src="/assets/admin/js/lib/all.min.js"></script>		
		<script src="/assets/admin/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/admin/js/lib/jquery-ui.js"></script>
		<script src="/assets/admin/js/common_anchordata.js"></script>
		<script src="/assets/admin/js/paging.js"></script>
		<script src="/assets/admin/js/script.js"></script>
	  </head>
	  
	  
	<script type='text/javascript'>
		$(document).ready(function() {
			searchEvaluationDetail();
			searchEvaluationResultItemDetail();
			searchEvaluationItemDetail();
			
			searchCommissionerDetail2();
		});


		// 평가 상세 조회
		function searchEvaluationDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/detail");
			comAjax.addParam("evaluation_id", $("#evaluation_id").val());
			comAjax.setCallback(searchEvaluationDetailCB);
			comAjax.ajax();
		}
		var evaluationInfo;
		function searchEvaluationDetailCB(data){
			evaluationInfo = data.result_data;
		 	$("#reception_id").text(evaluationInfo.reception_id);
		 	$("#tech_info_name").text(evaluationInfo.tech_info_name);
		 	$("#institution_name").text(evaluationInfo.institution_name);
		 	$("#steward").text(evaluationInfo.steward);
		 	$("#evaluation_date").text(evaluationInfo.evaluation_date);
		}

		// 평가위원이 평가한 평가 항목이 있는지 검색
		function searchEvaluationResultItemDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/resultItem/detail");
			comAjax.addParam("member_id",$("#member_id").val());
			comAjax.addParam("evaluation_id",$("#evaluation_id").val());
			comAjax.setCallback(searchEvaluationResultItemDetailCB);
			comAjax.ajax();
		}
		var evaluationResultItemInfo = null;
		function searchEvaluationResultItemDetailCB(data){
			evaluationResultItemInfo = data.result_data;
		}
		
		// 평가항목 검색
		function searchEvaluationItemDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/item/detail");
			comAjax.addParam("evaluation_id",$("#evaluation_id").val());
			comAjax.setCallback(searchEvaluationItemDetailCB);
			comAjax.ajax();
		}
		function searchEvaluationItemDetailCB(data){
			var evaluationItemInfo = data.result_data;
			var body = $("#evaluation_item_body");
			body.empty();

			var str = "";
			var pointIndex = 1;
			var totalLimitPoint = 0;
			var totalInputPoint = 0;
			$.each(evaluationItemInfo, function(index, item){ 
				if ( item.item_releated_list != null && item.item_releated_list.length > 0) {
					$.each(item.item_releated_list, function(index2, item2){
						if ( item2.item_form_detail_info_list != null && item2.item_form_detail_info_list.length > 0) {
							$.each(item2.item_form_detail_info_list, function(index3, item3){
								totalLimitPoint = totalLimitPoint + Number(item3.form_item_result);
								str += "<tr item_id='" + item3.item_id + "'>";
								if (index3 == 0 ) {
									str += "<td class='first last rating_item' rowspan='" +item2.item_form_detail_info_list.length  + "'><span>" + item2.form_item_name + "</span></td>";
								}
								str += "	<td class='first rating_indicators'>" + item3.form_item_detail_name + "</td>";
								str += "	<td class='sum_cell_1' id='limit_point_" + pointIndex + "'>" + item3.form_item_result +"</td>";

								var inputPoint = 0;
								if (evaluationResultItemInfo != null && evaluationResultItemInfo.item_result_info_list !=null && evaluationResultItemInfo.item_result_info_list.length > 0){
									$.each(evaluationResultItemInfo.item_result_info_list, function(index4, item4){
										if ( item4.item_id == item3.item_id ) {
											inputPoint = item4.item_result;
											totalInputPoint = Number(totalInputPoint) + Number(inputPoint);
											return false;
										}
									});
								}
								str += "	<td class='sum_cell_2'><span class='ls'>" + inputPoint + "</span></td>";
								str += "</tr>";
								pointIndex++;
							});
						}
					});
				}
			});

			body.append(str);
			$("#total_limit_point").html("<span>" + totalLimitPoint + " 점</span>");
			$("#total_input_point").html(totalInputPoint + " 점");
		}

		function searchCommissionerDetail2() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/commissioner/detail2");
			comAjax.setCallback(searchCommissionerDetail2CB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.addParam("evaluation_id", $("#evaluation_id").val());
			comAjax.ajax();
		}
	
		function searchCommissionerDetail2CB(data){
			var str = "<span>서명</span>";
			//"<img class='field-lecture-detail-instructor-profile-image' src='data:image/gif;base64," + data.result_data.security_declaration_sign +"'  width='134px' height='134px' alt=''>"
			str += "<img src='" + data.result_data.evaluation_report_declaration_sign + "' alt='서명이미지'>";
			$("#image_area").empty();
			$("#image_area").html(str);
		}
	
	</script>
	  
	  
	<body>		
		<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />
		<input type="hidden" id="evaluation_id" name="evaluation_id" value="${vo.evaluation_id}" />	
		<div id="rating_leader_wrap">
			<div class="wrap_area">
				<div class="table_area rating_result_tabel_area" style="display: block;">
					<!--개별평가-->
					<table class="list2 write fixed table_rating">
						<caption>평가서 구분</caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>	
						<thead>
							<tr>
								<th scope="row">평가서 구분</th>
								<td><span>개별평가서</span></td>
							</tr>						
														  
							<tr>
								<th scope="row">접수번호</th>
								<td id="reception_id"></td>
							</tr>
							<tr>
								<th scope="row">기술명</th>
								<td id="tech_info_name"></td>
							</tr>
							<tr>
								<th scope="row">기관명</th>
								<td id="institution_name"></td>												
							</tr>
							<tr>
								<th scope="row">검토자/평가자</th>
								<td id="steward"></td>	
							</tr>
							<tr>
								<th scope="row">평가일</th>
								<td id="evaluation_date"></td>	
							</tr>
						</tbody>
					</table>								
					<!--//개별평가-->
				
					<!--평가 점수 항목-->
					<div class="view_top_area clearfix">
						<h4 class="fl sub_title_h4">평가 점수 항목</h4>
					</div>												
					<table class="list fixed score_tabel">
						<caption>평가 점수 항목</caption>
						<colgroup>
							<col style="width:22%" />
							<col style="width:48%" />
							<col style="width:15%" />
							<col style="width:15%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">평가항목(배점)</th>
								<th scope="col">평가지표</th>	
								<th scope="col">배점</th>
								<th scope="col">점수</th>
							</tr>
						</thead>
						<tbody id="evaluation_item_body">
						</tbody>
						<tfoot>
							<tr>												
								<td class="sum_all_title ta_c fw_b" colspan="2" >합계</td>
								<td class="all_sum_cell_1 sum_all_title ta_c" id="total_limit_point"></td>	
								<td class="all_sum_cell_2 sum_all_title ta_c" id="total_input_point"></td>					
							</tr>
						</tfoot>
					</table>	
					<!--사인-->
					<!--<div class="txt">
						<div class="sign claerfix mt30">														
							<div class="sigPad claerfix" id="linear3" style="width:304px">												
								<!--<div class="clearButton mb5 hide_print" style="height: 30px;">
									<a href="#clear" class="clear_btn">지우기</a>
								</div>								
								<div class="sign sigWrapper" style="height:auto;border: 1px solid #d1d1d1;">										
									<canvas class="pad" width="300" height="80"></canvas>	
									
									<span class="sign_txt2">서명</span>
								</div>
							</div>								
						</div>
					</div>-->
					
					<div class="sign_img_area clearfix mb30">
						<div class="sign_img fr" id="image_area">
							<span>서명</span>
							<img src="../images/sign.jpg" alt="서명이미지" />
						</div>
					</div>
					<!--//사인-->

					<!--//평가 점수 항목-->								
					<!--<div class="button_box clearfix pb20 fr list_btn hide_print">											
						<button type="button" class="blue_btn fl mr5 rating_send_ok_btn">제출하기</button>		
						<button type="button" class="gray_btn fl" onClick="self.close();">닫기</button>
					</div>-->
				</div>
			</div>
		</div>
		<!-- //wrap -->
		
		<script src="/assets/admin/js/script.js"></script>
		
	</body>
		
</html>
