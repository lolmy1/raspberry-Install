#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Dieses Script benötigt sudo Rechte!"
  exit
fi

read -p "Soll ein weiterer User angelegt werden? (y,n)" newuser
if [ $newuser == 'y' ]
	then read -p "Benutzername für den neuen Benutzer? " newname
		read -p "Password für den neuen Benutzer? " newpw
		read -p "Soll er in die Sudoer Liste aufgenommen werden? (y,n)" newsudo
		useradd -m -s /bin/bash $newname
		echo $newname:$newpw | chpasswd
		if [ $newsudo == 'y' ]
			then usermod -aG sudo $newname
		fi	
fi
sudo apt update
sudo apt upgrade -y
sudo systemctl enable ssh
sudo systemctl start ssh
sudo apt install xrdp
echo ""
echo ""
echo ""
echo ""
ifconfig | grep 'inet' | grep -v '127.0.0.1' | cut -d: -f2
