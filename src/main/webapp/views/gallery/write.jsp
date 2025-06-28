<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>사진 갤러리 글쓰기</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>

<%
  if (session.getAttribute("sid") == null) {
%>
  <script>
    alert("로그인 후 이용해주세요.");
    history.back();
  </script>
<%
    return;
  }
%>

<div class="container mt-5">
  <h2 class="mb-4">글쓰기</h2>
  <form
    action="<%=request.getContextPath()%>/gallery/writePro"
    method="post"
    enctype="multipart/form-data">
    
    <!-- 제목 -->
    <div class="mb-3">
      <label>제목</label>
      <input type="text" name="title" class="form-control" required>
    </div>
    <!-- 내용 -->
    <div class="mb-3">
      <label>내용</label>
      <textarea name="content" class="form-control" rows="6" required></textarea>
    </div>
    <!-- 비밀번호 -->
    <div class="mb-3">
      <label>비밀번호</label>
      <input type="password" name="pw" class="form-control" required>
    </div>
    <!-- 사진 업로드 -->
    <div class="mb-3">
      <label>사진</label>
      <input type="file" name="upfile" accept="image/*" class="form-control" required>
    </div>
    
    <div class="text-center">
      <button type="submit" class="btn btn-primary">등록</button>
      <button type="button" class="btn btn-secondary" onclick="location.href='<%=request.getContextPath()%>/views/gallery/gallery.jsp'">목록</button>
    </div>
  </form>
</div>

<%@ include file="/resources/footer/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
