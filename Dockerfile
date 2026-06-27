# ----------------------------------------------------
# Stage 1: Build the Spring Boot application
# ----------------------------------------------------

# Use Maven with Eclipse Temurin JDK 17 as the build environment
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project configuration file
COPY app/pom.xml .

# Copy the application source code
COPY app/src ./src

# Build the application and create the executable JAR file
# Skip running unit tests to speed up the build process
RUN mvn clean package -DskipTests

# ----------------------------------------------------
# Stage 2: Create the runtime image
# ----------------------------------------------------

# Use a lightweight Eclipse Temurin Java 17 Runtime Environment (JRE)
FROM eclipse-temurin:17.0.15_6-jre

# Set the working directory inside the runtime container
WORKDIR /app

# Copy the generated JAR file from the builder stage
COPY --from=builder /app/target/back-end-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080 so the Spring Boot application can receive HTTP requests
EXPOSE 8080

# Command executed when the container starts
# Launches the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
