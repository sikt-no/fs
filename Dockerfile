FROM nginx:alpine

# Install bash for entrypoint script
RUN apk add --no-cache bash

# Copy reports to staging directory (will be deployed to persistent volume on startup)
COPY reports/ /reports-staging/

# Copy entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# nginx config for serving reports with no-cache headers and directory listing
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    add_header Cache-Control "no-cache, no-store, must-revalidate"; \
    add_header Pragma "no-cache"; \
    add_header Expires "0"; \
    location / { \
        autoindex on; \
    } \
}' > /etc/nginx/conf.d/default.conf

ENTRYPOINT ["/entrypoint.sh"]
