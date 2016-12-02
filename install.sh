#!/bin/bash

PHP_INSTALL_DIR=/usr/local/php

[ -z "`grep ^'export PATH=' /etc/profile`" ] && echo "export PATH=$PHP_INSTALL_DIR/bin:\$PATH" >> /etc/profile
[ -n "`grep ^'export PATH=' /etc/profile`" -a -z "`grep $PHP_INSTALL_DIR /etc/profile`" ] && sed -i "s@^export PATH=\(.*\)@export PATH=$PHP_INSTALL_DIR/bin:\1@" /etc/profile
source /etc/profile

# optimize php.ini
sed -i "s@^memory_limit.*@memory_limit = 192M@" $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^output_buffering =@output_buffering = On\noutput_buffering =@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^;cgi.fix_pathinfo.*@cgi.fix_pathinfo=0@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^short_open_tag = Off@short_open_tag = On@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^expose_php = On@expose_php = Off@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^request_order.*@request_order = "CGP"@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^;date.timezone.*@date.timezone = Asia/Shanghai@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^post_max_size.*@post_max_size = 100M@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^upload_max_filesize.*@upload_max_filesize = 50M@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^max_execution_time.*@max_execution_time = 5@' $PHP_INSTALL_DIR/etc/php.ini
sed -i 's@^disable_functions.*@disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,popen@' $PHP_INSTALL_DIR/etc/php.ini
sed -i "s@extension_dir = \"ext\"@extension_dir = \"ext\"\nextension_dir = \"`$PHP_INSTALL_DIR/bin/php-config --extension-dir`\"@" $PHP_INSTALL_DIR/etc/php.ini
[ -e /usr/sbin/sendmail ] && sed -i 's@^;sendmail_path.*@sendmail_path = /usr/sbin/sendmail -t -i@' $PHP_INSTALL_DIR/etc/php.ini

# ZendGuardLoader
if [ -f "`$PHP_INSTALL_DIR/bin/php-config --extension-dir`/ZendGuardLoader.so" ];then
    cat > $PHP_INSTALL_DIR/etc/php.d/ext-ZendGuardLoader.ini << EOF
[Zend Guard Loader]
zend_extension=`$PHP_INSTALL_DIR/bin/php-config --extension-dir`/ZendGuardLoader.so
zend_loader.enable=1
zend_loader.disable_licensing=0
zend_loader.obfuscation_level_support=3
EOF
fi

# ioncube
if [ -f "`$PHP_INSTALL_DIR/bin/php-config --extension-dir`/ioncube_loader.so" ];then
    cat > $PHP_INSTALL_DIR/etc/php.d/ext-0ioncube.ini << EOF
[ionCube Loader]
zend_extension=`$PHP_INSTALL_DIR/bin/php-config --extension-dir`/ioncube_loader.so
EOF
fi

# zendopcache
# opcache.max_accelerated_files's value can be in {223,463,983,1979,3907,7963,16229,32521,65407,130987}
if [ -f "`$PHP_INSTALL_DIR/bin/php-config --extension-dir`/opcache.so" ]; then
    cat > ${PHP_INSTALL_DIR}/etc/php.d/ext-opcache.ini << EOF
[opcache]
zend_extension=`$PHP_INSTALL_DIR/bin/php-config --extension-dir`/opcache.so
opcache.enable=1
opcache.memory_consumption=192
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=7963
opcache.revalidate_freq=60
opcache.save_comments=0
opcache.fast_shutdown=1
opcache.enable_cli=1
;opcache.optimization_level=0
EOF

else

    cat > $PHP_INSTALL_DIR/etc/php.d/ext-opcache.ini << EOF
[opcache]
zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=192
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=7963
opcache.max_wasted_percentage=5
opcache.use_cwd=1
opcache.validate_timestamps=1
opcache.revalidate_freq=60
opcache.save_comments=0
opcache.fast_shutdown=1
opcache.consistency_checks=0
;opcache.optimization_level=0
EOF
fi