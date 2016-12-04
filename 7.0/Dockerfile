FROM ywfwj2008/dependent:latest
MAINTAINER ywfwj2008 <ywfwj2008@163.com>

ENV PHP_INSTALL_DIR=/usr/local/php \
    PHP_VERSION=7.0.13 \
    IMAGICK_PECL_VERSION=3.4.3RC1 \
    MEMCACHE_PECL_VERSION=3.0.8 \
    LIBMEMCACHED_VERSION=1.0.18 \
    MEMCACHED_PECL_VERSION=2.2.0 \
    REDIS_PECL_VERSION=2.2.8 \
    SWOOLE_VERSION=1.9.0 \
    REMOTE_PATH=https://github.com/ywfwj2008/docker-php/raw/master

WORKDIR /tmp

# install php
RUN wget -c --no-check-certificate http://www.php.net/distributions/php-$PHP_VERSION.tar.gz && \
    tar xzf php-$PHP_VERSION.tar.gz && \
    cd php-$PHP_VERSION && \
    ./buildconf --force && \
    ./configure --prefix=$PHP_INSTALL_DIR --with-config-file-path=$PHP_INSTALL_DIR/etc \
        --with-config-file-scan-dir=$PHP_INSTALL_DIR/etc/php.d \
        --with-fpm-user=$RUN_USER --with-fpm-group=$RUN_USER --enable-fpm \
        --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
        --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib \
        --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-exif \
        --enable-sysvsem --enable-inline-optimization --with-curl=/usr/local --enable-mbregex \
        --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl \
        --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-ftp --enable-intl --with-xsl \
        --with-gettext --enable-zip --enable-soap --disable-ipv6 --disable-debug && \
    make ZEND_EXTRA_LIBS='-liconv' && \
    make install && \
    mkdir -p $PHP_INSTALL_DIR/etc/php.d && \
    /bin/cp php.ini-production $PHP_INSTALL_DIR/etc/php.ini && \
    /bin/cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && \
    chmod +x /etc/init.d/php-fpm && \
    rm -rf /tmp/*

# run install script
ADD ${REMOTE_PATH}/install.sh /tmp/install.sh
RUN chmod 777 install.sh && \
    bash install.sh && \
    rm -rf /tmp/*

# install composer
RUN curl -sS https://getcomposer.org/installer | $PHP_INSTALL_DIR/bin/php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer

# Set the entrypoint script.
ADD $REMOTE_PATH/entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define the default command.
CMD ["bash"]
