#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run install-rpms.sh script ##################'
echo '##########################################################################'

yum install -y epel-release 
yum install -y vim 
yum install -y bash-completion 