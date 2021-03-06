<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var isModification = false;
	
	$(document).ready(function() {
		searchDetail();
	});

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/report/search/detail'/>");
		comAjax.setCallback(getSerarchDetailCB);
		var temp = $("#reception_id").val();
		comAjax.addParam("reception_id", $("#reception_id").val() );
		comAjax.ajax();
	}
	
	function getSerarchDetailCB(data){
		$("#reception_reg_number").val(data.result_data.reception_reg_number);
		$("#announcement_business_name").val(data.result_data.announcement_business_name);
		$("#announcement_title").val(data.result_data.announcement_title);
		$("#researcher_institution_name").val(data.result_data.researcher_institution_name);
		$("#researcher_name").val(data.result_data.researcher_name);
		$("#institution_reg_number").val(data.result_data.institution_reg_number);
		$("#researcher_institution_department").val(data.result_data.researcher_institution_department);
		$("#researcher_mobile_phone").val(data.result_data.researcher_mobile_phone);
		$("#researcher_email").val(data.result_data.researcher_email);
	}

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
		if ( isModification == true) {
			location.reload();
		}
	}

</script>

<!-- container -->
<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<div id="container" class="mb50">
	<h2 class="hidden">?????? ????????? ??????</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area clearfix">
				<h3 class="hidden">??????????????????</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">???</i></li>
						<li>???????????????</li>
						<li>??????????????????</li>
					</ul>
				</div>
				<div id="lnb" class="fl">
					<!-- lnb_area -->	
					<div class="lnb_area">
						<!-- lnb_title_area -->	
						<div class="lnb_title_area">
							<h2 class="title">???????????????</h2>
						</div>
						<!--// lnb_title_area -->
						<!-- lnb_menu_area -->
						<div class="lnb_menu_area">
							<!-- lnb_menu -->	
							<ul class="lnb_menu">
								<li>
									<a href="/member/fwd/mypage/institution" title="??????????????????"><span>??????????????????</span></a>									
								</li>
								<li>
									<a href="/member/fwd/mypage/main" title="?????????????????? ???????????? ??????"><span>??????????????????</span></a>									
								</li>
								<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/expert" title="????????? ?????? ??????" ><span>????????? ?????? ??????</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="????????????????????????" ><span>???????????? ?????? ??????</span></a>				
									</li>
								</sec:authorize>
								<li>
									<a href="/member/fwd/mypage/report" title="?????? ???????????? ?????? ?????? ???????????? ??????" class="active"><span>?????? ???????????? ?????? ??????</span></a>									
								</li>											
							</ul>
							<!--// lnb_menu -->
						</div><!--//lnb_menu_area-->
					</div><!--//lnb_area-->
				</div>
				<!--//lnb-->
				<div class="sub_right_contents fl">
					<h3>?????? ???????????? ?????? ??????</h3>				
					<h4>?????? ?????? ??????</h4>
					<!--?????? ?????? ??????-->
					<div class="table_area">
						<table class="write fixed">
							<caption>??????????????? ??????</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 30%;">
								<col style="width: 20%;">
								<col style="width: 30%;">
							</colgroup>
							<tbody>
								<tr>
								    <th scope="col"><label for="reception_reg_number">????????????</label></th>
								    <td><input disabled type="text" id="reception_reg_number" class="form-control w100 ls"/></td>		    
								    <th scope="col"><label for="announcement_business_name">?????????</label></th>
								    <td><input disabled type="text" id="announcement_business_name" class="form-control w100"/></td> 
							    </tr>
							    <tr>
								    <th scope="col"><label for="announcement_title">?????????</label></th>
								    <td colspan="3" class="ta_c">
								    	<input disabled type="text" id="announcement_title" class="form-control w100" />
							    	</td> 
							    </tr>
								<tr>
								    <th scope="col"><label for="researcher_institution_name">?????????</label></th>
								    <td><input disabled type="text" id="researcher_institution_name" class="form-control w100"  /></td> 				   
								    <th scope="col"><label for="institution_reg_number">?????????????????????</label></th>
								    <td><input disabled type="text" id="institution_reg_number" class="form-control w100 ls" /></td> 
							    </tr>
								<tr>
								    <th scope="col"><label for="researcher_name">??????????????? ??????</label></th>
								    <td><input disabled type="text" id="researcher_name" maxlength="3" class="form-control w100" /></td>   
								    <th scope="col"><label for="researcher_institution_department">??????????????? ??????/??????</label></th>
								    <td><input disabled type="text" id="researcher_institution_department" class="form-control w100" /></td> 
							    </tr>
								<tr>
								    <th scope="col"><label for="researcher_mobile_phone">??????????????? ????????????</label></th>
								    <td><input disabled type="text" id="researcher_mobile_phone" class="form-control w100 ls" /></td> 
									<th scope="col"><label for="researcher_email">??????????????? ?????????</label></th>
								    <td><input disabled type="text" id="researcher_email" class="form-control w100 ls" /></td> 
							    </tr>
							 </tbody>									 
						</table>
					</div><!--//table_area-->	
					<!--//?????? ?????? ??????-->
					<!---?????? ?????? ??????-->
					<h4>?????? ?????? ??????</h4>	
					<div class="table_area">
						<table class="list fixed">
							<caption>?????? ?????? ?????? ??????</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 15%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
								<col style="width: 20%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">??????</th>
									<th scope="col">????????????</th>
									<th scope="col">???????????????</th>
									<th scope="col">???????????????</th>
									<th scope="col">??????</th>
									<th scope="col" class="last">??????</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="first">1</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">2</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">3</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">4</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">5</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_blue">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">6</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_blue">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">7</td>
									<td><span>???????????????</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_blue">??????</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
							</tbody>
						</table>
						<!--div class="data_null ta_c">????????? ????????? ????????????.</div-->
						<div class="paging_area">
							<a href="" class="stimg" title="????????? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_first.png" alt="????????? ???????????? ??????"></a>
							<a href="" class="stimg" title="??? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_prev.png" alt="??? ???????????? ??????"></a>
							<strong>1</strong>
							<a href="">2</a>
							<a href="">3</a>
							<a href="">4</a>
							<a href="">5</a>
							<a href="">6</a>
							<a href="">7</a>
							<a href="">8</a>
							<a href="">9</a>
							<a href="">10</a>
							<a href="" class="stimg" title="?????? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_next.png" alt="?????? ???????????? ??????"></a>
							<a href="" class="stimg" title="???????????? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_last.png" alt="???????????? ???????????? ??????"></a>
						</div>
					</div>
					<!---//?????? ?????? ??????-->
					
					<!---??????????????? ??????-->
					<h4>??????????????? ??????</h4>	
					<div class="table_area">
						<table class="list fixed">
							<caption>??????????????? ??????</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">??????</th>
									<th scope="col">??????</th>
									<th scope="col">????????????</th>
									<th scope="col">????????????</th>
									<th scope="col">?????????</th>
									<th scope="col">?????????</th>
									<th scope="col">???????????????</th>
									<th scope="col">???????????????</th>
									<th scope="col" class="last">??????</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="first">1</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">2</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">3</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>											
								<tr>
									<td class="first">4</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">5</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">6</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">7</td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
							</tbody>
						</table>
						<!--div class="data_null ta_c">????????? ????????? ????????????.</div-->
						<div class="paging_area">
							<a href="" class="stimg" title="????????? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_first.png" alt="????????? ???????????? ??????"></a>
							<a href="" class="stimg" title="??? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_prev.png" alt="??? ???????????? ??????"></a>
							<strong>1</strong>
							<a href="">2</a>
							<a href="">3</a>
							<a href="">4</a>
							<a href="">5</a>
							<a href="">6</a>
							<a href="">7</a>
							<a href="">8</a>
							<a href="">9</a>
							<a href="">10</a>
							<a href="" class="stimg" title="?????? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_next.png" alt="?????? ???????????? ??????"></a>
							<a href="" class="stimg" title="???????????? ???????????? ??????"><img src="/assets/user/images/icon/btn_paging_last.png" alt="???????????? ???????????? ??????"></a>
						</div>
					</div><!--//table_area-->
					<!---//??????????????? ??????-->

					<!--????????? ??????-->
					<h4>????????? ??????</h4>
					<div class="table_area">
						<table class="write fixed money_table">
							<caption>????????? ??????</caption>
							<colgroup>
								<col style="width: 50%;">
								<col style="width: 50%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">??????</th>
									<th scope="col">??????</th>
								</tr>
							</thead>
							<tbody>											
								<tr>
								    <th scope="row" class="ta_c">?????????</th>
								    <th scope="col"><span>&nbsp;</span></th> 
							    </tr>
							    <tr>
								    <th scope="row" class="ta_c">???????????????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">???????????????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">??????</th>
								    <th scope="col"><span>&nbsp;</span></th> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">????????????/?????????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">???????????????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">???????????????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">???????????????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">?????????</th>
								    <th scope="col"><span>&nbsp;</span></th> 
							    </tr>
							 </tbody>	
							 <tfoot>
								<tr>
								    <th scope="row" class="ta_c">??????</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
							 </tfoot>
						</table>
					</div><!--//table_area-->	
					<div class="fr mt10">
						<button type="button" class="gray_btn mb5" title="?????? ????????? ????????????" onclick="location.href='/member/fwd/mypage/report'">??????</button>
					</div>
				</div><!--//sub_right_contents-->
			</div><!--//content_area-->
		</div><!--//sub_contents-->

	</section><!--//content-->
</div>
 
 
<!--?????? ??????-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="??????" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" title="??????" onclick="commonPopupConfirm();">??????</button>
			</div>
		</div>						
	</div> 
</div>
