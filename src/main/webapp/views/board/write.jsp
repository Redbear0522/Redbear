<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>

<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글쓰기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>
<%
    // 직접 sid 변수 선언하지 않고 세션에서 꺼내서 체크
    if (session.getAttribute("sid") == null) {
%>
    <script>
        alert("로그인 후 이용 가능합니다.");
        history.back();
    </script>
<%
        return; // 더 이상 진행하지 않도록 처리
    }
%>
    <h2>게시글 작성</h2>
    <form action="writePro.jsp" method="post" accept-charset="UTF-8">
        <table border="1" cellpadding="10">
            <tr>
                <td>작성자</td>
                   <input type="text" name="writer" value="<%= session.getAttribute("sname") != null ? session.getAttribute("sname") : "" %>" readonly>
            </tr>
            <tr>
                <td>제목</td>
                <td><input type="text" name="title" required></td>
            </tr>
            <tr>
                <td>내용</td>
                <td><textarea name="content" rows="10" cols="50" required></textarea></td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td><input type="password" name="pw" required></td>
            </tr>
        </table>
        <br>
        <input type="submit" value="등록">
        <input type="button" value="목록" onclick="location.href='list.jsp'">
    </form>
<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
