<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "board.PostDAO" %>
<%@page import = "board.PostDTO" %>
<%@page import = "java.text.SimpleDateFormat" %>
<% request.setCharacterEncoding("UTF-8");%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title> 게시판</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">

<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

	PostDAO pdPro = PostDAO.getInstance();
	PostDTO post =  pdPro.getPost(num);

	int ref=post.getRef();
	int re_step=post.getRe_step();
	int re_level=post.getRe_level();
%>
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>


<form>
<table class="table table-bordered table-striped table-hover" style="margin: 0 auto; width: 70%;">
<tbody>
      <tr>
        <th scope="row" style="width:15%;">글번호</th>
        <td style="width:20%;"><%= post.getNum() %></td>
        <th scope="row" style="width:15%;">조회수</th>
        <td style="width:20%;"><%= post.getReadcnt() %></td>
      </tr>
<tr>
        <th scope="row">작성자</th>
        <td><%= post.getWriter() %></td>
        <th scope="row">작성일</th>
        <td><%= post.getRegdate() %></td>
      </tr>
 <tr>
        <th scope="row">제목</th>
        <td colspan="3"><strong><%= post.getTitle() %></strong></td>
</tr>

      <tr>
        <th scope="row" style="vertical-align: top;">내용</th>
        <td colspan="3" style="height: 30%; width: 60%; white-space: pre-wrap;"><%= post.getContent() %></td>

      </tr>
<%
    if (pageNum == null || pageNum.trim().equals("")) {
        pageNum = "1";
    }
%>
<tr height="30">      
      <td colspan="4" class="text-center">
          <button type="button" class="btn btn-primary me-2"
            onclick="location.href='update.jsp?num=<%= post.getNum() %>&pageNum=<%= pageNum %>'">글수정</button>
          <button type="button" class="btn btn-danger me-2"
            onclick="location.href='delete.jsp?num=<%= post.getNum() %>&pageNum=<%= pageNum %>'">글삭제</button>
          <button type="button" class="btn btn-success me-2"
            onclick="location.href='write.jsp?num=<%= num %>&ref=<%= ref %>&re_step=<%= re_step %>&re_level=<%= re_level %>'">답글쓰기</button>
          <button type="button" class="btn btn-secondary"
            onclick="location.href='bord.jsp?pageNum=<%= pageNum %>'">글목록</button>
    </td>
  </tr>
</table>


</form>

<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>


</body>



</html>
