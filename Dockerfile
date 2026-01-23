FROM nginx:alpine

# Add the Playwright HTML report at root
COPY tester/playwright-report/ /usr/share/nginx/html/

# Add the Allure report at /allure
COPY tester/allure-report/ /usr/share/nginx/html/allure/

# nginx config for serving both reports with no-cache headers
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    add_header Cache-Control "no-cache, no-store, must-revalidate"; \
    add_header Pragma "no-cache"; \
    add_header Expires "0"; \
    location / { \
        autoindex on; \
    } \
    location /allure/ { \
        autoindex on; \
    } \
}' > /etc/nginx/conf.d/default.conf
