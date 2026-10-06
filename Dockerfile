FROM tomcat:10.1-jdk17

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY target/smart-campus-incident.war /usr/local/tomcat/webapps/smart-campus-incident.war

CMD ["catalina.sh", "run"]