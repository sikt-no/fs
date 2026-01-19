FROM nginx:alpine

# Add the Playwright HTML report
COPY tester/playwright-report/ /usr/share/nginx/html/

# Simple nginx config for serving static files
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    location / { \
        autoindex on; \
    } \
}' > /etc/nginx/conf.d/default.conf
