package board;

// import javax.servlet.*; // javax.servlet.http.*에 포함되므로 중복
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;
// import java.util.HashMap; // 현재 코드에서 사용되지 않음
// import java.io.IOException; // 중복
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
// import javax.servlet.http.*; // 중복
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

/*
 * ========================================
 * [수정된 부분]
 * ========================================
 * 1. @WebServlet, @MultipartConfig 어노테이션 주석 해제
 * - @WebServlet: 서블릿을 특정 URL과 매핑합니다. 이 주석이 없으면 서버가 이 서블릿을 인식하지 못합니다.
 * - @MultipartConfig: 파일 업로드(multi-part request)를 처리하기 위해 반드시 필요합니다.
 * 2. 중복되거나 불필요한 import 문 정리
 */
<font color='blue'>@WebServlet("/gallery/updatePro")</font> // [수정] 주석 해제
<font color='blue'>@MultipartConfig</font>               // [수정] 주석 해제
public class UpdateProServlet extends HttpServlet {
	<font color='gray'>//private Cloudinary cloudinary;</font> <font color='blue'>// 아래 내용과 중복되어 삭제</font>
	<font color='blue'>private static final long serialVersionUID = 1L;</font> // [추가] HttpServlet의 경고를 없애기 위한 권장 사항
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