
Map = function(){
	this.map = new Object();
};   

Map.prototype = {   
	put : function(key, value) {   
		this.map[key] = value;
	},   
	get : function(key) {   
		return this.map[key];
	},
	containsKey : function(key) {    
		return key in this.map;
	},
	containsValue : function(value) {    
		for(var prop in this.map){
			if(this.map[prop] == value) return true;
		}
		return false;
	},
	isEmpty : function(key) {    
		return (this.size() == 0);
	},
	clear : function() {   
		for(var prop in this.map){
			delete this.map[prop];
		}
	},
	remove : function(key) {    
		delete this.map[key];
	},
	keys : function() {   
		var keys = new Array();   
		for(var prop in this.map){   
			keys.push(prop);
		}   
		return keys;
	},
	values : function() {   
		var values = new Array();   
		for(var prop in this.map){   
			values.push(this.map[prop]);
		}   
		return values;
	},
	size : function() {
		var count = 0;
		for (var prop in this.map) {
			count++;
		}
		return count;
	}
};

readImage = function(file, element) {
    var reader = new FileReader();
    var image  = new Image();

    reader.readAsDataURL(file);
    reader.onload = function (_file) {
        image.src = _file.target.result;
        image.onload = function() {
            $(element).data('height', this.height);
            $(element).data('width', this.width);
            $(element).data('size', ~~((file.size / 1024) / 1024));
        }
    }
}

String.prototype.byteLength = function() {
    var l= 0;	     
    for (var idx = 0; idx < this.length; idx++) {
        var c = escape(this.charAt(idx));	         
        if ( c.length==1 ) l ++;
        else if ( c.indexOf("%u") !=-1 ) l += 2;
        else if ( c.indexOf("%")  !=-1 ) l += c.length / 3;
    }	     
    return l;
};

String.prototype.getStringFromByteLength = function( byteLength ) {
    var contents = this;
    var str_character;
    var int_char_count;
    var int_contents_length;	     
    var returnValue = "";
     
    int_char_count = 0;
    int_contents_length = contents.length;
     
    for (k = 0; k < int_contents_length; k++) {
        str_character = contents.charAt(k);
        if (escape(str_character).length > 4) {
            int_char_count += 2;
    	} else {
            int_char_count++;
    	}
        if (int_char_count > byteLength ) {
        	break;
        }
        returnValue += str_character;
    }
    return returnValue;
}

String.prototype.format = function(args) {
	var newStr = this;
	for ( var key in args) {
		newStr = newStr.replace('{' + key + '}', args[key]);
	}
	return newStr;
}

String.prototype.formatAll = function(args) {
	var newStr = this;
	for ( var key in args) {
		newStr = newStr.split("{" + key + "}").join(args[key]);
	}
	return newStr;
}

String.prototype.getLpad = function(spad, len) {
	var str = this;
	while (str.length < len)
		str = spad + str;
	return str;
}

String.prototype.getRpad = function(spad, len) {
	var str = this;
	while (str.length < len)
		str += spad;
	return str;
}

String.prototype.getDateFormat = function() {
	var Week = [ '일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일' ];
	var year = this.substring(0, 4);
	var month = this.substring(4, 6);
	var day = this.substring(6, 8);
	var date = new Date(year, parseInt(month) - 1, day);
	return {
		date : "{YY}.{MM}.{DD}".format({
			YY : year.substring(2, 4), MM : month, DD : day
		}),
		fullDate : "{YYYY}.{MM}.{DD}".format({
			YYYY : year.substring(0, 4), MM : month, DD : day
		}),
		week : Week[date.getDay()],
		month : month + "월",
		day : day,
		orginDate : date
	}
}

String.prototype.isBlank = function() {
	var str = this.trim();
	for (var i = 0; i < str.length; i++) {
		if ((str.charAt(i) != "\t") && (str.charAt(i) != "\n") && (str.charAt(i) != "\r")) {
			return false;
		}
	}
	return true;
}

String.prototype.isEmail = function() {
	return (/\w+([-+.]\w+)*@\w+([-.]\w+)*\.[a-zA-Z]{2,4}$/).test(this.trim());
}

String.prototype.isDomain = function() {
	return (/\w+([-.]\w+)*\.[a-zA-Z]{2,4}$/).test(this.trim());
}

String.prototype.isBirth = function() {
	return (/(19|20)[0-9]{2}[01]{1}[0-9]{1}[0123]{1}[0-9]{1}$/).test(this.trim());
}

String.prototype.isIncKor = function() {
	return (/[ㄱ-ㅎ|ㅏ-ㅣ|가-하]/).test(this) ? true : false;
}

String.prototype.isKor = function() {
	return (/^[가-힣]+$/).test(this) ? true : false;
}

String.prototype.isEngkor = function() {
	return (/^[가-힣]+$/).test(this) ? true : (/^[a-zA-Z]+$/).test(this) ? true : false;
}

String.prototype.num = function() {
	return (this.trim().replace(/[^0-9]/g, ""));
}

String.prototype.isNum = function() {
	return (/^[0-9]+$/).test(this) ? true : false;
}

String.prototype.isEng = function() {
	return (/^[a-zA-Z]+$/).test(this) ? true : false;
}

String.prototype.isEngNum = function() {
	return (/^[0-9a-zA-Z]+$/).test(this) ? true : false;
}

String.prototype.money = function() {
	var num = this.trim();
	while ((/(-?[0-9]+)([0-9]{3})/).test(num)) {
		num = num.replace((/(-?[0-9]+)([0-9]{3})/), "$1,$2");
	}
	return num;
}

String.prototype.trim = function() {
	return this.replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1");
}

String.prototype.ltrim = function() {
	return this.replace(/^[\s]+/gm, '');
}

String.prototype.rtrim = function() {
	return this.replace(/^[\s]+$/gm, '');
}

String.prototype.int = function() {
	return (!isNaN(this)) ? parseInt(this) : null;
}

String.prototype.decodeEntity = function() {
	return this.replace(/&amp;/gi, "&").replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
};

String.prototype.encodeCode = function(str) {
	return str.replace(/\'/g, "&#39;").replace(/\"/g, "&#34;")
	.replace(/\(/g, "&#40;").replace(/\)/g, "&#41;")				
	.replace(/</g, "&#60;").replace(/>/g, "&#62;")
	.replace(/(?:\r\n|\r|\n)/g, '<br />');
};

String.prototype.decodeCode = function() {
	return this.replace(/&#39;/g, "'").replace(/&#34;/g, "'")
				.replace(/&#40;/g, "(").replace(/&#41;/g, ")")				
				.replace(/&#60;/g, "<").replace(/&#62;/g, ">")
				.replace(/&#x0D;/gi, "\r");
};

String.prototype.decodeCodeStr = function(str) {
	return str.replace(/&#39;/g, "'").replace(/&#34;/g, "'")
				.replace(/&#40;/g, "(").replace(/&#41;/g, ")")				
				.replace(/&#60;/g, "<").replace(/&#62;/g, ">")
				.replace(/&#x0D;/gi, "\r");
};

String.prototype.isLength = function() {
    var min = arguments[0];
    var max = arguments[1] ? arguments[1] : null;
    var success = true;
    if (this.length < min) {
        success = false;
    }
    if (max && this.length > max) {
        success = false;
    }
    return success;
}

String.prototype.parseDate = function() {
	var year 	= this.substring(0, 4);
	var month 	= this.substring(4, 6);
	var day 	= this.substring(6, 8);
	var hour 	= this.substring(8, 10);
	var minute 	= this.substring(10, 12);
	var second 	= this.substring(12, 14);
	return new Date(year, month-1, day, hour, minute, second);
}

String.prototype.ext = function() {
    return (this.indexOf(".") < 0) ? "" : this.substring(this.lastIndexOf(".") + 1, this.length);   
}

String.prototype.stripHtml = function() {
	return $('<div/>').html(this).text();
};

Date.prototype.yyyymmdd = function() {
	var yyyy = this.getFullYear().toString();
	var mm = (this.getMonth() + 1).toString();
	var dd = this.getDate().toString();
	return yyyy + (mm[1] ? mm : "0" + mm[0]) + (dd[1] ? dd : "0" + dd[0]);
};

Date.prototype.yyyymmddDash = function() {
	var yyyy = this.getFullYear().toString();
	var mm = (this.getMonth() + 1).toString();
	var dd = this.getDate().toString();
	return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
};

Date.prototype.yyyymmddDot = function() {
	var yyyy = this.getFullYear().toString();
	var mm = (this.getMonth() + 1).toString();
	var dd = this.getDate().toString();
	return yyyy + '.' + (mm[1] ? mm : "0" + mm[0]) + '.' + (dd[1] ? dd : "0" + dd[0]);
};

Date.prototype.beforeDate = function(value) {
	switch(value) {
		case '1d' : return this;
		case '1w' : this.setDate(this.getDate() -7); break;
		case '1m' : this.setMonth(this.getMonth() -1); break;
		case '3m' : this.setMonth(this.getMonth() -3); break;
		case '6m' : this.setMonth(this.getMonth() -6); break;
		case '1y' : this.setMonth(this.getMonth() -12); break;
	}
	return this;
}

Date.prototype.afterDate = function(value) {
	switch(value) {
		case '1d' : return this;
		case '1w' : this.setDate(this.getDate() +7); break;
		case '1m' : this.setMonth(this.getMonth() +1); break;
		case '3m' : this.setMonth(this.getMonth() +3); break;
		case '6m' : this.setMonth(this.getMonth() +6); break;
		case '1y' : this.setMonth(this.getMonth() +12); break;
	}
	return this;
}

Date.prototype.format = function(f) {
    if (!this.valueOf()) return " "; 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|SSS|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy"	: return d.getFullYear();
            case "yy"	: return (d.getFullYear() % 1000).zf(2);
            case "MM"	: return (d.getMonth() + 1).zf(2);
            case "dd"	: return d.getDate().zf(2);
            case "E"	: return weekName[d.getDay()];
            case "HH"	: return d.getHours().zf(2);
            case "hh"	: return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm"	: return d.getMinutes().zf(2);
            case "ss"	: return d.getSeconds().zf(2);
            case "a/p"	: return d.getHours() < 12 ? "오전" : "오후";
            case "SSS"	: return d.getMilliseconds().zf(2)
            default: return $1;
        }
    });
};
 
Array.prototype.remove = function(el) {
	return this.splice(this.indexOf(el), 1);
};

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

/*$.is_mobile = function() {
	if (_agent.match(/android/) || _agent.match(/(iphone|ipod|ipad)/)) {
		return typeof arguments[0] == 'undefined' ? true : (function(a, cs) {
			return a.match((cs == 'android' ? /android/ : /(iphone|ipod|ipad)/)) ? true : false;
		})(_agent, arguments[0]);
	}
	return false;
};*/


/**
 * 비밀번호 검증 var password = ""; var passed = validatePassword(password, {
 * length: [8, Infinity], - 비밀번호 최소, 최대 lower: 1, - 최소 n 개의 영문 소문자 (a-z) upper:
 * 1, - 최소 n 개의 영문 대문자 (A-Z) numeric: 1, - 최소 n 개의 숫자 (0-9). special: 1, - 최소 n
 * 개의 특수 문자 (a-z, A-Z, 0-9 이외의 문자). badWords: ["111", "steven",
 * "levithan"], - 특정 단어 (대소 소문자를 구별) 금지 badSequenceLength: 4 - 최소 n 개의 연속된 문자
 * });
 * 
 * @param pw
 * @param options
 * @returns
 */
function validatePassword (pw, param, options) {
	var id = $(param).val();
	var o = {
		lower:    0,
		upper:    0,
		alpha:    0,
		numeric:  0,
		special:  0,
		length:   [0, Infinity],
		idCheckLength : 0,
		custom:   [ /* regexes and/or functions */ ],
		badWords: [],
		badSequenceLength: 0,
		noQwertySequences: false,
		noSequential:      true
	};
	for (var property in options) {
		o[property] = options[property];
	}	
	var	re = {
		lower: /[a-z]/g, 
		upper: /[A-Z]/g, 
		alpha: /[A-Z]/gi, 
		numeric: /[0-9]/g, 
		special: /[!, ", ', (, ), +, -, /, :, ;, <, >, = , `, {, }, |, @@, #, $, %, ^, &, *, ?, _, ~]/gi
	}, rule, i, count = 0;
	
	var engLen = pw.match(re.alpha) 	!= null ? pw.match(re.alpha).length 	: 0; // 영문자
																						// 갯수
	var numLen = pw.match(re.numeric) 	!= null ? pw.match(re.numeric).length 	: 0; // 숫자
																						// 갯수
	var speLen = pw.match(re.special)	!= null ? pw.match(re.special).length	: 0; // 특수문자
																						// 갯수
	count = (engLen > 0) ? count + 1 : count;
	count = (numLen > 0) ? count + 1 : count;
	count = (speLen > 0) ? count + 1 : count;
	for (rule in re) {
		if (((pw.match(re[rule]) || []).length < o[rule]) || pw.length < o.length[0]) {
			if (count == 1) {
				if (pw.length > o.length[1]) return $.validator.format("최소 {0}자리 이상 입력하세요.", o.length[1]);
				else return '영문, 숫자, 특수문자중 2종류 이상 최소 10자리, 3종류 이상 8자리 이상 입력하세요.'
			}
			if (count == 2) {
				if (!(pw.length > 9 && pw.length < o.length[1])) return '영문, 숫자, 특수문자중 2종류 이상 최소 10자리 이상 입력하세요. ';
				else if (pw.length > o.length[1]) return $.validator.format("최소 {0}자리 이하 입력하세요.", o.length[1]);
		    }
		    if (count > 2) {
		        if (!(pw.length > 7 && pw.length < o.length[1])) return '영문, 숫자, 특수문자중 3종류 이상 최소 8자리 이상 입력하세요. ';
		        else if (pw.length > o.length[1]) return $.validator.format("최소 {0}자리 이하 입력하세요.", o.length[1]);
		    }
		}	
	}
	for (i = 0; i < o.badWords.length; i++) {
		if (pw.toLowerCase().indexOf(o.badWords[i].toLowerCase()) > -1)
			return $.validator.format("{0} 과(와) 같은 단어를 사용할 수 없습니다.", o.badWords[i]);
	}
	if (o.noSequential && /([\S\s])\1\1\1/.test(pw)) {			
		return $.validator.format('동일한 숫자또는 문자열이 {0}자리 이상 들어갈 수 없습니다.', o.badSequenceLength);
	}	
	if (o.idCheckLength) {
		var str = "";
		for (var i = 0; i < pw.length; i++) {
			var end = pw.length -((pw.length) % 3);
			if (pw.length - i > 2) {
				str = pw.substr(i, 3);
				if (id.indexOf(str) != -1) {
					return $.validator.format('사용자 ID의 문자열을 {0}자리 이상 동일하게 사용 할 수 없습니다.', o.idCheckLength);
				}
			}
		}
	}	
	if (o.badSequenceLength) {
		var	lower   = "abcdefghijklmnopqrstuvwxyz",
			upper   = lower.toUpperCase(),
			numbers = "0123456789",
			qwerty  = "qwertyuiopasdfghjklzxcvbnm",
			start   = o.badSequenceLength - 1,
			seq     = "_" + pw.slice(0, start);		
		for (i = start; i < pw.length; i++) {
			seq = seq.slice(1) + pw.charAt(i);
			if (lower.indexOf(seq)   > -1 || upper.indexOf(seq)   > -1 || numbers.indexOf(seq) > -1 || (o.noQwertySequences && qwerty.indexOf(seq) > -1) ) {
				return $.validator.format('연속된 숫자 또는 문자열이 {0}자리 이상 사용 할 수 없습니다.', o.badSequenceLength);
			}
		}
	}
	for (i = 0; i < o.custom.length; i++) {
		rule = o.custom[i];
		if (rule instanceof RegExp) {
			if (!rule.test(pw)) return false;
		} else if (rule instanceof Function) {
			if (!rule(pw)) return false;
		}
	}
	return 'success';
}

function gfn_isNull(str) {
	if (str == null) return true;
	if (str == "NaN") return true;
	if (new String(str).valueOf() == "undefined") return true;    
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;    
    if (chkStr.toString().length == 0 ) return true;   
    return false; 
}

var gfv_ajaxCallback = "";
var pageIndex = 1;
function ComAjax(opt_formId) {
	this.url = "";
	this.formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
	this.param = "";
	if (this.formId == "commonForm") {
		var frm = $("#commonForm");
		if (frm.length > 0) {
			frm.remove();
		}
		var str = "<form id='commonForm' name='commonForm'></form>";
		$('body').append(str);
	}
	this.setUrl = function setUrl(url) {
		this.url = url;
	};
	this.setCallback = function setCallback(callBack) {
		fv_ajaxCallback = callBack;
	};
	this.addParam = function addParam(key, value) {
		this.param = this.param + "&" + key + "=" + value;
	};
	this.ajax = function ajax() {
		if (this.formId != "commonForm") {
			this.param += "&" + $("#" + this.formId).serialize();
		}
		$.ajax({
			url : this.url,
			type : "POST",
			data : this.param,
			async : false,
			success : function(data, status) {
				if (typeof (fv_ajaxCallback) == "function") {
					fv_ajaxCallback(data);
				}
			}, error : function(err) {
				alert("error!!" + err);
			}
		});
	};
}

function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();

	if (n.length < digits) {
		for (var i = 0; i < digits - n.length; i++)
			zero += '0';
		}
  	return zero + n;
}

function unescapeHtml(str) {
	if (str == null) {
		return "";
	}
	 
	 while ( str.match(/&amp;/g) || str.match(/&lt;/g) || str.match(/&gt;/g) || str.match(/&middot;/g) 
			 || str.match(/&quot;/g) || str.match(/&#039;/g) || str.match(/&#39;/g)) {
		 str = str.replace(/&amp;/g, '&')
  		  .replace(/&lt;/g, '<')
  		  .replace(/&gt;/g, '>')
  		  .replace(/&middot;/g, '·')
  		  .replace(/&quot;/g, '"')
  		  .replace(/&#039;/g, "'")
  		  .replace(/&#39;/g, "'");
	 }
	 
	 return str;
}

//여러 개의 column를 가지고 있는 array의 각가의 column Sort
function arraySortWithColumn(array, column, desc) {
	var tempArray = array;
	
	var nullPosition = desc ? 1 : -1;
	
	// ASC / DESC 처리
	if (desc) {
		tempArray.sort(function(a, b) {
			 if (a == null) return nullPosition;
			 if (b == null) return -nullPosition;
			const upperCaseA = a[column];
			const upperCaseB = b[column];
  
			if(upperCaseA < upperCaseB) return 1;
			if(upperCaseA > upperCaseB) return -1;
			if(upperCaseA === upperCaseB) return 0;
		});	
	}
	else {
		tempArray.sort(function(a, b) {
			 if (a == null) return nullPosition;
			 if (b == null) return -nullPosition;
			const upperCaseA = a[column];
			const upperCaseB = b[column];
		  
			if(upperCaseA > upperCaseB) return 1;
			if(upperCaseA < upperCaseB) return -1;
			if(upperCaseA === upperCaseB) return 0;		
			

		});
	}
	 return tempArray;
}


function phoneFomatter(num,type){
    var formatNum = '';
    if(num.length==11){
        if(type==0){
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-****-$3');
        }else{
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        }
    }else if(num.length==8){
        formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
    }else{
        if(num.indexOf('02')==0){
            if(type==0){
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-****-$3');
            }else{
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
            }
        }else{
            if(type==0){
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-***-$3');
            }else{
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
            }
        }
    }
    return formatNum;
}

//숫자만 입력
function numberOnlyMaxLength(e){
    if(e.value.length > e.maxLength){
        e.value = e.value.slice(0, e.maxLength);
    }
    e.value = e.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
}

//숫자만 입력
function numberOnlyInput(e){
    e.value = e.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
}


function numberOnlyPhoneAutoHyphen(e){
//  e.value = e.value.replace(/[^0-9.]/g, '').replace(/([0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3").replace(/^-/, "");
  e.value = e.value.replace(/[^0-9.]/g, '').replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2}|[0-9]{3})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-");
}

function makeMoneyWithComma(e) {
	e.value = e.value.replace(/[^0-9]/g,'');   // 입력값이 숫자가 아니면 공백
	e.value = e.value.replace(/,/g,'');          // ,값 공백처리
	e.value = e.value.replace(/\B(?=(\d{3})+(?!\d))/g, ","); // 정규식을 이용해서 3자리 마다 , 추가 	
}


function makeMoneyWithCommaString(input) {
	input = input.replace(/[^0-9]/g,'');   // 입력값이 숫자가 아니면 공백
	input = input.replace(/,/g,'');          // ,값 공백처리
	input = input.replace(/\B(?=(\d{3})+(?!\d))/g, ","); // 정규식을 이용해서 3자리 마다 , 추가 	
}

//주소 검색
document.write("<script src='https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js'></script>");
function execPostCode(addressTag, zipTag) {
	new daum.Postcode({
        oncomplete: function(data) {
           // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

           // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
           // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
           var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
           var extraRoadAddr = ''; // 도로명 조합형 주소 변수

           // 법정동명이 있을 경우 추가한다. (법정리는 제외)
           // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
           if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
               extraRoadAddr += data.bname;
           }
           // 건물명이 있고, 공동주택일 경우 추가한다.
           if(data.buildingName !== '' && data.apartment === 'Y'){
              extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
           }
           // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
           if(extraRoadAddr !== ''){
               extraRoadAddr = ' (' + extraRoadAddr + ')';
           }
           // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
           if(fullRoadAddr !== ''){
               fullRoadAddr += extraRoadAddr;
           }

           // 우편번호와 주소 정보를 해당 필드에 넣는다.
           $("#" + zipTag).val(data.zonecode);
           $("#" + addressTag).val(fullRoadAddr);
           
           /* document.getElementById('signUpUserPostNo').value = data.zonecode; //5자리 새우편번호 사용
           document.getElementById('signUpUserCompanyAddress').value = fullRoadAddr;
           document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
       }
    }).open();
}
