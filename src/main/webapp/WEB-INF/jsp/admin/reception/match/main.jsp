<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var receptionList;
	$(document).ready(function() {
		
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/reception/search/paging' />");
		comAjax.setCallback(searchListCB);

		if ( gfn_isNull($("#search_reception_from_date").val()) == true && gfn_isNull($("#search_reception_to_date").val()) == false ) {
			alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#search_reception_from_date").val()) == false && gfn_isNull($("#search_reception_to_date").val()) == true) {
			alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#search_reception_from_date").val()) == false && gfn_isNull($("#search_reception_to_date").val()) == false) {
			if ( $("#search_reception_from_date").val() > $("#search_reception_to_date").val()) {
				alert("시작 접수일이 종료 접수일보다 앞선 날짜 입니다. 다시 선택해 주시기 바랍니다.");
				return;
			} else {
				comAjax.addParam("reception_from_date", $("#search_reception_from_date").val());
				comAjax.addParam("reception_to_date", $("#search_reception_to_date").val());
			}
		}

		comAjax.addParam("announcement_type", $("#search_reception_class_selector").val());
		comAjax.addParam("announcement_name", $("#search_announcement_name").val());
		comAjax.addParam("institution_name", $("#search_institution_name").val());
		comAjax.addParam("reception_reg_number", $("#search_reception_reg_number").val());
		comAjax.addParam("reception_status", $("#search_reception_status_selector").val());
		
		
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		comAjax.ajax();
	}


	function searchListCB(data) {
		
		console.log('data ---> ', data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		$("#search_count").html("&#91;총 <span class='font_blue'>" + total + "</span>건&#93;");
		if (total == 0) {
			var str = "<tr>" + "<td colspan='11'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPaging(params);

			receptionList = data.result_data;
			var count = 0;
			var index = 0;
			$.each(receptionList, function(key, value) {
				if ( value.announcement_type == "D0000001" || value.announcement_type == "D0000002") {
					// D0000001 - 전문가 매칭 신청이 아닌 접수 서류 작성 중인 상태
					// D0000003 - 전문가 매칭 신청 서류 작성 중인 상태
					// 위의 3가지 status는 기술 매칭 시에는 안 보이게 한다.
					if ( value.reception_status != "D0000001" && value.reception_status != "D0000003" ) {
						str += "<tr>";

						if ( value.reception_status == "D0000004" || value.reception_status == "D0000005") {
							str += "	<td><input type='checkbox' name='reception_checkbox' id='checkbox_" + index + "' value='" + index + "'/><label for='checkbox_" + index + "' class='checkbox_a'>&nbsp;</label></td>";
						} else {
							str += "	<td></td>";
						}
						
						str += "	<td class='announcement_name'><a href='/admin/fwd/reception/match/announcementDetail?announcement_id=" + value.announcement_id + "'>" + value.announcement_title + "</td>";
						str += "	<td class='announcement_name'>" + value.announcement_type_name + "</td>";
						str += "	<td class='sevice_name'>" + value.tech_info_name + "</td>";
						str += "	<td>" + value.institution_name + "</td>";
						str += "	<td>" + value.researcher_name + "</td>";
						count++;
					}
					// D0000002 - 접수 신청서 작성 완료 상태이므로 관리자 입장에서는 접수 신청이다.
					if (value.reception_status == "D0000002" ) {
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_waiting2'>접수 신청</span></a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_waiting2'>접수 신청</span></a></td>";
						}
						str += "	<td><span>" + value.mail_send_date + "</span></td>";

						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td>";
			  			str += "	</td>";
					}
					// D0000004 - 매칭 신청 완료 상태이므로 관리자 입장에서는 매칭 신청 이다.
					else if ( value.reception_status == "D0000004" ) {
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 신청</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 신청</a></td>";
						}
						str += "	<td><span></span></td>";
						str += "	<td><span>0</span></td>";
						str += "	<td><span>0</span></td>";
						str += "	<td></td>";
					}
					// D0000005 - 관리자가 희망 전문가에게 메일을 보낸 상태이다. 매칭 진행 중
					// 매칭 진행 중인 상태이다. 
					else if ( value.reception_status == "D0000005" ) {
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertProgress?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 진행 중</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertProgress?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 진행 중</a></td>";
						}
						str += "	<td><span>" + value.mail_send_date + "</span></td>";

						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td>";
						str += "		<button type='button' class='gray_btn2 end_popup_open2 fl mr5' onclick='updateReceptionClose(\"" + value.reception_id + "\");'>마감</button>";
						str += "  		<button type='button' class='blue_btn fl'  onclick='location.href=\"/admin/fwd/reception/match/expertParticipation?reception_id=" + value.reception_id + "\"'>전문가 참여 의향 현황</button>";  
			  			str += "	</td>";
					
					}
					// D0000006 - 희망 전문가 중에서 실제로 사용자에게 선택할 전문가를 선택 및 참여 의사 여부 확인
					// 사용자가 희망 전문가 중에서 같이 일할 점문가를 선택한다.
					else if ( value.reception_status == "D0000006" ) {
						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});

						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertClosed?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 신청 완료</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertClosed?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 신청 완료</a></td>";
						}
						
						str += "	<td><span>" + value.mail_send_date +"</span></td>";
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td></td>";
					} 
					// D0000007 - 매칭 결과. 사용자 최종 전문가를 선택한 상태
					else if ( value.reception_status == "D0000007" ) {
						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});

						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertClosed?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 결과</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertClosed?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 결과</a></td>";
						}
						
						str += "	<td><span>" + value.mail_send_date +"</span></td>";
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td>";
						str += "		<button type='button' class='gray_btn2 end_popup_open2 fl mr5' onclick='updateReceptionComplete(\"" + value.reception_id + "\");'>매칭완료</button>";
			  			str += "	</td>";
					}
					// D0000008 - 매칭 완료. 전문가 매칭 죄종 완료
					else if ( value.reception_status == "D0000008" ) {
						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});

						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertClosed?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 완료</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertClosed?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 완료</a></td>";
						}
						
						str += "	<td><span>" + value.mail_send_date +"</span></td>";
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td></td>";
					}
					// D0000009 - 매칭 취소
					else if ( value.reception_status == "D0000009" ) {
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertCancel?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 취소</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertCancel?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 취소</a></td>";
						}
						str += "	<td><span></span></td>";
						str += "	<td><span>0</span></td>";
						str += "	<td><span>0</span></td>";
						str += "	<td></td>";
					}
					// D0000009 - 매칭 포기
					else if ( value.reception_status == "D0000010" ) {
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingExpertCancel?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 취소</a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchExpertCancel?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 취소</a></td>";
						}
						str += "	<td><span></span></td>";
						str += "	<td><span>0</span></td>";
						str += "	<td><span>0</span></td>";
						str += "	<td></td>";
					}
					// 접수 취소 
					else if ( value.reception_status == "D0000011" ) {
						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});
						
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_completed2'>접수 취소</span></a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_completed2'>접수 취소</span></a></td>";
						}
						str += "	<td><span>" + value.mail_send_date +"</span></td>";
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td></td>";
						
					}
					// 접수 완료 
					 else if ( value.reception_status == "D0000012" ) {
						var responseMail = 0;
						var participationMail = 0;
						$.each(value.choiced_expert_list, function(key, value2) {
							if ( value2.participation_type == "D0000003" ) {
								participationMail++;
							}
							if ( value2.participation_type == "D0000002" || value2.participation_type == "D0000003" ) {
								responseMail++;
							}
						});
						
						if ( value.announcement_type == "D0000001") {
							str += "	<td><a href='/admin/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_completed2'>접수 완료</span></a></td>";
						} else {
							str += "	<td><a href='/admin/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'><span class='reception_completed2'>접수 완료</span></a></td>";
						}
						str += "	<td><span>" + value.mail_send_date +"</span></td>";
						// 회신 
						str += "	<td><span>" + responseMail + "</span></td>";
						// 참여
						str += "	<td><span>" + participationMail + "</span></td>";
						str += "	<td></td>";
					}

					str += "</tr>";
					index++;
				}
			});
			body.append(str);
		}
	}

	function updateReceptionComplete(id) {
		if (confirm("매칭 완료 하시겠습니까?")) {
			var formData = new FormData();
			formData.append("reception_id", id );
			formData.append("reception_status", "D0000008");
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/reception/updateStatus",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	alert("전문가 매칭이 완료되었습니다.");
			    	location.reload();
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	function updateReceptionClose(id){
		if (confirm("매칭 마감 하시겠습니까?")) {
			var formData = new FormData();
			formData.append("reception_id", id);
			formData.append("reception_status", "D0000006");

			$.ajax({
			    type : "POST",
			    url : "/admin/api/reception/updateStatus",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			    	if (jsonData.result == true) {
				    	alert("매칭 마감 되었습니다.");
				    	location.reload();
			    	} else {
				    	alert("매칭 마감에 실패했습니다. 다시 시도해 주시기 바랍니다.");
			    	}
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	var mailSMSContents;
	function searchMailSMSContents() {
		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/tech/match/emailSMS/detail",
		    processData: false,
		    contentType: false,
		    async : false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( jsonData.result_data != null && jsonData.result_data.length > 0 ) {
        				mailSMSContents = jsonData.result_data;
   				 	} else {
       					alert("전송할 메일/SMS 내용이 없습니다. 먼저 메일/SMS 전송 내용을 세팅하고 이용하여 주시기 바랍니다.");
    				}
		        } else {
		        	alert("전송할 메일/SMS 내용이 없습니다. 먼저 메일/SMS 전송 내용을 세팅하고 이용하여 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}
	function sendMail() {
		if($("input:checkbox[name=reception_checkbox]").is(":checked") == false) {
			alert("메일 전송할 접수 항목을 선택하여야 합니다.");
			return;
		}

		if (confirm("메일을 전송하시겠습니까?")) {
			// 가장 최근의 전송 메일 내용을 가져온다. 
			searchMailSMSContents();
			if ( mailSMSContents == null || mailSMSContents.length <= 0 ) {
				return;
			}
			console.log('mailSMSContents : ', mailSMSContents);
			// 접수 별로 한번씩 보내야 한다. 각각의 Status가 틀리기 때문에 동시에 처리할 수가 앖다.
			$("input:checkbox[name=reception_checkbox]:checked").each(function() {
				var reception = receptionList[$(this).val()];
				console.log('reception :: ', reception);

				var formData = new FormData();
				// Expert Progress에서의 Reception Status는 항상 'D0000005' 매칭 신청 시 이다. 
				formData.append("reception_id", reception.reception_id );
				formData.append("reception_status", reception.reception_status );
				// 전송할 메일 내용 
				$.each(mailSMSContents, function(key, value) {
					if (value.type == "email") {
						formData.append("title", value.title);
						formData.append("comment", value.comment);
						formData.append("link", value.link);
						formData.append("sender", value.sender);
					}
				});
				// 전송할 대상 			
				var memberIdList = new Array();
				var toMailList = new Array();
				$.each(reception.choiced_expert_list, function(key, value2) {
					console.log('VALUE2 ---> ', value2);
					memberIdList.push(value2.member_id);
					toMailList.push(value2.email);
				});

				formData.append("expert_member_ids", memberIdList);
				formData.append("to_mail", toMailList);

				console.log(toMailList);
				
				$.ajax({
				    type : "POST",
				    url : "/admin/api/reception/tech/match/emailSMS/sendMail",
				    data : formData,
				    processData: false,
				    contentType: false,
				    mimeType: 'multipart/form-data',
				    success : function(data) {
				    },
				    error : function(err) {
				        alert(err.status);
				    }
				});
			});	

			setTimeout(function() {
				alert("메일 전송에 성공하였습니다.");
				searchList(1);
			}, $("input:checkbox[name=reception_checkbox]:checked").length*500);
		}
	}

	function sendSMS() {
		if($("input:checkbox[name=reception_checkbox]").is(":checked") == false) {
			alert("문자메세지 전송할 접수 항목을 선택하여야 합니다.");
			return;
		}
		searchMailSMSContents();
		//체크한 리스트 정보_핸드폰번호
		$("input:checkbox[name=reception_checkbox]:checked").each(function() {
			var reception = receptionList[$(this).val()];
			console.log('reception :: ', reception.researcher_mobile_phone);
		});
		
		//보낼 sms 내용
		$.each(mailSMSContents, function(key, value) {
					if (value.type == "sms") {
					console.log(key, value);
						//formData.append("title", value.title);   //제목
						//formData.append("comment", value.comment);  //내용
						//formData.append("link", value.link);  //링크
						//formData.append("sender", value.sender);  //발송자
					}
				});
		//보낼파라미터 : 폰번호, 내용
		var formData = new FormData();
		if (confirm('SMS을 전송하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/reception/tech/match/emailSMS/sendSMS",
			    //data : formData,
			    //processData: false,
			    //contentType: false,
			    //mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			        	alert("성공했습니다.");
			        } else {
			        	alert("실패했습니다.");
			        	console.log('sms data --> ', jsonData.result);
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
		
		console.log('흠.....');
	}

	function receptionClosedAll() {
		if($("input:checkbox[name=reception_checkbox]").is(":checked") == false) {
			alert("마감 처리 할 접수을 선택하여야 합니다.");
			return;
		}

		if (confirm("전문가 매칭을 마감하시겠습니까?")) {
			// 가장 최근의 전송 메일 내용을 가져온다. 
			// 접수 별로 한번씩 보내야 한다. 각각의 Status가 틀리기 때문에 동시에 처리할 수가 앖다.
			$("input:checkbox[name=reception_checkbox]:checked").each(function() {
				var reception = receptionList[$(this).val()];
				
				var formData = new FormData();
				// Expert Progress에서의 Reception Status는 항상 'D0000005' 매칭 신청 시 이다. 
				formData.append("reception_id", reception.reception_id );
				formData.append("reception_status", "D0000006" );

				$.ajax({
				    type : "POST",
				    url : "/admin/api/reception/updateStatus",
				    data : formData,
				    processData: false,
				    contentType: false,
				    mimeType: 'multipart/form-data',
				    success : function(data) {
				    },
				    error : function(err) {
				        alert(err.status);
				    }
				});
			});	

			setTimeout(function() {
				alert("접수 마감 되었습니다.");
				searchList(1);
			}, $("input:checkbox[name=reception_checkbox]:checked").length*500);
		}
	}

	function downloadExcelFile() {
		if (confirm('다운로드하시겠습니까?')) {
			location.href = "/admin/api/reception/excelDownload?announcement_type=D0000005";
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
				       <li class="on"><a href="/admin/fwd/reception/main" title="접수관리">접수관리</a></li>
					   <li class="menu2depth">
						   	<ul>
							   <li class="active"><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
							   <li><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
							   <li><a href="/admin/fwd/reception/proposal/main">기술제안</a></li>
					   		</ul>
					   </li>
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
				       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
					   <li>접수관리</li>
					   <li><strong>기술매칭</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				   <h3 class="title_area">기술매칭</h3>
				  <!--//페이지타이틀-->
			    </div>
		   </div>
		   
           <div class="contents_view">                           
				<h4 class="sub_title_h4 mb10">접수 목록</h4>    
		        <!--접수 목록-->
			    <div class="list_search_top_area">							   
				    <ul class="clearfix list_search_top2">
					    <li class="clearfix">                
						    <label for="list_search_reception_class" class="fl list_search_title ta_r mr10 w_8">구분</label>
						    <select name="list-search-reception_class" id="search_reception_class_selector" class="ace-select fl w_18">
							    <option value="D0000005">전체</option>
							    <option value="D0000001">기술컨설팅</option>
							    <option value="D0000002">기술연구개발</option>
						    </select>
					    </li>
					    <li class="clearfix">
						    <label for="list_search_reception_type" class="fl list_search_title ta_r mr10 w_8">공고명</label>
						    <input type="text" id="search_announcement_name" class="form-control w_18" />
					    </li>
						<li class="clearfix">
						    <label for="search_reception_date" class="fl list_search_title ta_r mr10 w_8">접수일</label>									
						    <div class="datepicker_area fl">
							    <input type="text" id="search_reception_from_date" class="datepicker form-control w_14" placeholder="시작일" />					
						    </div>
							<span class="fl ml5 mr5 mt5">~</span>
						    <div class="datepicker_area fl mr20">
							    <input type="text" id="search_reception_to_date" class="datepicker form-control w_14" placeholder="종료일" />
						    </div>                                        
						</li>
					</ul>
					<ul class="clearfix list_search_top2">
						<li class="clearfix">
							<label for="search_institution_name" class="fl list_search_title ta_r mr10 w_8">기관명</label>
							<input type="text" id="search_institution_name" class="form-control brc-on-focusd-inline-block fl list_search_word_input w_18" />
						</li>	
					    <li class="clearfix">
							<label for="search_reception_reg_number" class="fl list_search_title ta_r mr10 w_8">접수번호</label>
							<input type="text" id="search_reception_reg_number" class="form-control brc-on-focusd-inline-block fl list_search_word_input w_18"  />
						</li>																	
						<li class="clearfix">
							<label for="list_search_reception_condition" class="fl list_search_title ta_r mr10 w_8">접수상태</label>
							<select name="list_search_reception_condition" id="search_reception_status_selector" class="ace-select fl w_18">
							   	<option value="">전체</option>
					          	<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.master_id == 'M0000014' && (code.detail_id != 'D0000003' && code.detail_id != 'D0000001' && code.detail_id != 'D0000002' ) }" >
										<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
									</c:if>
								</c:forEach>
							</select>
						</li>								    
				    </ul>								
					<div class="list_search_btn clearfix"><button type="submit" class="blue_btn fr" onclick="searchList(1);">조회</button></div>
			    </div>
			    <!--//리스트 상단 검색-->

			    <!--검색 결과-->
			    <div class="list_search_table">
				    <div class="table_count_area">
					    <div class="count_area clearfix">
						    <div class="clearfix">
								<div class="fl mt5" id="search_count">								   
									&#91;총 <span class="font_blue">0</span>건&#93;
								</div>
								<div class="fr">
								    <button type="button" class="gray_btn2 fl mr5" onclick="receptionClosedAll();">일괄 마감</button>
									<button type="button" class="blue_btn2 fl mr5" onclick="location.href='/admin/fwd/reception/match/emailSMS/setup'">이메일/sms 세팅</button>
								    <div class="download fr green_btn"><a href="javascript:downloadExcelFile();" class="ex_down">엑셀 다운로드</a></div>					
						        </div>							   
					        </div>							   
				        </div>
				        <div style="overflow-x:auto;">
					       <table class="list th_c matching">
						       <caption>접수 목록</caption>     
						       <colgroup>
							       <col style="width:5%" />
							       <col style="width:20%" />
							       <col style="width:7%" />
							       <col style="width:15%" />
								   <col style="width:10%" />
							       <col style="width:5%" />
							       <col style="width:7%" />
							       <col style="width:10%" />
							       <col style="width:4%" />
							       <col style="width:4%" />
							       <col style="width:12%" />
						       </colgroup>
						       <thead>
							       <tr>
								       <th scope="col">
								         <input type="checkbox" id="allCheck"/><label for="allCheck" class="checkbox_a">&nbsp;</label>
								       </th>
								       <th scope="col">공고명</th>
								       <th scope="col">구분</th>
									   <th scope="col">제품/서비스명</th>
								       <th scope="col">기관명</th>
								       <th scope="col">성명</th>
								       <th scope="col">진행상태</th>
								       <th scope="col">발송일시</th>
								       <th scope="col">회신</th>
								       <th scope="col">참여</th>
								       <th scope="col">&nbsp;</th>
							       </tr>
						       </thead>
						       <tbody id="list_body">
							   </tbody>
							</table>   
							<!--//검색 결과-->                           
						</div>  
					   <!--페이지 네비게이션-->
					   <input type="hidden" id="pageIndex" name="pageIndex"/>
					   <div class="page" id="pageNavi"></div>  
						<!--//페이지 네비게이션-->
						
						<div class="fr clearfix expert_button_box">									    
						    <span class="fl mt5 mr20">전문가 참여 의향 조사</span>									   
							<button type="button" class="blue_btn fl mr5 expertintention_emailsend_popup_open mail_btn" onclick="sendMail();">E-mail</button>
							<button type="button" class="blue_btn fl expertintention_smssend_popup_open sms_btn" onclick="sendSMS();">SMS</button><br />					
						</div>									
					</div>
					<!--//list_search_table-->
			    </div><!--content view-->
		   </div>
			<!--//contents--> 
	   </div>
   		<!--//sub--> 
	</div>
</div>
<!--//container-->
