<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, board.GalleryDTO, board.GalleryDAO"%>
<%
    request.setCharacterEncoding("UTF-8");
    int pageSize = 10;
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null) pageNum = "1";
    int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow   = currentPage * pageSize;

    GalleryDAO dao = GalleryDAO.getInstance();
    int count = dao.getArticleCount();
    List<GalleryDTO> galleryList = (count > 0) ? dao.getGalleryList(startRow, endRow) : null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>갤러리 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>
<div class="container mt-5">
  <h2 class="text-center mb-4">갤러리 목록</h2>
  <div class="text-end mb-3">
    <button type="button" class="btn btn-primary btn-sm" onclick="location.href='write.jsp'">글쓰기</button>
  </div>
  <table class="table table-hover">
    <thead>
      <tr>
        <th style="width:5%;" >번호</th>
        <th style="width:10%;">사진</th>
        <th style="width:60%;">제목</th>
        <th style="width:10%;">작성자</th>
        <th style="width:10%;">작성일</th>
        <th style="width:5%;">조회수</th>
      </tr>
    </thead>
    <tbody>
      
<% if (galleryList != null && !galleryList.isEmpty()) {
       for (GalleryDTO g : galleryList) { %>
  <tr>
    <td><%= g.getNum() %></td>
    <td>
      <a href="view.jsp?num=<%=g.getNum()%>">
        <img src="<%= g.getImage() %>" 
             class="img-thumbnail" 
             style="width:120px;height:90px;object-fit:cover;" 
             ">
      </a>
    </td>
    <td><a href="view.jsp?num=<%= g.getNum() %>"><%= g.getTitle() %></a></td>
    <td><%= g.getWriter() %></td>
    <td><%= g.getRegdate() %></td>
    <td><%= g.getReadcnt() %></td>
  </tr>
<%   }
     } else { %>
  <tr>
    <td colspan="6" class="text-center">등록된 글이 없습니다.</td>
  </tr>
<% } %>
    </tbody>
  </table>
  <nav>
    <ul class="pagination justify-content-center">
      <% if (currentPage > 1) { %>
      <li class="page-item"><a class="page-link" href="gallery.jsp?pageNum=<%=currentPage-1%>">이전</a></li>
      <% } else { %>
      <li class="page-item disabled"><span class="page-link">이전</span></li>
      <% } %>
      <li class="page-item active"><span class="page-link"><%=currentPage%></span></li>
      <% if (count > currentPage * pageSize) { %>
      <li class="page-item"><a class="page-link" href="gallery.jsp?pageNum=<%=currentPage+1%>">다음</a></li>
      <% } else { %>
      <li class="page-item disabled"><span class="page-link">다음</span></li>
      <% } %>
    </ul>
  </nav>
</div>
<%@ include file="/resources/footer/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>