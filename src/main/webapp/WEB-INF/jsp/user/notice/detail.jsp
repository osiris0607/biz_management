<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
  
<script type='text/javascript'>
	$(document).ready(function() {
	 	getDetail();
	});
	
	
	function getDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/notice/detail'/>");
		comAjax.setCallback(getDetailCB);
		comAjax.addParam("notice_id", $("#notice_id").val());
		comAjax.ajax();
	}

	var uploaded_files = new Array();
	function getDetailCB(data){
		if ( data.result == false){
			alert("공지 사항 정보가 없습니다. 다시 시도해 주시기 바랍니다.");
			return;
		}
		
		$("#title").text(data.result_data.title);
		$("#reg_date").text(data.result_data.reg_date);
		$("#hits").text(data.result_data.hits);
		
		
		$("#explanation").html(unescapeHtml(data.result_data.explanation));
		$("#file_list").empty();
		var str = "";
	    if ( data.result_data.return_upload_files != null) {
	    	$.each(data.result_data.return_upload_files, function(key, value) {
				str += "		<a href='/user/api/announcement/download/" + value.file_id + "' download>";
				var extName = value.name.split('.').pop().toLowerCase();
				if (extName == "hwp" ) {
					str += "	<img src='/assets/user/images/icon/icon_hwp.png' alt='hwp' />" + value.name;
				}
				else if (extName == "pdf" ) {
					str += "	<img src='/assets/user/images/icon/icon_pdf.png' alt='pdf' />" + value.name;
				}
				else if (extName == "xlsx" || extName == "xls" ) {
					str += "	<img src='/assets/user/images/icon/icon_xlsx.png' alt='xlsx' />" + value.name;
				}
				else if (extName == "ppt" || extName == "pptx") {
					str += "	<img src='/assets/user/images/icon/icon_ppt.png' alt='ppt' />" + value.name;
				}
				else if (extName == "zip" ) {
					str += "	<img src='/assets/user/images/icon/icon_zip.png' alt='zip' />" + value.name;
				}
				else {
					str += value.name;
				}
				str += "</a>";
			});

	    	$("#file_list").append(str);
		}
	}
</script>

<input type="hidden" id="notice_id" name="notice_id" value="${vo.notice_id}" />
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>알림·정보</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>알림·정보</li>
					</ul>
				</div>
				<div class="content_area">
					<h4>알림·정보</h4>
					<table class="table_view reception_info_step_table_view">
						<caption>알림·정보</caption> 
						<thead>
							<tr>
								<th scope="row" id="title"></th>
							</tr>
							<tr>
								<td>
								   <dl class="answer">												  
<!-- 									  <dt class="adt"><span>작성자</span></dt>
									  <dd class="add"  id="writer">관리자</dd> -->
									  <dt class="adt"><span>작성일</span></dt>
									  <dd class="add ls" id="reg_date"></dd>
									  <dt class="adt"><span>조회수</span></dt>
									  <dd class="add ls" id="hits"></dd>
								  </dl>                                    
								</td> 
							</tr>								   
						    
					   </thead>
					   <tbody>
						   <tr>								   
							   <td>
									<p style="line-height: 1.5;" id="explanation"></p>                                   
							   </td> 
						   </tr>
						   <tr>
							   <td>
								   <dl class="answer">
									  <dt class="adt"><span>첨부파일</span></dt>
									  <dd class="add" id="file_list">
									      <a href="javascript:void(0);" download=""><img src="../images/icon/icon_hwp.png" alt="hwp"> 2021 신기술접수소 기술매칭(기술컨설팅).zip(503816KB)</a>
										  <a href="javascript:void(0);" download=""><img src="../images/icon/icon_pdf.png" alt="pdf"> 2021 신기술접수소 기술매칭(기술컨설팅).zip(503816KB)</a>
										  <a href="javascript:void(0);" download=""><img src="../images/icon/icon_xlsx.png" alt="xlsx"> 2021 신기술접수소 기술매칭(기술컨설팅).zip(503816KB)</a>
										  <a href="javascript:void(0);" download=""><img src="../images/icon//icon_ppt.png" alt="ppt"> 2021 신기술접수소 기술매칭(기술컨설팅).zip(503816KB)</a>
										  <a href="javascript:void(0);" download=""><img src="../images/icon/icon_zip.png" alt="zip"> 2021 신기술접수소 기술매칭(기술컨설팅).zip(503816KB)</a>
									  </dd>
								   </dl>
							   </td>
						   </tr>
					   </tbody>								   
				   </table>							   
				   <button type="button" class="gray_btn fr mt20 mr3 mb20" onclick="location.href='/user/fwd/notice/main'">목록</button>
				</div><!--content_area-->
			</div>
		</div><!--sub_contents-->
	</section>
</div>