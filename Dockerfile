FROM php:5.6-apache

# Dependencies
RUN apt-get -y update && apt-get -y install \
    libpng12-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    automake \
    libmemcached-dev \
    libmcrypt-dev \
    unixODBC-dev

# PHP extensions
RUN docker-php-ext-install \
    bcmath \
    gd \
    mysql \
    mysqli \
    #mysqlnd \
    pdo \
    pdo_mysql \
    # pdo_pgsql -- not installing
    # pdo_sqlite -- not installing
    # pgsql -- not installing
    soap

# Magic from https://github.com/docker-library/php/issues/103
RUN set -x \
    && docker-php-source extract odbc \
    && cd /usr/src/php/ext/odbc \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && ./configure --with-unixODBC=shared,/usr \
    && docker-php-ext-install odbc

# PECL extensions
RUN pecl install \
    igbinary \
    imagick \
    memcached

# Add extensions to include dir
RUN echo -e "extension=memcached.so\nextension=igbinary.so\nextension=imagick.so" >> /usr/local/etc/php/conf.d/thirdparty.ini
