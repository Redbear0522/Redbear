<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ include file="/resources/header/header.jsp" %>

<%
    // 로그인 체크
    if (session.getAttribute("sid") == null) {
%>
    <script>
        alert("로그인 후 이용 가능합니다.");
        history.back();
    </script>
<%
        return;
    }

    // 답글 여부 파라미터 처리
    int num = 0, ref = 1, re_step = 0, re_level = 0;
    try {
        if (request.getParameter("num") != null) {
            num = Integer.parseInt(request.getParameter("num"));
            ref = Integer.parseInt(request.getParameter("ref"));
            re_step = Integer.parseInt(request.getParameter("re_step"));
            re_level = Integer.parseInt(request.getParameter("re_level"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>글쓰기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4">게시글 작성</h2>
    <form action="writePro.jsp" method="post" accept-charset="UTF-8">

        <!-- 답글 정보 hidden 처리 -->
        <input type="hidden" name="num" value="<%=num%>">
        <input type="hidden" name="ref" value="<%=ref%>">
        <input type="hidden" name="re_step" value="<%=re_step%>">
        <input type="hidden" name="re_level" value="<%=re_level%>">

        <div class="mb-3">
            <label class="form-label">작성자</label>
            <input type="text" class="form-control" name="writer" 
                   value="<%= session.getAttribute("sname") != null ? session.getAttribute("sname") : "" %>" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" class="form-control" name="title" maxlength="50"
                   value="<%= request.getParameter("num") == null ? "" : "[답변] " %>" required>
        </div>

        <div class="mb-3">
            <label class="form-label">내용</label>
            <textarea class="form-control" name="content" rows="10" required></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">비밀번호</label>
            <input type="password" class="form-control" name="pw" required>
        </div>

        <div class="d-flex justify-content-between">
            <input type="submit" class="btn btn-primary w-25" value="등록">
            <button type="button" class="btn btn-secondary w-25" onclick="location.href='list.jsp'">목록</button>
        </div>

    </form>
</div>

<%@ include file="/resources/footer/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
