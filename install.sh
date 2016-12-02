#!/bin/bash

PHP_INSTALL_DIR=/usr/local/php
phpExtensionDir=$(${PHP_INSTALL_DIR}/bin/php-config --extension-dir)

[ -z "`grep ^'export PATH=' /etc/profile`" ] && echo "export PATH=$PHP_INSTALL_DIR/bin:\$PATH" >> /etc/profile
[ -n "`grep ^'export PATH=' /etc/profile`" -a -z "`grep $PHP_INSTALL_DIR /etc/profile`" ] && sed -i "s@^export PATH=\(.*\)@export PATH=$PHP_INSTALL_DIR/bin:\1@" /etc/profile

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
sed -i "s@extension_dir = \"ext\"@extension_dir = \"ext\"\nextension_dir = \"${phpExtensionDir}\"@" $PHP_INSTALL_DIR/etc/php.ini
[ -e /usr/sbin/sendmail ] && sed -i 's@^;sendmail_path.*@sendmail_path = /usr/sbin/sendmail -t -i@' $PHP_INSTALL_DIR/etc/php.ini

# ZendGuardLoader
if [ -f "${phpExtensionDir}/ZendGuardLoader.so" ];then
    cat > $PHP_INSTALL_DIR/etc/php.d/ext-ZendGuardLoader.ini << EOF
[Zend Guard Loader]
zend_extension=${phpExtensionDir}/ZendGuardLoader.so
zend_loader.enable=1
zend_loader.disable_licensing=0
zend_loader.obfuscation_level_support=3
EOF
fi

# ioncube
if [ -f "${phpExtensionDir}/ioncube_loader.so" ];then
    cat > $PHP_INSTALL_DIR/etc/php.d/ext-0ioncube.ini << EOF
[ionCube Loader]
zend_extension=${phpExtensionDir}/ioncube_loader.so
EOF
fi
