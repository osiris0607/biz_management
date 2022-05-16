<!DOCTYPE html>
<html lang="ko">
	<head>		
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="ie=edge" />
		<meta name="description" content="신기술접수소 사업평가관리시스템" />
		<meta name="keywords" content="신기술 접수소, 서울 신기술 사업평가관리" />
		<meta property="og:type" content="website" />
		<meta property="og:title" content="신기술접수소 사업평가관리시스템 관리자사이트" />
		<meta property="og:url" content="http://www.seoul-tech.com/admin" />
		<meta property="og:image" content="/assets/admin/image/barun-translate.png" />
		<meta property="og:description" content="신기술접수소 사업평가관리시스템" />
		<title>신기술접수소 사업평가관리시스템</title>		
		<link rel="stylesheet" href="/assets/admin/css/style.css" />
		<link rel="stylesheet" href="/assets/admin/css/lib/solid.min.css" />
		<script src="/assets/admin/js/lib/jquery-1.11.0.min.js"></script>
		<script src="/assets/admin/js/lib/all.min.js"></script>		
		<script src="/assets/admin/js/lib/jquery.nice-select.min.js"></script>
	</head>
	<body>		
		<div class="login_wrapper">	
		    <div class="login_wrapper_box">
                <div class="login_contents_box">
                    <header class="login_header">
                       <h1 class="login_logo"><img src="/assets/admin/images/admin_logo.png" alt="신기술접수소"></h1> 
                       <span class="login_logo_txt"><span class="font_blue">사업평가&middot;관리시스템</span> 관리자 사이트입니다.</span>                 
                    </header>
                    <div class="login_container">
                        <h2><i class="fa fa-user text-grey-m2 ml-n4 mr10"></i>관리자 로그인</h2>
                        
                        <form action="/admin/fwd/login/adminLogin" method="POST">
	                        <ul class="login_form">
	                            <li><label for="login_id"></label><input type="text" name="member_id" id="member_id" class="login_form_input form-control" placeholder="아이디를 입력해주세요 (아이디는 영문+숫자)" /></li>
	                            <li><label for="login_pw"></label><input type="password" name="pwd" id="pwd" class="login_form_input form-control" placeholder="비밀번호를 입력해주세요 (6자 이상 ~ 20자 이하)"  maxlength="20" /></li>
	                            <li class="mt30"><input type="checkbox" id="id_save" /><label for="id_save">아이디 저장</label></li>
	                        </ul>
	                        <button type="submit" class="login_btn blue_btn">로그인</button>
                        </form>
                        

                    </div>
                </div>
		    </div>	           
         </div>
	</body>
</html>