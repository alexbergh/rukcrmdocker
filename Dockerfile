FROM httpd:2.4

ENV PHP_VERSION 8.0
ENV PHP_MODULES gd mbstring curl zip xml mysql

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget unzip && \
    docker-php-ext-install ${PHP_MODULES} && \
    docker-php-ext-install mysqli && \
    a2enmod rewrite && \
    a2enmod php8.0 && \
    a2enmod proxy_fcgi setenvif && \
    a2enmod ssl && \
    a2enmod proxy_http && \
    a2enmod proxy_balancer && \
    a2enmod lbmethod_byrequests

RUN mkdir -p /var/www/html/rukovoditel && \
    cd /var/www/html/rukovoditel && \
    wget https://www.rukovoditel.net.ru/download/free/rukovoditel_3.5.2.zip && \
    unzip rukovoditel_3.5.2.zip && \
    rm rukovoditel_3.5.2.zip && \
    mv * /var/www/html/ && \
    chmod -R 777 /var/www/html/backups/ /var/www/html/uploads/ /var/www/html/uploads/attachments/ /var/www/html/uploads/users/ /var/www/html/uploads/images/ /var/www/html/cache/ /var/www/html/log/ && \
    chown -R www-data:www-data /var/www/html/

RUN rm /var/www/html/index.html

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
