#!/bin/bash
/usr/bin/mysqld_safe &
/usr/sbin/sshd -D &
/etc/init.d/postfix start
/etc/init.d/fail2ban start
/etc/init.d/bind9 start
/usr/sbin/apache2ctl -D FOREGROUND
