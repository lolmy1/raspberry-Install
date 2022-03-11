#!/bin/bash

config='/etc/vsftpd.conf'

if [ "$EUID" -ne 0 ]
  then echo "Dieses Script benötigt sudo Rechte!"
  exit
fi

apt update
apt install vsftpd -y

sed -i 's/#write_enable=YES/write_enable=YES/g' $config
sed -i 's/#chroot_local_user=YES/chroot_local_user=YES/g' $config
echo "allow_writeable_chroot=YES" | tee -a $config
echo "user_sub_token=$USER" | tee -a $config
echo "local_root=/home/$USER" | tee -a $config
/etc/init.d/vsftpd restart
