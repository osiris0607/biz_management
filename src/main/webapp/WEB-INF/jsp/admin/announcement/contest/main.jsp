<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {

		$("#lately_week").change(function(){
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
	    });
		
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/announcement/contest/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "DATE DESC");

		// 기술공모의 공고 페이지이므로 type은 D0000003 로 고정
		comAjax.addParam("type", "D0000003");
		comAjax.addParam("process_status", $("#process_status option:selected").val());
		var temp = $("#manager_selector option:selected").val();
		comAjax.addParam("manager", $("#manager_selector option:selected").val());
		comAjax.addParam("receipt_from", $("#receipt_from").val());
		comAjax.addParam("receipt_to", $("#receipt_to").val());
		
		comAjax.ajax();
	}
	
	
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").text(total);
			$("#pageIndex").empty();

			// 담당자 Selector List
			$("#manager_selector").empty();
			var str = "<option value=''>선택</option>";
			$("#manager_selector").append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPaging(params);

			$("#search_count").text(total);

			var managerList = [];
			var index = 1;
			var str = "";
			$.each(data.result, function(key, value) {
				// 검색 시 담당자명의 Select List를 만들기 위해 중복 데이터를 제거한다.
				if(managerList.indexOf(value.manager) == -1 ){
					managerList.push(value.manager);
				}

				str += "<tr>";
				str += "	<td>" + index + "</td>";
				str += "	<td>"+ value.type_name + "</td>";
				str += "	<td><a href='/admin/fwd/announcement/contest/detail?announcement_id=" + value.announcement_id + "'><div class='txt_hidden'>" + value.title + "</div></a></td>";
				str += "	<td>"+ value.date +"</td>";
				str += "	<td>"+ value.receipt_from + " ~ " + value.receipt_to +"</td>";
				str += "	<td>"+ value.manager +"</td>";
				str += "	<td>"+ value.reg_date +"</td>";
				str += "	<td>"+ value.register +"</td>";

				// 작성중
				if ( value.process_status == "D0000001") {
					str += "	<td><a href='/admin/fwd/announcement/contest/modification?announcement_id=" + value.announcement_id + "'><span class='font_blue'>"+ value.status_name +"</span></a></td>";
					str += "	<td><span>&nbsp;</span></td>";
				}
				// 작성완료
				else if ( value.process_status == "D0000002") {
					str += "	<td><span class='gray_blue'>"+ value.status_name +"</span></td>";
					str += "	<td><span><button type='button' class='blue_btn' onclick='updateProcessStatus(\"" + value.announcement_id + "\", \"D0000003\");'>게시</button></span></td>";
				}
				// 개시중
				else if ( value.process_status == "D0000003") {
					str += "	<td><span class='font_yellow'>"+ value.status_name +"</span></td>";
					str += "	<td><span><button type='button' class='gray_btn2' onclick='updateProcessStatus(\"" + value.announcement_id + "\", \"D0000004\");'>게시해제</button></span></td>";
				}
				// 개시종료
				else {
					str += "	<td><span class='font_yellow'>"+ value.status_name +"</span></td>";
					str += "	<td><span><button type='button' class='blue_btn' onclick='updateProcessStatus(\"" + value.announcement_id + "\", \"D0000003\");'>게시</button></span></td>";
				}
				
				str += "</tr>";
	
				index++;
			});
			body.append(str);

			// 담당자 Selector List
			$("#manager_selector").empty();
			var str = "<option value=''>선택</option>";
			$.each(managerList, function(key, value) {
				str += "<option value='" + value + "'>" + value +"</option>";
			});
			$("#manager_selector").append(str);
		}
	}


	function updateProcessStatus(id, status) {
		var formData = new FormData();
		formData.append("announcement_id", id);
		formData.append("process_status", status);

		if (confirm('수정 하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/announcement/contest/update/processStatus",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == 1) {
			            alert("수정 되었습니다.");
			            location.href = "/admin/fwd/announcement/contest/main";
			        } else {
			            alert("수정에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
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
			       <h2 class="title">공고관리</h2>
			   </div>
                  <!--// 레프트 메뉴 서브 타이틀 -->
			   <div class="lnb_menu_area">	
			       <ul class="lnb_menu">
				       <li class="on"><a href="/admin/fwd/announcement/main" title="공고관리">공고관리</a></li>
					   <ul class="menu2depth">
					       <li><a href="/admin/fwd/announcement/match/main">기술매칭</a></li>
					   	   <li class="active"><a href="/admin/fwd/announcement/contest/main">기술공모</a></li>
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
					   <li><strong>기술공모</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				    <h3 class="title_area">기술공모</h3>
				  <!--//페이지타이틀-->
			    </div>
		   </div>
           <div class="contents_view">
		        <!--리스트 상단 검색-->
			    <div class="list_search_top_area clearfix">
				    <ul class="clearfix list_search_top fl">
					    <li class="clearfix">                
						    <label for="list_search_member_class" class="fl list_search_title mr10 w_8 ta_r">구분</label>
						    <select name="list-search-member-class" id="process_status" class="ace-select fl w_12" title="사업명">
							   	<option value="">전체</option>
					          	<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.master_id == 'M0000006'}">
										<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
									</c:if>
								</c:forEach>
						   </select>    
					    </li>
					    <li class="clearfix">
						    <label for="list_search_merber_type" class="fl w_8 mr10 ta_r list_search_title">담당자명</label>
						    <select name="list-search-member-type" id="manager_selector" class="ace-select fl w_12">
						    	<option value="">전체</option>
						    </select>
					    </li>
					    <li class="clearfix">         
						    <label for="join_datepicker" class="fl mr10 list_search_title w_8 ta_r">등록기간</label>
						    <div class="datepicker_area fl">
							    <input type="text" id="receipt_from" class="datepicker form-control w_12" placeholder="시작일" />
						    </div>
						    <span class="fl ml5 mr5 mt5">~</span>
						    <div class="datepicker_area fl">
							    <input type="text" id="receipt_to" class="datepicker form-control w_12" placeholder="종료일" />
						    </div>
					    </li> 
				     </ul>
			    	 <div class="clearfix fr">
						<button type="button" class="blue_btn fl mr25 mt10" onclick="searchList(1);">검색</button>
					 </div>
			    </div>
			    <!--//리스트 상단 검색-->

			    <!--검색 결과-->
			    <div class="list_search_table">
				    <div class="table_count_area">
					    <div class="count_area clearfix">
						    <div class="fl mt15">								   
						    &#91;총 <span class="font_blue" id="search_count">0</span>건&#93;
						    </div>
						    <div class="fr">
						    <button type="button" class="fr blue_btn2 mr3" onclick="location.href='/admin/fwd/announcement/contest/registration'">공고 등록</button>
						    </div>								   
					    </div>							   
				    </div>
				    <div style="overflow-x:auto;">
					   <table class="list th_c a_b">
						   <caption>공고 관리</caption>     
						   <colgroup>
							   <col style="width:5%" />
							   <col style="width:8%" />
							   <col style="width:23%" />
							   <col style="width:7%" />
							   <col style="width:15%" />
							   <col style="width:5%" />
							   <col style="width:10%" />
							   <col style="width:5%" />
							   <col style="width:8%" />
							   <col style="width:8%" />
						   </colgroup>
						   <thead>
							   <tr>
								   <th scope="col">번호</th>
								   <th scope="col">사업명</th>
								   <th scope="col">공고명</th>
								   <th scope="col">공고일</th>
								   <th scope="col">접수기간</th>
								   <th scope="col">담당자</th>
								   <th scope="col">등록일</th>
								   <th scope="col">등록자</th>
								   <th scope="col" colspan="2">상태</th>
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
<!--//container-->
            
        
