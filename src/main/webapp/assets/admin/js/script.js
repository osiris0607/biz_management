/*-----------------------------------------상단-------------------------------------------------------*/
$(function(){

	//로그아웃 팝업
    //----- OPEN
    $('.logout').on('click', function(e)  {      
        $('.logout_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.logout_popup_close_btn').on('click', function(e)  {
        $('.logout_popup_box').fadeOut(350);
        e.preventDefault();
    });
/*-----------------------------------------//상단-------------------------------------------------------*/

/*------------------------------------------------레프트메뉴----------------------------------------------*/
	//레프트메뉴 active
	  var sBtn = $(".left_gnb>li>ul>li");    //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
	  sBtn.find("a").click(function(){   // sBtn에 속해 있는  a 찾아 클릭 하면.
	  sBtn.find("a").removeClass("active");     // sBtn 속에 (active) 클래스를 삭제 한다.
	   $(this).addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
	  })

/*------------------------------------------------//레프트메뉴----------------------------------------------*/
/*--------------------------------------홈화면------------------------------------------------------------*/
	/*$('#calendar').fullCalendar({
		var $calEl = $('#calendar').tuiCalendar({
  defaultView: 'month',
  taskView: true,
  template: {
    monthDayname: function(dayname) {
      return '<span class="calendar-week-dayname-name">' + dayname.label + '</span>';
    }
  
  }
});
*/

	
/*-------------------------------------------------회원관리 ------------------------------------------------*/
	//select box 선택 시 input 값 비활성화(이메일)
	//이메일 입력방식 선택
	$('#selectEmail').change(function(){ 
		$("#selectEmail option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$("#str_email2").val(''); //값 초기화 
				$("#str_email2").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$("#str_email2").val($(this).text()); //선택값 입력 
				$("#str_email2").attr("disabled",true); //비활성화
			} 
		}); 
	});	
	//-------------------------------------------------------------------------------------------------
	//시작일, 종료일, 생년월일 날짜 선택
	/*var options = {
		showOn	: 'button',	
			//buttonImage : "../assets/images/calendar-alt-regular.svg", 
			buttonText	: false, 
			//buttonImageOnly : true,
		    showMonthAfterYear	: true,
		    changeYear			: true,
		    changeMonth			: true,
		    dateFormat			: 'yy-mm-dd',
		    monthNamesShort		: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'], // 월의 한글 형식.
		    dayNamesMin			: ['일','월','화','수','목','금','토']

	};
    $(".datepicker").datepicker(options);*/

	$(".datepicker").datepicker({  
		  showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
		  //buttonImage: "/application/db/jquery/images/calendar.gif", // 버튼 이미지
		  buttonText	: false, 
		  buttonImageOnly: false, // 버튼에 있는 이미지만 표시한다.
		  changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
		  changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
		  minDate: '-100y', // 현재날짜로부터 100년이전까지 년을 표시한다.
		  nextText: '다음 달', // next 아이콘의 툴팁.
		  prevText: '이전 달', // prev 아이콘의 툴팁.
		  numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
		  stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
		  yearRange: 'c-100:c+10', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
		  //showButtonPanel: true, // 캘린더 하단에 버튼 패널을 표시한다. ( ...으로 표시되는부분이다.) 
		  //currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
		  closeText: '닫기',  // 닫기 버튼 패널
		  dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
		  showAnim: "slide", //애니메이션을 적용한다.  
		  showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
		  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], // 요일의 한글 형식.
		  monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
	  });
	//---------------------------------------------------------------------------------------------------
	//아이디중복 체크 팝업
    //----- OPEN
    $('.id_check_btn').on('click', function(e)  {      
        $('.idcheck_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.idcheck_popup_box').fadeOut(350);
        e.preventDefault();
    });
    //------------------------------------------------------------------------------------------------------
	//수정 팝업
    //----- OPEN
    $('.member_view_revise_popup_open').on('click', function(e)  {      
        $('.member_view_revise_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.member_view_revise_popup_box').fadeOut(350);
        e.preventDefault();
    });
    //------------------------------------------------------------------------------------------------------

	/*//삭제 팝업
    //----- OPEN
    $('.member_view_revise_popup_open').on('click', function(e)  {      
        $('.member_view_del_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.member_view_del_popup_box').fadeOut(350);
        e.preventDefault();
    });*/
	
	//수정 disabled 해제
	$(".member_view_revise").click(function() { 
	    var condition = $(".d_input").prop( 'disabled' ); 
	    $(".d_input").prop("disabled", condition ? false : true);
		if( $(this).text() == '수정' ) {
            $(this).text('수정완료');	
			$('.adress_btn').css('display', 'block');
			$('.contents_view .datepicker_area button').css('display', 'inline-block');
			
        }
        else {
            $(this).text('수정');
			alert("수정 완료 되었습니다.");
			$('.contents_view .adress_btn, .datepicker_area button').css('display', 'none');
        }
	});

	
//------------------------------------------------------------------------------------------------------
/*-----------------------------------------------//회원관리-----------------------------------------------------*/
	

/*--------------------------------------------------관리자 계정관리------------------------------------------------*/
    // 구분 셀렉트 박스 선택시 평가 간사 및 연구간사 보이게
	jQuery('#member_manager_list_search_merber_class').change(function() {
		var state = jQuery('#member_manager_list_search_merber_class option:selected').val();
		if ( state == 'option3' ) {
			jQuery('.layer').css('display', 'block');
		} else {
			jQuery('.layer').css('display', 'none');
		}
	});
-//---------------------------------------------------------------------------------------------------------------------
	//전체선택 체크박스 클릭 
	$(".allCheck").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($(".allCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$("input.checkbox_member_manager_table[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$("input.checkbox_member_manager_table[type=checkbox]").prop("checked",false); 
		} 
	});

    //관리자 권한 설정 팝업
    //----- OPEN
    $('.member_manager_settings_popup_open').on('click', function(e)  {      
        $('.member_manager_settings_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.member_manager_settings_popup_box').fadeOut(350);
        e.preventDefault();
    });
	//-------------------------------------------------------------------------------------------------------------
    //권한설정 전체 선택
	
		//최상단 체크박스 클릭
		$("#have_menu_all").click(function(){
			//클릭되었으면
			if($("#have_menu_all").prop("checked")){
				//input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
				$("input[name=membermanagersettings]").prop("checked",true);
				//클릭이 안되있으면
			}else{
				//input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
				$("input[name=membermanagersettings]").prop("checked",false);
			}
		})
	
	
/*--------------------------------------------------//관리자 계정관리------------------------------------------------*/
    //관리자 view 수정 팝업
    //----- OPEN
    $('.member_manager_view_revise_popup_open').on('click', function(e)  {      
        $('.member_manager_view_revise_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.member_manager_view_revise_popup_box').fadeOut(350);
        e.preventDefault();
    });
	//------------------------------------------------------------------------------------------------------
	//관리자 추가 페이지 - 등록 팝업
    //----- OPEN
    $('.member_manager_assi_view_revise_popup_open').on('click', function(e)  {      
        $('.member_manager_assi_view_revise_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.member_manager_assi_view_revise_popup_box').fadeOut(350);
        e.preventDefault();
    });
	
	//--예 알럿창 띄움
	$('.member_manager_assi_view_revise_popup_box .ok_btn').on('click', function(e)  {
        alert('등록 되었습니다.');
    });

	//평가관리자 - 연구간사, 평가간사 보이게
	$('#member_write_class2').on('click', function(e)  {
        $('.layer').css('display', 'block');

    });

	$('#member_write_class').on('click', function(e)  {
        $('.layer').css('display', 'none');

    });
	//------------------------------------------------------------------------------------------------------

/*------------------------------------------셀추가----------------------------------------------------------------
	$('.add_cell_btn').on('click', function(e)  {    
		var addStaffText = '<tr>'+'<td><input type="checkbox" class="checkbox_member_manager_table" /></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><select class="ace-select w100"><option value="전체">전체</option><option value="공고관리">공고관리</option><option value="접수관리">접수관리</option><option value="평가관리">평가관리</option><option value="수행관리">수행관리</option><option value="협약관리">협약관리</option><option value="정산관리">정산관리</option><option value="알림&middot;정보관리">알림&middot;정보관리</option><option value="평가위원관리">평가위원관리</option><option value="회원관리">회원관리</option></select></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><input type="text" class="form-control" /></td>'+'<td><input type="text" class="form-control" /></td>'+'</tr>';

		var trHtml = $( "tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.

		var button_joinus = document.getElementById('add_cell_btn');
			button_joinus.disabled = true;

        });

        //생태계 관리 탭 삭제 버튼
        $(document).on("click","button[name=delStaff]",function(){
            var trHtml = $(this).parent().parent();
            trHtml.remove(); //tr 테그 삭제
        });

*/


/*--------------------------------------공고관리--------------------------------------------------------------------------*/
	function uploadFile(){
		var form = $('#FILE_FORM')[0];
		var formData = new FormData(form);
		formData.append("fileObj", $("#FILE_TAG")[0].files[0]);
		formData.append("fileObj2", $("#FILE_TAG2")[0].files[0]);

		$.ajax({
			url: '',
					processData: false,
					contentType: false,
					data: formData,
					type: 'POST',
					success: function(result){
						alert("업로드 성공!!");
					}
			});
	}

	//공고 등록 팝업
    //----- OPEN
    $('.announcement_write_popup_open').on('click', function(e)  {      
        $('.announcement_write_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.announcement_write_popup_box').fadeOut(350);
        e.preventDefault();
    });

	// 파일 첨부 추가
   /* $(document).on("click","input[name=FILE_add]",function(){       
		var addStaffText = '<input type="file" class="file_form_input file_add_cell w_60" />';
		var trHtml = $( "input[name=FILE_TAG]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
	});*/

	

	//첨부파일
	$("#fileUpload").change(function(){
		fileList = $("#fileUpload")[0].files;
		fileListTag = '';
		for(i = 0; i < fileList.length; i++){
			fileListTag += "<li>"+fileList[i].name+'<a href="javascript:void(0);" class="del_btn fr"><i class="fas fa-times" /></i></a>'+"</li>";
		}
		$('#fileList').html(fileListTag);		
	});

	$('#fileUpload').off('scroll touchmove mousewheel');
   
    //첨부파일 삭제
	$('#fileUpload .del_btn').on('click', function(e)  {
	    $(this).parent().css('display', 'none');
	});
	
	/*($("#file").on('change',function(){
	  var fileName = $("#file").val();
	  $(".upload-name").val(fileName);
	});

	$("#file2").on('change',function(){
	  var fileName = $("#file2").val();
	  $(".upload-name2").val(fileName);
	});

	$("#file3").on('change',function(){
	  var fileName = $("#file3").val();
	  $(".upload-name3").val(fileName);
	});*/




    //공고 수정 팝업
    //----- OPEN
    $('.announcement_modify_popup_open').on('click', function(e)  {      
        $('.announcement_modify_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.announcement_modify_popup_box').fadeOut(350);
        e.preventDefault();
    });   
	
	//공고 등록 -탭
	$(document).ready(function(){ 
		$(".tab_1").click(function() {			//이전 클릭
			$(".announcement_tab1").css('display', 'block');
			$(".announcement_tab2").css('display', 'none');
		});
		
		$(".tab_2").click(function() {			 //다음 클릭
			$(".announcement_tab2").css('display', 'block');
			$(".announcement_tab1").css('display', 'none');
		});
	});

	//-------------------------------------------------------------------------------------------------------------------

/*-----------------------------------------------접수관리--------------------------------------------------------------------------*/
	//input 디세이블 해제 - 수정버튼 클릭시
	$(".reception_amend_btn").click(function() { 
	    var condition = $(".agency_select_title").prop( 'disabled' ); 
	    $(".agency_select_title").prop("disabled", condition ? false : true);
		if( $(this).val() == '수정' ) {
            $(this).val('수정완료');
        }
        else {
            $(this).val('수정');
        }
	});
    //기관정보 추가
    $('.view_agency_information_add_btn').on('click', function(e)  {    
		var addStaffText = '<tr><th scope="row"><span class="icon_box"><label>&nbsp;</label></span></th><td><input type="text" class="form-control w_40"></td></tr>';
		var trHtml = $( ".agency_information tr:last" ); 
		trHtml.after(addStaffText); 
     });

    //기술정보 추가-write
	 $('.write_agency_information_add_btn').on('click', function(e)  {
		var addStaffText = '<tr><th scope="row" class="clearfix"><div style="width:90%;margin:0 auto;"><label for="checkbox_reception_table1">&nbsp;</label><input type="text" class="form-control ta_c agency_select_title mr5 mb5" /><button type="button" class="gray_btn">완료</button></div></th><td><input type="radio" class="checkbox_reception_selected" name="" checked="checked"><label class="mr10" style="margin-right:20px">선택</label><input type="radio" class="checkbox_reception_notselected" name=""><label class="mr10">선택 안함</label></td></tr>';
		var trHtml = $( ".technology_information tr:last" ); 
		trHtml.after(addStaffText); 
    });

	 //제출서류 기술컨설팅 추가-write
	 $('.technology_add_btn').on('click', function(e)  {
		var addStaffText = ' <tr><td></td><td><input type="text" class="form-control w80 mr5 mb5" /><input type="button" class="gray_btn mb5" value="등록" /></td><td>PDF</td><td><input type="radio" class="checkbox_reception_selected"  checked="checked" /><label class="w_0">&nbsp;</label></td><td><input type="radio" class="checkbox_reception_notselected"  /><label class="w_0">&nbsp;</label></td><td><input type="radio" class="checkbox_reception_notselected" /><label class="w_0">&nbsp;</label></td></tr>';
		var trHtml = $( ".submission tr:last" ); 		
		trHtml.after(addStaffText);
		$(this).attr('disabled', true);	//추가버튼 디세이블	
    });
		
	//추가버튼 디세이블 해제
	$(document).on("click", ".submission .gray_btn", function(){ 	
		//$('.technology_add_btn').attr('disabled', false);
		$(this).addClass('ubmissionaddcomplate');
		if($(this).hasClass("ubmissionaddcomplate") === true) {  
			$('.technology_add_btn').attr('disabled', false);
		} 				
	});			
	


	
	//제출서류 기술연구개발 추가-write
	 $('.development_technology_add_btn').on('click', function(e)  {
		var addStaffText = ' <tr><td></td><td><input type="text" class="form-control w80 mr5 mb5" /><input type="button" class="gray_btn mb5" value="등록" /></td><td>PDF</td><td><input type="radio" class="checkbox_reception_selected"  checked="checked" /><label class="w_0">&nbsp;</label></td><td><input type="radio" class="checkbox_reception_notselected"  /><label class="w_0">&nbsp;</label></td><td><input type="radio" class="checkbox_reception_notselected" /><label class="w_0">&nbsp;</label></td></tr>';
		var trHtml = $( ".submission2 tr:last" ); 		
		trHtml.after(addStaffText); 		
    });

	 
	

    //체크리스트 추가
	$('.add_checklist_txtbox_btn').on('click', function(e)  {    
		var addStaffText = '<div class="checklist_box"><div class="checklist_txtbox_area"><div class="checklist_txtbox_title clearfix"><span class="fl mr20">항목 3.</span><div class="ta_l fl"><input type="radio" class="checklist_popupcheck_selected3" id="use_checklist" name="checklist_popupcheck_selected3" checked="checked" /><label class="mr10">사용</label><input type="radio" class="checklict_popupcheck_selected3" id="not_checklist" name="checklist_popupcheck_selected3" /><label class="mr10">사용 안함</label></div></div><div class="checklist_txt_area"><span class="dim_box" style="display:none">&nbsp;</span><div class="checklist_txtbox w100"><textarea name="checklist_txt_box1" class="bd_n mr5 mb10 w100">주관기관이 접수마감일 기준 본점 또는 지점이 법인등기부등본 상 서울시에 소재한 중소기업(법인) 또는 서울시 소재 관할 세무서에 사업자등록을 한 중소기업(법인)입니까?</textarea><!--<input type="button" class="fl document_disabled_btn gray_btn mb10" value="입력" />  --> <div class="checklict_txtbox_popuparea clearfix"><table class="list"><caption>체크리스트 팝업</caption><colgroup><col style="width: 20%" /><col style="width: 35%" /><col style="width: 50%" /></colgroup><thead><tr><th scope="col">팝업 사용</th><th scope="col"><span class="ta_c ">팝업 경고</span></th><th scope="col"><span class="ta_c ">팝업 경고 내용</span></th></tr></thead><tbody><tr><td><input type="checkbox" name="chkbox" class="checkbox_member_manager_table" /><label>&nbsp;</label></td><td><span><label>&nbsp;</label></span><input type="radio" id="checkbox_receptionpopup3_1" class="checkbox_receptionpopup_selected" name="checkbox_receptionpopup_selected3" checked="checked" /> <label ="checkbox_receptionpopup3_1">예</label>&nbsp;&nbsp;&nbsp;<input type="radio" id="checkbox_receptionpopup3_2" class="checkbox_receptionpopup_notselected" name="checkbox_receptionpopup_selected3" /><label for="checkbox_receptionpopup3_2">아니오</label></td><td><textarea name="checkbox_receptionpopup-txt" class="checkbox_receptionpopup_txt1 w100 bd_n">동일 솔루션 실증 수행 사업은 지원 대상이 아닙니다.</textarea></td></tr></tbody></table></div></div></div></div></div>';
		var trHtml = $( ".checklist_box:last" ); 
		trHtml.after(addStaffText); 
    });
	

	//체크리스트 사용안함 - 딤처리
	$('input[type=radio][id="not_checklist"]').on('click', function(e)  {		
		$(this).parent().parent().siblings('.checklist_txt_area').children('.dim_box').css('display', 'block');		
	});

	$('input[type=radio][id="use_checklist"]').on('click', function(e)  {		
		$(this).parent().parent().siblings('.checklist_txt_area').children('.dim_box').css('display', 'none');		
	});
    
	$('input[type=radio][id="not_checklist2"]').on('click', function(e)  {		
		$(this).parent().parent().siblings('.checklist_txt_area').children('.dim_box').css('display', 'block');		
	});

	$('input[type=radio][id="use_checklist2"]').on('click', function(e)  {		
		$(this).parent().parent().siblings('.checklist_txt_area').children('.dim_box').css('display', 'none');		
	});
	
	

     //임시저장 팝업
	 //----- OPEN
    $('.temporary_storage_popup_box_open').on('click', function(e)  {      
        $('.temporary_storage_popup_box').fadeIn(350);
        e.preventDefault();
    });
    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.temporary_storage_popup_box').fadeOut(350);
        e.preventDefault();
    }); 

 
   //반려 팝업
    $('.be_rejected_popup_box_open').on('click', function(e)  {      
        $('.be_rejected_popup_box').fadeIn(350);
        e.preventDefault();
    });
    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.be_rejected_popup_box').fadeOut(350);
        e.preventDefault();
    }); 

	//반려완료 팝업
	$('.be_rejected_popup_box .complate_btn').on('click', function(e)  {  
		alert("반려처리 되었습니다.");
        $('.be_rejected_popup_box').fadeOut(350);
        e.preventDefault();
    });

   
	//접수등록 팝업
	 //----- OPEN
    $('.application_completed_popup_open').on('click', function(e)  {      
        $('.application_completed_popup_box, .announcement_write_popup_box').fadeIn(350);
        e.preventDefault();
    });
    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.application_completed_popup_box, .announcement_write_popup_box').fadeOut(350);
        e.preventDefault();
    }); 
	
	//접수등록 팝업
	$('.application_completed_popup_box .complate_btn').on('click', function(e)  {  
		alert("접수 완료 되었습니다.");
        $('.application_completed_popup_box').fadeOut(350);
        e.preventDefault();
    });
  /*----------------------------------------------------//0405추가 - 기술매칭-----------------------------------------------------------------------------*/
  //리스트페이지
	  //전체선택 체크박스 클릭 
		$("#allCheck").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		  if($("#allCheck").prop("checked")) { 
		  //해당화면에 전체 checkbox들을 체크해준다 
		    $("input[type=checkbox]").prop("checked",true); 
		  // 전체선택 체크박스가 해제된 경우 
		  } else { 
			  //해당화면에 모든 checkbox들의 체크를해제시킨다. 
			$("input[type=checkbox]").prop("checked",false); } 
		})

	  //일괄마감
	  $("input[type=checkbox]").click(function(){
	      $(".end_popup_open").css('display', 'block')
	  })

	  //전문가 참여 의향 조사
	     //email
		 //----- OPEN
		$('.expertintention_emailsend_popup_open').on('click', function(e)  {      
			$('.expertintention_emailsend_popup_box').fadeIn(350);
			e.preventDefault();
		});
		//----- CLOSE
		$('.expertintention_emailsend_popup_box .popup_close_btn').on('click', function(e)  {
			$('.expertintention_emailsend_popup_box').fadeOut(350);
			e.preventDefault();
		}); 

		//sms
		//----- OPEN
		$('.expertintention_smssend_popup_open').on('click', function(e)  {      
			$('.expertintention_smssend_popup_box').fadeIn(350);
			e.preventDefault();
		});
		//----- CLOSE
		$('.expertintention_smssend_popup_box .popup_close_btn').on('click', function(e)  {
			$('.expertintention_smssend_popup_box').fadeOut(350);
			e.preventDefault();
		});   
		
	//마감버튼 팝업
	    //7일 이전
		//----- OPEN
		$('.end_popup_open').on('click', function(e)  {      
			$('.end_popup_box').fadeIn(350);
			e.preventDefault();
		});
		//----- CLOSE
		$('.end_popup_box .popup_close_btn').on('click', function(e)  {
			$('.end_popup_box').fadeOut(350);
			e.preventDefault();
		});  

		//7일 이후
		//----- OPEN
		$('.end_popup_open2').on('click', function(e)  {      
			$('.end_popup_box2').fadeIn(350);
			e.preventDefault();
		});
		//----- CLOSE
		$('.end_popup_box2 .popup_close_btn').on('click', function(e)  {
			$('.end_popup_box2').fadeOut(350);
			e.preventDefault();
		});

	//마감팝업 - 확인 
		//----- OPEN
		$('.matching_end_btn').on('click', function(e)  {      
			alert("매칭이 마감처리 되었습니다.");
			e.preventDefault();
		});

	//발송하기 버튼
	$('.send_btn').on('click', function(e)  {
		alert("발송하였습니다.");
		$('.expertintention_emailsend_popup_box, .expertintention_smssend_popup_box').fadeOut(350);		
		e.preventDefault();
	}); 
  //-------------------------------------------------------------------------------------------------------------------------------
  //sms/email-세팅 페이지 탭
	   //tab
		$('.tab-link').click(function () {
			var tab_id = $(this).attr('data-tab'); 
			$('.tab-link').removeClass('current');
			$('.tab-content').removeClass('current'); 
			$(this).addClass('current');
			$("#" + tab_id).addClass('current');
	   })

	   //저장 팝업
		 //----- OPEN
		$('.send_save_popup_open').on('click', function(e)  {      
			$('.send_save_popup_box').fadeIn(350);
			e.preventDefault();
		});
		//----- CLOSE
		$('.send_save_popup_box .popup_close_btn').on('click', function(e)  {
			$('.send_save_popup_box').fadeOut(350);
			e.preventDefault();
		}); 

		//저장 완료
		$('.send_save_popup_box .popup_complate_btn').on('click', function(e)  {
			$('.send_save_popup_box').fadeOut(350);
			alert("저장되었습니다.")
		}); 
//----------------------------------------------------------------------------------------------------------------------------------
   //전문가 검토- 희망전문가
       //삭제 버튼
	   $('.hope_expert .del_btn').click(function () {
		   $(this).parent().parent().remove();
	   })
		
	   //검토완료 팝업
	    $('.complate_review').click(function () {
			alert("검토가 완료되었습니다.");
			history.go(-1);
		});
   
   		/*//희망전문가 선택 삭제
		$("#del").click(function() {             
			if($("input").is(":checked") == true){ //체크된 요소가 있으면               
				var i = $("input:checked").parents("tr").remove();                   
			}else {
				alert("삭제할 항목을 선택해주세요!")
			}            
        }); */

	   //체크박스 전체 선택
	   $(".expert_add_searchlist #allCheck2").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		  if($(".expert_add_searchlist #allCheck2").prop("checked")) { 
		  //해당화면에 전체 checkbox들을 체크해준다 
		  $(".expert_add_searchlist input[type=checkbox]").prop("checked",true); 
		  // 전체선택 체크박스가 해제된 경우 
		  } else { 
			  //해당화면에 모든 checkbox들의 체크를해제시킨다. 
			  $(".expert_add_searchlist input[type=checkbox]").prop("checked",false); } 
		}); 
			
		//저장 팝업
		 //----- OPEN
		$('.expert_add_popup_open').on('click', function(e)  {      
			$('.expert_add_popup_box').fadeIn(350);
			e.preventDefault();
		});
		//----- CLOSE
		$('.expert_add_popup_box .popup_close_btn').on('click', function(e)  {
			$('.expert_add_popup_box').fadeOut(350);
			e.preventDefault();
		}); 

	//우선순위 버튼
	$('.s_h_button').on('click', function(e)  {
		$('.td_txt').fadeIn(350);
		$('.s_h').fadeIn(350);
	 //----- OPEN
			$('.expert_add_popup_box').fadeIn(350);
			e.preventDefault();
		}); 
    //----- CLOSE
		$('.expert_add_popup_box .popup_close_btn').on('click', function(e)  {
			$('.expert_add_popup_box').fadeOut(350);
			e.preventDefault();
		});    
		
	/*//전문가 참여 의향 확인 - 우선순위 선정 버튼
	$(".s_h_button").on('click', function() {
		var currentVal = $(".td_txt").html("<span>참여</span>");
		var sss = currentVal
		if(currentVal == sss) {
					
		}else { 			 
			
			
		} 	
		
	});*/
      
        
 })   

	 
        
   /* //전문가 참여 의향	
    function moveUp(el){
		var $tr = $(el).parent().parent(); // 클릭한 버튼이 속한 tr 요소
		$tr.prev().before($tr); // 현재 tr 의 이전 tr 앞에 선택한 tr 넣기
	}

	function moveDown(el){
		var $tr = $(el).parent().parent(); // 클릭한 버튼이 속한 tr 요소
		$tr.next().after($tr); // 현재 tr 의 다음 tr 뒤에 선택한 tr 넣기
	}	*/    
            
       

//-----------------------------------------------------------------------------------------------------------------------------------------------------

/*0422 추가*/
//알림정보
	// 알림정보 수정버튼
	$(".notice_modify_btn").click(function() { 
	    var condition = $(".notice input, .notice textarea").prop( 'disabled' ); 
	    $(".notice input, .notice textarea").prop("disabled", condition ? false : true);
		if( $(this).text() == '수정' ) {
            $(this).text('수정완료');				
			$('.file_form_txt').css('display', 'block');
        }
        else {
            $(this).text('수정');
			$('.file_form_txt').css('display', 'none');
        }
	});


//-----------------------------------------------------------------------------------------------------------------------------------------------------

/*0804추가*/
	//
	//------------------------------------------------------------------회원관리---------------------------------------------------------------------------

	//전화번호, 휴대전화 번호, 년도 넘버만 입력(한글 입력 강제 안됨)
	$(".agreement_member_view_revise").click(function() { 	  
		var condition = $(".d_input").prop( 'disabled' ); 
		$(".d_input").prop("disabled", condition ? false : true);
		if( $(this).text() == '평가위원정보 수정' ) {
            $(this).text('수정완료');		
			
			$('.adress_btn').css('display', 'block');
			$('.datepicker_area button').css('display', 'inline-block');
        }
        else {
            $(this).text('평가위원정보 수정');
			$('.adress_btn, .datepicker_area button').css('display', 'none');
			alert("수정 완료 되었습니다.");
        }
	});



	//-------------------------------------------------------------------------------------------------------------------------------------------------
	
	//한글 강제 입력 못하게 (년도, 월)
	$("input[type='tel'], input.number_t[type='number'], input.number_t[type='text']").keyup(function(event){
		var inputVal = $(this).val();
		$(this).val(inputVal.replace(/[^0-9]/gi,''));
	});
	

	//-------------------------------------------------------------------------------------------------------------------------------------------------
	
	//년도 월 맥심엄 글자 길이 제한
	function maxLengthCheck(object){
	    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
	    }   
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------------

	//등록보류 안내 팝업	
    //----- OPEN
    $('.member_manager_hold_popup_btn').on('click', function(e)  {      
        $('.member_manager_hold_popup_box').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.member_manager_hold_popup_box .popup_close_btn, .member_manager_hold_popup_box .ok_btn').on('click', function(e)  {
        $('.member_manager_hold_popup_box').fadeOut(350);		
        e.preventDefault();
    });
	
	//----- 예 클릭 경고창
	$('.member_manager_hold_popup_box .ok_btn').on('click', function(e)  {
		alert("해당 평가위원이 보류 되었습니다.");
	});
	//-------------------------------------------------------------------------------------------------------------------------------------------------
	
	//이메일 발송 팝업 안내	
		//----- OPEN
		$('.send_email_popup_open_btn').on('click', function(e)  {      
			$('.send_email_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.send_email_popup_box .popup_close_btn, .send_email_popup_box .ok_btn').on('click', function(e)  {
			$('.send_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- 예 클릭 경고창
		$('.send_email_popup_box .ok_btn').on('click', function(e)  {
			alert("이메일이 발송 되었습니다.");
		});

	//sms 발송 팝업 안내	
		//----- OPEN
		$('.send_sms_popup_open_btn').on('click', function(e)  {      
			$('.send_sms_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.send_sms_popup_box .popup_close_btn, .send_sms_popup_box .ok_btn').on('click', function(e)  {
			$('.send_sms_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- 예 클릭 경고창
		$('.send_sms_popup_box .ok_btn').on('click', function(e)  {
			alert("sms 메세지가 발송 되었습니다.");
		});


	
		//이메일 및 sms 발송내역 체크박스		
		//이메일
		$(".history_send #email_checkbox").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
			if($(".history_send #email_checkbox").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
				$(".history_send input.history_email[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
				$(".history_email").parent().parent('tr').show();
			} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
				
				$(".history_email").parent().parent('tr').hide();
				$(".history_send #allcheckbok").prop("checked",false); 
			} 
		});
		//sms
		$(".history_send #sms_checkbox").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
			if($(".history_send #sms_checkbox").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
				$(".history_send input.history_sms[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
				$(".history_sms").parent().parent('tr').show();
			} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
				
				$(".history_sms").parent().parent('tr').hide();
				$(".history_send #allcheck[type=checkbox]").prop("checked",false); 
			} 
		});

	//-----------------------------------------------------------------------------------------------------------------------------------------------
	/*-------------------------------------------------평가-----------------------------------------------------------------------------------------*/
	//전체선택 체크박스 클릭 
	$(".checkinput_table th input[type='checkbox']").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($(".checkinput_table input[type='checkbox']").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".checkinput_table tbody tr td input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".checkinput_table tbody tr td input[type=checkbox]").prop("checked",false); 
		} 
	});

	//평가위원 등록 버튼 활성화 - 평가준비일 경우
	$(".add_rating_btn").click(function(){
		var checkTextReady = $(".estimation tbody tr td:last-child a").text('평가준비');
		var checkAddBtn = $(".add_rating_btn").prop( 'disabled', true );
		var checkTextCheck = $(".estimation tbody tr td:last-child a").parent('td').sibling('td.check').children('input:checked');
		var checkTable = $(".estimation td.check input:checked").prop("checked",true);
		var chk = checkTextCheck.is(":checked");

		if(chk==true){
			checkAddBtn.prop( 'disabled', false );		
			
		}else{
			checkAddBtn.prop( 'disabled', true );	
		}


	});
		
	//평가번호 생성 - 평가번호가 없을때 팝업	
		//----- OPEN
		$('.add_rating_numer_popup_btn').on('click', function(e)  {      
			$('.rating_group_nullproduce_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.rating_group_nullproduce_popup_box .popup_close_btn').on('click', function(e)  {
			$('.rating_group_nullproduce_popup_box').fadeOut(350);		
			e.preventDefault();
		});
	
	//평가번호 생성 - 평가번호가 있을때 팝업
		/*//----- OPEN
		$('.add_rating_numer_popup_btn').on('click', function(e)  {      
			$('.rating_group_okproduce_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.rating_group_okproduce_popup_box .popup_close_btn').on('click', function(e)  {
			$('.rating_group_okproduce_popup_box').fadeOut(350);		
			e.preventDefault();
		});*/

	//평가그룹 해제 - 체크 선택안했을때 팝업
		/*//----- OPEN
		$('.rating_groupcancel_popup_btn').on('click', function(e)  {      
			$('.rating_groupcancelcheck_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.rating_groupcancelcheck_popup_box .popup_close_btn').on('click', function(e)  {
			$('.rating_groupcancelcheck_popup_box').fadeOut(350);		
			e.preventDefault();
		});*/
	
	//평가그룹 해제 팝업
		//----- OPEN
		$('.rating_groupcancel_popup_btn').on('click', function(e)  {      
			$('.rating_groupcancel_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.rating_groupcancel_popup_box .popup_close_btn').on('click', function(e)  {
			$('.rating_groupcancel_popup_box').fadeOut(350);		
			e.preventDefault();
		});

	//평가구분 및 평가일 선택 팝업
		//----- OPEN
		$('.rating_day_popup_btn').on('click', function(e)  {      
			$('.rating_day_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.rating_day_popup_box .popup_close_btn').on('click', function(e)  {
			$('.rating_day_popup_box').fadeOut(350);		
			e.preventDefault();
		});

		//----- 저장문구
		$('.rating_day_popup_box .save_btn').on('click', function(e)  {
			alert("저장되었습니다.")			
			e.preventDefault();
		});
		
		//----- 저장 - 평가일자가 등록된 목록 포함된것
		$('.rating_day_popup_btn .save_btn').on('click', function(e)  {
			alert("이미 평가일자가 등록된 목록이 포함되어 있습니다.")			
			e.preventDefault();
		});
		
		

		
	//평가구분 및 평가일자 등록 - 셀렉트 옵션값에 따른 변화값
		function agreement_categoryChange(e) {
			var category_1 = ["전체", "사전검토", "서면평가", "발표평가"];
			var category_2 = ["전체", "사전검토", "서면평가", "발표평가"];
			var category_3 = ["전체", "서면평가", "발표평가"];
			var category_4 = ["전체", "서면평가", "발표평가"];
			var target = document.getElementById("agreement_category2");

			if(e.value == "select_agreement_all") var d = category_1;
			else if(e.value == "select_agreement_select") var d = category_2;
			else if(e.value == "select_agreement_middle") var d = category_3;
			else if(e.value == "select_agreement_final") var d = category_4;
			target.options.length = 0;

			for (x in d) {
				var opt = document.createElement("option");
				opt.value = d[x];
				opt.innerHTML = d[x];
				target.appendChild(opt);
			}   
		}




	//평가위원 참여 이메일 보내기
		//----- OPEN
		$('.estimation_addevaluator_mail_btn').on('click', function(e)  {      
			$('.rating_email_popup_box').fadeIn(350);
			e.preventDefault();
		});

		//----- OPEN
		$('.rating_email_popup_box .send_email_btn').on('click', function(e)  {
			//발송팝업	
			$('.send_email_popup_box').fadeIn(350);
			//$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- CLOSE
		$('.rating_email_popup_box .popup_close_btn').on('click', function(e)  {
			//발송팝업	
			//$('.send_email_popup_box').fadeIn(350);
			$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});

	//이메일 발송팝업		
		$('.send_email_popup_box .ok_btn').on('click', function(e)  {			
			$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});

		


	//자동추출 - SHOW & HIDE
		$('.auto_result_btn').on('click', function(e)  {
			//발송팝업	
			$('.auto_result_area').fadeIn(350);
			//$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});

	//종합평가서 최종 업로드 버튼
	//-----보안서약서 미리보기
		//----- 미리보기 새창 OPEN - 사인창 띄우기
		$('.rating_day_popup_btn').click( function() {				  
			//var url = "../html/estimation_leader_preview.html";  
			//window.open(url, "_blank", 'width=841, height=595'); 				
			//$('.security_popup_box').fadeOut(350);			
		 });
		
		//종합평가서 새창
		 //----- 미리보기 새창 OPEN - 사인창 띄우기
		$('.rating_pdf_popup_btn').click( function() {				  
			var url = "../html/estimation_leader_preview.html";  
		   window.open(url, "_blank", 'width=841, height=595, scrollbars=1'); 				
			//$('.security_popup_box').fadeOut(350);			
		 });

	
	//종합평가서 팝업
	//----- OPEN
		$('.final_upload_popup_btn').on('click', function(e)  {
			//발송팝업	
			$('.final_upload_popup_box').fadeIn(350);
			//$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- CLOSE
		$('.final_upload_popup_box .popup_close_btn').on('click', function(e)  {
			//발송팝업	
			//$('.send_email_popup_box').fadeIn(350);
			$('.final_upload_popup_box').fadeOut(350);		
			e.preventDefault();
		});

	//----- OPEN(업로드되었습니다)
		$('.final_upload_popup_box .ok_btn').on('click', function(e)  {
			//발송팝업	
			alert('업로드 되었습니다.');
			$('.final_upload_popup_box').fadeOut(350);	
		});


	//임시저장 팝업
	//----- OPEN
		$('.temporary_storage_popup_btn').on('click', function(e)  {
			//발송팝업	
			$('.temporary_storage_popup_box').fadeIn(350);
			//$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- CLOSE
		$('.temporary_storage_popup_box .popup_close_btn').on('click', function(e)  {
			//발송팝업	
			//$('.send_email_popup_box').fadeIn(350);
			$('.temporary_storage_popup_box').fadeOut(350);		
			e.preventDefault();
		});

	//----- OPEN(임시저장되었습니다)
		$('.temporary_storage_popup_box .ok_btn').on('click', function(e)  {
			//발송팝업	
			alert('임시 저장되었습니다.');
			$('.temporary_storage_popup_box').fadeOut(350);		
			e.preventDefault();
		});


	//제출 팝업
		//----- OPEN
		$('.send_submission').on('click', function(e)  {
			//발송팝업	
			$('.send_submission_popup_box').fadeIn(350);
			//$('.rating_email_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- CLOSE
		$('.send_submission_popup_box .popup_close_btn').on('click', function(e)  {
			//발송팝업	
			//$('.send_email_popup_box').fadeIn(350);
			$('.send_submission_popup_box').fadeOut(350);		
			e.preventDefault();
		});
		
		//----- OPEN
		$('.send_submission_popup_box .ok_btn').on('click', function(e)  {
			//발송팝업	
			alert('제출이 완료되였습니다.');
			$('.send_submission_popup_box').fadeOut(350);		
			e.preventDefault();
		});


	//평가위원 정보 팝업
		//----- OPEN
		
		
		//----- CLOSE
		/*$('.rating_link_popup_box .popup_close_btn').on('click', function(e)  {
			//발송팝업	
			$('.send_email_popup_box').fadeIn(350);				
			$(opener.document).find(".rating_link_popup_box").fadeOut(350);	
			e.preventDefault();
		});*/
		
		//----- OPEN
		$('.note_save_btn').on('click', function(e)  {
			//발송팝업	
			alert('저장 되었습니다.');					
			e.preventDefault();
		});

/*-----------------------------------------------------------------------0823추가--------------------------------------------------------------------------------------*/

	//평가관리 - 평가그룹해제(평가번호 입력하지 않았을때)
	$('.none_estimation_number_group').on('click', function(e)  {			
		alert('평가번호를 입력해주세요.');					
		e.preventDefault();
	});
	
	//평가관리 - 평가그룹해제(평가번호가 잘못 기입 되었을때)
	$('.none_estimation_number_group').on('click', function(e)  {			
		alert('올바르지 않은 평가 번호입니다.\n다시 입력해 주시기 바랍니다.');					
		e.preventDefault();
	});

	//평가관리 - 평가그룹해제완료
	$('.none_estimation_number_group').on('click', function(e)  {			
		alert('평가그룹 해제가 완료 되었습니다.');					
		e.preventDefault();
	});


	/*내부평가자메뉴 - 권한테이블 정렬*/
	$(document).ready(function(){
		var addStaffText ="<label>&nbsp;</label>";
		var trHtml = $( "#total_permission" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText);

	});


/*------------------------------------------------------------------------------협약관리----------------------------------------------------------------------------------*/

	/*//사업자등록번호 자동입력(-)	
	function licenseNum(str){
	  str = str.replace(/[^0-9]/g, '');
	  var tmp = '';
	  if(str.length < 4){
		  return str;
	  }else if(str.length < 7){
		  tmp += str.substr(0, 3);
		  tmp += '-';
		  tmp += str.substr(3);
		  return tmp;
	  }else{             
		  tmp += str.substr(0, 3);
		  tmp += '-';
		  tmp += str.substr(1, 2);
		  tmp += '-';
		  tmp += str.substr(5);
		  return tmp;
	  }
	  return str;
	}
 
	var li_number = document.getElementById("li_number");
	li_number.onkeyup = function(event){
		   event = event || window.event;
		   var _val = this.value.trim();
		   this.value = licenseNum(_val) ;
	};*/

	//휴대전화
	$(document).on("keyup", ".phoneNumber", function() { 
		$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-") ); 
		// copy from https://cublip.tistory.com/326
		//﻿ 원본과 class 명만 바뀐 상태다.
	});
								
	//금액
	$(document).ready(function(){
      $("input:text[id='test3']").on("keyup", function() {
         $(this).val(addComma($(this).val().replace(/[^0-9]/g,"")));

      });
    });

	//천단위마다 콤마 생성
	function addComma(data) {
		return data.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	//모든 콤마 제거 방법
	function removeCommas(data) {
		if(!data || data.length == 0){
			return "";
		}else{
			return x.split(",").join("");
		}
	}

	$(document).ready(function(){
		$(".onlynum").keyup( function(){ $(this).val( $(this).val().replace(/[^0-9]/gi,"") ); } );
	});


	//이메일 입력방식 선택
	$('.responsible_studies_email1 .selectEmail').change(function(){ 
		$(".responsible_studies_email1 .selectEmail option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$(this).parent('select').siblings(".str_email").val(''); //값 초기화 
				$(this).parent('select').siblings(".str_email").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$(this).parent('select').siblings(".str_email").val($(this).text()); //선택값 입력 
				$(this).parent('select').siblings(".str_email").attr("disabled",true); //비활성화
			} 
		}); 
	});	

	
	
	//협약완료승인 팝업
	//----- OPEN
	$('.agreemen_ok_popup_open').on('click', function(e)  {
		$(".agreemen_ok_popup_box").fadeIn(350);			
	});

	//----- CLOSE
	$('.agreemen_ok_popup_box .popup_close_btn').on('click', function(e)  {			
		$(".agreemen_ok_popup_box").fadeOut(350);			
	});

	//----- OPEN(완료)
	$('.agreemen_ok_btn').on('click', function(e)  {
		alert('승인 완료 되었습니다.');	
		$(".agreemen_ok_popup_box").fadeOut(350);	
	});

	/*----------------------------------------------------------------------수행-----------------------------------------------------------------------*/
	//등록 버튼 팝업
	//----- OPEN
	$('.execute_ok_popup_open').on('click', function(e)  {
		$(".execute_ok_popup_box").fadeIn(350);			
	});

	//----- CLOSE
	$('.execute_ok_popup_box .popup_close_btn').on('click', function(e)  {			
		$(".execute_ok_popup_box").fadeOut(350);			
	});

	//----- OPEN(완료)
	$('.execute_ok_popup_box .execute_ok_btn').on('click', function(e)  {
		alert('등록 완료 되었습니다.');	
		$(".execute_ok_popup_box").fadeOut(350);	
	});

	
	//전체선택 체크박스 클릭 
	$("#computeallCheck").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#computeallCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".compute_list_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".compute_list_table input[type=checkbox]").prop("checked",false); 
		} 
	});	
/*----------------------------------------------------------------------------정산----------------------------------------------------------------------------*/
//정산완료 버튼 팝업
	//----- OPEN
	$('.compute_ok_popup_open').on('click', function(e)  {
		$(".compute_ok_popup_box").fadeIn(350);			
	});

	//----- CLOSE
	$('.compute_ok_popup_box .popup_close_btn').on('click', function(e)  {			
		$(".compute_ok_popup_box").fadeOut(350);			
	});
	
	//----- OPEN(완료)
	$('.compute_ok_popup_box .compute_ok_btn').on('click', function(e)  {
		alert('등록 완료 되었습니다.');	
		$(".compute_ok_popup_box").fadeOut(350);	
	});






	

	//첨부파일 - 단일
	$(document).ready(function(){ 
	var fileTarget = $('.filebox .upload-hidden'); 
	fileTarget.on('change', function(){ // 값이 변경되면
		if(window.FileReader){ // modern browser 
			var filename = $(this)[0].files[0].name; 
		} 
		else {// old IE 
			var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출 
		} // 추출한 파일명 삽입 
		$(this).siblings('.upload-name').val(filename); 
	}); 




/*--------------------------------------------------------------평가 양식---------------------------------------------------------------------*/
	//평가 점수
	//텍스트 view버튼
	$('.form_box_score_txt1').on('click', function(e)  {
		$("#form_box_score_txt1").css('display', 'block');	
		$("#form_box_score_write, #score_modify, #opinion_modify, #opinion_view").css('display', 'none');
	});

	//작성버튼
	$('.not_form_txt .add_write').on('click', function(e)  {
		$("#form_box_score_write").css('display', 'block');	
		$("#form_box_score_txt1, #score_modify, #opinion_modify, #opinion_view").css('display', 'none');
	});

	//수정 버튼
	$('.score_modify').on('click', function(e)  {
		$("#score_modify").css('display', 'block');	
		$("#form_box_score_txt1, #form_box_score_write, #opinion_modify, #opinion_view").css('display', 'none');
	});


	//평가 의견
	//텍스트 view버튼
	$('.opinion_modify_txt1').on('click', function(e)  {
		$("#opinion_view").css('display', 'block');	
		$("#form_box_score_txt1, #form_box_score_write, #score_modify").css('display', 'none');
	});

	//수정 버튼
	$('.opinion_modify').on('click', function(e)  {
		$("#opinion_modify").css('display', 'block');	
		$("#form_box_score_txt1, #form_box_score_write, #score_modify, #opinion_view").css('display', 'none');
	});


	
	//저장팝업
	//----- OPEN
	$('.save_form_popup_btn').on('click', function(e)  {
		$(".save_form_popup_box").fadeIn(350);			
	});

	//----- CLOSE
	$('.save_form_popup_box .popup_close_btn, .save_form_popup_box .ok_btn').on('click', function(e)  {			
		$(".save_form_popup_box").fadeOut(350);			
	});

	$('.save_form_popup_box .ok_btn').on('click', function(e)  {
		alert('저장되었습니다.');		
	});



	//삭제 팝업
	$('.write_table2 .del, .write_table .del').on('click', function(e)  {
		$(".del_info_popup_box").fadeIn(350);			
	});

	//----- CLOSE
	$('.del_info_popup_box .popup_close_btn, .del_info_popup_box .ok_btn').on('click', function(e)  {			
		$(".del_info_popup_box").fadeOut(350);			
	});
	
	$('.del_info_popup_box .ok_btn').on('click', function(e)  {
		alert('삭제되었습니다.');				
	});


	//평가서 등록 팝업
	$('.add_info_popup_btn').on('click', function(e)  {
		$(".add_info_popup_box").fadeIn(350);			
	});

	//----- CLOSE
	$('.add_info_popup_box .popup_close_btn, .add_info_popup_box .ok_btn').on('click', function(e)  {			
		$(".add_info_popup_box").fadeOut(350);			
	});
	
	$('.add_info_popup_box .ok_btn').on('click', function(e)  {
		alert('등록되었습니다.');				
	});

	//평가- 목록 뒤로가기
	$("#repage").click(function(){
		history.go(-1)();
	});

	/*접수 제출서류 확인 적합&부적합 표기*/
	
});