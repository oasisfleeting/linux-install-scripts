# GeekPeek.Net scripts - CentOS Network Bonding Script
#
# INFO: This script was created and tested on fresh CentOS 6.4 minimal installation. To succesfully configure
# network bonding additional information needs to be provided - bond interface, bonding mode, bonding ip address,
# bonding netmask, bonding gateway, network devices used to create bonding. Script edits ifcfg-bondX, ifcfg-ethX 
# and ifcfg-ethY configuration files and adds a file bonding.conf to /etc/modprobe.d directory. The exsisting ifcf-ethx,
# ifcfg-ethY and bonding.conf are backed up to directory /etc/sysconfig.
#
# This script AUTOMATICALLY restarts network!!
#
# CODE:
/bin/echo "Which bond device are you configuring? (bond0, bond1, bond2, ...)"
read BONDNR
/bin/echo "Which mode number are you configuring? (1 = active-backup, 2 = balance-xor, 3 = broadcast, 4 = 802.3ad, 5 = balance-tlb, 6 = balance-alb)"
read MODENR
/bin/echo "What IP address do you want to assign to $BONDNR? (192.168.1.100)"
read IPADDRNR
/bin/echo "What is the netmask address you want to assign to $BONDNR? (255.255.255.0)"
read NETMASKNR
/bin/echo "What is the gateway address you want to assign to $BONDNR? (192.168.1.1)"
read GATEWAYNR
/bin/echo "List the first network device you want to assign to $BONDNR (eth0, eth1, eth2, ...)"
read NETNR1
/bin/echo "List the second network device you want to assign to $BONDNR (eth0, eth1, eth2, ...)"
read NETNR2
/bin/cp /etc/sysconfig/network-scripts/ifcfg-$BONDNR /etc/sysconfig/ifcfg-$BONDNR.bkp
/bin/cp /etc/modprobe.d/bonding.conf /etc/sysconfig/
/bin/rm /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/rm /etc/modprobe.d/bonding.conf
/bin/echo "This is it ... configuring network bonding for $BONDNR... Backing up config files to /etc/sysconfig/"
/bin/echo "alias $BONDNR bonding" >> /etc/modprobe.d/bonding.conf
/bin/echo "options $BONDNR miimon=80 mode=$MODENR"  >> /etc/modprobe.d/bonding.conf
/bin/echo "DEVICE=$BONDNR" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/echo "IPADDR=$IPADDRNR" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/echo "NETMASK=$NETMASKNR" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/echo "GATEWAY=$GATEWAYNR" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/echo "USERCTL=no" >> /etc/sysconfig/network-scripts/ifcfg-$BONDNR
/bin/cp /etc/sysconfig/network-scripts/ifcfg-$NETNR1 /etc/sysconfig/ifcfg-$NETNR1.bkp
/bin/cp /etc/sysconfig/network-scripts/ifcfg-$NETNR2 /etc/sysconfig/ifcfg-$NETNR2.bkp
/bin/rm /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/rm /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/bin/echo "DEVICE=$NETNR1" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/echo "USERCTL=no" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/echo "MASTER=$BONDNR" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/echo "SLAVE=yes" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR1
/bin/echo "DEVICE=$NETNR2" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/bin/echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/bin/echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/bin/echo "USERCTL=no" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/bin/echo "MASTER=$BONDNR" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/bin/echo "SLAVE=yes" >> /etc/sysconfig/network-scripts/ifcfg-$NETNR2
/etc/init.d/network restart
/bin/sleep 5
/bin/cat /proc/net/bonding/$BONDNR
