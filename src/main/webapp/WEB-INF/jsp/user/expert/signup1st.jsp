<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="ie=edge" />
		<meta name="description" content="신기술접수소 사업평가관리시스템" />
		<meta name="keywords" content="신기술 접수소, 서울 신기술 사업평가관리" />
		<meta property="og:type" content="website" />
		<meta property="og:title" content="신기술접수소 사업평가관리시스템 사이트" />
		<meta property="og:url" content="" />
		<meta property="og:description" content="신기술접수소 사업평가관리시스템" />
		<title>신기술접수소 사업평가·관리 시스템</title>
		<link rel="stylesheet" type="text/css" href="/assets/user/css/style.css" />		
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/common/js/common_anchordata.js"></script>
	</head>
	
	
<script type='text/javascript'>

	var isNewSignup = true;
	
	$(document).ready(function() {
 		if ( gfn_isNull('${vo}') != true ) {
			var certAuthResult = '${vo.result}';
			if (certAuthResult != "Y") {
				alert("핸드폰 본인 인증에 실패했습니다. 다시 시도해 주시기 바랍니다.");
			}
		}
		
		$("#search_text").on("keydown", function(key) {
            //키의 코드가 13번일 경우 (13번은 엔터키)
            if (key.keyCode == 13) {
            	searchList();
            }
        });
	});
	
	function searchList() {
		if ( gfn_isNull($("#search_text").val()) == true ) {
			alert("검색어를 입력해주세요.");
			return;
		}
		
 		var comAjax = new ComAjax();
		comAjax.setUrl("/user/api/expert/search/all");
		comAjax.setCallback(searchListCB);
		comAjax.addParam($("#search_type_selector option:selected").val(), $("#search_text").val());
		comAjax.ajax(); 
	}
	

	var memberList;
	function searchListCB(data) {
		console.log(data);

		var body = $("#list_body");
		body.empty();
		if ( data.result == null || data.result.length == 0 ) {
			var str = "<tr>" + "<td colspan='7'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var str = "";
			var index = 0;
			memberList = data.result;
			$.each(data.result, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>";
				str += "		<input type='radio' id='checkbox" + index + "' class='fl checkbox_' name='check_member' value='" + value.member_seq + "'>";
				str += "		<label for='checkbox" + index + "' class='checkbox_label'>&nbsp;</label>";
				str += "	</td>";
				str += "	<td><span>" + value.university + "</span></td>";
				str += "	<td><span>" + value.department + "</span></td>";
				str += "	<td><span>" + value.name + "</span></td>";
				str += "	<td><span>" + value.research + "</span></td>";
				str += "	<td>";
				if ( gfn_isNull(value.large) == true ){
					str += "		<span class='d_ib'>" + "없음" + "</span> > ";
				}
				else {
					str += "		<span class='d_ib'>" + value.large + "</span> > ";
				}
				if ( gfn_isNull(value.middle) == true ){
					str += "		<span class='d_ib'>" + "없음" + "</span> > ";
				}
				else {
					str += "		<span class='d_ib'>" + value.middle + "</span> > ";
				}
				if ( gfn_isNull(value.small) == true ){
					str += "		<span class='d_ib'>" + "없음" + "</span> > ";
				}
				else {
					str += "		<span class='d_ib'>" + value.small + "</span> > ";
				}
				str += "	</td>";
				str += "	<td class='ls'><span>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</span></td>";

				if ( gfn_isNull(value.email) == false  ) {
					var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
					var mail =value.email.split("@")[1];
				 	userEmail= id+"@"+mail;
					
					str += "	<td class='last ls'><span>" + userEmail + "</span></td>";
				} else {
					str += "	<td class='last ls'><span></span></td>";
				}
				
				str += "</tr>";

				index++;
			});
			body.append(str);
		}
	}

	function prepareCertify(){
		if ( $(":input:radio[name=check_member]:checked").is(':checked') == false ) {
			alert("조회된 전문가 결과에서 본인 정보를 반드시 체크하여야 합니다.");
			return;
		}
		else {
			isNewSignup = false;
			$('.new_expert_box').css('display', 'block');		
		}
	}


	function certifyBizsiren() {
		var returnString = "";
		if (isNewSignup == false) {
			returnString = $(":input:radio[name=check_member]:checked").val();
		}
		
		$.ajax({
		    type : "POST",
		    url : "/user/api/expert/cert/bizsiren",
		    data : {extraVal : returnString },
		    async : false,
		    success : function(data) {
		    	requestBizsiren(data);
		    },
		    error : function(err) {
		    	alert(err);
		    }
		});
	}

	function requestBizsiren(data) {
		var PCC_window = window.open('', 'PCCV3Window', 'width=400, height=630, resizable=1, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200' );
	       
	   	// iframe형식으로 개발하시지 말아주십시오. iframe으로 개발 시 나오는 문제는 개발지원해드리지 않습니다.
       	if(PCC_window == null){ 
			 alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
        }

        //창을 오픈할때 크롬 및 익스플로어 양쪽 다 테스트 하시길 바랍니다.
	    var newForm = $('<form></form>'); 
	    //set attribute (form) 
	    newForm.attr("name","reqPCCForm"); 
	    newForm.attr("method","post"); 
	    newForm.attr("action","https://pcc.siren24.com/pcc_V3/jsp/pcc_V3_j10_v2.jsp"); 
	    newForm.attr("target","PCCV3Window");

 		// create element & set attribute (input) 
 		newForm.append($("<input type='hidden' name='reqInfo' value = '" + data.reqInfo + "'>"));
 		newForm.append($("<input type='hidden' name='retUrl' value='" + data.retUrl + "'>"));
 		newForm.append($("<input type='hidden' name='verSion' value='2'>"));

 		// append form (to body) 
 		newForm.appendTo('body'); 

 		// submit form 
 		newForm.submit();
	}
</script>

    <body>
        <div id="wrap">
			<div id="skip_nav">  
				<!--a href="#nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a-->
				<a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
			</div>
			<!--팝업-->
			<!--아이디 중복 팝업-->
			<div class="expert_certification_popup_box">
				<div class="popup_bg"></div>
				<div class="expert_certification_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl">본인인증 안내</h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
							<p tabindex="0"><span class="font_blue">본인 인증이</span> 완료되었습니다.</p>	
							<!--p tabindex="0">입력하신 <span class="font_blue">000</span> 아이디는 사용이 가능합니다.</p-->
						</div>						
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn popup_close_btn" title="확인" onclick="location.href='./expert_certification.html'">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--//아이디 중복 팝업-->
			<!--//팝업-->

			<div id="container">
				<div class="content_area login_area_box">
					<a href="/" title="신기술접수소 사업평가·관리 시스템 홈페이지 이동" class="logo">
						<h1 class="home_logo"><img src="/assets/user/images/main/logo.png" alt="신기술접수소 사업평가·관리 시스템"></h1>
					</a>
				</div>
				<p class="ta_c header_logo_p">사업평가 · 관리시스템입니다.</p>
				<section id="content">
					<div id="sub_contents">						
					    <div class="content_area login_box_area expert_box">
						<h2>서울기술연구원 신기술접수소의 전문가 등록</h2>		
						<img src="/assets/user/images/sub/expert_add_bg.png" alt="기존 전문가" />												
						<div class="user_box mb50">
							<ul class="clearfix">
								<li>
									<a href="" class="existing_expert">
										<span class="title">기존 전문가</span>
										<img src="/assets/user/images/sub/expert_existing_img.png" alt="기존 전문가" />
										<p>기존 전문가분께서는 이메일 주소로 조회하여<br /> 본인인증 후 정보를 업데이트 해주세요.</p>
										<div class="search_expert_btn gray_btn2 w80" style="margin: auto;padding: 7px 0 0 0;" >조회</div>
									</a>										
								</li>
								<li>
									<a href="" class="new_expert">
										<span class="title">신규 전문가</span>
										<img src="/assets/user/images/sub/expert_new_img.png" alt="신규 전문가" />
										<p>신규 전문가 신청을 하시는 경우<br /> 본인인증을 하시면 등록이 가능합니다.</p>
										<div class="search_expert_btn blue_btn2 w80" style="margin: auto;padding: 7px 0 0 0;">등록</div>
									</a>
								</li>									
							</ul>
						</div>
						
						<div class="existing_expert_box" style="display:none">
								<div class="info_txt">
									<p>※ 기존 전문가분께서는 <span class="font_blue">이름, 핸드폰번호 및 이메일 주소</span>로 조회하여 <span class="font_blue">본인인증</span> 후 정보를 업데이트 해주세요.</p>						
								</div>
								<h4 class="ta_l">전문가 조회</h4>
								<div class="search_area">
									<dl class="search_box">
										<dt class="hidden">검색대상</dt>
										<dd class="box">
											<label for="search_type_selector" class="fl">구분</label>
											<select id="search_type_selector" class="in_wp150 fl ace-select ls">
												<option value="name">이름</option>
												<option value="mobile_phone">휴대전화</option>
												<option value="email">이메일</option>
											</select>
											
											<div class="input_search_box fl w77">
												<label for="search_text" class="hidden">검색어 입력</label>
												<input id="search_text" class="w83 fl ml10 mr5" name="input_txt" type="text" placeholder="검색어를 입력하세요.">
												<div class="fr clearfix">
													<button type="button" class="search_txt_del2 fl" title="검색어 삭제"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
													<button type="submit" class="serch_btn blue_btn fl mr20" title="검색" onclick="searchList();">검색</button>	
												</div>	
											</div>										
										</dd>
									</dl>								
								</div>
								
								<!--전문가 조회 결과-->
								<h4 class="ta_l" style="margin-top: 70px !important;">전문가 조회 결과</h4>
								<P class="ta_l w100">- 해당되는 본인 정보를 선택한 후 <span class="font_blue">본인인증</span>을 진행해주세요. </P>
								<div class="table_area">
									<table class="list fixed expert_table">
										<caption>전문가 조회 결과</caption>
										<colgroup>
											<col style="width: 5%;">											
											<col style="width: 15%;">
											<col style="width: 15%;">
											<col style="width: 5%;">
											<col style="width: 15%;">
											<col style="width: 20%;">
											<col style="width: 10%;">
											<col style="width: 15%;">
										</colgroup>
										<thead>
											<tr>
												<th scope="col" colspan="8">전문가 정보</th>
											</tr>
											<tr>
												<th scope="col" class="ta_c">&nbsp;</th>												
												<th scope="col">대학(소속)</th>
												<th scope="col">학과(부서)</th>
												<th scope="col">성명</th>
												<th scope="col">연구분야</th>
												<th scope="col">국가과학 기술분류</th>
												<th scope="col">휴대전화</th>
												<th scope="col" class="last">이메일</th>
											</tr>
										</thead>
										<tbody id="list_body">
										</tbody>
									</table>
									<div class="clearfix mb50 certification">
										<button type="button" class="blue_btn mt10 fr" title="본인인증" onclick="prepareCertify();">본인인증</button>
									</div>
								</div>
							</div>
							<!--//기존 전문가-->

							<!--신규 전문가-->
							<div class="new_expert_box" style="display:none">
							<!--div class="data_null ta_c">조회된 내용이 없습니다.</div-->								
								<!--//전문가 조회 결과-->
								<div class="info_txt mb10">
									<p class="new_expert_title">신규 전문가 신청을 하시는 경우 <span class="font_blue">본인인증</span>을 하시면 등록이 가능합니다.</p>
								</div>
								<!--전문가 본인 인증-->
								<div class="phone_certification ta_l">
									<h5>전문가 본인인증</h5>
									<p style="margin-left:86px;margin-bottom:0">본인 명의로 등록된 휴대폰으로 본인인증 해주시기 바랍니다.</p>
									<button type="button" class="blue_btn3 mt10" title="휴대폰 인증하기" onclick="certifyBizsiren();">휴대폰 인증하기</button>
									<!--button type="button" class="blue_btn3" title="휴대폰 인증하기">인증 완료</button-->
								</div>	
								<!--//전문가 본인 인증-->
							</div>	
							<!--//신규 전문가-->
							
						</div>
					</div>								
				</section>
			</div>
		</div>
		<script src="/assets/user/js/script.js"></script>
  </body>
</html>