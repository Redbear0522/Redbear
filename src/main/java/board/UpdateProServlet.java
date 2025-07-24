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
            try {
                // 파일 크기 제한 체크 (예: 10MB)
                if (filePart.getSize() > 10 * 1024 * 1024) {
                    throw new ServletException("파일 크기가 10MB를 초과할 수 없습니다.");
                }
                
                // 파일 타입 체크
                String contentType = filePart.getContentType();
                if (!contentType.startsWith("image/")) {
                    throw new ServletException("이미지 파일만 업로드할 수 있습니다.");
                }

                // 파일을 Cloudinary에 업로드하고 이미지 URL을 받아옵니다.
                byte[] bytes = filePart.getInputStream().readAllBytes();
                Map<?,?> uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.emptyMap());
                imageUrl = (String) uploadResult.get("secure_url");
            } catch (IOException e) {
                throw new ServletException("파일 업로드 중 오류가 발생했습니다.", e);
            } catch (RuntimeException e) {
                throw new ServletException("Cloudinary 업로드 중 오류가 발생했습니다.", e);
            }
        }

        // 폼 데이터를 검증하고 DTO 객체에 저장합니다.
        String numStr = req.getParameter("num");
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String password = req.getParameter("pw");

        // 필수 입력값 검증
        if (numStr == null || title == null || content == null || password == null) {
            throw new ServletException("필수 입력값이 누락되었습니다.");
        }

        // 제목과 내용의 길이 검증
        if (title.length() < 1 || title.length() > 100) {
            throw new ServletException("제목은 1자 이상 100자 이하여야 합니다.");
        }
        if (content.length() < 1 || content.length() > 2000) {
            throw new ServletException("내용은 1자 이상 2000자 이하여야 합니다.");
        }

        GalleryDTO dto = new GalleryDTO();
        try {
            dto.setNum(Integer.parseInt(numStr));
        } catch (NumberFormatException e) {
            throw new ServletException("잘못된 글 번호입니다.");
        }
        dto.setTitle(title);
        dto.setContent(content);
        dto.setPw(password);
        
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
            // 업데이트 실패 시 상세한 에러 메시지와 함께 이전 페이지로 돌아갑니다.
            resp.setContentType("text/html; charset=UTF-8");
            resp.getWriter().println("<script>");
            resp.getWriter().println("alert('수정에 실패했습니다.\\n" +
                                   "- 비밀번호를 확인해주세요.\\n" +
                                   "- 존재하지 않는 게시물일 수 있습니다.\\n" +
                                   "- 일시적인 오류일 수 있으니 잠시 후 다시 시도해주세요.');");
            resp.getWriter().println("history.back();");
            resp.getWriter().println("</script>");
        }
    }
}