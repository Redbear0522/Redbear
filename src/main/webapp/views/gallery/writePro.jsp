<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.GalleryDAO" %>
<%@ page import="board.GalleryDTO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
    // --- 1. 로그인 세션 확인 ---
    String writerId = (String) session.getAttribute("sid");
    if (writerId == null) {
%>
    <script>
        alert("로그인 후 이용해주세요.");
        location.href = "<%= request.getContextPath() %>/views/member/login.jsp";
    </script>
<%
        return; // JSP 처리를 중단합니다.
    }

    // --- 2. 파일 업로드 설정 및 처리 ---
    // 파일이 저장될 서버의 실제 경로를 찾습니다.
    String savePath = config.getServletContext().getRealPath("/resources/imageboard");
    int maxSize = 100 * 1024 * 1024; // 최대 파일 사이즈: 100MB
    String encType = "UTF-8";
    
    // MultipartRequest 객체가 생성되는 순간 파일 업로드가 완료됩니다.
    DefaultFileRenamePolicy df = new DefaultFileRenamePolicy(); 
    MultipartRequest mr = 
      new MultipartRequest(request, savePath,maxSize,encType,df);
 	// --- 3. DTO 객체 생성 및 데이터 저장 ---
    %>
    <jsp:useBean id="dto" scope="page" class="board.GalleryDTO" />
    <%
    // MultipartRequest 객체로부터 파라미터 값을 가져옵니다.
    dto.setWriter(mr.getParameter("writer"));
    dto.setTitle(mr.getParameter("title")); // [수정] subject -> title
    dto.setContent(mr.getParameter("content"));
    dto.setPw(mr.getParameter("pw"));       // [수정] passwd -> pw
    dto.setIp(request.getRemoteAddr());

    // 답글 관련 파라미터 (새 글일 경우 0으로 전달됨)
    // hidden input 등으로 이 값들이 폼에서 전달된다고 가정합니다.
    int num = mr.getParameter("num") != null ? Integer.parseInt(mr.getParameter("num")) : 0;
    int ref = mr.getParameter("ref") != null ? Integer.parseInt(mr.getParameter("ref")) : 0;
    int re_step = mr.getParameter("re_step") != null ? Integer.parseInt(mr.getParameter("re_step")) : 0;
    int re_level = mr.getParameter("re_level") != null ? Integer.parseInt(mr.getParameter("re_level")) : 0;

    dto.setNum(num);
    dto.setRef(ref);
    dto.setRe_step(re_step);
    dto.setRe_level(re_level);

    // [수정] 파일 이름 처리 로직
    String filename = mr.getFilesystemName("uploadFile"); // <input type="file" name="uploadFile">
    if (filename != null) {
        String fileType = mr.getContentType("uploadFile");
        if (!fileType.startsWith("image")) {
            // 이미지 파일이 아니면 처리 중단 또는 경고
            // 여기서는 파일이름을 null로 만들어 DB에 저장되지 않게 함
            filename = null; 
        }
    }
    dto.setFilename(filename); // DTO에 파일 이름 저장
    
    // [수정] boardnum은 예시입니다. 실제 게시판 종류에 맞게 설정해야 합니다. (예: 1=자유, 2=갤러리)
    dto.setBoardnum(2); 


    // --- 4. DAO를 통한 데이터베이스 작업 ---
    GalleryDAO dao = GalleryDAO.getInstance();
    int result = dao.insertGallery(dto); // [수정] DTO 하나로 모든 정보를 한번에 전달


    // --- 5. 결과에 따른 페이지 이동 ---
    if (result > 0) {
%>
    <script>
        alert("게시글이 성공적으로 등록되었습니다.");
        location.href = "gallery.jsp"; // [수정] 성공 시 목록 페이지로 이동
    </script>
<%
    } else {
%>
    <script>
        alert("게시글 등록에 실패했습니다. 다시 시도해주세요.");
        history.back(); // 이전 페이지(글쓰기 폼)로 돌아가기
    </script>
<%
    }
%>