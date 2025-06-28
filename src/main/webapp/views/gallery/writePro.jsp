<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 한글 파라미터 인코딩
    request.setCharacterEncoding("UTF-8");
    // 파일 업로드는 WriteProServlet이 처리하게 포워드
    getServletContext()
      .getRequestDispatcher("/gallery/writePro")
      .forward(request, response);
%>
