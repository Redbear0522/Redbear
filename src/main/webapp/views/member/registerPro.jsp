<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="user.UserDAO" />
<%
    // DAO의 checkid 대신 회원가입(insert) 메소드를 호출합니다.
	dao.input(dto);
	if(true){ // 회원가입 성공 시
%>		
		<script>
		alert("회원가입이 완료되었습니다. 로그인 페이지로 이동합니다.");
		location.href = "<%=request.getContextPath()%>/views/member/login.jsp"; // 성공 시 로그인 페이지로 이동
		</script>
<%
	}else{ // 회원가입 실패 시 (DB 오류, 제약조건 위배 등)
%>		
		<script>
		alert("회원가입 중 오류가 발생했습니다. 다시 시도해 주세요.");
		history.go(-1); // 이전 페이지(회원가입 폼)로 돌아가기
		</script>
<%
	}
%>