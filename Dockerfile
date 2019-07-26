FROM phusion/baseimage:0.11
MAINTAINER matyxcz@gmail.com

CMD ["/sbin/my_init"]

RUN echo "Europe/Prague" > /etc/timezone
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
#RUN apt-get upgrade -y

RUN packages=" \
    git \
    mysql-client \
    php7.3 \
    php7.3-curl \
    php7.3-gd \
    php7.3-gettext \
    php7.3-gmp \
    php7.3-iconv \
    php7.3-imap \
    php7.3-intl \
    php7.3-mbstring \
    php7.3-mysqli \
    php7.3-pdo \
    php7.3-sqlite \
    php7.3-soap \
    php7.3-wddx \
    php7.3-xmlrpc \
    php7.3-xsl \
    php7.3-zip \
" && apt-get install -y $packages

RUN phpenmod curl
RUN phpenmod gd
RUN phpenmod gettext
RUN phpenmod gmp
RUN phpenmod iconv
RUN phpenmod imap
RUN phpenmod intl
RUN phpenmod mbstring
RUN phpenmod mcrypt
RUN phpenmod mysqli
RUN phpenmod pdo
RUN phpenmod pdo_mysql
RUN phpenmod pdo_sqlite
RUN phpenmod soap
RUN phpenmod wddx
RUN phpenmod xmlrpc
RUN phpenmod xsl
RUN phpenmod zip

RUN a2enmod rewrite
RUN a2enmod alias

# Install Composer.
ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN ln -fs /dev/stderr /var/log/apache2/error.log
RUN ln -fs /dev/stderr /var/log/apache2/access.log

RUN useradd -ms /bin/bash user
RUN rm -r /var/lib/apt/lists/*

RUN mkdir /etc/service/apache2
COPY apache2.sh /etc/service/apache2/run
RUN chmod a+x /etc/service/apache2/run
COPY sites/000-default.conf /etc/apache2/sites-available/000-default.conf