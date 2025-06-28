<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:useBean id="dao" class="user.UserDAO" />

<%
    request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
    String name = request.getParameter("name");
    String phone2 = request.getParameter("phone2");
    String birth = request.getParameter("birth");
	dto.setId(id);
    dto.setName(name);
    dto.setPhone2(phone2);
    dto.setBirth(birth);

    String pw = dao.findPw(dto); // id를 반환하는 메서드로 수정 완료

    if (pw != null && !pw.trim().equals("")) {
%>
    <script>
        alert("비밀번호는 [<%=pw %>] 입니다.");
        window.location = "<%=request.getContextPath()%>/views/member/login.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("입력사항을 확인해주세요.");
        history.go(-1);
    </script>
<%
    }
%>
