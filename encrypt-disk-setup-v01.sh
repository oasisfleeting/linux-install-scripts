#!/bin/sh
# 
# encrypt-disk-setup-v01.sh (9 June 2013)
# GeekPeek.Net scripts - Encrypt disk/partition with cryptsetup
#
# INFO: This script was created and tested on fresh CentOS 6.4 minimal installation. The script adds disk/partition
# to luks and creates /dev/mapper entry with the desired name. It creates ext3 or ext4 filesystem on the encrypted 
# disk/partition. It also configures automount for encrypted partition (if selected) - it creates keyfile file and 
# adds key to luks, creates desired mount point for encrypted disk/partition and /etc/fstab and /etc/crypttab entries.
#
# Requirements: Additional disk/partition for encryption
#
/bin/echo "Which disk/partition would you like to encrypt? (example: /dev/sdb, /dev/sdb1,...)"
read cryptpart
/bin/echo "Enter the name of the encrypted disk/partition. This is the /dev/mapper name. (example: CryptedPart1)"
read cryptname
/bin/echo "You must enter the same passphrase 4 times during the configuration process!!"
/sbin/cryptsetup luksFormat $cryptpart
/sbin/cryptsetup luksOpen $cryptpart $cryptname
/bin/echo "Which filesystem will the encrypted disk/partition hold? (ext4/ext3)"
read filesystem
/bin/echo "Do you want to automount encrypted disk/partition on boot? This creates the keyfile and crypttab/fstab entry. (y/n)"
read automount
case $automount in
	y)
		/bin/echo "Enter the name and location of keyfile. Usually in /root directory. (example: /root/keyfile)"
		read keyfile
		dd if=/dev/urandom of=$keyfile bs=1024 count=4
		chmod 0400 $keyfile
		/sbin/cryptsetup luksAddKey $cryptpart $keyfile
                /bin/echo "Please enter the desired mount point for the encrypted disk/partition. If it doesn't exist it will be created! (example: /encrypted)"
                read mountpoint
                /bin/mkdir $mountpoint
		case $filesystem in
        		ext4)
                		/sbin/mkfs.ext4 /dev/mapper/$cryptname
                		;;
        		ext3)
                		/sbin/mkfs.ext3 /dev/mapper/$cryptname
                		;;
        		*)
                		/bin/echo "Unknown filesystem $filesystem, creating ext4..."
                		/sbin/mkfs.ext4 /dev/mapper/$cryptname
                		;;
		esac
                /bin/echo "/dev/mapper/$cryptname $mountpoint $filesystem defaults 1 2" >> /etc/fstab
                /bin/echo "$cryptname $cryptpart $keyfile luks" >> /etc/crypttab
		;;
	n)
		/bin/echo "Skipping automount configuration... You will have to manually mount encrypted disk/partition!"
                case $filesystem in
                        ext4)
                                /sbin/mkfs.ext4 /dev/mapper/$cryptname
                                ;;
                        ext3)
                                /sbin/mkfs.ext3 /dev/mapper/$cryptname
                                ;;
                        *)
                                /bin/echo "Unknown filesystem $filesystem, creating ext4..."
                                /sbin/mkfs.ext4 /dev/mapper/$cryptname
                                ;;
                esac
		;;
	*)
		/bin/echo "Skipping automount configuration... You will have to manually mount encrypted disk/partition!"
                case $filesystem in
                        ext4)
                                /sbin/mkfs.ext4 /dev/mapper/$cryptname
                                ;;
                        ext3)
                                /sbin/mkfs.ext3 /dev/mapper/$cryptname
                                ;;
                        *)
                                /bin/echo "Unknown filesystem $filesystem, creating ext4..."
                                /sbin/mkfs.ext4 /dev/mapper/$cryptname
                                ;;
                esac
		;;
esac
/bin/echo "Setup has finished! Your encrypted disk/partition is ready to be used!"
