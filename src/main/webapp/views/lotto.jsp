<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>로또번호 추천
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/redbear_resources/theme.css">
    <style>
        .lotto-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        #generateBtn {
            background-color: #66bb6a;
            color: white;
            border: none;
            cursor: pointer;
            padding: 15px 30px;
            font-size: 1.2rem;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }
        #generateBtn:hover {
            background-color: #4caf50;
        }
        .result-area {
            margin-top: 30px;
            padding: 20px;
            background: #e9f8ef;
            border-radius: 8px;
            min-height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .lotto-numbers {
            display: flex;
            gap: 15px;
        }
        .lotto-ball {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: #ffc107;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.8rem;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .loading-text {
            font-size: 1.1rem;
            color: #2e7d32;
        }
    </style>
</head>
<body>
<%@ include file="/resources/header/header.jsp"%>
      <div class="lotto-container">
        <h1>로또 번호 필터링 추천</h1>
        <p>과거 당첨 데이터 기반, 확률 낮은 조합을 제외한 번호를 추천합니다.</p>
        <button id="generateBtn">추천 번호 받기</button>

        <div class="result-area">
            <div id="lottoResult" class="loading-text">버튼을 눌러 추천 번호를 확인하세요.</div>
        </div>
    </div>

<script>
    document.getElementById('generateBtn').addEventListener('click', function() {
        const resultDiv = document.getElementById('lottoResult');
        resultDiv.innerHTML = '<div class="loading-text">최적의 번호를 찾는 중...</div>';
        
        const contextPath = "${pageContext.request.contextPath}";
        fetch(`${contextPath}/lotto/generate`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('네트워크 응답이 올바르지 않습니다.');
                }
                return response.json();
            })
            .then(numbers => {
                resultDiv.innerHTML = '';
                const numberContainer = document.createElement('div');
                numberContainer.className = 'lotto-numbers';

                numbers.forEach(num => {
                    const ball = document.createElement('div');
                    ball.className = 'lotto-ball';
                    ball.textContent = num;
                    numberContainer.appendChild(ball);
                });
                resultDiv.appendChild(numberContainer);
            })
            .catch(error => {
                console.error('번호 생성 중 오류 발생:', error);
                resultDiv.innerHTML = '<div class="loading-text" style="color: red;">번호 생성에 실패했습니다. 잠시 후 다시 시도해주세요.</div>';
            });
    });
    console.log("Context path:", contextPath);
</script>
<%@ include file="/resources/footer/footer.jsp"%>

<!-- JS Script -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>