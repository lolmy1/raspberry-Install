#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Dieses Script benötigt sudo Rechte!"
  exit
fi

read -p "Wie soll der User der Datenbank heißen?" sqluser
read -p "Wie soll das Passwort für $sqluser sein?" sqluserpw
read -p "Benutzername für den Adminaccount der Cloud?" adminname
read -p "Passwort für den Adminaccount?" adminpw

apt update
apt install php php-ctype php-curl php-dom php-gd php-json php-mbstring php-zip php-mysql php-bz2 php-intl php-ldap php-imap php-bcmath php-gmp php-imagick libapache2-mod-php7.4 apache2 mariadb-server -y

mysql -uroot <<Query
CREATE USER $sqluser@'localhost' IDENTIFIED BY '$sqluserpw';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
Query

wget -P /tmp/ https://download.nextcloud.com/server/releases/nextcloud-23.0.2.zip
unzip /tmp/nextcloud-23.0.2.zip -d /var/www/
chown www-data:www-data -Rv /var/www/nextcloud/

a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

touch /etc/apache2/sites-available/nextcloud.conf
echo "Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
  Require all granted
  AllowOverride All
  Options FollowSymLinks MultiViews
  Satisfy Any

  <IfModule mod_dav.c>
    Dav off
  </IfModule>
</Directory>" | tee /etc/apache2/sites-available/nextcloud.conf

a2ensite nextcloud.conf
systemctl restart apache2

cd /var/www/nextcloud/
sudo -u www-data php occ  maintenance:install --database mysql --database-name nextcloud  --database-user $sqluser --database-pass $sqluserpw --admin-user $adminname --admin-pass $adminpw
