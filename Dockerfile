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

FROM debian:stretch-slim

MAINTAINER Jeremie Robert <appydo@gmail.com> version: 0.2

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# --- 1 Preliminary
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install rsyslog rsyslog-relp logrotate supervisor screenfetch
# Create the log file to be able to run tail
RUN touch /var/log/cron.log /var/log/auth.log

# --- 2 Install the SSH server
RUN apt-get -y install ssh openssh-server rsync

# --- 3 Install a shell text editor
RUN apt-get -y install nano vim-nox

# --- 5 Update Your Debian Installation
ADD ./etc/apt/sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get -y upgrade

# --- 6 Change The Default Shell
RUN echo "dash  dash/sh boolean no" | debconf-set-selections && dpkg-reconfigure dash

# --- 7 Synchronize the System Clock
# RUN apt-get -y install ntp ntpdate

# --- 8 Install Postfix, Dovecot, MySQL, phpMyAdmin, rkhunter, binutils
RUN echo 'mysql-server mysql-server/root_password password pass' | debconf-set-selections \
&& echo 'mysql-server mysql-server/root_password_again password pass' | debconf-set-selections \
&& echo 'mariadb-server mariadb-server/root_password password pass' | debconf-set-selections \
&& echo 'mariadb-server mariadb-server/root_password_again password pass' | debconf-set-selections
RUN apt-get -y install postfix postfix-mysql postfix-doc mariadb-client mariadb-server openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd sudo
ADD ./etc/postfix/master.cf /etc/postfix/master.cf
RUN mv /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.backup
ADD ./etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# RUN apt-get -y install expect
RUN mv /etc/mysql/debian.cnf /etc/mysql/debian.cnf.backup
ADD ./etc/mysql/debian.cnf /etc/mysql/debian.cnf
ADD ./etc/security/limits.conf /etc/security/limits.conf
RUN mkdir -p /etc/systemd/system/mysql.service.d/
ADD ./etc/systemd/system/mysql.service.d/limits.conf /etc/systemd/system/mysql.service.d/limits.conf

# --- 9 Install Amavisd-new, SpamAssassin And Clamav
RUN apt-get -y install amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl
ADD ./etc/clamav/clamd.conf /etc/clamav/clamd.conf
RUN service spamassassin stop && systemctl disable spamassassin

# --- 9.1 Install Metronome XMPP Server
RUN echo "deb http://packages.prosody.im/debian jessie main" > /etc/apt/sources.list.d/metronome.list
RUN wget http://prosody.im/files/prosody-debian-packages.key -O - | apt-key add -
RUN apt-get -qq update && apt-get -y -qq install git lua5.1 liblua5.1-0-dev lua-filesystem libidn11-dev libssl-dev lua-zlib lua-expat lua-event lua-bitop lua-socket lua-sec luarocks luarocks
RUN luarocks install lpc
RUN adduser --no-create-home --disabled-login --gecos 'Metronome' metronome
RUN cd /opt && git clone https://github.com/maranda/metronome.git metronome
RUN cd /opt/metronome && ./configure --ostype=debian --prefix=/usr && make && make install

# --- 10 Install Apache2, PHP5, phpMyAdmin, FCGI, suExec, Pear, And mcrypt
RUN echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections \
&& echo 'phpmyadmin phpmyadmin/mysql/admin-pass password pass' | debconf-set-selections \
&& echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
RUN service mysql start && apt-get -y install apache2 apache2-doc apache2-utils libapache2-mod-php php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap phpmyadmin php7.0-cli php7.0-cgi libapache2-mod-fcgid apache2-suexec-pristine php-pear php7.0-mcrypt mcrypt  imagemagick libruby libapache2-mod-python php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring memcached libapache2-mod-passenger php7.0-soap
RUN a2enmod suexec rewrite ssl actions include dav_fs dav auth_digest cgi

# --- 11 Install Let's Encrypt
RUN apt-get -y install certbot

# --- 12 Opcode and PHP-FPM
RUN apt-get -y install php7.0-fpm php7.0-opcache php-apcu
RUN a2enmod actions proxy_fcgi alias
# php5 fpm (non-free)
# RUN apt-get -y install libapache2-mod-fastcgi php5-fpm
# RUN a2enmod actions fastcgi alias

# --- 13 Install Mailman
RUN echo 'mailman mailman/default_server_language en' | debconf-set-selections
RUN apt-get -y install mailman
# RUN ["/usr/lib/mailman/bin/newlist", "-q", "mailman", "mail@mail.com", "pass"]
ADD ./etc/aliases /etc/aliases
RUN newaliases
RUN ln -s /etc/mailman/apache.conf /etc/apache2/conf-enabled/mailman.conf

# --- 14 Install PureFTPd And Quota
# RUN apt-get -y install pure-ftpd-common pure-ftpd-mysql quota quotatool

# --- 14 Install PureFTPd And Quota
# install package building helpers
RUN apt-get -qq -y --force-yes install dpkg-dev debhelper openbsd-inetd debian-keyring
# install dependancies
RUN apt-get -y -qq build-dep pure-ftpd
# build from source
RUN mkdir /tmp/pure-ftpd-mysql/ && \
    cd /tmp/pure-ftpd-mysql/ && \
    apt-get -qq source pure-ftpd-mysql && \
    cd pure-ftpd-* && \
    sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
    dpkg-buildpackage -b -uc > /tmp/pureftpd-build-stdout.txt 2> /tmp/pureftpd-build-stderr.txt
# install the new deb files
RUN dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-common*.deb && dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-mysql*.deb
# Prevent pure-ftpd upgrading
RUN apt-mark hold pure-ftpd-common pure-ftpd-mysql
# setup ftpgroup and ftpuser
RUN groupadd ftpgroup && useradd -g ftpgroup -d /dev/null -s /etc ftpuser
RUN apt-get -qq update && apt-get -y -qq install quota quotatool
#RUN /bin/bash -c 'sed -i "s/{{ SSLCERT_ORGANIZATION }}/${SSLCERT_ORGANIZATION}/g;s/{{ SSLCERT_UNITNAME }}/${SSLCERT_UNITNAME}/g;s/{{ SSLCERT_EMAIL }}/${SSLCERT_EMAIL}/g;s/{{ SSLCERT_LOCALITY }}/${SSLCERT_LOCALITY}/g;s/{{ SSLCERT_STATE }}/${SSLCERT_STATE}/g;s/{{ SSLCERT_COUNTRY }}/${SSLCERT_COUNTRY}/g;s/{{ SSLCERT_CN }}/${FQDN}/g" /root/config/openssl.cnf'
#RUN openssl req -x509 -nodes -days 7300 -newkey rsa:4096 -config /root/config/openssl.cnf -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
#RUN chmod 600 /etc/ssl/private/pure-ftpd.pem

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
RUN echo 1 > /etc/pure-ftpd/conf/TLS && mkdir -p /etc/ssl/private/
# RUN openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
# RUN chmod 600 /etc/ssl/private/pure-ftpd.pem

# --- 15 Install BIND DNS Server
RUN apt-get -y install bind9 dnsutils haveged

# --- 16 Install Vlogger, Webalizer, And AWStats
RUN apt-get -y install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl
ADD etc/cron.d/awstats /etc/cron.d/

# --- 17 Install Jailkit
RUN apt-get -y install build-essential autoconf automake libtool flex bison debhelper binutils
RUN cd /tmp \
&& wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz \
&& tar xvfz jailkit-2.19.tar.gz \
&& cd jailkit-2.19 \
&& echo 5 > debian/compat \
&& ./debian/rules binary \
&& cd /tmp \
&& dpkg -i jailkit_2.19-1_*.deb

# --- 18 Install fail2ban
RUN apt-get -y install fail2ban
ADD ./etc/fail2ban/jail.local /etc/fail2ban/jail.local
ADD ./etc/fail2ban/filter.d/pureftpd.conf /etc/fail2ban/filter.d/pureftpd.conf
ADD ./etc/fail2ban/filter.d/dovecot-pop3imap.conf /etc/fail2ban/filter.d/dovecot-pop3imap.conf
RUN echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf

# --- 19 Install RoundCube
# RUN apt-get -y install squirrelmail
# ADD ./etc/apache2/conf-enabled/squirrelmail.conf /etc/apache2/conf-enabled/squirrelmail.conf
# ADD ./etc/squirrelmail/config.php /etc/squirrelmail/config.php
# RUN mkdir /var/lib/squirrelmail/tmp
# RUN chown www-data /var/lib/squirrelmail/tmp
RUN service mysql start && apt-get -y install roundcube roundcube-core roundcube-mysql roundcube-plugins
ADD ./etc/apache2/conf-enabled/roundcube.conf /etc/apache2/conf-enabled/roundcube.conf
ADD ./etc/roundcube/config.inc.php /etc/roundcube/config.inc.php

# --- 20 Install ISPConfig 3
RUN cd /root && wget http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz && tar xfz ISPConfig-3-stable.tar.gz
# RUN ["/bin/bash", "-c", "cat /tmp/install_ispconfig.txt | php -q /tmp/ispconfig3_install/install/install.php"]
# RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
# RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini

# ADD ./etc/mysql/my.cnf /etc/mysql/my.cnf
ADD ./etc/clamav/clamd.conf /etc/clamav/clamd.conf

RUN echo "export TERM=xterm" >> /root/.bashrc

EXPOSE 20/tcp 21/tcp 22/tcp 53 80/tcp 443/tcp 953/tcp 8080/tcp 30000 30001 30002 30003 30004 30005 30006 30007 30008 30009 3306

# ISPCONFIG Initialization and Startup Script
ADD ./start.sh /start.sh
ADD ./supervisord.conf /etc/supervisor/supervisord.conf
ADD ./etc/cron.daily/sql_backup.sh /etc/cron.daily/sql_backup.sh
ADD ./autoinstall.ini /root/ispconfig3_install/install/autoinstall.ini
RUN mkdir -p /var/run/sshd /var/log/supervisor /var/run/supervisor
RUN mv /bin/systemctl /bin/systemctloriginal
ADD ./bin/systemctl /bin/systemctl
RUN chmod 755 /start.sh /bin/systemctl

RUN mkdir -p /var/backup/sql
RUN freshclam

# CLEANING
RUN apt-get autoremove -y && apt-get clean && rm -rf /tmp/*

VOLUME ["/var/www/","/var/mail/","/var/backup/","/var/lib/mysql","/var/log/"]

CMD ["/bin/bash", "/start.sh"]
