#!/bin/sh -ex
##
# Loïc AUDU PHP 8.0 container
##
export ACCEPT_EULA=Y
export DEBIAN_FRONTEND=noninteractive
# Sury : PHP Sources
wget -q -O - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/sury-php.list

# Blackfire
wget -q -O - https://packages.blackfire.io/gpg.key | sudo apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list

# PHP
apt-get update && apt-get upgrade -y
apt-get -y install php8.0-dev php8.0-cli php8.0-bcmath php8.0-curl php-pear php8.0-gd php8.0-mbstring php8.0-mysql php8.0-sqlite3 php8.0-xmlrpc php8.0-xsl php8.0-ldap php8.0-gmp php8.0-intl php8.0-zip php8.0-soap php8.0-xml php8.0-common php8.0-opcache php8.0-readline
# Disabled ext from repos :  php8.0-imagick php8.0-xdebug php8.0-apcu
# Disable dependencies : libmagickwand-6.q16-dev
# Disabled php-redis

sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Paris/g' /etc/php/8.0/cli/php.ini
sed -i 's/\memory_limit\ \=\ 128M/memory_limit\ \=\ -1/g' /etc/php/8.0/cli/php.ini
sed -i 's/\display_errors\ \=\ Off/display_errors\ \=\ On/g' /etc/php/8.0/cli/php.ini
sed -i 's/disable_functions\ \=\ pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,/\;disable_functions\ \=\ pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,/g' /etc/php/8.0/cli/php.ini

pear channel-update pear.php.net
## Fix Tar Error
#wget https://github.com/pear/Archive_Tar/releases/download/1.4.3/Archive_Tar-1.4.3.tgz
#tar -xvf Archive_Tar-1.4.3.tgz
#cp Archive_Tar-1.4.3/Archive/Tar.php /usr/share/php/Archive/Tar.php
#rm -rf  Archive_Tar-1.4.3

pecl install sqlsrv-5.9.0
pecl install pdo_sqlsrv-5.9.0
echo "extension=sqlsrv" > /etc/php/8.0/mods-available/sqlsrv.ini
echo "extension=pdo_sqlsrv" > /etc/php/8.0/mods-available/pdo_sqlsrv.ini

#PEAR
pear upgrade --force
pear install pecl/amqp-1.11.0beta
echo "extension=amqp" > /etc/php/8.0/mods-available/amqp.ini


pear install pecl/redis-5.3.4
echo "extension=redis" > /etc/php/8.0/mods-available/redis.ini

#apt-get install -y libmagickwand-dev libmagickcore-dev libmagickwand-6.q16-6 libmagickcore-6.q16-6
#pear install pecl/imagick
#echo "extension=imagick" > /etc/php/8.0/mods-available/imagick.ini


pear install pecl/xdebug-3.0.4
echo "zend_extension=xdebug" > /etc/php/8.0/mods-available/xdebug.ini

phpenmod -v 8.0 -s cli amqp sqlsrv pdo_sqlsrv redis xdebug imagick
#phpenmod -v 8.0 -s imagick

#useradd -s /bin/bash --home /sources --no-create-home phpuser

groupadd -g ${gid} phpuser
useradd -l -u ${uid} -g ${gid} -m -s /bin/bash phpuser
usermod -a -G www-data phpuser

apt-get remove -y libgcc-8-dev php8.0-dev libmagickwand-dev libmagickcore-dev gnupg && apt-get autoremove -y
