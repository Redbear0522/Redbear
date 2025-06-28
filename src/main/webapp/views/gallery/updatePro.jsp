<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ page import = "board.GalleryDTO" %>
<%@ page import = "board.GalleryDAO" %>
<%@ page import = "java.sql.Timestamp" %>

<jsp:useBean id="article" scope="page" class="board.GalleryDTO">
<jsp:setProperty name="article" property="*"/>
</jsp:useBean>

<%
	String pageNum = request.getParameter("pageNum");
	GalleryDAO pd = GalleryDAO.getInstance();
	int check = pd.updateGallery(article);
	
	if(check ==1){%>
		<meta http-equiv="Refresh" content="0;url=gallery.jsp?pageNum=<%=pageNum%>">
	<%}else{%>
	<script >
		alert("비밀번호 확인하세요");
		history.go(-1);
	</script>
	<%}%>