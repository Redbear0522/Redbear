<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>

<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글쓰기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"rel="stylesheet">
<link rel="stylesheet"	href="<%=request.getContextPath()%>/resources/theme.css">
<script language="JavaScript" src="/jsp/resources/js/imageboard.js"></script>
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
    <h2>게시글 작성</h2>
    <form action="writePro.jsp" method="post" enctype="multipart/form-data" name="write" onsubmit="return writeSave();">
        <table border="1" cellpadding="10">
           <tr>
			    <td>작성자</td>
			    <%-- [수정] input 태그를 td 태그 안으로 이동 --%>
			    <td>
			        <input type="text" name="writer" value="<%= session.getAttribute("sname") != null ? session.getAttribute("sname") : "" %>" readonly>
			    </td>
			</tr>
            <tr>
                <td>제 목</td>
                <td><input type="text" name="title" required></td>
            </tr>
            <tr>
                <td>내 용</td>
                <td><textarea name="content" rows="10" cols="50" required></textarea></td>
            </tr>
              <tr>
                <td>첨 부</td>
                <td>
                    <%-- [수정] 파일 관련 요소 전체를 감싸는 컨테이너 --%>
                    <div id="file-container">
                        
                        <%-- 1. 파일 추가 버튼 --%>
                        <div>
                            <input type="button" value="파일 추가" onclick="addFile();"/>
                        </div>

                        <%-- 2. 기본으로 표시될 첫 파일 입력창 + 미리보기 --%>
                        <div style="display: flex; align-items: center; margin-top: 10px;">
                            <input type="file" id="image-input" name="uploadFile" required>
                            <img id="image-preview" src="#" alt="이미지 미리보기" 
                                 style="display: none; max-width: 200px; max-height: 200px; margin-left: 15px; border: 1px solid #ddd;">
                        </div>

                        <%-- 3. '파일 추가' 버튼으로 추가될 입력창들이 들어올 위치 --%>
                        <div id="addfile"></div>

                    </div>
                </td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td><input type="password" name="pw" required></td>
            </tr>
        </table>
        <br>
        <input type="submit" value="등록">
        <input type="button" value="목록" onclick="location.href='list.jsp'">
    </form>
<%@ include file="/resources/footer/footer.jsp"%>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // --- 1. 파일 미리보기를 설정하는 재사용 가능한 함수 ---
    function setupImagePreview(fileInput, previewElement) {
        fileInput.addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewElement.src = e.target.result;
                    previewElement.style.display = 'block'; // 이미지를 보이게 함
                }
                reader.readAsDataURL(file);
            } else {
                previewElement.src = "#";
                previewElement.style.display = 'none'; // 파일 선택 취소 시 이미지 숨김
            }
        });
    }

    // --- 2. '파일 추가' 버튼을 눌렀을 때 실행될 함수 ---
    var fileCount = 1; // 추가된 파일의 고유 번호를 위한 변수

    function addFile() {
        const addfileContainer = document.getElementById("addfile");

        // 새로운 파일 입력 + 미리보기를 감쌀 컨테이너 div 생성
        const wrapper = document.createElement("div");
        wrapper.style.display = "flex";
        wrapper.style.alignItems = "center";
        wrapper.style.marginTop = "10px";

        // 새로운 파일 input 생성
        const newFileInput = document.createElement("input");
        newFileInput.type = "file";
        newFileInput.name = "uploadFile" + (++fileCount);

        // 새로운 미리보기 img 생성
        const newImagePreview = document.createElement("img");
        newImagePreview.alt = "이미지 미리보기";
        newImagePreview.style.display = "none";
        newImagePreview.style.maxWidth = "200px";
        newImagePreview.style.maxHeight = "200px";
        newImagePreview.style.marginLeft = "15px";
        newImagePreview.style.border = "1px solid #ddd";

        // 컨테이너에 새로 만든 요소들 추가
        wrapper.appendChild(newFileInput);
        wrapper.appendChild(newImagePreview);

        // #addfile 영역에 최종적으로 컨테이너 추가
        addfileContainer.appendChild(wrapper);

        // [핵심] 새로 만든 파일 입력창에도 미리보기 기능을 즉시 설정해줍니다.
        setupImagePreview(newFileInput, newImagePreview);
    }

    // --- 3. 페이지가 처음 로드될 때 실행 ---
    document.addEventListener('DOMContentLoaded', function() {
        // 기본으로 존재하는 첫 번째 파일 입력창의 요소를 가져옵니다.
        const initialImageInput = document.getElementById('image-input');
        const initialImagePreview = document.getElementById('image-preview');
        
        // 첫 번째 파일 입력창에도 미리보기 기능을 설정합니다.
        setupImagePreview(initialImageInput, initialImagePreview);
    });

    // --- 4. 유효성 검사 함수 (기존과 동일) ---
    function writeSave() {
        if(document.write.writer.value==""){
          alert("작성자를 입력하십시오.");
          document.write.writer.focus();
          return false;
        }
        if(document.write.title.value==""){
          alert("제목을 입력하십시오.");
          document.write.title.focus();
          return false;
        }
        if(document.write.content.value==""){
          alert("내용을 입력하십시오.");
          document.write.content.focus();
          return false;
        }
        if(document.write.pw.value==""){
          alert("비밀번호를 입력하십시오.");
          document.write.pw.focus();
          return false;
        }
    }
</script>
</body>

</html>
