<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {
		searchMainStat();
	});

	function searchMainStat() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/announcement/main/stat' />");
		comAjax.setCallback(searchMainStatCB);
		comAjax.ajax();
	}
	
	function searchMainStatCB(data) {
		console.log(data);

		$("#match_open_count").html("<span class='font_blue'>" + data.result_data.MATCH_OPEN_COUNT + "</span>건</td>");
		$("#match_write_finish_count").html("<span class='font_blue'>" + data.result_data.MATCH_WRITE_FINISH_COUNT + "</span>건</td>");
		$("#match_write_continue_count").html("<span class='font_blue'>" + data.result_data.MATCH_WRITE_CONTINUE_COUNT + "</span>건</td>");
		$("#contest_open_count").html("<span class='font_blue'>" + data.result_data.CONTEST_OPEN_COUNT + "</span>건</td>") ;
		$("#contest_write_finish_count").html("<span class='font_blue'>" + data.result_data.CONTEST_WRITE_FINISH_COUNT + "</span>건</td>") ;
		$("#contest_write_continue_count").html("<span class='font_blue'>" + data.result_data.CONTEST_WRITE_CONTINUE_COUNT + "</span>건</td>") ;
		$("#proposal_open_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_OPEN_COUNT + "</span>건</td>") ;
		$("#proposal_write_finish_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_WRITE_FINISH_COUNT + "</span>건</td>") ;
		$("#proposal_write_continue_count").html("<span class='font_blue'>" + data.result_data.PROPOSAL_WRITE_CONTINUE_COUNT + "</span>건</td>") ;
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
						       <h2 class="title">공고관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="/admin/fwd/announcement/main" title="공고관리">공고관리</a></li>
								   <ul class="menu2depth">
								       <li><a href="/admin/fwd/announcement/match/main">기술매칭</a></li>
								   	   <li><a href="/admin/fwd/announcement/contest/main">기술공모</a></li>
								   	   <li><a href="/admin/fwd/announcement/proposal/main">기술제안</a></li>
								   </ul>
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
							       <li><a href="/admin/fwd/announcement/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li><strong>공고관리</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">공고관리</h3>
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
												   <th>게시중</th>
												   <td class="ta_c" id="match_open_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>작성완료</th>
												    <td class="ta_c" id="match_write_finish_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>작성중</th>
												   <td class="ta_c" id="match_write_continue_count"><span class="font_blue">00</span>건</td>
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
												   <th>게시중</th>
												   <td class="ta_c" id="contest_open_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>작성완료</th>
												   <td class="ta_c" id="contest_write_finish_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>작성중</th>
												   <td class="ta_c" id="contest_write_continue_count"><span class="font_blue">00</span>건</td>
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
												   <th>게시중</th>
												   <td class="ta_c" id="proposal_open_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>작성완료</th>
												   <td class="ta_c" id="proposal_write_finish_count"><span class="font_blue">00</span>건</td>
											   </tr>
											   <tr>
												   <th>작성중</th>
												   <td class="ta_c" id="proposal_write_continue_count"><span class="font_blue">00</span>건</td>
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
		    <!--//container-->
            
        
