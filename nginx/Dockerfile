FROM openresty/openresty:alpine

LABEL maintainer="FailedRequestTrace"
LABEL description="FailedRequestTrace - Cloud-native request diagnostic tool for OpenResty/NGINX"

# Install additional packages if needed
RUN apk add --no-cache \
    curl \
    bash

# Copy the nginx configuration
COPY nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Copy the sample website
COPY sample_site /usr/share/nginx/html/

# Copy the Lua modules for FailedRequestTrace
COPY lua /app/lua/

# Create log directory if needed
RUN mkdir -p /var/log/nginx

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Expose HTTP port
EXPOSE 80

# Start OpenResty
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
