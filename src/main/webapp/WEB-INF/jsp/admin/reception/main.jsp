<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		searchMainStat();
	});

	function searchMainStat() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/reception/main/stat' />");
		comAjax.setCallback(searchMainStatCB);
		comAjax.ajax();
	}
	
	function searchMainStatCB(data) {
		console.log(data);

		$("#match_registration_count").html("<span class='font_blue'>" + data.result_data.MATCH_REGISTRATION_COUNT + "</span>건</td>");
		$("#match_progress_count").html("<span class='font_blue'>" + data.result_data.MATCH_PROGRESS_COUNT + "</span>건</td>");
		$("#match_complete_count").html("<span class='font_blue'>" + data.result_data.MATCH_COMPLETE_COUNT + "</span>건</td>");
		$("#match_cancel_count").html("<span class='font_blue'>" + data.result_data.MATCH_CANCEL_COUNT + "</span>건</td>");
		$("#match_reject_count").html("<span class='font_blue'>" + data.result_data.MATCH_REJECT_COUNT + "</span>건</td>");

		$("#contest_registration_count").html("<span class='font_blue'>" + data.result_data.CONTEST_REGISTRATION_COUNT + "</span>건</td>");
		$("#contest_progress_count").html("<span class='font_blue'>" + data.result_data.CONTEST_PROGRESS_COUNT + "</span>건</td>");
		$("#contest_complete_count").html("<span class='font_blue'>" + data.result_data.CONTEST_COMPLETE_COUNT + "</span>건</td>");
		$("#contest_cancel_count").html("<span class='font_blue'>" + data.result_data.CONTEST_CANCEL_COUNT + "</span>건</td>");
		$("#contest_reject_count").html("<span class='font_blue'>" + data.result_data.CONTEST_REJECT_COUNT + "</span>건</td>");
		
		$("#proposal_registration_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_REGISTRATION_COUNT + "</span>건</td>");
		$("#proposal_progress_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_PROGRESS_COUNT + "</span>건</td>");
		$("#proposal_complete_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_COMPLETE_COUNT + "</span>건</td>");
		$("#proposal_cancel_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_CANCEL_COUNT + "</span>건</td>");
		$("#proposal_reject_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_REJECT_COUNT + "</span>건</td>");
	}
	


</script>
            
<div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                   <!--left menu 서브 메뉴-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- 레프트 메뉴 서브 타이틀 -->	
					       <div class="lnb_title_area">
						       <h2 class="title">접수관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="/admin/fwd/reception/main" title="접수관리">접수관리</a></li>
								   <li class="menu2depth">
									   <ul>
										   <li><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
										   <li><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
										   <li><a href="/admin/fwd/reception/proposal/main">기술제안</a></li>
									   </ul>
								   </li>
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
							       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
								   <li><strong>접수관리</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">접수관리</h3>
							  <!--//페이지타이틀-->
						    </div>
					   </div>
					   
                       <div class="contents_view">
					       <div class="technology_class_area">
						       <ul class="clearfix">
							   	   <!--기술매칭-->
						           <li>
								       <span class="echnology_class_title">기술매칭</span>
									   <table class="list2">
										   <tbody>
											   <tr>
												   <th>접수신청</th>
												   <td class="ta_c" id="match_registration_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수진행</th>
												    <td class="ta_c" id="match_progress_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수완료</th>
												   <td class="ta_c" id="match_complete_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수취소</th>
												   <td class="ta_c" id="match_cancel_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>반려</th>
												   <td class="ta_c" id="match_reject_count"><span class="font_blue">00</span>건</td>
											   </tr>
										   </tbody>
									   </table>
								   </li>

								    <!--기술공모-->
						       	   <li>
								       <span class="echnology_class_title">기술공모</span>
									   <table class="list2">
										   <tbody>
											   <tr>
												   <th>접수신청</th>
												   <td class="ta_c" id="contest_registration_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수진행</th>
												    <td class="ta_c" id="contest_progress_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수완료</th>
												   <td class="ta_c" id="contest_complete_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수취소</th>
												   <td class="ta_c" id="contest_cancel_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>반려</th>
												   <td class="ta_c" id="contest_reject_count"><span class="font_blue">00</span>건</td>
											   </tr>
										   </tbody>
									   </table>
								   </li>

								    <!--기술제안-->
						       	   <li>
								       <span class="echnology_class_title">기술제안</span>
									   <table class="list2">
										   <tbody>
											   <tr>
												   <th>접수신청</th>
												   <td class="ta_c" id="proposal_registration_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수진행</th>
												    <td class="ta_c" id="proposal_progress_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수완료</th>
												   <td class="ta_c" id="proposal_complete_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>접수취소</th>
												   <td class="ta_c" id="proposal_cancel_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>반려</th>
												   <td class="ta_c" id="proposal_reject_count"><span class="font_blue">00</span>건</td>
											   </tr>
										   </tbody>
									   </table>
								   </li>
						       </ul>
						   </div>					   
                       </div><!--content view-->
				   </div>
					<!--//contents--> 

			   </div>
			   <!--//sub--> 
		    </div>
