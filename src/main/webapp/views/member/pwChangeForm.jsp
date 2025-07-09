<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>비밀번호 변경</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>

<form action = "pwChangePro.jsp"method="post"/> 
	기존 비밀번호 <input type="password" name ="pw" /><br>
	변경 비밀번호 <input type="password" name ="pw1" /><br>
	비밀번호 확인 <input type="password" name ="pw2" /><br>
				<input type="submit" value="변경" />
</form>
				
				<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
				