# STAGE 1: Build the WAR file
FROM maven:3-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# STAGE 2: Run the application using Jetty Runner
FROM eclipse-temurin:21-jre
WORKDIR /app

# Jetty 공식 실행기(Runner)를 직접 다운로드합니다.
RUN apt-get update && apt-get install -y curl && \
    curl -L -o jetty-runner.jar https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-runner/11.0.20/jetty-runner-11.0.20.jar

# 1단계에서 빌드된 .war 파일을 복사합니다.
COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.war .

# 포트를 설정합니다.
EXPOSE 8080
ENV PORT 8080

# Jetty Runner로 .war 파일을 실행합니다.
CMD ["java", "-jar", "jetty-runner.jar", "m4-news-1.0-SNAPSHOT.war"]
