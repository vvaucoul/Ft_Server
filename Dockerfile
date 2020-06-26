# FT_SERVER DOCKERFILE #
FROM debian:buster
MAINTAINER Vincent Vaucouleur <vvaucoul@student.42.fr>

# ----- INIT START CONTAINER ----- #

# Update debian
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y procps
RUN apt-get install -y emacs
RUN apt-get install -y wget
RUN apt-get install -y openssl
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt install -y libbz2-1.0

# Install requiered services
RUN apt install -y nginx
RUN apt install -y mariadb-server
RUN apt-get install -y php
RUN apt-get install -y php-cli php-fpm php-cgi
RUN apt-get install -y php-mysql
RUN apt-get install -y php-mbstring

# Update packages
RUN apt-get update
RUN apt-get -y upgrade

# Copy all Services
COPY srcs/nginx.conf /tmp/nginx.conf
COPY srcs/phpmyadmin.inc.php /tmp/phpmyadmin.inc.php
COPY srcs/wp-config.php /tmp/wp-config.php
COPY srcs/datatable.sql /tmp/datatable.sql

# Expose http & https
EXPOSE 80
EXPOSE 443

# -------------------------------- #

# ----- INIT DEBIAN CONTAINER ----- #

# --- CONFIG --- #

# Configuration Access
RUN chown -R www-data /var/www/*
RUN chmod -R 755 /var/www/*

# Create Website Folder & Website files
RUN mkdir /var/www/website
RUN touch /var/www/website/index.php
RUN echo "<?php phpinfo(); ?>" >> /var/www/website/index.php

# --- NGINX --- #

# Nginx configuration
RUN mv /tmp/nginx.conf /etc/nginx/sites-available/website
# Autoindex line (remove this line to disable it)
RUN ln -s /etc/nginx/sites-available/website /etc/nginx/sites-enabled/website
RUN rm -rf /etc/nginx/sites-enabled/default

# --- SSL --- #

# SSL
RUN mkdir /etc/nginx/ssl

# Generate Autosigned SSL KEY
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/website.pem -keyout /etc/nginx/ssl/website.key -subj "/C=FR/ST=FRANCE/L=Paris/O=42 School/OU=vvaucoul/CN=website"

# --- WORDPRESS --- #

# - Wordpress
RUN cd /tmp/
RUN wget -c https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress/* /var/www/website/
RUN mv /tmp/wp-config.php /var/www/website/

# --- PHPMYADMIN --- #

# - PHPmyadmin
RUN mkdir /var/www/website/phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/website/phpmyadmin
RUN mv /tmp/phpmyadmin.inc.php /var/www/website/phpmyadmin/config.inc.php


# --- SERVICES --- #

# Start services and put datatable then start bash

ENTRYPOINT service mysql start && \
service php7.3-fpm start && \
nginx -t && \
service nginx start && mariadb < /tmp/datatable.sql && \
bash

# --------------------------------- #
