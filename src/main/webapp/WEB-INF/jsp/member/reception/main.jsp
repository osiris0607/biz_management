<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		// 공고 검색		
		searchAnnouncementList(1);
		// 나의 접수 과재 목록
		searchMyReceptionList(1); 
	});
	
	function searchAnnouncementList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/announcement/search/paging' />");
		comAjax.setCallback(searchAnnouncementListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		// D0000003 : 개시된 공고 목록만 가지고 온다.
		comAjax.addParam("process_status", "D0000003");
		comAjax.addParam("type", $("#type_selector option:selected").val());
		comAjax.addParam("search_text", $("#search_text").val());
		// 접수에서 공고를 찾을때는 접수일에 해당하는 공고만 찾는다.
		comAjax.addParam("search_date_yn", "Y");
		
		comAjax.ajax();
	}
	
	
	function searchAnnouncementListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchAnnouncementList"
				};
			gfnRenderPagingMain(params);
			
			$("#search_count").html("[총 <span class='fw500 font_blue'>" + total + "</span>건]");
			var index = 1;
			var str = "";
			$.each(data.result, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index + "</td>";
				str += "	<td>"+ value.type_name + "</td>";
				str += "	<td><a href='/member/fwd/reception/announcementDetail?announcement_id=" + value.announcement_id + "'><div class='txt_hidden'>" + value.title + "</div></a></td>";
				str += "	<td>"+ value.receipt_from + " ~ " + value.receipt_to +"</td>";
				str += "	<td class='last'>";
				str += "		<button type='button' title='접수하기' class='blue_btn2' onclick='location.href=\"/member/fwd/reception/guide?announcement_id=" + value.announcement_id + "&announcement_type=" + value.type + "\"'>접수하기</button>";
				str += "	</td>";
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	function searchMyReceptionList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/reception/search/paging' />");
		comAjax.setCallback(searchMyReceptionListCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		
		comAjax.ajax();
	}


	function searchMyReceptionListCB(data) {
		var total = data.totalCount;
		var body = $("#my_reception_list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi_reception",
					pageIndex : "pageIndex_reception",
					totalCount : total,
					eventName : "searchMyReceptionList",
					recordCount : 10
				};
	
			gfnRenderPagingReception(params);

			var index = 1;
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index + "</td>";
				str += "	<td>"+ value.announcement_type_name + "</td>";
				str += "	<td class='announcement_name'><a href='/member/fwd/reception/announcementDetail?announcement_id=" + value.announcement_id + "'>" + value.announcement_title + "</a></td>";
				str += "	<td class='announcement_name'>" + value.tech_info_name + "</td>";
				str += "	<td><span>"+ value.reg_date +"</span></td>";
				str += "	<td><span>"+ value.reception_reg_number +"</span></td>";

				//  D0000001 : 접수 작성 중인 상태
				if ( value.reception_status == "D0000001" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "'>작성 중</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='location.href=\"/member/fwd/reception/match/consultingExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>작성하기</button>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "'>작성 중</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='location.href=\"/member/fwd/reception/match/researchExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>작성하기</button>";
					}
					// 기술 공고
				 	else if (value.announcement_type == "D0000003") {
						str += "	<td><a href='/member/fwd/reception/contest/modification?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "'>작성 중</a></td>";
						str += "	<td class='last'>";
				 		str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='location.href=\"/member/fwd/reception/contest/modification?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>작성하기</button>";
					}
					// 기술 제안
				 	else if (value.announcement_type == "D0000004") {
				 		str += "	<td><a href='/member/fwd/reception/proposal/modification?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "'>작성 중</a></td>";
						str += "	<td class='last'>";
				 		str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='location.href=\"/member/fwd/reception/proposal/modification?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>작성하기</button>";
					}
					str += "		</td>";
				}
				//  D0000002 : 접수 작성 완료 상태
				else if ( value.reception_status == "D0000002" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수대기</a></td>";
					} 
					// 기술 매칭 연구 개발
					else  if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수대기</a></td>";
					}
					// 기술 공고
					else  if (value.announcement_type == "D0000003") {
						str += "	<td><a href='/member/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수대기</a></td>";
					}
					// 기술 공고
					else  if (value.announcement_type == "D0000004") {
						str += "	<td><a href='/member/fwd/reception/proposal/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수대기</a></td>";
					}
					str += "	<td class='last'>";
					str += "		<button type='button' class='btn_gray ml10 del_reception_popup_open openLayer3 fl' onclick='prepareWithdrawalReception(\"" + value.reception_id + "\");'>접수취소</button>";
					str += "	</td>";
				}
				//  D0000003 : 기술 매칭인 경우 전문가 매칭 신청 임시 저장 상태
				//  기술 매칭인 경우 전문가 매칭이 먼저 선행되어야 한다. 전문가 매칭 신청서 작성 중인 상태
				else if ( value.reception_status == "D0000003" ) {

					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "'>매칭 작성 중</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='location.href=\"/member/fwd/reception/match/consultingExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>작성하기</button>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "'>매칭 작성 중</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='location.href=\"/member/fwd/reception/match/researchExpertDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>작성하기</button>";
					}
					str += "		</td>";
				}
				//  D0000004 : 기술 매칭인 경우 사용자가 전문가를 선택한 상태
				//  D0000005 : 관리자가 사용자가 선택한 전문가의 참여 의향을 물어보고 있는 단계
				else if ( value.reception_status == "D0000004" || value.reception_status == "D0000005") {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 신청 중</a></td>";
						str += "	<td class='last'>";
						str += "	<button type='button' class='btn_gray ml10 fl' onclick='prepareUpdateReceptionStatus(\"D0000009\", \""+ value.reception_id + "\");'>매칭 취소</button>";
						str += "	</td>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 신청 중</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray ml10 fl' onclick='prepareUpdateReceptionStatus(\"D0000009\", \""+ value.reception_id + "\");'>매칭취소</button>";
						str += "	</td>";
					}
				}
				//  D0000006 : 기술 매칭 인 경우 관리자가 매칭 접수 마감인 상태. 
				//	사용자는 참여 의사가 있는 전문가를 선택해야 하는 단계
				else if ( value.reception_status == "D0000006" ) {

					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id +"'>전문가 매칭 결과</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='moveChoiceExpert(\"" + value.reception_id + "\", \"" + value.announcement_id + "\", \"D0000001\");'>매칭하기</button>";
					} else {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id +"'>전문가 매칭 결과</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_gray3 ml10 fl' onclick='moveChoiceExpert(\"" + value.reception_id + "\", \"" + value.announcement_id + "\", \"D0000002\");'>매칭하기</button>";
					}
					str += "		<button type='button' class='btn_gray ml10 fl' onclick='prepareUpdateReceptionStatus(\"D0000009\", \""+ value.reception_id + "\");'>매칭취소</button>";
					str += "	</td>";
				}
				//  D0000007 : 전문가 선택 완료인 상태
				//	간사가 확인을 하고 나면 접수번호가 발급된다.
				else if ( value.reception_status == "D0000007" ) {
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>전문가 매칭 결과</a></td>";
					}
					else {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>전문가 매칭 결과</a></td>";
					}
					str += "	<td class='last'>";
					str += "		<button type='button' class='btn_gray ml10 fl' onclick='prepareUpdateReceptionStatus(\"D0000009\", \""+ value.reception_id + "\");'>매칭취소</button>";
					str += "	</td>";
				}
				//  D0000008 : 매칭 완료인 상태
				//	사용자는 매칭 완료 이후 실제 접수를 하게 된다.
				else if ( value.reception_status == "D0000008" ) {

					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 완료</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_blue2 ml10 mb5 fl' onclick='location.href=\"/member/fwd/reception/match/consultingDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>접수하기</button>";
					} else {
						str += "	<td><a href='/member/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭 완료</a></td>";
						str += "	<td class='last'>";
						str += "		<button type='button' class='btn_blue2 ml10 mb5 fl' onclick='location.href=\"/member/fwd/reception/match/researchDetail?announcement_id=" + value.announcement_id + "&reception_id=" + value.reception_id + "\"'>접수하기</button>";
					}
					str += "		<button type='button' class='btn_gray ml10 fl' onclick='prepareUpdateReceptionStatus(\"D0000009\", \""+ value.reception_id + "\");'>매칭취소</button>";
					str += "	</td>";
				}
				//  D0000009 : 매칭 취소 
				else if ( value.reception_status == "D0000009" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭취소</a></td>";
						str += "	<td class='last'>";
						str += "	</td>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭취소</a></td>";
						str += "	<td class='last'>";
						str += "	</td>";
					}
				}
				//  D0000010 : 매칭 포기 
				else if ( value.reception_status == "D0000010" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭포기</a></td>";
						str += "	<td class='last'>";
						str += "	</td>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchExpertMatching?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>매칭포기</a></td>";
						str += "	<td class='last'>";
						str += "	</td>";
					}
				}
				//  D0000011 : 접수 취소 
				else if ( value.reception_status == "D0000011" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수취소</a></td>";
						str += "	<td class='last'>";
						str += "	</td>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수취소</a></td>";
						str += "	<td class='last'>";
						str += "	</td>";
					}
					// 기술 공모
					else if (value.announcement_type == "D0000003") {
						str += "	<td><a href='/member/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수취소</a></td>";
					}
					// 기술 제안
					else if (value.announcement_type == "D0000004") {
						str += "	<td><a href='/member/fwd/reception/proposal/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수취소</a></td>";
					}
				}
				//  D0000012 : 접수 완료 
				else if ( value.reception_status == "D0000012" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수완료</a></td>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수완료</a></td>";
					}
					// 기술 공모
					else if (value.announcement_type == "D0000003") {
						str += "	<td><a href='/member/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수완료</a></td>";
					}
					// 기술 제안
					else if (value.announcement_type == "D0000004") {
						str += "	<td><a href='/member/fwd/reception/proposal/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>접수완료</a></td>";
					}

					str += "	<td class='last'>";
					str += "		<button type='button' class='btn_gray del_reception_popup_open openLayer3 ml10 fl' onclick='prepareWithdrawalReception(\"" + value.reception_id + "\");'>접수취소</button>";
					str += "	</td>";
				}
				//  D0000013 / D0000014 : 반려
				else if ( value.reception_status == "D0000013" || value.reception_status == "D0000014" ) {
					// 기술 매칭 컨설팅
					if (value.announcement_type == "D0000001") {
						str += "	<td><a href='/member/fwd/reception/match/consultingDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>반려</a></td>";
					}
					// 기술 매칭 연구 개발
					else if (value.announcement_type == "D0000002") {
						str += "	<td><a href='/member/fwd/reception/match/researchDetail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>반려</a></td>";
					}
					// 기술 공모
					else if (value.announcement_type == "D0000003") {
						str += "	<td><a href='/member/fwd/reception/contest/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>반려</a></td>";
					}
					// 기술 제안
					else if (value.announcement_type == "D0000004") {
						str += "	<td><a href='/member/fwd/reception/proposal/detail?reception_id=" + value.reception_id + "&announcement_id=" + value.announcement_id + "'>반려</a></td>";
					}

					str += "	<td class='last'>";
					str += "	</td>";
				}
				
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	function moveChoiceExpert(id, announcement_id, type ) {
		if ( type == "D0000001") {
			location.href = "/member/fwd/reception/match/consultingExpertMatching?reception_id=" + id + "&announcement_id=" + announcement_id;
		} else {
			location.href = "/member/fwd/reception/match/researchExpertMatching?reception_id=" + id + "&announcement_id=" + announcement_id;
		}
	}
	
	var updateStatusId;
	function prepareUpdateReceptionStatus(status, id) {
		updateStatusId = id;
		if ( status == "D0000009") {
			$('.machingdel_reception_popup_box, .popup_bg').fadeIn(350);
		}
	}


	function updateReceptionStatus(status) {
		$('.machingdel_reception_popup_box, .popup_bg').fadeOut(350);
		$.ajax({
		    type : "POST",
		    url : "/member/api/reception/status/update",
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    data : {
	    				"reception_id" : updateStatusId,
	    				"reception_status" : status
	    		    },
		    success : function(data) {
		    	console.log(data.result);
	            if (data.result == 1) {
	            	if ( status == "D0000009") {
	            		$('.machingcomplete_del_reception_popup_box, .popup_bg').fadeIn(350);
	        		}
	            }
	            else {
	            	if ( status == "D0000009") {
	            		showPopup("매칭 취소에 실패 했습니다.", "매칭 취소 안내");
	        		}
	            }
		    },
		    error : function(err) {
		    	showPopup("매칭 취소에 실패 했습니다.", "매칭 취소 안내");
		        alert(err.status);
		    }
		});
	}


	var deleteReceptionId;
	function prepareWithdrawalReception(id) {
		deleteReceptionId = id;
	}


	function WithdrawalReception() {
		$.ajax({
		    type : "POST",
		    url : "/member/api/reception/withdrawal",
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    data : {
	    				"reception_id" : deleteReceptionId
	    		    },
		    success : function(data) {
		    	console.log(data.result);
	            if (data.result == 1) {
	            	$('.complete_del_reception_popup_box, .popup_bg').fadeIn(350);
	            }
	            else {
	            	showPopup("삭제 실패 했습니다.", "접수 삭제 안내");
	            }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	

	function withdrawalMatching() {

	}

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
		if ( isWithdrawalReception == true) {
			location.relaod();
		}
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}

</script>
            
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>접수</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>접수</li>
						<li>접수</li>
					</ul>
				</div>
				<div class="content_area">
					<h4>접수 중인 과제 목록</h4>
					<!--search_area-->
					<div class="search_area">
						<dl class="search_box">
							<dt class="hidden">검색대상</dt>
							<dd class="box">
								<label for="type_selector" class="hidden">검색구분</label>
								<select name="list-search-member-class" id="type_selector" class="selectbox1 fl ace-select w19" title="사업명">
								   	<option value="">전체</option>
						          	<c:forEach items="${commonCode}" var="code">
										<c:if test="${code.master_id == 'M0000005'}">
											<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
										</c:if>
									</c:forEach>
						  	 	</select>
								<div class="input_search_box fl w80">
									<label for="search_text" class="hidden">검색어 입력</label>
									<input id="search_text" class="in_w85 fl ml10" name="input_txt" type="text" placeholder="키워드를 입력하여 공고를 검색하실 수 있습니다." />
									<div class="fr clearfix">
										<button type="button" class="search_txt_del fl" title="검색어 삭제" onclick="initSearchText();">
											<img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼" />
										</button>	
										<button type="button" class="serch_btn blue_btn fl mr20" title="검색" onclick="searchAnnouncementList(1);">검색</button>	
									</div>	
								</div>
							</dd>
						</dl>							
					</div>
					<!--//search_area-->
	
					<!--table_count_area-->
					<div class="table_count_area">
						<div class="count_area" id="search_count"></div>
					</div>
					<!--//table_count_area-->
					
					<!--리스트시작-->							
					<div class="table_area">
						<table class="list fixed">
							<caption>접수 목록</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 18%;">
								<col style="width: 50%;">
								<col style="width: 17%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">번호</th>
									<th scope="col">사업명</th>
									<th scope="col">공고명</th>
									<th scope="col">접수기간</th>
									<th scope="col" class="last">신청</th>
								</tr>
							</thead>
							<tbody id="list_body">
							</tbody>
						</table>
						
						
						 <!-- Pagenation -->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
						<div class="paging_area" id="pageNavi"></div>
						</div>							
	
					<h4>나의 접수 과제 목록</h4>
					<p class="receptionmylist_txt"><span class="necessary_icon">*</span>내가 접수한 과제 목록을 확인합니다. 접수가 완료된 과제는 접수번호가 부여되며, <a href="/member/fwd/mypage/report" title="나의 수행 과제 현황 링크 바로가기"><span class="fw500">&#39;나의 수행 과제 현황&#39;</span></a> 에서 확인할 수 있습니다. </p>
	                            <!--table_count_area-->
					<div class="table_count_area">
						<div class="count_area" id="search_my_count"></div>
					</div>
					<!--//table_count_area-->
					<!--table_area-->
					<div class="table_area">
						<table class="list fixed my_list">
							<caption>나의 접수 과제 목록</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 9%;">
								<col style="width: 19%;">
								<col style="width: 19%;">
								<col style="width: 8%;">
								<col style="width: 11%;">
								<col style="width: 10%;">
								<col style="width: 20%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">번호</th>
									<th scope="col">사업명</th>
									<th scope="col">공고명</th>
									<th scope="col">기술명</th>
									<th scope="col">접수일</th>
									<th scope="col">접수 번호</th>
									<th scope="col" class="last" colspan="2">접수 상태</th>
								</tr>
							</thead>
							<tbody id="my_reception_list_body"></tbody>
						</table>
					 	<!-- Pagenation -->
					   	<input type="hidden" id="pageIndex_reception" name="pageIndex_reception"/>
						<div class="paging_area" id="pageNavi_reception"></div>
					</div>	
					<!--//table_area-->
				</div>
			</div>
		</div>
	</section>
</div>
<!--//container-->
<!--재접수 팝업-->
<div class="rereception_popup_box">		
	<div class="popup_bg"></div>
	<div class="rereception_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">재접수 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">기존에 접수한 내역이 있습니다.<br />
			재접수 하실 경우, <span class="font_blue">기존 접수번호와 별도로 신규 접수번호</span>가 생성됩니다.<br />
			재접수 하시겠습니까?</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5" onclick="location.href='./reception_write.html'">예</button>
				<button type="button" class="gray_btn lastClose layerClose">아니요</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//재접수 팝업-->
<!--접수취소 팝업-->
<div class="del_reception_popup_box">		
	<div class="popup_bg"></div>
	<div class="del_reception_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">접수 취소 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">작성하신 접수를 <span class="font_blue">취소</span> 하시겠습니까?<br />
			<span><span class="fw500">취소시 작성하신 내용이 삭제 될 수 있습니다.</span></span></p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5 lastClose openLayer4" onclick="WithdrawalReception();">예</button>
				<button type="button" class="gray_btn lastClose layerClose">아니요</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//접수취소 팝업-->
<!--접수취소완료 팝업-->
<div class="complete_del_reception_popup_box" >		
	<div class="popup_bg"></div>
	<div class="complete_del_reception_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">접수 취소 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">작성하신 접수가 <span class="font_blue">취소 완료</span> 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn lastClose layerClose" onclick="location.reload();">확인</button>
			</div>	
		</div>									
	</div> 
</div>            
        
<!--매칭취소 팝업-->
<div class="machingdel_reception_popup_box">		
	<div class="popup_bg"></div>
	<div class="del_reception_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">매칭 취소 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">
				취소 시 해당 매칭을 다시 사용할 수 없으며 신규 접수를 해야 합니다.  <br>
				<span class="font_blue">전문가 매칭을 취소</span> 하시겠습니까?
			</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5 complete_machingdel_reception_popup_open lastClose openLayer4" onclick="updateReceptionStatus('D0000009');">예</button>
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">아니요</button>
			</div>	
		</div>									
	</div> 
</div>        
        
<!--매칭취소완료 팝업-->
<div class="machingcomplete_del_reception_popup_box">		
	<div class="popup_bg"></div>
	<div class="machingcomplete_del_reception_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">매칭 취소 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"> <span class="font_blue">전문가 매칭취소</span>가 완료 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn" onclick="location.reload();">확인</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//매칭취소완료 팝업-->



<!--접수취소완료 팝업-->
<div class="complete_del_matching_popup_box" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; display: none;">		
	<div class="popup_bg"></div>
	<div class="complete_del_reception_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">접수 취소 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">작성하신 접수가 <span class="font_blue">취소 완료</span> 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn lastClose layerClose">확인</button>
			</div>	
		</div>									
	</div> 
</div>

<!--공통 팝업-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>
