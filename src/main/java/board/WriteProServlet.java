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
        req.setCharacterEncoding("UTF-8");

        // 1. 게시글 정보 먼저 INSERT (GalleryDTO, GalleryDAO)
        GalleryDTO dto = new GalleryDTO();
        // ... dto에 setTitle, setContent 등 값 채우기
        int newNum = GalleryDAO.getInstance().insertGallery(dto); // num 리턴받게 수정 필요

        // 2. 여러 파일 받아서 각각 Cloudinary 업로드 후 gallery_image 테이블에 insert
        Collection<Part> fileParts = req.getParts();
        for (Part part : fileParts) {
            if ("upfile".equals(part.getName()) && part.getSize() > 0) {
                byte[] bytes = part.getInputStream().readAllBytes();
                Map uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.emptyMap());
                String imageUrl = (String) uploadResult.get("secure_url");

                // 여기서 이미지 테이블에 insert
                GalleryImageDAO.getInstance().insertImage(newNum, imageUrl);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/views/gallery/gallery.jsp");
    }
}