# =================================================================
# 1단계: 빌드용 환경 (Builder)
# Maven과 JDK가 설치된 환경에서 우리 프로젝트를 빌드합니다.
# =================================================================
FROM eclipse-temurin:17-jdk-jammy AS builder

# 작업 폴더를 /app으로 지정
WORKDIR /app

# Maven Wrapper 파일들을 먼저 복사
COPY .mvn/ .mvn
COPY mvnw .
COPY mvnw.cmd .

# pom.xml 파일과 소스코드 전체를 복사
COPY pom.xml .
COPY src ./src

# Maven Wrapper에 실행 권한을 부여하고, 테스트는 건너뛰고 빠르게 빌드
RUN chmod +x ./mvnw && ./mvnw package -DskipTests


# =================================================================
# 2단계: 최종 실행용 환경 (Runner)
# 딱 필요한 자바 실행 환경(JRE)만 있는 가벼운 환경입니다.
# =================================================================
FROM eclipse-temurin:17-jre-jammy

# 작업 폴더를 /app으로 지정
WORKDIR /app

# --- 가장 중요한 부분 ---
# 1단계(builder)에서 빌드된 .jar 파일을 지금 환경으로 복사해옵니다.
# 'm4-news-1.0-SNAPSHOT.jar' 부분을 실제 파일 이름으로 바꿔주세요!
COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.jar app.jar

# Render에게 8080 포트를 사용한다고 알림
EXPOSE 8080

# 최종적으로 실행할 명령어
CMD ["java", "-jar", "app.jar"]