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
			searchInstitutionDetail();
			searchDetail();		
		});
	
		function searchMemberDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/member/api/mypage/detail");
			comAjax.setCallback(getMemberDetailCB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.ajax();
		}
	
		var memberInfo;
		function getMemberDetailCB(data){
			memberInfo = data.result;
			$("#name").html("<span>" + data.result.name + "</span>") ;
			$("#mobile_phone").html(data.result.mobile_phone) ;
			$("#email").html(data.result.email) ;
			$("#address").html(data.result.address + " " + data.result.address_detail) ;
		}
	
		function searchInstitutionDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/member/api/mypage/institution/detail");
			comAjax.setCallback(getInstitutionDetailCB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.ajax();
		}
		
		function getInstitutionDetailCB(data){
			$("#institution_type").html("<span>" + data.result.type_name + "</span>");
			$("#institution_name").html("<span>" + data.result.name +" </span>");
			$("#institution_address").html("<span class='fl'>" + data.result.address +"</span> <span class='fl ls'>" + data.result.address_detail + "</span>");
			$("#institution_phone").html("<span>" + data.result.phone + "</span>");
			$("#institution_depart").html("<span>" + memberInfo.department + "</span>");
			$("#institution_position").html("<span>" + memberInfo.position + "</span>");
		}
	
		
		function searchDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("/admin/api/member/commissioner/detail");
			comAjax.setCallback(searchDetailCB);
			comAjax.addParam("member_id", $("#member_id").val());
			comAjax.ajax();
		}
		
		function searchDetailCB(data){
			$("#bank_name").html( data.result_data.bank_name + "<span class='d_i'>은행</span>") ;
			$("#bank_account").html( data.result_data.bank_account) ;
	
			$("#national_skill_large").html( "대분류 - " + data.result_data.national_skill_large) ;
			$("#national_skill_middle").html( "중분류 - " + data.result_data.national_skill_middle) ;
			$("#national_skill_small").html( "소분류 - " + data.result_data.national_skill_small) ;
			$("#four_industry").html(data.result_data.four_industry_name) ;
			$("#rnd_class").html(data.result_data.rnd_class) ;
	
			// 학력
			var body = $("#degree_body");
			body.empty();
			var str = "";
			if ( gfn_isNull(data.result_data.degree_school_01) == false &&
				 gfn_isNull(data.result_data.degree_major_01) == false &&
				 gfn_isNull(data.result_data.degree_date_01) == false  ) {
					str += "<tr>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_01 + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_school_01 + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_major_01 + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_date_01 + "년</center></td>";
					str += "	<td class='td_c'>";
					str += "		<a href='/admin/api/member/commissioner/download/"+ data.result_data.degree_certificate_file_id_01 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_01 + "</a>";
					str += "	</td>"
					str += "</tr>";
			 }
	
			if ( gfn_isNull(data.result_data.degree_school_02) == false &&
				 gfn_isNull(data.result_data.degree_major_02) == false &&
				 gfn_isNull(data.result_data.degree_date_02) == false  ) {
					str += "<tr>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_02 + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_school_02 + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_major_02 + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data.degree_date_02 + "년</center></td>";
					str += "	<td class='td_c'>";
					str += "		<a href='/admin/api/member/commissioner/download/"+ data.result_data.degree_certificate_file_id_02 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_02 + "</a>";
					str += "	</td>"
					str += "</tr>";
				 }
			body.append(str);
	
	  		// 경력
			var body = $("#career_body");
			body.empty();
			str = "";
			for(var i=1; i<=4; i++) {
				if ( gfn_isNull(data.result_data["career_company_0" + i]) == false) {
					str += "<tr>";
					str += "	<td class='clearfix'><center>"+ data.result_data["career_company_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["career_depart_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["career_position_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["career_start_date_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["career_retire_date_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["career_description_0" + i] + "</center></td>";
					str += "</tr>";
				}
			}
			body.append(str);
	
	  		// 논문
			var body = $("#thesis_body");
			var isExist = false;
			str = "";
			body.empty();
			for(var i=1; i<=3; i++) {
				if ( gfn_isNull(data.result_data["thesis_title_0" + i]) == false) {
					isExist = true;
					str += "<tr>";
					if ( data.result_data["thesis_sci_yn_0" + i] == "Y") {
						str += "	<td class='clearfix'><center>"+ "등재" + "</center></td>";
					} else {
						str += "	<td class='clearfix'><center>"+ "등재안됨" + "</center></td>";
					}
					str += "	<td class='clearfix'><center>"+ data.result_data["thesis_title_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["thesis_writer_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["thesis_journal_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["thesis_nationality_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["thesis_date_0" + i] + "</center></td>";
					str += "</tr>";
				}
			}
			if ( isExist == false ) {
				str = "<tr>" + "<td colspan='6'>조회된 결과가 없습니다.</td>" + "</tr>";
			}
			body.append(str);
	
			// 지적 재산권
			var body = $("#iprs_body");
			var isExist = false;
			str = "";
			body.empty();
			for(var i=1; i<=3; i++) {
				if ( gfn_isNull(data.result_data["iprs_name_0" + i]) == false) {
					isExist = true;
					str += "<tr>";
					str += "	<td class='clearfix'><center>"+ data.result_data["iprs_name_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["iprs_enroll_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["iprs_reg_no_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["iprs_date_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["iprs_nationality_0" + i] + "</center></td>";
					str += "	<td class='clearfix'><center>"+ data.result_data["iprs_writer_0" + i] + "</center></td>";
					str += "</tr>";
				}
			}
			if ( isExist == false ) {
				str = "<tr>" + "<td colspan='6'>조회된 결과가 없습니다.</td>" + "</tr>";
			}
			body.append(str);
	
			$("#self_description").html(data.result_data.self_description) ;
			$("#remark").val(data.result_data.remark);
		}
	

		function saveRemark() {
			var formData = new FormData();
			formData.append("member_id", $("#member_id").val() );
			formData.append("remark", $("#remark").val() );
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/member/commissioner/update/remark",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	alert("저장 되었습니다.");
			    	searchDetail();
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
		
	</script>
	  
	  
	<body>		
		<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />	
		<div id="rating_leader_wrap">		
			<div class="wrap_area">
				<div class="table_area rating_result_tabel_area" style="display: block;">
					<div class="view_top_area">
						<h4 class="sub_title_h4">기본 정보</h4>						   
					</div>
					
					
					
					<table class="list2">
					   <caption>기본 정보</caption>
					   <colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
					   </colgroup>
					   <tbody>
							<tr>
								<th scope="row">성명</th>
								<td id="name"></td>	
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
						</tbody>
				   </table>
					
					
					<!--기관 정보-->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">기관 정보</h4>							  
				   </div>						   
				   <table class="list2">
					   <caption>기관 정보</caption>
					   <colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
					   </colgroup>
					   <tbody>
							<tr>
								<th scope="row">기관 유형</th>
								<td id="institution_type"></td>
							</tr>									  
							<tr>
								<th scope="row"><label>기관명</label></th>
								<td id="institution_name"></td>
							</tr>
							<tr>
								<th scope="row"><label>주소</label></th>
								<td id="institution_address"></td>
							</tr>
							<tr>
								<th scope="row"><label>전화</label></th>
								<td id="institution_phone"></td>
							</tr>
							<tr>
								<th scope="row"><label>부서</label></th>
								<td id="institution_depart"></td>
							</tr>
							<tr>
								<th scope="row"><label>직책</label></th>
								<td id="institution_position"></td>
							</tr>																									
						</tbody>
				   </table>
					<!--기관정보-->
					

					<!--계좌 정보-->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">계좌 정보</h4>							  
				   </div>						   
				   <table class="list2 write fixed">
				   <caption>계좌 정보</caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label>은행명</label></th>
								<td id="bank_name"></td>	
							</tr>  
							<tr>
								<th scope="row"><label>계좌번호</label></th>
								<td id="bank_account"></td>	
							</tr>																							
						</tbody>
				   </table>	

					<!-- 기술 분야 -->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">기술 분야</h4>							  
				   </div>						   
				   <table class="list2 write fixed">
				   <caption>기술 분야 </caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>								
						<tr>
							<th scope="row" rowspan="3">국가과학기술분류</th>
							<td id="national_skill_large"></td>
						</tr>  
						<tr>
							<td id="national_skill_middle"></td>
						</tr>
						<tr>
							<td id="national_skill_small"></td>
						</tr>
						<tr>
						   <th scope="row"><label>4차 산업혁명 기술분류</label></th>
						   <td id="four_industry"></td>
					   </tr>							   								
				   </table>
					
					<!-- 연구 분야 -->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">연구 분야</h4>							  
				   </div>						   
				   <table class="list2 write fixed">
						<caption>연구 분야</caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>
						<tbody>
							<tr>
						   		<th scope="row"><label>연구 상세 분야</label></th>
							  	<td id="rnd_class"></td>
							</tr>
						</tbody>
				   </table>

					<!-- 학력 -->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">학력</h4>							  
				   </div>						   
				   <table class="list write fixed bd_r">
						<caption>학력</caption>
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 25%;">
							<col style="width: 25%;">
							<col style="width: 12%;">
							<col style="width: 28%;">
						</colgroup>
						<thead>
							<tr>
								<th>학위</span></th>
								<th scope="col">학교명</th>
								<th scope="col">전공</th>
								<th scope="col">학위취득연도</th>
								<th scope="col">학위증명서</th>				
							</tr>
						</thead>
						<tbody id="degree_body">
						</tbody>
				   </table>
						   

					<!-- 경력 -->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">경력</h4>							  
				   </div>						   
				   <table class="list fixed history_table write2 bd_r">
						<caption>경력</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 20%;">
							<col style="width: 10%;">
							<col style="width: 19%;">
							<col style="width: 19%;">
							<col style="width: 22%;">
						</colgroup>
						<thead>
							<tr>
								<th scope="col">근무처</th>
								<th scope="col">근무부서</th>
								<th scope="col">직급</th>
								<th scope="col">입사</th>
								<th scope="col"><span class="icon_box">퇴사</span></th>
								<th scope="col">업무내용</th>
							</tr>
						</thead>
						<tbody id="career_body"></tbody>
				   </table>

					<!-- 논문/저서 -->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">논문/저서<span class="font_blue">(선택)</span></h4>							  
				   </div>						   
				   <table class="list fixed history_table write2 bd_r">
						<caption>논문/저서</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 20%;">
							<col style="width: 10%;">
							<col style="width: 19%;">
							<col style="width: 19%;">
							<col style="width: 22%;">
						</colgroup>
						<thead>
							<tr>
								<th scope="col">SCI여부</th>
								<th scope="col">논문저서명명</th>
								<th scope="col">주저자명</th>
								<th scope="col">학술지</th>
								<th scope="col">국내/국외</th>
								<th scope="col">발행일자</th>
							</tr>
						</thead>
						<tbody id="thesis_body"></tbody>
				   </table>

					<!--지식/재산권-->
				   <div class="view_top_area">
					   <h4 class="sub_title_h4">지식재산권<span class="font_blue">(선택)</span></h4>							  
				   </div>						   									
				   <table class="list fixed knowledge_table write2">
						<caption>지식재산권</caption>
						<colgroup>
							<col style="width: 21%;">
							<col style="width: 13%;">
							<col style="width: 14%;">
							<col style="width: 14%;">
							<col style="width: 18%;">
							<col style="width: 10%;">
						</colgroup>
						<thead>
							<tr>
								<th scope="col">논문저서 명</th>
								<th scope="col">출원/등록</th>
								<th scope="col">출원/등록 번호</th>
								<th scope="col">출원/등록 일자</th>
								<th scope="col">출원/등록 국가</th>
								<th scope="col">발명자명</th>
							</tr>
						</thead>
						<tbody id="iprs_body"></tbody>
				   </table>
					
					<!--자기기술서-->
				   <div class="view_top_area clearfix mt30">
					   <h4 class="sub_title_h4">자기기술서<span class="font_blue">(선택)</span></h4>							  
				   </div>						   
				   <table class="list2 font_white">
					   <caption>자기기술서</caption>
						<colgroup>
							<col style="width: 30%;">																		
							<col style="width: 70%;">
						</colgroup>
						<tbody>
							<tr>
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="my_skill">자기기술서</label></span></th>
							   <td>
								   <textarea name="my_skill" id="self_description" cols="30" rows="8" class="w100 d_input" disabled></textarea>
								   <p class="ta_r">(500자 이내)</p>
							   </td>
							</tr>
							<tr>
							   <th scope="row">비고</th>
							   <td>
								   <input type="text" class="form-control w90 ls fl" id="remark"/>
								   <button type="button" class="blue_btn fl ml5" onclick="saveRemark();">저장</button>
							   </td>
							</tr>
						 </tbody>
					</table>

					
				</div>
			</div>
		</div>
		<!-- //wrap -->
		
		<script src="/assets/admin/js/script.js"></script>
		
	</body>
</html>
