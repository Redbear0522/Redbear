<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>메인 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <link rel="stylesheet" href="/redbear_resources/theme.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            color: white;
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect fill="rgba(255,255,255,0.1)" x="0" y="0" width="100" height="100"/></svg>');
            opacity: 0.1;
        }
        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.12);
        }
        .card-body {
            padding: 2rem;
            background: linear-gradient(to bottom, #ffffff 0%, #f8f9fa 100%);
        }
        .btn-primary {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(37, 117, 252, 0.4);
        }
        .card-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .card-text {
            color: #7f8c8d;
            line-height: 1.6;
        }
        .hero-section11 {
            background-color: #f8f9fa;
            padding: 80px 0;
        }
        h2 {
            position: relative;
            padding-bottom: 15px;
        }
        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
        }
    </style>
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>
<%
    String sid = (String) session.getAttribute("sid");
    String name = (String) session.getAttribute("sname");
    boolean isLoggedIn = (sid != null);
%>

<% if (!isLoggedIn) { %>
<!-- 비회원용 화면 -->
<header class="hero-section text-center">
    <div class="container" data-aos="fade-up">
        <h1 class="display-3 fw-bold mb-4">Redbear</h1>
        <p class="lead fs-4 mb-5">혁신적인 웹 경험을 제공하는 Redbear 홈페이지에 오신 것을 환영합니다.</p>
        <a href="intro.jsp" class="btn btn-light btn-lg mt-3 rounded-pill px-5 py-3 shadow-sm">
            자세히 보기
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-right ms-2" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z"/>
            </svg>
        </a>
    </div>
</header>

<section class="hero-section11 py-5">
    <div class="container">
        <h2 class="text-center mb-5">사이트 주요 기능</h2>
        <div class="row g-4 justify-content-center">
            <!-- 게시판 -->
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="100">
                <div class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">게시판</h5>
                        <p class="card-text flex-grow-1">간단한 글을 올릴 수 있어요.</p>
                        <a href="<%=request.getContextPath()%>/views/board/bord.jsp" class="btn btn-primary mt-auto">이동</a>
                    </div>
                </div>
            </div>
            <!-- 사진 갤러리 -->
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="200">
                <div class="card shadow-sm h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">사진 갤러리</h5>
                        <p class="card-text flex-grow-1">소중한 추억을 공유해요.</p>
                        <a href="<%=request.getContextPath()%>/views/gallery/gallery.jsp" class="btn btn-primary mt-auto">이동</a>
                    </div>
                </div>
            </div>
            <!-- 회원가입 -->
            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="300">
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
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">게시판</h5>
                        <p class="card-text">간단한 글을 올릴 수 있어요.</p>
                        <a href="<%=request.getContextPath()%>/views/board/bord.jsp" class="btn btn-primary">이동</a>
                    </div>
                </div>
            </div>
            <!-- 사진 갤러리 -->
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">사진 갤러리</h5>
                        <p class="card-text">소중한 추억을 공유해요.</p>
                        <a href="<%=request.getContextPath()%>/views/gallery/gallery.jsp" class="btn btn-primary">이동</a>
                    </div>
                </div>
            </div>
            <!-- 회원정보 -->
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">회원정보</h5>
                        <p class="card-text">[<%=name%>]님의 회원정보입니다.</p>
                        <a href="<%=request.getContextPath()%>/views/member/info.jsp" class="btn btn-primary">이동</a>
                    </div>
                </div>
            </div>
            <!-- 로또 분석기 -->
            <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="400">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title">로또 분석기</h5>
                        <p class="card-text">로또 분석기 입니다.</p>
                        <a href="<%=request.getContextPath()%>/views/lotto.jsp" class="btn btn-primary">이동</a>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>
    AOS.init({
        duration: 1000,
        once: true,
        offset: 100
    });
</script>

</body>
</html>
