<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String sid = (String) session.getAttribute("sid");
    String name = (String) session.getAttribute("sname");
    if (name == null) {
        name = "손님";
    }
%>
<!-- CSS (정상 경로로 로딩) -->
<link href="${pageContext.request.contextPath}/resources/theme.css" rel="stylesheet">

<!-- ❌ 잘못된 script → 제거 또는 필요한 JS로 교체 -->
<!-- <script src="${pageContext.request.contextPath}/redbear_resources/theme.css"></script> -->
<!-- theme.css는 CSS입니다. script 태그 사용 금지 -->

<nav class="navbar navbar-expand-lg navbar-dark custom-green">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/views/main.jsp">Redbear</a>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/views/member/logout.jsp">로그아웃</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/views/member/info.jsp">회원정보</a>
                    </li>
                <% } %>

                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/board/bord.jsp">게시판</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/gallery/gallery.jsp">갤러리</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="https://open.kakao.com/o/g8CG2Ayh" target="_blank" rel="noopener noreferrer">문의</a>
                </li>

            </ul>
        </div>
    </div>
</nav>



