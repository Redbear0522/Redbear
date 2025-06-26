# =================================================================
# STAGE 1: Build using the container's built-in Maven
# =================================================================
FROM maven:3-eclipse-temurin-21 AS builder
WORKDIR /app

COPY pom.xml .
COPY src ./src


RUN mvn package -DskipTests

# =================================================================
# STAGE 2: Run the application on a Tomcat server
# =================================================================
FROM tomcat:9.0-jdk21-temurin


RUN rm -rf /usr/local/tomcat/webapps/*


COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war


EXPOSE 8080
