# =================================================================
# STAGE 1: Build a project with a verified Java 21 + Maven image
# =================================================================
FROM maven:3-eclipse-temurin-21 AS builder

# Set the working directory
WORKDIR /app

# Copy Maven Wrapper files
COPY .mvn/ .mvn
COPY mvnw .
COPY mvnw.cmd .

# Copy the project's pom.xml and source code
COPY pom.xml .
COPY src ./src

# Grant execute permissions and build the project, skipping tests
RUN chmod +x ./mvnw && ./mvnw package -DskipTests

# =================================================================
# STAGE 2: Create the final, lightweight runtime image
# =================================================================
FROM eclipse-temurin:21-jre

# Set the working directory
WORKDIR /app

# Copy the built JAR from the builder stage
# IMPORTANT: Replace 'm4-news-1.0-SNAPSHOT.jar' with your actual JAR file name
COPY --from=builder /app/target/m4-news-1.0-SNAPSHOT.jar app.jar

# Expose the port the application will run on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
