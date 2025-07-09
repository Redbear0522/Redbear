<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h1></h1><br>
<%
	session.invalidate();// 삭제 전체 삭제
	response.sendRedirect("/Redbear/views/main.jsp");
%>