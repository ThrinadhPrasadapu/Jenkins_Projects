# Use Tomcat as the base image
FROM tomcat:9.0

# Remove default Tomcat web apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into the Tomcat webapps folder
COPY target/*.war /usr/local/tomcat/webapps/mywebapp.war

# Expose port 8080 for web access
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

