<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>회원가입</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>

<%@ include file="/resources/header/header.jsp" %>

<div class="container mt-5" style="max-width: 720px;">
  <h3 class="mb-4 text-center">회원가입</h3>
  <form action="registerPro.jsp" method="post" class="needs-validation" novalidate>

    <!-- 아이디 + 중복 확인 -->
    <div class="mb-3 row">
      <label for="id" class="col-sm-3 col-form-label">아이디</label>
      <div class="col-sm-9">
        <div class="input-group input-group-sm">
          <input type="text" id="id" name="id" class="form-control" required minlength="4" maxlength="12" pattern="[a-zA-Z0-9]+">
          <button type="button" onclick="checkId()" class="btn btn-outline-secondary">중복확인</button>
          <div class="invalid-feedback">
            영문자와 숫자 4~12자로 입력해주세요.
          </div>
        </div>
      </div>
    </div>

    <!-- 비밀번호 -->
    <div class="mb-3 row">
      <label for="pw" class="col-sm-3 col-form-label">비밀번호</label>
      <div class="col-sm-9">
        <input type="password" id="pw" name="pw" class="form-control form-control-sm" required minlength="8" ">
        <div class="invalid-feedback">
        </div>
      </div>
    </div>

    <!-- 비밀번호 확인 -->
    <div class="mb-3 row">
      <label for="pw2" class="col-sm-3 col-form-label">비밀번호 확인</label>
      <div class="col-sm-9">
        <input type="password" id="pw2" name="pw2" class="form-control form-control-sm" required>
        <div class="invalid-feedback">
          비밀번호가 일치하지 않습니다.
        </div>
      </div>
    </div>

    <!-- 이름 -->
    <div class="mb-3 row">
      <label for="name" class="col-sm-3 col-form-label">이름</label>
      <div class="col-sm-9">
        <input type="text" id="name" name="name" class="form-control form-control-sm" required maxlength="20">
        <div class="invalid-feedback">
          이름을 입력해주세요.
        </div>
      </div>
    </div>

    <!-- 생년월일 -->
    <div class="mb-3 row">
      <label for="birth" class="col-sm-3 col-form-label">생년월일</label>
      <div class="col-sm-9">
        <input type="date" id="birth" name="birth" class="form-control form-control-sm" required>
        <div class="invalid-feedback">
          생년월일을 선택해주세요.
        </div>
      </div>
    </div>

    <!-- 전화번호 -->
    <div class="mb-3 row">
      <label class="col-sm-3 col-form-label">전화번호</label>
      <div class="col-sm-3">
        <select name="phone1" id="phone1" class="form-select form-select-sm" required>
          <option value="">통신사 선택</option>
          <option>SKT</option>
          <option>KT</option>
          <option>LGU+</option>
        </select>
        <div class="invalid-feedback">
          통신사를 선택해주세요.
        </div>
      </div>
      <div class="col-sm-6">
        <input type="text" id="phone2" name="phone2" class="form-control form-control-sm"  ">
        <div class="invalid-feedback">
          올바른 전화번호 형식을 입력해주세요.
        </div>
      </div>
    </div>

    <!-- 성별 -->
    <div class="mb-3 row">
      <label class="col-sm-3 col-form-label">성별</label>
      <div class="col-sm-9 d-flex align-items-center">
        <div class="form-check me-3">
          <input type="radio" id="male" name="gender" value="1" class="form-check-input" required>
          <label for="male" class="form-check-label">남</label>
        </div>
        <div class="form-check">
          <input type="radio" id="female" name="gender" value="2" class="form-check-input">
          <label for="female" class="form-check-label">여</label>
        </div>
        <div class="invalid-feedback">
          성별을 선택해주세요.
        </div>
      </div>
    </div>

    <!-- 주소 -->
    <div class="mb-3 row">
      <label class="col-sm-3 col-form-label">주소</label>
      <div class="col-sm-9">
        <div class="input-group input-group-sm mb-2">
          <input type="text" id="zip" name="zip" placeholder="우편번호" readonly class="form-control" required>
          <button type="button" onclick="execDaumPostcode()" class="btn btn-outline-primary">주소 검색</button>
        </div>
        <div class="invalid-feedback">
          우편번호를 검색해주세요.
        </div>
        <input type="text" id="addr1" name="addr1" placeholder="기본 주소" readonly class="form-control form-control-sm mb-2" required>
        <div class="invalid-feedback">
          주소를 선택해주세요.
        </div>
        <input type="text" id="addr2" name="addr2" placeholder="상세 주소 입력" class="form-control form-control-sm" required maxlength="50">
        <div class="invalid-feedback">
          상세 주소를 입력해주세요.
        </div>
      </div>
    </div>

    <!-- 인사말 -->
    <div class="mb-3 row">
      <label for="greetings" class="col-sm-3 col-form-label">인사말</label>
      <div class="col-sm-9">
        <textarea id="greetings" name="greetings" rows="3" class="form-control form-control-sm" maxlength="200"></textarea>
        <div class="form-text">최대 200자까지 입력 가능합니다.</div>
      </div>
    </div>

    <!-- 제출 버튼 -->
    <div class="text-center">
      <button type="submit" class="btn btn-primary btn-sm px-4">가입</button>
    </div>

  </form>
</div>

<%@ include file="/resources/footer/footer.jsp" %>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/viewmember.js"></script>
<script>
  // 아이디 중복 확인
  function checkId() {
    var idVal = document.getElementById("id").value.trim();
    if (!idVal) {
      alert("아이디를 입력해주세요.");
      return;
    }
    window.open("<%=request.getContextPath()%>/views/member/checkid.jsp?id=" + encodeURIComponent(idVal),
      "idCheck", "width=500,height=400");
  }

  // Daum 우편번호 검색
  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function(data) {
        document.getElementById('zip').value = data.zonecode;
        document.getElementById('addr1').value = data.roadAddress;
        document.getElementById('addr2').focus();
      }
    }).open();
  }

  // 부트스트랩 커스텀 유효성 검사
  (function () {
    'use strict';
    var form = document.querySelector('.needs-validation');
    form.addEventListener('submit', function (event) {
      var pw = document.getElementById('pw');
      var pw2 = document.getElementById('pw2');
      if (pw.value !== pw2.value) {
        pw2.setCustomValidity('비밀번호가 일치하지 않습니다.');
      } else {
        pw2.setCustomValidity('');
      }
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  })();
</script>

</body>
</html>
