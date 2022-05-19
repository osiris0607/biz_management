<script type='text/javascript'>
	$(document).ready(function() {
		searchDetail();
	});
	
	/*******************************************************************************
	* 보도자료 상세 조회
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
			alert("공지 사항 정보가 없습니다. 다시 시도해 주시기 바랍니다.");
			return;
		}
	
		$("#txt_title").html("<p>" + data.result_data.title + "</p>");
		$("#txt_writer").html("<span>" + data.result_data.writer + "</span>");
		$("#txt_regDate").html(data.result_data.reg_date);
		$("#txt_description").html(unescapeHtml(data.result_data.description));
	
	
		var str = "";
		var index = 1;
		$("#div_attachFile").empty();
	    if ( data.result_data.return_upload_attach_file_info != null) 
	    {
	    	$.each(data.result_data.return_upload_attach_file_info, function(key, value) {
				str += "		<a href='/user/api/notice/download/" + value.file_id + "' download>";
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
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">알림&middot;홍보</a></li>
				<li><a href="/userHome/fwd/announcement/broadcast/broadcastMain">보도자료</a></li>
			</ul>
		</div>
	</article>
	<!-- //서브 경로 -->
	
		
	<article class="contents">
		<div class="wrap_area clearfix">
			<!-- 서브 레프트메뉴 -->
			<div class="lnb" id="lnb">
				<h2 class="lnb_title">알림&middot;홍보</h2>
				<ul class="lnb_menu">
					<li><a href="/userHome/fwd/announcement/notice/noticeMain">공지사항</a></li>
					<li class="on"><a href="/userHome/fwd/announcement/broadcast/broadcastMain">보도자료</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<h2 class="sub_contents_title">보도자료</h2>						
				<div class="board_data_area data_view_area">	
					<div class="list_table">
						<table class="list2 view_table data_table_view">
							<caption>보도자료</caption>     
							<colgroup>
								<col style="width:20%">
								<col style="width:80%">								
							</colgroup>
							<tbody>										
								<tr>
									<th scope="row">제목</th>
									<td class="write_title" id="txt_title"></td>	
								</tr>
								<tr>
									<th scope="row">작성자</th>	
									<td class="write_name" id="txt_writer"></td>
								</tr>
								<tr>
									<th scope="row">등록일</th>	
									<td class="date" id="txt_regDate"></td>
								</tr>								
								<tr>									
									<th scope="row">내용</th>	
									<td class="data_write_text" id="txt_description"></td>
								</tr>  
								<tr>
									<th scope="row">첨부파일</th>	
									<td class="data_write_attachfile">	
										<!-- 업로드 -->
										<div class="view_attachfile" id="div_attachFile">
										</div>
										<!-- //업로드 -->
									</td>
								</tr>   
							</tbody>
						</table>   
						<!--//검색 결과-->  
						 <div class="write_button_area mt30">
							<button type="button" class="gray_btn2 fr" onclick="location.href='/userHome/fwd/announcement/broadcast/broadcastMain'">목록</button>
						</div>
					</div>	
				</div>
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>