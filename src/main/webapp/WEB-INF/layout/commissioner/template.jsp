<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="application" />
<%
	pageContext.setAttribute("cr", "\r");
	pageContext.setAttribute("lf", "\n");
	pageContext.setAttribute("crlf", "\r\n");
%>
<!DOCTYPE html>
<html lang="ko">

<script src="/assets/user/js/lib/jquery-1.11.0.min.js"></script>
<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
<script src="/assets/common/js/common_anchordata.js"></script>
<script src="/assets/common/js/paging.js"></script>


<tiles:insertAttribute name="header" />
<body>

	<div id="wrap" class="main">
		<!-- skip_nav --> 
		<div id="skip_nav">  
			<a href="#nav">메인메뉴 바로가기</a>
			<a href="#content">본문내용 바로가기</a>
		</div>
		<!-- //skip -->
		
		<tiles:insertAttribute name="headerSide" /> 
		<tiles:insertAttribute name="body" />
		<tiles:insertAttribute name="footer" />
	</div>
	
	<script src="/assets/user/js/script.js"></script>
</body>

</html>
