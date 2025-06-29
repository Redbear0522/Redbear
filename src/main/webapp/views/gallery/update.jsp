<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="board.GalleryDAO, board.GalleryDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    int num = Integer.parseInt(request.getParameter("num"));
    String pageNum = request.getParameter("pageNum");
    GalleryDTO article = GalleryDAO.getInstance().getGallery(num);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 수정</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>
<body>
<jsp:include page="/resources/header/header.jsp" />
<form method="post"
      enctype="multipart/form-data"
      action="${pageContext.request.contextPath}/gallery/updatePro?num=${num}&pageNum=${pageNum}">
  <input type="hidden" name="num" value="${num}">
  <table class="table" style="width:70%; margin:2em auto;">
    <tr>
      <th>제목</th>
      <td><input class="form-control" type="text" name="title"
                 value="${article.title}" required></td>
    </tr>
    <tr>
      <th>사진</th>
      <td><input class="form-control" type="file" name="upfile" accept="image/*"></td>
    </tr>
    <tr>
      <th>내용</th>
      <td><textarea class="form-control" name="content"
                    required>${article.content}</textarea></td>
    </tr>
    <tr>
      <th>비밀번호</th>
      <td><input class="form-control" type="password" name="pw" required></td>
    </tr>
    <tr>
      <td colspan="2" class="text-center">
        <button class="btn btn-primary" type="submit">수정</button>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/gallery/list?pageNum=${pageNum}">목록</a>
      </td>
    </tr>
  </table>
</form>
<jsp:include page="/resources/footer/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
