<script type='text/javascript'>

	$(document).ready(function() {
		searchDetail();
	});

	
	/*******************************************************************************
	* 갤러리 상세 조회
	*******************************************************************************/
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/userHome/api/board/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("board_id", $("#board_id").val());
		comAjax.ajax();
	}
	function searchDetailCB(data){
		console.log(data);
		if ( data.result == false){
			alert("갤러리 정보가 없습니다. 다시 시도해 주시기 바랍니다.");
			return;
		}

		$("#txt_businessName").html("<p id='bs_class'>" + data.result_data.business_name + "</p>");
		$("#txt_date").html(data.result_data.from_date + " ~ " + data.result_data.to_date);
		$("#txt_title").html("<p>" +  data.result_data.title + "</p>");
		$("#txt_institueName").html("<p>" + data.result_data.institue_name + "</p>");
		$("#txt_skillKeyword").html("<p>" + data.result_data.skill_keyword + "</p>");
		$("#txt_description").html("<p>" + unescapeHtml(data.result_data.description) + "</p>");


		$("#txt_description").html("<p>" + unescapeHtml(data.result_data.description) + "</p>");
		$("#txt_skillEffect").html("<p>" + unescapeHtml(data.result_data.skill_effect) + "</p>");
		


		var str = "";
		var index = 1;
		$("#div_imageFile").empty();
		if ( data.result_data.return_upload_image_file_info != null) 
		{
			$.each(data.result_data.return_upload_image_file_info, function(key, value) {
				str += "<div class='file'>";
				str += "	<img src='data:image/gif;base64," + value.binary_content + "' alt='갤러리 이미지' />";
				str += "</div>";
			});
		}
		$("#div_imageFile").append(str);

		str = "";
		index = 1;
		$("#div_attachFile").empty();
	    if ( data.result_data.return_upload_attach_file_info != null) 
	    {
	    	$.each(data.result_data.return_upload_attach_file_info, function(key, value) {
				str += "		<a href='/adminHome/api/board/download/" + value.file_id + "' download>";
				var extName = value.name.split('.').pop().toLowerCase();
				if (extName == "hwp" ) {
					str += "	<img src='/assets/adminHome/images/icon_hwp.png' alt='hwp' />" + value.name;
				}
				else if (extName == "pdf" ) {
					str += "	<img src='/assets/adminHome/images/icon_pdf.png' alt='pdf' />" + value.name;
				}
				else if (extName == "xlsx" || extName == "xls" ) {
					str += "	<img src='/assets/adminHome/images/icon_xlsx.png' alt='xlsx' />" + value.name;
				}
				else if (extName == "ppt" || extName == "pptx") {
					str += "	<img src='/assets/adminHome/images/icon_ppt.png' alt='ppt' />" + value.name;
				}
				else if (extName == "zip" ) {
					str += "	<img src='/assets/adminHome/images/icon_zip.png' alt='zip' />" + value.name;
				}
				else {
					str += value.name;
				}
				str += "</a>";
				index++;
			});
		}

	    $("#div_attachFile").append(str);
	}
</script>


<input type="hidden" id="board_id" name="board_id" value="${vo.board_id}" />
<section>	
	<h2 class="hidden">서브영역</h2>
	<!-- 서브 경로 -->
	<article class="sub_route">
		<h3 class="hidden">서브경로</h3>
		<div class="wrap_area">
			<ul>
				<li><a href="/" class="home"><i class="fas fa-home"></i><span class="hidden">홈</span></a></li>
				<li><a href="/userHome/fwd/gallery/main">기술 갤러리</a></li>
				<li><a href="/userHome/fwd/gallery/main">선정기술 안내</a></li>
			</ul>	
		</div>
	</article>
	<!-- //서브 경로 -->
	
		
	<article class="contents">
		<div class="wrap_area clearfix">
			<!-- 서브 레프트메뉴 -->
			<div class="lnb" id="lnb">
				<h2 class="lnb_title">기술 갤러리</h2>
				<ul class="lnb_menu">
					<li class="on"><a href="/userHome/fwd/gallery/main">선정기술 안내</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<h2 class="sub_contents_title">선정기술 안내</h2>						
				<div class="board_gallery_area gallery_view_area">	
					<div class="list_table">
						<table class="list2 write_table gallery_table">
							<caption>선정기술 안내</caption>     
							<colgroup>
								<col style="width:12%">
								<col style="width:12%">
								<col style="width:38%">
								<col style="width:12%">	
								<col style="width:26%">
							</colgroup>
							<tbody>									
								<tr>
									<th scope="col" colspan="2">사업명</th>
									<td class="bs_class" id="txt_businessName"></td>						
									<th scope="col">수행기간</th>	
									<td class="date"><span class="year">2022</span>-<span class="month">04</span>-<span class="day">02</span> ~ <span class="year">2022</span>-<span class="month">04</span>-<span class="day">02</span></td>
								</tr>
								<tr>
									<th scope="col" colspan="2">기술명</th>	
									<td class="tech_title" id="txt_title"></td>
								
									<th scope="col">기관명</th>	
									<td class="company_name" id="txt_institueName"></td>
								</tr>								
								<tr>
									<th scope="col" rowspan="4">사업 주요 내용</th>
									
									<th scope="row">기술 키워드</th>	
									<td class="key" colspan="3" id="txt_skillKeyword"></td>
								</tr>
								<tr>
									<th scope="row">기술 요약</th>
									<td colspan="3" class="or_summary" id="txt_description"></td>
								</tr>
								<tr>
									<th scope="row">기대 효과</th>
									<td colspan="3" class="or_effect" id="txt_skillEffect"></td>
								</tr>
								<tr>
									<th scope="row">기술 이미지</th>
									<td colspan="3" class="gallery_write_attachfile">										
										<div id="gallery_attach">														
											<div class="fileList clearfix view_file" id="div_imageFile">
											</div>											
										</div>											
									</td>
								</tr>
								<tr>
									<th scope="row" colspan="2">기술첨부자료</th>
									<td colspan="3" class="gallery_write_attachfile">										
										<!-- 업로드 -->
										<div class="view_attachfile" id="div_attachFile"></div>
										<!-- //업로드 -->								
									</td>
								</tr>	
							</tbody>
						</table> 
					
						<div class="write_button_area mt30">
							<button type="button" class="gray_btn2 fr" onclick="location.href='/userHome/fwd/gallery/main'">목록</button>
						</div>
					</div>
				</div>						
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>