FROM openjdk:8
WORKDIR /home/ec2-user/soccer-stats
COPY target/soccer-stats-0.0.2.war soccer-stats-0.0.2.war
COPY pom.xml pom.xml
COPY maven-entrypoint.sh maven-entrypoint.sh
RUN chmod +x maven-entrypoint.sh
ENTRYPOINT ["./maven-entrypoint.sh"]
