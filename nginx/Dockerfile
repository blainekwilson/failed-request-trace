FROM openresty/openresty:alpine

LABEL maintainer="FailedRequestTrace"
LABEL description="FailedRequestTrace - Cloud-native request diagnostic tool for OpenResty/NGINX"

# Install additional packages
RUN apk add --no-cache \
    curl \
    bash \
    libcap

# Create a non-root nginx user/group and set permissions for nginx runtime directories
RUN addgroup -S nginx \
  && adduser -S -G nginx -h /var/lib/nginx -s /sbin/nologin nginx \
  && mkdir -p /var/log/nginx /var/run/nginx /usr/share/nginx/html /app/lua \
  && chown -R nginx:nginx /var/log/nginx /var/run/nginx /usr/share/nginx/html /app/lua

# Copy the nginx configuration
COPY nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Copy the sample website
COPY sample_site /usr/share/nginx/html/

# Copy the Lua modules for FailedRequestTrace
COPY lua /app/lua/

# Ensure ownership for runtime directories
RUN chown -R nginx:nginx /var/log/nginx /var/run/nginx /usr/share/nginx/html /app/lua

# Switch to non-root user
USER nginx

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Expose internal port (8080 for non-root, mapped to 80 at runtime)
EXPOSE 8080

# Start OpenResty
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
