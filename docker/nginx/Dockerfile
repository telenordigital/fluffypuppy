FROM nginx:latest

RUN mkdir -p /etc/nginx/globals && \
    rm -vf /etc/nginx/sites-enabled/* && \
    rm -vf /etc/nginx/sites-available/* && \
    rm -vf /etc/nginx/conf.d/* && \
    rm -vf /usr/share/nginx/html/index.html

COPY nginx.conf /etc/nginx/nginx.conf
COPY htmlglobal.conf /etc/nginx/globals/htmlglobal.conf
COPY fluffypuppy.conf /etc/nginx/sites-enabled/fluffypuppy.conf
