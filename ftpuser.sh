#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Dieses Script benötigt sudo Rechte!"
  exit
fi

read -p "Wie soll der neue Benutzer heißen?" username
read -p "Welches Passwort für den User?" userpw

useradd -m -G www-data -s /bin/false $username
echo $username:$userpw | chpasswd