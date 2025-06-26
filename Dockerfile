# STAGE 1: Build the .war and copy webapp-runner via Maven
FROM maven:3-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
# 'package' goal will build the .war and trigger the dependency:copy
RUN mvn package -DskipTests

# STAGE 2: Run the application
FROM eclipse-temurin:21-jre
WORKDIR /app

# 1단계에서 빌드된 webapp-runner.jar를 복사
COPY --from=builder /app/target/dependency/webapp-runner.jar .
# 1단계에서 빌드된 .war 파일을 복사
COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.war .

EXPOSE 8080
ENV PORT 8080

# webapp-runner로 .war 파일을 실행
CMD ["java", "-jar", "webapp-runner.jar", "m4-news-1.0-SNAPSHOT.war"]
