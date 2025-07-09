<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="user.UserDAO, user.UserDTO" %>

<h1>/views/member/loginPro.jsp</h1><br>

<jsp:useBean id="dto" class="user.UserDTO" />
<jsp:setProperty name="dto" property="*" />

<%
    // UserDAO를 new로 인스턴스화
    UserDAO dao = new UserDAO();
    boolean result = dao.checkid(dto);

    if (result) {
        // 로그인 성공
        session.setAttribute("sid", dto.getId());
        session.setAttribute("sname", dao.getUserById(dto.getId()).getName());
        response.sendRedirect(request.getContextPath() + "/views/main.jsp");
    } else {
%>
        <script>
            alert("아이디/비밀번호를 확인하세요");
            history.back();
        </script>
<%
    }
%>
