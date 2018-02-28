#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run install-rpms.sh script ##################'
echo '##########################################################################'

yum install -y epel-release 
yum install -y vim 
yum install -y bash-completion 
yum install -y man-pages
#yum install -y tree
#yum install -y nc
#yum install -y git
yum install -y bash-completion-extras 
