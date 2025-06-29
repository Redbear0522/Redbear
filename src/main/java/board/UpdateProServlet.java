package board;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.Map;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

// 서블릿을 '/gallery/updatePro' URL에 매핑하고, 파일 업로드를 활성화합니다.
@WebServlet("/gallery/updatePro")
@MultipartConfig
public class UpdateProServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        // Cloudinary 설정을 초기화합니다.
        String url = System.getenv("CLOUDINARY_URL");
        if (url == null) {
            throw new ServletException("CLOUDINARY_URL 환경 변수가 설정되지 않았습니다.");
        }
        cloudinary = new Cloudinary(url);
        cloudinary.config.secure = true;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 요청 데이터의 문자 인코딩을 UTF-8로 설정합니다.
        req.setCharacterEncoding("UTF-8");

        Part filePart = req.getPart("upfile");
        String imageUrl = null;

        // 새로운 파일이 업로드되었는지 확인합니다.
        if (filePart != null && filePart.getSize() > 0) {
            // 파일을 Cloudinary에 업로드하고 이미지 URL을 받아옵니다.
            byte[] bytes = filePart.getInputStream().readAllBytes();
            Map<?,?> uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.emptyMap());
            imageUrl = (String) uploadResult.get("secure_url");
        }

        // 폼 데이터를 DTO 객체에 저장합니다.
        GalleryDTO dto = new GalleryDTO();
        dto.setNum(Integer.parseInt(req.getParameter("num")));
        dto.setTitle(req.getParameter("title"));
        dto.setContent(req.getParameter("content"));
        dto.setPw(req.getParameter("pw"));
        
        // 새로운 이미지 URL이 있다면 DTO에 설정합니다. (없다면 기존 이미지는 그대로 유지됩니다)
        if (imageUrl != null) {
            dto.setImage(imageUrl);
        }

        // DAO를 통해 데이터베이스 업데이트를 시도합니다.
        int updated = GalleryDAO.getInstance().updateGallery(dto);

        if (updated == 1) {
            // 업데이트 성공 시, 원래 있던 페이지로 리다이렉트합니다.
            String pageNum = req.getParameter("pageNum");
            resp.sendRedirect(req.getContextPath() + "/gallery/list?pageNum=" + pageNum);
        } else {
            // 업데이트 실패 시 (비밀번호 오류 등), 알림창을 띄우고 이전 페이지로 돌아갑니다.
            resp.setContentType("text/html; charset=UTF-8");
            resp.getWriter().println("<script>");
            resp.getWriter().println("alert('비밀번호가 틀렸거나 수정에 실패했습니다.');");
            resp.getWriter().println("history.back();");
            resp.getWriter().println("</script>");
        }
    }
}