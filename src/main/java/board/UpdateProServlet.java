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

@WebServlet("/gallery/updatePro")
@MultipartConfig
public class UpdateProServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
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
        try {
            // 요청 데이터의 문자 인코딩을 UTF-8로 설정합니다.
            req.setCharacterEncoding("UTF-8");
            resp.setContentType("text/html; charset=UTF-8");

            // 폼 데이터 유효성 검사
            String numStr = req.getParameter("num");
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String password = req.getParameter("pw");

            // 필수 파라미터 검사
            if (numStr == null || numStr.trim().isEmpty()) {
                showError(resp, "게시물 번호가 누락되었습니다.");
                return;
            }

            if (title == null || title.trim().isEmpty()) {
                showError(resp, "제목을 입력해주세요.");
                return;
            }

            if (content == null || content.trim().isEmpty()) {
                showError(resp, "내용을 입력해주세요.");
                return;
            }

            if (password == null || password.trim().isEmpty()) {
                showError(resp, "비밀번호를 입력해주세요.");
                return;
            }

            // 게시물 번호 파싱
            int num;
            try {
                num = Integer.parseInt(numStr.trim());
            } catch (NumberFormatException e) {
                showError(resp, "잘못된 게시물 번호입니다.");
                return;
            }

            // 파일 업로드 처리
            String imageUrl = null;
            Part filePart = req.getPart("upfile");
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    // 파일 크기 제한 체크 (10MB)
                    if (filePart.getSize() > 10 * 1024 * 1024) {
                        showError(resp, "파일 크기는 10MB를 초과할 수 없습니다.");
                        return;
                    }

                    // 파일 형식 체크
                    String contentType = filePart.getContentType();
                    if (!contentType.startsWith("image/")) {
                        showError(resp, "이미지 파일만 업로드할 수 있습니다.");
                        return;
                    }

                    // Cloudinary에 업로드
                    byte[] bytes = filePart.getInputStream().readAllBytes();
                    Map<?, ?> uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.emptyMap());
                    imageUrl = (String) uploadResult.get("secure_url");
                } catch (Exception e) {
                    showError(resp, "파일 업로드 중 오류가 발생했습니다.");
                    return;
                }
            }

            // DTO 객체 생성 및 데이터 설정
            GalleryDTO dto = new GalleryDTO();
            dto.setNum(num);
            dto.setTitle(title.trim());
            dto.setContent(content.trim());
            dto.setPw(password);

            if (imageUrl != null) {
                dto.setImage(imageUrl);
            }

            // DAO를 통해 데이터베이스 업데이트
            int updated = GalleryDAO.getInstance().updateGallery(dto);

            if (updated == 1) {
                // 업데이트 성공
                String pageNum = req.getParameter("pageNum");
                if (pageNum == null || pageNum.trim().isEmpty()) {
                    pageNum = "1";
                }
                resp.sendRedirect(req.getContextPath() + "/views/gallery/gallery.jsp?pageNum=" + pageNum);
            } else {
                // 업데이트 실패
                showError(resp, "비밀번호가 틀렸거나 수정 권한이 없습니다.");
            }
        } catch (Exception e) {
            showError(resp, "수정 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    }

    private void showError(HttpServletResponse resp, String message) throws IOException {
        resp.getWriter().println("<script>");
        resp.getWriter().println("alert('" + message + "');");
        resp.getWriter().println("history.back();");
        resp.getWriter().println("</script>");
    }
}