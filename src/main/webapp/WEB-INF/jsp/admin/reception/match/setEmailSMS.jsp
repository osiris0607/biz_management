<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var saveType;

	$(document).ready(function() {
		searchDetail();
	});

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/reception/tech/match/emailSMS/detail");
		comAjax.setCallback(getDetailCB);
		comAjax.ajax();
	}


	function getDetailCB(data){
		$.each(data.result_data, function(key, value) {
			console.log('key, value setting', value);
			if (value.type == "email") {
				$("#email_title").val(value.title);
				$("#email_comment").val(unescapeHtml(value.comment));
				$("#email_link").val(value.link);
				$("#email_sender").val(value.sender);
			} else {
				$("#sms_title").val(value.title);
				$("#sms_comment").val(unescapeHtml(value.comment));
				$("#sms_link").val(value.link);
				$("#sms_sender").val(value.sender);
			}
		});
	}


	
	function prepareRegistration(type) {
		saveType = type;
	}

	function registration() {
		$('.send_save_popup_box').fadeOut(350);

		var formData = new FormData();
		if ( saveType == "email") {
			formData.append("title", $("#email_title").val());
			//var comment = $("#email_comment").val().replace(/(?:\r\n|\r|\n)/g, '<br>');
			
			//formData.append("comment", comment);
			formData.append("comment", $("#email_comment").val());
			formData.append("link", $("#email_link").val());
			formData.append("sender", $("#email_sender").val());
			formData.append("type", saveType);
		} else {
			formData.append("title", $("#sms_title").val());
			//문자메세지는 <br> 적용 X
			//var comment = $("#sms_comment").val().replace(/(?:\r\n|\r|\n)/g, '<br>');
			formData.append("comment", $("#sms_comment").val());
			formData.append("link", $("#sms_link").val());
			formData.append("sender", $("#sms_sender").val());
			formData.append("type", saveType);
		}

		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/tech/match/emailSMS/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		            alert("등록 되었습니다.");
		            location.href = "/admin/fwd/reception/match/main";
		        } else {
		            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

</script>

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
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
							       <li class="on"><a href="./reception.html" title="접수관리">접수관리</a></li>
								   <li class="menu2depth">
									   	<ul>
										   <li class="active"><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
										   <li><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
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
								   <li><strong>기술매칭</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">기술매칭</h3>
							  <!--//페이지타이틀-->
						    </div>
					    </div>
					    <div class="contents_view">
						   <!--이메일-->
						   <div class="allWrap">
						       <div class="tabBox">
									<p class="tab-link current" data-tab="tab-1">이메일</p>
									<p class="tab-link"  data-tab="tab-2">SMS</p>
							   </div>
							   <div  id="tab-1" class="tab-content current">							  
							       <table class="list2 font_white tbody_t">
								       <caption>이메일</caption> 
								       <colgroup>
									       <col style="width: 10%" />
									       <col style="width: 10%" />
									       <col style="width: 80%" />
								       </colgroup>
								       <tbody>
										       <td rowspan="4" class="b_e">평가위원<br />참여 요청</td>
										       <td class="b_e"><span class="necessary_icon">*</span><label for="email_title">발송제목</label></td>
										       <td><input type="text" class="form-control w100" id="email_title" /></td> 
									       </tr>										   
									       <tr>
										       <td class="b_e"><span class="necessary_icon">*</span><label for="email_comment">발송문구</label></td>
										       <td><textarea rows="10" id="email_comment" class="w100"></textarea></td> 
									       </tr>
									       <tr>
										       <td class="b_e"><label for="email_link">참여 링크</label></td>
										       <td><input type="text" id="email_link" class="form-control w100" /></td> 
									       </tr>
									       <tr>
										       <td class="b_e"><label for="email_sender">발신자</label></td>
										       <td><input type="text" id="email_sender" class="form-control w100" /></td> 
									       </tr>	
									   </tbody>									   
							       </table>	
							       <div class="fr clearfix mt30">
							           <button type="button" class="gray_btn fl mr5" onclick="history.back();">뒤로</button>
								       <button type="button" class="blue_btn fl send_save_popup_open" onclick="prepareRegistration('email');">저장</button>
							       </div>
						       </div>
						       <!--//이메일-->

						       <!--sms-->
						       <div  id="tab-2" class="tab-content">							  
							       <table class="list2 font_white tbody_t">
								       <caption>SMS</caption> 
								       <colgroup>
									       <col style="width: 10%" />
									       <col style="width: 10%" />
									       <col style="width: 80%" />
								       </colgroup>
								       <tbody>
										       <td  class="b_e" rowspan="4">평가위원<br />참여 요청</td>
										       <td  class="b_e"><label for="sms_title">발송제목</label></td>
										       <td><input type="text" class="form-control w100" id="sms_title" /></td> 
									       </tr>
									       <tr>
										       <td  class="b_e"><label for="sms_comment">발송문구</label></td>
										       <td><textarea rows="10" id="sms_comment" class="w100"></textarea></td> 
									       </tr>
									       <tr>
										       <td  class="b_e"><label for="sms_link">참여 링크</label></td>
										       <td><input type="text" id="sms_link" class="form-control w100" /></td> 
									       </tr>
									       <tr>
										       <td  class="b_e"><label for="sms_sender">발신자</label></td>
										       <td><input type="text" id="sms_sender" class="form-control w100" /></td> 
									       </tr>	
									   </tbody>									   
							       </table>	
								   <div class="fr clearfix mt30">
								       <button type="button" class="gray_btn fl mr5" onclick="history.back();">뒤로</button>
								       <button type="button" class="blue_btn fl send_save_popup_open" onclick="prepareRegistration('sms');">저장</button>
							       </div>
						       </div>
						       <!--//sms-->
                               
						   </div>
						   
					   </div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
            
            <!--저장 팝업-->
	   <div class="send_save_popup_box">
		   <div class="popup_bg"></div>
		   <div class="send_save_popup">
		       <div class="popup_titlebox clearfix">
			       <h4 class="fl">저장</h4>
			       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
			   </div>
			   <div class="popup_txt_area">
				   <p>작성하신 정보로 <span class="font_blue">저장</span> 하시겠습니까?</p>
				   <div class="popup_button_area_center">
					   <button type="button" class="blue_btn mr5" onclick="registration();">예</button>
					   <button type="button" class="gray_btn popup_close_btn">아니요</button>
				   </div>
			   </div>
		   </div>
	   </div>
	   <!--//저장 팝업-->
