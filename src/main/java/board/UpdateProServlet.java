package board;
import java.util.Map;
import java.util.HashMap;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

	//@WebServlet("/gallery/updatePro")
	//@MultipartConfig
	//public class UpdateProServlet extends HttpServlet {
	//    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        String url = System.getenv("CLOUDINARY_URL");
        if (url == null) throw new ServletException("CLOUDINARY_URL 미설정");
        cloudinary = new Cloudinary(url);
        cloudinary.config.secure = true;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Part filePart = req.getPart("upfile");
        String imageUrl = null;
        if (filePart != null && filePart.getSize() > 0) {
            byte[] bytes = filePart.getInputStream().readAllBytes();
            Map<?,?> upload = cloudinary.uploader()
                            .upload(bytes, ObjectUtils.emptyMap());
            imageUrl = (String) upload.get("secure_url");
        }

        GalleryDTO dto = new GalleryDTO();
        dto.setNum(Integer.parseInt(req.getParameter("num")));
        dto.setTitle(req.getParameter("title"));
        dto.setContent(req.getParameter("content"));
        dto.setPw(req.getParameter("pw"));
        if (imageUrl != null) {
            dto.setImage(imageUrl);
        }

        int updated = GalleryDAO.getInstance().updateGallery(dto);
        if (updated == 1) {
            String pageNum = req.getParameter("pageNum");
            resp.sendRedirect(req.getContextPath() + "/gallery/list?pageNum=" + pageNum);
        } else {
            resp.setContentType("text/html; charset=UTF-8");
            resp.getWriter().println("<script>"
                + "alert('비밀번호가 틀렸거나 수정 실패');"
                + "history.back();"
                + "</script>");
        }
    }
}
