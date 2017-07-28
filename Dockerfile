FROM alpine:3.6

MAINTAINER Laurent RICHARD "easylo@gmail.com"

RUN apk update && apk upgrade && \
    apk add --no-cache bash supervisor coreutils git mysql-client libmcrypt libmcrypt-dev curl wget \
    freetype-dev libpng-dev libjpeg-turbo-dev

RUN apk add ca-certificates  curl ssmtp php7 php7-phar php7-curl \
    php7-fpm php7-json php7-zlib php7-xml php7-dom php7-ctype php7-opcache php7-zip php7-iconv \
    php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-pdo_pgsql php7-mbstring php7-session \
    php7-gd php7-mcrypt php7-openssl php7-sockets php7-posix php7-ldap php7-simplexml php7-gd php7-opcache php7-mysqli php7-mysqlnd && \
    rm -rf /var/cache/apk/* 
    # && \
    # rm -f /etc/php7/php-fpm.d/www.conf && \
    # touch /etc/php7/php-fpm.d/env.conf
  
RUN mkdir -p /usr/local/etc/php/conf.d/
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY conf/php/www.conf /etc/php7/php-fpm.d/www.conf


COPY supervisor/ /etc/supervisor/conf.d/

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]