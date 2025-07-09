package board;

import java.io.IOException;
import java.util.Map; // Map 자료구조를 사용하기 위해 import 합니다.

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.servlet.http.HttpSession;

// Cloudinary 라이브러리에서 필요한 클래스들을 import 합니다.
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

@WebServlet("/gallery/writePro")
@MultipartConfig // 파일 업로드를 처리하는 서블릿이므로 어노테이션은 그대로 유지합니다.
public class WriteProServlet extends HttpServlet {

    // Cloudinary 객체를 저장할 멤버 변수를 선언합니다.
    // 한번만 생성해서 계속 재사용하기 위함입니다.
    private Cloudinary cloudinary;

    /**
     * 서블릿이 처음 생성될 때 딱 한 번만 실행되는 메소드입니다.
     * 여기서 Render 환경 변수에 저장된 Cloudinary 접속 정보를 읽어와
     * Cloudinary 객체를 초기화합니다.
     */
    @Override
    public void init() throws ServletException {
        // Render 대시보드에 설정한 환경 변수 'CLOUDINARY_URL' 값을 가져옵니다.
        String cloudinaryUrl = System.getenv("CLOUDINARY_URL");
        
        // 환경 변수가 설정되지 않았을 경우, 심각한 오류이므로 서버 로그에 메시지를 남깁니다.
        if (cloudinaryUrl == null || cloudinaryUrl.isEmpty()) {
            System.err.println("************************************************************");
            System.err.println("FATAL ERROR: CLOUDINARY_URL 환경 변수가 설정되지 않았습니다!");
            System.err.println("Render 대시보드에서 환경 변수를 설정해주세요.");
            System.err.println("************************************************************");
            return; // 서블릿 초기화를 중단합니다.
        }
        
        // 가져온 URL 정보로 Cloudinary 객체를 생성합니다.
        this.cloudinary = new Cloudinary(cloudinaryUrl);
        // 항상 https:// 로 시작하는 보안 URL을 사용하도록 설정합니다.
        this.cloudinary.config.secure = true; 
        System.out.println("Cloudinary 클라이언트가 성공적으로 초기화되었습니다.");
    }

    /**
     * 글쓰기 폼에서 'post' 방식으로 요청이 올 때마다 실행되는 메소드입니다.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Cloudinary 객체가 초기화되지 않았다면, 에러를 발생시키고 메소드를 종료합니다.
        if (this.cloudinary == null) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cloudinary 서비스가 초기화되지 않았습니다. 서버 로그를 확인해주세요.");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        try {
            // 1. 폼에서 전송된 파일(Part)을 가져옵니다.
            Part filePart = req.getPart("upfile");
            if (filePart == null || filePart.getSize() == 0) {
                // 이 부분은 실제 서비스에서는 "파일을 선택해주세요" 같은 알림을 띄우고
                // 이전 페이지로 돌려보내는 자바스크립트 로직을 추가하면 더 좋습니다.
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "업로드할 파일이 없습니다.");
                return;
            }

            // 2. Cloudinary에 파일을 업로드합니다.
            // uploader().upload() 메소드를 사용하며, 첫 번째 인자로 파일의 데이터(byte[]),
            // 두 번째 인자로 추가 옵션(여기서는 없음)을 전달합니다.
            Map uploadResult = cloudinary.uploader().upload(filePart.getInputStream().readAllBytes(), ObjectUtils.emptyMap());

            // 3. 업로드 결과에서 이미지 URL을 추출합니다.
            // Cloudinary는 업로드 성공 시, 다양한 정보를 Map 형태로 반환합니다.
            // 그 중에서 'secure_url' 키 값에 저장된 URL이 우리가 필요한 주소입니다.
            String imageUrl = (String) uploadResult.get("secure_url");
            System.out.println("Cloudinary에 업로드된 URL: " + imageUrl);

            // 4. 나머지 폼 데이터와 함께 DTO(Data Transfer Object)를 생성합니다.
            GalleryDTO dto = new GalleryDTO();
            HttpSession session = req.getSession(false);
            
            // ★★★★★ 가장 중요한 변경점 ★★★★★
            // DB의 image 컬럼에는 파일명이 아닌, Cloudinary로부터 받은 전체 이미지 URL을 저장합니다.
            dto.setImage(imageUrl);
            
            dto.setWriter((String) session.getAttribute("sname"));
            dto.setTitle(req.getParameter("title"));
            dto.setContent(req.getParameter("content"));
            dto.setPw(req.getParameter("pw"));
            dto.setIp(req.getRemoteAddr());

            // 5. 데이터베이스에 DTO를 저장합니다.
            GalleryDAO.getInstance().insertGallery(dto);

            // 6. 모든 과정이 끝나면 갤러리 목록 페이지로 이동(리다이렉트)시킵니다.
            resp.sendRedirect(req.getContextPath() + "/views/gallery/gallery.jsp");

        } catch (Exception e) {
            System.err.println("Cloudinary 파일 업로드 중 예외 발생!");
            e.printStackTrace();
            // 사용자에게 보여줄 에러 페이지로 이동시키는 것이 좋습니다.
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "파일 업로드 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    }

}