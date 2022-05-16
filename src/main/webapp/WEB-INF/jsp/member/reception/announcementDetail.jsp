<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	
	$(document).ready(function() {
						
		getDetail();
		
	});

	function getDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/announcement/detail'/>");
		comAjax.setCallback(getDetailCB);
		comAjax.addParam("announcement_id", $("#announcement_id").val());
		comAjax.ajax();
	}
	
	function getDetailCB(data){
		
		$("#title").text(data.result.title) ;
		$("#type").html(data.result.type_name) ;

		$("#hits").text(data.result.hits);
		$("#register").text(data.result.register);
		$("#reg_date").text(data.result.reg_date);
		$("#business_name").text(data.result.business_name);
		$("#manager").text(data.result.manager);
		$("#manager_dept").text(data.result.manager_dept);
		$("#manager_job_title").text(data.result.manager_job_title);
		$("#manager_phone").text(data.result.manager_phone);
		$("#manager_mail").text(data.result.manager_mail);
		$("#receipt_from").text(data.result.receipt_from);
		$("#receipt_to").text(data.result.receipt_to);
		$("#contents").html(unescapeHtml(data.result.contents));

		var uploadFiles = $("#upload_files");
		var index = 1;
		var str = "";

		if (data.result.type == "D0000001") {
			str += "<dt class='adt'><span>첨부파일(기술컨설팅)</span></dt>";
		}
		else if (data.result.type == "D0000002") {
			str += "<dt class='adt'><span>첨부파일(기술연구개발)</span></dt>";
		}
		else {
			str += "<dt class='adt'><span>첨부파일(" + data.result.type_name + ")</span></dt>";
		}

		str += "	<dd class='add'>";
		if ( data.result.return_upload_files != null) {
			$.each(data.result.return_upload_files, function(key, value) {
				str += "		<a href='/member/api/announcement/download/" + value.file_id + "' download>";
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
				if (index != data.result.return_upload_files.length) {
					str += "<br />";
				}
				index++;
			});
		}
		str += "	</dd>";
		uploadFiles.append(str);
	}


</script>

<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>공고</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>공고</li>
						<li>공고</li>
					</ul>
				</div>
				<div class="content_area">
					<h4>공고 정보</h4>
					<table class="table_view reception_info_step_table_view" style="width: 100%;">
						<caption>공고정보</caption> 
						<thead>
							<tr>
								<th scope="row" id="title">2021년 신기술접수소 기술매칭(기술컨설팅) 공고</th>
							</tr>
							<tr>
							   <td>
								   <dl class="answer">
									  <dt class="adt"><span>구분</span></dt>
									  <dd class="add"><span class="fl mr5" id="type"></span>
								   </dl>                                    
							   </td> 
						    </tr>
							<tr>
								<td>
								   <dl class="answer">
									  <dt class="adt"><span>조회수</span></dt>
									  <dd class="add ls" id="hits">600</dd>
									  <dt class="adt"><span>작성자</span></dt>
									  <dd class="add" id="register">홍길동</dd>
									  <dt class="adt"><span>작성일</span></dt>
									  <dd class="add ls" id="reg_date">2021-01-10</dd>
								  </dl>                                    
								</td> 
							</tr>
							<tr>
							   <td>
								   <dl class="answer">
									  <dt class="adt"><span>사업명</span></dt>
									  <dd class="add" id="business_name">사업명사업명사업명사업명사업명사업명사업명사업명</dd>
								   </dl>                                    
							   </td> 
						   </tr>
						   <tr>
							   <td>
								   <dl class="answer">										  
									  <dt class="adt"><span>담당자</span></dt>
									  <dd class="add" id="manager">홍길동</dd>
									  <dt class="adt"><span>담당자 부서</span></dt>
									  <dd class="add" id="manager_dept">담당자 부서 담당자 부서</dd>
									  <dt class="adt"><span>담당자 직책</span></dt>
									  <dd class="add" id="manager_job_title">담당자 직책</dd>
									  <dt class="adt"><span>담당자 전화</span></dt>
									  <dd class="add ls" id="manager_phone">010-5654-5684</dd>
									  <dt class="adt"><span>담당자 이메일</span></dt>
									  <dd class="add ls" id="manager_mail">dsldkslkd@sddj.com</dd>									  
								  </dl>                                    
							   </td> 
						   </tr>
						   <tr>
							   <td>
								   <dl class="answer">
									  <dt class="adt"><span>접수 시작일</span></dt>
									  <dd class="add ls" id="receipt_from">2021-02-16</dd>
									  <dt class="adt"><span>접수 종료일</span></dt>
									  <dd class="add ls" id="receipt_to">2021-02-26</dd>
								   </dl>                                    
							   </td> 
						   </tr>									   
					   </thead>
					   <tbody>
						   <tr>								   
							   <td>
							   <p style="line-height: 1.5;" id="contents"></p>  
							   </td> 
						   </tr>
						   <tr>
							   <td> 
								   <dl class="answer" id="upload_files">
			  					   </dl>
							   </td>
						   </tr>
					   </tbody>
				   </table>							   
				   <button type="button" class="gray_btn fr mt20 mr3 mb20" onclick="location.href='/member/fwd/reception/main'">목록</button>
				</div><!--content_area-->
			</div>
		</div><!--sub_contents-->
	</section>
</div>
 <!--//contents--> 
