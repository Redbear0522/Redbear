<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>
<script src="/Redbear/resources/js/viewmember.js"></script>

<div class="container mt-5" style="max-width: 720px;">
    <h3 class="mb-4 text-center">회원가입</h3>
    <form action="registerPro.jsp" method="post">
        <!-- 아이디 + 중복 확인 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">아이디</label>
            <div class="col-sm-6">
                <input type="text" name="id" id="id" required class="form-control form-control-sm">
            </div>
            <div class="col-sm-3">
                <input type="button" value="중복확인" onclick="checkid()" class="btn btn-sm btn-outline-secondary w-100">
            </div>
        </div>

        <!-- 비밀번호 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">비밀번호</label>
            <div class="col-sm-9">
                <input type="password" name="pw" required class="form-control form-control-sm">
            </div>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">비밀번호 확인</label>
            <div class="col-sm-9">
                <input type="password" name="pw2" class="form-control form-control-sm">
            </div>
        </div>

        <!-- 이름 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">이름</label>
            <div class="col-sm-9">
                <input type="text" name="name" id="name" required class="form-control form-control-sm">
            </div>
        </div>

        <!-- 생년월일 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">생년월일</label>
            <div class="col-sm-9">
                <input type="date" id="birth" name="birth" class="form-control form-control-sm">
            </div>
        </div>

        <!-- 전화번호 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">전화번호</label>
            <div class="col-sm-3">
                <select name="phone1" class="form-select form-select-sm">
                    <option>SKT</option>
                    <option>KT</option>
                    <option>LGU+</option>
                </select>
            </div>
            <div class="col-sm-6">
                <input type="text" name="phone2" class="form-control form-control-sm" placeholder="010-xxxx-xxxx">
            </div>
        </div>

        <!-- 성별 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">성별</label>
            <div class="col-sm-9 d-flex align-items-center">
                <div class="form-check me-3">
                    <input type="radio" name="gender" value="1" class="form-check-input" id="male">
                    <label for="male" class="form-check-label">남</label>
                </div>
                <div class="form-check">
                    <input type="radio" name="gender" value="2" class="form-check-input" id="female">
                    <label for="female" class="form-check-label">여</label>
                </div>
            </div>
        </div>

        <!-- 주소 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">주소</label>
            <div class="col-sm-9">
                <div class="input-group mb-2">
                    <input type="text" id="zip" name="zip" placeholder="우편번호" readonly class="form-control form-control-sm">
                    <button type="button" onclick="execDaumPostcode()" class="btn btn-sm btn-outline-primary">주소 검색</button>
                </div>
                <input type="text" id="addr1" name="addr1" placeholder="기본 주소" readonly class="form-control form-control-sm mb-2">
                <input type="text" id="addr2" name="addr2" placeholder="상세 주소 입력" class="form-control form-control-sm">
            </div>
        </div>

        <!-- 인사말 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">인사말</label>
            <div class="col-sm-9">
                <textarea name="greetings" rows="3" class="form-control form-control-sm"></textarea>
            </div>
        </div>

        <!-- 제출 버튼 -->
        <div class="text-center">
            <input type="submit" value="가입" class="btn btn-primary btn-sm px-4">
        </div>
    </form>
</div>

<%@ include file="/resources/footer/footer.jsp" %>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function checkid() {
        var id = document.getElementById("id").value.trim();
        if (id === "") {
            alert("아이디를 입력해주세요.");
            return;
        }
        window.open("<%=request.getContextPath()%>/views/member/checkid.jsp?id=" + encodeURIComponent(id),
            "idCheck", "width=500,height=400");
    }

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('zip').value = data.zonecode;
                document.getElementById("addr1").value = data.roadAddress;
                document.getElementById("addr2").focus();
            }
        }).open();
    }
</script>
</body>
</html>
