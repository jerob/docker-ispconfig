#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# echo "ROOT password : $DOCKERPASS"
# echo "root:pass"|chpasswd
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
/usr/bin/mysqld_safe &
/usr/sbin/sshd -D &
/etc/init.d/postfix start
/etc/init.d/fail2ban start
/etc/init.d/bind9 start
cron
/usr/sbin/apache2ctl -D FOREGROUND
