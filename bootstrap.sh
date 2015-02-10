#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y apache2
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt
sudo apt-get install git

if ! [ -L /var/www ]; then
  rm -rf /var/www/html
  ln -fs /vagrant/www /var/www/html
fi

# WP-CLI Install
if [[ ! -d /var/www/wp-cli ]]; then
	echo -e "\nDownloading wp-cli, see http://wp-cli.org"
	git clone https://github.com/wp-cli/wp-cli.git /srv/www/wp-cli
	cd /var/www/wp-cli
	composer install
else
	echo -e "\nUpdating wp-cli..."
	cd /var/www/wp-cli
	git pull --rebase origin master
	composer update
fi
# Link `wp` to the `/usr/local/bin` directory
ln -sf /var/www/wp-cli/bin/wp /usr/local/bin/wp


# Create the wp database
mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS wpdb"

# Download and install the Wordpress Core Files
wp core download --path=/var/www/html
wp core config --dbname=wpdb --dbuser=root --dbpass=root 

