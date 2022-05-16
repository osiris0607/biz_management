<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />


<script type='text/javascript'>

	$(document).ready(function() {
		//btn_search_onclick();
	});

	/*******************************************************************************
	* Content Paging 조회
	*******************************************************************************/
	function btn_search_onclick() 
	{
		var comAjax = new ComAjax();
		comAjax.setUrl("/adminHome/api/statistics/visitor/searchTime");
		comAjax.setCallback(searchCB);

		if ( (gfn_isNull($("#ibx_fromDate").val()) && gfn_isNull($("#ibx_toDate").val()) == false ) || 
				 (gfn_isNull($("#ibx_fromDate").val()) == false && gfn_isNull($("#ibx_toDate").val()) ) 
		   ) 
	   {
			alert("시작일/종료일 정보를 같이 입력해 주시기 바랍니다. 다시 선택해 주시기 바랍니다.");
			return;
	   	}
	   	if ( $("#ibx_fromDate").val() > $("#ibx_toDate").val() )  
	   	{
	   		alert("시작일이 종료일보다 클 수는 없습니다.");
			return;
	   	}
	   	if ( $("#ibx_fromDate").val() > $("#ibx_toDate").val() )  
	   	{
	   		alert("시작일이 종료일보다 클 수는 없습니다.");
			return;
	   	}

	   	if ( gfn_isNull($("#ibx_fromDate").val()) == false && gfn_isNull($("#ibx_toDate").val()) == false )
		{
	   		var sdt = new Date($("#ibx_fromDate").val());
		   	var edt = new Date($("#ibx_toDate").val());
		   	var dateDiff = Math.ceil((edt.getTime()-sdt.getTime())/(1000*3600*24));
			if ( dateDiff > 7)
			{
				alert("최대 7일간의 통계 조회가 가능합니다.");
				return;
			}

			comAjax.addParam("from_date", $("#ibx_fromDate").val());
			comAjax.addParam("to_date", $("#ibx_toDate").val());
   		}
	   	else // 지정된 날짜가 없으면 오늘 날짜로 검색
	   	{
	   		var date = new Date();
	   		var month = date.getMonth() + 1;
	        var day = date.getDate();

	        month = month >= 10 ? month : '0' + month;
	        day = day >= 10 ? day : '0' + day;
	        var dateString = date.getFullYear() + '-' + month + '-' + day;
		   	
	   		comAjax.addParam("from_date", dateString);
			comAjax.addParam("to_date", dateString);
	   	}

		comAjax.ajax();
	}
	
	function searchCB(data) 
	{
		console.log(data);
		if (data.result == false)
		{
			alert("조회된 자료가 없습니다. 다시 시도해 주시기 바랍니다.");
			return;
		}
		else 
		{
			
		}
		
		
	}
</script>

<section id="content">	
	<h2 class="hidden">본문시작</h2>
	<!-- left_menu -->
	<nav id="left_menu">
		<h2 class="left_menu_title"><i class="fas fa-chart-bar"></i>통계관리</h2>
		<ul class="left_menu_link">						
			<li class="on"><a href="./statistics_time.html">방문자통계</a></li>
		</ul>	
	</nav>
	<!-- //left_menu -->
	
	<!-- 서브컨텐츠 -->
	<article class="contents sub_content">
		<h3 class="sub_title">방문자통계</h3>
		<!-- tab -->
		<div class="statistics">
			<ul>
				<li class="active"><a href="/adminHome/statistics/visitor/time">시간대별</a></li>
				<li><a href="./statistics_date.html">일자별</a></li>
				<li><a href="./statistics_week.html">주별</a></li>
				<li><a href="./statistics_month.html">월별</a></li>
				<li><a href="./statistics_year.html">연도별</a></li>
			</ul>
		</div>
		<!-- //tab -->

		<!-- list 검색 상단 -->
		<div class="list_search_top_area">							   
			<ul class="clearfix statistics_list_searchbox">							
				<li class="clearfix">
					<div class="width_box">
						<span class="title">기간</span>	
						<div class="datepicker_area">
							<input type="text" id="ibx_fromDate" class="datepicker form-control w120" placeholder="시작일" />					
							<span>~</span>								
							<input type="text" id="ibx_toDate" class="datepicker form-control w120" placeholder="종료일" />
						</div>								
						<button type="button" class="blue_btn2" onclick="btn_search_onclick();">조회</button>
						<span class="board_list_searchbox_txt">한번에 <span class="fw_b fc_b">최대 7일간</span>의 통계 조회가 가능합니다. 조회버튼을 눌러야 조회됩니다.</span>
					</div>
				</li>
			</ul>						
		</div>		 
		<!-- //list 검색 상단 -->

		<!-- list 검색 결과 -->
		<div class="list_search_table">	
			<div class="clearfix">
				<h4>시간대별 통계</h4>		
			</div>
			<div class="statistics_content_area" id="div_statisticsBody">
				<div class="list_table">
					<a href="" download class="ex_d_btn green_btn">엑셀 다운받기</a>
					<table class="list statisticstime statistics_list_table_board">
						<caption>시간대별 통계</caption>     
						<colgroup>
							<col style="width:50%">
							<col style="width:50%">										
						</colgroup>
						<thead>
							<tr>
								<th scope="row" rowspan="2" class="bgc_g">시간대</th>
								<th scope="row" id="txt_totalCount" class="fw_i">조회기간 방문자 : <span class="number fw_b sum_result"></span>(명) / 총 방문자 : <span class="number fw_b all_people">20000</span>(명)</th>
							</tr>
							<tr>
								<th scope="row">방문자(명)</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="time">00:00 ~ 01:00</td>
								<td class="number people" id="0"><span>0</span></td>
							</tr> 
							<tr>
								<td class="time">01:00 ~ 02:00</td>	
								<td class="number people" id="1"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">02:00 ~ 03:00</td>	
								<td class="number people" id="2"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">03:00 ~ 04:00</td>	
								<td class="number people" id="3"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">04:00 ~ 05:00</td>	
								<td class="number people" id="4"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">05:00 ~ 06:00</td>	
								<td class="number people" id="5"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">06:00 ~ 07:00</td>	
								<td class="number people" id="6"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">07:00 ~ 08:00</td>	
								<td class="number people" id="7"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">08:00 ~ 09:00</td>	
								<td class="number people" id="8"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">09:00 ~ 10:00</td>	
								<td class="number people" id="9"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">10:00 ~ 11:00</td>	
								<td class="number people" id="10"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">11:00 ~ 12:00</td>	
								<td class="number people" id="11"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">12:00 ~ 13:00</td>	
								<td class="number people" id="12"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">13:00 ~ 14:00</td>	
								<td class="number people" id="13"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">14:00 ~ 15:00</td>	
								<td class="number people" id="14"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">15:00 ~ 16:00</td>	
								<td class="number people" id="15"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">16:00 ~ 17:00</td>	
								<td class="number people" id="16"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">17:00 ~ 18:00</td>	
								<td class="number people" id="17"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">18:00 ~ 19:00</td>	
								<td class="number people" id="18"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">19:00 ~ 20:00</td>	
								<td class="number people" id="19"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">20:00 ~ 21:00</td>	
								<td class="number people" id="20"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">21:00 ~ 22:00</td>	
								<td class="number people" id="21"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">22:00 ~ 23:00</td>	
								<td class="number people" id="22"><span>0</span></td>
							</tr>
							<tr>
								<td class="time">23:00 ~ 24:00</td>	
								<td class="number people" id="23"><span>0</span></td>
							</tr>
					   </tbody>
					</table>   
					<!--//검색 결과--> 							   
								
				</div><!-- list_table-->
			</div><!-- //statistics_content_area -->
		</div>
		<!-- //list 검색 결과 -->
	</article>	
	<!-- //서브컨텐츠 -->
</section>
<!--// section -->
	

<script src="/assets/adminHome/js/script.js"></script>
