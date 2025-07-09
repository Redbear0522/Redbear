package lotto;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/lotto/generate")
public class LottoGeneratorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private LottoService lottoService;
    private final Gson gson = new Gson();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ServletContext context = config.getServletContext();
        String csvFilePath = context.getRealPath("/WEB-INF/lotto.csv");
        System.out.println("CSV 파일 경로: " + csvFilePath); // 디버깅용 로그
        List<List<Integer>> loadedNumbers = LottoDataLoader.loadPastWinningNumbers();
        System.out.println("로드된 과거 당첨 번호 개수: " + loadedNumbers.size());
        this.lottoService = new LottoService(loadedNumbers);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Integer> lottoNumbers = lottoService.generateFilteredLottoNumbers();
        String jsonResponse = gson.toJson(lottoNumbers);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }
    
}