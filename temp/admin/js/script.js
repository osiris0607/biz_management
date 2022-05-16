/*--------------------------------------------------index-------------------------------------------------*/
$(function(){

	//------------------------로그아웃 팝업
	//open
	$('.logout').on('click', function(e) {
		$('.logout_popup_box').fadeIn(350);
		e.preventDefault();
	});
	//close
	$('.logout_popup_box .popup_close_btn').on('click', function(e) {
		$('.logout_popup_box').fadeOut(350);
		e.preventDefault();
	});
/*------------------------------------------------------sub------------------------------------------------*/
	//-----------------------tab
	$('.tab-link').click(function() {
		const tabId = $(this).attr('data-tab');
		$('.tab-link').removeClass('current');
		$('.tab-content').removeClass('current');
		$(this).addClass('current');
		$("#" + tabId).addClass('current');
	});		
		
	//-------------------------------------------공지사항 페이지
	//-----list page
		//게시3개만 허용
		$(document).ready(function() {
            $(".notice_board_posting_check input[type=radio]:first-child").addClass('push_check');
        });		
		
		$(document).on('change', '.notice_board_posting_check input[type=radio]', function(){
			if($('.notice_board_posting_check input[type=radio]').is(":checked")){
				$(this).attr('checked', true);
				$(this).siblings('input[type=radio]').removeAttr('checked');
				
			}
		});

		$(document).on("click",".notice_board_posting_check .push_check",function(){ 			
			const radioCheck= $('.notice_board_posting_check .push_check:checked').length;
			if(radioCheck > 3){
				alert("게시할 항목은 3개까지입니다.");
				$(this).prop("checked",false);
				$(this).siblings('input[type=radio]').prop("checked", true);
			}					
		});

			
		//검색필드 초기화
		$('.search_txt_del').on('click', function(e) {
			$('#board_list_searchbox_search').val('');
		});
		
		//페이지네이션
			//페이지네이션 클릭 색상
			$('.pagination li a.num').on('click', function(e) {
				const page = $(this).parent().siblings().children();
				$(this).addClass('active');
				page.removeClass('active');
				
			});

			
			//처음페이지
			$('.pagination li a.first').on('click', function(e) {
				const pageFirst = $('.pagination li a.num').parent().siblings().children('.num');
				pageFirst.removeClass('active');
				$(".pagination li a.num:contains('1')").addClass('active');				
			});

			//끝페이지
			$('.pagination li a.last').on('click', function(e) {
				const pageLast = $('.pagination li a.num').parent().siblings().children('.num');
				pageLast.removeClass('active');
				$(".pagination li a.num").last().addClass('active');				
			});

			/*
			//화살표 - left
			$('.pagination li a.left').on('click', function(e) {
				let hasActive = $('.pagination li a.num.active');
				const onecheck = $(".pagination li a.num:contains('1')");
				if(onecheck.hasClass("active") === true) { 
					//$(this).addClass('hide');
				} 
				else if (onecheck.hasClass("active") === false) {			
					hasActive.removeClass('active');
					hasActive.parent().prev().children('.num').addClass('active');	
					//$(this).removeClass('hide');
				}						
			});

			//화살표 - right
			$('.pagination li a.right').on('click', function(e) {
				let hasActive = $('.pagination li a.num.active');
				const endcheck = $(".pagination li a.num").last();
				if(endcheck.hasClass("active") === true) { 
					//$(this).addClass('hide');
				} 
				else if (endcheck.hasClass("active") === false) {			
					hasActive.removeClass('active');
					hasActive.parent().next().children('.num').addClass('active');	
					//$(this).removeClass('hide');
				}						
			});
	*/

		//공지사항 테이블 조회수 콤마
		Number.prototype.format = function(){
			if(this==0) return 0;
			var reg = /(^[+-]?\d+)(\d{3})/;
			var n = (this + '');
			while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
			return n;
		};

		// 문자열 타입에서 쓸 수 있도록 format() 함수 추가
		String.prototype.format = function(){
			const number = parseFloat(this);
			if( isNaN(number) ) return "0";

			return number.format();
		};
		$('.number').text(function() {
			$(this).text(
				$(this).text().format()
			);
		});
		
		//list 전체선택
		$('.list_table table #allcheck').on('click', function(e) {
			const checkIs = $(".list_table table tbody .checkboxs");
			if(checkIs.prop("checked")){            
				checkIs.prop("checked",false);       
			}else{				
				
				checkIs.prop("checked",true);   
			}
		});

		//list 삭제
		//삭제
		$('.board_list_del').click(function(){       
			if($('.list_table table input[type=checkbox]:checked').length === 0){
				//삭제 팝업
				alert("삭제하실 항목을 선택해주세요.");			
			}else{					
				//삭제 팝업
				//open
				$('.board_list_del_popup_box').fadeIn(350);			

				//close
				$('.board_list_del_popup_box .popup_close_btn').on('click', function(e) {
					$('.board_list_del_popup_box').fadeOut(350);			
				});

				//close >> complete_open
				//open
				$('.board_list_del_popup_box .complete').on('click', function(e) {
					const inputParent = $('.list_table table tbody input[type=checkbox]:checked').parent().parent('tr');
					inputParent.remove();
					$('.board_list_del_complete_popup_box').fadeIn(350);	
					$('.list_table table thead input[type=checkbox]').prop('checked', false);
				});
				
				//close
				$('.board_list_del_complete_popup_box .popup_close_btn').on('click', function(e) {
					$('.board_list_del_complete_popup_box').fadeOut(350);			
				});			
			}
		});
	//-----write page
		//첨부파일
		$("#fileUpload").change(function(){
			fileList = $("#fileUpload")[0].files;
			fileListTag = '';
			for(i = 0; i < fileList.length; i++){
				fileListTag += "<li>"+'<a href="javascript:void(0);" class="del_btn fl mr5" title="삭제"><i class="fas fa-times" /></i></a>'+fileList[i].name+"</li>";
			}
			$('#fileList').html(fileListTag);	
			$('.fileList').show();
		});		
		
		//첨부파일 삭제
		$(document).on("click",".del_btn",function(){ 			
			$(this).parent().remove();				
		});

		//등록팝업
			//open
			$('.board_write').on('click', function(e) {
				$('.board_write_popup_box').fadeIn(350);			
			});

			//close
			$('.board_write_popup_box .popup_close_btn').on('click', function(e) {
				$('.board_write_popup_box').fadeOut(350);			
			});
			
			//open
			$('.board_write_popup_box .complete').on('click', function(e) {
				$('.board_write_complete_popup_box').fadeIn(350);			
			});

			//close
			$('.board_write_complete_popup_box .popup_close_btn').on('click', function(e) {
				$('.board_write_complete_popup_box').fadeOut(350);			
			});


	//-----view page
		//삭제 팝업
			//open
			$('.board_view_del').on('click', function(e) {
				$('.board_view_del_popup_box').fadeIn(350);			
			});

			//close
			$('.board_view_del_popup_box .popup_close_btn').on('click', function(e) {
				$('.board_view_del_popup_box').fadeOut(350);			
			});

			//close >> complete_open
			//open
			$('.board_view_del_popup_box .complete').on('click', function(e) {
				$('.board_view_del_complete_popup_box').fadeIn(350);			
			});
			
			//close
			$('.board_view_del_complete_popup_box .popup_close_btn').on('click', function(e) {
				$('.board_view_del_complete_popup_box').fadeOut(350);			
			});

	//-----modify page
		//수정완료 안내 팝업
			//open
			$('.board_modify').on('click', function(e) {
				$('.board_modify_popup_box').fadeIn(350);			
			});

			//close
			$('.board_modify_popup_box .popup_close_btn').on('click', function(e) {
				$('.board_modify_popup_box').fadeOut(350);			
			});	

			//close >> complete_open
			//open
			$('.board_modify_popup_box .complete').on('click', function(e) {
				$('.board_modify_complete_popup_box').fadeIn(350);			
			});

			//close
			$('.board_modify_complete_popup_box .popup_close_btn').on('click', function(e) {
				$('.board_modify_complete_popup_box').fadeOut(350);			
			});	

	//-----포스터 page
		//이미지 첨부파일	- 1개	
		var sel_file;
 
        $(document).ready(function() {
            $("#input-image").on("change", handleImgFileSelect);
        }); 
 
        function handleImgFileSelect(e) {
            var files = e.target.files;
            var filesArr = Array.prototype.slice.call(files);
 
            filesArr.forEach(function(f) {
                if(!f.type.match("image.*")) {
                    alert("이미지 파일만 가능합니다.");
                    return;
                }
 
                sel_file = f;
 
                var reader = new FileReader();
                reader.onload = function(e) {
					var fileName = $("#input-image").val().split('/').pop().split('\\').pop();
					$("#preview-image").attr("src", e.target.result);
                    $(".upload-name").val(fileName);
                }
                reader.readAsDataURL(f);
            });
        };
		
		//포스터 10개 게시
		$(document).ready(function() {
            $(".poster_board_posting_check input[type=radio]:first-child").addClass('push_check');
        });		
		
		$(document).on('change', '.poster_board_posting_check input[type=radio]', function(){
			if($('.poster_board_posting_check input[type=radio]').is(":checked")){
				$(this).attr('checked', true);
				$(this).siblings('input[type=radio]').removeAttr('checked');
				
			}
		});

		$(document).on("click",".poster_board_posting_check .push_check",function(){ 			
			const radioCheck= $('.poster_board_posting_check .push_check:checked').length;
			if(radioCheck > 10){
				alert("게시할 항목은 10개까지입니다.");
				$(this).prop("checked",false);
				$(this).siblings('input[type=radio]').prop("checked", true);
			}					
		});
	
	//-----갤러리 page 이미지 - 복수
	 $('#files').change(function(){      
        const target = document.getElementsByName('files[]');        
		var html = '';
		$.each(target[0].files, function(index, file){
			const fileName = file.name;
			html += '<div class="file">';
			html += '<img src="'+URL.createObjectURL(file)+'">'
			html += '<a href="javascript:click()" id="removeImg" title="삭제"><i class="fas fa-times"></i></a>';
			html += '<span>'+fileName+'</span>';           
			html += '</div>';
			const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
			if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp"){
				alert("파일은 (jpg, gif, png, bmp) 형식만 등록 가능합니다.");
				resetFile();
				return false;
			}
			$('.fileList').html(html);
			//첨부파일 이미지 삭제
			$(document).on("click","#removeImg",function(){ 			
				$(this).parent().remove();	
				e.preventDefault();
			});
		}); 
    });



	//-----통계관리페이지
	//달력	
       //input을 datepicker로 선언
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
       //초기값을 오늘 날짜로 설정해줘야 합니다.
       $('#datepicker').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)            
  
	//시간대별 통계 
		//합계(조회기간 방문자 명)	
		
		var timeSumResultsum = 0;
		
		//-----시간별
		$('.statisticstime .people').each(function () {
			timeSumResultsum += parseInt(this.innerText);
		});
		$('.statisticstime .sum_result').text(timeSumResultsum);
		
		//-----일자별
		$('.statisticsdate2 .people').each(function () {
			timeSumResultsum += parseInt(this.innerText);
		});
		$('.statisticsdate2 .sum_result').text(timeSumResultsum);

			//써치필드 버튼 클릭 컬러 체인지
			$('.day_class_btn_area .gray_btn3').on('click', function(e) {
				$(this).addClass('active');	
				$(this).siblings().removeClass('active');
			});

		//-----주별
		$('.statisticsweek .people').each(function () {
			timeSumResultsum += parseInt(this.innerText);
		});
		$('.statisticsweek .sum_result').text(timeSumResultsum);
				
		//-----월별
		var monthSumResultsum1 = 0;
		var monthSumResultsum2 = 0;
		var monthSumResultsum3 = 0;
		var monthSumResultsum4 = 0;
		var monthSumResultsum5 = 0;
		var monthSumResultsum6 = 0;
		var monthSumResultsum7 = 0;
		var monthSumResultsum8 = 0;
		var monthSumResultsum9 = 0;
		var monthSumResultsum10 = 0;
		var monthSumResultsum11 = 0;
		var monthSumResultsum12 = 0;
		
		//1
		$('.statisticsmonth .month1 .people').each(function () {
			monthSumResultsum1 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result1').text(monthSumResultsum1);

		//2
		$('.statisticsmonth .month2 .people').each(function () {
			monthSumResultsum2 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result2').text(monthSumResultsum2);
		
		//3
		$('.statisticsmonth .month3 .people').each(function () {
			monthSumResultsum3 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result3').text(monthSumResultsum3);		

		//4
		$('.statisticsmonth .month4 .people').each(function () {
			monthSumResultsum4 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result4').text(monthSumResultsum4);		

		//5
		$('.statisticsmonth .month5 .people').each(function () {
			monthSumResultsum5 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result5').text(monthSumResultsum5);		

		//6
		$('.statisticsmonth .month6 .people').each(function () {
			monthSumResultsum6 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result6').text(monthSumResultsum6);		

		//7
		$('.statisticsmonth .month7 .people').each(function () {
			monthSumResultsum7 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result7').text(monthSumResultsum7);
		
		//8
		$('.statisticsmonth .month8 .people').each(function () {
			monthSumResultsum8 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result8').text(monthSumResultsum8);
		
		//9
		$('.statisticsmonth .month9 .people').each(function () {
			monthSumResultsum9 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result9').text(monthSumResultsum9);
		
		//10
		$('.statisticsmonth .month10 .people').each(function () {
			monthSumResultsum10 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result10').text(monthSumResultsum10);
		
		//11
		$('.statisticsmonth .month4 .people').each(function () {
			monthSumResultsum11 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result11').text(monthSumResultsum11);
		
		//12
		$('.statisticsmonth .month12 .people').each(function () {
			monthSumResultsum12 += parseInt(this.innerText);
		});
		$('.statisticsmonth .month_sum_result12').text(monthSumResultsum12);

		
		/*$(document).ready(function() {
            const table = $('#statisticsyear');
			const tableTr = $('#statisticsyear tbody tr')
		    // 합계 계산
			let sum = 0;
			for(let i = 0; i < tableTr.length; i++)  {
				sum += parseInt(tableTr[i].cells[i].innerHTML);
			}
		  
			 // 합계 출력
			$('.year_sum_result[i]').innerText(sum);
        });*/
		
	
	//-----poster page
		//textarea 엔터키
		//- textarea 의 줄바꿈 부분을 <br/>로 변경
		$(document).ready(function(){	
			//수정관련	
				$('.business_poster_area input, .business_poster_area textarea').attr('disabled', true);
				$('.poster_image-container input, .poster_image-container textarea').attr('disabled', false);
				$('.poster_image-container label, .poster_upload-name, .poster_list_cancel').hide();
				
				//수정취소
				$(document).on("click",".business_area_contents li .poster_list_cancel",function(){ 
					var thisC = $(this);				
					//thisC.addClass('poster_list_cancel');
					//var addC = thisC.addClass('poster_list_cancel');
					//thisC.removeClass('add_poster_cancel');
					//var classAdd= addC;
					thisC.hide();
					thisC.parent().parent().find('.modify_btn, .poster_list_del').show();
					thisC.parent().parent().find('.modify_btn').text('수정');	
					thisC.parent().parent().find('input, textarea').attr('disabled','true');	
					thisC.parent().parent().find('.poster_image-container label, .poster_image-container input').hide();
					$('.poster_list_add').show();
					thisC.parent().parent().find('.modify_btn').removeClass('complate_modify_btn');
					thisC.parent().parent().siblings().children().find('.modify_btn, .poster_list_del').show();
				});
				
				//수정
				$(document).on("click",".business_area_contents li .modify_btn",function(){ 				
					var thisC = $(this);
					const BusinessPosterT= $(this).parent().parent().children().find('input, textarea');						
					const hideSiblins = $(this).parent().parent().siblings('li').find('.modify_btn, .poster_list_del, .poster_list_cancel');
					hideSiblins.hide();
					$('.poster_cancel').show();
					$('.poster_list_add').hide();
					$(this).siblings('.poster_list_cancel').show();
					$(this).siblings('.poster_list_del').hide();

					if( $(this).text() == '수정' ) {
						$(this).text('수정 완료');	
						$(this).removeClass('complate_modify_btn');	
						BusinessPosterT.attr('disabled', false);					
						$(this).parent().parent().find('.poster_image-container label, .poster_upload-name').show();
						$(this).addClass('complate_modify_btn');
					}

					//수정 팝업
					//open					
					$(document).on("click",".complate_modify_btn",function(){ 
						$('.board_list_modify_popup_box').fadeIn(350);				
					});

					//close
					$('.board_list_modify_popup_box .popup_close_btn').on('click', function(e) {
						$('.board_list_modify_popup_box').fadeOut(350);						
					});	

					//close >> complete_open
					//open
					$('.board_list_modify_popup_box .complete').on('click', function(e) {
						$('.board_list_modify_complete_popup_box').fadeIn(350);	
						thisC.text('수정');
						thisC.removeClass('complate_modify_btn');
						BusinessPosterT.attr('disabled', true);					
						$('.poster_image-container label, .poster_upload-name, .poster_list_cancel').hide();
						hideSiblins.show();
						$('.poster_list_add, .poster_list_del').show();
						$(this).removeClass('complate_modify_btn');
						$('.business_area_contents').find('.poster_list_cancel').hide();
						//$(this).parent().children().children().find('.active').removeClass('active')
					});

					//close
					$('.board_list_modify_complete_popup_box .popup_close_btn').on('click', function(e) {
						$('.board_list_modify_complete_popup_box').fadeOut(350);
							
					});	
				});

			//삭제		
				$(document).on("click",".poster_list_del",function(){ 
					var delThis = $(this)			
					//삭제 팝업
					//open
					$('.board_list_del_popup_box').fadeIn(350);			

					//close
					$('.board_list_del_popup_box .popup_close_btn').on('click', function(e) {
						$('.board_list_del_popup_box').fadeOut(350);			
					});

					//close >> complete_open
					//open
					$('.board_list_del_popup_box .complete').on('click', function(e) {
						delThis.parent().parent('li').remove();
						$('.board_list_del_complete_popup_box').fadeIn(350);				
					});
					
					//close
					$('.board_list_del_complete_popup_box .popup_close_btn').on('click', function(e) {
						$('.board_list_del_complete_popup_box').fadeOut(350);			
					});					
				});
		});

		//추가
			$('.poster_list_add').on('click', function(e) {
				$('.business_area_contents li .modify_btn').hide();
				$('.business_area_contents li .active').removeClass('active');

				var addStaffText = '<li class="clearfix li_active"><div class="business_poster_area clearfix"><input type="text" class="form-control business_poster_title" /><div class="poster_image-container"><a href="" target="_blank"><img class="poster_preview-image" src="https://dummyimage.com/300x400/ffffff/000000.png&text=preview+image" alt="포스터 이미지" /></a><label>파일 선택</label><input style="display: block;" type="file" class="hidden poster_input-image"><input class="poster_upload-name" value="첨부파일" placeholder="첨부파일"></div><div class="business_poster_text_area add_form fr"><textarea name="business_poster_text_title_outline_c1" class="business_poster_text"></textarea></div></div><div class="buttonarea fr"><button type="button" class="blue_btn modify_btn mr5">수정</button><button type="button" class="gray_btn poster_list_del">삭제</button><button type="button" class="blue_btn poster_list_add_complate mr5">등록완료</button><button type="button" class="gray_btn2 add_poster_cancel">취소</button></div></li>';
				var trHtml = $( ".business_area_contents li:first" ); 

				trHtml.before(addStaffText);
				$('.modify_btn, .poster_list_del').hide();
				$(this).hide();				
				$('.business_area_contents .add_poster_cancel').show();
			});


			//추가 취소
			$(document).on("click",".business_area_contents .add_poster_cancel",function(){ 
				$('.li_active').remove();
				$('.poster_list_add, .business_area_contents li .modify_btn, .poster_list_del').show();
				$(this).hide();				
			});

			//추가완료
			$(document).on("click",".business_area_contents .poster_list_add_complate",function(){ 
				var delThis = $(this)
				$(this).parent().parent().find('.add_poster_cancel').addClass('poster_list_cancel');				
				
				//open
				$('.board_write_popup_box').fadeIn(350);			

				//close
				$('.board_write_popup_box .popup_close_btn').on('click', function(e) {
					$('.board_write_popup_box').fadeOut(350);			
				});

				//close >> complete_open
				//open
				$('.board_write_popup_box .complete').on('click', function(e) {					
					delThis.parent().parent().find('.poster_list_cancel').removeClass(' add_poster_cancel');
					$('.board_write_complete_popup_box').fadeIn(350);					
					$('.business_area_contents li .add_btn, .li_active .poster_image-container label, .poster_upload-name, .poster_list_add_complate, .add_poster_cancel, .poster_list_cancel').hide();
					$('.poster_list_add, .modify_btn, .poster_list_del, .li_active .modify_btn').show();
					$('.li_active .business_poster_title, .li_active textarea').attr('disabled', true);					
				});			
				
				//close
				$('.board_write_complete_popup_box .popup_close_btn').on('click', function(e) {
					$('.board_write_complete_popup_box').fadeOut(350);			
				});	
			});


		//포스터 이미지 첨부파일
		/*var posterSelfile;
 
        $(document).ready(function() {
			$(document).on("change",".poster_input-image",function(){ 
				handleImgFileSelect(event);
			}); 
		});

		$(document).on("click",".poster_image-container label",function(){ 
			$(this).parent().addClass('active');
			$(this).parent().parent().parent().siblings('li').children().children('.poster_image-container').removeClass('active');
		});
        function handleImgFileSelect(e) {
            var files = e.target.files;
            var filesArr = Array.prototype.slice.call(files);
 
            filesArr.forEach(function(f) {
                if(!f.type.match("image.*")) {
                    alert("이미지 파일만 가능합니다.");
                    return;
                }
 
                posterSelfile = f;   			

				var reader = new FileReader();
                reader.onload = function(e) {					
					var fileName = $(".poster_input-image").val().split('/').pop().split('\\').pop();

					$(".active .poster_preview-image").attr("src", e.target.result);
                    $(".active .poster_upload-name").val(fileName);
                }
                reader.readAsDataURL(f);
            });
        }*/






});











