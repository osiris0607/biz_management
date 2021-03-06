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
			var comment = $("#email_comment").val().replace(/(?:\r\n|\r|\n)/g, '<br>');
			formData.append("comment", comment);
			formData.append("link", $("#email_link").val());
			formData.append("sender", $("#email_sender").val());
			formData.append("type", saveType);
		} else {
			formData.append("title", $("#sms_title").val());
			var comment = $("#sms_comment").val().replace(/(?:\r\n|\r|\n)/g, '<br>');
			formData.append("comment", comment);
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
		            alert("?????? ???????????????.");
		            location.href = "/admin/fwd/reception/match/main";
		        } else {
		            alert("????????? ?????????????????????. ?????? ????????? ????????? ????????????.");
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
                <h2 class="hidden">????????? ??????</h2>
                <div class="sub">
                   <!--left menu ?????? ??????-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- ????????? ?????? ?????? ????????? -->	
					       <div class="lnb_title_area">
						       <h2 class="title">????????????</h2>
						   </div>
		                   <!--// ????????? ?????? ?????? ????????? -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="./reception.html" title="????????????">????????????</a></li>
								   <li class="menu2depth">
									   	<ul>
										   <li class="active"><a href="/admin/fwd/reception/match/main">????????????</a></li>
										   <li><a href="/admin/fwd/reception/contest/main">????????????</a></li>
										   <li><a href="/admin/fwd/reception/proposal/main">????????????</a></li>
								   		</ul>
								   </li>
							   </ul>				
						   </div>					
					   </div>			
				   </div>
				   <!--left menu ?????? ??????-->

				   <!--????????????-->
                   <div class="contents">
                       <div class="location_area">
					       <div class="location_division">
							   <!--????????? ??????-->
					           <ul class="location clearfix">
							       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>????????????</li>
								   <li><strong>????????????</strong></li>
							   </ul>	
							  <!--//????????? ??????-->
							  <!--??????????????????-->
							   <h3 class="title_area">????????????</h3>
							  <!--//??????????????????-->
						    </div>
					    </div>
					    <div class="contents_view">
						   <!--?????????-->
						   <div class="allWrap">
						       <div class="tabBox">
									<p class="tab-link current" data-tab="tab-1">?????????</p>
									<p class="tab-link"  data-tab="tab-2">SMS</p>
							   </div>
							   <div  id="tab-1" class="tab-content current">							  
							       <table class="list2 font_white tbody_t">
								       <caption>?????????</caption> 
								       <colgroup>
									       <col style="width: 10%" />
									       <col style="width: 10%" />
									       <col style="width: 80%" />
								       </colgroup>
								       <tbody>
										       <td rowspan="4" class="b_e">????????????<br />?????? ??????</td>
										       <td class="b_e"><span class="necessary_icon">*</span><label for="email_title">????????????</label></td>
										       <td><input type="text" class="form-control w100" id="email_title" /></td> 
									       </tr>										   
									       <tr>
										       <td class="b_e"><span class="necessary_icon">*</span><label for="email_comment">????????????</label></td>
										       <td><textarea rows="10" id="email_comment" class="w100"></textarea></td> 
									       </tr>
									       <tr>
										       <td class="b_e"><label for="email_link">?????? ??????</label></td>
										       <td><input type="text" id="email_link" class="form-control w100" /></td> 
									       </tr>
									       <tr>
										       <td class="b_e"><label for="email_sender">?????????</label></td>
										       <td><input type="text" id="email_sender" class="form-control w100" /></td> 
									       </tr>	
									   </tbody>									   
							       </table>	
							       <div class="fr clearfix mt30">
							           <button type="button" class="gray_btn fl mr5" onclick="history.back();">??????</button>
								       <button type="button" class="blue_btn fl send_save_popup_open" onclick="prepareRegistration('email');">??????</button>
							       </div>
						       </div>
						       <!--//?????????-->

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
										       <td  class="b_e" rowspan="4">????????????<br />?????? ??????</td>
										       <td  class="b_e"><label for="sms_title">????????????</label></td>
										       <td><input type="text" class="form-control w100" id="sms_title" /></td> 
									       </tr>
									       <tr>
										       <td  class="b_e"><label for="sms_comment">????????????</label></td>
										       <td><textarea rows="10" id="sms_comment" class="w100"></textarea></td> 
									       </tr>
									       <tr>
										       <td  class="b_e"><label for="sms_link">?????? ??????</label></td>
										       <td><input type="text" id="sms_link" class="form-control w100" /></td> 
									       </tr>
									       <tr>
										       <td  class="b_e"><label for="sms_sender">?????????</label></td>
										       <td><input type="text" id="sms_sender" class="form-control w100" /></td> 
									       </tr>	
									   </tbody>									   
							       </table>	
								   <div class="fr clearfix mt30">
								       <button type="button" class="gray_btn fl mr5" onclick="location.href='./reception_technologymatching.html'">??????</button>
								       <button type="button" class="blue_btn fl send_save_popup_open" onclick="prepareRegistration('sms');">??????</button>
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
            
            <!--?????? ??????-->
	   <div class="send_save_popup_box">
		   <div class="popup_bg"></div>
		   <div class="send_save_popup">
		       <div class="popup_titlebox clearfix">
			       <h4 class="fl">??????</h4>
			       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
			   </div>
			   <div class="popup_txt_area">
				   <p>???????????? ????????? <span class="font_blue">??????</span> ???????????????????</p>
				   <div class="popup_button_area_center">
					   <button type="button" class="blue_btn mr5" onclick="registration();">???</button>
					   <button type="button" class="gray_btn popup_close_btn">?????????</button>
				   </div>
			   </div>
		   </div>
	   </div>
	   <!--//?????? ??????-->
