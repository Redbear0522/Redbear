<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h1>/views/member/loginPro.jsp</h1><br>

<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="user.UserDAO" />
<%
	boolean result = dao.checkid(dto);
	if(result){
		//로그인 성공 = 세션 , 쿠키 // 로그인 성공의 표시를 누가 들고있는가.
		//쿠키정보는 보안에 취약하지만 지극히 개인적으로 사용하는 핸드폰에서 주로 편리성을 위해 사용한다. 
		//프레임워크에서는 세션 X 토큰과 쿠기를 사용한다. 
		//세션은
		
		session.setAttribute("sid", dto.getId());
		session.setAttribute("sname", dao.getUserById(dto.getId()).getName());
		%>		
		<script>
		alert("로그인 되었습니다. ");
		location.href = "<%=request.getContextPath()%>/views/main.jsp"; // 성공 시 메인 페이지로 이동
		</script>
<%
		System.out.print(dao.getUserById("id"));
		
	}else{
%>		//로그인 실패
		<script>
		alert("아이디/비밀번호를 확인하세요");
		history.go(-1);
		</script>
		 
		
	<%}
%>
		