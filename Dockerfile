FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
		apache2 \
		curl \
		software-properties-common \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN LC_ALL=fr_CH.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y --no-install-recommends \
		libapache2-mod-php7.4 \
		php7.4 \
		php7.4-common \
		php7.4-mysql \
		php7.4-xml \
		php7.4-xmlrpc \
		php7.4-curl \
		php7.4-gd \
		php7.4-imagick \
		php7.4-cli \
		php7.4-dev \
		php7.4-imap \
		php7.4-mbstring \
		php7.4-opcache \
		php7.4-soap \
		php7.4-zip \
		php7.4-intl \
		php7.4-bcmath \
		php7.4-pgsql \
		php7.4-pspell \
		php-apcu \
		php-memcached \
		php-pear \
		php-redis \
		php-xdebug \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN a2enmod php7.4
RUN a2enmod rewrite

RUN a2dissite 000-default.conf

RUN curl -sS https://getcomposer.org/installer | php -- \ --install-dir=/usr/bin --filename=composer

RUN apt-get update && apt-get install -y vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "xdebug.profiler_enable=1" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.remote_enable=1" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.profiler_enable=1" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.remote_mode=req" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.remote_host=host.docker.internal" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.remote_port=9001" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.remote_autostart=1" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.remote_connect_back=1" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini; \
    echo "xdebug.idekey=PHPSTORM" >> /etc/php/7.4/apache2/conf.d/20-xdebug.ini;


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2a
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
