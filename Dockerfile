# Use the official Nginx image as base
FROM nginx:latest

# Install inotify-tools for file monitoring
RUN apt-get update && apt-get install -y inotify-tools

# Copy the initial routes.trp file
COPY routes.trp /etc/nginx/routes.trp

# Copy the nginx configuration file with dynamic routing
COPY nginx.conf /etc/nginx/nginx.conf

COPY util.sh /etc/nginx/util.sh
RUN chmod +x /etc/nginx/util.sh

COPY config_checker.sh /etc/nginx/config_checker.sh
RUN chmod +x /etc/nginx/config_checker.sh

# Copy the script for monitoring and updating nginx configuration
COPY watch_routes.sh /usr/local/bin/watch_routes.sh
RUN chmod +x /usr/local/bin/watch_routes.sh

# Expose ports
EXPOSE 80
EXPOSE 443

# Start Nginx and monitoring script
CMD ["sh", "-c", "nginx && watch_routes.sh"]
