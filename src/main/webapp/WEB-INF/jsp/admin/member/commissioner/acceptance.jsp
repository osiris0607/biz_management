<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
  
<script type='text/javascript'>
	$(document).ready(function() {
		$("#email_receiver").val($("#email").val());
	});

	function sendEmail() {
		var chkVal = ["email_receiver", "email_title", "email_comment", "email_sender"];

		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		} 

		var formData = new FormData();
		formData.append("member_id", $("#member_id").val());
		formData.append("title", $("#email_title").val());
		formData.append("comment", $("#email_comment").val());
		formData.append("sender", $("#email_sender").val());
		
		var toMailList = new Array();
		toMailList.push($("#email_receiver").val());
		formData.append("to_mail", toMailList);
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/member/commissioner/send/email",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	alert("메일 전송에 성공하였습니다.");
		        	location.href='/admin/fwd/member/commissioner/main';
		        } else {
		        	alert("메일 전송에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function moveDetail(){
		location.href="/admin/fwd/member/commissioner/detail?member_id=" + $("#member_id").val();
	}
	
</script>

<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />
<input type="hidden" id="email" name="email" value="${vo.email}" />	
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
					    <div class="contents_view sub_view">
							
						   <!--이메일-->
						   <div class="allWrap clearfix">
						       <div class="tabBox">
									<p class="tab-link current" data-tab="tab-1">이메일</p>
									<!--<p class="tab-link" data-tab="tab-2">SMS</p>-->
							   </div>
							   <div id="tab-1" class="tab-content current">							  
							       <table class="list2 font_white tbody_t">
								       <caption>이메일</caption> 
								       <colgroup>
									       <col style="width: 10%">
									       <col style="width: 10%">
									       <col style="width: 80%">
								       </colgroup>
								       <tbody>									   	   
										   <tr>
												<td rowspan="4" class="b_e">평가위원 승인<br> 안내 발송</td>
										        <td class="b_e"><span class="necessary_icon">*</span><label for="email_receiver">수신자</label></td>
										        <td><input type="text" title="수신자" class="form-control w100" id="email_receiver" /></td> 
									       </tr>
										   <tr>									        
												<td class="b_e"><span class="necessary_icon">*</span><label for="email_title">발송제목</label></td>
										        <td><input type="text" title="발송제목" class="form-control w100" id="email_title"></td> 
									       </tr>
									       <tr>
										       <td class="b_e"><span class="necessary_icon">*</span><label for="email_comment">발송문구</label></td>
										       <td><textarea rows="10" title="발송문구" id="email_comment" class="w100"></textarea></td> 
									       </tr>									       
									       <tr>
										       <td class="b_e"><span class="necessary_icon">*</span><label for="email_sender">발신자</label></td>
										       <td><input type="text" title="발신자" id="email_sender" class="form-control w100"></td> 
									       </tr>	
									   </tbody>									   
							       </table>	
								   <!--발송내역-->
								   
								   <div class="clearfix"> 
									   <div class="fl mt30">
										   <button type="button" class="gray_btn2 fl mr5 back_btn" onclick="moveDetail();">뒤로</button>
									   </div>
									   <div class="fr clearfix mt30">										   
										   <!--<button type="button" class="blue_btn2 fl mr5 send_save_popup_preview_open">미리보기</button>-->
										   <button type="button" onclick="sendEmail();" class="blue_btn fl send_email_popup_open_btn mr5 mail_btn">이메일 발송</button>
										   <button type="button" class="blue_btn fl expertintention_smssend_popup_open sms_btn mr5">SMS 보내기</button>
										   <button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/member/commissioner/main'">목록</button>
									   </div>
								   </div>
						       </div>
						       <!--//이메일-->

						       <!--sms-->
						       <!--<div id="tab-2" class="tab-content">							  
							       <table class="list2 font_white tbody_t">
								       <caption>이메일</caption> 
								       <colgroup>
									       <col style="width: 10%">
									       <col style="width: 10%">
									       <col style="width: 80%">
								       </colgroup>
								       <tbody>
										       <td rowspan="4" class="b_e">평가위원 승인<br> 안내 발송</td>
										       <td class="b_e"><label for="sms_send_receiver">수신자</label></td>
										        <td><input type="text" class="form-control w100" id="sms_send_receiver" /></td> 
									       </tr>
										   <tr>
										       <td class="b_e"><label for="send_sms_title">발송제목</label></td>
										       <td><input type="text" class="form-control w100" id="send_sms_title"></td> 
									       </tr>
									       <tr>
										       <td class="b_e"><label for="send_sms_text">발송문구</label></td>
										       <td><textarea rows="10" id="send_sms_text" class="w100"></textarea></td> 
									       </tr>									      
									       <tr>
										       <td class="b_e"><label for="send_sms_caller">발신자</label></td>
										       <td><input type="text" id="send_sms_caller" class="form-control w100"></td> 
									       </tr>	
									   </tbody>									   
							       </table>	

								   <div class="clearfix"> 
									   <div class="fl mt30">
										   <button type="button" class="gray_btn2 fl mr5 back_btn" onclick="location.href='./member_agreement_view.html'">뒤로</button>
									   </div>
									   <div class="fr clearfix mt30">										   
										   <!--<button type="button" class="blue_btn2 fl mr5 send_save_popup_preview_open">미리보기</button>
										   <button type="button" class="blue_btn fl  send_sms_popup_open_btn mr5 sms_btn">SMS 발송</button>
										   <button type="button" class="gray_btn2 fl" onclick="location.href='./member_agreement.html'">목록</button>
									   </div>
								   </div>
						       </div>-->
							   <!--//sms-->
						   </div>
					   </div>
                   </div>
				   <!--//contents--> 
                </div>
                <!--//sub--> 
            </div>
            
            
            
            
            
            
            
<!--이메일 발송 팝업-->
  	<div class="send_email_popup_box">
	   <div class="popup_bg"></div>
	   <div class="send_email_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">이메일 발송 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
		   		<div class="popup_txt"><span>[알림]</span>
				   <p class="font_w">이메일 발송</p>
				   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 작성하신 내용으로 <span class="font_blue" style="display:inline-block">email</span>이 발송됩니다.<br>발송하시겠습니까?</p>
			    </div>			   	   
			    <div class="popup_button_area_center">
				   <button type="button" class="blue_btn mr5 ok_btn">발송하기</button>
				   <button type="button" class="gray_btn popup_close_btn">취소</button>
			    </div>				   
		   </div>
	   </div>
   </div>
   <!--//이메일 발송 팝업-->

   <!--sms 발송 팝업-->
   <div class="send_sms_popup_box">
	   <div class="popup_bg"></div>
	   <div class="send_sms_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">SMS 발송 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
		   	   <div class="popup_txt"><span>[알림]</span>
				   <p class="font_w">SMS 발송</p>
				   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 작성하신 내용으로 <span class="font_blue" style="display:inline-block">SMS</span> 메세지가 발송됩니다.<br>발송하시겠습니까?</p>
			   </div>			   	   
			   <div class="popup_button_area_center">
				   <button type="button" class="blue_btn mr5 ok_btn">발송하기</button>
				   <button type="button" class="gray_btn popup_close_btn">취소</button>
			   </div>			 					
		   </div>
	   </div>
   </div>
   <!--//sms 발송 팝업-->            