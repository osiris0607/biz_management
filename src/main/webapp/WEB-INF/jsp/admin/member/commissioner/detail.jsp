<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
  
<script type='text/javascript'>
	$(document).ready(function() {
		searchMemberDetail();
		searchInstitutionDetail();
		searchDetail();		
	});

	function searchMemberDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/detail'/>");
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
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
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
		comAjax.setUrl("<c:url value='/admin/api/member/commissioner/detail'/>");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("member_id", $("#member_id").val());
		comAjax.addParam("commissioner_id", $("#commissioner_id").val());
		comAjax.ajax();
	}
	
	function searchDetailCB(data){
		$("#bank_name").html( data.result_data.bank_name + "<span class='d_i'>??????</span>") ;
		$("#bank_account").html( data.result_data.bank_account) ;

		$("#national_skill_large").html( "????????? - " + data.result_data.national_skill_large) ;
		$("#national_skill_middle").html( "????????? - " + data.result_data.national_skill_middle) ;
		$("#national_skill_small").html( "????????? - " + data.result_data.national_skill_small) ;
		$("#four_industry").html(data.result_data.four_industry_name) ;
		$("#rnd_class").html(data.result_data.rnd_class) ;

		// ??????
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
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_date_01 + "???</center></td>";
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
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_date_02 + "???</center></td>";
				str += "	<td class='td_c'>";
				str += "		<a href='/admin/api/member/commissioner/download/"+ data.result_data.degree_certificate_file_id_02 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_02 + "</a>";
				str += "	</td>"
				str += "</tr>";
			 }
		body.append(str);

  		// ??????
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

  		// ??????
		var body = $("#thesis_body");
		var isExist = false;
		str = "";
		body.empty();
		for(var i=1; i<=3; i++) {
			if ( gfn_isNull(data.result_data["thesis_title_0" + i]) == false) {
				isExist = true;
				str += "<tr>";
				if ( data.result_data["thesis_sci_yn_0" + i] == "Y") {
					str += "	<td class='clearfix'><center>"+ "??????" + "</center></td>";
				} else {
					str += "	<td class='clearfix'><center>"+ "????????????" + "</center></td>";
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
			str = "<tr>" + "<td colspan='6'>????????? ????????? ????????????.</td>" + "</tr>";
		}
		body.append(str);

		// ?????? ?????????
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
			str = "<tr>" + "<td colspan='6'>????????? ????????? ????????????.</td>" + "</tr>";
		}
		body.append(str);

		$("#self_description").html(data.result_data.self_description) ;

		// D0000002 - ????????????????????? ??????????????? ????????? ??? ?????? ????????? ????????????.
		if ( data.result_data.commissioner_status == "D0000002") {
			$("#reg_fail_btn").show();
			$("#reg_success_btn").show();
		}

/* 		// D0000003 - ????????????????????? ?????? ????????? ??? ????????? ??????.
		if ( data.result_data.commissioner_status == "D0000003") {
			$("#reg_success_btn").show();
		}

		// D0000004 - ????????????????????? ?????? ????????? ??? ????????? ??????.
		if ( data.result_data.commissioner_status == "D0000004") {
			$("#reg_fail_btn").show();
		} */
	}

	function updateCommissionerStatus(status) {
		var formData = new FormData();
		formData.append("member_id", $("#member_id").val() );
		formData.append("commissioner_status", status);

		if (confirm("???????????? ???????????????????")){
			$.ajax({
			    type : "POST",
			    url : "/admin/api/member/commissioner/update/status",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	alert("?????? ???????????????.");
			    	location.href='/admin/fwd/member/commissioner/main';
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
		
		
	}

	function moveAcceptance(){
		location.href="/admin/fwd/member/commissioner/acceptance?member_id=" + $("#member_id").val() + "&email=" + memberInfo.email + "&mobile_phone=" + memberInfo.mobile_phone;
	}

	
</script>

<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />	
<input type="hidden" id="commissioner_id" name="commissioner_id" value="${vo.commissioner_id}" />	
<div class="container" id="content">
                <h2 class="hidden">????????? ??????</h2>
                <div class="sub">
                   <!--left menu ?????? ??????-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- ????????? ?????? ?????? ????????? -->	
					       <div class="lnb_title_area">
						       <h2 class="title">????????????</h2>
						   </div>
		                   <!--// ????????? ?????? ?????? ????????? -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">							       
								   <li><a href="/admin/fwd/member/researcher/main" title="?????????">?????????</a></li>
								   <li class="on"><a href="/admin/fwd/member/commissioner/main" title="????????????">????????????</a></li>
								   <li><a href="/admin/fwd/member/expert/main" title="?????????">?????????</a></li>
								   <li><a href="/admin/fwd/member/manager/main" title="????????? or ??????????????????">????????? or ??????????????????</a></li>
							   </ul>			
						   </div>					
					   </div>			
				   </div>
				   <!--left menu ?????? ??????-->

				   <!--????????????-->
                   <div class="contents">
                       <div class="location_area">
					       <div class="location_division">
							   <!--????????? ??????-->
					           <ul class="location clearfix">
							       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>????????????</li>
								   <li><strong>????????????</strong></li>
							   </ul>	
							  <!--//????????? ??????-->
							  <!--??????????????????-->
							   <h3 class="title_area">????????????</h3>
							  <!--//??????????????????-->
						    </div>
					    </div>
					    <div class="contents_view sub_view">
						   <!--????????? or ?????????????????? view-->
						   <div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">?????? ??????</h4>
							   <!-- <span class="fr mt30"><input type="checkbox" class="checkbox_member_manager_table" /><label>?????? ??????</label></span> -->
						   </div>						   
						   <table class="list2">
							   <caption>?????? ??????</caption>
							   <colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
							   </colgroup>
							   <tbody>
									<tr>
										<th scope="row">??????</th>
										<td id="name"></td>	
									</tr>									  
									<tr>
										<th scope="row"><span class="icon_box"><span class=" necessary_icon">*</span>????????????</span></th>
										<td id="mobile_phone"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class=" necessary_icon">*</span>?????????</span></th>
										<td id="email"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class=" necessary_icon">*</span>??????</span></th>
										<td id="address"></td>
									</tr>
								</tbody>
						   </table>
						   

						   <!--?????? ??????-->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">?????? ??????</h4>							  
						   </div>						   
						   <table class="list2">
							   <caption>?????? ??????</caption>
							   <colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
							   </colgroup>
							   <tbody>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>?????? ??????</span></th>
										<td id="institution_type"></td>
									</tr>									  
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_name">?????????</label></span></th>
										<td id="institution_name"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="address_agreementmember_sign2">??????</label></span></th>
										<td id="institution_address"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_charge_tel2">??????</label></span></th>
										<td id="institution_phone"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_partment">??????</label></span></th>
										<td id="institution_depart"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_rank">??????</label></span></th>
										<td id="institution_position"></td>
									</tr>																									
								</tbody>
						   </table>
						   

						   <!--?????? ??????-->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">?????? ??????</h4>							  
						   </div>						   
						   <table class="list2 write fixed">
						   <caption>?????? ??????</caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_bankname">?????????</label></span></th>
										<td id="bank_name"></td>	
									</tr>  
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_banknumber">????????????</label></span></th>
										<td id="bank_account"></td>	
									</tr>																							
								</tbody>
						   </table>	
						   
						   
						   <!-- ?????? ?????? -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">?????? ??????</h4>							  
						   </div>						   
						   <table class="list2 write fixed">
						   <caption>?????? ?????? </caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>								
								<tr>
									<th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span>????????????????????????</span></th>
									<td id="national_skill_large"></td>
								</tr>  
								<tr>
									<td id="national_skill_middle"></td>
								</tr>
								<tr>
									<td id="national_skill_small"></td>
								</tr>
								<tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="industry_4th_technology">4??? ???????????? ????????????</label></span></th>
								   <td id="four_industry"></td>
							   </tr>							   								
						   </table>

						   <!-- ?????? ?????? -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">?????? ??????</h4>							  
						   </div>						   
						   <table class="list2 write fixed">
								<caption>?????? ??????</caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>
								<tbody>
									<tr>
								   		<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="research_class">?????? ?????? ??????</label></span></th>
									  	<td id="rnd_class"></td>
									</tr>
								</tbody>
						   </table>
						   
						   

						   <!-- ?????? -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">??????</h4>							  
						   </div>						   
						   <table class="list2 write fixed bd_r">
								<caption>??????</caption>
								<colgroup>
									<col style="width: 10%;">
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 12%;">
									<col style="width: 28%;">
								</colgroup>
								<thead>
									<tr>
										<th><span class="icon_box"><span class="necessary_icon">*</span>??????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>?????????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>??????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>??????????????????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>???????????????</span></th>				
									</tr>
								</thead>
								<tbody id="degree_body">
								</tbody>
						   </table>
						  

						   <!-- ?????? -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">??????</h4>							  
						   </div>						   
						   <table class="list2 fixed history_table write2 bd_r">
								<caption>??????</caption>
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
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>?????????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>????????????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>??????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>??????</span></th>
										<th scope="col"><span class="icon_box">??????</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>????????????</span></th>
									</tr>
								</thead>
								<tbody id="career_body"></tbody>
						   </table>
						   

						   <!-- ??????/?????? -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">??????/??????<span class="font_blue">(??????)</span></h4>							  
						   </div>						   
						   <table class="list2 fixed history_table write2 bd_r">
								<caption>??????/??????</caption>
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
										<th scope="col">SCI??????</th>
										<th scope="col">??????????????????</th>
										<th scope="col">????????????</th>
										<th scope="col">?????????</th>
										<th scope="col">??????/??????</th>
										<th scope="col">????????????</th>
									</tr>
								</thead>
								<tbody id="thesis_body"></tbody>
						   </table>
						   
						   <!-- ??????/?????? -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">???????????????<span class="font_blue">(??????)</span></h4>							  
						   </div>						   									
						   <table class="list fixed knowledge_table write2">
								<caption>???????????????</caption>
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
										<th scope="col">???????????? ???</th>
										<th scope="col">??????/??????</th>
										<th scope="col">??????/?????? ??????</th>
										<th scope="col">??????/?????? ??????</th>
										<th scope="col">??????/?????? ??????</th>
										<th scope="col">????????????</th>
									</tr>
								</thead>
								<tbody id="iprs_body"></tbody>
						   </table>
						   
						   
						   <!-- ??????/?????? -->
						   <div class="view_top_area clearfix mt30">
							   <h4 class="sub_title_h4">???????????????<span class="font_blue">(??????)</span></h4>							  
						   </div>						   
						   <table class="list2 font_white">
							   <caption>???????????????</caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>
								<tbody>
									<tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="my_skill">???????????????</label></span></th>
									   <td>
										   <textarea name="my_skill" id="self_description" cols="30" rows="8" class="w100 d_input" disabled></textarea>
										   <p class="ta_r">(500??? ??????)</p>
									   </td>
									</tr>
								 </tbody>
							</table>
						   
						   <!--//????????? or ?????????????????? view-->						  
						   <div class="fr mt30 clearfix">
						   	   <button type="button" style="display:none;" id="reg_fail_btn" onclick="updateCommissionerStatus('D0000003');" class="gray_btn fl mr5 member_manager_hold_popup_btn">????????????</button>
							   <button type="button" style="display:none;" id="reg_success_btn" class="blue_btn2 fl mr5" onclick="moveAcceptance();">???????????? ??? ????????? ??????</button>
							   <button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/member/commissioner/main'">??????</button>
						   </div>
						   
					   </div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>