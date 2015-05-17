#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# echo "ROOT password : $DOCKERPASS"
# echo "root:pass"|chpasswd
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
if [[ 1 == 2 ]]
then
newlist -q mailman $1 $2
fi
/usr/bin/supervisord
