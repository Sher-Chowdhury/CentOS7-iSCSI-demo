#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run setup-isCSI-target.sh script #############'
echo '##########################################################################'

yum install -y targetcli

setenforce permissive

targetcli <<EOF
backstores/block create BD1 /dev/sdb
cd /iscsi
create iqn.2018-02.net.cb.target:fqdn
cd /iscsi/iqn.2018-02.net.cb.target:fqdn/tpg1/luns
create /backstores/block/BD1
cd /iscsi/iqn.2018-02.net.cb.target:fqdn/tpg1/acls
create iqn.2018-02.net.cb.target:client
cd /iscsi/iqn.2018-02.net.cb.target:fqdn/tpg1/acls/iqn.2018-02.net.cb.target:client/
set auth userid=codingbee
set auth password=password
exit
EOF


systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=3260/tcp
systemctl restart firewalld

systemctl enable target
systemctl start target


exit 0