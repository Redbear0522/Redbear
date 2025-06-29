<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ page import = "board.GalleryDTO" %>
<%@ page import = "board.GalleryDAO" %>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import="org.apache.commons.fileupload.*,org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.disk.*"%>
<%
  DiskFileItemFactory factory = new DiskFileItemFactory();
  ServletFileUpload upload = new ServletFileUpload(factory);
  Map<String,String> form = new HashMap<>();
  String imageUrl = null;
  for (FileItem item : upload.parseRequest(request)) {
    if (item.isFormField()) {
      form.put(item.getFieldName(), item.getString("UTF-8"));
    } else {
      // 파일 업로드 처리 (cloudinary 로직 재사용)
      imageUrl = uploadToCloudinary(item.getInputStream());
    }
  }
  // DTO에 form.get("title"), form.get("content"), form.get("pw") 등 세팅,
  // dto.setImage(imageUrl) 도 세팅 후
  int updated = GalleryDAO.getInstance().updateGallery(dto);
  // 리다이렉트/스크립트 알림 처리...
%>

<jsp:useBean id="article" scope="page" class="board.GalleryDTO">
<jsp:setProperty name="article" property="*"/>
</jsp:useBean>

<%
	String pageNum = request.getParameter("pageNum");
	GalleryDAO pd = GalleryDAO.getInstance();
	int check = pd.updateGallery(article);
	
	if(check ==1){%>
		<meta http-equiv="Refresh" content="0;url=gallery.jsp?pageNum=<%=pageNum%>">
	<%}else{%>
	<script >
		alert("비밀번호 확인하세요");
		history.go(-1);
	</script>
	<%}%>
	