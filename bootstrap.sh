#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y apache2
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt
sudo apt-get install -y git

if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant/www /var/www/html
fi

# WP-CLI Install
if [[ ! -d /var/www/wp-cli ]]; then
	echo -e "\nDownloading wp-cli, see http://wp-cli.org"
	mkdir /var/www/wp-cli
	sudo wget -q -P /var/www/wp-cli https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	sudo mv /var/www/wp-cli/wp-cli.phar /usr/local/bin/wp
	sudo chmod +x /usr/local/bin/wp
fi

# Create the wp database
mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS wpdb"

# run wp as vagrant, not as root.  wp hates running as root.
if (( $EUID == 0 )); then
    wp() { sudo -EH -u vagrant -- wp "$@"; }
fi

# Download and install the Wordpress Core Files
wp core download --path=/var/www/html
wp core config --path=/var/www/html --dbname=wpdb --dbuser=root --dbpass=root 
wp core install --path=/var/www/html --url=http://www.wp.dev --title='Wordpress Dev Site' --admin_user=devadmin --admin_password=adminpass
