#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
#          |          |
#       __ |  __   __ | _  __   _
#      /  \| /  \ /   |/  / _\ |
#      \__/| \__/ \__ |\_ \__  |
#
# Dockerfile for ISPConfig with MariaDB database
#
# https://www.howtoforge.com/tutorial/perfect-server-debian-8-jessie-apache-bind-dovecot-ispconfig-3/
#

FROM debian:stretch

MAINTAINER Jeremie Robert <appydo@gmail.com> version: 0.2

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# --- 1 Preliminary
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install rsyslog rsyslog-relp logrotate supervisor
RUN touch /var/log/cron.log
# Create the log file to be able to run tail
RUN touch /var/log/auth.log

# --- 2 Install the SSH server
RUN apt-get -y install ssh openssh-server rsync

# --- 3 Install a shell text editor
RUN apt-get -y install nano vim-nox

# --- 5 Update Your Debian Installation
ADD ./etc/apt/sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get -y upgrade

# --- 6 Change The Default Shell
RUN echo "dash  dash/sh boolean no" | debconf-set-selections
RUN dpkg-reconfigure dash

# --- 7 Synchronize the System Clock
RUN apt-get -y install ntp ntpdate

# --- 8 Install Postfix, Dovecot, MySQL, phpMyAdmin, rkhunter, binutils
RUN echo 'mysql-server mysql-server/root_password password pass' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password pass' | debconf-set-selections
RUN echo 'mariadb-server mariadb-server/root_password password pass' | debconf-set-selections
RUN echo 'mariadb-server mariadb-server/root_password_again password pass' | debconf-set-selections
RUN apt-get -y install postfix postfix-mysql postfix-doc mariadb-client mariadb-server openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd sudo
ADD ./etc/postfix/master.cf /etc/postfix/master.cf
RUN mv /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.backup
ADD ./etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN service postfix restart
RUN service mysql restart
RUN aptitude -y install expect
RUN <<EOR
MYSQL_ROOT_PASSWORD=abcd1234
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$SECURE_MYSQL"
EOR
RUN aptitude -y purge expect

# --- 9 Install Amavisd-new, SpamAssassin And Clamav
RUN apt-get -y install amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl
ADD ./etc/clamav/clamd.conf /etc/clamav/clamd.conf
RUN service spamassassin stop
RUN systemctl disable spamassassin

# --- 10 Install Apache2, PHP5, phpMyAdmin, FCGI, suExec, Pear, And mcrypt
RUN echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
# RUN echo 'phpmyadmin phpmyadmin/app-password-confirm password your-app-pwd' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/mysql/admin-pass password pass' | debconf-set-selections
# RUN echo 'phpmyadmin phpmyadmin/mysql/app-pass password your-app-db-pwd' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
RUN service mysql restart && apt-get -y install apache2 apache2-doc apache2-utils libapache2-mod-php php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap phpmyadmin php7.0-cli php7.0-cgi libapache2-mod-fcgid apache2-suexec-pristine php-pear php7.0-mcrypt mcrypt  imagemagick libruby libapache2-mod-python php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring memcached libapache2-mod-passenger php7.0-soap
RUN a2enmod suexec rewrite ssl actions include dav_fs dav auth_digest cgi

# --- 11 Install Let's Encrypt
RUN apt-get -y install certbot

# --- 12 Opcode and PHP-FPM
RUN apt-get -y install php7.0-fpm php7.0-opcache php-apcu
RUN a2enmod actions proxy_fcgi alias
RUN service apache2 restart
# php5 fpm (non-free)
# RUN apt-get -y install libapache2-mod-fastcgi php5-fpm
# RUN a2enmod actions fastcgi alias
# RUN service apache2 restart

# --- 13 Install Mailman
RUN echo 'mailman mailman/default_server_language en' | debconf-set-selections
RUN apt-get -y install mailman
# RUN ["/usr/lib/mailman/bin/newlist", "-q", "mailman", "mail@mail.com", "pass"]
ADD ./etc/aliases /etc/aliases
RUN newaliases
RUN service postfix restart
RUN ln -s /etc/mailman/apache.conf /etc/apache2/conf-enabled/mailman.conf

# --- 14 Install PureFTPd And Quota
RUN apt-get -y install pure-ftpd-common pure-ftpd-mysql quota quotatool

# install package building helpers
# RUN apt-get -y --force-yes install dpkg-dev debhelper openbsd-inetd
# install dependancies
# RUN apt-get -y build-dep pure-ftpd
# build from source
# RUN mkdir /tmp/pure-ftpd-mysql/ && \
#    cd /tmp/pure-ftpd-mysql/ && \
#    apt-get source pure-ftpd-mysql && \
#    cd pure-ftpd-* && \
#    sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
#    dpkg-buildpackage -b -uc
# install the new deb files
# RUN dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-common*.deb
# RUN dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-mysql*.deb
# Prevent pure-ftpd upgrading
# RUN apt-mark hold pure-ftpd-common pure-ftpd-mysql
# setup ftpgroup and ftpuser
# RUN groupadd ftpgroup
# RUN useradd -g ftpgroup -d /dev/null -s /etc ftpuser
# RUN apt-get -y install quota quotatool
ADD ./etc/default/pure-ftpd-common /etc/default/pure-ftpd-common
RUN echo 1 > /etc/pure-ftpd/conf/TLS
RUN mkdir -p /etc/ssl/private/
# RUN openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
# RUN chmod 600 /etc/ssl/private/pure-ftpd.pem
# RUN service pure-ftpd-mysql restart

# --- 15 Install BIND DNS Server
RUN apt-get -y install bind9 dnsutils haveged

# --- 16 Install Vlogger, Webalizer, And AWStats
RUN apt-get -y install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl
ADD etc/cron.d/awstats /etc/cron.d/

# --- 17 Install Jailkit
RUN apt-get -y install build-essential autoconf automake libtool flex bison debhelper binutils
RUN cd /tmp && wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz && tar xvfz jailkit-2.19.tar.gz && cd jailkit-2.19 && echo 5 > debian/compat && ./debian/rules binary
RUN cd /tmp && dpkg -i jailkit_2.19-1_*.deb && rm -rf jailkit-2.19*

# --- 18 Install fail2ban
RUN apt-get -y install fail2ban
ADD ./etc/fail2ban/jail.local /etc/fail2ban/jail.local
ADD ./etc/fail2ban/filter.d/pureftpd.conf /etc/fail2ban/filter.d/pureftpd.conf
ADD ./etc/fail2ban/filter.d/dovecot-pop3imap.conf /etc/fail2ban/filter.d/dovecot-pop3imap.conf
RUN echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf
RUN service fail2ban restart

# --- 19 Install RoundCube
# RUN apt-get -y install squirrelmail
# ADD ./etc/apache2/conf-enabled/squirrelmail.conf /etc/apache2/conf-enabled/squirrelmail.conf
# ADD ./etc/squirrelmail/config.php /etc/squirrelmail/config.php
# RUN mkdir /var/lib/squirrelmail/tmp
# RUN chown www-data /var/lib/squirrelmail/tmp
RUN apt-get -y install roundcube roundcube-core roundcube-mysql roundcube-plugins
# RUN service mysql restart

# --- 20 Install ISPConfig 3
RUN cd /tmp && cd . && wget http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz
RUN cd /tmp && tar xfz ISPConfig-3-stable.tar.gz
RUN service mysql restart
# RUN ["/bin/bash", "-c", "cat /tmp/install_ispconfig.txt | php -q /tmp/ispconfig3_install/install/install.php"]
# RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
# RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini

# ADD ./etc/mysql/my.cnf /etc/mysql/my.cnf
ADD ./etc/postfix/master.cf /etc/postfix/master.cf
ADD ./etc/clamav/clamd.conf /etc/clamav/clamd.conf

RUN echo "export TERM=xterm" >> /root/.bashrc

EXPOSE 20 21 22 53/udp 53/tcp 80 443 953 8080 30000 30001 30002 30003 30004 30005 30006 30007 30008 30009 3306

# ISPCONFIG Initialization and Startup Script
ADD ./start.sh /start.sh
ADD ./supervisord.conf /etc/supervisor/supervisord.conf
ADD ./etc/cron.daily/sql_backup.sh /etc/cron.daily/sql_backup.sh
ADD ./autoinstall.ini /tmp/ispconfig3_install/install/autoinstall.ini
RUN chmod 755 /start.sh
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
RUN mv /bin/systemctl /bin/systemctloriginal
ADD ./bin/systemctl /bin/systemctl

RUN sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /tmp/ispconfig3_install/install/autoinstall.ini
# RUN mysqladmin -u root password pass
RUN service mysql restart && php -q /tmp/ispconfig3_install/install/install.php --autoinstall=/tmp/ispconfig3_install/install/autoinstall.ini
# ADD ./ISPConfig_Clean-3.0.5 /tmp/ISPConfig_Clean-3.0.5
# RUN cp -r /tmp/ISPConfig_Clean-3.0.5/interface /usr/local/ispconfig/
# RUN service mysql restart && mysql -ppass < /tmp/ISPConfig_Clean-3.0.5/sql/ispc-clean.sql
# Directory for dump SQL backup
RUN mkdir -p /var/backup/sql
RUN freshclam

VOLUME ["/var/www/","/var/mail/","/var/backup/","/var/lib/mysql","/etc/","/usr/local/ispconfig","/var/log/"]

CMD ["/bin/bash", "/start.sh"]
