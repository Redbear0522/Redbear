<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인 페이지</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>
<form action="loginPro.jsp" method="post">
	아이디  <input type="text" name="id"/><br>
	비밀번호 <input type="password" name="pw"/><br>
		<input type="submit" value="로그인"/><br>
		<input type="button" value="회원가입" onclick="location.href='<%=request.getContextPath()%>/views/member/register.jsp'"/><br>
		<input type="button" value="ID찾기" onclick="location.href='<%=request.getContextPath()%>/views/member/findId.jsp'"/><br>
		<input type="button" value="PW찾기" onclick="location.href='<%=request.getContextPath()%>/views/member/findPw.jsp'"/><br>
	
	
</form>
<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
