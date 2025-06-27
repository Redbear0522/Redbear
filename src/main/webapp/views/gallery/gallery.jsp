<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- [수정] 필요한 클래스들을 import 합니다. --%>
<%@ page import="board.GalleryDAO" %>
<%@ page import="board.GalleryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- 1. 페이징 및 데이터 조회 준비 ---
    request.setCharacterEncoding("UTF-8");

    int pageSize = 10; // 한 페이지에 보여줄 글의 수
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null) {
        pageNum = "1";
    }

    int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;
    int count = 0;
    int number = 0;

    List<GalleryDTO> list = null;
    
    // [수정] DTO가 아닌 DAO의 인스턴스를 가져옵니다.
    GalleryDAO dao = GalleryDAO.getInstance();
    
    // [수정] DAO를 통해 전체 게시글 수를 가져옵니다.
    count = dao.getArticleCount(); 
    
    if (count > 0) {
        // [수정] 올바른 메소드명(getGalleryList)으로 목록을 가져옵니다.
        list = dao.getGalleryList(startRow, endRow);
    }
    
    // JSP 화면에 표시할 글 번호를 계산합니다.
    number = count - (currentPage - 1) * pageSize;
%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>갤러리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%-- 헤더 파일을 include 합니다. --%>
<%@ include file="/resources/header/header.jsp" %>

<div class="container mt-4">
    <h2 class="text-center mb-4">갤러리</h2>
    
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
    <%-- 게시글이 있을 경우, 목록을 반복하여 출력합니다. --%>
    <% if (list != null && !list.isEmpty()) {
        // [수정] galleryDTO -> GalleryDTO (클래스명 대소문자 수정)
        for (GalleryDTO dto : list) { %>
        <tr>
            <td><%= number-- %></td>
            <td class="text-start">
                <%-- 답글일 경우 들여쓰기를 적용합니다. --%>
                <% if (dto.getRe_level() > 0) { %>
                    <span style="display: inline-block; width: <%= dto.getRe_level() * 20 %>px;"></span>
                    <span class="text-secondary">RE:</span>
                <% } %>
                
                <%-- 글 제목을 클릭하면 해당 글로 이동합니다. --%>
                <a href="<%=request.getContextPath() %>/view.jsp?num=<%= dto.getNum() %>&pageNum=<%= currentPage %>"><%= dto.getTitle() %></a>
                
                <%-- 조회수가 20 이상이면 [HOT] 아이콘을 표시합니다. --%>
                <% if (dto.getReadcnt() >= 20) { %>
                    <span class="badge bg-danger ms-1">HOT</span>
                <% } %>
            </td>
            <td><%= dto.getWriter() %></td>
            <td>
                <%-- 날짜 형식을 'yyyy-MM-dd HH:mm'으로 변환하여 출력합니다. --%>
                <% 
                    if(dto.getRegdate() != null) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        out.print(sdf.format(dto.getRegdate()));
                    }
                %>
            </td>
            <td><%= dto.getReadcnt() %></td>
        </tr>
    <%  } // for loop end
    } else { // 게시글이 없을 경우 %>
        <tr>
            <td colspan="5">등록된 글이 없습니다.</td>
        </tr>
    <% } // if-else end %>
    </tbody>
    </table>
    
    <div class="d-flex justify-content-end mt-3" style="width: 15%; margin: auto;">
        <input type="button" value="글쓰기" class="btn btn-primary" onclick="location.href='<%=request.getContextPath() %>write.jsp'">
    </div>
    
    <%-- 페이지네이션 --%>
    <div class="d-flex justify-content-center mt-4">
        <ul class="pagination">
        <% if (count > 0) {
            int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
            int startPage = 1;
            
            if(currentPage % 10 != 0) {
                startPage = (currentPage / 10) * 10 + 1;
            } else {
                startPage = ((currentPage-1) / 10) * 10 + 1;
            }
            
            int pageBlock = 10;
            int endPage = startPage + pageBlock - 1;
            if (endPage > pageCount) endPage = pageCount;
            
            if (startPage > 10) { %>
                <li class="page-item"><a class="page-link" href="/gallery.jsp?pageNum=<%= startPage - 10 %>">이전</a></li>
            <% }
            
            for (int i = startPage; i <= endPage; i++) { %>
                <li class="page-item <%= currentPage == i ? "active" : "" %>">
                    <a class="page-link" href="<%=request.getContextPath() %>/gallery.jsp?pageNum=<%= i %>"><%= i %></a>
                </li>
            <% }
            
            if (endPage < pageCount) { %>
                <li class="page-item"><a class="page-link" href="/gallery.jsp?pageNum=<%= startPage + 10 %>">다음</a></li>
            <% }
        } %>
        </ul>
    </div>
</div>

<%@ include file="/resources/footer/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
