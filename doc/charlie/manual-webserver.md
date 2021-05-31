   ## Install webserver
    sudo dnf update
    sudo dnf install nginx
    sudo systemctl start nginx
  ## Install database
    dnf module list postgresql
    sudo dnf module enable postgresql:12
    sudo dnf install postgresql-server
    sudo postgresql-setup --initdb
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    sudo -u postgres createuser --pwprompt --encrypted --no-adduser --no-createdb drupal
    sudo -u postgres createdb --encoding=UNICODE --owner=drupal drupaldb
## php install
     dnf module list php
     sudo dnf install php-fpm php-pgsql php-cli php-dom php-pdo php-xml php-gd php-openssl php-mbstring php-json php-zip

## config files edit
	- /etc/php-fpm.d/www.conf
		- change user and group to nginx 

```
; RPM: apache user chosen to provide access to the same directories as httpd
user = nginx
; RPM: Keep a group allowed to write in log dir.
group = nginx
```

    sudo systemctl start php-fpm
	sudo systemctl restart nginx
## composer install
	sudo dnf -y install wget
	wget https://getcomposer.org/installer -O composer-installer.php
	sudo php composer-installer.php --filename=composer --install-dir=/usr/local/bin 

## Drupal
```php
composer create-project drupal/recommended-project my_site_name_dir
```
	 
