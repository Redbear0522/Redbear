<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="user.UserDAO" />

<%
	String id = (String)session.getAttribute("sid");
	if (id == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	dto.setId(id);

	if (dao.checkid(dto)) {
		dao.deleteMember(dto);
		session.invalidate();
%>
		<script>
			alert("탈퇴가 완료되었습니다.");
			location.href = "<%=request.getContextPath()%>/views/main.jsp";
		</script>
<%
	} else {
%>
		<script>
			alert("비밀번호를 확인하세요");
			history.back();
		</script>
<%
	}
%>
