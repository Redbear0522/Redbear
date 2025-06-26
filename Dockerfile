# =================================================================
# STAGE 1: Build the application using the image's built-in Maven
# =================================================================
FROM maven:3-eclipse-temurin-21 AS builder

# Set the working directory
WORKDIR /app

# Copy only the essential files: pom.xml and the src folder
COPY pom.xml .
COPY src ./src

# Run the build directly with the 'mvn' command. No more mvnw!
# This is cleaner and more reliable inside Docker.
RUN mvn package -DskipTests

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
