<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "board.GalleryDAO" %>
<%@ page import = "board.GalleryDTO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.List" %>

<html>
<head>
<meta charset="UTF-8">
    <title>갤러리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

	GalleryDAO dbPro = GalleryDAO.getInstance();
	GalleryDTO article =  dbPro.getGallery(num);
	List<GalleryDTO>  fileList = null;
	int fileCount = dbPro.getGalleryCount(num);
	if(fileCount >0){
		fileList = dbPro.getGalleryFile(num);
	}
	
	int ref=article.getRef();
	int re_step=article.getRe_step();
	int re_level=article.getRe_level();
%>
<body>
<%@ include file="/resources/header/header.jsp" %>
<table width="80%" border="1" cellspacing="0" cellpadding="0" align="center">
<tr height="30">
    <td align="center" width="125"   >글번호</td>
    <td align="center" width="125" align="center">
	     <%=article.getNum()%></td>
    <td align="center" width="125"   >조회수</td>
    <td align="center" width="125" align="center">
	     <%=article.getReadcnt()%></td>
  </tr>
  <tr height="30">
    <td align="center" width="125"   >작성자</td>
    <td align="center" width="125" align="center">
	     <%=article.getWriter()%></td>
    <td align="center" width="125"    >작성일</td>
    <td align="center" width="125" align="center">
	     <%= sdf.format(article.getRegdate())%></td>
  </tr>
  <tr height="30">
    <td align="center" width="125"   >글제목</td>
    <td align="center" width="375" align="center" colspan="3">
	     <%=article.getTitle()%></td>
  </tr>
  <tr>
    <td align="center" width="125"   >글내용</td>
    <td align="left" width="375" colspan="3">
    	<div>
    	<%if(fileList!= null){
    		for(GalleryDTO fileDTO : fileList){%>
    			<img width="100%" src="/jsp/resources/imageboard/<%=fileDTO.getFilename() %>"/>
    			</div><br>
    		<%}
    	}%>
    	<pre><%=article.getContent()%></pre>
    	
    </td>
  </tr>
  <tr height="30">      
    <td colspan="4"    align="right" > 
	  <input type="button" value="수정" 
       onclick="document.location.href='<%=request.getContextPath() %>/updateForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">
	   &nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" value="삭제"
       onclick="document.location.href='<%=request.getContextPath() %>/deleteForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">
	   &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="button" value="답글쓰기" 
       onclick="document.location.href='<%=request.getContextPath() %>/writeForm.jsp?num=<%=num%>&ref=<%=ref%>&re_step=<%=re_step%>&re_level=<%=re_level%>'">
	   &nbsp;&nbsp;&nbsp;&nbsp;
       <input type="button" value="글목록" 
       onclick="document.location.href='<%=request.getContextPath() %>/list.jsp?pageNum=<%=pageNum%>'">
    </td>
  </tr>
</table>   
</body>
</html>      

