#!/bin/bash

USERNAME=""
DOMAIN=""
GROUPS=""
USER=""
SUDOGROUP=""

# Update & upgrade System
echo "##### Update the System #####"
apt update
apt upgrade -y

# Install required packages
echo "##### Install required packages #####"
apt install sssd realmd policykit-1 packagekit sssd-tools libnss-sss libpam-sss adcli sudo -y

# Join and list Active Directory Settings
echo "##### Join the Active Direcotry Domain #####"
realm join -U $USERNAME $DOMAIN
if [ $? == 1] then
	echo "ERROR"
	exit 1
fi

# Edit SSSD Settings
echo "##### Edit SSSD Settings #####"
cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf.backup
sed 's/use_fully_qualified_names = True/use_fully_qualified_names = False/gi' /etc/sssd/sssd.conf >> /etc/sssd/sssd.conf
sed 's/fallback_homedir = \/home\/%u@%d/fallback_homedir = \/home\/%u/gi' /etc/sssd/sssd.conf >> /etc/sssd/sssd.conf

# Edit Pam to create Homedirectory on first login
echo "##### Edit PAM #####"
echo 'session required pam_mkhomedir.so skel=/etc/skel umask=0022' | cat - /etc/pam.d/common-session >> temp && mv temp /etc/pam.d/common-session

# Edit Sudoers to get Sudo
echo "##### Edit Sudoers #####"
echo '%'$SUDOGROUP' ALL=(ALL) ALL' >> /etc/sudoers.d/ad-sudoers

# Restart SSSD
echo "##### Restart SSSD #####"
/etc/init.d/sssd restart

# ALLOW USERS/GROUPS
echo "##### Allow Logins #####"
realm deny --all
realm permit $USER
realm permit -g $GROUPS

echo "##### RESULT #####"
realm list
