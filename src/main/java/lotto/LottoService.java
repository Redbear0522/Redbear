package lotto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.stream.Collectors;

public class LottoService {

    private final Set<Set<Integer>> pastWinningNumbersSet;

    public LottoService(List<List<Integer>> loadedNumbers) {
        this.pastWinningNumbersSet = loadedNumbers.stream()
                                                  .map(HashSet::new)
                                                  .collect(Collectors.toSet());
    }

    public List<Integer> generateFilteredLottoNumbers() {
        while (true) {
            Set<Integer> numberSet = generateSingleSet();
            //if (isPastWinner(numberSet)) continue;

            List<Integer> sortedNumbers = new ArrayList<>(numberSet);
            Collections.sort(sortedNumbers);

           // if (hasTooManyConsecutive(sortedNumbers, 4)) continue;
            //if (!isValidSum(sortedNumbers, 100, 180)) continue;
           // if (!isValidEvenOddRatio(sortedNumbers)) continue;
            
            return sortedNumbers;
        }
    }
    

    private Set<Integer> generateSingleSet() {
        Set<Integer> numberSet = new HashSet<>();
        Random random = new Random();
        while (numberSet.size() < 6) {
            numberSet.add(random.nextInt(45) + 1);
        }
        return numberSet;
    }

    private boolean isPastWinner(Set<Integer> numberSet) {
        return this.pastWinningNumbersSet.contains(numberSet);
    }
    
    private boolean hasTooManyConsecutive(List<Integer> numbers, int maxCount) {
        if (numbers.size() < maxCount) return false;
        int consecutiveCount = 1;
        for (int i = 1; i < numbers.size(); i++) {
            if (numbers.get(i) == numbers.get(i - 1) + 1) {
                consecutiveCount++;
            } else {
                consecutiveCount = 1;
            }
            if (consecutiveCount >= maxCount) return true;
        }
        return false;
    }

    private boolean isValidSum(List<Integer> numbers, int min, int max) {
        int sum = numbers.stream().mapToInt(Integer::intValue).sum();
        return sum >= min && sum <= max;
    }
    
    private boolean isValidEvenOddRatio(List<Integer> numbers) {
        long evenCount = numbers.stream().filter(n -> n % 2 == 0).count();
        return evenCount > 0 && evenCount < 6;
    }
    public static void main(String[] args) {
    	System.out.println("새 번호 생성 시도...");
	}
}