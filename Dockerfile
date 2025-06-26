# 1. 베이스 이미지 선택 (자바 17 실행 환경이 설치된 미니 컴퓨터)
FROM eclipse-temurin:21-jdk-jammy

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. 빌드된 .jar 파일을 미니 컴퓨터 안으로 복사
#    'm4-news-1.0-SNAPSHOT.jar' 부분을 실제 파일 이름으로 바꿔주세요!
COPY target/m4-news-1.0-SNAPSHOT.jar app.jar

# 4. Render가 사용할 포트 번호를 외부에 알림
EXPOSE 8080

# 5. 이 미니 컴퓨터가 시작될 때 실행할 명령어
CMD ["java", "-jar", "app.jar"]