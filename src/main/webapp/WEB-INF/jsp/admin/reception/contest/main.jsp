<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var receptionList;
	$(document).ready(function() {
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/reception/search/paging' />");
		comAjax.setCallback(searchListCB);

		if ( gfn_isNull($("#search_reception_from_date").val()) == true && gfn_isNull($("#search_reception_to_date").val()) == false ) {
			alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#search_reception_from_date").val()) == false && gfn_isNull($("#search_reception_to_date").val()) == true) {
			alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#search_reception_from_date").val()) == false && gfn_isNull($("#search_reception_to_date").val()) == false) {
			if ( $("#search_reception_from_date").val() > $("#search_reception_to_date").val()) {
				alert("시작 접수일이 종료 접수일보다 앞선 날짜 입니다. 다시 선택해 주시기 바랍니다.");
				return;
			} else {
				comAjax.addParam("reception_from_date", $("#search_reception_from_date").val());
				comAjax.addParam("reception_to_date", $("#search_reception_to_date").val());
			}
		}

		comAjax.addParam("announcement_type", "D0000003");
		comAjax.addParam("announcement_name", $("#search_announcement_name").val());
		comAjax.addParam("institution_name", $("#search_institution_name").val());
		comAjax.addParam("reception_reg_number", $("#search_reception_reg_number").val());
		comAjax.addParam("reception_status", $("#search_reception_status_selector").val());
		
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		comAjax.ajax();
	}


	function searchListCB(data) {
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			$("#search_count").html("&#91;총 <span class='font_blue'>" + total + "</span>건&#93;");
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPaging(params);

			receptionList = data.result_data;
			var count = 0;
			var index = 1;
			$.each(receptionList, function(key, value) {
				// 	D0000002 - 접수 신청 완료
				//	D0000011 - 접수 취소
				//	D0000012 - 접수 완료
				//	D0000013 - 반려
				//	D0000014 - 반려 - 재접수 불가
				//	기술 공고 이므로 위의 Status만 보이게 한다.
				if ( value.reception_status == "D0000002" || value.reception_status == "D0000011" || value.reception_status == "D0000012" ||
					 value.reception_status == "D0000013" || value.reception_status == "D0000014" ) {
					str += "<tr>";
					str += "	<td>" + index + "</td>";
					str += "	<td class='announcement_name'><a href='/admin/fwd/reception/match/announcementDetail?announcement_id=" + value.announcement_id + "'>" + value.announcement_title + "</td>";
					str += "	<td class='announcement_name'>" + value.tech_info_name + "</td>";
					str += "	<td><span>" + value.receipt_from + " ~ " + value.receipt_to + "</span></td>";
					str += "	<td><span>" + value.reg_date + "</span></td>";
					str += "	<td><span>" + value.reception_reg_number + "</span></td>";
					str += "	<td>" + value.institution_name + "</td>";

					// D0000002 - 접수 신청서 작성 완료 상태이므로 관리자 입장에서는 접수 신청이다.
					if (value.reception_status == "D0000002" ) {
						str += "	<td><a href='/admin/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_waiting2'>접수신청</span></a></td>";
					}
					if (value.reception_status == "D0000011" ) {
						str += "	<td><a href='/admin/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_waiting'>접수취소</span></a></td>";
					}
					if (value.reception_status == "D0000012" ) {
						str += "	<td><a href='/admin/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_completed2'>접수완료</span></a></td>";
					}
					if (value.reception_status == "D0000013" || value.reception_status == "D0000014") {
						str += "	<td><a href='/admin/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "' class='reception_rejected_btn gray_btn2'>반려</a></td>";
					}

					count++;
					index++;
				}
				
			});
			body.append(str);

			$("#search_count").html("&#91;총 <span class='font_blue'>" + count + "</span>건&#93;");
		}
	}


	function downloadExcelFile() {
		if (confirm('다운로드하시겠습니까?')) {
			location.href = "/admin/api/reception/excelDownload?announcement_type=D0000003";
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
			       <h2 class="title">접수관리</h2>
			   </div>
	                 <!--// 레프트 메뉴 서브 타이틀 -->					   
			   <div class="lnb_menu_area">	
			       <ul class="lnb_menu">
				       <li class="on"><a href="/admin/fwd/reception/main" title="접수관리">접수관리</a></li>
					   <li class="menu2depth">
						   	<ul>
							   <li><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
							   <li  class="active"><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
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
					   <li>접수관리</li>
					   <li><strong>기술공고</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				   <h3 class="title_area">기술공고</h3>
				  <!--//페이지타이틀-->
			    </div>
		   </div>
		   
           <div class="contents_view">                           
				<h4 class="sub_title_h4 mb10">접수 목록</h4>    
		        <!--접수 목록-->
			    <div class="list_search_top_area">							   
				    <ul class="clearfix list_search_top2">
					    <li class="clearfix">
						    <label for="list_search_reception_type" class="fl list_search_title ta_r mr10 w_8">공고명</label>
						    <input type="text" id="search_announcement_name" class="form-control w_18" />
					    </li>
						<li class="clearfix">
						    <label for="search_reception_date" class="fl list_search_title ta_r mr10 w_8">접수일</label>									
						    <div class="datepicker_area fl">
							    <input type="text" id="search_reception_from_date" class="datepicker form-control w_14" placeholder="시작일" />					
						    </div>
							<span class="fl ml5 mr5 mt5">~</span>
						    <div class="datepicker_area fl mr20">
							    <input type="text" id="search_reception_to_date" class="datepicker form-control w_14" placeholder="종료일" />
						    </div>                                        
						</li>
						<li class="clearfix">
							<label for="search_institution_name" class="fl list_search_title ta_r mr10 w_8">기관명</label>
							<input type="text" id="search_institution_name" class="form-control brc-on-focusd-inline-block fl list_search_word_input w_18" />
						</li>
					</ul>
					<ul class="clearfix list_search_top2">
	
					    <li class="clearfix">
							<label for="search_reception_reg_number" class="fl list_search_title ta_r mr10 w_8">접수번호</label>
							<input type="text" id="search_reception_reg_number" class="form-control brc-on-focusd-inline-block fl list_search_word_input w_18"  />
						</li>																	
						<li class="clearfix">
							<label for="list_search_reception_condition" class="fl list_search_title ta_r mr10 w_8">접수상태</label>
							<select name="list_search_reception_condition" id="search_reception_status_selector" class="ace-select fl w_18">
							   	<option value="">전체</option>
					          	<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.master_id == 'M0000014' && (code.detail_id == 'D0000002' || code.detail_id == 'D0000011' || code.detail_id == 'D0000012' || code.detail_id == 'D0000013' || code.detail_id == 'D0000014' ) }" >
										<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
									</c:if>
								</c:forEach>
							</select>
						</li>								    
				    </ul>								
					<div class="list_search_btn clearfix"><button type="submit" class="blue_btn fr" onclick="searchList(1);">조회</button></div>
			    </div>
			    <!--//리스트 상단 검색-->

			    <!--검색 결과-->
			    <div class="list_search_table">
				    <div class="table_count_area">
					    <div class="count_area clearfix">
						    <div class="clearfix">
								<div class="fl mt5" id="search_count">								   
									&#91;총 <span class="font_blue">0</span>건&#93;
								</div>
								<div class="fr">
								    <div class="download fr green_btn"><a href="javascript:downloadExcelFile();" class="ex_down">엑셀 다운로드</a></div>					
						        </div>							   
					        </div>							   
				        </div>
				        <div style="overflow-x:auto;">
						   <table class="list th_c">
							   <caption>접수 목록</caption>     
							   <colgroup>
								   <col style="width:5%" />
								   <col style="width:23%" />
								   <col style="width:23%" />
								   <col style="width:15%" />
								   <col style="width:6%" />
								   <col style="width:6%" />
								   <col style="width:14%" />
								   <col style="width:8%" />
							   </colgroup>
							   <thead>
								   <tr>
									   <th scope="col">번호</th>
									   <th scope="col">공고명</th>
									   <th scope="col">기술명</th>
									   <th scope="col">접수기간</th>
									   <th scope="col">접수일</th>
									   <th scope="col">접수번호</th>
									   <th scope="col">기관명</th>
									   <th scope="col">접수상태</th>
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
						<!--//페이지 네비게이션-->
						
					</div>
					<!--//list_search_table-->
			    </div><!--content view-->
		   </div>
			<!--//contents--> 
	   </div>
   		<!--//sub--> 
	</div>
</div>
<!--//container-->
