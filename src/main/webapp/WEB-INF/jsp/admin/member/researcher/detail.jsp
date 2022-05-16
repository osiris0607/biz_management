<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
  
<script type='text/javascript'>
	$(document).ready(function() {
		searchMemberDetail();
		searchInstitutionDetail();
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
		$("#name").html(data.result.name) ;
		$("#institution_type").html(data.result.institution_type_name);
		$("#id").html($("#member_id").val()) ;
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
		$("#institution_name").html("<span>" + data.result.name +" </span>");
		$("#institution_phone").html("<span>" + data.result.phone + "</span>");
	}
</script>

<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />	
<div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                   <!--left menu 서브 메뉴-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- 레프트 메뉴 서브 타이틀 -->	
					       <div class="lnb_title_area">
						       <h2 class="title">회원관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							      <li class="on"><a href="/admin/fwd/member/researcher/main" title="연구자 관리">연구자 관리</a></li>
								   <li><a href="/admin/fwd/member/commissioner/main" title="평가위원 관리">평가위원 관리</a></li>
								   <li><a href="/admin/fwd/member/expert/main" title="전문가 관리">전문가 관리</a></li>
								   <li><a href="/admin/fwd/member/mainAdmin" title="관리자 계정 관리">관리자 계정관리</a></li>
							   </ul>				
						   </div>					
					   </div>			
				   </div>
				   <!--left menu 서브 메뉴-->

				   <!--본문시작-->
                   <div class="contents">
                       <div class="location_area">
					       <div class="location_division">
							   <!--페이지 경로-->
					           <ul class="location clearfix">
							       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>회원관리</li>
								   <li><strong>연구자 관리</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">연구자 관리</h3>
							  <!--//페이지타이틀-->
						    </div>
					   </div>
                       <div class="contents_view sub_view">
						   <!--회원관리 view-->
						   <div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">기본 정보</h4>
							   <span class="fr mt30"><input type="checkbox" class="checkbox_member_manager_table" /><label>이용 중지</label></span>
						   </div>
						  
						   <table class="list2">
							   <caption>연구자 관리</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <thead>
								   <tr>
								   		<th scope="row">성명</th>
										<td id="name"></td>	
								   </tr>
							   </thead>
							   <tbody>							   	   
								   <tr>
				  				 		<th scope="row">소속기관 유형</th>
										<td id="institution_type"></td>
								   </tr>
								   <tr>
									   <th scope="row">아이디</th>
									   <td id="id"></td>	
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
									   	<th scope="row">기관명</th>
										<td id="institution_name"></td>
								   </tr>
								   
								   <tr>
									   	<th scope="row">기관 전화번호</th>
										<td id="institution_phone"></td>
								   </tr>
								   <!--tr>
									   <th scope="row"><label for="member_Jobdepartment">부서</label></th>
									   <td><input type="text" id="member_Jobdepartment" class="form-control w_40 d_input" placeholder="abc부서" disabled /></td> 
								   </tr>
								   <tr>
									   <th scope="row"><label for="member_position">직책</label></th>
									   <td><input type="text" id="member_position" class="form-control w_18 d_input" placeholder="부장" disabled /></td> 
								   </tr-->
							   </tbody>
						   </table>  
						   


						   <!--//회원관리 view-->
						   <div class="fr mt30 clearfix">
							   <button type="button" class="fl gray_btn2" onclick="location.href='/admin/fwd/member/researcher/main'">목록</button>
						   </div>
				       </div><!--//contents view-->
					   
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>