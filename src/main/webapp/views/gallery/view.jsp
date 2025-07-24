<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import = "board.GalleryDAO" %>
<%@page import = "board.GalleryDTO" %>
<%@page import = "java.text.SimpleDateFormat" %>
<% request.setCharacterEncoding("UTF-8");%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>갤러리 게시글 보기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">

<%
    String numStr = request.getParameter("num");
    String pageNum = request.getParameter("pageNum");
    
    if (numStr == null || numStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/gallery/gallery.jsp");
        return;
    }

    int num = 0;
    try {
        num = Integer.parseInt(numStr);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/views/gallery/gallery.jsp");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    GalleryDAO pdPro = GalleryDAO.getInstance();
    GalleryDTO post = pdPro.getGallery(num);
    
    if (post == null) {
        response.sendRedirect(request.getContextPath() + "/views/gallery/gallery.jsp");
        return;
    }
    
    // 조회수 증가
    pdPro.updateReadCount(num);

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
        <td colspan="3">
            <h4 class="mb-0"><%= post.getTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;") %></h4>
        </td>
</tr>
 		<tr>
		        <th scope="row">사진</th>
		        <td colspan="3" class="text-center">
                    <div class="position-relative">
                        <img src="<%= post.getImage() %>" class="img-fluid rounded" 
                             style="max-width: 100%; max-height: 600px; object-fit: contain;"
                             onerror="this.onerror=null; this.src='<%=request.getContextPath()%>/resources/images/no-image.png';"
                             alt="<%= post.getTitle() %>">
                    </div>
                </td>
		</tr>

      <tr>
        <th scope="row" style="vertical-align: top;">내용</th>
        <td colspan="3" class="p-4" style="min-height: 200px;">
            <div class="content-area" style="white-space: pre-wrap; line-height: 1.6;">
                <%= post.getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;") %>
            </div>
        </td>
      </tr>
<%
    if (pageNum == null || pageNum.trim().equals("")) {
        pageNum = "1";
    }
%>
<tr height="30">      
      <td colspan="4" class="text-center">
          <% if (sid != null && sid.equals(post.getWriter())) { %>
              <button type="button" class="btn btn-primary me-2"
                onclick="location.href='<%=request.getContextPath()%>/views/gallery/update.jsp?num=<%= post.getNum() %>&pageNum=<%= pageNum %>'">글수정</button>
              <button type="button" class="btn btn-danger me-2"
                onclick="location.href='<%=request.getContextPath()%>/views/gallery/delete.jsp?num=<%= post.getNum() %>&pageNum=<%= pageNum %>'">글삭제</button>
          <% } %>
          <button type="button" class="btn btn-secondary"
            onclick="location.href='<%=request.getContextPath()%>/views/gallery/gallery.jsp?pageNum=<%= pageNum %>'">글목록</button>
    </td>
  </tr>
</table>


</form>

<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // 이미지 클릭 시 원본 크기로 보기
    const postImage = document.querySelector('img.img-fluid');
    if (postImage) {
        postImage.addEventListener('click', function() {
            window.open(this.src, '_blank');
        });
        postImage.style.cursor = 'pointer';
    }

    // 삭제 버튼 클릭 시 확인
    const deleteBtn = document.querySelector('.btn-danger');
    if (deleteBtn) {
        deleteBtn.addEventListener('click', function(e) {
            if (!confirm('정말 삭제하시겠습니까?')) {
                e.preventDefault();
            }
        });
    }
});
</script>
</body>
</html>
