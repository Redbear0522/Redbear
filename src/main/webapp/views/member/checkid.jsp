<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%
String id = request.getParameter("id");
boolean isDuplicate = false;

if (id != null && !id.trim().isEmpty()) {
    UserDAO dao = new UserDAO();
    isDuplicate = dao.isIdExists(id);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복확인</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
	text-align: center;
}

.result-message {
	padding: 15px;
	border-radius: 5px;
	margin-top: 20px;
}

.available {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.duplicate {
	background-color: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}

button {
	margin-top: 15px;
	padding: 8px 15px;
	border: none;
	border-radius: 4px;
	background-color: #007bff;
	color: white;
	cursor: pointer;
}

button:hover {
	background-color: #0056b3;
}
</style>
</head>
<body>
	<div class="container">
		<h2>아이디 중복확인</h2>
		<%
		if (id == null || id.trim().isEmpty()) {
		%>
		<p class="result-message duplicate">아이디를 입력해주세요.</p>
		<%
		} else if (isDuplicate) {
		%>
		<p class="result-message duplicate">
			입력하신 아이디 (<%=id%>)는 이미 사용 중입니다.
		</p>
		<button onclick="window.close()">창 닫기</button>
		<%
		} else {
		%>
		<p class="result-message available">
			입력하신 아이디 (<%=id%>)는 사용 가능합니다.
		</p>
		<button onclick="window.close()">사용하기</button>
		<%
		}
		%>
	</div>

	
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
