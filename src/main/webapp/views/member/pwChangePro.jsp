<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h1>pwChangePro.jsp</h1><br>
<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:useBean id="dao" class="user.UserDAO" />
<%
	
	String pw = request.getParameter("pw");
	String pw1 = request.getParameter("pw1");
	String id = (String)session.getAttribute("sid");	
	dto.setId(id);
	dto.setPw(pw);
	if(dao.checkid(dto)){
		dao.pwChange(id, pw1);
		%>
	<script >
	alert("비밀번호가 변경되었습니다.");
	window.location="<%=request.getContextPath()%>/views/member/info.jsp";
</script>

	<%}else{%>
		<script>
		alert("비밀번호를 확인해주세요");
		history.go(-1);
		</script>
	<%} %>