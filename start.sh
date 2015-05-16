#!/bin/bash
/usr/bin/mysqld_safe &
/usr/sbin/apache2ctl -D FOREGROUND
/etc/init.d/postfix start
/usr/sbin/sshd -D
