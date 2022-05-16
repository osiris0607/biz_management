<script type='text/javascript'>
	$(document).ready(function() {
		searchDetail();
	});
	
	/*******************************************************************************
	* 사업공고 상세 조회
	*******************************************************************************/
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/user/api/announcement/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("announcement_id", $("#announcement_id").val());
		comAjax.ajax();
	}
	
	function searchDetailCB(data){
		
		$("#title").text(data.result.title) ;
		$("#type").html(data.result.type_name) ;

		$("#hits").text(data.result.hits);
		$("#register").text(data.result.register);
		$("#reg_date").text(data.result.reg_date);
		$("#business_name").text(unescapeHtml(data.result.business_name));
		$("#manager").text(data.result.manager);
		$("#manager_dept").text(data.result.manager_dept);
		$("#manager_job_title").text(data.result.manager_job_title);
		$("#manager_phone").text(data.result.manager_phone);
		$("#manager_mail").text(data.result.manager_mail);
		$("#receipt_from").text(data.result.receipt_from);
		$("#receipt_to").text(data.result.receipt_to);
		$("#contents").html(unescapeHtml(data.result.contents));

		var uploadFiles = $("#upload_files");
		var index = 1;
		var str = "";

		if (data.result.type == "D0000001") {
			str += "<dt class='adt'><span>첨부파일(기술컨설팅)</span></dt>";
		}
		else if (data.result.type == "D0000002") {
			str += "<dt class='adt'><span>첨부파일(기술연구개발)</span></dt>";
		}
		else {
			str += "<dt class='adt'><span>첨부파일(" + data.result.type_name + ")</span></dt>";
		}

		str += "	<dd class='add'>";
		if ( data.result.return_upload_files != null) {
			$.each(data.result.return_upload_files, function(key, value) {
				str += "		<a href='/user/api/announcement/download/" + value.file_id + "' download>";
				var extName = value.name.split('.').pop().toLowerCase();
				if (extName == "hwp" ) {
					str += "	<img src='/assets/user/images/icon/icon_hwp.png' alt='hwp' />" + value.name.trim();
				}
				else if (extName == "pdf" ) {
					str += "	<img src='/assets/user/images/icon/icon_pdf.png' alt='pdf' />" + value.name.trim();
				}
				else if (extName == "xlsx" || extName == "xls" ) {
					str += "	<img src='/assets/user/images/icon/icon_xlsx.png' alt='xlsx' />" + value.name.trim();
				}
				else if (extName == "ppt" || extName == "pptx") {
					str += "	<img src='/assets/user/images/icon/icon_ppt.png' alt='ppt' />" + value.name.trim();
				}
				else if (extName == "zip" ) {
					str += "	<img src='/assets/user/images/icon/icon_zip.png' alt='zip' />" + value.name.trim();
				}
				else {
					str += value.name.trim();
				}
				str += "</a>";
				index++;
			});
		}
		str += "	</dd>";
		uploadFiles.append(str);
	}
</script>


<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<section>	
	<h2 class="hidden">서브영역</h2>
	<!-- 서브 경로 -->
	<article class="sub_route">
		<h3 class="hidden">서브경로</h3>
		<div class="wrap_area">
			<ul>
				<li><a href="/" class="home"><i class="fas fa-home"></i><span class="hidden">홈</span></a></li>
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">알림&middot;홍보</a></li>
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">공지&middot;공고</a></li>
				<li><a href="/userHome/fwd/announcement/notice/businessMain">사업공고</a></li>
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
					<li class="on"><a href="/userHome/fwd/announcement/notice/noticeMain">공지&middot;공고</a></li>
					<li><a href="/userHome/fwd/announcement/broadcast/broadcastMain">보도자료</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<h2 class="sub_contents_title">사업공고</h2>						
				<div class="board_businessnotice_area businessnotice_view_area">
					<div class="list_table">
						<table class="business_table_view">
							<caption>공고정보</caption> 
							<thead>
								<tr>
									<th scope="row" id="title"></th>
								</tr>
								<tr>
								   <td>
									   <dl class="answer">
										  <dt class="adt"><span>기술명</span></dt>
										  <dd class="add">기술명기술명</dd>
									   </dl>                                    
								   </td> 
								</tr>
								<tr>
									<td>
									   <dl class="answer">
										  <dt class="adt"><span>조회수</span></dt>
										  <dd class="add ls" id="hits"></dd>
										  <dt class="adt"><span>작성자</span></dt>
										  <dd class="add" id="register"></dd>
										  <dt class="adt"><span>작성일</span></dt>
										  <dd class="add ls" id="reg_date"></dd>
									  </dl>                                    
									</td> 
								</tr>
								<tr>
								   <td>
									   <dl class="answer">
										  <dt class="adt"><span>사업명</span></dt>
										  <dd class="add" id="business_name"></dd>
									   </dl>                                    
								   </td> 
							   </tr>
							   <tr>
									<td>
										<dl class="answer">										  
											<dt class="adt"><span>담당자</span></dt>
											<dd class="add" id="manager"></dd>
											<dt class="adt"><span>담당자 부서</span></dt>
											<dd class="add" id="manager_dept"></dd>
											<dt class="adt"><span>담당자 직책</span></dt>
											<dd class="add" id="manager_job_title"></dd>												 
										 </dl>   
										 <dl class="answer pt0">
											<dt class="adt"><span>담당자 전화</span></dt>
											<dd class="add ls" id="manager_phone"></dd>
											<dt class="adt"><span>담당자 이메일</span></dt>
											<dd class="add ls" id="manager_mail"></dd>									  
									   </dl>                                    
									</td> 
								</tr>
								<tr>
									<td>
										<dl class="answer">
										   <dt class="adt"><span>접수 시작일</span></dt>
										   <dd class="add ls" id="receipt_from"></dd>
										   <dt class="adt"><span>접수 종료일</span></dt>
										   <dd class="add ls" id="receipt_to"></dd>
										</dl>                                    
									</td> 
								</tr>									   
							</thead>
							<tbody>
								<tr>								   
									<td>
										<p style="line-height: 1.5;" id="contents"></p>                                    
									</td> 
								</tr>
								<tr>
									<td> 
									   <dl class="answer" id="upload_files"></dl>
								   </td>
								</tr>
							</tbody>
						</table>  
						<div class="write_button_area mt30">
							<button type="button" class="gray_btn2 fr" onclick="location.href='/userHome/fwd/announcement/notice/businessMain'">목록</button>
						</div>
					</div>
				</div>
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>