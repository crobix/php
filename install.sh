#!/bin/sh -xe
##
# Loïc AUDU PHP 7.4 container
##

export DEBIAN_FRONTEND=noninteractive
# Sury : PHP Sources
wget -q -O - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/sury-php.list

# Blackfire
wget -q -O - https://packages.blackfire.io/gpg.key | sudo apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list
apt-key update
# PHP
apt-get update && apt-get upgrade -y && apt-get -y install php7.4-dev php7.4-cli php7.4-bcmath php7.4-curl php-pear php7.4-gd php7.4-mbstring php7.4-mysql php7.4-sqlite3 php7.4-xmlrpc php7.4-xsl php7.4-ldap php7.4-gmp php7.4-intl php7.4-zip php7.4-soap php7.4-xml php7.4-common php7.4-json php7.4-opcache php7.4-readline
# Disabled : blackfire-agent blackfire-php
# Disabled ext from repos :  php7.4-imagick php7.4-xdebug php7.4-apcu
# Disable dependencies : libmagickwand-6.q16-dev
# Disabled php-redis

sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Paris/g' /etc/php/7.4/cli/php.ini
sed -i 's/\memory_limit\ \=\ 128M/memory_limit\ \=\ -1/g' /etc/php/7.4/cli/php.ini
sed -i 's/\display_errors\ \=\ Off/display_errors\ \=\ On/g' /etc/php/7.4/cli/php.ini
sed -i 's/disable_functions\ \=\ pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,/\;disable_functions\ \=\ pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,/g' /etc/php/7.4/cli/php.ini

pecl channel-update pecl.php.net
## Fix Tar Error
wget https://github.com/pear/Archive_Tar/archive/1.4.7.tar.gz
tar -xvf Archive_Tar-1.4.7.tar.gz
cp Archive_Tar-1.4.7/Archive/Tar.php /usr/share/php/Archive/Tar.php

pecl install sqlsrv-5.7.0preview
pecl install pdo_sqlsrv-5.7.0preview
echo "extension=sqlsrv" > /etc/php/7.4/mods-available/sqlsrv.ini
echo "extension=pdo_sqlsrv" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini

#PEAR
pear upgrade
pear install pecl/amqp
echo "extension=amqp" > /etc/php/7.4/mods-available/amqp.ini


pear install pecl/redis-5.0.2
echo "extension=redis" > /etc/php/7.4/mods-available/redis.ini

apt install -y libmagickwand-dev libmagickcore-dev libmagickwand-6.q16-6 libmagickcore-6.q16-6
pear install pecl/imagick
echo "extension=imagick" > /etc/php/7.4/mods-available/imagick.ini

#git clone git://github.com/xdebug/xdebug.git
#cd xdebug
#git co 2.6.0beta1
#/usr/bin/phpize7.4 && ./configure --enable-xdebug && make && make install
pear install pecl/xdebug-2.8.0beta2
echo "zend_extension=xdebug" > /etc/php/7.4/mods-available/xdebug.ini

phpenmod -v 7.4 -s cli amqp sqlsrv pdo_sqlsrv redis xdebug imagick
# Disable : imagick

#useradd -s /bin/bash --home /sources --no-create-home phpuser

groupadd -g ${gid} phpuser
useradd -l -u ${uid} -g ${gid} -m -s /bin/bash phpuser
usermod -a -G www-data phpuser

apt-get remove -y libmagickwand-dev libmagickcore-dev && apt autoremove -y
