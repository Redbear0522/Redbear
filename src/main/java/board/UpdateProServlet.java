package board;

import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

@WebServlet("/gallery/updatePro")
@MultipartConfig
public class UpdateProServlet extends HttpServlet {
    private Cloudinary cloudinary;
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
            Map upload = cloudinary.uploader()
                         .upload(filePart.getInputStream().readAllBytes(),
                                 ObjectUtils.emptyMap());
            imageUrl = (String) upload.get("secure_url");
        }

        // DTO 조립
        GalleryDTO dto = new GalleryDTO();
        dto.setNum    (Integer.parseInt(req.getParameter("num")));
        dto.setTitle  (req.getParameter("title"));
        dto.setContent(req.getParameter("content"));
        dto.setPw     (req.getParameter("pw"));
        if (imageUrl != null) dto.setImage(imageUrl);

        // DB 반영
        int updated = GalleryDAO.getInstance().updateGallery(dto);
        if (updated == 1) {
            resp.sendRedirect(req.getContextPath() + "/views/gallery/gallery.jsp?pageNum=" 
                             + req.getParameter("pageNum"));
        } else {
            resp.setContentType("text/html; charset=UTF-8");
            resp.getWriter().println("<script>"
                + "alert('비밀번호가 틀렸거나 수정 실패');"
                + "history.back();"
                + "</script>");
        }
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/plain; charset=UTF-8");
        resp.getWriter().println("UpdateProServlet 연결 OK");
        
    }
    
    
}
