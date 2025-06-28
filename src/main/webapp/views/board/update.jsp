<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ page import = "board.PostDTO" %>
<%@ page import = "board.PostDAO" %>    
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글 수정</title>
<%
  int num = Integer.parseInt(request.getParameter("num"));
  String pageNum = request.getParameter("pageNum");
  try{
      PostDAO pd = PostDAO.getInstance();
      PostDTO article = pd.getPost(num);

%>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>
<%
    // 직접 sid 변수 선언하지 않고 세션에서 꺼내서 체크
    if (session.getAttribute("sid") == null) {
%>
    <script>
        alert("로그인 후 이용 가능합니다.");
        history.back();
    </script>
<%
        return; // 더 이상 진행하지 않도록 처리
    }
%>
<form method="post" name="update" action="updatePro.jsp?pageNum=<%=pageNum%>" onsubmit="return writeSave()">
<input type="hidden" name="num" value="<%=num%>">
<table class="board-table" style="margin: 0 auto; width: 70%;">
    <tr>
    <td  width="70"     align="center" >제 목</td>
    <td align="left" width="330">
        <input type="text" name="title" value="<%=article.getTitle()%>">
  </tr>
  <tr>
    <td  width="70"     align="center" >내 용</td>
    <td align="left" width="330">
     <textarea name="content" rows="10" cols="50"><%=article.getContent()%></textarea>
  </tr>
  <tr>
    <td  width="70"     align="center" >비밀번호</td>
    <td align="left" width="330" >
      <input type="password" name="pw">
     
	 </td>
  </tr>
  <tr>      
   <td colspan=2    align="center"> 
     <input type="submit" value="글수정" >  
     <input type="reset" value="다시 작성">
     <input type="button" value="글목록" 
       onclick="document.location.href='bord.jsp?pageNum=<%=pageNum%>'">
   </td>
 </tr>
 </table>
</form>
<%
}catch(Exception e){}%>      
<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

