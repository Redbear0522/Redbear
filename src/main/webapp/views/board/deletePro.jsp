<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "board.PostDAO" %>
<%@ page import = "board.PostDTO" %>
<%@ page import = "java.sql.Timestamp" %>
<% request.setCharacterEncoding("UTF-8");%>

<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	String pw = request.getParameter("pw");
	
	PostDAO pd = PostDAO.getInstance();
	int check = pd.deletePost(num, pw);
	if(check == 1){%>
		<meta http-equiv = "Refresh" content="0;url=bord.jsp?pageNum=<%=pageNum%>">
	<%}else{%>
		<script>
        alert("비밀번호가 틀렸거나 게시물이 존재하지 않습니다.");
        history.back();
    </script>
	<%}

%>