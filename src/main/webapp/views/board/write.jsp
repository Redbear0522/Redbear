<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>

<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글쓰기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>
<%
    // 직접 sid 변수 선언하지 않고 세션에서 꺼내서 체크
    if (session.getAttribute("sid") == null) {
%>
    <script>
        alert("로그인 후 이용 가능합니다.");
        history.back();
    </script>
<%
        return; // 더 이상 진행하지 않도록 처리
    }
%>
    <div class="container mt-5">
        <h2 class="text-center mb-4">게시글 작성</h2>
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form action="writePro.jsp" method="post" accept-charset="UTF-8">
                            <div class="mb-3">
                                <label for="writer" class="form-label">작성자</label>
                                <input type="text" class="form-control" id="writer" name="writer" 
                                    value="<%= session.getAttribute("sname") != null ? session.getAttribute("sname") : "" %>" readonly>
                            </div>
                            
                            <div class="mb-3">
                                <label for="title" class="form-label">제목</label>
                                <input type="text" class="form-control" id="title" name="title" required
                                    placeholder="제목을 입력하세요">
                            </div>
                            
                            <div class="mb-3">
                                <label for="content" class="form-label">내용</label>
                                <textarea class="form-control" id="content" name="content" rows="10" required
                                    placeholder="내용을 입력하세요" style="resize: vertical;"></textarea>
                            </div>
                            
                            <div class="mb-4">
                                <label for="pw" class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="pw" name="pw" required
                                    placeholder="비밀번호를 입력하세요">
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button type="button" class="btn btn-secondary me-md-2" onclick="location.href='bord.jsp'">
                                    목록
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    등록
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
