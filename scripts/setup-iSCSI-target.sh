#!/usr/bin/env bash
exit 0
# set -ex

echo '##########################################################################'
echo '##### About to run setup-isCSI-target.sh script #############'
echo '##########################################################################'

yum install -y targetcli

month=$(date +%m)   # 2-digit format, e.g. '02'
year=$(date +%Y)    # 4-digit format, e.g. '2018'


targetcli <<EOF
cd /backstores/block 
create BD1 /dev/sdb
cd /iscsi
create iqn.${year}-${month}.net.cb.target:fqdn
cd /iscsi/iqn.${year}-${month}.net.cb.target:fqdn/tpg1/luns
create /backstores/block/BD1
cd /iscsi/iqn.${year}-${month}.net.cb.target:fqdn/tpg1/acls
create iqn.${year}-${month}.net.cb.target:client
cd /iscsi/iqn.${year}-${month}.net.cb.target:fqdn/tpg1/acls/iqn.${year}-${month}.net.cb.target:client/
set auth userid=codingbee
set auth password=password
exit
EOF


systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=iscsi-target
systemctl restart firewalld

systemctl enable target
systemctl start target


exit 0
