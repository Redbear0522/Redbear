<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, board.GalleryDTO, board.GalleryDAO, java.text.SimpleDateFormat"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 페이지 관련 변수
    int pageSize = 12;  // 갤러리는 한 페이지에 12개 표시
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null || pageNum.trim().isEmpty()) {
        pageNum = "1";
    }
    
    // 현재 페이지 계산
    int currentPage = 0;
    try {
        currentPage = Integer.parseInt(pageNum);
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
    
    // 페이지 범위 계산
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;

    // DAO를 통한 데이터 조회
    GalleryDAO dao = GalleryDAO.getInstance();
    int count = dao.getArticleCount();
    List<GalleryDTO> galleryList = null;
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    if (count > 0) {
        galleryList = dao.getGalleryList(startRow, endRow);
    }
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
  <div class="row g-4">
    <% if (galleryList != null && !galleryList.isEmpty()) {
           for (GalleryDTO g : galleryList) { %>
        <div class="col-md-4 col-lg-3">
            <div class="card h-100 shadow-sm">
                <div class="position-relative">
                    <img src="<%= g.getImage() != null ? g.getImage() : request.getContextPath() + "/resources/images/no-image.png" %>"
                         class="card-img-top"
                         style="height: 200px; object-fit: cover;"
                         alt="<%= g.getTitle() %>">
                    <div class="position-absolute top-0 end-0 p-2">
                        <span class="badge bg-primary rounded-pill">조회 <%= g.getReadcnt() %></span>
                    </div>
                </div>
                <div class="card-body">
                    <h5 class="card-title text-truncate">
                        <a href="view.jsp?num=<%= g.getNum() %>&pageNum=<%= pageNum %>" 
                           class="text-decoration-none text-dark">
                            <%= g.getTitle() %>
                        </a>
                    </h5>
                    <p class="card-text small text-muted mb-0">
                        작성자: <%= g.getWriter() %><br>
                        <%= sdf.format(g.getRegdate()) %>
                    </p>
                </div>
            </div>
        </div>
    <% }
    } else { %>
        <div class="col-12 text-center py-5">
            <p class="text-muted">등록된 게시물이 없습니다.</p>
        </div>
    <% } %>
    </div>
    
    <!-- 페이지네이션 -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <% if (currentPage > 1) { %>
            <li class="page-item">
                <a class="page-link" href="gallery.jsp?pageNum=<%=currentPage-1%>">이전</a>
            </li>
            <% } else { %>
            <li class="page-item disabled">
                <span class="page-link">이전</span>
            </li>
            <% } %>
            
            <li class="page-item active">
                <span class="page-link"><%=currentPage%></span>
            </li>
            
            <% if (count > currentPage * pageSize) { %>
            <li class="page-item">
                <a class="page-link" href="gallery.jsp?pageNum=<%=currentPage+1%>">다음</a>
            </li>
            <% } else { %>
            <li class="page-item disabled">
                <span class="page-link">다음</span>
            </li>
            <% } %>
        </ul>
    </nav>
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