# =================================================================
# STAGE 1: Build the .war file and download webapp-runner
# =================================================================
FROM maven:3-eclipse-temurin-21 AS builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw .
COPY mvnw.cmd .
COPY pom.xml .
COPY src ./src
# 'package'를 실행하면 .war 파일 생성과 webapp-runner.jar 다운로드가 모두 실행됨
RUN ./mvnw package

# =================================================================
# STAGE 2: Run the application
# =================================================================
FROM eclipse-temurin:21-jre
WORKDIR /app

# 1단계에서 빌드된 target 폴더 전체를 복사
COPY --from=builder /app/target /app/target

# Render가 제공하는 포트를 사용하도록 설정
EXPOSE 8080
ENV PORT 8080

# webapp-runner.jar를 사용해 .war 파일을 실행
# java -jar [러너 경로] [실행할 war 파일 경로]
CMD ["java", "-jar", "target/dependency/webapp-runner.jar", "target/m4-news-1.0-SNAPSHOT.war"]
