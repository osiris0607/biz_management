<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var oEditors = [];
	
	$(document).ready(function() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors,
			elPlaceHolder : "contents", //textarea에서 지정한 id와 일치해야 합니다. 
			//SmartEditor2Skin.html 파일이 존재하는 경로
			sSkinURI : "${ctx }/assets/SE2/SmartEditor2Skin.html",
			htParams : {
				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseToolbar : true,
				// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,
				fOnBeforeUnload : function() {
	
				}
			},
			fOnAppLoad : function() {
				//기존 저장된 내용의 text 내용을 에디터상에 뿌려주고자 할때 사용
				//oEditors.getById["explanation"].exec("PASTE_HTML",[ "기존 DB에 저장된 내용을 에디터에 적용할 문구" ]);
			},
			fCreator : "createSEditor2"
		});


	 	$("#selectEmail").change(function(){
	 		if ( $("#selectEmail").val() == "1" ) {
				$("#email2").attr("disabled", false);
			}
			else {
				$("#email2").attr("disabled", true);
			}
		});
		
	});

	function registration(status) {
		var formData = new FormData();
		
  		var chkVal = ["title", "type", "manager", "manager_dept", "manager_job_title", "phone1", "phone2", "phone3", "receipt_to", "receipt_from"];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		} 

		tempStr = "";
		if ( gfn_isNull($("#email1").val()) == false && gfn_isNull($("#email2").val()) == false){
			tempStr = $("#email1").val() + "@" + $("#email2").val();
		}
		else if (gfn_isNull($("#email1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
			tempStr =  $("#email1").val() + "@" + $("select[name=selectEmail]").val();
		}
		else {
			alert("메일은(는) 필수입력입니다.");
			return false;
		}
		
		formData.append("title", $("#title").val());
		formData.append("type", $("#type option:selected").val());
		formData.append("manager", $("#manager").val());
		formData.append("manager_dept", $("#manager_dept").val());
		formData.append("manager_job_title", $("#manager_job_title").val());
		var tempStr = $("#phone1").val() + "-" + $("#phone2").val() + "-" + $("#phone3").val();
		formData.append("manager_phone", tempStr);



		formData.append("manager_mail", tempStr);
		if ( $("#register").val() == null || $("#register").val() == "" ) {
			formData.append("register",'${member_id}');
		}
		else {
			formData.append("register",$("#register").val());
		}
		formData.append("receipt_to", $("#receipt_to").val());
		formData.append("receipt_from", $("#receipt_from").val());
		formData.append("contents", oEditors.getById["contents"].getIR());
		formData.append("process_status", status);

		// Multi File Upload 시에 이용
		// formData.append("Param_name", "Value") 으로 같은 'Param_name'에 Append하면
		// 'Param_name'으로 된 Value를 같는 List가 생성된다.
		// 따라서 아래에서와 같이 
		// formData.append("upload_files", $("#upload_file_" + i)[0].files[0])
		// 이렇게 하면 'upload_files'이라는 변수에 upload file 정보가 list처럼 쌓이게 된다.
		for (var i=0; i<$("input[name=FILE_TAG]").length; i++ ) {
			if ( gfn_isNull($("#upload_file_" + i)[0].files[0]) == false ) {
				formData.append("upload_files", $("#upload_file_" + i)[0].files[0]);
			}
		}


		
		var extList = new Array();
		// 기관 정보
		for (var i=0; i<$("#agency_information_body tr").length; i++ ) {
			var institutionsInfo = new Object();
			institutionsInfo.ext_type = "D0000001";
			institutionsInfo.ext_field_yn = $("input:radio[name=reception_institutions_radiooptions" + (i+1) + "]:checked").val();
			institutionsInfo.ext_field_name = $("#institutions_name_"+ (i+1)).text() ;
			extList.push(institutionsInfo);
		}
		// 스킬 정보
		for (var i=0; i<$("#technology_body tr").length; i++ ) {
			var techInfo = new Object();
			techInfo.ext_type = "D0000002";
			techInfo.ext_field_yn = $("input:radio[name=reception_technique_radiooptions" + (i+1) + "]:checked").val();
			techInfo.ext_field_name = $("#technology_name_"+ (i+1)).text() ;
			extList.push(techInfo);
		}
		// 제출 서류
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			var techInfo = new Object();
			techInfo.ext_type = "D0000003";
			techInfo.ext_field_yn = $("input:radio[name=reception_document_radiooptions" + (i+1) + "]:checked").val();
			techInfo.ext_field_name = $("#doc_ext_name_"+ (i+1)).text() ;
			extList.push(techInfo);
		}


		

		formData.append("ext_field_list_json",  JSON.stringify(extList));

		if (confirm('등록 하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/announcement/registration",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == 1) {
			            alert("등록 되었습니다.");
			            location.href = "/admin/rdt/announcement/main";
			        } else {
			            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
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
			       <h2 class="title">접수관리</h2>
			   </div>
                  <!--// 레프트 메뉴 서브 타이틀 -->
			   <div class="lnb_menu_area">	
			       <ul class="lnb_menu">
					   <li class="on"><a href="/admin/rdt/reception/main" title="접수관리">접수관리</a></li>
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
				       <li><a href="/admin/rdt/reception/main"><i class="nav-icon fa fa-home"></i></a></li>
					   <li><strong>접수관리</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				   <h3 class="title_area">접수관리</h3>
				  <!--//페이지타이틀-->
			    </div>
		    </div>
		    <div class="contents_view">
			   <!--접수관리 view-->
			   <!--기관정보-->
			   <div class="view_top_area clearfix mt30">
				   <h4 class="fl sub_title_h4">기관 정보</h4>							  
			   </div>
			   <table class="list2 agency_information">
				   <caption>기관 정보</caption> 
				   <colgroup>
					   <col style="width: 20%" />
					   <col style="width: 80%" />
				   </colgroup>
				   <thead>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_registration_number">사업자 등록번호</label></span></th>
						   <td><span>000-00-00000</span></td> 
					   </tr>
				   </thead>
				   <tbody>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_name">기관명</label></span></th>
						   <td><span>㈜이노싱크컨설팅</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_address">주소</label></span></th>
						   <td><span>경기도 부천시 시민대로 123</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_tel">전화</label></span></th> 
						   <td><span>경기도 부천시 시민대로 123</span></td>
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_ceo_name">대표자명</label></span></th> 
						   <td><span>홍길동</span></td>
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_sectors">업종</label></span></th> 
						   <td><span>서비스업</span></td>
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_business_class">업태</label></span></th> 
						   <td><span>학술연구용역</span></td>
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_day">설립일</label></span></th> 
						   <td><span>2015-01-02</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_classification_of_establishment">설립 구분</label></span></th> 
						   <td><span>영리</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_company_class">기업 분류</label></span></th> 
						   <td><span>중소기업</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_other_class">기타 유형</label></span></th> 
						   <td><span>해당없음</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="reception_or_lab">기업부설연구소 유무</label></span></th> 
						   <td><span>있음</span></td> 
					   </tr>
				   </tbody>
			   </table>					   
			   <!--//기관정보-->

			   <!--연구책임자 정보-->
			   <div class="view_top_area mt30" style="clear:both">
				   <h4 class="sub_title_h4">연구책임자 정보</h4>							  
			   </div>
			   <table class="list2 font_white">
				   <caption>연구책임자 정보</caption> 
				   <colgroup>
					   <col style="width: 20%" />
					   <col style="width: 80%" />
				   </colgroup>
				   <thead>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_charge_name">성명</label></span></th>
						   <td><span>홍길동</span></td> 
					   </tr>
				   </thead>
				   <tbody>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_charge_part">부서</label></span></th>
						   <td><span>사업화전략팀</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_charge_position">직책</label></span></th>
						   <td><span>선임</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_charge_tel">휴대전화</label></span></th>
						   <td><span>00-000-00000</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_charge_mail">이메일</label></span></th>
						   <td><span>manager@Innothink.kr</span></td> 
					   </tr>								   
				   </tbody>
			   </table>					   
			   <!--//연구책임자 정보-->
                        
			   <!--기술 정보-->
			   <div class="view_top_area clearfix mt30">
				   <h4 class="fl sub_title_h4">기술 정보</h4>							  
			   </div>
                        <table class="list2 font_white">
				   <caption>기술 정보</caption> 
				   <colgroup>
					   <col style="width: 20%" />
					   <col style="width: 80%" />
				   </colgroup>
				   <thead>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_technical_name">기술명</label></span></th>
						   <td><span></span></td> 
					   </tr>
				   </thead>
				   <tbody>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_technical_overview">기술 개요</label></span></th>
						   <td><span></span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_field">실증 분야</label></span></th>
						   <td><span>예산지원형</span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_technology_class">국가기술분류</label></span></th>
						   <td><span></span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_industrytechnology_class">4차 산업혁명 기술분류</label></span></th>
						   <td><span></span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_technology_point">기술 특징</label></span></th>
						   <td><span></span></td> 
					   </tr>
					   <tr>
						   <th scope="row"><span class="icon_box"><label for="reception_get_class">적용 분야</label></span></th>
						   <td><span></span></td> 
					   </tr>
				   </tbody>
			   </table>	
			   <!--//기술 정보-->
			   <!--전문가 정보
			   <div class="view_top_area clearfix mt30">
				   <h4 class="fl sub_title_h4">전문가 정보</h4>							  
			   </div>
                        <table class="list2 font_white">
				   <caption>전문가 정보</caption> 
				   <colgroup>
					   <col style="width: 20%" />
					   <col style="width: 80%" />
				   </colgroup>
				   <thead>
					   <tr>
						   <th scope="row">성명</th>
						   <td><span>홍길동</span></td> 
					   </tr>
				   </thead>
				   <tbody>
					   <tr>
						   <th scope="row">소속 기관</th>
						   <td><span>기관</span></td> 
					   </tr>
					   <tr>
						   <th scope="row">휴대 전화</th>
						   <td><span>010-3333-5555</span></td> 
					   </tr>
					   <tr>
						   <th scope="row">이메일</th>
						   <td><span>abc@dfdf.com</span></td> 
					   </tr>								   
				   </tbody>
			   </table>	
			   <!--//기술 정보-->
			   <!--제출서류 확인-->
			   <div class="view_top_area clearfix mt30">
				   <h4 class="fl sub_title_h4">제출서류 확인</h4>							  
			   </div>
			   <table class="list">
				   <caption>제출서류 확인</caption>     
				   <colgroup>
					   <col style="width:5%">
					   <col style="width:15%">
					   <col style="width:20%">
					   <col style="width:10%">
					   <col style="width:10%">
				   </colgroup>
				   <thead>
					   <tr>
						   <th scope="col" rowspan="2">순번</th>
						   <th scope="col" rowspan="2">제출서류</th>
						   <th scope="col" rowspan="2">파일명</th>
						   <th scope="col" colspan="2">접수 결과 입력</th>
					   </tr>
					   <tr>
					       <th scope="col">적합</th>
						   <th scope="col">부적합</th>
					   </tr>
				   </thead>
				   <tbody>
					   <tr>
						   <td>1</td>
						   <td><span><span class="font_red"><strong>(필수)</strong></span>기술제안서.pdf</span></td>
						   <td><a href="" download><span><span class="font_red"><strong>(필수)</strong></span>기술제안서.pdf</span></a></td>
						   <td><input type="radio" name="documents_submitted" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted" /><label>&nbsp;</label></td>                           
					   </tr>   
					   <tr>
						   <td>2</td>
						   <td><span><span class="font_red"><strong>(필수)</strong></span>기술 등록 및 활용 동의서.pdf</span></td>
						   <td><a href="" download><span><span class="font_red"><strong>(필수)</strong></span>기술 등록 및 활용 동의서.pdf</span></a></td>
						   <td><input type="radio" name="documents_submitted2" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted2" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>3</td>
						   <td><span><span class="font_red"><strong>(필수)</strong></span>R&D 참여 현황 및 사업비 사용계획</span></td>
						   <td><a href="" download><span><span class="font_red"><strong>(필수)</strong></span>R&D 참여 현황 및 사업비 사용계획</span></a></td>							  
						   <td><input type="radio" name="documents_submitted3" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted3" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>4</td>
						   <td><span><span class="font_red"><strong>(필수)</strong></span>특허(출원, 등록) 증빙자료</span></td>
						   <td><a href="" download><span><span class="font_red"><strong>(필수)</strong></span>특허(출원, 등록) 증빙자료</span></a></td>		
						   <td><input type="radio" name="documents_submitted4" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted4" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>5</td>
						   <td><span><span class="font_red"><strong>(필수)</strong></span>사업자등록증, 법인등기부등본, 최근 2년간 표준재무제표증명원 각 1부</span></td>
						   <td><a href="" download><span><span class="font_red"><strong>(필수)</strong></span>사업자등록증, 법인등기부등본, 최근 2년간 표준재무제표증명원 각 1부</span></a></td>		
						   <td><input type="radio" name="documents_submitted5" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted5" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>6</td>
						   <td><span><span class="font_red"><strong>(필수)</strong></span>TRL 6단계 이상 증빙자료</span></td>
						   <td><a href="" download><span><span class="font_red"><strong>(필수)</strong></span>TRL 6단계 이상 증빙자료</span></a></td>	
						   <td><input type="radio" name="documents_submitted6" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted6" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>7</td>
						   <td><span>(선택)서울시산학연협력사업 최근 3년 이내 ‘우수‘ 최종평가 증빙</span></td>
						   <td><a href="" download><span>(선택)서울시산학연협력사업 최근 3년 이내 ‘우수‘ 최종평가 증빙</span></a></td>	
						   <td><input type="radio" name="documents_submitted7" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted7" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>8</td>
						   <td><span>(선택)여성기업인 확인서</span></td>
						   <td><a href="" download><span>(선택)여성기업인 확인서</span></a></td>	
						   <td><input type="radio" name="documents_submitted8" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted8" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>9</td>
						   <td><span>(선택)장애인기업 확인서</span></td>
						   <td><a href="" download><span>(선택)장애인기업 확인서</span></a></td>	
						   <td><input type="radio" name="documents_submitted9" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted9" /><label>&nbsp;</label></td>                           
					   </tr> 
					   <tr>
						   <td>10</td>
						   <td><span>(선택)사회적기업 확인서</span></td>
						   <td><a href="" download><span>(선택)사회적기업 확인서</span></a></td>	
						   <td><input type="radio" name="documents_submitted10" checked="checked" /><label>&nbsp;</label></td>
						   <td><input type="radio" name="documents_submitted10" /><label>&nbsp;</label></td>                           
					   </tr> 
				   </tbody>
				   <tfoot>
				       <tr>
				       	<th colspan="3" class="border_1">결과</th>
						<td colspan="2" class="ta_c"><span><span style="color:red;">부적합(자동생성)</span><!--span style="color:#2874d0">적합(자동생성)</span--></span></td>
				       </tr>
				   </tfoot>
			   </table>
			   <!--제출서류 확인-->
			   <div class="fr mt30">
			   	   <a href="" class="green_btn all_down fl mr5">첨부파일 전체 다운로드</a>
			       <button type="button" class="blue_btn2 temporary_storage_popup_box_open">임시 저장</button>
				   <button type="button" class="gray_btn">반려</button>
				   <button type="button" class="blue_btn application_completed_popup_open">등록</button>
				   <button type="button" class="gray_btn2" onclick="location.href='/admin/rdt/reception/main'">목록</button>
			   </div>
			   <!--//제출서류 확인-->
		   </div><!--contents_view-->
  		</div>
	   <!--//contents--> 
   </div>
   <!--//sub--> 
</div>
