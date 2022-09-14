FROM tomcat:9.0.65-jre17-temurin-jammy

EXPOSE 8080

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ./build/libs/spring-boot.war /usr/local/tomcat/webapps

#CMD ["catalina.sh", "run"]
CMD ["java", "-jar", "/usr/local/tomcat/webapps/spring-boot.war"]

