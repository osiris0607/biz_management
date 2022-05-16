//평가 위원 작성하기 버튼(show&hide)
		$('.rating_write_btn').on('click', function(e)  { 
			$(this).addClass('add_click_btn');
			$(this).parents('td').siblings('td.last').children('span').addClass('add_click_btn2');					
			e.preventDefault();
			
				$('.rating_result_tabel_area, .rating_result_tabel_area .list_btn').fadeIn(350);
				$('.rating_leader_tabel_area, .rating_leader_tabel_area .list_btn, .list_back').fadeOut(350);	
			
				
		});

		

	//평가 위원장 작성하기 버튼(show&hide)
		$('.rating_write_btn2').on('click', function(e)  { 
			//$(this).addClass('add_click_leader_btn');
			//$(this).parents('td').siblings('td.last').children('span').addClass('add_click_leader_btn2');
			$('.rating_leader_tabel_area, .rating_leader_tabel_area .list_btn').fadeIn(350);
			$('.rating_result_tabel_area, .rating_result_tabel_area .list_btn').fadeOut(350);			
			e.preventDefault();
		});

		
		$('.rating_sign_btn').on('click', function(e)  { 
			var url = "../html/estimation_rating_sign.html";  
			window.open(url, "_blank", 'width=595, height=841');	
		});

		saveSignButton.addEventListener("click", function (event) {
			  if (signaturePad.isEmpty()) {
				alert("서명을 해주시기 바랍니다.");
			  } else {
			   // var dataURL = signaturePad.toDataURL("image/jpeg");
			   // download(dataURL, "signature.jpg");				   
				   //alert("서명이 저장되었습니다.");	
				   //$('.sign_ok_rating').show();

				   //제출 버튼 쇼
				   $(opener.document).find('.rating_btn_hide').hide();
				   $(opener.document).find('.send_rating').show();
				   self.close();
			  }
			});
		