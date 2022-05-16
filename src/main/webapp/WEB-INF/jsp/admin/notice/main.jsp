<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/notice/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		if ( gfn_isNull($("#search_selector").val()) == false) {
			comAjax.addParam($("#search_selector").val(), $("#search_text").val() );
		}

		if ( (gfn_isNull($("#date_from").val()) == true && gfn_isNull($("#date_to").val()) == false ) ||
			 (gfn_isNull($("#date_from").val()) == false && gfn_isNull($("#date_to").val()) == true ) ) {
			alert("등록기간 시작일/종료일은 둘 다 존재하거나 혹은 둘 다 없어야 합니다.");
			return;
	   	} else {

			if ( $("#date_from").val() > $("#date_to").val() ) {
				alert("시작날짜가 종료날짜를 초과했습니다.");
				return;
			}
		   	
	   		comAjax.addParam("date_from", $("#date_from").val());
			comAjax.addParam("date_to", $("#date_to").val());
	   	}
		
		comAjax.ajax();
	}
	
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
		var body = $("#list_body");
		body.empty();
		
		if (total == 0) {
			var str = "<tr>" + "<td colspan='3'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
			gfnRenderPaging(params);

			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td>" + index + "</td>";
				str += "	<td><a href='/admin/fwd/notice/detail?notice_id=" + value.notice_id + "'>"+ value.title + "</a></td>";
				str += "	<td>"+ value.reg_date +"</td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);
		}
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
					<h2 class="title">알림&middot;정보</h2>
				</div>
      			 <!--// 레프트 메뉴 서브 타이틀 -->
				<div class="lnb_menu_area">	
					<ul class="lnb_menu">
						<li class="on"><a href="/admin/fwd/notice/main" title="알림&middot;정보">알림&middot;정보</a></li>								   
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
					   <li><strong>알림&middot;정보</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				   <h3 class="title_area">알림&middot;정보</h3>
				  <!--//페이지타이틀-->
			    </div>
		    </div>
	
		   <!--리스트 상단 검색-->
		   <div class="contents_view">
			   <div class="list_search_top_area">
				   <ul class="clearfix list_search_top">
				   		<li class="clearfix">         
						    <label for="join_datepicker" class="fl mr10 list_search_title w_8 ta_r">작성기간</label>
						    <div class="datepicker_area fl">
							    <input type="text" id="date_from" class="datepicker form-control w_12" placeholder="시작일" />
						    </div>
						    <span class="fl ml5 mr5 mt5">~</span>
						    <div class="datepicker_area fl">
							    <input type="text" id="date_to" class="datepicker form-control w_12" placeholder="종료일" />
						    </div>
					    </li> 
					</ul>
					<ul class="clearfix list_search_top">
					   <li class="clearfix" style="width:100%">
						   <label for="notice_list_search_word" class="fl list_search_title ta_r mr10 w_8">검색어</label>
						   <select name="notice_list_search_word" id="search_selector" class="ace-select fl w_18">
							   <option value="">선택</option>
							   <option value="title">제목</option>
							   <option value="explanation">내용</option>
							   <option value="titleExplanation">제목+내용</option>									
						   </select>
						   <input type="text" id="search_text" class="form-control brc-on-focusd-inline-block fl list_search_word_input ml5" style="width:48%">  
						   <label for="notice_list_search_input" class="hidden">검색어 입력</label>
					   </li>							   
				   </ul>
				  
				   <div class="list_search_btn clearfix">								  
					   <button type="button" class="fr blue_btn mr5" onclick="searchList(1);">검색</button>
				   </div>
			   </div>
			   <!--//리스트 상단 검색-->
	
			   <!--검색 결과-->
			   <div class="list_search_table">
				   <div class="table_count_area clearfix">
					   <div class="count_area fl" id="search_count"></div>
					   <div class="fr">
						  <button type="button" class="blue_btn2 mb10" onclick="location.href='/admin/fwd/notice/registration'">알림&middot;정보 등록</button>
					   </div>
				   </div>
				   <div style="overflow-x:auto;">
					   <table class="list th_c">
						   <caption>리스트 화면</caption>  
						   <colgroup>
							   <col style="width:10%">
							   <col style="width:80%">										  
							   <col style="width:10%">										 
						   </colgroup>
						   <thead>
							   <tr>
								   <th scope="col">번호</th>
								   <th scope="col">제목</th>											   
								   <th scope="col">작성일</th>											  
							   </tr>
						   </thead>
						   <tbody id="list_body"></tbody>
					   </table>   
					   <!--//검색 결과-->                           
				   </div>  
				   				 
  				   <!--페이지 네비게이션-->
				   <input type="hidden" id="pageIndex" name="pageIndex"/>
				   <div class="page" id="pageNavi"></div>  
					<!--//페이지 네비게이션-->
			   </div>
			   <!--//list_search_table-->
			</div><!--contents_view-->
        </div>
	   <!--//contents--> 
	</div>
</div>
<!--//container-->
