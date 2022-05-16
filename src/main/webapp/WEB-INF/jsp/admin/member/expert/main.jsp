<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {

/* 		$("#lately_week").change(function(){
	        if($("#lately_week").is(":checked")){
			  	var fromDay = new Date();
			  	var year = fromDay.getFullYear();
				var month = (fromDay.getMonth() + 1);
				var day = fromDay.getDate();
				month = (month < 10) ? "0" + String(month) : month;
				day = (day < 10) ? "0" + String(day) : day;
			  	$("#receipt_from").val(year+"-"+month+"-"+day);

			  	
			  	var toDay = new Date();
			  	toDay.setDate(toDay.getDate()+7);
		  		year = toDay.getFullYear();
		  		month = (toDay.getMonth() + 1);
		  		day = toDay.getDate();
				month = (month < 10) ? "0" + String(month) : month;
				day = (day < 10) ? "0" + String(day) : day;
				$("#receipt_to").val(year+"-"+month+"-"+day);
	        }else{
	        	$("#receipt_from").val("");
	        	$("#receipt_from").attr("placeholder", "시작일");
	            $("#receipt_to").val("");
	            $("#receipt_to").attr("placeholder", "종료일");
	        }
	    }); */
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/member/expert/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		var temp = $("#institution_type_selector").val();
		comAjax.addParam("institution_type", $("#institution_type_selector").val());

		if ( (gfn_isNull($("#from_date").val()) && gfn_isNull($("#to_date").val()) == false ) || 
			 (gfn_isNull($("#from_date").val()) == false && gfn_isNull($("#to_date").val()) ) 
		   ) {
			alert("시작일/종료일 정보는 하나씩 존재할 수 없습니다. 다시 선택해 주시기 바랍니다.");
			return;
	   	}
	   	if ( $("#from_date").val() > $("#to_date").val() )  {
	   		alert("시작일이 종료일보다 클 수는 없습니다.");
			return;
	   	}
		comAjax.addParam("from_date", $("#from_date").val());
		comAjax.addParam("to_date", $("#to_date").val());

		if ( gfn_isNull($("#search_selector").val()) == false ) {
			comAjax.addParam($("#search_selector").val(), $("#search_text").val() );
		}
		comAjax.ajax();
	}
	
	
	function searchListCB(data) {
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='9'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPaging(params);

			$("#search_count").text(total);
			var index = 1;
			var str = "";
			
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td>" + index + "</td>";
				str += "	<td>"+ value.university + "</td>";
				str += "	<td>"+ value.name + "</td>";
				str += "	<td><a href='/admin/fwd/member/expert/detail?member_id=" + value.member_id + "'><div class='txt_hidden'>" + value.member_id + "</div></a></td>";
				str += "	<td>" + value.research + "</td>";
				str += "	<td>"+ value.mobile_phone +"</td>";
				str += "	<td>"+ value.email +"</td>";
				str += "	<td>"+ value.reg_date +"</td>";
				str += "	<td>"+ value.institution_type_name +"</td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);
		}
	}

	function initSearch() {
		$("#nationality_selector option:eq(0)").prop("selected",true);
		$("#institution_type_selector option:eq(0)").prop("selected",true);
		$("#search_selector option:eq(0)").prop("selected",true);
		$("#search_text").val("");
		$("#from_date").val("");
		$("#to_date").val("");
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
				       <h2 class="title">회원관리</h2>
				   </div>
	                  <!--// 레프트 메뉴 서브 타이틀 -->
				   <div class="lnb_menu_area">	
				       <ul class="lnb_menu">
					       <li><a href="/admin/fwd/member/researcher/main" title="연구자">연구자</a></li>
						   <li><a href="/admin/fwd/member/commissioner/main" title="평가위원">평가위원</a></li>
						   <li class="on"><a href="/admin/fwd/member/expert/main" title="전문가">전문가</a></li>
						   <li><a href="/admin/fwd/member/manager/main" title="관리자 or 내부평가위원">관리자 or 내부평가위원</a></li>
					   </ul>
				       							       
				   </div>
  				</div>			
	   		</div>
	   <!--left menu 서브 메뉴-->            
            
			<div class="contents">
				<div class="location_area">
			       <div class="location_division">
					   <!--페이지 경로-->
			           <ul class="location clearfix">
					       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
						   <li>회원관리</li>
						   <li><strong>전문가</strong></li>
					   </ul>	
					  <!--//페이지 경로-->
					  <!--페이지타이틀-->
					   <h3 class="title_area">전문가</h3>
					  <!--//페이지타이틀-->
				    </div>
			    </div>

					   <!--리스트 상단 검색-->
			   <div class="contents_view">
				   <div class="list_search_top_area">
					   <ul class="clearfix list_search_top">								   
						   <li class="clearfix">
							   <label for="member_list_search_word_select" class="fl list_search_title ta_r mr10 w_8">기관 유형</label>
							   <select name="institution_type_selector" id="institution_type_selector" class="ace-select fl w_18">
  								   		<option value="">전체</option>
						          	<c:forEach items="${commonCode}" var="code">
										<c:if test="${code.master_id == 'M0000004'}">
											<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
										</c:if>
									</c:forEach>
							   </select>									   
						   </li>
						   <li class="clearfix">         
							   <label for="join_datepicker" class="fl list_search_title ta_r mr10 w_8">가입기간</label>								  
							   <div class="datepicker_area fl mr5 clearfix">
								   <input type="text" id="from_date" class="datepicker form-control w_14 fl" placeholder="시작일" />			   
							   </div>
							   <div class="datepicker_area fl clearfix">
								   <input type="text" id="to_date" class="datepicker form-control w_14 fl" placeholder="종료일" />				  
							   </div>
						   </li>
						</ul>
						<ul class="clearfix list_search_top">
						   <li class="clearfix" style="width:100%">
							   <label for="member_list_search_word" class="fl list_search_title ta_r mr10 w_8">검색어</label>
							   <select name="search_selector" id="search_selector" class="ace-select fl w_18">
								   <option value="">전체</option>
								   <option value="institution_name">소속기관</option>
								   <option value="member_id">아이디</option>
								   <option value="name">이름</option>
							   </select>
							   <input type="text" id="search_text" class="form-control brc-on-focusd-inline-block fl list_search_word_input ml5" style="width:48%">  
						   </li>							   
					   </ul>
					  
					   <div class="list_search_btn clearfix">								   
						   <button type="button" class="fr gray_btn" onclick="initSearch();">초기화</button>
						   <button type="button" class="fr blue_btn mr5" onclick="searchList(1);">검색</button>
					   </div>
				   </div>
			   <!--//리스트 상단 검색-->
		
		 			<!--검색 결과-->
					<div class="list_search_table">
					   <div class="table_count_area">
						   <div class="count_area">
							   [총 <span class="font_blue" id="search_count">100</span>건]
						   </div>
					   </div>
					   <div style="overflow-x:auto;">
						   <table class="list th_c">
							   <caption>리스트 화면</caption>  
							   <colgroup>
								   <col style="width:5%">
								   <col style="width:15%">										   
								   <col style="width:15%">
								   <col style="width:7%">
								   <col style="width:15%">
								   <col style="width:10%">
								   <col style="width:18%">
								   <col style="width:10%">
								   <col style="width:5%">
							   </colgroup>
							   <thead>
								   <tr>
									   <th scope="col">번호</th>										   
									   <th scope="col">기관명</th>
									   <th scope="col">성명</th>
									   <th scope="col">아이디</th>
									   <th scope="col">분야</th>
									   <th scope="col">휴대전화</th>
									   <th scope="col">이메일</th>
									   <th scope="col">가입일</th>
									   <th scope="col">비고</th>
								   </tr>
							   </thead>
							   <tbody id="list_body">
							   </tbody>
						   </table>   
						   <!--//검색 결과-->                           
					   </div>  
					   <!--페이지 네비게이션-->
					   <input type="hidden" id="pageIndex" name="pageIndex"/>
					   <div class="page" id="pageNavi"></div>  
					</div>
			   </div>
		</div><!--contents_view-->
	</div>
</div>
<!--//contents--> 
            
        
