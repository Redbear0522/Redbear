<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<h1>updatePro.jsp</h1><br>
<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="user.UserDAO" />
<%
	dao.updateUser(dto);
	
%>	<script >
	alert("회원정보가 변경되었습니다.");
	window.location="<%=request.getContextPath()%>/views/member/info.jsp";
	</script>

	

