


#  Configuratie Web Server - CHARLIE

  

Hierin staat beschreven hoe de webserver geconfigureerd is, welke stappen ondernomen zijn om tot deze configuratie te komen en verdere uitleg.

  

##  Requirements

  

Aangezien we deze server automatisch willen laten opstarten en provisionen maken we gebruik van de [anisble-skeleton](https://github.com/bertvv/ansible-skeleton) voorzien door [Bert Van Vreckem](https://github.com/bertvv) en moeten dus eerst nog wat voorbereiden werk doen.

  

1. De naam en het IP adres van de server moet toegevoegd worden aan de vagrant-hosts.yml file (Subnet moet niet gespecifieerd worden aangezien deze standaard op /24 gezet word in deze ansible-skeleton)

```yml
- name: charlie
  ip: 192.168.10.196
```

  

2. Deze server moet dan worden toegevoegd als host in site.yml en voegen direct ook de juiste role toe

```yml
- hosts: charlie
  become: true
  roles:
    - geerlingguy.repo-epel
    - geerlingguy.repo-remi
    - geerlingguy.git
    - geerlingguy.postfix
    - geerlingguy.nginx
    - geerlingguy.php-versions
    - geerlingguy.php
    - geerlingguy.php-pecl
    - geerlingguy.composer
    - geerlingguy.postgresql
    - geerlingguy.php-pgsql
    - geerlingguy.drush
    - geerlingguy.drupal
    - centos_rainloop
    - zabbix_server
    - zabbix_web
``` 

We hebben besloten om op deze server gebruik te maken van nginx als webserver. Meer bepaald de [geerlingguy.nginx](https://github.com/geerlingguy/ansible-role-nginx) uitgeschreven door [Jeff Geerling](https://github.com/geerlingguy) Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

 Voor de database maken we gebruik van psql . Meer bepaald de [geerlingguy.postgresql](https://github.com/geerlingguy/ansible-role-postgresql) uitgeschreven door [Jeff Geerling](https://github.com/geerlingguy). Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

 Voor de php instalatie maken we gebruik van volgende rollen. Meer bepaald :
 - [geerlingguy.php-versions](https://github.com/geerlingguy/ansible-role-php-versions) 
 - [geerlingguy.php](https://github.com/geerlingguy/ansible-role-php)
 - [geerlingguy.php-pecl](https://github.com/geerlingguy/ansible-role-php-pecl)
 - [geerlingguy.php-pgsql](https://github.com/geerlingguy/ansible-role-php-pgsql)

uitgeschreven door [Jeff Geerling](https://github.com/geerlingguy). Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

 Voor de cms instalatie maken we gebruik van drupal deze heeftde volgende rollen nodig:
 - [geerlingguy.composer](https://galaxy.ansible.com/geerlingguy/composer) 
 - [geerlingguy.drush](https://galaxy.ansible.com/geerlingguy/drush)
 - [geerlingguy.drupal](https://galaxy.ansible.com/geerlingguy/drupal)

uitgeschreven door [Jeff Geerling](https://github.com/geerlingguy). Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

Voor de uitbreiding van monitor systeem & mail webclient voegen we volgende rollen toe:
 - [centos_rainloop](https://galaxy.ansible.com/mariuszczyz/centos_rainloop)  uitgeschreven door [ mariuszczyz](https://galaxy.ansible.com/mariuszczyz)
 - [Zabbix_ web](https://github.com/ansible-collections/community.zabbix/blob/main/docs/ZABBIX_WEB_ROLE.md) & [Zabbix_server](https://github.com/ansible-collections/community.zabbix/blob/main/docs/ZABBIX_SERVER_ROLE.md) uitgeschreven door de [community.zabbix](https://github.com/ansible-collections/community.zabbix)

Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

3. Nu moeten enkel nog maar een 'roles' en een 'host_vars' directory gemaakt worden in de ansible directory. In host_vars maken we nog een file genaamd charlie.yml en in die file gebeurt alle configuratie. In de roles directory word de gedownloade role geplaatst.

  

```yml
├───files

├───group_vars

├───host_vars

├───roles

│ ├───geerlingguy.repo-epel
  ├───geerlingguy.repo-remi
  ├───geerlingguy.git
  ├───geerlingguy.postfix
  ├───geerlingguy.nginx
  ├───geerlingguy.php-versions
  ├───geerlingguy.php
  ├───geerlingguy.php-pecl
  ├───geerlingguy.composer
  ├───geerlingguy.postgresql
  ├───geerlingguy.php-pgsql
  ├───geerlingguy.drush
  ├───geerlingguy.drupal
  ├───centos_rainloop
  ├───zabbix_server
  ├───zabbix_web
```

  om de rollen te instaleren kan men gebruik maken van het commando in  de anisble directory van het ansible skeleton
  ```bash
  ansible-galaxy install -r requirements.yml
  ```

Op windows moet de naam van de role in de site.yml moet hetzelfde zijn als de naam van de role in de roles directory. Let er ook goed op dat de role nie in nog een direcotry staat (dus geen map in een map) anders vind dit ansible-skeleton de role niet.

  

4. In site.yml voegen we nog een host toe genaamd all, en voegen de role [rh-base role](https://github.com/bertvv/ansible-role-rh-base) & [zabbix_agent](https://github.com/ansible-collections/community.zabbix/blob/main/docs/ZABBIX_AGENT_ROLE.md) toe in de roles directory

 
```yml
- hosts: all
  become: true
  roles:
	- bertvv.rh-base
	- zabbix_agent
```
***note*** : *als windows wordt gebruikt als host machine voegen we ook volgende pre-task toe*
```yml
 pre_tasks:
   - name: install netaddr
     pip:
      name: netaddr
```

We doen dit omdat we enkele dingen op alle servers in ons netwerk willen installeren. Deze manier is dan efficiënter om op elke server standaard de rh-base role te zetten en zodat de zabbix server informatie kan opvragen bij de clients.
  

###  Gebruikte Variabelen

  

| Variable | Beschrijving |

| :------- | ----------------------------------------------------- |

| name | de naam van de server die aangemaakt moet worden |

| ip | het ip adres van de server die moet aangemaakt worden |

  

| Variable | Beschrijving |

| -------- | :----------------------------------------------------------- |

| hosts | naam van de server die geconfigureerd moet worden (wanneer deze all is zullen alle aangemaakte servers die bewerkingen krijgen) |

| become | Wanneer deze op true staat wilt dit zeggen dat we als root user inloggen op de server tijdens de provisioning dus krijgen we alle priveliges |

| roles | roles nodig om server te provisionen |

  

##  Provisioning webserver - Charlie
Eerst gaan we stap voor stap door het configuratie bestand en onderaan dit deel staat dan het volledige charlie.yml bestand
1. PHP
```yml
#boolean voor het auto selecteren van packages
php_install_recommends: no
#gegevens voor php limieten
php_memory_limit: "192M"
php_max_input_time: "300"
php_max_execution_time: "300"
php_max_input_vars: "4000"
#boolean voor exception weergave
php_display_errors: "On"
php_display_startup_errors: "On"
#php cache size groote
php_realpath_cache_size: "1024K"
#gegevens voor opcache
php_opcache_enabled_in_ini: true
php_opcache_memory_consumption: "192"
php_opcache_max_accelerated_files: 4096
#package voor communicatie met de databank
php_pgsql_package: php-pgsql
#php versie te instaleren
php_version: '7.4'
php_packages_state: "latest"
#Repository te gebruiken voor instalatie
php_enablerepo: "remi-php70,epel"
#boolean voor managed ini
php_use_managed_ini: true
#gegevens voor het toewijzen van de webserver
php_webserver_daemon: "nginx"
php_fpm_pool_user: "nginx" # default varies by OS
php_fpm_pool_group: "nginx" # default varies by OS
#boolean voor het activeren van php_fpm
php_enable_php_fpm: true
#address van php_fpm
php_fpm_listen: "127.0.0.1:9000"
#te instaleren php packages
php_packages:
- php
- php-cli
- php-common
- php-devel
- php-fpm
- php-gd
- php-imap
- php-ldap
- php-mbstring
- php-mcrypt
- php-opcache
- php-pdo
- php-pear
- php-pecl-apcu
- php-xml
- php-xmlrpc
- php-pecl-yaml
- php-mysqli
```
3. NGINX
```yml
#Gegevens voor NGINX vhost template
nginx_vhosts:
	#Server naam
  - server_name: "{{drupal_domain}} www.{{drupal_domain}}"
    #Root folder van webservice
    root: "{{drupal_core_path}}"
    #Boolean of de applicatie geschreven is in PHP
    is_php: true
    #extra parameters voor ssl
    extra_parameters: |
      listen 443 ssl;
      ssl_certificate /etc/pki/tls/certs/{{ssl_cert}};
      ssl_certificate_key /etc/pki/tls/certs/{{ssl_key}};
      ssl_protocols TLSv1.1 TLSv1.2;
      ssl_ciphers HIGH:!aNULL:!MD5;
  - server_name: "rainloop.{{drupal_domain}}"
    root: "{{RAINLOOP_WEB_ROOT}}"
    is_php: true
     #extra parameters toegang te blokeren to de data folder
    extra_parameters: |
      location ^~ /data {
      deny all;
      }
  - server_name: "{{zabbix_url}}"
    root: "/usr/share/zabbix"
    is_php: true
#boolean voor het verwijderen van de default vhost
nginx_remove_default_vhost: true
nginx_ppa_use: true
#locatie van te gebruiken template
nginx_vhost_template: "templates/nginx-vhost.conf.j2"
```
4. PSQL
```yml
#gegevens voor het aanmaken van gebruikers
postgresql_users: 
  - name: "{{ drupal_db_user }}"  
    password: "{{ drupal_db_password }}"
  - name: rainloop
    password: rainloop
  - name: zabbix-server
    password: zabbix-server
#gegevens voor het aanmaken van databases
postgresql_databases:
   - name: "{{ drupal_db_name }}"
     owner: "{{ drupal_db_user }}"
   - name: rainloop
     owner: rainloop
   - name: zabbix-server
     owner: zabbix-server
```
5. DRUPAL
```yml
#drupal versie te instaleren
drupal_major_version: 9
#boolean voor automatische instalatie
drupal_install_site: true
drupal_core_owner_become: true
#aangeven van drupal root path
drupal_composer_install_dir: "/var/www/html/drupal"
drupal_core_path: "{{ drupal_composer_install_dir }}/web"
#domein van website toewijzen
drupal_domain: "corona2020.local"
#databank gegevens voor drupal
drupal_db_user: drupal
drupal_db_password: drupal
drupal_db_name: drupal
drupal_db_host: localhost
drupal_db_backend: pgsql
#naam van website
drupal_site_name: "Corona2020"
#te instaleren profiel
drupal_install_profile: standard
```
6. COMPOSER
```yml
drupal_build_composer_project: true
drupal_composer_project_package: "drupal/recommended-project:^9@dev"
drupal_composer_project_options: "--prefer-dist --stability dev --no-interaction"
```
7. ZABBIX
```yml
#gegevens voor nginx configuratie
zabbix_websrv: nginx
zabbix_url: "zabbix.{{drupal_domain}}"
zabbix_vhost: false
zabbix_web_conf_web_user: nginx
zabbix_web_conf_web_group: nginx
#gegevens voor php en php-fpm
zabbix_php_install: false
zabbix_php_fpm_listen: "127.0.0.1:9000"
zabbix_php_fpm_conf_listen: false
zabbix_php_fpm_conf_enable_user: false
zabbix_php_fpm_conf_enable_group: false
zabbix_php_fpm_conf_mode: false
zabbix_php_fpm_conf_enable_mode: false
#boolean voor selinux configuratie
selinux_allow_zabbix_can_network: true
#Gegevens voor databank Zabbix
zabbix_server_database: pgsql
zabbix_server_database_long: postgresql
zabbix_server_dbhost: localhost
zabbix_server_dbname: zabbix-server
zabbix_server_dbuser: zabbix-server
zabbix_server_dbpassword: zabbix-server
zabbix_server_dbport: 5432
```
8. RHBASE
```yml
#Poorten om open te zetten op de server
rhbase_firewall_allow_ports:
- 8025/tcp
- 10050/tcp
#Toegang verlenen aan volgende services
rhbase_firewall_allow_services:
- http
- https
#Te configuren SElinux booleans
rhbase_selinux_booleans:
- httpd_can_network_connect_db
- httpd_can_network_connect
- collectd_tcp_network_connect
- httpd_execmem
```

##  Provisioning ALL

  

1. maakt in de group_vars directory een all.yml bestand

  

2. volgende code installeerd enkele packages op alle servers die handig kunnen zijn

  

```yml
rhbase_install_packages:
- bash-completion
- bind-utils
- git
- nano
- tree
- vim-enhanced
- wget
```

  

##  Uitvoering Provisioning websever - CHARLIE

  

1. Nu moet u in uw gewenste CLI navigeren naar de Ansible-skeleton directory

  

2. Enkel onderstaand commando is nodig om de server aan te maken en te configureren$

  

```bash
$ vagrant up charlie
```

  

Nu zal er een web & zabbix server gemaakt worden met 3 beschikbare webapplicatie en zabbix server voor het opvolgen van de servers en netwerk apparatuur in het netwerk

  

3. Voor te testen of aanpassingen te maken op de server kan volgend commando gerbuikt worden

```bash
$ vagrant ssh charlie
``` 

##  Andere documentatie

[research and testing voor webserver](/)
[Testplan charlie](/TestPlan.md)
[TestRapport charlie](/TestRapport.md)

  

