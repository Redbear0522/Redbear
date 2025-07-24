<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="board.PostDAO, board.PostDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    int num = Integer.parseInt(request.getParameter("num"));
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null || pageNum.trim().isEmpty()) {
        pageNum = "1";
    }

    // DAO 인스턴스 얻어서 게시글 조회
    PostDAO dao = PostDAO.getInstance();
    
    // 1. 조회수 증가
    dao.setReadCountUpdate(num);
    
    // 2. 증가된 조회수를 포함한 게시물 정보를 가져옵니다.
    PostDTO post = dao.getPost(num);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>게시글 보기</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>

<div class="container mt-5">
  <h2 class="mb-4 text-center">게시글 내용</h2>
  <table class="table table-bordered">
    <tbody>
      <tr>
        <th style="width:15%;">글번호</th>
        <td style="width:20%;"><%= post.getNum() %></td>
        <th style="width:15%;">조회수</th>
        <td style="width:20%;"><%= post.getReadcnt() %></td>
      </tr>
      <tr>
        <th>작성자</th>
        <td><%= post.getWriter() %></td>
        <th>작성일</th>
        <td><%= post.getRegdate() %></td>
      </tr>
      <tr>
        <th>제목</th>
        <td colspan="3"><strong><%= post.getTitle() %></strong></td>
      </tr>
      <tr>
        <th style="vertical-align: top;">내용</th>
        <td colspan="3" style="white-space: pre-wrap;"><%= post.getContent() %></td>
      </tr>
    </tbody>
  </table>

  <div class="text-center">
    <button type="button" class="btn btn-primary me-2"
            onclick="location.href='update.jsp?num=<%= post.getNum() %>&pageNum=<%= pageNum %>'">
      글수정
    </button>
    <button type="button" class="btn btn-danger me-2"
            onclick="location.href='delete.jsp?num=<%= post.getNum() %>&pageNum=<%= pageNum %>'">
      글삭제
    </button>
    <button type="button" class="btn btn-secondary"
            onclick="location.href='bord.jsp?pageNum=<%= pageNum %>'">
      글목록
    </button>
  </div>
</div>

<%@ include file="/resources/footer/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
