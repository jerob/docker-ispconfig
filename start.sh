#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# echo "ROOT password : $DOCKERPASS"
# echo "root:pass"|chpasswd
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
if [ ! -z "$DEFAULT_EMAIL_HOST" ]; then
sed -i "s/^\(DEFAULT_EMAIL_HOST\) = .*$/\1 = '$MAILMAN_EMAIL_HOST'/g" /etc/mailman/mm_cfg.py
newlist -q mailman $(MAILMAN_EMAIL) $(MAILMAN_PASS)
newaliases
fi
echo "START"
if [ ! -z "$LANGUAGE" ]; then
sed -i "s/^language=en$/language=$LANGUAGE/g" /tmp/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$COUNTRY" ]; then
sed -i "s/^ssl_cert_country=AU$/ssl_cert_country=$COUNTRY/g" /tmp/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$HOSTNAME" ]; then
sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /tmp/ispconfig3_install/install/autoinstall.ini
fi
# php -q /tmp/ispconfig3_install/install/install.php --autoinstall=/tmp/ispconfig3_install/install/autoinstall.ini
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
if [ ! -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
	php -q /tmp/ispconfig3_install/install/install.php --autoinstall=/tmp/ispconfig3_install/install/autoinstall.ini
	killall apache2
fi
