package board;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.servlet.http.HttpSession;

@WebServlet("/gallery/writePro")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB
    maxFileSize       = 5 * 1024 * 1024,  // 5MB
    maxRequestSize    = 10 * 1024 * 1024  // 10MB
)
public class WriteProServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 업로드 디렉터리 준비
        String uploadDir = getServletContext().getRealPath("/uploads");
        Files.createDirectories(Paths.get(uploadDir));

        // 파일 저장
        Part part = req.getPart("upfile");
        String fileName = Paths.get(part.getSubmittedFileName())
                               .getFileName().toString();
        part.write(Paths.get(uploadDir, fileName).toString());

        // DTO 세팅
        GalleryDTO dto = new GalleryDTO();
        HttpSession session = req.getSession(false);
        dto.setWriter((String) session.getAttribute("sname"));
        dto.setTitle(req.getParameter("title"));
        dto.setContent(req.getParameter("content"));
        dto.setPw(req.getParameter("pw"));
        dto.setIp(req.getRemoteAddr());
        dto.setImage(fileName);

        // DB 저장
        GalleryDAO.getInstance().insertGallery(dto);

        // 목록으로 리다이렉트
        resp.sendRedirect(req.getContextPath() + "/views/gallery/gallery.jsp");
    }
}
