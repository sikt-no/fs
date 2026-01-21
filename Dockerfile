FROM nginx:alpine

# Add the Playwright HTML report at root
COPY tester/playwright-report/ /usr/share/nginx/html/

# Add the Allure report at /allure
COPY tester/allure-report/ /usr/share/nginx/html/allure/

# nginx config for serving both reports
RUN echo 'server { \
    listen 80; \
    root /usr/share/nginx/html; \
    location / { \
        autoindex on; \
    } \
    location /allure/ { \
        autoindex on; \
    } \
}' > /etc/nginx/conf.d/default.conf
