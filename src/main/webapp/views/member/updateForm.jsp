<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserDTO, user.UserDAO" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/theme.css">
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>

<%
    

    // 세션에서 사용자 ID(sid)를 가져와서 사용자 정보 조회
    if (sid == null) {
        response.sendRedirect(request.getContextPath() + "/views/member/login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    UserDTO dto = dao.getInfo(sid);
    if (dto == null) {
        out.println("<script>alert('회원 정보가 없습니다.'); history.back();</script>");
        return;
    }
%>
<div class="container my-5">
    <h4 class="mb-4 text-center">회원정보 수정</h4>

    <form action="updatePro.jsp" method="post">
		<input type="hidden" name="id" value="<%=sid%>">
        <!-- 이름 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">이름</label>
            <div class="col-sm-9">
                <input type="text" name="name" required class="form-control form-control-sm" value="<%=dto.getName()%>">
            </div>
        </div>

        <!-- 생년월일 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">생년월일</label>
            <div class="col-sm-9">
                <input type="date" name="birth" class="form-control form-control-sm" value="<%=dto.getBirth()%>">
            </div>
        </div>

        <!-- 전화번호 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">전화번호</label>
            <div class="col-sm-3">
                <select name="phone1" class="form-select form-select-sm">
                    <option value="SKT" <%= "SKT".equals(dto.getPhone1()) ? "selected" : "" %>>SKT</option>
					<option value="KT" <%= "KT".equals(dto.getPhone1()) ? "selected" : "" %>>KT</option>
					<option value="LGU+" <%= "LGU+".equals(dto.getPhone1()) ? "selected" : "" %>>LGU+</option>
                </select>
            </div>
            <div class="col-sm-6">
                <input type="text" name="phone2" class="form-control form-control-sm" placeholder="010-xxxx-xxxx" value="<%=dto.getPhone2()%>">
            </div>
        </div>

        <!-- 성별 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">성별</label>
            <div class="col-sm-9 d-flex align-items-center">
                <div class="form-check me-3">
                    <input type="radio" name="gender" value="1" class="form-check-input" id="male" <%=dto.getGender() == 1 ? "checked" : ""%>>
                    <label for="male" class="form-check-label">남</label>
                </div>
                <div class="form-check">
                    <input type="radio" name="gender" value="2" class="form-check-input" id="female" <%=dto.getGender() == 2 ? "checked" : ""%>>
                    <label for="female" class="form-check-label">여</label>
                </div>
            </div>
        </div>

        <!-- 주소 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">주소</label>
            <div class="col-sm-9">
                <div class="input-group mb-2">
                    <input type="text" id="zip" name="zip" placeholder="우편번호" readonly class="form-control form-control-sm" value="<%=dto.getZip()%>">
                    <button type="button" onclick="execDaumPostcode()" class="btn btn-sm btn-outline-primary">주소 검색</button>
                </div>
                <input type="text" id="addr1" name="addr1" placeholder="기본 주소" readonly class="form-control form-control-sm mb-2" value="<%=dto.getAddr1()%>">
                <input type="text" id="addr2" name="addr2" placeholder="상세 주소 입력" class="form-control form-control-sm" value="<%=dto.getAddr2()%>">
            </div>
        </div>

        <!-- 인사말 -->
        <div class="mb-3 row">
            <label class="col-sm-3 col-form-label">인사말</label>
            <div class="col-sm-9">
                <textarea name="greetings" rows="3" class="form-control form-control-sm"><%=dto.getGreetings() == null ? "" : dto.getGreetings().replaceAll("<", "&lt;").replaceAll(">", "&gt;")%></textarea>
            </div>
        </div>

        <!-- 제출 버튼 -->
        <div class="text-center">
            <input type="submit" value="수정" class="btn btn-primary btn-sm px-4">
        </div>
    </form>
</div>
<script>
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

<%@ include file="/resources/footer/footer.jsp" %>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
