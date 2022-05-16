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
		comAjax.setUrl("<c:url value='/admin/api/announcement/proposal/detail'/>");
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
		$("#business_name").text(unescapeHtml(data.result.business_name));
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
		
		str += "<dt class='adt'><span>첨부파일</span></dt>";
		str += "	<dd class='add'>";
		if ( data.result.return_upload_files != null) {
			$.each(data.result.return_upload_files, function(key, value) {
				str += "		<a href='/user/api/announcement/download/" + value.file_id + "' download>";
				var extName = value.name.split('.').pop().toLowerCase();
				if (extName == "hwp" ) {
					str += "	<img src='/assets/admin/images/icon_hwp.png' alt='hwp' />" + value.name;
				}
				else if (extName == "pdf" ) {
					str += "	<img src='/assets/admin/images/icon_pdf.png' alt='pdf' />" + value.name;
				}
				else if (extName == "xlsx" || extName == "xls" ) {
					str += "	<img src='/assets/admin/images/icon_xlsx.png' alt='xlsx' />" + value.name;
				}
				else if (extName == "ppt" || extName == "pptx") {
					str += "	<img src='/assets/admin/images/icon_ppt.png' alt='ppt' />" + value.name;
				}
				else if (extName == "zip" ) {
					str += "	<img src='/assets/admin/images/icon_zip.png' alt='zip' />" + value.name;
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
	
	function withdrawal() {
		if (confirm('삭제 하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/announcement/proposal/withdrawal",
			    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			    data : {
		    				"announcement_id" : $('#announcement_id').val()
		    		    },
			    success : function(data) {
			    	console.log(data.result);
		            if (data.result == 1) {
		            	alert("삭제 되었습니다.");
		            	location.href = "/admin/fwd/announcement/proposal/main";
		            }
		            else {
		            	alert("삭제 실패 했습니다.");
		            }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}
	
	function moveModification(){
		location.href = "/admin/fwd/announcement/proposal/modification?announcement_id=" + $("#announcement_id").val();
	}

</script>

<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />	
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
					   	   <li class="active"><a href="/admin/fwd/announcement/proposal/main">기술제안</a></li>
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
			       <li><a href="/admin/rdt/announcement/main"><i class="nav-icon fa fa-home"></i></a></li>
				   <li><strong>기술매칭</strong></li>
			   </ul>	
			  <!--//페이지 경로-->
			  <!--페이지타이틀-->
			   <h3 class="title_area">기술매칭</h3>
			  <!--//페이지타이틀-->
		    </div>
	   </div>
                   
       <div class="contents_view">
		   <!--공고관리 view-->
		   <div class="view_top_area clearfix">
			   <h4 class="fl sub_title_h4">공고정보</h4>
		   </div>
		   
		   <div class="contents_view">
		   <!--공고관리 view-->
		   <div class="view_top_area clearfix">
			   <h4 class="fl sub_title_h4">공고정보</h4>
		   </div>
		   
		   <div style="overflow-x:auto;">
	<table class="table_view">
	   <caption>공고정보</caption> 
	   <thead>
		   <tr>
			   <th scope="row" id="title">2021년 신기술접수소 기술매칭(기술컨설팅) 공고</th>
		   </tr>
		   <tr>
		      <td>
			      <dl class="answer">
					  <dt class="adt"><span>구분</span></dt>
					  <dd class="add" id="type">기술매칭<span >(기술컨설팅)</span></dd>											  
				  </dl>      
			  </td>
		   </tr>
		   <tr>
			   <td>
				   <dl class="answer">
					  <dt class="adt"><span>조회수</span></dt>
					  <dd class="add" id="hits">600</dd>
					  <dt class="adt"><span>작성자</span></dt>
					  <dd class="add" id="register">홍길동</dd>
					  <dt class="adt"><span>작성일</span></dt>
					  <dd class="add" id="reg_date">2021-01-10</dd>
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
					  <dd class="add" id="manager_dept">담당자 부서담당자 부서</dd>
					  <dt class="adt"><span>담당자 직책</span></dt>
					  <dd class="add" id="manager_job_title">담당자 직책</dd>
					  <dt class="adt"><span>담당자 전화</span></dt>
					  <dd class="add" id="manager_phone">010-5654-5684</dd>
					  <dt class="adt"><span>담당자 이메일</span></dt>
					  <dd class="add" id="manager_mail">dsldkslkd@sddj.com</dd>									  
				  </dl>                                    
			   </td> 
		   </tr>
		   <tr>
			   <td>
				   <dl class="answer">
					  <dt class="adt"><span>접수 시작일</span></dt>
					  <dd class="add" id="receipt_from">2021-02-16</dd>
					  <dt class="adt"><span>접수 종료일</span></dt>
					  <dd class="add" id="receipt_to">2021-02-26</dd>
				   </dl>                                    
			   </td> 
		   </tr>								   
	   </thead>
	   <tbody>
		   <tr>								   
			   <td>
					<p id="contents"></p>                                   
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
   		</div>
		   <!--//공고관리 view-->
		   <div class="fr mt30 clearfix">
		   	   <button type="button" class="gray_btn2 fl mr5" onclick="location.href='/admin/fwd/announcement/proposal/main'">목록</button>
		       <button type="button" class="blue_btn fl mr5" onclick="moveModification();">수정</button>
			   <button type="button" class="gray_btn fl" onclick="withdrawal();">삭제</button>
		   </div>
	    </div><!--content view-->
	   
               </div>
   <!--//contents--> 

            </div>
            <!--//sub--> 
        </div>
