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
			searchMemberDetail();
			searchCommissionerDetail();
			searchCommissionerDetail2();
		});

		function searchMemberDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/member/api/mypage/detail");
			comAjax.setCallback(getMemberDetailCB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.ajax();
		}

		function getMemberDetailCB(data){
			$("#name").html("<span>" + data.result.name + "</span>") ;
			$("#mobile_phone").html(data.result.mobile_phone) ;
			$("#email").html(data.result.email) ;
			$("#address").html(data.result.address + " " + data.result.address_detail) ;
		}

		function searchCommissionerDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/commissioner/detail");
			comAjax.setCallback(searchCommissionerDetailCB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.ajax();
		}

		function searchCommissionerDetailCB(data){
			console.log(data);
			$("#bank_name").html("<span class='fl'>" + data.result_data.bank_name + "</span><span class='fl'>은행</span>") ;
			$("#bank_number").html("<span>" + data.result_data.bank_account + "</span>") ;
		}

		
	
		function searchCommissionerDetail2() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/commissioner/api/evaluation/commissioner/detail2");
			comAjax.setCallback(searchCommissionerDetail2CB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.addParam("evaluation_id", $("#evaluation_id").val());
			comAjax.ajax();
		}
	
		var memberInfo;
		function searchCommissionerDetail2CB(data){
			var str = "<span>서명</span>";
			//"<img class='field-lecture-detail-instructor-profile-image' src='data:image/gif;base64," + data.result_data.security_declaration_sign +"'  width='134px' height='134px' alt=''>"
			str += "<img src='" + data.result_data.payment_declaration_sign + "' alt='서명이미지'>";
			$("#image_area").empty();
			$("#image_area").html(str);
		}
	
	</script>
	  
	  
	<body>		
		<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />
		<input type="hidden" id="evaluation_id" name="evaluation_id" value="${vo.evaluation_id}" />	
		<div id="receipt_preview">
			<div class="wrap_area">
				<h1>지급 청구서</h1>
				<div class="txt">
					<table class="write fixed list2">
						<caption>평가위원회 지급청구서</caption>
						<colgroup>
							<col style="width: 30%;">
							<col style="width: 70%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">성명</th>
								<td id="name"><span>홍길동</span></td> 
							</tr>									  
							<tr>
								<th scope="row">휴대전화</th>
								<td id="mobile_phone"></td> 
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td id="email"></td> 
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td id="address"></td> 
							</tr>
							<tr>
								<th scope="row">은행명</th>
								<td id="bank_name">
						
								</td> 
							</tr>
							<tr>
								<th scope="row">계좌번호</th>
								<td id="bank_number">
								</td> 
							</tr>
						</tbody>
					</table>	
					<!--사인-->	
					<!--<div class="sign claerfix" style="margin-top: 40px;">													
						 <div class="sign claerfix">															
							 <div class="sigPad claerfix" id="linear4" style="width:304px">														
								<div class="clearButton">
									<a href="#clear" class="clear_btn hide_print">지우기</a>
								</div>						
								<div class="sign sigWrapper" style="height:auto;">										
									<canvas class="pad" width="300" height="80"></canvas>	
									
									<span class="sign_txt2">서명</span>
								</div>
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
		</div>
		
		<script src="/assets/admin/js/script.js"></script>
		
	</body>
</html>
