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
		comAjax.setUrl("<c:url value='/admin/api/member/commissioner/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		comAjax.addParam("member_id", '${member_id}');
		comAjax.addParam("commissioner_status", $("#commissioner_status_selector option:selected").val());
		comAjax.addParam("name", $("#member_name").val());
		comAjax.addParam("update_date", $("#update_date").val());
		comAjax.addParam("institution_type", $("#institution_type_selector").val());
		comAjax.addParam("institution_name", $("#institution_name").val());
		
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

		   $("#search_count").html("&#91;총 <span class='font_blue'>" + total + "</span>건&#93;");
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				console.log("value:", value);
				str += "<tr>";
				str += "	<td>" + index + "</td>";
				str += "	<td>"+ value.institution_type_name + "</td>";
				str += "	<td>"+ value.institution_name + "</td>";
				str += "	<td>"+ value.name + "</td>";
				str += "	<td>"+ value.mobile_phone + "</td>";
				str += "	<td>"+ value.email + "</td>";
				str += "	<td>"+ value.rnd_class + "</td>";
				str += "	<td>"+ value.reg_date + "</td>";
				str += "	<td>"+ value.update_date + "</td>";
				str += "	<td><a href='/admin/fwd/member/commissioner/detail?member_id=" + value.member_id + "&commissioner_id=" + value.commissioner_id + "' class='link_text_underline'>" + value.commissioner_status_name + "</a></td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);
		}
	}

	function initSearch() {
		$("#member_name").val("");
		$("#update_date").val("");
		$("#institution_name").val("");
		$("#commissioner_status_selector option:eq(0)").prop("selected",true);
		$("#institution_type_selector option:eq(0)").prop("selected",true);
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
								   <li class="on"><a href="/admin/fwd/member/commissioner/main" title="평가위원">평가위원</a></li>
								   <li><a href="/admin/fwd/member/expert/main" title="전문가">전문가</a></li>
								   <li><a href="/admin/fwd/member/manager/main" title="관리자 or 내부평가위원">관리자 or 내부평가위원</a></li>
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
								   <li><strong>평가위원</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">평가위원</h3>
							  <!--//페이지타이틀-->
						    </div>
					    </div>

					   <!--리스트 상단 검색-->
					   <div class="contents_view">
						   <div class="list_search_top_area">
						   	   <ul class="clearfix list_search_top">
								   <li class="clearfix">                
									   <label for="member_list_search_merber_class" class="fl list_search_title ta_r mr10 w_8">등록 상태</label>
									   <select name="commissioner_status_selector" id="commissioner_status_selector" class="ace-select fl w_18">
										   <option value="">전체</option>
										   <option value="D0000002">등록대기</option>
										   <option value="D0000003">등록보류</option>
										   <option value="D0000004">등록완료</option>
									   </select>
								   </li>
								   <li class="clearfix">									   
									   <label for="agreement_myname" class="fl list_search_title ta_r mr10 w_8">이름</label>
									   <input type="text" id="member_name" class="form-control w_18">									   
								   </li>
								   <li class="clearfix">         
									   <label for="join_datepicker" class="fl list_search_title ta_r mr10 w_13">최근 수정일</label>								  
									   <div class="datepicker_area fl mr5 clearfix">
										   <input type="text" id="update_date" class="datepicker form-control w_14" />			   
									   </div>									  							   
								   </li>
								</ul>
								<ul class="clearfix list_search_top" style="margin-top: 2px;">
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
								   <li class="clearfix w_100">
										<label for="institution_name" class="fl list_search_title ta_r mr5 w_8">기관명</label>					
									    <input type="text" id="institution_name" class="form-control brc-on-focusd-inline-block fl list_search_word_input ml5" style="width: 70%;">
								   </li>
							   </ul>						   
							  
							   <div class="list_search_btn clearfix">								   
								   <button type="button" class="fr gray_btn" onclick="initSearch();">초기화</button>
								   <button type="submit" class="fr blue_btn mr5" onclick="searchList(1);">검색</button>
							   </div>
						   </div>
						   <!--//리스트 상단 검색-->

						   <!--검색 결과-->
						   <div class="list_search_table">
							   <div class="table_count_area count_area clearfix">
								   <div class="count_area fl" id="search_count"></div>
								   <div class="fr">									
										<div class="download fr green_btn"><a href="/admin/api/member/commissioner/excelDownload" class="ex_down">엑셀 다운로드</a></div>					
								   </div>
							   </div>
							   <div style="overflow-x:auto;">
								   <table class="list th_c">
									   <caption>리스트 화면</caption>  
									   <colgroup>
										   <col style="width:5%" />
										   <col style="width:7%" />
										   <col style="width:19%" />
										   <col style="width:8%" />
										   <col style="width:10%" />
										   <col style="width:15%" />
										   <col style="width:15%" />
										   <col style="width:7%" />
										   <col style="width:7%" />
										   <col style="width:7%" />
									   </colgroup>
									   <thead>
									   	   <tr>
											   <th scope="col" colspan="10">평가위원 정보</th>
										   </tr>
										   <tr>
										   	   <th scope="col">번호</th>
											   <th scope="col">기관유형</th>
											   <th scope="col">기관명</th>
											   <th scope="col">성명</th>
											   <th scope="col">휴대전화</th>
											   <th scope="col">이메일</th>
											   <th scope="col">연구분야</th>
											   <th scope="col">최초 등록일</th>
											   <th scope="col">최종 수정일</th>
											   <th scope="col">상태</th>										   
										   </tr>
									   </thead>
									   
									   
									   
									   
									   <tbody id="list_body">
									   </tbody>
								   </table>   
								   <!--//검색 결과-->                           
						   		</div>  
							   <!--페이지 네비게이션-->
							   
							   <!--페이지 네비게이션-->
							   <input type="hidden" id="pageIndex" name="pageIndex"/>
							   <div class="page" id="pageNavi"></div>  
						   </div>
						   <!--//list_search_table-->
						</div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
            
        
