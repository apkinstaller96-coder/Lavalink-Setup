FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY Lavalink.jar application.yml ./
EXPOSE 8000
CMD ["java", "-jar", "Lavalink.jar"]
