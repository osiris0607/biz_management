<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="hasAnyRole('ROLE_MEMBER')">
    <script>
    	console.log("ROLE_MEMBER");
    	location.href = "/member/fwd/home/main";
    </script>
</sec:authorize>
<sec:authorize access="hasAnyRole('ROLE_ADMIN')">
	<script>
	console.log("ROLE_ADMIN");
    	location.href = "/admin/fwd/home/main";
    </script>
</sec:authorize>
<sec:authorize access="hasAnyRole('ROLE_EXPERT')">
	<script>
	console.log("ROLE_EXPERT");
    	location.href = "/member/fwd/home/main";
    </script>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
	console.log("isAuthenticated");
</sec:authorize>
<%-- <sec:authentication property="principal.username" var="user_id" /> --%>