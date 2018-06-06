#!/bin/bash
echo "What is the user name you would like for the jailed sFTP user?"
read JailedUser
if getent group sftpusers > /dev/null ; then
	:
else 
	groupadd sftpusers
fi
if getent passwd $JailedUser > /dev/null ; then
	usermod -g sftpusers -d /incoming -s /sbin/nologin $JailedUser
else 
	useradd -g sftpusers -d /incoming -s /sbin/nologin $JailedUser
	echo "Please specify a password."
	read JailedPass
	echo $JailedUser:$JailedPass | chpasswd
fi
mkdir -p /sftp/$JailedUser/incoming
chown $JailedUser:sftpusers /sftp/$JailedUser/incoming

