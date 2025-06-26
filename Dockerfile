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
RUN chmod +x ./mvnw && ./mvnw package -DskipTests

# =================================================================
# STAGE 2: Run the application
# =================================================================
FROM tomcat:9.0-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
