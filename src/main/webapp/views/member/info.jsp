<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원 정보</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>

<main class="container">
<%
    
    UserDTO dto = null;

    if (sid != null) {
        UserDAO dao = new UserDAO();
        dto = dao.getInfo(sid);
    }

    if (dto == null) {
%>
    <div class="alert alert-warning text-center" role="alert">
        <h2>로그인이 필요합니다.</h2>
        <a href="<%=request.getContextPath()%>/views/member/login.jsp" class="btn btn-primary mt-3">로그인 하러 가기</a>
    </div>
<%
    } else {
%>
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h2 class="mb-0"><%= dto.getId() %>님의 정보</h2>
        </div>
        <div class="card-body">
            <p><strong>이름:</strong> <%= dto.getName() %></p>
            <p><strong>생년월일:</strong> <%= dto.getBirth() %></p>
            <p><strong>전화번호:</strong> [<%= dto.getPhone1() %>] <%= dto.getPhone2() %></p>
            <p><strong>성별:</strong> <%= (dto.getGender() == 1) ? "남자" : "여자" %></p>
            <p><strong>주소:</strong> <%= dto.getAddr1() %> , <%= dto.getAddr2() %></p>
            <p><strong>인사말:</strong> <%= dto.getGreetings() %></p>
        </div>
        <div class="card-footer">
            <a href="<%=request.getContextPath()%>/views/main.jsp" class="btn btn-secondary me-2">메인으로</a>
            <a href="<%=request.getContextPath()%>/views/member/updateForm.jsp" class="btn btn-warning me-2">회원정보 변경</a>
            <a href="<%=request.getContextPath()%>/views/member/pwChangeForm.jsp" class="btn btn-warning me-2">비밀번호 변경</a>
            <a href="<%=request.getContextPath()%>/views/member/deleteForm.jsp" class="btn btn-danger">회원 탈퇴</a>
        </div>
    </div>
<%
    }
%>
</main>
				<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>