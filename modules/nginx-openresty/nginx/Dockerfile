FROM openresty/openresty:alpine

LABEL maintainer="FailedRequestTrace"
LABEL description="FailedRequestTrace - Cloud-native request diagnostic tool for OpenResty/NGINX"

RUN apk add --no-cache \
    curl \
    bash

RUN addgroup -S nginx \
  && adduser -S -G nginx -h /var/lib/nginx -s /sbin/nologin nginx \
  && mkdir -p \
      /usr/local/openresty/nginx/client_body_temp \
      /usr/local/openresty/nginx/proxy_temp \
      /usr/local/openresty/nginx/fastcgi_temp \
      /usr/local/openresty/nginx/uwsgi_temp \
      /usr/local/openresty/nginx/scgi_temp \
      /usr/local/openresty/nginx/logs \
      /var/run/nginx \
      /var/lib/nginx \
      /usr/share/nginx/html \
      /app/lua \
  && chown -R nginx:nginx \
      /usr/local/openresty/nginx \
      /var/run/nginx \
      /var/lib/nginx \
      /usr/share/nginx/html \
      /app/lua

COPY nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY sample_site /usr/share/nginx/html/
COPY lua /app/lua/

RUN chown -R nginx:nginx \
      /usr/local/openresty/nginx/conf/nginx.conf \
      /usr/share/nginx/html \
      /app/lua

USER nginx

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]