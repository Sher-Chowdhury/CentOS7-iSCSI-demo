#!/usr/bin/env bash
exit 0
set -ex

echo '##########################################################################'
echo '############ About to run setup-iSCSI-initiator.sh script ################'
echo '##########################################################################'

yum install -y iscsi-initiator-utils

cp /etc/iscsi/initiatorname.iscsi /tmp/initiatorname.iscsi-orig
cp /etc/iscsi/iscsid.conf /tmp/iscsid.conf-orig


month=$(date +%m)   # 2-digit format, e.g. '02'
year=$(date +%Y)    # 4-digit format, e.g. '2018'
                    
echo "InitiatorName=iqn.${year}-${month}.net.cb.target:client" > /etc/iscsi/initiatorname.iscsi

sed -i 's/#node.session.auth.authmethod = CHAP/node.session.auth.authmethod = CHAP/g' /etc/iscsi/iscsid.conf
sed -i 's/#node.session.auth.username = username/node.session.auth.username = codingbee/g' /etc/iscsi/iscsid.conf
sed -i 's/#node.session.auth.password = password/node.session.auth.password = password/g' /etc/iscsi/iscsid.conf






iscsiadm --mode discovery --type sendtargets --portal 192.168.14.100

systemctl start iscsi
systemctl enable iscsi


# the above daemon should work to sort this out. So following command isn't needed. 
# iscsiadm --mode node --targetname iqn.${year}-${month}.net.cb.target:fqdn --portal 192.168.14.100 --login

sleep 5 
mkfs.xfs -f -L iscsi_device /dev/sdb
# -f is force overwrite


mkdir /mnt/remotedisk


echo 'LABEL="iscsi_device" /mnt/remotedisk    xfs     _netdev        0 0' >> /etc/fstab


mount -a



# only run the following when shutting down the box
# umount /dev/sdb
# systemctl stop iscsi

exit 0


