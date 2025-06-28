<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.PostDAO, board.PostDTO, java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");
    int pageSize = 10;
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null) pageNum = "1";

    int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;

    PostDAO dao = PostDAO.getInstance();
    int count = dao.getArticleCount();
    List<PostDTO> list = (count > 0) ? dao.getPostList(startRow, endRow) : null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시판 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>

<div class="container mt-5">
  <h2 class="text-center mb-4">게시판 목록</h2>

  <div class="text-end mb-3">
    <button type="button" class="btn btn-primary btn-sm" onclick="location.href='write.jsp'">글쓰기</button>
  </div>

  <table class="table table-hover">
    <thead>
      <tr>
        <th scope="col">번호</th>
        <th scope="col">제목</th>
        <th scope="col">작성자</th>
        <th scope="col">작성일</th>
        <th scope="col">조회수</th>
      </tr>
    </thead>
    <tbody>
      <% if (list != null && !list.isEmpty()) {
           for (PostDTO dto : list) { %>
      <tr>
        <td><%= dto.getNum() %></td>
        <td>
          <% for (int i = 0; i < dto.getRe_level(); i++) { %>
            <span class="ms-<%= i * 2 %>"></span>
          <% } %>
          <% if (dto.getRe_level() > 0) { %>
            <span class="text-muted">RE:</span>
          <% } %>
          <a href="view.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a>
        </td>
        <td><%= dto.getWriter() %></td>
        <td><%= dto.getRegdate() %></td>
        <td><%= dto.getReadcnt() %></td>
      </tr>
      <%   }
         } else { %>
      <tr>
        <td colspan="5" class="text-center">등록된 글이 없습니다.</td>
      </tr>
      <% } %>
    </tbody>
  </table>

  <nav aria-label="Page navigation">
    <ul class="pagination justify-content-center">
      <% if (currentPage > 1) { %>
      <li class="page-item">
        <a class="page-link" href="board.jsp?pageNum=<%= currentPage - 1 %>">이전</a>
      </li>
      <% } else { %>
      <li class="page-item disabled"><span class="page-link">이전</span></li>
      <% } %>

      <li class="page-item active"><span class="page-link"><%= currentPage %></span></li>

      <% if (count > currentPage * pageSize) { %>
      <li class="page-item">
        <a class="page-link" href="board.jsp?pageNum=<%= currentPage + 1 %>">다음</a>
      </li>
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
