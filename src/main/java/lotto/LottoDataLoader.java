// LottoDataLoader.java
package lotto;

// import java.io.BufferedReader;
// import java.io.FileReader; 
//highlight-start
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
//highlight-end
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader; // BufferedReader는 유지합니다.

public class LottoDataLoader {

    //highlight-start
    // 기존 메소드는 유지하거나 삭제하고 아래 메소드를 추가합니다.
    public static List<List<Integer>> loadPastWinningNumbers() {
        List<List<Integer>> pastNumbers = new ArrayList<>();
        String resourcePath = "/lotto.csv"; // resources 폴더 아래의 파일 경로

        try (InputStream is = LottoDataLoader.class.getResourceAsStream(resourcePath);
             InputStreamReader isr = new InputStreamReader(is, StandardCharsets.UTF_8);
             BufferedReader br = new BufferedReader(isr)) {
    //highlight-end
            String line;
            while ((line = br.readLine()) != null) {
                // ... (이하 로직은 동일)
                String[] parts = line.split(",");
                List<Integer> numbers = new ArrayList<>();

                for (int i = 0; i < Math.min(6, parts.length); i++) {
                    try {
                        numbers.add(Integer.parseInt(parts[i].trim()));
                    } catch (NumberFormatException e) {
                        // 숫자가 아니면 건너뛰기
                    }
                }

                if (numbers.size() == 6) {
                    pastNumbers.add(numbers);
                }
            }
        } catch (IOException | NullPointerException e) { // NullPointerException 추가
            System.out.println("CSV 파일을 읽는 중 오류 발생: " + resourcePath);
            e.printStackTrace();
        }

        return pastNumbers;
    }
    
    // 기존 메소드는 주석 처리하거나 삭제합니다.
    /*
    public static List<List<Integer>> loadPastWinningNumbers(String csvFilePath) {
        ...
    }
    */
}