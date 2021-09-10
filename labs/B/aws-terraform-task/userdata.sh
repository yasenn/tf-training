#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
apt-get update -y
apt-get install apache2 -y
apt install nfs-common -y

apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-mysql -y
apt install apache2 libapache2-mod-php -y
a2enmod rewrite

cd /tmp
curl -LO https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
sed -i 's|database_name_here|${db_name}|g' /tmp/wordpress/wp-config.php
sed -i 's|username_here|${db_username}|g' /tmp/wordpress/wp-config.php
sed -i 's|password_here|${db_password}|g' /tmp/wordpress/wp-config.php
sed -i 's|localhost|${db_host}:${db_port}|g' /tmp/wordpress/wp-config.php

rm /var/www/html/index.html
cp -a /tmp/wordpress/. /var/www/html
mkdir /var/www/html/wp-content/uploads
chown -R root:www-data /var/www/html
chown -R www-data:www-data /var/www/html/wp-content

service apache2 restart

mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${dns_efs}:/   /var/www/html/wp-content/uploads
chmod -R 777 /var/www/html/wp-content

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html
sudo -u ubuntu wp core install --url=${domain} --title=EpamTaskAWS --admin_user=${wp_username} --admin_password=${wp_password} --admin_email=${wp_email}