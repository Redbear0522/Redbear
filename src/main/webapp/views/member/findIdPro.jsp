<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:useBean id="dao" class="user.UserDAO" />

<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("name");
    String phone2 = request.getParameter("phone2");
    String birth = request.getParameter("birth");

    dto.setName(name);
    dto.setPhone2(phone2);
    dto.setBirth(birth);

    String id = dao.findId(dto); // id를 반환하는 메서드로 수정 완료

    if (id != null && !id.trim().equals("")) {
%>
    <script>
        alert("아이디는 [<%=id %>] 입니다.");
        window.location = "<%=request.getContextPath()%>/views/member/info.jsp";
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
