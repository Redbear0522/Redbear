<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%
  int num = Integer.parseInt(request.getParameter("num"));
  String pageNum = request.getParameter("pageNum");
%>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글 삭제</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
	
<script language="JavaScript">      
  function deleteSave(){	
	if(document.delForm.passwd.value==''){
	alert("비밀번호를 입력하세요.");
	document.delForm.passwd.focus();
	return false; }
}   
</script>
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
<body bgcolor="#a3d9a5">
<center><b>글삭제</b>
<br>
<form method="POST" name="delete"  action="deletePro.jsp?pageNum=<%=pageNum%>" 
   onsubmit="return deleteSave()"> 
 <table class="board-table" style="margin: 0 auto; width: 70%;">
  <tr height="30">
     <td align=center   >
       <b>비밀번호를 입력해주세요</b></td>
  </tr>
  <tr height="30">
     <td align=center >비밀번호   
       <input type="password" name="pw" size="8" maxlength="12">
	   <input type="hidden" name="num" value="<%=num%>"></td>
 </tr>
 <tr height="30">
    <td align=center  >
      <input type="submit" value="글삭제" >
      <input type="button" value="글목록"
       onclick="document.location.href='bord.jsp?pageNum=<%=pageNum%>'">     
   </td>
 </tr>  
</table> 
</form>
</body>

<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

