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
 		<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.debug.js"></script>
	  </head>
	  
	  
	<script type='text/javascript'>
		$(document).ready(function() {
			searchChoicedCommissionerList(1);
			searchCommissionerList();
			searchDetail();
		});

		// 평가 내용 상세		
		function searchDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/admin/api/evaluation/match/search/detail");
			comAjax.addParam("evaluation_id", $("#evaluation_id").val());
			comAjax.setCallback(searchDetailCB);
			comAjax.ajax();
		}
		var evaluationDetail;
		function searchDetailCB(data) {
			$("#reception_id").html("<span>" + data.result_data.reception_id + "</span>");
			$("#evaluation_reg_number").html("<span>" + data.result_data.evaluation_reg_number + "</span>");
			$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
			$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
			$("#institution_name").html("<span>" + data.result_data.institution_name + "</span>");
			$("#member_name").html("<span>" + data.result_data.member_name + "</span>");
			$("#classification_name").html("<span>" + data.result_data.classification_name + "</span>");
			$("#type_name").html("<span>" + data.result_data.type_name + "</span>");
			$("#status_name").html("<span>" + data.result_data.status_name + "</span>");
			$("#steward_department").html("<span>" + data.result_data.steward_department + "</span>");
			$("#steward").html("<span>" + data.result_data.steward + "</span>");
			$("#evaluation_date").html("<span>" + data.result_data.evaluation_date + "</span>");
			$("#manager_point").val(data.result_data.manager_point);

			$("#guide_file_name").val(data.result_data.guide_file_name);
			$("#result_file_name").val(data.result_data.result_file_name);
				
			evaluationDetail = data.result_data;
		}

		// 평가 위원 검색
		function searchChoicedCommissionerList(pageNo) {
			var comAjax = new ComAjax();
			comAjax.setUrl("/admin/api/evaluation/match/commissioner/search/pagingRelatedId");
			// 20개씩 검색
			comAjax.addParam("choice_yn", "y");
			comAjax.addParam("evaluation_id", $("#evaluation_id").val());
			comAjax.addParam("page_row_count", "20");
			comAjax.setCallback(serarchChoicedCommissionerListCB);
			comAjax.addParam("pageIndex", pageNo);
			comAjax.addParam("orderby", "CHAIRMAN_YN DESC");
			comAjax.ajax();
		}
		function serarchChoicedCommissionerListCB(data) {
			$.each(data.result_data, function(key, value) {
				// 평가위원장의 평가 결과를 찾는다.
				if (value.chairman_yn == "Y") {
					$("#final_result").html("<span class='font_blue'>" + value.chairman_result + "</span>");
					$("#chairman_comment").text(value.chairman_comment);

					var str = "<span>서명</span>";
					str += "<img src='" + value.chairman_sign + "' alt='서명이미지'>";
					$("#image_area").empty();
					$("#image_area").html(str);
				}
			});
		}

		// 해당 평가에 선정된 평가위원 정보 검색(평가내용 포함)
		function searchCommissionerList() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/search/relatedCommissionerList");
			comAjax.addParam("evaluation_id","${vo.evaluation_id}");
			comAjax.addParam("choice_yn","Y");
			comAjax.setCallback(searchCommissionerListCB);
			comAjax.ajax();
		}

		var isAllEvaluationCompleted = true;
		function searchCommissionerListCB(data){
			console.log(data);
			var body = $("#commissioner_evaluation_list");
			body.empty();
			
			var str = "";	
			var evaluationItemCount = 0;
			var sumTotalPoint = 0;
			$("#commissioner_count").html("<span>평가위원</span><span>(" + data.result_data.length + "명)</span>");
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'><span>" + value.member_name + "</span></td>";

				// 평가서가 완료된 평가위원 정보만 업데이트 한다.
				if ( value.evaluation_report_yn == "Y") {
					var totalPoint = 0;
					var index = 1;
					
					evaluationItemCount = value.commissioner_item_result_list.length;
					// 평가 점수 입력
					$.each(value.commissioner_item_result_list, function(key2, value2) {
						str += "<td class='evaluation_item_" + index + "'><span>" + value2.item_result + "</span></td>";
						totalPoint += Number(value2.item_result);
						index++;
					});

					// 현재 10까지만 입력 가능. 평가점수가 있는 것은 평가 점수를 입력하고 나머지 없는 것은 공백으로 한다.
					for (var i=0; i<(10-value.commissioner_item_result_list.length); i++) {
						str += "<td><span>&nbsp;</span></td>"; 
					}
					sumTotalPoint += Number(totalPoint);
					str += "<td class='result_sum td_c'><span>" + totalPoint + "</span></td>";
					str += "<td class='last'>";
					str += "	<div class='sign_annex'>";
					str += "		<img src='" + value.evaluation_report_declaration_sign + "' alt='서명이미지' class='d_n sign_load' />";
					str += "	</div>";
					str += "</td>";
																			
				} else {
					isAllEvaluationCompleted = false;
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td><span>&nbsp;</span></td>";
					str += "<td class='result_sum td_c'><span>&nbsp;</span></td>";
					str += "<td class='last'>평가서 미제출</td>";
				}
				
				str += "</tr>";
			});

			body.append(str);

			// 최고 점수
			str += "<tr>";
			str += "	<td class='first td_c2'><span class='fw_b'>최고점수</span></td>";
			// 최고 점수를 찾는다.
			var totalHighPoint = 0;
			for (var i=0; i<evaluationItemCount; i++) {
				var highPoint = 0;
				$(".evaluation_item_" + (i+1)).each(function(){
					if ( Number($(this).text()) >= Number(highPoint)) {
						highPoint = Number($(this).text());
					}
				});

				str += "<td class='td_c'><span>" + highPoint + "</span></td>";
				totalHighPoint += Number(highPoint); 
			}
			// 현재 10까지만 입력 가능. 평가점수가 있는 것은 평가 점수를 입력하고 나머지 없는 것은 공백으로 한다.
			for (var i=0; i<(10-evaluationItemCount); i++) {
				str += "<td class='td_c'><span>&nbsp;</span></td>"; 
			}

			if ( totalHighPoint > 0) {
				str += "<td class='result_sum td_c'><span>" + totalHighPoint + "</span></td>"; 
			} else {
				str += "<td class='result_sum td_c'><span>&nbsp;</span></td>"; 
			}
			str += "	<td class='last'><span>&nbsp;</span></td>"; 
			str += "</tr>";


			// 최저 점수
			str += "<tr>";
			str += "	<td class='first td_c2'><span class='fw_b'>최저점수</span></td>";
			// 최저 점수를 찾는다.
			var totalLowPoint = 0;
			for (var i=0; i<evaluationItemCount; i++) {
				var lowPoint = 0;
				var isFirst = true;
				$(".evaluation_item_" + (i+1)).each(function(){
					if ( isFirst ) {
						lowPoint = Number($(this).text());
						isFirst = false; 
					} else {
						if ( Number($(this).text()) <= Number(lowPoint)) {
							lowPoint = Number($(this).text());
						}
					}
				});

				str += "<td class='td_c'><span>" + lowPoint + "</span></td>";
				totalLowPoint += Number(lowPoint); 
			}
			// 현재 10까지만 입력 가능. 평가점수가 있는 것은 평가 점수를 입력하고 나머지 없는 것은 공백으로 한다.
			for (var i=0; i<(10-evaluationItemCount); i++) {
				str += "<td class='td_c'><span>&nbsp;</span></td>"; 
			}

			if ( totalLowPoint > 0) {
				str += "<td class='result_sum td_c'><span>" + totalLowPoint + "</span></td>"; 
			} else {
				str += "<td class='result_sum td_c'><span>&nbsp;</span></td>"; 
			}
			str += "	<td class='last'><span>&nbsp;</span></td>"; 
			str += "</tr>";

			// 합계
			str += "<tr>";
			str += "	<td class='first td_c2' colspan='11'><span class='fw_b'>합계</span></td>";
			if ( sumTotalPoint != 0) {
				str += "	<td class='last sum_result td_c' colspan='2'><span>" + sumTotalPoint + "</span></td>";
			} else {
				str += "	<td class='last sum_result td_c' colspan='2'><span>&nbsp;</span></td>";
			}
			str += "</tr>";

			//최종합계
			str += "<tr>";
			str += "	<td class='first td_c2' colspan='11'><span class='fw_b'>최종합계<span class='fw_b'>(합계-최고점수-최저점수)</span></span></td>";
			var finalTotalPoint = sumTotalPoint - totalHighPoint - totalLowPoint;
			str += "	<td class='last sum_result td_c' colspan='2'><span>" + finalTotalPoint + "</span></td>";
			str += "</tr>";

			//최종평균
			str += "<tr>";
			str += "	<td class='first td_c2' colspan='11'><span class='fw_b'>최종평균<span class='fw_b'>((합계-최고점수-최저점수)/(N명)</span></span></td>";
			var finalAvg = finalTotalPoint / data.result_data.length;
			str += "	<td class='last sum_result td_c' colspan='2'><span>" + finalAvg + "</span></td>";
			str += "</tr>";

			//간사 입력
			str += "<tr>";
			str += "	<td colspan='2' class='td_c2 fw_b'>가점 입력(간사입력)</td>";
			str += "	<td colspan='9'>";
			str += "		<div class='ta_r'>";
			str += "			<input type='text' id='manager_point' class='form-control w10 ls number_t'  maxlength='3'>";
			str += "			<label for='plus_write'>점</label>";
			str += "		</div>";
			str += "	</td>";
			str += "	<td class='last total_score' colspan='2'>";
			str += "		<span class='mr5'>&nbsp;</span>";
			str += "	</td>";
			str += "</tr>";
			
			body.empty();
			body.append(str);
		}


		function convertPDF(){
			html2canvas($('#rating_leader_wrap')[0]).then(function(canvas) {
	          	var imgData = canvas.toDataURL('image/png');

	          	var imgWidth = 190; // 이미지 가로 길이(mm) / A4 기준 210mm
				var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
				var imgHeight = canvas.height * imgWidth / canvas.width;
				var heightLeft = imgHeight;
				var margin = 10; // 출력 페이지 여백설정
				var doc = new jsPDF('p', 'mm');
				var position = 0;

				doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight );
				
				heightLeft -= pageHeight;
  				// 한 페이지 이상일 경우 루프 돌면서 출력
				while (heightLeft >= 20) {
				    position = heightLeft - imgHeight;
				    doc.addPage();
				    doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
				    heightLeft -= pageHeight;
				} 

				 // 파일 저장
			    doc.save("종합평가서_" + evaluationDetail.evaluation_reg_number + ".pdf");
		          
/* 		          var imgWidth = 210;
		          var pageHeight = imgWidth * 1.414;
		          var imgHeight = canvas.height * imgWidth / canvas.width;

		          var doc = new jsPDF({
		            'orientation': 'p',
		            'unit': 'mm',
		            'format': 'a4'
		          });

		          doc.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
		          doc.save('sample_A4.pdf'); */
			 });
		}
		
	</script>
		
	<body id="doc_body">		
		<input type="hidden" id="evaluation_id" name="evaluation_id" value="${vo.evaluation_id}" />	
		<div>		
			<div class="wrap_area" id="rating_leader_wrap">
				<div class="table_area rating_result_tabel_area"  style="display: block;">
					<!--개별평가-->
					<table class="list2 write fixed table_rating">
						<caption>평가서 구분</caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>
						<tbody>	
							<tr>
								<th scope="row">평가서 구분</th>
								<td><span>종합평가서</span></td>
							</tr>														  
							<tr>
								<th scope="row">접수번호</th>
								<td id="reception_id"></td>
							</tr>									  
							<tr>
								<th scope="row">과제번호</th>
								<td id="evaluation_reg_number"></td>
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

					<!--종합 점수-->					
					<div class="view_top_area clearfix">
						<h4 class="fl sub_title_h4">종합 점수</h4>
					</div>
					<table class="list ruselt_score">
						<caption>종합 점수</caption>
						<colgroup>
							<col style="width:10%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:6%" />
							<col style="width:10%" />	
							<col style="width:10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col" rowspan="2" class="first" id="commissioner_count"></th>	
								<th scope="col" colspan="11">평가 점수 및 구분</th>												
								<th scope="col" rowspan="2">서명</th>
							</tr>										
							<tr>
								<th scope="col">A</th>
								<th scope="col">B</th>
								<th scope="col">C</th>
								<th scope="col">D</th>
								<th scope="col">E</th>
								<th scope="col">F</th>
								<th scope="col">G</th>
								<th scope="col">H</th>
								<th scope="col">I</th>
								<th scope="col">J</th>												
								<th scope="col">점수</th>
							</tr>
						</thead>
						<tbody id="commissioner_evaluation_list">
						</tbody>
						<tfoot>											
							<tr>
								<td class="ta_c" colspan="2">최종결과</td>												
								<td class="last total_score ta_c" colspan="11" id="final_result">													
									<span class="font_blue">적합</span>													
								</td>		
							</tr>
						</tfoot>
					</table>		
					<!--//평가 의견 항목-->	

					<!--의결 사항-->
					<table class="write fixed mt30 list2 opinion">
						<caption>의결 사항</caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">의결 결과 및 종합의견</th>
								<td class="ta_l" id="chairman_comment"></td>	
							</tr>											
						</tbody>
					</table>
					<!--//의결 사항-->	
					
					<div class="txt">
						<!--사인-->
						<!--<div class="sign claerfix mt30">														
							<div class="sigPad claerfix" id="linear3" style="width:304px">												
								<div class="clearButton mb5 hide_print" style="height: 30px;">
									<a href="#clear" class="clear_btn">지우기</a>
								</div>								
								<div class="sign sigWrapper" style="height:auto;border: 1px solid #d1d1d1;">										
									<canvas class="pad" width="300" height="80"></canvas>										
									<span class="sign_txt2">서명</span>
								</div>
							</div>							
						</div>-->
						
						<div class="sign_img_area clearfix">
							<div class="sign_img fr" id="image_area">
								<span>서명</span>
								<img src="../images/sign.jpg" alt="서명이미지" />
							</div>
						</div>
						<!--//사인-->
					</div>
				</div>
			</div>
			
			<!--//평가 점수 항목-->								
			<div class="button_box clearfix fr pb20 list_btn hide_print">												
				<button type="submit" class="blue_btn fl mr5" onclick="convertPDF();">PDF변환하기</button>		
				<button type="button" class="gray_btn fl" onClick="self.close();">닫기</button>
			</div>
				
		</div>
		<!-- //wrap -->
		
		<script src="/assets/admin/js/script.js"></script>
	</body>
		
</html>
