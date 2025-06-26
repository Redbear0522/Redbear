# STAGE 1: Build the WAR file
FROM maven:3-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
# 오직 WAR 파일만 생성합니다.
RUN mvn package -DskipTests

# STAGE 2: Run the application
FROM eclipse-temurin:21-jre

WORKDIR /app

# 확실하게 동작하는 webapp-runner 버전을 인터넷에서 직접 다운로드합니다.
RUN apt-get update && apt-get install -y curl && \
    curl -L -o webapp-runner.jar https://repo1.maven.org/maven2/com/github/jsimone/webapp-runner/9.0.80.0/webapp-runner-9.0.80.0.jar

# 1단계에서 빌드된 .war 파일을 복사합니다.
# 'm4-news-1.0-SNAPSHOT.war' 부분을 실제 빌드된 .war 파일 이름으로 바꿔주세요.
COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.war .

# 포트를 설정합니다.
EXPOSE 8080
ENV PORT 8080

# webapp-runner로 .war 파일을 실행합니다.
CMD ["java", "-jar", "webapp-runner.jar", "m4-news-1.0-SNAPSHOT.war"]
