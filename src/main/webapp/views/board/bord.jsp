<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="board.PostDAO, board.PostDTO, java.util.List, java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");
    int pageSize = 10;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    String pageNum = request.getParameter("pageNum");
    if (pageNum == null) pageNum = "1";

    int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;
    int count = 0;
    int number = 0;

    List<PostDTO> list = null;
    PostDAO dao = PostDAO.getInstance();
    
    count = dao.getArticleCount();
    if (count > 0) {
        list = dao.getPostList(startRow, endRow);
    }
    number = count - (currentPage - 1) * pageSize;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>

<center><B><h2 class="text-center">게시판 목록 (전체글: <%= count %>)</h2></B>


<table class="table table-bordered text-center" style="width: 80%; margin: auto;">
    <thead class="table-light">
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
            <th>조회수</th>
        </tr>
    </thead>
   <tbody>
<% if (list != null && list.size() > 0) {
    for (PostDTO dto : list) { %>
    <tr>
        <td><%= number-- %></td>
        <td class="text-start">
            <% for (int i = 0; i < dto.getRe_level(); i++) { %>
                <span class="ms-3"></span>
            <% } %>
            <% if (dto.getRe_level() > 0) { %>
                <span class="text-secondary">RE:</span>
            <% } %>
            <a href="view.jsp?num=<%= dto.getNum() %>&pageNum=<%= currentPage %>"><%= dto.getTitle() %></a>
            <% if (dto.getReadcnt() >= 20) { %>
                [인기글]
            <% } %>
        </td>
        <td><%= dto.getWriter() %></td>
        <td>
            <%
                Object regDate = dto.getRegdate();
                if (regDate != null && regDate instanceof java.util.Date) {
            %>
                <%= sdf.format((java.util.Date)regDate) %>
            <%
                } else {
            %>
                -
            <%
                }
            %>
        </td>
        <td><%= dto.getReadcnt() %></td>
    </tr>
<% }
} else { %>
    <tr>
        <td colspan="5">등록된 글이 없습니다.</td>
    </tr>
<% } %>
</tbody>
</table>

<div class="text-center mt-3">
    <input type="button" value="글쓰기" class="btn btn-primary" style="width: 15%;" onclick="location.href='write.jsp'">
</div>

<div class="pagination justify-content-center mt-4">
    <% if (currentPage > 1) { %>
        <a class="btn btn-outline-secondary me-2" href="bord.jsp?pageNum=<%= currentPage - 1 %>">[이전]</a>
    <% } %>
    <span class="align-self-center"> <%= currentPage %> 페이지 </span>
    <% if (count > endRow) { %>
        <a class="btn btn-outline-secondary ms-2" href="bord.jsp?pageNum=<%= currentPage + 1 %>">[다음]</a>
    <% } %>
</div>

<%@ include file="/resources/footer/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
