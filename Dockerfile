FROM openjdk:8-jdk-alpine
COPY target/spring-boot-docker-compose.jar spring-boot-docker-compose.jar
ENTRYPOINT ["java","-jar","/spring-boot-docker-compose.jar"]
