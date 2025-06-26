# ===== 빌드 스테이지 =====
FROM maven:3.8.7-eclipse-temurin-17-jammy AS builder
WORKDIR /app

# 의존성만 먼저 내려받아 캐시 활용
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스코드 복사 및 패키징
COPY src ./src
RUN mvn package -DskipTests -B

# ===== 실행 스테이지 =====
FROM tomcat:9.0-jdk17-openjdk-slim
WORKDIR /usr/local/tomcat/webapps

# 빌드된 WAR를 ROOT.war로 복사
COPY --from=builder /app/target/app.war ROOT.war

# Render가 매핑하는 포트
EXPOSE 8080

# Tomcat 기동
CMD ["catalina.sh", "run"]
