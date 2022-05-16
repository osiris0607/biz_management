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
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area clearfix">
				<h3 class="hidden">기관정보관리</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>마이페이지</li>
						<li>기관정보관리</li>
					</ul>
				</div>
				<div id="lnb" class="fl">
					<!-- lnb_area -->	
					<div class="lnb_area">
						<!-- lnb_title_area -->	
						<div class="lnb_title_area">
							<h2 class="title">마이페이지</h2>
						</div>
						<!--// lnb_title_area -->
						<!-- lnb_menu_area -->
						<div class="lnb_menu_area">
							<!-- lnb_menu -->	
							<ul class="lnb_menu">
								<li>
									<a href="/member/fwd/mypage/institution" title="기관정보관리"><span>기관정보관리</span></a>									
								</li>
								<li>
									<a href="/member/fwd/mypage/main" title="개인정보관리 페이지로 이동"><span>개인정보관리</span></a>									
								</li>
								<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/expert" title="전문가 참여 현황" ><span>전문가 참여 현황</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="평가위원정보관리" ><span>평가위원 정보 관리</span></a>				
									</li>
								</sec:authorize>
								<li>
									<a href="/member/fwd/mypage/report" title="나의 수행과제 현황 관리 페이지로 이동" class="active"><span>나의 수행과제 현황 관리</span></a>									
								</li>											
							</ul>
							<!--// lnb_menu -->
						</div><!--//lnb_menu_area-->
					</div><!--//lnb_area-->
				</div>
				<!--//lnb-->
				<div class="sub_right_contents fl">
					<h3>나의 수행과제 현황 관리</h3>				
					<h4>사업 수행 관리</h4>
					<!--사업 수행 현황-->
					<div class="table_area">
						<table class="write fixed">
							<caption>연구책임자 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 30%;">
								<col style="width: 20%;">
								<col style="width: 30%;">
							</colgroup>
							<tbody>
								<tr>
								    <th scope="col"><label for="reception_reg_number">접수번호</label></th>
								    <td><input disabled type="text" id="reception_reg_number" class="form-control w100 ls"/></td>		    
								    <th scope="col"><label for="announcement_business_name">사업명</label></th>
								    <td><input disabled type="text" id="announcement_business_name" class="form-control w100"/></td> 
							    </tr>
							    <tr>
								    <th scope="col"><label for="announcement_title">공고명</label></th>
								    <td colspan="3" class="ta_c">
								    	<input disabled type="text" id="announcement_title" class="form-control w100" />
							    	</td> 
							    </tr>
								<tr>
								    <th scope="col"><label for="researcher_institution_name">기관명</label></th>
								    <td><input disabled type="text" id="researcher_institution_name" class="form-control w100"  /></td> 				   
								    <th scope="col"><label for="institution_reg_number">사업자등록번호</label></th>
								    <td><input disabled type="text" id="institution_reg_number" class="form-control w100 ls" /></td> 
							    </tr>
								<tr>
								    <th scope="col"><label for="researcher_name">연구책임자 성명</label></th>
								    <td><input disabled type="text" id="researcher_name" maxlength="3" class="form-control w100" /></td>   
								    <th scope="col"><label for="researcher_institution_department">연구책임자 부서/직책</label></th>
								    <td><input disabled type="text" id="researcher_institution_department" class="form-control w100" /></td> 
							    </tr>
								<tr>
								    <th scope="col"><label for="researcher_mobile_phone">연구책임자 휴대전화</label></th>
								    <td><input disabled type="text" id="researcher_mobile_phone" class="form-control w100 ls" /></td> 
									<th scope="col"><label for="researcher_email">연구책임자 이메일</label></th>
								    <td><input disabled type="text" id="researcher_email" class="form-control w100 ls" /></td> 
							    </tr>
							 </tbody>									 
						</table>
					</div><!--//table_area-->	
					<!--//사업 수행 현황-->
					<!---협약 변경 이력-->
					<h4>협약 변경 이력</h4>	
					<div class="table_area">
						<table class="list fixed">
							<caption>나의 접수 과제 목록</caption>
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
									<th scope="col" class="first">번호</th>
									<th scope="col">변경내용</th>
									<th scope="col">변경요청일</th>
									<th scope="col">변경승인일</th>
									<th scope="col">상태</th>
									<th scope="col" class="last">비고</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="first">1</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">제출</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">2</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">제출</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">3</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">제출</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">4</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_yellow">제출</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">5</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_blue">승인</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">6</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_blue">승인</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
								<tr>
									<td class="first">7</td>
									<td><span>참여연구원</span></td>
									<td><span>&nbsp;</span></td>
									<td><span>&nbsp;</span></td>
									<td><span class="font_blue">승인</span></td>
									<td class="last"><span>&nbsp;</span></td>												
								</tr>
							</tbody>
						</table>
						<!--div class="data_null ta_c">조회된 내용이 없습니다.</div-->
						<div class="paging_area">
							<a href="" class="stimg" title="맨처음 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_first.png" alt="맨처음 페이지로 이동"></a>
							<a href="" class="stimg" title="전 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_prev.png" alt="전 페이지로 이동"></a>
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
							<a href="" class="stimg" title="다음 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_next.png" alt="다음 페이지로 이동"></a>
							<a href="" class="stimg" title="맨마지막 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_last.png" alt="맨마지막 페이지로 이동"></a>
						</div>
					</div>
					<!---//협약 변경 이력-->
					
					<!---참여연구원 정보-->
					<h4>참여연구원 정보</h4>	
					<div class="table_area">
						<table class="list fixed">
							<caption>참여연구원 정보</caption>
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
									<th scope="col" class="first">번호</th>
									<th scope="col">성명</th>
									<th scope="col">생년월일</th>
									<th scope="col">휴대전화</th>
									<th scope="col">이메일</th>
									<th scope="col">참여율</th>
									<th scope="col">참여시작일</th>
									<th scope="col">참여종료일</th>
									<th scope="col" class="last">비고</th>
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
						<!--div class="data_null ta_c">조회된 내용이 없습니다.</div-->
						<div class="paging_area">
							<a href="" class="stimg" title="맨처음 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_first.png" alt="맨처음 페이지로 이동"></a>
							<a href="" class="stimg" title="전 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_prev.png" alt="전 페이지로 이동"></a>
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
							<a href="" class="stimg" title="다음 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_next.png" alt="다음 페이지로 이동"></a>
							<a href="" class="stimg" title="맨마지막 페이지로 이동"><img src="/assets/user/images/icon/btn_paging_last.png" alt="맨마지막 페이지로 이동"></a>
						</div>
					</div><!--//table_area-->
					<!---//참여연구원 정보-->

					<!--연구비 정보-->
					<h4>연구비 정보</h4>
					<div class="table_area">
						<table class="write fixed money_table">
							<caption>연구비 정보</caption>
							<colgroup>
								<col style="width: 50%;">
								<col style="width: 50%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">비목</th>
									<th scope="col">금액</th>
								</tr>
							</thead>
							<tbody>											
								<tr>
								    <th scope="row" class="ta_c">인건비</th>
								    <th scope="col"><span>&nbsp;</span></th> 
							    </tr>
							    <tr>
								    <th scope="row" class="ta_c">내부인건비</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">외부인건비</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">경비</th>
								    <th scope="col"><span>&nbsp;</span></th> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">연구장비/재료비</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">연구활동비</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">위탁사업비</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">성과장려비</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
								<tr>
								    <th scope="row" class="ta_c">간접비</th>
								    <th scope="col"><span>&nbsp;</span></th> 
							    </tr>
							 </tbody>	
							 <tfoot>
								<tr>
								    <th scope="row" class="ta_c">합계</th>
								    <td><span>&nbsp;</span></td> 
							    </tr>
							 </tfoot>
						</table>
					</div><!--//table_area-->	
					<div class="fr mt10">
						<button type="button" class="gray_btn mb5" title="목록 페이지 바로가기" onclick="location.href='/member/fwd/mypage/report'">목록</button>
					</div>
				</div><!--//sub_right_contents-->
			</div><!--//content_area-->
		</div><!--//sub_contents-->

	</section><!--//content-->
</div>
 
 
<!--공통 팝업-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>
