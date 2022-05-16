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
			searchCommissionerDetail();
		});
	
		function searchCommissionerDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/commissioner/detail2");
			comAjax.setCallback(searchCommissionerDetailCB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.addParam("evaluation_id", $("#evaluation_id").val());
			comAjax.ajax();
		}
	
		var memberInfo;
		function searchCommissionerDetailCB(data){
			console.log(data);
			var str = "<span>서명</span>";
			//"<img class='field-lecture-detail-instructor-profile-image' src='data:image/gif;base64," + data.result_data.security_declaration_sign +"'  width='134px' height='134px' alt=''>"
			str += "<img src='" + data.result_data.security_declaration_sign + "' alt='서명이미지'>";
			$("#image_area").empty();
			$("#image_area").html(str);
		}
	
	</script>
	  
	  
	<body>		
		<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />
		<input type="hidden" id="evaluation_id" name="evaluation_id" value="${vo.evaluation_id}" />	
		<div id="security_wrap">
			<div class="wrap_area">				
				<div class="security_popup_box">
					<h1>보안 서약서</h1>
					<div class="txt">
						<ol>
							<li><p>① 사업에 대한 평가를 수행하는 과정에서 습득한 기술기밀에 대해 사업수행 중은 물론 종료후에도 서울기술연구원장의 허락없이 자신 또는 제 3자를 위해서 사용하지 않는다.</p><span class="fw_b ta_r"><input type="checkbox" id="security_of_service1" name="security_of_service1" value="동의" checked disabled /><label for="security_of_service1">상기 내용을 확인하고 동의합니다.</label></span>
							</li>
							<li><p>② 사업의 내용 또는 추진성과가 적법하게 공개된 경우라 하여도 미공개 부분에 대하여 1항과 같은 비밀유지 의무를 부담한다.</p>
								 <span class="fw_b ta_r"><input type="checkbox" id="security_of_service2" name="security_of_service2" value="동의" checked disabled /><label for="security_of_service2">상기 내용을 확인하고 동의합니다.</label></span></li>
							<li><p>③ 위의 사항을 본인이 준수하지 않아 발생하는 제반사항에 대해 필요한 책임을 부담한다.</p>
								 <span class="fw_b ta_r"><input type="checkbox" id="security_of_service3" name="security_of_service3" value="동의" checked disabled /><label for="security_of_service3">상기 내용을 확인하고 동의합니다.</label></span>
							</li>
						</ol>	
						<!--사인-->
						<!--<div class="sign clearfix">														
							<div class="sigPad clearfix" id="linear3" style="width:304px">											
								<!--<div class="clearButton">
									<a href="#clear" class="clear_btn hide_print">지우기</a>
								</div>						
								<div class="sign sigWrapper" style="height:auto;">										
									<canvas class="pad" width="300" height="80"></canvas>	
									
									<span class="sign_txt2">서명</span>
								</div>
							</div>						
						</div>	-->	
						
						<div class="sign_img_area clearfix">
							<div class="sign_img fr" id="image_area">
							</div>
						</div>
						<!--//사인-->
					</div>					
				</div>
				<div class="bottom">
						<div class="day">						
							<span style="display:inline-block;"  class="clearfix"><span class="fl">2021</span><span class="fl mr10">년</span><span class="fl">09</span><span class="fl mr10">월</span><span class="fl">20</span><span class="fl">일</span></span>							
						</div>

						<div class="sit_leader">
							<p>서울기술연구원장 귀하</p>
						</div>
					</div>
			</div>
		</div>
		
		<script src="/assets/admin/js/script.js"></script>
		
	</body>
</html>
