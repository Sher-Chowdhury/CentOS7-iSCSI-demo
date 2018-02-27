#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '############ About to run setup-iSCSI-initiator.sh script ################'
echo '##########################################################################'

setenforce permissive



yum install -y iscsi-initiator-utils

cp /etc/iscsi/initiatorname.iscsi /tmp/initiatorname.iscsi-orig
cp /etc/iscsi/iscsid.conf /tmp/iscsid.conf-orig

echo 'InitiatorName=iqn.2018-02.net.cb.target:client' > /etc/iscsi/initiatorname.iscsi

#sed -i 's/#node.session.auth.authmethod = CHAP/node.session.auth.authmethod = CHAP/g' /etc/iscsi/iscsid.conf
#sed -i 's/#node.session.auth.username = username/node.session.auth.username = codingbee/g' /etc/iscsi/iscsid.conf
#sed -i 's/#node.session.auth.password = password/node.session.auth.password = password/g' /etc/iscsi/iscsid.conf

# iscsiadm --mode discovery --type sendtargets --portal 192.168.14.100
# iscsiadm --mode node --targetname iqn.2018-02.net.cb.target:fqdn --portal 192.168.14.100 --login

exit 0