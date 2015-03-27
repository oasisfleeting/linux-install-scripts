#!/bin/sh
# 
# nagios-3.5.0-install-v01.sh (9 May 2013)
# GeekPeek.Net scripts - Install nagios 3.5.0 from CentALT repository
#
# INFO: This script was tested on CentOS 6.4 minimal installation. The script installs 
# EPEL and CentALT repository. It then installs Nagios 3.5.0 and Nagios plugins and creates
# nagiosadmin user.
#
# CODE:
/bin/rpm -ivh http://ftp-stud.hs-esslingen.de/pub/epel/6/i386/epel-release-6-8.noarch.rpm
/bin/rpm -ivh http://centos.alt.ru/repository/centos/6/i386/centalt-release-6-1.noarch.rpm
/usr/bin/yum install nagios nagios-plugins-all php -y
/bin/ln -s /usr/share/nagios/html/ /var/www/html/nagios
/bin/sed -i -e "15s/None/+Indexes/" /etc/httpd/conf.d/nagios.conf
/bin/sed -ie "17s/deny/#deny/" /etc/httpd/conf.d/nagios.conf
/bin/sed -ie "18s/127.0.0.1/all/" /etc/httpd/conf.d/nagios.conf
/bin/echo "Insert password for Nagios user nagiosadmin!"
/usr/bin/htpasswd -s -c /etc/nagios/passwd nagiosadmin
/etc/init.d/nagios start
/etc/init.d/httpd start
/bin/echo "Install Nagios 3.5.0 script is done!" 
/bin/echo "Point your browser to http://IPADDRESS/nagios and log in with nagiosadmin user!"
/bin/echo "Visit GeekPeek.Net for more bash scripts!"
exit 0

