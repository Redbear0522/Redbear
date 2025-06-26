<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/resources/header/header.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>메인 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/redbear_resources/theme.css">
</head>
<body>

<%
    // 로그인 여부 체크
    boolean isLoggedIn = (sid != null);
%>

<% if (!isLoggedIn) { %>
<!-- 비회원용 화면 -->
<header class="hero-section text-center py-5">
    <div class="container">
        <h1 class="display-4">Redbear</h1>
        <p class="lead">Redbear 홈페이지에 오신 것을 환영합니다.</p>
        <a href="intro.jsp" class="btn btn-light btn-lg mt-3">자세히 보기</a>
    </div>
</header>

<section class="hero-section11 py-5">
    <div class="container">
        <h2 class="text-center mb-5">사이트 주요 기능</h2>
        <div class="row g-4 justify-content-center">
            <!-- 게시판 -->
            <div class="col-md-6 col-lg-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">게시판</h5>
                        <p class="card-text flex-grow-1">간단한 글을 올릴 수 있어요.</p>
                        <a href="<%=request.getContextPath()%>/views/board/bord.jsp" class="btn btn-primary mt-auto">이동</a>
                    </div>
                </div>
            </div>
            <!-- 사진 갤러리 -->
            <div class="col-md-6 col-lg-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">사진 갤러리</h5>
                        <p class="card-text flex-grow-1">소중한 추억을 공유해요.</p>
                        <a href="/gallery/gallery.jsp" class="btn btn-primary mt-auto">이동하기</a>
                    </div>
                </div>
            </div>
            <!-- 회원가입 -->
            <div class="col-md-6 col-lg-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">회원가입</h5>
                        <p class="card-text flex-grow-1">사이트의 회원이 되어보세요.</p>
                        <a href="<%=request.getContextPath()%>/views/member/register.jsp" class="btn btn-primary mt-auto">이동</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<% } else { %>
<!-- 로그인 사용자용 화면 -->
<section class="hero-section11 text-center py-5">
    <div class="container">
        <h2 class="text-center mb-5">사이트 안내</h2>
        <div class="row g-4 justify-content-center">
            <!-- 게시판 -->
            <div class="col-md-6 col-lg-3">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">게시판</h5>
                        <p class="card-text">간단한 글을 올릴 수 있어요.</p>
                        <a href="<%=request.getContextPath()%>/views/board/bord.jsp" class="btn btn-primary">이동</a>
                    </div>
                </div>
            </div>
            <!-- 사진 갤러리 -->
            <div class="col-md-6 col-lg-3">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">사진 갤러리</h5>
                        <p class="card-text">소중한 추억을 공유해요.</p>
                        <a href="<%=request.getContextPath()%>/views/gallery/gallery.jsp" class="btn btn-primary">이동하기</a>
                    </div>
                </div>
            </div>
            <!-- 회원정보 -->
            <div class="col-md-6 col-lg-3">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">회원정보</h5>
                        <p class="card-text">[<%=name%>]님의 회원정보입니다.</p>
                        <a href="<%=request.getContextPath()%>/views/member/info.jsp" class="btn btn-primary">이동</a>
                    </div>
                </div>
            </div>
            <!-- 로또 분석기 -->
            <div class="col-md-6 col-lg-3">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">로또 분석기</h5>
                        <p class="card-text">로또 분석기 입니다.</p>
                        <a href="/lotto/lotto.jsp" class="btn btn-primary">이동하기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<% } %>

<%@ include file="/resources/footer/footer.jsp"%>

<!-- JS Script -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
