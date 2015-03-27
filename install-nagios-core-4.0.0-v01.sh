#!/bin/sh
# 
# install-nagios-core-4.0.0-v02.sh (04 Oct 2013)
# GeekPeek.Net scripts - Install Nagios Core 4.0.0 from sources
#
# INFO: This script was created and tested on fresh CentOS 6.4 minimal installation. The script installs 
# Nagios dependencies and downloads Nagios Core 4.0.0 tarball. It creates nagios user and compiles Nagios Core. 
# It creates Nagios Apache user and sets it's password. It installs EPEL Repository and Nagios plugins.
# It links Nagios plugins to correct directory and starts Nagios and Apache service.
#
# CODE:
architecture=$(uname -i)
/usr/bin/yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp
/usr/bin/wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.0.tar.gz
/bin/tar -xvzf nagios-4.0.0.tar.gz
/usr/sbin/useradd nagios
cd nagios
./configure
/usr/bin/make all
/usr/bin/make install
/usr/bin/make install-init
/usr/bin/make install-config
/usr/bin/make install-commandmode
/usr/bin/make install-webconf
/bin/echo "Please enter nagiosadmin password!"
/usr/bin/htpasswd -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
/bin/rpm -ivh http://ftp-stud.hs-esslingen.de/pub/epel/6/i386/epel-release-6-8.noarch.rpm
/usr/bin/yum install nagios-plugins-all -y
/bin/rm -rf /usr/local/nagios/libexec
case $architecture in
	i386 )
		/bin/ln -s /usr/lib/nagios/plugins/ /usr/local/nagios/libexec
		/bin/chown -R nagios:nagios /usr/local/nagios/libexec/
		;;
	x86_64 )
		/bin/ln -s /usr/lib64/nagios/plugins/ /usr/local/nagios/libexec
		/bin/chown -R nagios:nagios /usr/local/nagios/libexec/
		;;
	* )
		/bin/echo "Unknown architecture! Exiting..."
		exit 3
		;;
esac
/etc/init.d/httpd start
/etc/init.d/nagios start
/bin/echo ""
/bin/echo "Open http://IPADDRESS/nagios or http://FQDN/nagios in your browser and enter nagiosadmin username and password!"

