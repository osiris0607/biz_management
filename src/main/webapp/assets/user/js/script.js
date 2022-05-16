
/*-----------------------------------------푸터-------------------------------------------------------*/
//링크 바로가기
function go_url(url)
	{if(url != '')   window.open(url,'_blank');
		//self.location.href=this.value
	}
//------------------------------------------------------------------------------------------------------------------	
$(function(){

	//로그아웃 팝업
    //----- OPEN
    $('.logout_pop_open').on('click', function(e)  {      
        $('.logout_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.logout_popup_close_btn').on('click', function(e)  {
        $('.logout_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//포커스 강제이동
	$(".openLayer").on("click", function(){
		$(".logout_popup_box").attr("tabindex", "0").show().focus();
		$(".layerClose").click(function(){
			$(".logout_popup_box").removeAttr("tabindex").hide();
			$(".openLayer").focus();
		});
		$(".lastClose").focus(function(){
			$(".logout_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
			$(".linkAppend").focus( function(){
				$(".logout_popup_box").attr("tabindex", "0").focus();
				$(".linkAppend").remove();
			});
		});
	});

//------------------------------------------------------------------------------------------------------------------
//최초로그인 팝업
	//----- OPEN
    $('.login_first_popup_open').on('click', function(e)  {      
        $('.first_popup_box, .first_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.first_popup_box .popup_close_btn').on('click', function(e)  {
        $('.first_popup_box, .first_popup_box .popup_bg').fadeOut(350);
        e.preventDefault();
    });
/*------------------------------------------------접수-------------------------------------------------------------*/
	/*//탭 이미지 변경
	$(".reception_info_step_tab1 a").click(function() { 
		$(".reception_info_step_tab").css({"background":"url('../assets/images/sub/announcement_tab1_on.png') 0 0 no-repeat"});	
	});

	$(".reception_info_step_tab2 a").click(function() { 
		$(".reception_info_step_tab").css({"background":"url('../assets/images/sub/announcement_tab2_on.png') 0 0 no-repeat"});		
	});

	$(".reception_info_step_tab3 a").click(function() { 
		$(".reception_info_step_tab").css({"background":"url('../assets/images/sub/announcement_tab3_on.png') 0 0 no-repeat"});		
	});*/
	
  //--------------------------------------------------------------------------------------------------------------------------------------- 
  	//접수 안내
	//개인 확인하기 팝업
	//----- OPEN
    $('.validation_popup_open').on('click', function(e)  {      
        $('.validation_popup_box, .validation_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.validation_popup_box .popup_close_btn').on('click', function(e)  {
        $('.validation_popup_box, .validation_popup_box .popup_bg').fadeOut(350);
		$('.validation_popup_open').css('display', 'none');
		$('.validation_complete').css('display', 'block');
        e.preventDefault();
    });

	//기관 확인하기 팝업
	//----- OPEN
    $('.company_validation_popup_open').on('click', function(e)  {      
        $('.company_validation_popup_box, .company_validation_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.company_validation_popup_box .popup_close_btn, .validation_popup_close').on('click', function(e)  {
        $('.company_validation_popup_box, .company_validation_popup_box .popup_bg').fadeOut(350);
		$('.company_validation_popup_open').css('display', 'none');
		$('.company_validation_complete').css('display', 'block');
        e.preventDefault();
    });
 //--------------------------------------------------------------------------------------------------------------------------------------- 
	//재접수 팝업
    //----- OPEN
    $('.rereception_pop_open').on('click', function(e)  {      
        $('.rereception_popup_box, .popup_bg').fadeIn(350);
		$('.companion_popup_box').fadeOut(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.rereception_popup_box .popup_close_btn').on('click', function(e)  {
        $('.rereception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//포커스 강제이동
	$(".openLayer2").on("click", function(){
		$(".rereception_popup_box").attr("tabindex", "0").show().focus();
		$(".layerClose").click(function(){
			$(".rereception_popup_box").removeAttr("tabindex").hide();
			$(".openLayer2").focus();
		});
		$(".lastClose").focus(function(){
			$(".rereception_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
			$(".linkAppend").focus( function(){
				$(".rereception_popup_box").attr("tabindex", "0").focus();
				$(".linkAppend").remove();
			});
		});
	});
//------------------------------------------------------------------------------------------------------------------------------------------
//접수 취소 팝업
    //----- OPEN
    $('.del_reception_popup_open').on('click', function(e)  {      
        $('.del_reception_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.del_reception_popup_box .popup_close_btn').on('click', function(e)  {
        $('.del_reception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//포커스 강제이동
	$(".openLayer3").on("click", function(){
		$(".del_reception_popup_box").attr("tabindex", "0").show().focus();
		$(".layerClose").click(function(){
			$(".del_reception_popup_box").removeAttr("tabindex").hide();
			$(".openLayer3").focus();
		});
		$(".lastClose").focus(function(){
			$(".del_reception_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
			$(".linkAppend").focus( function(){
				$(".del_reception_popup_box").attr("tabindex", "0").focus();
				$(".linkAppend").remove();
			});
		});
	});
//------------------------------------------------------------------------------------------------------------------------------------------------
//접수 취소 완료 안내 팝업
    //----- OPEN
    $('.complete_del_reception_popup_open').on('click', function(e)  {      
        $('.complete_del_reception_popup_box, .popup_bg').fadeIn(350);
		$('.del_reception_popup_box').fadeOut(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.complete_del_reception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//포커스 강제이동
	$(".openLayer4").on("click", function(){
		$(".complete_del_reception_popup_box").attr("tabindex", "0").show().focus();
		$(".layerClose").click(function(){
			$(".complete_del_reception_popup_box").removeAttr("tabindex").hide();
			$(".openLayer4").focus();
		});
		$(".lastClose").focus(function(){
			$(".complete_del_reception_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
			$(".linkAppend").focus( function(){
				$(".complete_del_reception_popup_box").attr("tabindex", "0").focus();
				$(".linkAppend").remove();
			});
		});
	});
//------------------------------------------------------------------------------------------------------------------------------------------------
	

	

//------------------------------------------------------------------------------------------------------------------------------------------------
	/*//전화번호 강제
	$(document).ready(function() {  
		$("#reception_charge_tel, #mypage_company_company_tel").focus(focused); //input에 focus일 때
		$("#reception_charge_tel, #mypage_company_company_tel").blur(blured);   //focus out일 때
	})

	function focused(){
	  var input = $("#reception_charge_tel, #mypage_company_company_tel").val();
	  //input안에서 하이픈(-) 제거
	  var phone = input.replace( /-/gi, '');
	  var phone2 = input.replace( /-/gi, '');
	  //number 타입으로 변경(숫자만 입력)
	  $("#reception_charge_tel, #mypage_company_company_tel").prop('type', 'number');	  
	  $("#reception_charge_tel, #mypage_company_company_tel").val(phone);
	}

	function blured(){
	  var input = $("#reception_charge_tel, #mypage_company_company_tel").val();
	  
	  //숫자에 하이픈(-) 추가
	  var phone = chkItemPhone(input);
	  var phone2 = chkItemPhone(input);
	  //text 타입으로 변경
	  $("#reception_charge_tel, #mypage_company_company_tel").prop('type', 'text');	  
	  $("#reception_charge_tel, #mypage_company_company_tel").val(phone);
	}
//------------------------------------------------------------------------------------------------------------------------------------------------

	//전화번호 문자(-)
	function chkItemPhone(temp) {
	  var number = temp.replace(/[^0-9]/g, "");
	  var phone = "";

	  if (number.length < 9) {
		return number;
	  } else if (number.length < 10) {
		phone += number.substr(0, 2);
			phone += "-";
			phone += number.substr(2, 3);
		phone += "-";
		phone += number.substr(5);
	  } else if (number.length < 11) {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3, 3);
		phone += "-";
		phone += number.substr(6);
	  } else {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3, 4);
		phone += "-";
		phone += number.substr(7);
	  }

	  return phone;
	}
*/
//------------------------------------------------------------------------------------------------------------------------------------------------------
	
//-------------------------------------------------------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------------------------------------------------------
	$('#selectEmail2').change(function(){ 
		$("#selectEmail2 option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$("#str_email3").val(''); //값 초기화 
				$("#str_email3").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$("#str_email3").val($(this).text()); //선택값 입력 
				$("#str_email3").attr("disabled",true); //비활성화
			} 
		}); 
	});	
//--------------------------------------------------------------------------------------------------------------------------------------------------------
	//이메일 입력방식 선택
	$('#reception_expert_email3').change(function(){ 
		$("#reception_expert_email3 option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$("#reception_expert_email2").val(''); //값 초기화 
				$("#reception_expert_email2").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$("#reception_expert_email2").val($(this).text()); //선택값 입력 
				$("#reception_expert_email2").attr("disabled",true); //비활성화
			} 
		}); 
	});	
});
//---------------------------------------------------------------------------------------------------------------------------------------------------------
//첨부파일
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
});
//---------------------------------------------------------------------------------------------------------------------------------------------------------
//접수 취소 완료 안내 팝업
//----- OPEN
$('.attachments_popup_open').on('click', function(e)  {      
	$('.attachments_popup_box, .popup_bg').fadeIn(350);
	e.preventDefault();
});

//----- CLOSE
$('.attachments_popup_open .popup_close_btn').on('click', function(e)  {
	$('.attachments_popup_box, .popup_bg').fadeOut(350);
	e.preventDefault();
});	

/*포커스 강제이동
$(".openLayer5").on("click", function(){
	$(".attachments_popup_box").attr("tabindex", "0").show().focus();
	$(".layerClose").click(function(){
		$(".attachments_popup_box").removeAttr("tabindex").hide();
		$(".openLayer5").focus();
	});
	$(".lastClose").focus(function(){
		$(".attachments_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
		$(".linkAppend").focus( function(){
			$(".attachments_popup_box").attr("tabindex", "0").focus();
			$(".linkAppend").remove();
		});
	});
});
	*/
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//접수 제출 완료 안내 팝업
//----- OPEN
$('.reception_complete_popup_open').on('click', function(e)  {      
	$('.reception_complete_popup_box, .popup_bg').fadeIn(350);
	e.preventDefault();
});

//----- CLOSE
$('.reception_complete_popup_box .popup_close_btn').on('click', function(e)  {
	$('.reception_complete_popup_box, .popup_bg').fadeOut(350);
	e.preventDefault();
});	

//포커스 강제이동
$(".openLayer6").on("click", function(){
	$(".reception_complete_popup_box").attr("tabindex", "0").show().focus();
	$(".layerClose").click(function(){
		$(".reception_complete_popup_box").removeAttr("tabindex").hide();
		$(".openLayer6").focus();
	});
	$(".lastClose").focus(function(){
		$(".reception_complete_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
		$(".linkAppend").focus( function(){
			$(".reception_complete_popup_box").attr("tabindex", "0").focus();
			$(".linkAppend").remove();
		});
	});
});
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------
//셀페체크리스트항목 팝업 팝업
    //----- OPEN
$('.selfchecklist_popup_open').on('click', function(e)  {      
	$('.selfchecklist_popup_box, .popup_bg').fadeIn(350);
	e.preventDefault();
});

//----- CLOSE
$('.popup_close_btn').on('click', function(e)  {
	$('.selfchecklist_popup_box, .popup_bg').fadeOut(350);
	e.preventDefault();
});	

//포커스 강제이동
$(".openLayer7").on("click", function(){
	$(".selfchecklist_popup_box").attr("tabindex", "0").show().focus();
	$(".layerClose").click(function(){
		$(".selfchecklist_popup_box").removeAttr("tabindex").hide();
		$(".openLayer7").focus();
	});
	$(".lastClose").focus(function(){
		$(".selfchecklist_popup_box").append("<a href='javascript:void(0);' class='linkAppend'></a>");
		$(".linkAppend").focus( function(){
			$(".selfchecklist_popup_box").attr("tabindex", "0").focus();
			$(".linkAppend").remove();
		});
	});
});
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------

//셀프체크리스트 항목 셀 추가
$(document).on("click",".selfchecklist_popup_add_btn",function(){       
	var addStaffText = '<tr>' +
		'<td>'+'<textarea name="selfchecklist_popup_add_txt" id="selfchecklist_popup_add_txt" rows="5" class="w100"></textarea><label for="selfchecklist_popup_add_txt" class="hidden"></label>' + '</td>'+	
		'<td>' + '<input type="radio" id="area_class4" name="" value="예" /> <label for="area_class4">예</label><input type="radio" id="area_class4_2" name="" value="아니오" />	<label for="area_class4_2">아니오</label>'+ '</td>' 
		+ '</tr>';

	var trHtml = $( ".selfchecklist_popup_box tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
	trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
});
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

//셀페체크리스트항목 미체크 경고 팝업
//----- OPEN
$('.selfchecklistnecessary_warning_popup_open').on('click', function(e)  {      
	e.preventDefault();
	alert("체크하지 않은 항목이 있습니다. 모두 체크해주세요.");
});
	
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
//회원가입 - 탭
/*	jQuery(function($){
		// List Tab Navigation
		var $tab_list = $('.member_info_step_tab');
		$tab_list.removeClass('jx').find('ul .tab_txt').hide();
		$tab_list.find('li li.active').parents('li').addClass('active');
		$tab_list.find('li.active>ul').show();
		$tab_list.each(function(){
			var $this = $(this);
			$this.height($this.find('li.active>ul').height()+40);
		});
		function listTabMenuToggle(event){
			var $this = $(this);
			$this.next('ul').show().parent('li').addClass('active').siblings('li').removeClass('active').find('>ul').hide();
			$this.closest('.step_tab').height($this.next('ul').height()+40);
			if($this.attr('href') === '#'){
				return false;
			}
		}
		$tab_list.find('>ul>li>a').click(listTabMenuToggle).focus(listTabMenuToggle);
	});*/




/*---------------------------------------------------------마이페이지------------------------------------------------------------------------------*/
/*----------------------------------------------------------기관정보관리--------------------------------------------------------------------------*/
//기관정보관리
	//탭
	function tab_menu(num) {
		var f = $('.mypage_company_tab').find('li');
		for (var i = 0; i < f.length; i++) {
			if (i == num) {
				f.eq(i).addClass('active');
				$('.menu_tab0' + i).show();
			} else {
				f.eq(i).removeClass('active');
				$('.menu_tab0' + i).hide();
			}
		}
	}
//-------------------------------------------------------------------------------------------------------------------------------------------------------
	//기관정보등록 팝업
    //----- OPEN
    $('.company_signup_popup_open').on('click', function(e)  {      
        $('.company_signup_popup_box, .company_signup_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.company_signup_popup_close_btn').on('click', function(e)  {
        $('.company_signup_popup_box, .company_signup_popup_box .popup_bg, .company_signup_popup_open_info').fadeOut(350);
		//테이블안에 disabled 해제 
		var condition = $(".d_input").prop( 'disabled' ); 
	    //$(".d_input").prop("disabled", condition ? false : true);
		$(".d_input").attr('disabled', false);
		$('.member_info_save, .member_area_table button').css('display', 'block');
		$('.member_info_popup_open2').css('display', 'none');
        e.preventDefault();
    });	
	
//----------------------------------------------------------------------------------------------------------------------------------------------------------
	//개인정보관리 저장 클릭 
	$('.member_info_save').on('click', function(e)  {
		e.preventDefault();
		alert("저장되었습니다.");
		$('.member_info_popup_open2').css('display', 'block');
		$('.member_info_save').css('display', 'none');
		$(".d_input").prop( 'disabled', true ); 
		
	});
//-------------------------------------------------------------------------------------------------------------------------------------------------------
	//비밀번호 변경 팝업
	//----- OPEN
    $('.pw_change_popup_open').on('click', function(e)  {      
        $('.pw_change_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.pw_change_popup_box .popup_close_btn').on('click', function(e)  {
        $('.pw_change_popup_box, .popup_bg').fadeOut(350);
		alert("입력하신 비밀번호로 변경되었습니다.");
        e.preventDefault();
    });	

	/*$('.pw_change').on('click', function(e)  {
		var condition = $(".d_input2").prop( 'disabled' ); 
	    $(".d_input2").prop("disabled", condition ? false : true);
		$(this).css('display', 'none');
		$('.pw_change_save').css('display', 'block');
	});	
	//비밀번호 변경 저장
	$('.pw_change_save').on('click', function(e)  {
		e.preventDefault();
		alert("저장되었습니다.");
	});*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------
	/*사업자등록번호 인증 팝업
	//----- OPEN
    $('.companynumber_popup_open').on('click', function(e)  {      
        $('.companynumber_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.companynumber_popup_close_btn').on('click', function(e)  {
        $('.companynumber_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//미등록 기관 사업자 등록번호 - 중복확인 
	 $('.notsignup_test_company_number').on('click', function(e)  {      
        e.preventDefault();
		alert("입력하신 사업자 등록번호가 중복됩니다. 다시 입력해 주시기 바랍니다.");
		//alert("입력하신 사업자 등록번호가 확인되었습니다.");
    });*/
//---------------------------------------------------------------------------------------------------------------------------------------------------------
	//기관명 직접입력 체크 해제
	$("input#mypage_company_name_check").on('click',function(){
		var chk = $('input:checkbox[id="mypage_company_name_check"]').is(":checked");
		if(chk==true){
			$('#mypage_company_name').attr('disabled', false);
		}else{
			$('#mypage_company_name').attr('disabled', true);
		}
	});
//---------------------------------------------------------------------------------------------------------------------------------------------------------
	//개인 라디오 버튼 체크시 디세이블
	$(document).ready(function(){	 
		// 라디오버튼 클릭시 이벤트 발생
		$("input:radio[name=mypage_company_g]").click(function(){
			//var button_joinus = document.getElementById('companynumber_popup_open');
			if($("input[name=mypage_company_g]:checked").val() == "1"){
				$("input:text[name=li_number]").attr("disabled",false);
				$(".mypage_company_name_popup_open").css('display', 'block');
				button_joinus.disabled = false;
				// radio 버튼의 value 값이 1이라면 활성화
	 
			}else if($("input[name=mypage_company_g]:checked").val() == "0"){
				  $("input:text[name=li_number]").attr("disabled",true);
				  $(".mypage_company_name_popup_open").css('display', 'none');
					button_joinus.disabled = true;				  
				// radio 버튼의 value 값이 0이라면 비활성화
			}
		});
	});
//-------------------------------------------------------------------------------------------------------------------------------------------------------------	

	//기관정보등록 저장버튼(show,hide)
	function toggleText() {
	  var text = document.getElementById("demo");
	  var text2 = document.getElementById("demo2");
	  if (text.style.display === "none") {
		text.style.display = "block";
		text2.style.display = "none";
	  } else {
		text.style.display = "none";
		text2.style.display = "block";
		
	  }
	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------------

	//사업자등록번호 검색 팝업	
    //----- OPEN
    $('.mypage_company_name_popup_open').on('click', function(e)  {      
        $('.mypage_company_name_popup_box, .mypage_company_name_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.mypage_company_name_popup_box .popup_close_btn').on('click', function(e)  {
        $('.mypage_company_name_popup_box, .mypage_company_name_popup_box .popup_bg').fadeOut(350);
        e.preventDefault();
    });	
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//대표자 
//대표자 추가(show,hide)
	function ceotoggleText() {
	  var text2 = document.getElementById("ceo_add");
	 var button_joinus2 = document.getElementById('ceo_add_cell_btn');			
	  if (text2.style.display === "none") {

		text2.style.display = "block";
		button_joinus2.disabled = true;
	  } else {

		text2.style.display = "none";
		button_joinus2.disabled = false;
	  }
	}

//대표자 정보 삭제
function Delete()
{
	$(".mypage_company_con_box input[type='checkbox']:checked").parent().parent().remove();

}	
//------------------------------------------------------------------------------------------------------------------------------------------------------------
//개인정보수정 팝업
	//----- OPEN
    $('.member_info_popup_open2').on('click', function(e)  {      
        $('.member_info_popup_box, .member_info_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.member_info_popup .popup_close_btn').on('click', function(e)  {
        $('.member_info_popup_box, .member_info_popup_box .popup_bg').fadeOut(350);
        e.preventDefault();
    });
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
//인증되었습니다.
$('.companynumber_popup_close_btn').on('click', function(e)  {      
	e.preventDefault();
	alert("인증되었습니다.");
});

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------


	
/*------------------------------------------------------------------------회원가입---------------------------------------------------------------------------------------*/
// 회원가입 탭
$(function(){
	var sBtn = $(".step1_box .txt_list li");    //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
	sBtn.find("a").click(function(){   // sBtn에 속해 있는  a 찾아 클릭 하면.
		//sBtn.removeClass("active");     // sBtn 속에 (active) 클래스를 삭제 한다.
		//$(this).parent().addClass("active"); // 클릭한 a에 (active)클래스를 넣는다.
		$('.step1_box .txt_list li a .check_icon').css('display', 'block');
		$('.step1_box .btn_box').css('display', 'block');
	});

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
//다음,이전버튼 show
	//다음-1
	$('.step1_box .next_btn_2step').on('click', function(e)  { 
		 $('.member_info_step1, .member_info_step2').addClass('active');
		 $('.member_info_step4, .member_info_step5, .member_info_step3').removeClass('active');
		 $('.step2_box').css('display', 'block');
		 $('.step1_box, .step3_box, .step4_box, .step4_box_2, .step5_box').css('display', 'none');
	});
   

	//다음-2
	$('.step2_box button.next_btn').on('confirm', function(e)  { 
		 $('.member_info_step1, .member_info_step2, .member_info_step3').addClass('active');
		 $('.member_info_step4, .member_info_step5').removeClass('active');
		 $('.step3_box').css('display', 'block');
		 $('.step1_box, .step2_box, .step4_box, .step4_box_2, .step5_box').css('display', 'none');
	});
	//이전-2
	$('.step2_box button.prv_btn').on('click', function(e)  { 
		 $('.member_info_step1').addClass('active');
		 $('.member_info_step2, .member_info_step3, .member_info_step4, .member_info_step5').removeClass('active');
		 $('.step1_box').css('display', 'block');
		 $('.step2_box, .step3_box, .step4_box, .step4_box_2, .step5_box').css('display', 'none');
	});


	//다음-3
	$('.step3_box button.next_btn').on('confirm', function(e)  { 
		 $('.member_info_step1, .member_info_step2, .member_info_step3, .member_info_step4').addClass('active');
		 $('.member_info_step5').removeClass('active');
		 $('.step4_box').css('display', 'block');
		 $('.step1_box, .step2_box, .step3_box, .step5_box, .step4_box_2').css('display', 'none');
	});
	//이전-3
	$('.step3_box button.prv_btn').on('click', function(e)  { 
		$('.member_info_step1, .member_info_step2').addClass('active');
		$('.member_info_step3, .member_info_step4, .member_info_step5').removeClass('active');
		$('.step2_box').css('display', 'block');
		$('.step3_box, .step1_box, .step4_box, .step5_box, .step4_box_2').css('display', 'none');
	});


	//다음-4
	$('.step4_box .complete_btn, .step4_box_2 .complete_btn').on('click', function(e)  {   
		 $('.member_info_step1, .member_info_step2, .member_info_step3, .member_info_step4, .member_info_step5').addClass('active');
		 $('.step5_box').css('display', 'block');
		 $('.step1_box, .step2_box, .step3_box, .step4_box, .step4_box_2').css('display', 'none');
	});

	//이전-4
	$('.step4_box button.prv_btn').on('click', function(e)  { 
		$('.member_info_step1 .member_info_step2, .member_info_step3').addClass('active');
		$('.member_info_step4, .member_info_step5').removeClass('active');
		$('.step3_box').css('display', 'block');
		$('.step2_box, .step1_box, .step4_box, .step5_box, .step4_box_2').css('display', 'none');
	});

	//아이디 중복 체크 팝업
	//----- OPEN
    $('.id_check_info_popup_open').on('click', function(e)  {      
        $('.id_check_info_popup_box, .id_check_info_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.id_check_info_popup_box .popup_close_btn').on('click', function(e)  {
        $('.id_check_info_popup_box, .id_check_info_popup_box .popup_bg').fadeOut(350);
        e.preventDefault();
    });
 })

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//거소증 외국인 확인
$('.foreigner_box_click').on('click', function(e)  { 
	$('.foreigner_box').css('display', 'block');
	$('.foreigner_not_box').css('display', 'none');
});

	//다음-3
	$('.foreigner_notcertification').on('click', function(e)  { 
		 $('.member_info_step1, .member_info_step2, .member_info_step3, .member_info_step4').addClass('active');
		 $('.member_info_step5').removeClass('active');
		 $('.step4_box_2').css('display', 'block');
		 $('.step1_box, .step2_box, .step3_box, .step5_box, .step4_box').css('display', 'none');
	});

	$('.step1_box .btn_box button').on('click', function(e)  {  
	    $('.foreigner_not_box').css('display', 'block');
		$('.foreigner_box, .step1_box .btn_box').css('display', 'none');

	});

	//이전-3
	$('.step4_box_2 .prv_btn').on('click', function(e)  { 
		$('.member_info_step1').addClass('active');
		$('.member_info_step3, .member_info_step2, .member_info_step4, .member_info_step5').removeClass('active');
		$('.step1_box').css('display', 'block');
		$('.step3_box, .step2_box, .step4_box, .step5_box, .step4_box_2').css('display', 'none');
	});
//----------------------------------------------------------------------------------------------------------------------------------------------------
/*----------------------------------------------------------------------------------------------------------------------------------------------------*/
//최초로그인 팝업
	//----- OPEN
    $('.login__').on('click', function(e)  {      
        $('.first_popup_box, .first_popup_box .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.first_popup_box .popup_close_btn').on('click', function(e)  {
        $('.first_popup_box, .first_popup_box .popup_bg').fadeOut(350);
        e.preventDefault();
    });
//------------------------------------------------------------------------------------------------------------------------------------------------------

/*--------------------------------------------------------------전문가 등록-------------------------------------------------------------------------------*/
//전문가 등록 페이지
	//all_chexk
	$("#allCheck").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#allCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".expert_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".expert_table input[type=checkbox]").prop("checked",false); 
		} 
	});

	$("#allCheck2").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#allCheck2").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".expert_hope_search_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".expert_hope_search_table input[type=checkbox]").prop("checked",false); 
		} 
	});
	
	$("#allCheck3").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#allCheck3").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".expert_table_ input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".expert_table_ input[type=checkbox]").prop("checked",false); 
		} 
	});

	
	//학위취득연도
	function numberMaxLength(e){
        if(e.value.length > e.maxLength){
            e.value = e.value.slice(0, e.maxLength);
        }
        e.value = e.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
    }

	//신규전문가
	$('.new_expert').on('click', function(e)  { 
		$(this).parent('li').addClass('on');
		$('.existing_expert').parent('li').removeClass('on');
		$('.new_expert_box').fadeIn(350);		
		$('.existing_expert_box').css('display', 'none');
		$('.new_expert_box .info_txt').css('display', 'block');
        e.preventDefault();
    });

	//기존 전문가
	$('.existing_expert').on('click', function(e)  {
		$(this).parent('li').addClass('on');
		$('.new_expert').parent('li').removeClass('on');			
        $('.existing_expert_box').fadeIn(350);
		$('.new_expert_box').css('display', 'none');
		$('.new_expert_box .info_txt').css('display', 'none');
        e.preventDefault();
    });
	
	//미체크 경고팝업
	/*
	e.preventDefault();
	alert("체크하지 않은 항목이 있습니다. 모두 체크해주세요.");
	alert("필수 항목에 기재하지 않은 항목이 있습니다.");
	*/

	//본인인증-보이게
	$(".phone_certification_btn").click(function(){		
		$('.new_expert_box').css('display', 'block');		
	});
	
	/*//본인인증 완료
		//----- OPEN
		$('.expert_certification_popup').on('click', function(e)  {      
			$('.expert_certification_popup_box, .security_popup_box .popup_bg').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.expert_certification_popup_box .popup_close_btn').on('click', function(e)  {
			$('.expert_certification_popup_box,  .expert_certification_popup_box .popup_bg').fadeOut(350);
			e.preventDefault();
		});*/

	//보안 서약 확인
		//----- OPEN
		$('.security_popup_open').on('click', function(e)  {      
			$('.security_popup_box, .security_popup_box .popup_bg').fadeIn(350);
			e.preventDefault();
		});
		
		
		//----- CLOSE
		$('.security_popup_box .popup_close_btn, .security_popup_box .complate_close').on('click', function(e)  {
			$('.security_popup_box, .security_popup_box .popup_bg').fadeOut(350);
			e.preventDefault();
		});
	
		//팝업 동의 체크하면 페이지 같은 항목 동의 체크
		$("#securitypopup_txt_check").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#securitypopup_txt_check").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
				$("input#security_txt_check[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
			} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
				$("input#security_txt_check[type=checkbox]").prop("checked",false); 
			} 
		});

	//개인정보 수집 및 이용 동의
	//----- OPEN
		$('.personal_information_popup_open').on('click', function(e)  {      
			$('.personal_information_popup_box, .personal_information_popup_box .popup_bg').fadeIn(350);
			e.preventDefault();
		});

		//----- CLOSE
		$('.personal_information_popup_box .popup_close_btn').on('click', function(e)  {
			$('.personal_information_popup_box, .personal_information_popup_box .popup_bg').fadeOut(350);
			e.preventDefault();
		});

		//팝업 동의 체크하면 페이지 같은 항목 동의 체크
		$("#personal_information_popup_check").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#personal_information_popup_check").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
				$("#personal_information_check[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
			} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
				$("#personal_information_check[type=checkbox]").prop("checked",false); 
			} 
		});
	
	
	//논문/저서 -추가
	$('.treatise_add').on('click', function(e)  {
		var addStaffText = '<tr>' +
		'<td class="first"><input type="text" id="treatise" class="form-control w100 fl"><label for="treatise" class="hidden">논문/저서명1</label></td>			<td><input type="text" id="academic_personname" class="form-control w100 fl"><label for="academic_personname" class="hidden">학술자명1</label></td>		<td><label for="posting_day" class="hidden">발행일자1</label><div class="datepicker_area fl mr5"><input type="text" id="posting_day" class="datepicker form-control w_14 mr5 ls"></div></td><td class="last"><div class="clearfix" style="margin: auto;width:50px"><input type="checkbox" id="mypage_company_ceo_check" class="fl ml10 mr5" /><label for="mypage_company_ceo_check" class="fl">SCI</label></div></td>' 
		+ '</tr>';
		var trHtml = $( ".treatise_table tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
		$('.treatise_table_box').css('overflow-y', 'scroll');
	});
	
	//지식재산권 -추가	
	$('.license_add').on('click', function(e)  {
		var addStaffText = '<tr>' +
		'<td class="first clearfix"><input type="radio" id="license_pending4" name="" checked /><label for="license_pending" class="mr5">출원</label><input type="radio" id="license_enrollment4" name="" /><label for="license_enrollment4">등록</label></td><td><input type="text" id="license_name4" class="form-control w100 fl" /><label for="license_name4" class="hidden">특허명4</label></td><td><input type="text" id="license_number4" class="form-control w100 fl" /><label for="license_number4" class="hidden">출원번호/등록번호4</label></td><td><input type="text" id="license_personname4" class="form-control w100 fl" /><label for="license_personname4" class="hidden">출원인4</label></td><td class="last"><div class="datepicker_area fl mr5"><input type="text" id="license_day4" class="datepicker form-control w_14 mr5 ls" /></div><label for="license_day4" class="hidden">출원일/등록일4</label></td>' 
		+ '</tr>';
		var trHtml = $( ".license_table tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
		$('.license_table_box').css('overflow-y', 'scroll');
	});

	//기술이전 -추가	
	$('.technology_transmigrate_add').on('click', function(e)  {
		var addStaffText = '<tr>' +
		'<td class="first clearfix"><input type="text" id="technology_transmigrate_name" class="w100" /><label for="technology_transmigrate_name" class="hidden">기술명4</label></td><td><div class="datepicker_area fl mr5"><input type="text" id="technology_transmigrate_day" class="datepicker form-control w_14 mr5 ls" /></div><label for="technology_transmigrate_day" class="hidden">기술이전일4</label></td><td class="last"><input type="text" id="technology_transmigrate_company" class="w100" /><label for="technology_transmigrate_company" class="hidden">기술이전기업4</label></td>' 
		+ '</tr>';
		var trHtml = $( ".technology_transmigrate_table tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
		$('.technology_transmigrate_table_box').css('overflow-y', 'scroll');
	});

	//R&D과제  -추가	
	$('.rnd_add').on('click', function(e)  {
		var addStaffText = '<tr>' +
		'<td class="first clearfix"><label for="rnd_problem_name" class="hidden">기술명4</label><input type="text" id="rnd_problem_name" class="w100" /></td>		<td class="clearfix"><div class="datepicker_area fl"><label for="rnd_problem_day" class="hidden">기술이전일4</label><input type="text" id="rnd_problem_day" class="datepicker form-control w_12 ls" /></div><span class="fl ml5 mr5 mt5">~</span><div class="datepicker_area fl mr5"><label for="rnd_problem_day" class="hidden">기술이전일4</label><input type="text" id="rnd_problem_day_1" class="datepicker form-control w_12 ls" /></div></td><td><label for="rnd_research_class" class="hidden">연구분야4</label><input type="text" id="rnd_research_class" class="w100" /></td><td class="last"><label for="rnd_4th_technology" class="hidden">4차산업기술분류</label><select name="rnd_4th_technology" id="rnd_4th_technology" class="w100 ace-select"><option value="5G">5G</option><option value="스마트헬스케어">스마트헬스케어</option></select></td>' 
		+ '</tr>';
		var trHtml = $( ".rnd_table tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
		$('.rnd_table_box').css('overflow-y', 'scroll');
	});

	
	//이메일 입력방식 선택
	$('#expert_email3').change(function(){ 
		$("#expert_email3 option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$("#expert_email2").val(''); //값 초기화 
				$("#expert_email2").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$("#expert_email2").val($(this).text()); //선택값 입력 
				$("#expert_email2").attr("disabled",true); //비활성화
			} 
		}); 
	});	
/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------희망 전문가 요청 사업--------------------------------------------------------------------------*/
	//수락 팝업
	//----- OPEN
    $('.accept_popup_btn').on('click', function(e)  {      
        $('.accept_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.accept_popup_box .popup_close_btn').on('click', function(e)  {
        $('.accept_popup_box, .popup_bg, .accept_popup_box').fadeOut(350);
        e.preventDefault();
    });
/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------홈화면------------------------------------------------------------------------------*/
	//희망 전문가 요청 사업 - 셀렉트 박스 보이게 - index.html
	$('#select_expert_class_').change(function() {
		var state = jQuery('#select_expert_class_ option:selected').val();
		if ( state == '1' ) {
			jQuery('#select_expert_class').show();
			 $('.input_search_box').css('width', '53.1%');
			 $('#expert_input_txt2').css('width', '78%');			 
		} else {
			jQuery('#select_expert_class').hide();
			$('.input_search_box').css('width', '74%');
		}
	});

	//list_목록
	$('#select_expert_class_2').change(function() {
		var state = jQuery('#select_expert_class_2 option:selected').val();
		if ( state == '1' ) {
			jQuery('#select_expert_class2').show();
			 $('.input_search_box2').css('width', '52%');
		} else {
			jQuery('#select_expert_class2').hide();
			$('.input_search_box2').css('width', '73.1%');
		}
	});
/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------접수등록페이지----------------------------------------------------------------------------------*/

	//기관, 개인 선택
	$(document).ready(function(){ 
		$("#selector_company").click(function() {
			$("#copmpany_area").css('display', 'block');
			$("#member_area").css('display', 'none');
		});
		
		$("#selector_member").click(function() {
			$("#member_area").css('display', 'block');
			$("#copmpany_area").css('display', 'none');
		});
	});

	
	//연구책임자 개인정보
	$("input#memberinfo_check").on('click',function(){
		var chk = $('input:checkbox[id="memberinfo_check"]').is(":checked");
		if(chk==true){
			$('.member_d input, #member_reception_phone').attr('disabled', true);			
			$('.address_search').css('display', 'none');
			$('#member_reception_member_reception_charge_mail3').css('display', 'none');
		}else{
			$('.member_d input, #member_reception_phone').attr('disabled', false);
			$('.address_search').css('display', 'block');			
			$('#member_reception_member_reception_charge_mail3').css('display', 'block');	
		}
	});

	//이메일(연구책임자 정보)-개인
	$('#member_reception_member_reception_charge_mail3').change(function(){ 
		$("#member_reception_member_reception_charge_mail3 option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$("#member_reception_member_reception_charge_mail2").val(''); //값 초기화 
				$("#member_reception_member_reception_charge_mail2").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$("#member_reception_member_reception_charge_mail2").val($(this).text()); //선택값 입력 
				$("#member_reception_member_reception_charge_mail2").attr("disabled",true); //비활성화
			} 
		}); 
	});	
	
	//연구책임자 기관
	$("input#companyinfo_check").on('click',function(){
		var chk = $('input:checkbox[id="companyinfo_check"]').is(":checked");
		if(chk==true){
			$('.company_d input, #company_reception_phone').attr('disabled', true);			
			$('.address_search').css('display', 'none');
			$('#company_reception_charge_mail3').css('display', 'none');
		}else{
			$('.company_d input, #company_reception_phone').attr('disabled', false);
			$('.address_search').css('display', 'block');
			$('#company_reception_charge_mail3').css('display', 'block');
		}
	});

	//이메일(연구책임자 정보)-기관
	$('#company_reception_charge_mail3').change(function(){ 
		$("#company_reception_charge_mail3 option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$("#company_reception_charge_mail2").val(''); //값 초기화 
				$("#company_reception_charge_mail2").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$("#company_reception_charge_mail2").val($(this).text()); //선택값 입력 
				$("#company_reception_charge_mail2").attr("disabled",true); //비활성화
			} 
		}); 
	});	

	//기관 - 컨설팅 요청사항 - 컨설팅 목적(기타)
	$("input[type=radio][name=con_radio_check]").on('click',function(){
		var chkValue = $('input[type=radio][name=con_radio_check]:checked').val();
		if(chkValue=='8. 기타'){
			$('#con_purpose8_comment').attr('disabled', false);			
		
		} else {		
			$('#con_purpose8_comment').attr('disabled', true);		
		}
	});
	
	//희망전문가 직접입력
	$(".expert_input_btn, .expert_input_table_txt_add").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($(".expert_input_btn").prop("checked")) {
			$('.expert_hope_search_table2 .d_n, .expert_hope_search_table2 input, .expert_hope_search_table2 textarea, .expert_hope_search_table2 select, .expert_hope_search_table2 span, .select_write').css('display', 'inline-block');
			$('#expert_select_btn_div, .expert_input_table_txt_add, .expert_input_table_txt_del').css('display', 'block');

		} else { 
			$('.expert_hope_search_table2 .d_n, .expert_hope_search_table2 input, .expert_hope_search_table2 textarea, .expert_hope_search_table2 select, .expert_hope_search_table2 span, .select_write').css('display', 'none');
			$('#expert_select_btn_div, .expert_input_table_txt_add, .expert_input_table_txt_del').css('display', 'none');
		} 
	});

	//직접입력 클리어 - 기관
	 $('.expert_input_table_txt_del').click( function() {
        $( '.expert_input_table tbody tr td input, .expert_input_table tbody tr td textarea').val("");
		$(".expert_input_table #expert_MainCategory option:eq(0), #expert_MiddleCategory option:eq(0), #expert_SubClass option:eq(0)").prop("selected", true);
     });

	//첨부파일
		//기술컨설팅
		$("#fileUpload2").change(function(){			
			fileList = $("#fileUpload2")[0].files;
			fileListTag = '';
			for(i = 0; i < fileList.length; i++){
				fileListTag += "<li>"+fileList[i].name+'<a href="javascript:void(0);" class="del_btn fr"><i class="fas fa-times" /></i></a>'+"</li>";
			}
			$('#fileList2').html(fileListTag);
			$('#fileList2').css('display', 'block');		
		});
		//$('#fileUpload2').off('scroll touchmove mousewheel');
		
			//첨부파일 삭제
			$('#fileList2 li .del_btn').on('click', function(e)  {
				$(this).parent().css('display', 'none');	
			});

			//위
			
		

		//기술연구개발
		$("#fileUpload").change(function(){			
			fileList = $("#fileUpload")[0].files;
			fileListTag = '';
			for(i = 0; i < fileList.length; i++){
				fileListTag += "<li>"+fileList[i].name+'<a href="javascript:void(0);" class="del_btn fr"><i class="fas fa-times" /></i></a>'+"</li>";
			}
			$('#fileList').html(fileListTag);
			$('#fileList').css('display', 'block');		
		});	
		//$('#fileUpload').off('scroll touchmove mousewheel');
	
			//첨부파일 삭제
			$('#fileList li .del_btn').on('click', function(e)  {
				$(this).parent().css('display', 'none');	
			});



	//기술컨설팅, R&D 항목 값에 따른 내용 변환
	$('input[type=radio][id="con_reception_class"]').on('click', function(e)  {		
		$('.charge_con').css('display', 'block');	
		$('.charge_rnd').css('display', 'none');
	});

	$('input[type=radio][id="rnd_reception_class"]').on('click', function(e)  {		
		$('.charge_rnd').css('display', 'block');	
		$('.charge_con').css('display', 'none');
	});

	
	

	

	//희망전문가 글 삭제
	$('.expert_hope_search_table_del').click( function() {
		var check_txt = $(".expert_hope_search_table input:checked");
		 if($(".expert_hope_search_table input").is(":checked") == true){              
			check_txt.parents().parents('tr').empty();			
		}else {
			alert("삭제할 항목을 선택해주세요!")
		}       
     });
 
	

	//접수 완료 안내
	$('.reception_complete_popup_open2').click( function() {			
		alert("매칭신청이 완료되었습니다.");
		e.preventDefault();
	});

	
	
	//소속캠퍼스타운 선택
	//----- OPEN
    $('.reception_campus_popup_open').on('click', function(e)  {      
        $('.reception_campus_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.reception_campus_popup_box .popup_close_btn').on('click', function(e)  {
        $('.reception_campus_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });

	//전문가 검색 리스트 누르면 팝럽(전문가 정보)
	
	//----- OPEN
    $('.expert_search_view_popupopen_btn').on('click', function(e)  {      
        $('.reception_expert_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.reception_expert_popup_box .popup_close_btn').on('click', function(e)  {
        $('.reception_expert_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });








/*------------------------------------------------------------------공통팝업--------------------------------------------------------------------------------*/
//공통팝업
	//----- OPEN
    $('.common_popup_open').on('click', function(e)  {      
        $('.common_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.common_popup_box .popup_close_btn').on('click', function(e)  {
        $('.common_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });

 //-----------------------------------------------------------------------------------------------------------------------------------------------------------
	
/*20210514 추가*/
//전문가회신
	//전체 체크박스 선택 - 매칭회신 있는경우
	$("#allCheck4").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#allCheck4").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".reply_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".reply_table input[type=checkbox]").prop("checked",false); 
		} 
	});
	 
	//매칭회신 없는경우
	$("#allCheck5").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#allCheck5").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
			$(".none_reply_table2 input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
			$(".none_reply_table2 input[type=checkbox]").prop("checked",false); 
		} 
	});
	
	//전문가 정보 1명만 선택 팝업
	//----- OPEN
    $('.reply_oneselect_popup_open').on('click', function(e)  {      
        $('.reply_oneselect_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.reply_oneselect_popup_box .popup_close_btn').on('click', function(e)  {
        $('.reply_oneselect_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });

	//임시저장 팝업
	//----- OPEN
    $('.save_popup2_open').on('click', function(e)  {      
        $('.save_popup2_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.save_popup2_box .popup_close_btn').on('click', function(e)  {
        $('.save_popup2_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });

	//접수완료 팝업
	//----- OPEN
    $('.save_popup_open').on('click', function(e)  {      
        $('.save_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.save_popup_box .popup_close_btn').on('click', function(e)  {
        $('.save_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });

	//매칭신청완료 팝업
	//----- OPEN
    $('.machhing_save_popup_open').on('click', function(e)  {      
        $('.machhing_save_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.machhing_save_popup_box .popup_close_btn').on('click', function(e)  {
        $('.machhing_save_popup_box, .popup_bg').fadeOut(350);
		$('.new_matching_hidden').css("display", "none");
        e.preventDefault();
    });

	//매칭포기 팝업
	//----- OPEN
    $('.machhing_ab_popup_box_open').on('click', function(e)  {      
        $('.machhing_ab_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });

    //----- CLOSE
    $('.machhing_ab_popup_box .popup_close_btn').on('click', function(e)  {
        $('.machhing_ab_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });

	//매칭(기관)첨부파일 - 기술컨설팅
	$(document).ready(function(){
        $(".custom-file-input-write-company").on("change", function() {
            var fileName = $(this).val().split("\\").pop();
            $(this).siblings(".custom-control-label-write-company").addClass("selected").html(fileName);
        });
    });

	//매칭(기관)첨부파일 - 기술연구개발
	$(document).ready(function(){
        $(".custom-file-input-write-company2").on("change", function() {
            var fileName = $(this).val().split("\\").pop();
            $(this).siblings(".custom-control-label-write-company2").addClass("selected").html(fileName);
        });
    });

	//회신전문가 팝업에서 삭제(접수취소)
	$(".machhing_ab_popup_box .del_select").click(function(){ 
		$(".reply_table tbody tr td").parent().css('display', 'none');
		$("table.list thead tr:nth-child(2) th:first-child").css('border', '0px');		
	})


/*0517 추가*/
	// 매칭 하기 안내
	//----- OPEN
    $('.maching_reception_popup_open').on('click', function(e)  {      
        $('.maching_reception_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });	
	//----- CLOSE
    $('.maching_reception_popup_box .popup_close_btn').on('click', function(e)  {
        $('.maching_reception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	// 매칭 하기완료 안내
	//----- OPEN
    $('.maching_completereception_popup_open').on('click', function(e)  {      
        $('.maching_completereception_popup_box, .popup_bg').fadeIn(350);
		$('.maching_reception_popup_box').fadeOut(350);
        e.preventDefault();
    });	
	//----- CLOSE
    $('.maching_completereception_popup_box .popup_close_btn').on('click', function(e)  {
        $('.maching_completereception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//----------------------------------------------------------------------------------------------------------------------------------------------
	// 매칭 취소 안내
	//----- OPEN
    $('.machingdel_reception_popup_open').on('click', function(e)  {      
        $('.machingdel_reception_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });
    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.machingdel_reception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	
	//----------------------------------------------------------------------------------------------------------------------------------------------
	// 매칭 취소완료 안내
	//----- OPEN
    $('.complete_machingdel_reception_popup_open').on('click', function(e)  {      
        $('.machingcomplete_del_reception_popup_box, .popup_bg').fadeIn(350);
		$('.machingdel_reception_popup_box').fadeOut(350);
        e.preventDefault();
    });	
	//----- CLOSE
    $('.machingcomplete_del_reception_popup_box .popup_close_btn').on('click', function(e)  {
        $('.machingcomplete_del_reception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	//----------------------------------------------------------------------------------------------------------------------------------------------
	// 접수 하기 안내
	//----- OPEN
    $('.complate_reception_popup_open').on('click', function(e)  {      
        $('.complate_reception_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });
    //----- CLOSE
    $('.popup_close_btn').on('click', function(e)  {
        $('.complate_reception_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	
	//----------------------------------------------------------------------------------------------------------------------------------------------
	// 접수 하기완료 안내
	//----- OPEN
    $('.complate_reception_popup_box2_open').on('click', function(e)  {      
        $('.complate_reception_popup_box2, .popup_bg').fadeIn(350);
		$('.complate_reception_popup_box').fadeOut(350);
        e.preventDefault();
    });	
	//----- CLOSE
    $('.complate_reception_popup_box2 .popup_close_btn').on('click', function(e)  {
        $('.complate_reception_popup_box2, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	
		
	//----------------------------------------------------------------------------------------------------------------------------------------------
	//view.html 수정 못하게 디세이블 및 달력버튼 안보이게
	 $(".not_view_reception table input, .not_view_reception table select, .not_view_reception table button, .not_view_reception table textarea, .not_view_reception table checkbox").attr("disabled", true);
	 $("input:radio[name=reply_check]").attr("disabled", false);

	 $('.new_match').on('click', function(e)  {
		$(".not_view_reception table input, .not_view_reception table select, .not_view_reception table input, .not_view_reception table button, .not_view_reception table textarea, .not_view_reception table checkbox").attr("disabled", false);
		$(".expert_input_btn, #checkbox3_1").prop("checked", false);
		$(".expert_input_table tbody, .select_write, .expert_input_table_txt_add, .expert_input_table_txt_del").css("display", 'none');
		$('.not_view_reception .ui-datepicker-trigger, .not_view_reception table button, .not_view_reception .custom-file button').css('display','inline-block');
		$('#con_reception_belong').attr("disabled",true); 
		$('.new_matching_hidden').css("display", "block");
	 });
	 $(document).ready(function(){	
		 $('.not_view_reception .ui-datepicker-trigger, .not_view_reception table button, .not_view_reception .custom-file button').css('display','none');
	 });

	//----------------------------------------------------------------------------------------------------------------------------------------------
	 // 반려 사유안내 팝업
	//----- OPEN
    $('.companion_popup_open').on('click', function(e)  {      
        $('.companion_popup_box, .popup_bg').fadeIn(350);
        e.preventDefault();
    });	
	//----- CLOSE
    $('.companion_popup_box .popup_close_btn').on('click', function(e)  {
        $('.companion_popup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	

	// 신규매칭 팝업
	//----- OPEN
    $('.new_machhingpopup_open').on('click', function(e)  {      
        $('.new_machhingpopup_box, .popup_bg').fadeIn(350);		
        e.preventDefault();
    });	

	$('.new_machhingpopup_box .new_match, .machhing_ab_popup_box .new_match').on('click', function(e)  {      
        $('.new_machhingpopup_open, .machhing_ab_popup_box_open').css('display', 'none');
        e.preventDefault();    
	});

	
	//----- CLOSE
    $('.new_machhingpopup_box .popup_close_btn').on('click', function(e)  {
        $('.new_machhingpopup_box, .popup_bg').fadeOut(350);
        e.preventDefault();
    });	
	
	//----------------------------------------------------------------------------------------------------------------------------------------------
	//20210609 추가	
	//희망전문가 직접입력
	$(".expert_input_btn, .expert_input_table_txt_add").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
		if($(".expert_input_btn").prop("checked")) {
			$('.expert_hope_search_table2 tbody').show();
			$('#expert_select_btn_div, .expert_input_table_txt_add, .expert_input_table_txt_del').css('display', 'block');

		} else { 
			$('.expert_hope_search_table2 tbody').hide();
			$('#expert_select_btn_div, .expert_input_table_txt_add, .expert_input_table_txt_del').css('display', 'none');
		} 
	});
	//----------------------------------------------------------------------------------------------------------------------------------------------
	//희망전문가 추가
	$('.expert_input_table_txt_add').on('click', function(e)  {		
		var addStaffText = '<tr>' + 
	   '<td><div><input type="checkbox" id="add_expert_checkbox3_1'+ (count2++) +'"><label for="add_expert_checkbox3_1'+ (count++) +'" >&nbsp;</label></div></td>'+
	   '<td><label for="" class="hidden">연구분야</label><textarea name="" id="" cols="30" rows="2" class="w100" ></textarea></td>'+
		'<td><label for="" class="hidden">성명</label><input type="text" id="" class="form-control w100" /></td>'+
		'<td><label for="" class="hidden">기관명</label><input type="text" id="" class="form-control w100" /></td>'+
		'<td><label for="" class="hidden">부서</label><input type="text" id="" class="form-control w100" /></td>'+
		'<td><label for="" class="hidden">휴대전화</label><select name="" id="" class="w_8 fl d_input ls"><option value="010">010</option></select><span class="fl mc8">-</span><label for="" class="hidden">전화</label><input type="tel" id="" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl" ><span class="fl mc8 ls">-</span><label for="" class="hidden">전화</label><input type="tel" id="" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl ls"></td>'+
		'<td class="last"><label for="" class="hidden">이메일</label><input type="text" id="" class="form-control w100 direct_companypart_email" placeholder="ex)XXX@email.com" /></td>' 
		+ '</tr>';

		var trHtml = $( ".expert_hope_search_table2 tr:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
		trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
		//$('.rnd_table_box').css('overflow-y', 'scroll');
	});



	//신규매칭에서 희망전문가 직접입력 추가버튼 디세이블 해제
	$('.new_machhingpopup_box .new_match').on('click', function(e)  {      
        $('.expert_input_table_txt_add, .expert_input_table_txt_del, .select_write').attr('disabled', false);
        e.preventDefault();
    });	

///---------------------------------------------------------------------------------------------------------------------------------------------------------
	
/*20210623 추가 - 아이디, 비밀번호 찾기 페이지*/
	//아이디 찾기  - 없음경우 알럿창
	//----- OPEN
    $('.id_search_none_popup_open').on('click', function(e)  {    
       alert("입력하신 정보에 해당하는 아이디가 존재하지 않습니다.");	
        e.preventDefault();
    });	


	//비밀번호 찾기 - 없을경우 알럿창
	//----- OPEN
	$('.password_search_none_popup_open').on('click', function(e)  {    
       alert("회원 정보가 존재하지 않습니다. \n다시 확인하시고 입력해 주시기 바랍니다.");	
        e.preventDefault();
    });	
	
	//접수 -기술 컨설팅 요청사항 - 소속 캠퍼스 타운 input태그 디세이블 처리
	$('#con_reception_belong, #esearch_reception_belong').attr("disabled",true); 

/*-----------------------------------------------------------0804추가---------------------------------------------------------------------------------------*/
//-----------------------------------------------------------------------------------------------------------------------------------------------------------
//평가 (0804 추가)
//평가위원 등록 페이지
//다음,이전버튼 show
	//다음-1
	/*$('.agreement_sign_box .agreement_step1_box .next_btn').on('click', function(e)  { 
		 $('.agreement_sign_box .agreement_step2_box').css('display', 'block');
		 $('.agreement_sign_box .agreement_step1_box').css('display', 'none');
	});
	//평가위원 - 다음버튼
	//greement_step1_box
	$('.agreement_sign_box .greement_step1_box .next_btn').on('click', function(e)  { 
		// $('.agreement_sign_box .greement_step1_box .next_btn').addClass('active');
		 //$('.member_info_step4, .member_info_step5, .member_info_step3').removeClass('active');
		 $('.agreement_sign_box .agreement_step2_box').css('display', 'block');
		 $('.agreement_sign_box .agreement_step1_box, .agreement_sign_box .agreement_step3_box').css('display', 'none');
	});
		
	$('.agreement_sign_box .agreement_step1_box .next_btn').click( function() {
		var check_txts = $(".agreement_sign_box .agreement_step1_box input[name=member_info_terms_of_service]:checked");
		 if($(".agreement_sign_box .agreement_step1_box input[name=member_info_terms_of_service]").is(":checked") == true){    
			 $('.agreement_sign_box .agreement_step2_box').css('display', 'block');
			 $('.agreement_sign_box .agreement_step1_box').css('display', 'none');
			
		}else {
			alert("개인정보 추가 수집 동의가 필요합니다. 동의 체크하신 후 다시 시도해 주시기 바랍니다.");			
		}       
	 });*/



	 $('.agreement_sign_box .agreement_step1_box .next_btn').click( function() {		
		 if($(".agreement_sign_box .agreement_step1_box input[name=member_info_terms_of_service]").is(":checked") && $(".agreement_sign_box .agreement_step1_box input[name=member_info_usageagreement_service]").is(":checked") && $(".agreement_sign_box .agreement_step1_box input[name=member_info_security_service]").is(":checked")== true){    
			 $('.agreement_sign_box .agreement_step2_box').css('display', 'block');
			 $('.agreement_sign_box .agreement_step1_box').css('display', 'none');
		}else {
			alert("체크하지 않은 항목이 있습니다. 모든 항목에 동의가 필요합니다.");			
		}       
	 })

	//----------------------------------------------------------------------------------------------------------------------------------------------------------

	//greement_step2_box
	$('.agreement_sign_box .agreement_step2_box .next_btn').on('click', function(e)  { 
		// $('.agreement_sign_box .greement_step1_box .next_btn').addClass('active');
		 //$('.member_info_step4, .member_info_step5, .member_info_step3').removeClass('active');
		 $('.agreement_sign_box .agreement_step3_box').css('display', 'block');
		 $('.agreement_sign_box .agreement_step2_box, .agreement_sign_box .agreement_step1_box').css('display', 'none');
	});

	//greement_step3_box
	$('.agreement_sign_box .agreement_step3_box .next_btn').on('click', function(e)  { 
		// $('.agreement_sign_box .greement_step1_box .next_btn').addClass('active');
		 //$('.member_info_step4, .member_info_step5, .member_info_step3').removeClass('active');
		 $('.agreement_sign_box .agreement_step3_box').css('display', 'block');
		 $('.agreement_sign_box .agreement_step2_box, .agreement_sign_box .agreement_step1_box').css('display', 'none');
	});

	//----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	

	//전화번호, 휴대전화 번호, 년도 넘버만 입력(한글 입력 강제 안됨)
	$("input[type='tel'], input.number_t[type='text']").keyup(function(event){
		var inputVal = $(this).val();
		$(this).val(inputVal.replace(/[^0-9]/gi,''));
	});
	
	//----------------------------------------------------------------------------------------------------------------------------------------------------------

	//4차 산업 셀렉트 박스 가변형
	//$( "#industry_4th_technology" ).selectmenu( "option", "width", "auto" );

     
	/*연도 셀렉트박스
	$(document).ready(function () {
		setDateBox();
    });

    //select box 연도 , 월 표시
    function setDateBox() {
		var dt = new Date();	
		var year = "";
		var com_year = dt.getFullYear();
	
		//발행 뿌려주기
		$(".year").append("<option value=''>년도</option>");

		//올해 기준으로 -50년부터 +1년을 보여준다.
		for (var y = (com_year - 50); y <= (com_year + 1); y++) {
		  $(".year").append("<option value='" + y + "'>" + y + " 년" + "</option>");
		}

	
		//월 뿌려주기(1월부터 12월)
		/*var month;
		$("#month").append("<option value=''>월</option>");
		for (var i = 1; i <= 12; i++) {
		  $("#month").append("<option value='" + i + "'>" + i + " 월" + "</option>");
		}

		//일 뿌려주기(1일부터 31일)
		var day;
		$("#day").append("<option value=''>일</option>");
		for (var i = 1; i <= 31; i++) {
			$("#day").append("<option value='" + i + "'>" + i + " 일" + "</option>");
		}
	}*/

	//----------------------------------------------------------------------------------------------------------------------------------------------------------

	//number type 인풋 - 맥심엄 - 4자
	function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
        object.value = object.value.slice(0, object.maxLength);
		} 
	}	

	//----------------------------------------------------------------------------------------------------------------------------------------------------------

	
	/*//평가 위원 등록- 첨부파일
		$(document).ready(function(){
			var fileTarget = $('.upload-hidden');
			var fileTarget3 = $('.upload-hidden3');			

			fileTarget.on('change', function(){
				if(window.FileReader){
					var filename = $(this)[0].files[0].name;
				} else {
					var filename = $(this).val().split('/').pop().split('\\').pop();
				}

				$(this).siblings('.upload-name').val(filename);
			});
			
			fileTarget3.on('change', function(){
				if(window.FileReader){
					var filename3 = $(this)[0].files[0].name;
				} else {
					var filename3 = $(this).val().split('/').pop().split('\\').pop();
				}

				$(this).siblings('.upload-name3').val(filename3);
			});
		}); */

	//----------------------------------------------------------------------------------------------------------------------------------------------------------	

	//테이블 row 추가
		//평가위원 등록 - 학력 체크박스 제어
			//all_chexk
			$("#education_allCheck").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
				if($("#education_allCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
					$(".education_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
				} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
					$(".education_table input[type=checkbox]").prop("checked",false); 
				} 
			});	

			//테이블 선택 삭제
			$('.del_education_btn').click( function() {
				var check_txts = $(".education_table input[type=checkbox]:checked");				
				 if($(".education_table tbody input[type=checkbox]").is(":checked") == true){    
					alert("선택하신 항목을 삭제 하시겠습니까?");
					check_txts.parents().parents('tbody tr').empty();
					alert("선택하신 항목이 삭제되었습니다.");
					$(".education_table thead input[type=checkbox]").prop("checked",false); 
					
				}else {
					alert("삭제할 항목을 선택해주세요!");
					$(".history_table thead input[type=checkbox]").prop("checked",false); 
				}       
			 });

	//----------------------------------------------------------------------------------------------------------------------------------------------------------
		 //평가위원 등록 - 경력 체크박스 제어
			//all_chexk
			$("#history_allCheck").click(function(){ //만약 전체 선택 체크박스가 체크된상태일경우 
				if($("#history_allCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
					$(".history_table input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우
				} else { //해당화면에 모든 checkbox들의 체크를해제시킨다.
					$(".history_table input[type=checkbox]").prop("checked",false); 
					alert("삭제할 항목을 선택해주세요!")
				} 
			});	

			//테이블 선택 삭제
			$('.del_history_btn').click( function() {
				var check_txts = $(".history_table input[type=checkbox]:checked");
				 if($(".history_table tbody input[type=checkbox]").is(":checked") == true){    
					alert("선택하신 항목을 삭제 하시겠습니까?");
					check_txts.parents().parents('tbody tr').empty();
					alert("선택하신 항목이 삭제되었습니다.");
					$(".history_table thead input[type=checkbox]").prop("checked",false); 
					
				}else {
					alert("삭제할 항목을 선택해주세요!");
					$(".history_table thead input[type=checkbox]").prop("checked",false); 
				}       
			 });

	 
	//----------------------------------------------------------------------------------------------------------------------------------------------------------
			 
		var count = 0; 
		var count2 = 0;		
		//학력
		$(".add_education_btn").click(function(){ 			
			$('.education_table tbody tr:last').after(
		   '<tr>' + 
		   '<td class="first clearfix"><input type="checkbox" id="education_checkbox1_'+ (count2++) +'"><label for="education_checkbox1_'+ (count++) +'" class="education_checkbox">&nbsp;</label></td>'+
		   '<td><select class="ace-select w100" id="degree_type_'+ (count2++) +'"><option value="학사">학사</option><option value="석사">석사</option><option value="박사">박사</option></select><label for="degree_type_'+ (count++) +'" class="hidden">학위</label></td>' + 
		   '<td><input type="text" class="form-control w100" id="school_name_'+ (count2++) +'"><label for="school_name_'+ (count++) +'" class="hidden">학교명</label></td>' + 
		   '<td><input type="text" class="form-control w100" id="major_number_'+ (count2++) +'"><label for="major_number_'+ (count++) +'" class="hidden">전공</label></td>' + 
		   '<td><input type="text" class="form-control w60 ls number_t" maxlength="4" id="degree_day_'+ (count2++) +'"  /><label for="degree_day_'+ (count++) +'"> 년</label>' + '</td>' + 

		   //'<td class="last"><div class="clearfix file_form_txt"><!--업로드 버튼-->	<div class="filebox bs3-primary"><input class="upload-name w100 upload_text" value="선택된 파일이 없습니다." id="upload-name'+ (count2++) +'" disabled="disabled"><label for="upload-name'+ (count++) +'" class="hidden">선택된 파일이 없습니다.</label><input type="file" id="ex_filename'+ (count2++) +'" class="upload-hidden"><label for="ex_filename'+ (count++) +'" class="mt5 input_file">학위증명서 찾기</label> </div><!--//업로드 버튼	--></div>	</td>' + 
			'<td class="last"><div class="file_box"><input type="file" /></td>'+
		   '</tr>');
		});

		//경력 
		$(".add_history_btn").click(function(){ 		
			$('.history_table tbody tr:last').after(
		   '<tr>' + 
		   '<td class="first clearfix"><input type="checkbox" id="history_checkbox1'+ (count2++) +'"><label for="history_checkbox1'+ (count++) +'" class="history_checkbox">&nbsp;</label>	      </td>' +
		   '<td><input type="text" id="company_name_'+ (count2++) +'" class="form-control w100" /><label for="company_name_'+ (count++)+'" class="hidden">근무처</label></td>'+
		   '<td><input type="text" id="company_divisions_'+ (count2++) +'" class="form-control w100" /><label for="company_divisions_'+ (count++)+'" class="hidden">근무부서</label></td>'+
		   '<td><input type="text" id="company_rank_'+ (count2++) +'" class="form-control w100 ls" /><label for="company_rank_'+ (count++)+'" class="hidden">직급</label></td>'+	
		   '<td><input type="text" id="join_day_'+ (count2++) +'" class="form-control w40 ls  number_t" maxlength="4" /><label for="join_day_'+ (count++)+'" class="mr10">년</label><input type="text" id="join_day2_'+ (count2++) +'" class="form-control w20 ls number_t" maxlength="2"  /><label for="join_day2_'+ (count++)+'">월</label></td>'+
		   '<td><input type="text" id="leave_day_'+ (count2++) +'" class="form-control w40 ls  number_t" maxlength="4" /><label for="leave_day_'+ (count++)+'" class="mr10">년</label><input type="text" id="leave_day2_'+ (count2++) +'" class="form-control w20 ls  number_t" maxlength="2" /><label for="leave_day2_'+ (count++)+'">월</label></td>'+
		  '<td class="last"><textarea name="business_information" id="business_information_'+ (count2++) +'" rows="3"></textarea><label for="business_informatio_'+ (count++)+'n" class="hidden">업무내용</label></td>' +'</tr>');			
		});		

	
	//----------------------------------------------------------------------------------------------------------------------------------------------------------

	//평가 위원 임시저장 팝업
		//----- OPEN
		$('.temporary_storage_popup_btn').on('click', function(e)  {      
			$('.temporary_storage_popup_box, .popup_bg').fadeIn(350);		
			e.preventDefault();
		});	
		
		//----- CLOSE
		$('.temporary_storage_popup_box .popup_close_btn').on('click', function(e)  {
			$('.temporary_storage_popup_box, .popup_bg').fadeOut(350);
			e.preventDefault();
		});	
	
	//이전 버튼
		 $('.agreement_sign_box .agreement_step3_box .prv_btn').click( function() {			 
			 $('.agreement_sign_box .agreement_step2_box').css('display', 'block');
			 $('.agreement_sign_box .agreement_step1_box, .agreement_sign_box .agreement_step3_box').css('display', 'none');		      
		});

	//평가 위원 완료 팝업
		//----- OPEN
		$('.complate_popup_btn').on('click', function(e)  {      
			$('.complate_popup_box, .popup_bg').fadeIn(350);		
			e.preventDefault();
		});	
		
		//----- CLOSE
		$('.complate_popup_box .popup_close_btn').on('click', function(e)  {
			$('.complate_popup_box, .popup_bg').fadeOut(350);
			e.preventDefault();
		});	
	//----------------------------------------------------------------------------------------------------------------------------------------------------------
	
	/*----------------------------------------------------------마이페이지 - 평가위원정보관리------------------------------------------------------------------------*/
	//평가 위원 관리
		$(document).ready(function(){
			var mypage_agreementdata_modify = $(".mypage_agreementdata_area input, .mypage_agreementdata_area select, .mypage_agreementdata_area textarea, .mypage_agreementdata_area .d_input, .mypage_agreementdata_area .ui-datepicker-trigger").prop( 'disabled', true ); $(".mypage_agreementdata_area p")
			mypage_agreementdata_modify.attr( 'disabled', true );
		});	


	//마이페이지 - 평가위원 관리 수정버튼
		$(".member_agreementdata_modify_btn").click(function() { 
		   var mypage_agreementdata_modify = $(".mypage_agreementdata_area input, .mypage_agreementdata_area select, .mypage_agreementdata_area textarea, .mypage_agreementdata_area .d_input, .mypage_agreementdata_area .ui-datepicker-trigger").prop( 'disabled', true );
			$(".d_input").prop("disabled", mypage_agreementdata_modify ? false : true);
			if( $(this).text() == '평가위원 정보 수정' ) {
				$(this).text('평가위원 정보 수정 완료');				
				mypage_agreementdata_modify.prop( 'disabled', false );			
			}
			else {          
				mypage_agreementdata_modify.prop( 'disabled', true );
				$(this).text('평가위원 정보 수정');
				alert("수정이 완료 되었습니다.");
			}
		
		});	

/*------------------------------------------------------------평가위원 홈화면 announcement_list.html -----------------------------------------------------------------*/
	
	//---------------------------------보안서약서
	//보안서역서 완료 팝업
		//----- OPEN
		$('.security_popup_btn').on('click', function(e)  {  			
			$('.security_popup_box, .popup_bg').fadeIn(350);		
			e.preventDefault();
		});

		// 서명하기 > 완료텍스트 변경
		$('.security_popup_btn').on('click', function(e)  {   
			//var lastButton = $('.announcement_index_table td.last')
			$(this).addClass('add_pledge');
			$(this).parents('td').siblings('td.last').addClass('add_click_ok');	
			$('.sign_complate').hide();
		});	
		
		$('.receipt_popup_btn').on('click', function(e)  {   
			//var lastButton = $('.announcement_index_table td.last')
			$(this).addClass('add_pledge');
			$(this).parents('td').siblings('td.last').addClass('add_click_ok');	
			$('.sign_complate').hide();
		});	

		
		//미작성->작성완료 텍스트 변경
		$('.security_popup_box .complate_close, .receipt_popup_box .complate_close').on('click', function() {
		  $('.add_pledge').parent('td').html("<span class='font_blue'>작성완료</span>");		  	  	       
		});

		//작성 완료 팝업
		//----- OPEN
		$('.security_popup_box .complate_close').on('click', function() {
		 $('.security_ok_popup_box').fadeIn(350);	
		 $('.m_a').hide();
		 $(this).hide();
		});

		//----- close
		$('.security_ok_popup_box .popup_close_btn').on('click', function() {
			$('.security_ok_popup_box').fadeOut(350);
			$('.security_preview_btn').show();
		       
		});


		//-----보안서약서 미리보기
		//----- 미리보기 새창 OPEN - 사인창 띄우기
		$('.security_preview_btn').click( function() {		
			 if($(".security_popup_box input[name=security_of_service1]").is(":checked") && $(".security_popup_box input[name=security_of_service2]").is(":checked") && $(".security_popup_box input[name=security_of_service3]").is(":checked")== true){    
				var url = "../html/estimation_security_sign.html";  
				window.open(url, "_blank", 'width=700, height=460'); 				
				//$('.security_popup_box').fadeOut(350);				
			}else {
				alert("체크하지 않은 항목이 있습니다. 모든 항목에 동의가 필요합니다.");			
			}  			
		 });
		 
		 //수정이 완료되지 않았을 때
		 $(document).ready(function(){
			//btn_reset 을 클릭했을때의 함수
			$( "#btn_reset, #btn_reset1_1").click(function () {
				$( "#reset_test_form" ).each( function () {
					this.reset();
				});
			});

			//btn_reset 을 클릭했을때의 함수
			$( "#btn_reset2").click(function () {
				$( "#reset_test_form2" ).each( function () {
					this.reset();
				});
			});
			
			 //닫기 버튼 눌렀을때 초기화
			$( "#btn_reset2_1").click(function () {
				$( ".receipt_popup_box input" ).prop( 'disabled', true );
				$('.bank_name_amend_btn, .account_number_amend_btn').text('수정하기');
				
			});			 
		});
		
		//보안청구서-사인
		/*$(document).ready(function() {
			$('#linear').signaturePad({drawOnly:true, lineTop:200});
			$('#smoothed').signaturePad({drawOnly:true, drawBezierCurves:true, lineTop:200});
			$('#smoothed-variableStrokeWidth').signaturePad({drawOnly:true, drawBezierCurves:true, variableStrokeWidth:true, lineTop:200});
		});
		//지급청구서-사인
		$(document).ready(function() {
			$('#linear2').signaturePad({drawOnly:true, lineTop:200});
			$('#smoothed').signaturePad({drawOnly:true, drawBezierCurves:true, lineTop:200});
			$('#smoothed-variableStrokeWidth').signaturePad({drawOnly:true, drawBezierCurves:true, variableStrokeWidth:true, lineTop:200});
		});*/

	//---------------------------------지급청구서
	//작성 완료 팝업
		$('.receipt_preview_btn').click( function() {		
			 if($("#bank_name").is(":disabled") && $("#bank_number").is(":disabled") == true){    
				var url = "../html/estimation_receipt_sign.html";  
				window.open(url, "_blank", 'width=700, height=460'); 				
				//$('.security_popup_box').fadeOut(350);				
			}else {
				alert("수정이 완료 되지 않았습니다.");			
			}  			
		 });

		//----- OPEN
		$('.receipt_popup_box .complate_close').on('click', function() {
		   $('.receipt_ok_popup_box').fadeIn(350);	
		   $('.receipt_popup_box').fadeOut(350);		  
		   $('.m_a2').hide();
		   $('.receipt_preview_btn').show();
		});

		//----- close
		$('.receipt_ok_popup_box .popup_close_btn').on('click', function() {
			$('.receipt_ok_popup_box').fadeOut(350);		       
		});


	//지급청구서 완료 팝업		
		//----- OPEN
		$('.receipt_popup_btn').on('click', function(e)  {      
			$('.receipt_popup_box, .popup_bg').fadeIn(350);	
			$('.receipt_preview_btn').show;
			e.preventDefault();
		});	
		
		//----- CLOSE
		$('.receipt_ok_popup_box .popup_close_btn, .receipt_popup_box .popup_close_btn').on('click', function(e)  {
			$('.receipt_popup_box, .receipt_ok_popup_box, .popup_bg').fadeOut(350);
			e.preventDefault();
		});	

		
		
		
		
		

		 

		//서명 새창페이지 - 서명 불러오기			
		$('.sign_search').on('click', function(e)  { 
			alert('저장된 서명이 없습니다.\n서명을 새로 등록해 주시기 바랍니다.');
			$('.sign_search_img, .sign_search_modify, .sign_ok_okmodify').css("display", "block");	
			$('.signature-pad--body, .gray_btn2, .save_sign_popup_btn, .security_sign_ok, .sign_search').css("display", "none");
			e.preventDefault();
		});

		//서명 새창페이지 - 서명 수정하기			
		$('.sign_search_modify').on('click', function(e)  {      
			$('.sign_search_img, .sign_search_modify, .sign_ok_okmodify').css("display", "none");	
			$('.signature-pad--body, .gray_btn2, .save_sign_popup_btn, .security_sign_ok, .sign_search').css("display", "block");
			e.preventDefault();
		});


		
		//----- CLOSE
		$('.send_save_popup_box .popup_close_btn').on('click', function(e)  {
			$('.send_save_popup_box, .send_save_popup_box .popup_bg').fadeOut(350);
			e.preventDefault();
		});	

		
		//은행명 수정하기
		$(".bank_name_amend_btn").click(function() { 
			var bank_name_modify = $("#bank_name").prop('disabled', true);
			$(".d_input").prop("disabled", bank_name_modify ? false : true);
			if( $(this).text() == '수정하기' ) {
				$(this).text('수정 완료');				
				bank_name_modify.prop( 'disabled', false );			
			}
			else {          
				bank_name_modify.prop( 'disabled', true );
				$(this).text('수정하기');
				alert("수정이 완료 되었습니다.");
			}	
		});	

		//계좌번호 수정
		$(".account_number_amend_btn").click(function() { 
			var bank_number_modify = $("#bank_number").prop('disabled', true);
			$(".d_input").prop("disabled", bank_number_modify ? false : true);
			if( $(this).text() == '수정하기' ) {
				$(this).text('수정 완료');				
				bank_number_modify.prop( 'disabled', false );			
			}
			else {          
				bank_number_modify.prop( 'disabled', true );
				$(this).text('수정하기');
				alert("수정이 완료 되었습니다.");
			}	
		});
		







		/*$(".receipt_preview_btn").click(function() { 
			var bank_name_modify2 = $(".receipt_popup input[type=text]").is(':disabled')
			$(".receipt_popup input[type=text]").is("disabled", bank_name_modify2 ? false : true);
			
			if($(this).text()== '서명') {							
				var url = "../html/estimation_receipt_sign.html"
				window.open(url, "_blank", 'width=595, height=460'); 		
			}
			else {          
				
				alert("수정이 완료 되지 않았습니다.");
			}	
		});*/
		

		
		

	/*	 //-----지급청구서 미리보기
		//----- 미리보기 새창 OPEN
		$('.receipt_preview_btn').click( function() {							
			var url = "../html/estimation_receipt_sign.html"
			window.open(url, "_blank", 'width=595, height=460'); 
			//$('.receipt_popup_box').fadeOut(350);
		 });*/

/*-------------------------------------------------연구자 및 평가위원 전문가-최상상단-------------------------------------------------------------*/
	
	/*//index 상단 연구자 및 평가위원 active 컬러효과	
		var sBtn2 = $(".member_class li");    //  ul > li 이를 sBtn으로 칭한다. (클릭이벤트는 li에 적용 된다.)
		sBtn2.find("a").click(function(){   // sBtn에 속해 있는  a 찾아 클릭 하면.
		sBtn.removeClass("active");    // sBtn 속에 (active) 클래스를 삭제 한다.
		$(this).parent().addClass("active");// 클릭한 a에 (active)클래스를 넣는다.
		//$(this).parent().siblings().removeClass("active");
		});*/

		$(".member_class li").on("click", function() {
		    $(".member_class li").removeClass("active");
		    $(this).addClass("active");
		});

/*-------------------------------------------------평가위원 전자평가 평가시작 페이지------------------------------------------------------------------------------------*/
		
			
	//평가 위원 작성하기 버튼(show&hide)
		$('.rating_write_btn').on('click', function(e)  { 
			$(this).addClass('add_click_btn');
			$(this).parents('td').siblings('td.last').children('span').addClass('add_click_btn2');
			$('.rating_result_tabel_area, .rating_result_tabel_area .list_btn').fadeIn(350);
			$('.rating_leader_tabel_area, .rating_leader_tabel_area .list_btn').fadeOut(350);			
			e.preventDefault();
		});

		


	//평가 위원장 작성하기 버튼(show&hide)
		$('.rating_write_btn2').on('click', function(e)  { 
			$(this).addClass('add_click_leader_btn');
			$(this).parents('td').siblings('td.last').children('span').addClass('add_click_leader_btn2');
			$('.rating_leader_tabel_area, .rating_leader_tabel_area .list_btn').fadeIn(350);
			$('.rating_result_tabel_area, .rating_result_tabel_area .list_btn').fadeOut(350);
			$('.rating_leader_tabel_area input, .rating_leader_tabel_area textarea').prop('disabled', false);
			e.preventDefault();
		});

	
	//평가 점수 항목 점수계산
		$('.rating_result_tabel_area .sum_cell_2 input').blur(function () {
			var seip = 0;
			$('.rating_result_tabel_area .sum_cell_2 input').each(function(){ //클래스가 money인 항목의 갯수만큼 진행
				seip += Number($(this).val()); 
		});
	
	//합계를 출력
		$("#total_cell").val(seip); 
		var score = $("#total_cell").val(); 		
			if(score >= 100){
				$("#total_cell").val('100');
			}else{			 
				 $("#total_cell").val();
			}
		});

	//--------------평가 위원 서명하기 새창
		$('.rating_sign_btn').click( function() {					 
			var url = "../html/estimation_rating_sign.html";  
			window.open(url, "_blank", 'width=700, height=460');
			
		 });


	//-------------------------평가 위원 새창 
		//----- 미리보기 새창 OPEN
		$('.rating_send_popup_open').click( function() {		 
				var url = "../html/estimation_rating_preview.html";  
				window.open(url, "_blank", 'width=595, height=841');				
		 });			


		//제출
		$('.send_save_popup_box .send_save_ok_btn').click( function() {		
			alert("작성하신 내용으로 제출 되었습니다.");	
			$('.rating_sign_btn').css('display', 'none');
			$('.send_rating, .sign_info_txt').hide();			
		   //$(opener.document).find(".rating_result_tabel_area .list_btn2").show();
		    $(".add_click_btn").hide();				 
		    $('.add_click_btn2').html('<span class="font_blue">제출완료</span>');
			$('.list_back').show();
			$('.rating_result_tabel_area input, .rating_result_tabel_area textarea').prop('disabled', true);
			//$('.list_back').css('margin', '0');
		});		


		//--------open
		 $('.send_rating').on('click', function(e)  {      
			$('.send_save_popup_box, .send_save_popup_box .popup_bg').fadeIn(350);		
			e.preventDefault();
		});	
	
		//----- CLOSE
		$('.send_save_popup_box .popup_close_btn').on('click', function(e)  {
			$('.send_save_popup_box, .send_save_popup_box .popup_bg').fadeOut(350);		
			e.preventDefault();
		});	
	
		
		$('.rating_write_btn, .rating_write_btn2').on('click', function(e)  { 
			$('.list_back').css('display', 'none');
			$('.rating_result_tabel_area input, .rating_result_tabel_area textarea').prop('disabled', false);
			$('.sign_info_txt, .rating_sign_btn').show();
		});
	//-----------------------평가위원장 새창
		//----- 미리보기 새창 OPEN
		$('.rating_send_leader_popup_open').click( function() {		 
			var url = "../html/estimation_leader_sign.html";  
			window.open(url, "_blank", 'width=595, height=460');		    
		 });



		 //제출
		$('.leader_send_save_popup_box .send_save_ok_btn').click( function() {		
			alert("작성하신 내용으로 제출 되었습니다.");	
			$('.rating_btn_hide, .add_click_leader_btn').css('display', 'none');
			$('.send_leader, .sign_info_txt').fadeOut(350);				
		    $(".add_click_btn").hide();					 
		    $('.add_click_leader_btn2').html('<span class="font_blue">제출완료</span>');
			$('.list_back').show();
			$('.rating_leader_tabel_area input, .rating_leader_tabel_area textarea').prop('disabled', true);
			//$('.list_back').css('margin', '0');
		});

		//--------open
		 $('.send_leader').on('click', function(e)  {      
			$('.leader_send_save_popup_box, .leader_send_save_popup_box .popup_bg').fadeIn(350);		
			e.preventDefault();
		});	
	
		//----- CLOSE
		$('.leader_send_save_popup_box .popup_close_btn').on('click', function(e)  {
			$('.leader_send_save_popup_box, .leader_send_save_popup_box .popup_bg').fadeOut(350);		
			e.preventDefault();
		});	
		
		

		 //종합점수 테이블 - 서명 불러오기	 
		 $('.sign_annex_btn').on('click', function(e)  {
			$(this).hide();
			$(this).siblings('.sign_annex').show();
		 });

	/*---------------------------------------------------------------내부 평가자-----------------------------------------------------------------------------------------*/
	
	//내부 평가자
		//----- 미리보기 새창 OPEN
		$('.rating_send_examine_popup_open').click( function() {		 
				var url = "../html/estimation_examine_sign.html";  
				window.open(url, "_blank", 'width=595, height=460');		    
		 });
	/*--------------------------------------------------------------상단 평가페이지 메뉴 estimation.html ---------------------------------------------------------------------*/

	//리스트 페이지 - 셀렉트 옵션값에 따른 변화값
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


		

	
/*---------------------------------------------------------------------달력---------------------------------------------------------------------------------------------*/
	// 달력 꼭 맨하단
	$(".datepicker").datepicker({  
		  showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
		  //buttonImage: "/application/db/jquery/images/calendar.gif", 버튼 이미지
		  buttonText : false, 
		  buttonImageOnly: false, // 버튼에 있는 이미지만 표시한다.
		  changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
		  changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
		  minDate: '-100y', // 현재날짜로부터 100년이전까지 년을 표시한다.
		  nextText: '다음 달', // next 아이콘의 툴팁.
		  prevText: '이전 달', // prev 아이콘의 툴팁.
		  numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
		  stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
		  yearRange: 'c-100:c+10', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
		  //showButtonPanel: true,  캘린더 하단에 버튼 패널을 표시한다. ( ...으로 표시되는부분이다.) 
		  //currentText: '오늘 날짜' ,  오늘 날짜로 이동하는 버튼 패널
		  closeText: '닫기',  // 닫기 버튼 패널
		  dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
		  showAnim: "slide", //애니메이션을 적용한다.  
		  showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
		  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], // 요일의 한글 형식.
		  monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
	  
	});

/*--------------------------------------------------------------협약---------------------------------------------------------------------------------------------*/


	//휴대전화
	$(document).on("keyup", ".phoneNumber", function() { 
		$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})/,"$1-$2-$3").replace("--", "-") ); 
		// copy from https://cublip.tistory.com/326
		//﻿ 원본과 class 명만 바뀐 상태다.
	});
		
	//금액
	$(document).ready(function(){
		//키를 누르거나 떼었을때 이벤트 발생
		$("input.money").bind('keyup keydown',function(){
			inputNumberFormat(this);
		});

		//입력한 문자열 전달
		function inputNumberFormat(obj) {
			obj.value = comma(uncomma(obj.value));
		}
		  
		//콤마찍기
		function comma(str) {
			str = String(str);
			return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		}

		//콤마풀기
		function uncomma(str) {
			str = String(str);
			return str.replace(/[^\d]+/g, '');
		}

		//숫자만 리턴(저장할때)
		//alert(cf_getNumberOnly('1,2./3g')); -> 123 return
		function cf_getNumberOnly (str) {
			var len      = str.length;
			var sReturn  = "";

			for (var i=0; i<len; i++){
				if ( (str.charAt(i) >= "0") && (str.charAt(i) <= "9") ){
					sReturn += str.charAt(i);
				}
			}
			return sReturn;
		}
	});

	$(document).ready(function(){
		$(".onlynum").keyup( function(){ $(this).val( $(this).val().replace(/[^0-9]/gi,"") ); } );
	});


	//이메일 입력방식 선택
	$('.responsible_studies_email .selectEmail').change(function(){ 
		$(".responsible_studies_email .selectEmail option:selected").each(function () { 
			if($(this).val()== '1'){ //직접입력일 경우 
				$(this).parent('select').siblings(".str_email").val(''); //값 초기화 
				$(this).parent('select').siblings(".str_email").attr("disabled",false); //활성화
			}else{ //직접입력이 아닐경우
				$(this).parent('select').siblings(".str_email").val($(this).text()); //선택값 입력 
				$(this).parent('select').siblings(".str_email").attr("disabled",true); //비활성화
			} 
		}); 
	});

	//제출하기 버튼 팝업	
	//--------open
	 $('.agreement_send_popup_open').on('click', function(e)  {      
		$('.agreement_send_popup_box, .agreement_send_popup_box .popup_bg').fadeIn(350);		
		e.preventDefault();
	});	

	//----- CLOSE
	$('.agreement_send_popup_box .popup_close_btn').on('click', function(e)  {
		$('.agreement_send_popup_box').fadeOut(350);		
		e.preventDefault();
	});	
	
	 $('.agreement_send_popup_box .ok_btn').on('click', function(e)  {      
		alert('제출 되었습니다.');
		$('.agreement_send_popup_box').fadeOut(350);	
	});	



	
	//기관정보 수정버튼
	$(document).ready(function(){
		$('.assignment_info input, .assignment_info select').attr('disabled', true);
		$('.assignment_info button').css('display', 'none');
		$(".assignment_info_btn").click(function() { 			
		   var agreement_modify = $('.assignment_info input, .assignment_info select').prop( 'disabled', true );
			agreement_modify.prop("disabled", agreement_modify ? false : true);
			if( $(this).text() == '수정' ) {
				$(this).text('수정 완료');				
				agreement_modify.prop( 'disabled', false );			
			}
			else {          
				agreement_modify.prop( 'disabled', true );
				$(this).text('수정');
				alert("수정이 완료 되었습니다.");
			}
		
		});	
	});


	//협약 -협약완료, 제출완료
	$(document).ready(function(){
		$(".agreement_send_view2 input, .agreement_send_view2 select").attr('disabled', true);
		$('.agreement_send_view2 button').css('display', 'none');
		//$('.button_box button').css('display', 'block');		
	});
	
	

	//평가위원 - 사인불러오기 버튼		
	$('.sign_open_btn').on('click', function(e)  {
		//alert('등록하신 사인 이미지가 없습니다.');
		$('.sign_load').css('display', 'block');
		$(this).css('display', 'none');		
		e.preventDefault();
	});

function view(opt) {
  if(opt) {
     arrow_box.style.display = "block";
  }
  else {
     arrow_box.style.display = "none";
  }
}