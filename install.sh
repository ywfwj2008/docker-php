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

# zendopcache
# opcache.max_accelerated_files's value can be in {223,463,983,1979,3907,7963,16229,32521,65407,130987}
cat > $PHP_INSTALL_DIR/etc/php.d/ext-opcache.ini << EOF
[opcache]\nzend_extension=opcache.so\nopcache.enable=1\nopcache.enable_cli=1\nopcache.memory_consumption=192\nopcache.interned_strings_buffer=8\nopcache.max_accelerated_files=7963\nopcache.max_wasted_percentage=5\nopcache.use_cwd=1\nopcache.validate_timestamps=1\nopcache.revalidate_freq=60\nopcache.save_comments=0\nopcache.fast_shutdown=1\nopcache.consistency_checks=0\n;opcache.optimization_level=0
EOF
