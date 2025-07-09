<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ID 찾기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">

<style>
    body {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }
    main {
        flex: 1;
    }
</style>
</head>
<body>

<%@ include file="/resources/header/header.jsp" %>

<main class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow p-4">
                <h3 class="mb-4 text-center">아이디 찾기</h3>
                <form action="findIdPro.jsp" method="post">
                    <div class="mb-3">
                        <label for="name" class="form-label">이름</label>
                        <input type="text" class="form-control" name="name" id="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone2" class="form-label">전화번호</label>
                        <input type="text" class="form-control" name="phone2" id="phone2" placeholder="010-xxxx-xxxx" required>
                    </div>
                    <div class="mb-3">
                        <label for="birth" class="form-label">생년월일</label>
                        <input type="date" class="form-control" name="birth" id="birth" required>
                    </div>
                    <div class="d-grid">
                        <input type="submit" class="btn btn-primary" value="ID 찾기">
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<%@ include file="/resources/footer/footer.jsp" %>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
