<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="board.GalleryDAO, board.GalleryDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    int num = Integer.parseInt(request.getParameter("num"));
    String pageNum = request.getParameter("pageNum");
    GalleryDTO article = GalleryDAO.getInstance().getGallery(num);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .preview-image {
            max-width: 300px;
            max-height: 300px;
            margin-top: 10px;
        }
        .current-image {
            max-width: 300px;
            max-height: 300px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<%@ include file="/resources/header/header.jsp" %>
<div class="container mt-5">
    <h2 class="mb-4">게시글 수정</h2>
    <form action="<%=request.getContextPath()%>/gallery/updatePro" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <input type="hidden" name="num" value="<%=num%>">
        <input type="hidden" name="pageNum" value="<%=pageNum%>">
        <table class="table">
            <tr>
                <th>제목</th>
                <td>
                    <input class="form-control" type="text" name="title" 
                           value="<%=article.getTitle()%>" required
                           maxlength="100">
                </td>
            </tr>
            <tr>
                <th>사진</th>
                <td>
                    <% if(article.getImage() != null && !article.getImage().isEmpty()) { %>
                        <div class="mb-3">
                            <p>현재 이미지:</p>
                            <img src="<%=article.getImage()%>" class="current-image" alt="현재 이미지">
                        </div>
                    <% } %>
                    <input class="form-control" type="file" name="upfile" 
                           accept="image/*" id="imageInput">
                    <div id="imagePreview"></div>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <textarea class="form-control" name="content" 
                              required rows="10"><%=article.getContent()%></textarea>
                </td>
            </tr>
    <tr>
                <th>비밀번호</th>
                <td>
                    <input class="form-control" type="password" name="pw" required
                           minlength="4" maxlength="20">
                    <small class="text-muted">수정하려면 기존 비밀번호를 입력하세요.</small>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="text-center">
                    <button class="btn btn-primary me-2" type="submit">수정하기</button>
                    <button type="button" class="btn btn-secondary" 
                            onclick="location.href='<%=request.getContextPath()%>/views/gallery/gallery.jsp?pageNum=<%=pageNum%>'">
                        목록으로
                    </button>
                </td>
            </tr>
        </table>
    </form>
</div>

<%@ include file="/resources/footer/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// 이미지 미리보기 기능
document.getElementById('imageInput').addEventListener('change', function(e) {
    const preview = document.getElementById('imagePreview');
    preview.innerHTML = '';
    
    if (this.files && this.files[0]) {
        // 파일 크기 체크 (10MB)
        if (this.files[0].size > 10 * 1024 * 1024) {
            alert('파일 크기는 10MB를 초과할 수 없습니다.');
            this.value = '';
            return;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            const img = document.createElement('img');
            img.src = e.target.result;
            img.className = 'preview-image';
            preview.appendChild(img);
        }
        reader.readAsDataURL(this.files[0]);
    }
});

// 폼 유효성 검사
function validateForm() {
    const title = document.querySelector('input[name="title"]');
    const content = document.querySelector('textarea[name="content"]');
    const password = document.querySelector('input[name="pw"]');
    
    if (title.value.trim().length < 1) {
        alert('제목을 입력해주세요.');
        title.focus();
        return false;
    }
    
    if (content.value.trim().length < 1) {
        alert('내용을 입력해주세요.');
        content.focus();
        return false;
    }
    
    if (password.value.trim().length < 4) {
        alert('비밀번호는 4자 이상 입력해주세요.');
        password.focus();
        return false;
    }
    
    return true;
}
</script>
</body>
</html>
</body>
</html>
