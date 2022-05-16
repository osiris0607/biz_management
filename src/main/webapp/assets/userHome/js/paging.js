/* divId : 페이징 태그가 그려질 div pageIndx : 현재 페이지 위치가 저장될 input 태그 id recordCount : 페이지당 레코드 수 totalCount : 전체 조회 건수 eventName : 페이징 하단의 숫자 등의 버튼이 클릭되었을 때 호출될 함수 이름 */ 
/*
divId : 페이징 태그가 그려질 div
pageIndx : 현재 페이지 위치가 저장될 input 태그 id
recordCount : 페이지당 레코드 수
totalCount : 전체 조회 건수 
eventName : 페이징 하단의 숫자 등의 버튼이 클릭되었을 때 호출될 함수 이름
*/
var gfv_pageIndex = null;
var gfv_eventName = null;
function gfnRenderPaging(params){
	var divId = params.divId; // 페이징이 그려질 div id
	gfv_pageIndex = params.pageIndex; // 현재 위치가 저장될 input 태그
	var totalCount = params.totalCount; // 전체 조회 건수
	
	var currentIndex = $("#"+params.pageIndex).val(); // 현재 위치
	if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
		currentIndex = 1;
	}
	
	var recordCount = params.recordCount; // 페이지당 레코드 수
	if(gfn_isNull(recordCount) == true){
		recordCount = 10;
	}
	var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 인덱스 수
	gfv_eventName = params.eventName;
	
	$("#"+divId).empty();

	var preStr  = "<ul class='pagination'>";
	var postStr = "";
	var str = "";
	
	var first = (parseInt((currentIndex-1) / 10) * 10) + 1;
	var last = (parseInt(totalIndexCount/10) == parseInt(currentIndex/10)) ? totalIndexCount%10 : 10;
	if ( (currentIndex%10) == 0 ) {
		last = 10;
	}
	var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1; 
	var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount;
	
	if (totalIndexCount > 10) { // 전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
		preStr += "<li><a href='javascript:void(0)' class='first' onclick='_movePage("+"1"+", "+ gfv_eventName +")'>처음 페이지</a></li>"
		preStr += "<li><a href='javascript:void(0)' class='arrow left'><i class='fas fa-angle-left' onclick='_movePage("+prev+", "+ gfv_eventName +");'></i></a></li>"
		

		//		preStr += "<a href='javascript:void(0);' class='pprev' onclick='_movePage("+prev+", "+ gfv_eventName +")'></a>";
//		preStr += "<li class='pagination__listitem'><a href='javascript:void(0);' class='pagination__link'onclick='_movePage("+"1"+", "+ gfv_eventName +")'>◀◀</a></li>" +
//				  "<li><a href='javascript:void(0);' class='pagination__link' onclick='_movePage("+prev+", "+ gfv_eventName +")'>◀</a></li>";
	} else if (totalIndexCount <=10 && totalIndexCount > 1) { // 전체 인덱스가 10보다 작을경우, 맨앞 태그 작성
		preStr += "<li><a href='javascript:void(0)' class='first' onclick='_movePage("+prev+", "+ gfv_eventName +")'>처음 페이지</a></li>"
		preStr += "<li><a href='javascript:void(0)' class='arrow left'><i class='fas fa-angle-left' onclick='_movePage("+prev+", "+ gfv_eventName +");'></i></a></li>"
		
//		preStr += "<a href='javascript:void(0);' class='pprev' onclick='_movePage("+prev+", "+ gfv_eventName +")'></a>";
//		preStr += "<li class='page-item'><a href='javascript:void(0);' class='pprev' onclick='_movePage("+prev+", "+ gfv_eventName +")'></a></li>";
//		preStr += "<li class='pagination__listitem'><a href='javascript:void(0);' class='pagination__link' onclick='_movePage("+prev+", "+ gfv_eventName +")'>◀</a></li>";
	}
	
	if (totalIndexCount > 10) { // 전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
		postStr += "<li><a href='javascript:void(0)' class='arrow right' onclick='_movePage("+next+", "+ gfv_eventName +");'><i class='fas fa-angle-right'></i></a></li>"
		postStr += "<li><a href='javascript:void(0)' class='last' onclick='_movePage("+totalIndexCount+", "+ gfv_eventName +");'>끝 페이지</a></li>"
		
//		postStr += "<li class='pagination__listitem'><a href='javascript:void(0);' class='pagination__link' onclick='_movePage("+next+", "+ gfv_eventName +")'>▶</a></li>" +
//				   "<li class='pagination__listitem'><a href='javascript:void(0);' class='pagination__link' onclick='_movePage("+totalIndexCount+", "+ gfv_eventName +")'>▶▶</a></li>";
	} else if (totalIndexCount <=10 && totalIndexCount > 1){ // 전체 인덱스가 10보다
		// 작을경우, 맨뒤 태그 작성
		postStr += "<li><a href='javascript:void(0)' class='arrow right' onclick='_movePage("+next+", "+ gfv_eventName +");'><i class='fas fa-angle-right'></i></a></li>"
		postStr += "<li><a href='javascript:void(0)' class='last' onclick='_movePage("+totalIndexCount+", "+ gfv_eventName +");'>끝 페이지</a></li>"

//		postStr += "<a href='javascript:void(0);' class='nnext' onclick='_movePage("+next+", "+ gfv_eventName +")'></a>";
//		postStr += "<li class='page-item'><a href='javascript:void(0);' class='page-link' onclick='_movePage("+next+", "+ gfv_eventName +")'>▶▶</a></li>";
//		postStr += "<li class='pagination__listitem'><a href='javascript:void(0);' onclick='_movePage("+totalIndexCount+", "+ gfv_eventName +")'>▶</a></li>";
	}
	
	for (var i = first; i < (first+last); i++) {
		console.log("currentIndex::"+gfv_pageIndex);
		console.log("i::"+i);
		if (i != currentIndex) {
			str += "<li><a href='javascript:void(0)' class='num' onclick='_movePage("+i+", "+ gfv_eventName +")'>"+i+"</a></li>";
		} else {
			str += "<li><a href='javascript:void(0)' class='active num' onclick='_movePage("+i+", "+ gfv_eventName +")'>"+i+"</a></li>";
		}
	}
	
	postStr += "</ul>";
	
	var tempStr = preStr + str + postStr;
//	console.log("tempStr = "+ tempStr);
	$("#"+divId).append(preStr + str + postStr);
	
}

function _movePage(value, eventName){
	$("#"+gfv_pageIndex).val(value);
	if(typeof(eventName) == "function"){
		eventName(value);
	}
}

function gfnRenderPagingMain(params){
	var divId = params.divId; // 페이징이 그려질 div id
	gfv_pageIndex = params.pageIndex; // 현재 위치가 저장될 input 태그
	var totalCount = params.totalCount; // 전체 조회 건수
	
	var currentIndex = $("#"+params.pageIndex).val(); // 현재 위치
	if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
		currentIndex = 1;
	}
	
	var recordCount = params.recordCount; // 페이지당 레코드 수
	if(gfn_isNull(recordCount) == true){
		recordCount = 10;
	}
	var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 인덱스 수
	gfv_eventName = params.eventName;
	
	$("#"+divId).empty();
	
	
	var preStr = "";
	var postStr = "";
	var str = "";
	
	
	var first = (parseInt((currentIndex-1) / 10) * 10) + 1;
	var last = (parseInt(totalIndexCount/10) == parseInt(currentIndex/10)) ? totalIndexCount%10 : 10;
	if ( (currentIndex%10) == 0 ) {
		last = 10;
	}
	var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1; 
	var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount;
	
	
	if (totalIndexCount > 10) { // 전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
		preStr += "<a href='javascript:void(0);' class='stimg' title='맨처음 페이지로 이동' onclick='_movePage("+1+", "+ gfv_eventName +");'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_first.png' alt='맨처음 페이지로 이동'>" +
				  "</a>";
		preStr += "<a href='javascript:void(0);' class='stimg' title='전 페이지로 이동' onclick='_movePage("+prev+", "+ gfv_eventName +")'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_prev.png' alt='전 페이지로 이동'>" +
				  "</a>";
	} else if (totalIndexCount <=10 && totalIndexCount > 1) { // 전체 인덱스가 10보다
		// 작을경우, 맨앞 태그 작성
		preStr += "<a href='javascript:void(0);' class='stimg' title='맨처음 페이지로 이동' onclick='_movePage("+1+", "+ gfv_eventName +");'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_first.png' alt='맨처음 페이지로 이동'>" +
				  "</a>";
		preStr += "<a href='javascript:void(0);' class='stimg' title='전 페이지로 이동' onclick='_movePage("+prev+", "+ gfv_eventName +")'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_prev.png' alt='전 페이지로 이동'>" +
				  "</a>";
	}
	if (totalIndexCount > 10) { // 전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
		postStr += "<a href='javascript:void(0);' class='stimg' title='다음 페이지로 이동' onclick='_movePage("+next+", "+ gfv_eventName +")'>" +
				   "	<img src='/assets/user/images/icon/btn_paging_next.png' alt='다음 페이지로 이동'>" +
				   "</a>";
	    postStr += "<a href='javascript:void(0);' class='stimg' title='맨마지막 페이지로 이동' onclick='_movePage("+totalIndexCount+", "+ gfv_eventName +")'>" +
				   "	<img src='/assets/user/images/icon/btn_paging_last.png' alt='맨마지막 페이지로 이동'>" +
				   "</a>";
	} else if (totalIndexCount <=10 && totalIndexCount > 1){ // 전체 인덱스가 10보다
		postStr += "<a href='javascript:void(0);' class='stimg' title='다음 페이지로 이동' onclick='_movePage("+next+", "+ gfv_eventName +")'>" +
				   "	<img src='/assets/user/images/icon/btn_paging_next.png' alt='다음 페이지로 이동'>" +
				   "</a>";
	   postStr += "<a href='javascript:void(0);' class='stimg' title='맨마지막 페이지로 이동' onclick='_movePage("+totalIndexCount+", "+ gfv_eventName +")'>" +
		   		  "		<img src='/assets/user/images/icon/btn_paging_last.png' alt='맨마지막 페이지로 이동'>" +
	   			  "</a>";
	}
	
	for (var i = first; i < (first+last); i++) {
		console.log("currentIndex::"+gfv_pageIndex);
		console.log("i::"+i);
		if (i != currentIndex) {
			str += "<a href='javascript:void(0);' onclick='_movePage("+i+", "+ gfv_eventName +");'>"+i+"</a>";
		} else {
			
			str += "<strong>"+i+"</strong>";
		}
	}
	
	postStr += "</ul>";
	var tempStr = preStr + str + postStr;
//	console.log("tempStr = "+ tempStr);
	$("#"+divId).append(preStr + str + postStr);
}



var gfv_pageIndexReception = null;
var gfv_eventNameReception = null;
function gfnRenderPagingReception(params){
	var divId = params.divId; // 페이징이 그려질 div id
	gfv_pageIndexReception = params.pageIndex; // 현재 위치가 저장될 input 태그
	var totalCount = params.totalCount; // 전체 조회 건수
	
	var currentIndex = $("#"+params.pageIndex).val(); // 현재 위치
	if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
		currentIndex = 1;
	}
	
	var recordCount = params.recordCount; // 페이지당 레코드 수
	if(gfn_isNull(recordCount) == true){
		recordCount = 10;
	}
	var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 인덱스 수
	gfv_eventNameReception = params.eventName;
	
	$("#"+divId).empty();
	
	
	var preStr = "";
	var postStr = "";
	var str = "";
	
	
	var first = (parseInt((currentIndex-1) / 10) * 10) + 1;
	var last = (parseInt(totalIndexCount/10) == parseInt(currentIndex/10)) ? totalIndexCount%10 : 10;
	if ( (currentIndex%10) == 0 ) {
		last = 10;
	}
	var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1; 
	var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount;
	
	
	if (totalIndexCount > 10) { // 전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
		preStr += "<a href='javascript:void(0);' class='stimg' title='맨처음 페이지로 이동' onclick='_movePageReception("+1+", "+ gfv_eventNameReception +");'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_first.png' alt='맨처음 페이지로 이동'>" +
				  "</a>";
		preStr += "<a href='javascript:void(0);' class='stimg' title='전 페이지로 이동' onclick='_movePageReception("+prev+", "+ gfv_eventNameReception +")'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_prev.png' alt='전 페이지로 이동'>" +
				  "</a>";
	} else if (totalIndexCount <=10 && totalIndexCount > 1) { // 전체 인덱스가 10보다
		// 작을경우, 맨앞 태그 작성
		preStr += "<a href='javascript:void(0);' class='stimg' title='맨처음 페이지로 이동' onclick='_movePageReception("+1+", "+ gfv_eventNameReception +");'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_first.png' alt='맨처음 페이지로 이동'>" +
				  "</a>";
		preStr += "<a href='javascript:void(0);' class='stimg' title='전 페이지로 이동' onclick='_movePageReception("+prev+", "+ gfv_eventNameReception +")'>" +
				  "		<img src='/assets/user/images/icon/btn_paging_prev.png' alt='전 페이지로 이동'>" +
				  "</a>";
	}
	if (totalIndexCount > 10) { // 전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
		postStr += "<a href='javascript:void(0);' class='stimg' title='다음 페이지로 이동' onclick='_movePageReception("+next+", "+ gfv_eventNameReception +")'>" +
				   "	<img src='/assets/user/images/icon/btn_paging_next.png' alt='다음 페이지로 이동'>" +
				   "</a>";
	    postStr += "<a href='javascript:void(0);' class='stimg' title='맨마지막 페이지로 이동' onclick='_movePageReception("+totalIndexCount+", "+ gfv_eventNameReception +")'>" +
				   "	<img src='/assets/user/images/icon/btn_paging_last.png' alt='맨마지막 페이지로 이동'>" +
				   "</a>";
	} else if (totalIndexCount <=10 && totalIndexCount > 1){ // 전체 인덱스가 10보다
		postStr += "<a href='javascript:void(0);' class='stimg' title='다음 페이지로 이동' onclick='_movePageReception("+next+", "+ gfv_eventNameReception +")'>" +
				   "	<img src='/assets/user/images/icon/btn_paging_next.png' alt='다음 페이지로 이동'>" +
				   "</a>";
	   postStr += "<a href='javascript:void(0);' class='stimg' title='맨마지막 페이지로 이동' onclick='_movePageReception("+totalIndexCount+", "+ gfv_eventNameReception +")'>" +
		   		  "		<img src='/assets/user/images/icon/btn_paging_last.png' alt='맨마지막 페이지로 이동'>" +
	   			  "</a>";
	}
	
	for (var i = first; i < (first+last); i++) {
		console.log("currentIndex::"+gfv_pageIndexReception);
		console.log("i::"+i);
		if (i != currentIndex) {
			str += "<a href='javascript:void(0);' onclick='_movePageReception("+i+", "+ gfv_eventNameReception +");'>"+i+"</a>";
		} else {
			
			str += "<strong>"+i+"</strong>";
		}
	}
	
	postStr += "</ul>";
	var tempStr = preStr + str + postStr;
//	console.log("tempStr = "+ tempStr);
	$("#"+divId).append(preStr + str + postStr);
}


function _movePageReception(value, eventName){
	$("#"+gfv_pageIndexReception).val(value);
	if(typeof(eventName) == "function"){
		eventName(value);
	}
}