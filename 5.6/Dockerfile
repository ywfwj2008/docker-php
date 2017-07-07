FROM ywfwj2008/dependent:latest
MAINTAINER ywfwj2008 <ywfwj2008@163.com>

ENV PHP_INSTALL_DIR=/usr/local/php \
    PHP_VERSION=5.6.31 \
    IMAGICK_PECL_VERSION=3.4.3 \
    MEMCACHE_PECL_VERSION=3.0.8 \
    LIBMEMCACHED_VERSION=1.0.18 \
    MEMCACHED_PECL_VERSION=2.2.0 \
    EVENT_VERSION=2.3.0 \
    SWOOLE_VERSION=2.0.7 \
    REMOTE_PATH=https://github.com/ywfwj2008/docker-php/raw/master

WORKDIR /tmp

# install php
RUN wget -c --no-check-certificate http://www.php.net/distributions/php-$PHP_VERSION.tar.gz && \
    tar xzf php-$PHP_VERSION.tar.gz && \
    cd php-$PHP_VERSION && \
    ./configure --prefix=$PHP_INSTALL_DIR --with-config-file-path=$PHP_INSTALL_DIR/etc \
        --with-config-file-scan-dir=$PHP_INSTALL_DIR/etc/php.d \
        --with-fpm-user=$RUN_USER --with-fpm-group=$RUN_USER --enable-fpm --enable-opcache \
        --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
        --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib \
        --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-exif \
        --enable-sysvsem --enable-inline-optimization --with-curl=/usr/local --enable-mbregex \
        --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl \
        --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-ftp --enable-intl --with-xsl \
        --with-gettext --enable-zip --enable-soap --disable-debug && \
    make ZEND_EXTRA_LIBS='-liconv' && \
    make install && \
    mkdir -p $PHP_INSTALL_DIR/etc/php.d && \
    /bin/cp php.ini-production $PHP_INSTALL_DIR/etc/php.ini && \
    /bin/cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && \
    chmod +x /etc/init.d/php-fpm && \
    rm -rf /tmp/*

# install ImageMagick
RUN wget -c --no-check-certificate http://www.imagemagick.org/download/ImageMagick.tar.gz && \
    tar xzf ImageMagick.tar.gz && \
    cd ImageMagick* && \
    ./configure --prefix=/usr/local/imagemagick --enable-shared --enable-static && \
    make && make install && \
    cd .. && \
    wget -c --no-check-certificate http://pecl.php.net/get/imagick-$IMAGICK_PECL_VERSION.tgz && \
    tar xzf imagick-$IMAGICK_PECL_VERSION.tgz && \
    cd imagick-$IMAGICK_PECL_VERSION && \
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig && \
    $PHP_INSTALL_DIR/bin/phpize && \
    ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config --with-imagick=/usr/local/imagemagick && \
    make && make install && \
    echo "extension=imagick.so" > $PHP_INSTALL_DIR/etc/php.d/ext-imagick.ini && \
    rm -rf /tmp/*

# install php-memcache
RUN wget -c --no-check-certificate http://pecl.php.net/get/memcache-$MEMCACHE_PECL_VERSION.tgz && \
    tar xzf memcache-$MEMCACHE_PECL_VERSION.tgz && \
    cd memcache-$MEMCACHE_PECL_VERSION && \
    $PHP_INSTALL_DIR/bin/phpize && \
    ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config && \
    make && make install && \
    echo "extension=memcache.so" > $PHP_INSTALL_DIR/etc/php.d/ext-memcache.ini && \
    rm -rf /tmp/*

# install php-memcached
RUN wget -c --no-check-certificate https://launchpad.net/libmemcached/1.0/$LIBMEMCACHED_VERSION/+download/libmemcached-$LIBMEMCACHED_VERSION.tar.gz && \
    tar xzf libmemcached-$LIBMEMCACHED_VERSION.tar.gz && \
    cd libmemcached-$LIBMEMCACHED_VERSION && \
    sed -i "s@lthread -pthread -pthreads@lthread -lpthread -pthreads@" ./configure && \
    ./configure && \
    make && make install && \
    cd .. && \
    wget -c --no-check-certificate http://pecl.php.net/get/memcached-$MEMCACHED_PECL_VERSION.tgz && \
    tar xzf memcached-$MEMCACHED_PECL_VERSION.tgz && \
    cd memcached-$MEMCACHED_PECL_VERSION && \
    $PHP_INSTALL_DIR/bin/phpize && \
    ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config && \
    make && make install && \
    echo "extension=memcached.so" >> $PHP_INSTALL_DIR/etc/php.d/ext-memcached.ini && \
    echo "memcached.use_sasl=1" >> $PHP_INSTALL_DIR/etc/php.d/ext-memcached.ini && \
    rm -rf /tmp/*

# install php-redis
RUN $PHP_INSTALL_DIR/bin/pecl install redis && \
    echo "extension=redis.so" > $PHP_INSTALL_DIR/etc/php.d/ext-redis.ini && \
    rm -rf /tmp/*

# install event
RUN wget -c --no-check-certificate http://pecl.php.net/get/event-$EVENT_VERSION.tgz && \
    tar xzf event-$EVENT_VERSION.tgz && \
    cd event-$EVENT_VERSION && \
    $PHP_INSTALL_DIR/bin/phpize && \
    ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config --with-event-openssl=no --enable-event-sockets --with-event-extra && \
    make && make install && \
    echo "extension=event.so" > $PHP_INSTALL_DIR/etc/php.d/ext-event.ini && \
    rm -rf /tmp/*

# install swoole
RUN wget -c --no-check-certificate https://github.com/swoole/swoole-src/archive/v$SWOOLE_VERSION.tar.gz && \
    tar xzf v$SWOOLE_VERSION.tar.gz && \
    cd swoole-src-$SWOOLE_VERSION && \
    $PHP_INSTALL_DIR/bin/phpize && \
    ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config --enable-jemalloc && \
    make && make install && \
    echo "extension=swoole.so" > $PHP_INSTALL_DIR/etc/php.d/ext-swoole.ini && \
    rm -rf /tmp/*

# install ZendGuardLoader and ioncube and sg11
ADD ${REMOTE_PATH}/ext-opcache.ini $PHP_INSTALL_DIR/etc/php.d/ext-opcache.ini
RUN phpExtensionDir=$(${PHP_INSTALL_DIR}/bin/php-config --extension-dir) && \
    wget -c http://mirrors.linuxeye.com/oneinstack/src/zend-loader-php5.6-linux-x86_64.tar.gz -P /tmp && \
    tar xzf /tmp/zend-loader-php5.6-linux-x86_64.tar.gz && \
    /bin/cp /tmp/zend-loader-php5.6-linux-x86_64/ZendGuardLoader.so ${phpExtensionDir} && \
    wget -c http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -P /tmp && \
    tar xzf /tmp/ioncube_loaders_lin_x86-64.tar.gz && \
    /bin/cp /tmp/ioncube/ioncube_loader_lin_5.6.so ${phpExtensionDir}/ioncube_loader.so && \
    wget -c https://github.com/ywfwj2008/docker-php/raw/master/loaders.linux-x86_64.tar.gz -P /tmp && \
    tar xzf /tmp/loaders.linux-x86_64.tar.gz && \
    /bin/cp /tmp/ixed.5.6.lin ${phpExtensionDir}/ixed.lin && \
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
