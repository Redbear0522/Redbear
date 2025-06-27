<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String sid = (String) session.getAttribute("sid");
    String name = (String) session.getAttribute("sname");
    if (name == null) {
        name = "손님";
    }
%>
<link href="${pageContext.request.contextPath}/resources/theme.css" rel="stylesheet">
<nav class="navbar navbar-expand-lg navbar-dark custom-green">
    <div class="container">
        <a class="navbar-brand" href="<%=request.getContextPath() %>/views/main.jsp">Redbear</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navBar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navBar">
            <ul class="navbar-nav ms-auto">

               

                <% if (sid == null) { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/member/register.jsp">회원가입</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/member/login.jsp">로그인</a></li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="#">[<%= name %>]님 환영합니다.</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath() %>/views/member/logout.jsp">로그아웃</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath() %>/views/member/info.jsp">회원정보</a>
                    </li>
                <% } %>

                <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/views/board/bord.jsp">게시판</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/views/gallery/gallery.jsp">갤러리</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="https://open.kakao.com/o/g8CG2Ayh" target="_blank" rel="noopener noreferrer">문의</a>
                </li>

            </ul>
        </div>
    </div>
</nav>
