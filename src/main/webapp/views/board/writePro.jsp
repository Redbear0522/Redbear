<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 인코딩 설정은 가장 위에
    request.setCharacterEncoding("UTF-8");

    // 2. 세션에서 id 가져오기
    String id = (String) session.getAttribute("sid");
    String sname = (String) session.getAttribute("sname");
    if (id == null || sname == null) {
%>
    <script>
        alert("로그인 후 이용해주세요.");
        location.href = "<%= request.getContextPath() %>/views/member/login.jsp";
    </script>
<%
        return;
    }

    // 3. DTO 초기화 및 값 설정
    board.PostDTO dto = new board.PostDTO();
    // jsp:setProperty 대신 직접 세팅 (확실한 제어를 위해)
    dto.setWriter(sname);
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));
    dto.setPw(request.getParameter("pw"));
    dto.setIp(request.getRemoteAddr());
    // 필요하면 re_step, re_level 등도 초기화

    // 4. DAO 호출
    board.PostDAO dao = board.PostDAO.getInstance();
    int result = dao.insertPost(dto);

    if (result > 0) {
%>
    <script>
        alert("글이 등록되었습니다.");
        location.href = "bord.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("글 등록 실패. 다시 시도하세요.");
        history.back();
    </script>
<%
    }
%>
