#!/bin/sh
# 
# nagios-core-3.5.0-install-v02.sh (16 May 2013)
# GeekPeek.Net scripts - Install Nagios Core 3.5.0 from sources
#
# INFO: This script was created and tested on fresh CentOS 6.4 minimal installation. The script installs 
# EPEL repository and Nagios dependencies. It creates nagios user and nagcmd group. It downloads
# Nagios 3.5.0 tar from Nagios site - configures and installs Nagios. It creates nagiosadmin Apache
# user for Nagios authentication and starts httpd and nagios service.
#
# v02:
# Added usermod for nagcmd group
#
# CODE:
architecture=$(uname -i)
/bin/rpm -ivh http://ftp-stud.hs-esslingen.de/pub/epel/6/i386/epel-release-6-8.noarch.rpm
/usr/bin/yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp
/usr/sbin/useradd nagios
/usr/sbin/groupadd nagcmd
/usr/sbin/usermod -a -G nagcmd nagios
/usr/bin/wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-3.5.0.tar.gz
/bin/tar -xvzf nagios-3.5.0.tar.gz
cd nagios
./configure --with-command-group=nagcmd
/usr/bin/make all
/usr/bin/make install
/usr/bin/make install-init
/usr/bin/make install-config
/usr/bin/make install-commandmode
/usr/bin/make install-webconf
/usr/bin/yum install nagios-plugins-all -y
/bin/rm -rf /usr/local/nagios/libexec
cd /usr/local/nagios/
case $architecture in
	i386 )
		/bin/ln -s /usr/lib/nagios/plugins/ libexec
		;;
	x86_64 )
		/bin/ln -s /usr/lib64/nagios/plugins/ libexec
		;;
	* )
		/bin/echo "Unknown architecture! Exiting..."
		exit 3
		;;
esac
echo $architecture
/bin/chown nagios:nagios -R libexec/
/bin/echo "Insert password for Nagios user nagiosadmin!"
/usr/bin/htpasswd -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
/usr/sbin/usermod -a -G nagcmd nagios
/usr/sbin/usermod -a -G nagcmd apache
/etc/init.d/httpd start
/etc/init.d/nagios start
