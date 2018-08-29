#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
if [ ! -z "$DEFAULT_EMAIL_HOST" ]; then
	sed -i "s/^\(DEFAULT_EMAIL_HOST\) = .*$/\1 = '$MAILMAN_EMAIL_HOST'/g" /etc/mailman/mm_cfg.py
	newlist -q mailman $(MAILMAN_EMAIL) $(MAILMAN_PASS)
	newaliases
fi
if [ ! -z "$LANGUAGE" ]; then
	sed -i "s/^language=en$/language=$LANGUAGE/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$COUNTRY" ]; then
	sed -i "s/^ssl_cert_country=AU$/ssl_cert_country=$COUNTRY/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$HOSTNAME" ]; then
	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
	mysql_install_db
	service mysql start \
	&& echo "UPDATE mysql.user SET Password = PASSWORD('pass') WHERE User = 'root';" | mysql -u root \
	&& echo "UPDATE mysql.user SET plugin='mysql_native_password' where user='root';" | mysql -u root \
	&& echo "DELETE FROM mysql.user WHERE User='';" | mysql -u root \
	&& echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" | mysql -u root \
	&& echo "DROP DATABASE IF EXISTS test;" | mysql -u root \
	&& echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" | mysql -u root \
	&& echo "FLUSH PRIVILEGES;" | mysql -u root
	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini
	# RUN mysqladmin -u root password pass
	service mysql start && php -q /root/ispconfig3_install/install/install.php --autoinstall=/root/ispconfig3_install/install/autoinstall.ini
	mkdir /var/www/html
	echo "" > /var/www/html/index.html
	rm -r /root/ispconfig3_install
fi



screenfetch

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
