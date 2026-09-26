FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY Lavalink.jar application.yml ./
EXPOSE 80
CMD ["java", "-jar", "Lavalink.jar"]
