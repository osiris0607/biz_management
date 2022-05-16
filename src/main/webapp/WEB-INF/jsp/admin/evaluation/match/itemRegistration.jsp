<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {
		searchList();
	});
	
	function searchList() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/evaluation/match/releatedItem/search/list");
		comAjax.setCallback(searchListCB);
		// 등록된 평가 과제에서 검색
		
		var ids = "${vo.update_evaluation_number_list}".replace("[","").replace("]","");
		var temp = ids.split(',');   
		comAjax.addParam("evaluation_id_list", "${vo.update_evaluation_number_list[0]}");
		comAjax.ajax();
	}

	var itemInfo;
	function searchListCB(data) {
		itemInfo = data.result_data;

		var itemReleatedInfo;
		var itemUnreleatedInfo;
		$.each(itemInfo, function(index, item){ 
			$("#" + item.item_type).text(item.form_title);
			
			itemReleatedInfo = item.item_releated_list;
			if ( itemReleatedInfo != null && itemReleatedInfo.length > 0) {
				$("#" + item.item_type + "_modify_btn").prop("disabled", false);
				$("#" + item.item_type + "_reg_btn").prop("disabled", true);
			}

			itemUnreleatedInfo = item.item_unreleated_list;
			if ( itemUnreleatedInfo != null && itemUnreleatedInfo.length > 0) {
				$("#" + item.item_type + "_modify_btn").prop("disabled", true);
				$("#" + item.item_type + "_reg_btn").prop("disabled", false);
			}
		});
	}

	var itemType = "";
	var itemCount = 1;
	var radioCount = 1;
	function makeItem(element) {
		$("#preview").hide();
		itemType = $(element).val();
		$("#form_title").val("");
		itemCount = 1;
		radioCount = 1;
		returnObjList = new Array();

	   $("#thead_tr").empty();
	   var theadStr = "";
	   if (itemType == "A1" || itemType == "A2" || itemType == "A3") {
		   theadStr += "<th scope='col'>평가항목</th>";
		   theadStr += "<th scope='col'>세부지표</th>";
		   theadStr += "<th scope='col'>배점</th>";
	   } else {
		   theadStr += "<th scope='col'>검토항목</th>";
		   theadStr += "<th scope='col'>검토의견</th>";
	   }
	   $("#thead_tr").append(theadStr);

	   $("#list_colgroup").empty();
	   var colgroupStr = "";
	   if (itemType == "A1" || itemType == "A2" || itemType == "A3") {
		   colgroupStr += "<col style='width:30%'>";
		   colgroupStr += "<col style='width:55%'>";
		   colgroupStr += "<col style='width:15%'>";
	   } else {
		   colgroupStr += "<col style='width:30%'>";
		   colgroupStr += "<col style='width:70%'>";
	   }
	   $("#list_colgroup").append(colgroupStr);
		
		//작성버튼
		if ( $(element).text() == "작성" ) {
			$("#form_box_score_write").css('display', 'block');	
			$("#form_box_score_txt1, #score_modify, #opinion_modify, #opinion_view").css('display', 'none');
			
			$("#type_body").empty();
			var str = "";
			str += "<tr class='item_" + itemCount + "'>";
			str += "	<td rowspan='1'>";
			str += "		<button type='button' class='add mr5 d_ib' onclick='addItemName(this);'>+</button>";
			str += "		<input type='text' class='form-control d_ib' />";
			str += "		<button type='button' class='del mr5 d_ib' onclick='deleteItemName(this);'>x</button>";
			str += "	</td>";
			str += "	<td>";
			str += "		<button type='button' class='add mr5 d_ib' onclick='addItemDetailName(this);'>+</button>";
			str += "		<textarea type='text' class='form-control d_ib' />";
			str += "		<button type='button' class='del mr5 d_ib' onclick='deleteItemDetailName(this);'>x</button>";
			str += "	</td>";
			if (itemType == "A1" || itemType == "A2" || itemType == "A3") {
				str += "	<td><input type='text' name='point_yn' oninput='numberOnlyMaxLength(this);' class='form-control mr5' maxlength='2' disabled /></td>";
			} else {
/* 				str += "<td>";
				str += "	<input type='radio' name='write_table2_type_" + radioCount + "' id='write_table2_type_" + radioCount + "' value='적합' checked/>";
				str += "	<label for='write_table2_type1' class='mr10'>적합</label>	";
				str += "	<input type='radio' name='write_table2_type_" + radioCount + "' id='write_table2_type_" + radioCount + "_2' value='부적합' />";
				str += "	<label for='write_table2_type1_2' class='mr10'>부적합</label>	";
				str += "</td>"; */
			}
			
			str += "</tr>";
			
			$("#type_body").append(str);
		}
		//수정 버튼 
		else {
			$("#status").text("수정중");
			$("#status_btn").html("수정하기");
			$("#form_box_score_write").css('display', 'block');	
			$("#form_box_score_txt1, #score_modify, #opinion_modify, #opinion_view").css('display', 'none');

			$("#type_body").empty();
			var pointYN = false;
			var str = "";
			$.each(itemInfo, function(index, item){ 
				if ( $(element).val() == item.item_type ) {

					$("#form_title").val(item.form_title);
					$.each(item.item_releated_list, function(index2, item2){
						
						$.each(item2.item_form_detail_info_list, function(index3, item3){
							str += "<tr class='item_" + itemCount + "'>";
							if (index3 == 0 ) {
								str += "	<td rowspan='" +item2.item_form_detail_info_list.length  + "'>";
								str += "		<button type='button' class='add mr5 d_ib' onclick='addItemName(this);'>+</button>";
								str += "		<input type='text' value='" + item2.form_item_name+ "' class='form-control d_ib' />";
								str += "		<button type='button' class='del mr5 d_ib' onclick='deleteItemName(this);'>x</button>";
								str += "	</td>";
							}
							str += "		<td>";
							str += "			<button type='button' class='add mr5 d_ib' onclick='addItemDetailName(this);'>+</button>";
							str += "			<textarea type='text' class='form-control d_ib'>" + item3.form_item_detail_name + "</textarea>";
							str += "			<button type='button' class='del mr5 d_ib' onclick='deleteItemDetailName(this);'>x</button>";
							str += "		</td>";

							if (itemType == "A1" || itemType == "A2" || itemType == "A3") {
								if ( gfn_isNull(item3.form_item_result) == false) {
									pointYN = true;
								}
								str += "	<td><input type='text' value='" + item3.form_item_result + "' name='point_yn' oninput='numberOnlyMaxLength(this);' class='form-control mr5' maxlength='2' disabled /></td>";
							} else {
								radioCount++;
								/* str += "<td>";
								if ( item3.form_item_result == "적합") {
									str += "	<input type='radio' name='write_table2_type_" + radioCount + "' id='write_table2_type_" + radioCount + "' value='적합' checked/>";
									str += "	<label for='write_table2_type1' class='mr10'>적합</label>	";
									str += "	<input type='radio' name='write_table2_type_" + radioCount + "' id='write_table2_type_" + radioCount + "_2' value='부적합' />";
									str += "	<label for='write_table2_type1_2' class='mr10'>부적합</label>	";
								} else {
									str += "	<input type='radio' name='write_table2_type_" + radioCount + "' id='write_table2_type_" + radioCount + "' value='적합'/>";
									str += "	<label for='write_table2_type1' class='mr10'>적합</label>	";
									str += "	<input type='radio' name='write_table2_type_" + radioCount + "' id='write_table2_type_" + radioCount + "_2' value='부적합' checked/>";
									str += "	<label for='write_table2_type1_2' class='mr10'>부적합</label>	";
								}
								str += "</td>"; */
							}
							str += "</tr>";
						});
						itemCount++;
					});
				}
			});
			
			$("#type_body").append(str);

			if ( pointYN) {
				$("#point_yn_ckb").prop("checked", true);
				$("input:text[name='point_yn']").attr("disabled", false);
			}
		}
	}

	// 평가 작성 중에서 '평가항목'을 추가한다.
	function addItemName(element) {
		itemCount++;
		radioCount++;
 		var index = $(element).closest("tr").prevAll().length;
 		var tableObj = $("#type_body tr");

 		// 같은 class명을 가지는 여러개의 tr이 있는 경우도 index = 0 으로 선택되어 진다.
 		// 따라서 class 명이 같은 tr 개수을 더한다. 단 index = 0 부터 이므로 1을 뺀다.
 		var clickedRow = $(element).parent().parent();
        var cls = clickedRow.attr("class");
        index = (index + $("."+cls).length) - 1;

 		var newitem = $("#type_body tr:eq(0)").clone();
        newitem.removeAttr("class");
        newitem.find("td:eq(0)").attr("rowspan", "1");
        // 데이터 초기화
        newitem.find("input").val("");
        newitem.find("textarea").val("");
		// Class명 추가	
        newitem.addClass("item_"+ itemCount);

        if (itemType == "B1" || itemType == "B2" || itemType == "B3") {
        	 newitem.find("input:radio").attr("name", "write_table2_type_" + radioCount);
        	 newitem.find("input:radio").eq(0).prop("checked", true);
        	 newitem.find("input:radio").eq(0).attr("value", "적합");
        	 newitem.find("input:radio").eq(1).attr("value", "부적합");
        } 

		// Click 위치에 tr 추가
		tableObj.eq(index).after(newitem);
	}
	
	// 평가 작성 중에서 '평가항목'을 삭제한다.
	function deleteItemName(element) {
		if ( $("#type_body tr").length == 1) {
			alert("해당 항목은 삭제할 수 없습니다.");
			return;
		}
		var tr = $(element).parent().parent();
		var cls = tr.attr("class");

		if ( $("#type_body tr").length == $("." + cls).length ) {
			alert("해당 항목은 삭제할 수 없습니다.");
			return;
		}
		
		$("." + cls).each(function (index, item) { 
			item.remove();
		});
	}

	// 평가 작성 중에서 '세부지표'을 추가한다.
	function addItemDetailName(element){
		radioCount++;
        var clickedRow = $(element).parent().parent();
        var cls = clickedRow.attr("class");
        
        // tr 복사해서 마지막에 추가
		// tr 복사
        var newrow = $("."+cls).first().clone();
        newrow.find("td:eq(0)").remove();
        // 데이터 초기화
        newrow.find("input").val("");
        newrow.find("textarea").val("");

        if (itemType == "B1" || itemType == "B2" || itemType == "B3") {
       		newrow.find("input:radio").attr("name", "write_table2_type_" + radioCount);
       		newrow.find("input:radio").eq(0).prop("checked", true);
       		newrow.find("input:radio").eq(0).attr("value", "적합");
       		newrow.find("input:radio").eq(1).attr("value", "부적합");
       	} 
       	
		// 마지막에 추가
        var lastRow = clickedRow.last();
        newrow.insertAfter(lastRow);
        
		// rowspan 조정
        var rowspan = $("."+cls).length;
        $("."+cls+":first td:eq(0)").attr("rowspan", rowspan);
	}

	// 평가 작성 중에서 '세부지표'을 삭제한다.
	function deleteItemDetailName(element) {
		if ( $("#type_body tr").length == 1) {
			alert("해당 항목은 삭제할 수 없습니다.");
			return;
		}
		
		var clickedRow = $(element).parent().parent();
        var cls = clickedRow.attr("class");
         
        // 각 항목의 첫번째 row를 삭제한 경우 다음 row에 td 하나를 추가해 준다.
        if( clickedRow.find("td:eq(0)").attr("rowspan") ){
            if( clickedRow.next().hasClass(cls) ){
                clickedRow.next().prepend(clickedRow.find("td:eq(0)"));
            }
        }
        clickedRow.remove();

		// rowspan 조정
        var rowspan = $("."+cls).length;
        $("."+cls+":first td:eq(0)").attr("rowspan", rowspan);
	}

	// 채점항목 On-Off
	function clickPointCkeckBox(element) {
		if ( $(element).prop("checked") ) {
			$("input:text[name='point_yn']").attr("disabled", false);
		} 
		else {
			$("input:text[name='point_yn']").attr("disabled", true);
		}
	}


	function saveItemForm(element) {
		if ( gfn_isNull($("#form_title").val()) ) {
			alert("제목을 입력하시기 바랍니다.");
			return;
		}
		var beforeTrClassName = "";
		var trObj = new Object();
		var returnObjList = new Array();
		var isFirst = true;
		var tdObjList = new Array();
		var returnFlag = true;
		var rowCount = 0;
		
		$('#type_body tr').each(function(){
			rowCount++;
			// tr class 이름이 바꿔면 새로운 입력 객체를 생성 
			if ( beforeTrClassName != $(this).attr("class")) {
				beforeTrClassName = $(this).attr("class");
				if ( isFirst == true ) {
					isFirst = false;
				}else {
					trObj.item_form_detail_info_list = tdObjList;
					returnObjList.push(trObj);
					trObj = new Object();
					tdObjList = new Array();
				}
			}
			
			var tr = $(this);
			var td = tr.children();
			var tdObj = new Object();
			td.each(function() { 
				// 평가항목
				if ( $(this).is("[rowspan]") ) {
					if ( gfn_isNull($(this).find("input").val()) ) {
						alert("평가항목은 필수 입력입니다.");
						returnFlag = false;
						return false;
					}
					trObj.form_item_name = $(this).find("input").val();
					trObj.form_item_id = tr.attr("class").replace("item_", "");
				} 
				// 세부지표 / 배점
				else {
					// 세부지표
					if ( $(this).find("textarea").length > 0 ) {
						if ( gfn_isNull($(this).find("textarea").val()) ) {
							alert("세부지표는 필수 입력입니다.");
							returnFlag = false;
							return false;
						}
						tdObj.form_item_detail_name = $(this).find("textarea").val();
					} 
					// 배점
					else {
						// A type 과 B type 처리 방식이 다르다.
				        if (itemType == "B1" || itemType == "B2" || itemType == "B3") {
				        	var temp = $(this).find("input:radio:checked").val();
				       		tdObj.form_item_result = $(this).find("input:radio:checked").val();
				       	} else {
				       		// 평가 점수 항목 true인 경우만 처리
							if ( $("#point_yn_ckb").is(":checked") ) {
								if ( gfn_isNull($(this).find("input").val()) ) {
									alert("배점은 필수 입력입니다.");
									returnFlag = false;
									return false;
								} else {
									tdObj.form_item_result = $(this).find("input").val();
								}
							}
				       	}
					}
				}
			});

			if (returnFlag == false) {
				return false;
			}
			tdObj.form_item_seq = tdObjList.length+1;
			tdObjList.push(tdObj);

			// 마지막 데이터 입력
			if ( $('#type_body tr').length == rowCount ){
				trObj.item_form_detail_info_list = tdObjList;
				returnObjList.push(trObj);
			}
		});

		if (returnFlag == false) {
			return false;
		}

		
		if ($("#status_btn").html() == "수정하기" ) {
			if ( confirm("수정하시겠습니까?") ) {
				var formData = new FormData();
				var ids = "${vo.update_evaluation_number_list}".replace("[","").replace("]","");
				formData.append("evaluation_id_list", ids.split(','));
				
				formData.append("item_type", itemType);
				formData.append("form_title", $("#form_title").val());
				formData.append("item_form_info_json", JSON.stringify(returnObjList));

				$.ajax({
				    type : "POST",
				    url : "/admin/api/evaluation/match/releatedItem/registration",
				    data : formData,
				    processData: false,
				    contentType: false,
				    mimeType: 'multipart/form-data',
				    success : function(data) {
				    	var jsonData = JSON.parse(data);
				        if (jsonData.result == true) {
				            alert("수정 되었습니다.");
				            location.reload();
				        } else {
				            alert("수정에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
				        }
				    },
				    error : function(err) {
				        alert(err.status);
				    }
				});
				
			}
		} else {
			if ( confirm("저장 하시겠습니까?") ) {
				var formData = new FormData();
				formData.append("item_type", itemType);
				formData.append("form_title", $("#form_title").val());
				formData.append("item_form_info_json", JSON.stringify(returnObjList));
				
				$.ajax({
				    type : "POST",
				    url : "/admin/api/evaluation/match/item/registration",
				    data : formData,
				    processData: false,
				    contentType: false,
				    mimeType: 'multipart/form-data',
				    success : function(data) {
				    	var jsonData = JSON.parse(data);
				        if (jsonData.result == true) {
				            alert("저장 되었습니다.");
				            location.reload();
				        } else {
				            alert("저장에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
				        }
				    },
				    error : function(err) {
				        alert(err.status);
				    }
				});
			}

		}
		
		
	}

	function registrationReleatedItemForm(element) {
		if ( $(element).text() != "저장된 양식이 없습니다." ) {
			$.each(itemInfo, function(index, item){ 
				if ( $(element).val() == item.item_type ) {
					
					if ( confirm("등록 하시겠습니까?") ) {
						var formData = new FormData();
						var ids = "${vo.update_evaluation_number_list}".replace("[","").replace("]","");
						formData.append("evaluation_id_list", ids.split(','));
						
						formData.append("item_type", item.item_type);
						formData.append("form_title", item.form_title);
						if ( item.item_unreleated_list !=null) {
							formData.append("item_form_info_json", JSON.stringify(item.item_unreleated_list));
						}
						if ( item.item_releated_list !=null) {
							formData.append("item_form_info_json", JSON.stringify(item.item_releated_list));
						}
						
						$.ajax({
						    type : "POST",
						    url : "/admin/api/evaluation/match/releatedItem/registration",
						    data : formData,
						    processData: false,
						    contentType: false,
						    mimeType: 'multipart/form-data',
						    success : function(data) {
						    	var jsonData = JSON.parse(data);
						        if (jsonData.result == true) {
						            alert("등록 되었습니다.");
						            location.reload();
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
			});
		} else {
			alert("평가 항목 템플릿을 먼저 작성해 주시기 바랍니다.");
		}
	}


	function preview(element) {
		if ( $(element).text() != "저장된 양식이 없습니다." ) {
			// item에 해당하는 데이터를 찾는다.
			var str = "";
			$.each(itemInfo, function(index, item){ 
				if ( $(element).attr("id") == item.item_type ) {
					$("#preview_body").empty();

					$("#preview_title").text(item.form_title);
 					if ( item.item_releated_list != null && item.item_releated_list.length > 0) {
						$.each(item.item_releated_list, function(index2, item2){
							if ( item2.item_form_detail_info_list != null && item2.item_form_detail_info_list.length > 0) {
								$.each(item2.item_form_detail_info_list, function(index3, item3){
									str += "<tr>";
									if (index3 == 0 ) {
										str += "	<td rowspan='" +item2.item_form_detail_info_list.length  + "'><span>" + item2.form_item_name + "</span></td>";
									}
									str += "<td>" + item3.form_item_detail_name + "</td>";
									str += "<td>" + item3.form_item_result +"</td>";
									str += "</tr>";
								});
							}
						});
					}

 					if ( item.item_unreleated_list != null && item.item_unreleated_list.length > 0) {
						$.each(item.item_unreleated_list, function(index2, item2){
							if ( item2.item_form_detail_info_list != null && item2.item_form_detail_info_list.length > 0) {
								$.each(item2.item_form_detail_info_list, function(index3, item3){
									str += "<tr>";
									if (index3 == 0 ) {
										str += "	<td rowspan='" +item2.item_form_detail_info_list.length  + "'><span>" + item2.form_item_name + "</span></td>";
									}
									str += "	<td>" + item3.form_item_detail_name + "</td>";
									str += "	<td>" + item3.form_item_result +"</td>";
									str += "</tr>";
								});
							}
						});
					}
				}
			});
			$("#preview_body").append(str);
			
			$("#preview").show();	
			$("#form_box_score_write, #score_modify, #opinion_modify, #opinion_view").css('display', 'none');
		} else {
			$("#preview").hide();
			alert("평가 항목 템플릿을 먼저 작성해 주시기 바랍니다.");
		}
	}

	function moveMain() {
		location.href = "/admin/fwd/evaluation/main?announcement_type=" + '${vo.announcement_type}' + "&classification="  + '${vo.classification}';
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
				       <h2 class="title">평가관리</h2>
				   </div>
		                 <!--// 레프트 메뉴 서브 타이틀 -->					   
				   <div class="lnb_menu_area">	
				       <ul class="lnb_menu">
					       <li class="on"><a href="/admin/fwd/evaluation/match/main" title="평가관리">평가관리</a></li>
						   <li class="menu2depth">
							   <ul>
								   	<li class="active"><a href="/admin/fwd/evaluation/match/main">기술매칭</a></li>
					   				<li><a href="">기술공모</a></li>
							  		<li><a href="">기술제안</a></li>
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
				       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
					   <li>평가관리</li>
					   <li><strong>기술매칭</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				   <h3 class="title_area">기술매칭</h3>
				  <!--//페이지타이틀-->
			    </div>
		   </div>
					   
			<div class="contents_view">                           
				<h4 class="sub_title_h4 mb10">평가서 양식</h4> 	       						    
				<p class="formbox_p">평가서 제목을 누르면 평가서 내용을 볼 수 있습니다. 평가서가 없는 경우, <span class="font_blue">작성버튼</span>을 눌러서 평가서 양식을 작성해 주세요.</p>
			    <!--Type A 평가점수-->
				<div class="form_box_score clearfix form">
					<div class="form_box_score_title fl mr5">
						<span>Type A<br />
						(평가 점수)</span>
					</div>

					<div class="form_box_score_txt fl mr5">
						<ol>
							<li class="clearfix">
								<span class="fl mr5">1</span><p class="fl mr5" id="A1" onclick="preview(this);">저장된 양식이 없습니다.</p>
								<button type="button" class="blue_btn fl mr5 add_write" value="A1" id="A1_modify_btn" onclick="makeItem(this);" disabled>수정</button>
								<button type="button" class="blue_btn fl" value="A1" id="A1_reg_btn" onclick="registrationReleatedItemForm(this);">등록</button>
							</li>
							<li class="clearfix">
								<span class="fl mr5">2</span><p class="fl mr5" id="A2" onclick="preview(this);">저장된 양식이 없습니다.</p>
								<button type="button" class="blue_btn fl mr5 add_write" value="A2" id="A2_modify_btn" onclick="makeItem(this);" disabled>수정</button>
								<button type="button" class="blue_btn fl" value="A2" id="A2_reg_btn" onclick="registrationReleatedItemForm(this);">등록</button>
							</li>
							<li class="clearfix">
								<span class="fl mr5">3</span><p class="fl mr5" id="A3" onclick="preview(this);">저장된 양식이 없습니다.</p>
								<button type="button" class="blue_btn fl mr5 add_write" value="A3" id="A3_modify_btn" onclick="makeItem(this);" disabled>수정</button>
								<button type="button" class="blue_btn fl" value="A3" id="A3_reg_btn" onclick="registrationReleatedItemForm(this);">등록</button>
							</li>
						</ol>
					</div>
				</div>
				<!--//Type A 평가점수-->

				<!--Type B 평가의견-->
				<div class="form_box_score clearfix form">
					<div class="form_box_score_title fl mr5">
						<span>Type B<br />
						(평가 의견)</span>
					</div>

					<div class="form_box_score_txt fl mr5">
						<ol>
							<li class="clearfix">
								<span class="fl mr5">1</span><p class="fl mr5"  id="B1" onclick="preview(this);">저장된 양식이 없습니다.</p>
								<button type="button" class="blue_btn fl mr5" value="B1" id="B1_modify_btn" onclick="makeItem(this);" disabled>수정</button>
								<button type="button" class="blue_btn fl" value="B1" id="B1_reg_btn" onclick="registrationReleatedItemForm(this);">등록</button>
							</li>
							<li class="clearfix">
								<span class="fl mr5">2</span><p class="fl mr5"  id="B2" onclick="preview(this);">저장된 양식이 없습니다.</p>
								<button type="button" class="blue_btn fl mr5" value="B2" id="B2_modify_btn" onclick="makeItem(this);" disabled>수정</button>
								<button type="button" class="blue_btn fl" value="B2" id="B2_reg_btn" onclick="registrationReleatedItemForm(this);">등록</button>
							</li>
							<li class="clearfix">
								<span class="fl mr5">3</span><p class="fl mr5"  id="B3" onclick="preview(this);">저장된 양식이 없습니다.</p>
								<button type="button" class="blue_btn fl mr5" value="B3" id="B2_modify_btn" onclick="makeItem(this);" disabled>수정</button>
								<button type="button" class="blue_btn fl" value="B3" id="B3_reg_btn" onclick="registrationReleatedItemForm(this);">등록</button>
							</li>
						</ol>
					</div>
				</div>
				<!--Type B 평가의견-->

				<!--평가 점수-->
				<!--점수view-->
				<div class="form_box_score_txt_view form" id="preview" style="display:none">
					<ul class="clearfix">
						<li class="title">미리보기</li>
						<li class="txt"><span id="preview_title">기술제안 대면평가 양식</span></li>
					</ul>

					<table class="list th_c mt20">
					   <caption>리스트 화면</caption>  
					   <colgroup id="preview_colgroup">
						   <col style="width:30%">
						   <col style="width:55%">										   
						   <col style="width:15%">
					   </colgroup>
					   <thead id="preview_head">
						   <tr>
							   <th scope="col">평가항목</th>										   
							   <th scope="col">세부지표</th>
							   <th scope="col">배점</th>
						   </tr>
					   </thead>
					   <tbody id="preview_body">
					   </tbody>
				   </table>
				</div>							
				<!--//점수view-->

				<!--점수작성-->
				<div class="form_box_score_write form" id="form_box_score_write">
					<ul class="clearfix">
						<li class="title" id="status">작성중</li>
						<li class="txt">
							<input type="text" id="form_title" class="form-control fl mr5" />
							<button type="button" class="fl blue_btn" id="status_btn" onclick="saveItemForm(this);">저장하기</button>
						</li>
					</ul>
					
					<div class="check">
						<input type="checkbox" id="point_yn_ckb" onclick='clickPointCkeckBox(this);'>
						<label class="form_box_score_txt_write_check">평가 점수 항목</label>
					</div>

					<table class="list th_c mt20 write_table2">
					   <caption>리스트 화면</caption>  
					   <colgroup id="list_colgroup">
						   <col style="width:30%">
						   <col style="width:55%">										   
						   <col style="width:15%">
					   </colgroup>
					   <thead>
						   <tr id="thead_tr">
							   <th scope="col">평가항목</th>										   
							   <th scope="col">세부지표</th>
							   <th scope="col">배점</th>
						   </tr>
					   </thead>
					   <tbody id="type_body">
					   </tbody>
				   </table>
				</div>
				<!--//점수작성-->
				
				
				
				
				
				<!--점수수정-->
				<div class="form_box_score_write form" id="score_modify">
					<ul class="clearfix">
						<li class="title">수정중</li>
						<li class="txt">
							<input type="text" class="form-control fl mr5" />
							<button type="submit" class="fl blue_btn save_form_popup_btn">저장하기</button>
						</li>
					</ul>								

					<table class="list th_c mt20 write_table2">
					   <caption>리스트 화면</caption>  
					   <colgroup>
						   <col style="width:30%">
						   <col style="width:55%">										   
						   <col style="width:15%">
					   </colgroup>
					   <thead>
						   <tr>
							   <th scope="col">평가항목</th>										   
							   <th scope="col">세부지표</th>
							   <th scope="col">배점</th>
						   </tr>
					   </thead>
					   <tbody>
						   <tr>
							   <td rowspan="3">
									<button type="button" class="add mr5 d_ib">+</button>
									<input type="text" class="form-control d_ib" />
									<button type="button" class="del mr5 d_ib">x</button>
							   </td>										   
							   <td>
									<button type="button" class="add mr5 d_ib">+</button>
									<textarea type="text" class="form-control d_ib"></textarea>
									<button type="button" class="del mr5 d_ib">x</button>
							   </td>
							   <td><input type="text" class="form-control mr5 number_t" maxlength="2" /></td>									   
						   </tr>
						   <tr>
							   <td>
									<button type="button" class="add mr5 d_ib">+</button>
									<textarea type="text" class="form-control d_ib"></textarea>
									<button type="button" class="del mr5 d_ib">x</button>
							   </td>
							   <td><input type="text" class="form-control mr5 number_t" maxlength="2" /></td>	
						   </tr>
						   <tr>
							   <td>
									<button type="button" class="add mr5 d_ib">+</button>
									<textarea type="text" class="form-control d_ib"></textarea>
									<button type="button" class="del mr5 d_ib">x</button>
							   </td>
							   <td><input type="text" class="form-control mr5 number_t" maxlength="2" /></td>	
						   </tr>
					   </tbody>
				   </table>
				</div>
				<!--//점수수정-->
				<!--//평가 점수-->
							
				<!--평가의견-->
				<!--view-->
				<div class="form_box_score_write form" id="opinion_view">
					<ul class="clearfix">
						<li class="title">미리보기</li>
						<li class="txt"><span>사전검토 양식</span></li>
					</ul>								

					<table class="list th_c mt20 write_table2">
					   <caption>리스트 화면</caption>  
					   <colgroup>
						   <col style="width:30%">
						   <col style="width:55%">										   
						   <col style="width:15%">
					   </colgroup>
					   <thead>
						   <tr>
							   <th scope="col">검토항목</th>										   
							   <th scope="col">검토사항</th>
							   <th scope="col">결과</th>
						   </tr>
					   </thead>
					   <tbody>
						   <tr>
							   <td><span>시 추진사업 적용 가능성 (적용 분야 검토 의견)</span></td>										   
							   <td><span>실증기관 의견서에 작성된 기관 사업과 제안된 기술의 적용 분야 연관성</span></td>
							   <td><span>적합</span></td>									   
						   </tr>
						   <tr>
							   <td><span>시 추진사업 적용 가능성 (적용 분야 검토 의견)</span></td>										   
							   <td><span>실증기관 의견서에 작성된 기관 사업과 제안된 기술의 적용 분야 연관성</span></td>
							   <td><span>적합</span></td>									   
						   </tr>
						   <tr>
							   <td><span>시 추진사업 적용 가능성 (적용 분야 검토 의견)</span></td>										   
							   <td><span>실증기관 의견서에 작성된 기관 사업과 제안된 기술의 적용 분야 연관성</span></td>
							   <td><span>적합</span></td>									   
						   </tr>
						   <tr>
							   <td><span>시 추진사업 적용 가능성 (적용 분야 검토 의견)</span></td>										   
							   <td><span>실증기관 의견서에 작성된 기관 사업과 제안된 기술의 적용 분야 연관성</span></td>
							   <td><span>적합</span></td>									   
						   </tr>
					   </tbody>
				   </table>
				</div>
				<!--//view-->

				<!--수정-->
				<div class="form_box_score_write form" id="opinion_modify">
					<ul class="clearfix">
						<li class="title">수정중</li>
						<li class="txt">
							<input type="text" class="form-control fl mr5" />
							<button type="submit" class="fl blue_btn save_form_popup_btn">저장하기</button>
						</li>
					</ul>								

					<table class="list th_c mt20 write_table2">
					   <caption>리스트 화면</caption>  
					   <colgroup>
						   <col style="width:30%">
						   <col style="width:55%">										   
						   <col style="width:15%">
					   </colgroup>
					   <thead>
						   <tr>
							   <th scope="col">검토항목</th>										   
							   <th scope="col">검토의견</th>
							   <th scope="col">결과</th>
						   </tr>
					   </thead>
					   <tbody>
						   <tr>
							   <td rowspan="3">
									<button type="button" class="add mr5 d_ib">+</button>
									<input type="text" class="form-control d_ib" />
									<button type="button" class="del  d_ib">x</button>
							   </td>										   
							   <td>
									<button type="button" class="add mr5 d_ib">+</button>
									<textarea rows="10" type="text" class="form-control d_ib"></textarea>
									<button type="button" class="del d_ib">x</button>
							   </td>
							   <td>											
								   <input type="radio" name="write_table2_type" id="write_table2_type1" checked />
								   <label for="write_table2_type1" class="mr10">적합</label>										
								   <input type="radio" name="write_table2_type" id="write_table2_type1_2" />
								   <label for="write_table2_type1_2">부적합</label>										  									
							   </td>									   
						   </tr>
						   <tr>
							   <td>
									<button type="button" class="add mr5 d_ib">+</button>
									<textarea rows="10" type="text" class="form-control d_ib"></textarea>
									<button type="button" class="del d_ib">x</button>
							   </td>
							   <td>											
								   <input type="radio" name="write_table2_type2" id="write_table2_type2" checked />
								   <label for="write_table2_type2" class="mr10">적합</label>										
								   <input type="radio" name="write_table2_type2" id="write_table2_type2_1" />
								   <label for="write_table2_type2_1">부적합</label>										  									
							   </td>
						   </tr>
						   <tr>
							   <td>
									<button type="button" class="add mr5 d_ib">+</button>
									<textarea rows="10" type="text" class="form-control d_ib"></textarea>
									<button type="button" class="del d_ib">x</button>
							   </td>
							   <td>											
								   <input type="radio" name="write_table2_type3" id="write_table2_type3" checked />
								   <label for="write_table2_type3" class="mr10">적합</label>										
								   <input type="radio" name="write_table2_type3" id="write_table2_type3_1" />
								   <label for="write_table2_type3_1">부적합</label>										  									
							   </td>
						   </tr>
					   </tbody>
				   </table>
				</div>
				<!--//수정-->
				<!--//평가의견-->
				<div class="fr clearfix mt30">								
					<button type="button" class="gray_btn2 fl" onclick="moveMain();">목록</button>	  								   
				</div>
			</div><!--contents_view-->
    	</div>
	<!--//contents--> 
	</div>
<!--//sub--> 
</div>
            

<!--저장 팝업-->
	<div class="save_form_popup_box">
	   <div class="popup_bg"></div>
	   <div class="save_form_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">저장 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
		   		<p><span class="font_blue">저장</span> 하시겠습니까?</p>		   	   
			    <div class="popup_button_area_center">
				   <button type="submit" class="blue_btn mr5 ok_btn">확인</button>
				   <button type="button" class="gray_btn popup_close_btn">취소</button>
			    </div>				   
		   </div>
	   </div>
   </div>
   <!--//저장 팝업-->

   <!--삭제 팝업-->
   <div class="del_info_popup_box">
	   <div class="popup_bg"></div>
	   <div class="del_info_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">삭제 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
		   		<p><span class="font_blue">삭제</span> 하시겠습니까?</p>		   	   
			    <div class="popup_button_area_center">
				   <button type="submit" class="blue_btn mr5 ok_btn">확인</button>
				   <button type="button" class="gray_btn popup_close_btn">취소</button>
			    </div>				   
		   </div>
	   </div>
   </div>
   <!--//삭제 팝업-->

   <!--등록 팝업-->
   <div class="add_info_popup_box">
	   <div class="popup_bg"></div>
	   <div class="add_info_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">등록 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
		   		<p><span class="font_blue">평가서 등록</span> 하시겠습니까?</p>		   	   
			    <div class="popup_button_area_center">
				   <button type="submit" class="blue_btn mr5 ok_btn">등록</button>
				   <button type="button" class="gray_btn popup_close_btn">취소</button>
			    </div>				   
		   </div>
	   </div>
   </div>


<script src="/assets/admin/js/script.js"></script>