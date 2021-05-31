# Configuration AWS Could servers

In dit document kan u alle informatie vinden nodig om meerdere servers automatisch op te zetten en te provisionen met behulp van Ansible.

## Opmerking

We hebben gekozen voor AWS voor onze cloud omgeving. Dit hebben we gedaan omdat we als groep hadden afgesproken om alle cloud services eens te bekijken. Jochen en ik (Owen) hebben ons onderzoek op AWS geconcentreerd en niemand anders had verdere input of commentaar dus hebben we voor AWS gekozen.

In dit document gaan we ervan uit dat we deze configuratie op een Linux systeem doen en dus niet meer met de Ansible-skeleton die met behulp van vagrant alles automatiseerd. Dit doen we omdat na wa initiële tests het niet mogelijk was, of toch veel moeilijker, om alles met het skeleton te doen.

Ook maken we geen gebruik van het student account die ons is gegeven door HOGENT, deze is veel te gelimiteerd en kunnen niet aan alle nodige gegevens om het aanmaken van de servers automatisch te laten verlopen. Dit wil zeggen dat we een eigen account moeten maken en hiervoor hebben we een credit card nodig. Ook gaan we, als we het kostenloos willen houden, bepaalde dingen niet kunnen doen. Elastic IP's huren kost geld, we gaan geen CentOS servers gebruiken maar gewone RedHat servers en een VPN verbinding leggen kost (voor zover wij kunnen zien/hebben gevonden) ook geld. Ook zijn we beperkt tot het maken van t2.micro servers, deze zijn de enige free tier eligable servers, hierdoor kan ClamAV niet geïnstalleerd worden op de mail server DELTA want dit programma heeft hogere requirements.

## Requirement

Al deze requirements zijn dingen die éénmalig moeten gedaan worden of niet ge-automatiseerd kunnen worden. Daarom vonden we het niet nuttig om dit allemaal met Ansible te doen en gewoon de AWS GUI te gebruiken.

### Nodige Key's

In totaal hebben we 3 key's nodig de AWS access key, de AWS secret key en de key pairs. De eerst twee key's zijn key's die nodig zijn in onze site.yml om de instances (= servers) aan te maken onder het juiste AWS account. De laatste key is zodanig dat niet altijd een wachtwoord nodig is om in te loggen in de instances, dit vereenvoudigd de automatisatie enorm.

Hoe deze key's aanmaken/downloaden:

1. Wanneer u bent ingelogd op de AWS console klik op uw naam rechtsbovenaan de pagina en dan op My Security Credentials

   ![screenshot 1](/doc/AWS/img/Screenshot_1.png)

2. Klik op Create New Access Key, download deze file en sla ze ergens veilig op

   ![screenshot 2](/doc/AWS/img/Screenshot_2.png)

3. klik nu op Services en zoek naar EC2

   ![screenshot 3](/doc/AWS/img/Screenshot_3.png)

4. Navigeer in de linker balk naar Key Pairs

   ![screenshot 4](/doc/AWS/img/Screenshot_4.png)

5. Create key pair

   ![screenshot 5](/doc/AWS/img/Screenshot_5.png)

6. Geef een gepaste naam en duid pem aan

   ![screenshot 6](/doc/AWS/img/Screenshot_6.png)

7. Nu heeft u alle nodige keys voor het aanmaken van de servers in AWS

### VPC - ACL's

VPC is een Virtual Private Cloud. We willen dit maken voor meerdere redenen. Een VPC geeft ons meer controle over het domein waarin een instance zich bevind, ook kunnen we al onze instances een private IPv4 address geven (wat instances in een VPC gebruiken om te communiceren met elkaar), ook als we later onze servers op AWS willen verbinden met onze lokale servers zal een VPC een grote hulp zijn. 

We kunnen een instance echter niet direct in een VPC toe voegen maar moeten deze aan een VPC subnet toevoegen. Dit is echter geen probleem aangezien het subnet hetzelfde netwerk mag zijn als de VPC zelf.

Tijdens het maken van de VPC en VPC subnet mogen we niet vergeten aanpassingen te maken aan het network ACL, voor een correcte provisioning en configuratie te garanderen van de instances moeten we SSH en ICMP toelaten van elke mogelijke host, dit zal de points of failure ook beperken. Als we dit netwerk echt zouden moeten maken voor een bedrijf laten we dit uiteraard niet toe vanuit elke host omdat dit een slechte security zou zijn.

Het aanmaken van VPC en VPC subnets doet men als volgt:

1. Klik op Services, zoek vpc en klik op VPC

   ![screenshot 7](/doc/AWS/img/Screenshot_7.png)

2. Navigeer op de linke balk naar Your VPCs en klik op Create VPC

   ![screenshot 8](/doc/AWS/img/Screenshot_8.png)

3. Geef de VPC een naam en het netwerk waarin u wilt dat de prive IP adressen zitten en klik op create VPC

   ![screenshot 9](/doc/AWS/img/Screenshot_9.png)

4. navigeer op de linker balk naar Subnets en klik Create subnet

   ![screenshot 10](/doc/AWS/img/Screenshot_10.png)

5. Selecteer de VPC die u juist heeft aangemaakt, geef het subnet een naam een IPv4 CIDR block en klik op Create subnet

   ![screenshot 11](/doc/AWS/img/Screenshot_11.png)

6. Navigeer op de linker balk naar Network ACLs > selecteer de acl van uw VPC (staat onder VPC) > selecteer inbound rules > Edit inbound rules

   ![screenshot 16](/doc/AWS/img/Screenshot_16.png)

7. Voeg 2 regels toe zoals in onderstaande afbeelding en klik op save

   ![screenshot 17](/doc/AWS/img/Screenshot_17.png)

### Internet Gateway - Routing Table

Een Internet Gateway is een component die een VPC toelaat toegang te hebben tot het internet. We mogen deze dan ook niet vergeten toevoegen aan de Routing Tabel, anders heeft de gateway niet veel nut.

Het aanmaken en toekennen van de Internet Gateway doet men als volgt:

1. Navigeer op de linker balk naar Internet Gateways en klik op Create internet gateway

   ![screenshot 12](/doc/AWS/img/Screenshot_12.png)

2. Geef een gepaste naam en klik op Create internet gateway

   ![screenshot 13](/doc/AWS/img/Screenshot_13.png)

3. Klik op Actions > Attach to VPC of u kan ook gewoon op Atach to a VPC klikken bovenaan de pagina

   ![screenshot 14](/doc/AWS/img/Screenshot_14.png)

4. Selecteer de VPC die we eerder gemaakt hebben en klik op Attach internet gateway

   ![screenshot 15](/doc/AWS/img/Screenshot_15.png)

5. Navigeer nu naar Route Tables in de linker kolom en klik op de Route Table ID die bij de VPC hoort die u heeft aangemaakt, klik dan op Routes en Edit routes

   ![screenshot 21](/doc/AWS/img/Screenshot_21.png)

6. Klik op Add route > zet de Destination gelijk aan 0.0.0.0/0 en Target is de Internet Gateway die u hiervoor gemaakt hebt > Save routes en op het volgende scherm klik gewoon close

   ![screenshot 22](/doc/AWS/img/Screenshot_22.png)

### Security Group - Rules

Een Security Group is een virtuele firewall voor instances. We moeten deze maken want als we dit niet doen gaat de VPC een default security group maken voor onze instances en deze zou niet juist geconfigureerd zijn. Net zoals de Network ACL's moeten we SSH en ICMP voor IPv4 vanaf elke host toelaten, anders kunnen de instances niet juist geprovisioned en geconfigureerd worden met Ansible.

Een Security Group aanmaken, deze aan een VPC toekennen en de rules aanpassen doet men als volgt:

1. Navigeer op de linker balk naar Security Groups en klik op Create new security group

   ![screenshot 18](/doc/AWS/img/Screenshot_18.png)

2. Geef een gepaste naam en omschrijving, selecteer de VPC van die we eerder hebben aangemaakt

   ![screenshot 19](/doc/AWS/img/Screenshot_19.png)

3. Voeg 2 inbound regels toe zoals onderstaande afbeelding en klik op create security group

   ![screenshot 20](/doc/AWS/img/Screenshot_20.png)

## Configuratie Ansible Playbook & inventory

Eerst maken we een ansible map, daarin plaatsen we 3 files: site.yml, inventory.txt en de key pair die u voordien heeft aangemaakt ("naam van de key".pem) en gedownload heeft, en dan 2 folders: group_vars en roles (alle andere files en folders die aanwezig zijn hebben te maken met de servers, om hier meer uitleg over te krijgen moet u naar de configuratie bestanden van die servers zelf kijken en worden hier niet behandeld).

Voor we iets aanpassen in onze Ansible playbook moeten we de permissions van onze key veranderen. 

1. Gebruik uw geprefereerde CLI om naar de Ansible file te navigeren

2. Wanneer u zich in deze directory bevind moet u volgende code uitvoeren

   ```
   $ sudo chmod 600 *naam_key*.pem
   ```

### site.yml

Op het einde staat de volledige code, maar eerst gaan we stap voor stap door site.yml.

1. hosts en vars

   ```
   # site.yml
   # dit kan allemaal enkel in een linux omgeving gemaakt worden met ansible instalatie (misschien ook een mac)
   ---
   - hosts: localhost
     vars:
       #owen vars
       aws_access_key: AKIAJJH4TRBB7TJMGBOQ
       aws_secret_key: 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
       key_name: awdtest
       group: CORONA2020
       vpc_subnet_id: subnet-00302bce90c97dd61
       #jochen keys
       # aws_access_key: AKIAIHGSA4GHRVEZ4JPQ
       # aws_secret_key: 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
       # key_name: testkey
       # group: testgroup
       # vpc_subnet_id: subnet-04a4d350660b7c28e
   ```

   Als hosts kiezen we hier localhost, deze naam maakt niet zo veel uit aangezien we geen locale server gaan aanmaken maar AWS instances. Aangezien we met 2 personen aan dit deel van het project gewerkt hebben en om het testen eenvoudiger te maken gebruiken we vars om waarden die we veel moesten wisselen reeds in de site.yml te hebben staan en alles efficiënter te kunnen doen verlopen. Hier moet de persoon die de code test of iemand die zelf de cloud instances wilt maken zijn/haar gegevens plaatsen. aws_acces_key en aws_secret_key zijn de keys die we eerder in dit document achterhaald hebben. key_name is da naam van de key die we aangemaakt hebben eerder in dit document en die ook in dit playbook staat. De group is de Security Group en vpc_subnet_id is het id van de VPC subnet

2. task 1: install boto

   ```
     tasks:
       - name: install boto
         pip: 
           name: 
             - boto3
             - boto
           state: latest
   ```

   Deze task installeerd boto en boto3. Boto3 is een AWS software Development Kit voor phyton. Deze packages zijn nodig om een correcte aanmaak/installatie/configurate/provisioning van de instances te garanderen

3. taks 2: Instance aanmaken

   ```
   #Instance DNS aanmaken
       - name: Provision DNS instance
         ec2:
           aws_access_key: "{{ aws_access_key }}"
           aws_secret_key: "{{ aws_secret_key }}"
           key_name: "{{ key_name }}"
           instance_type: t2.micro
           image: ami-0fc841be1f929d7d1
           wait: true
           exact_count: 1
           count_tag:
             Name: bravo
           instance_tags:
             Name: bravo
           region: eu-west-2
           group: "{{ group }}"
           vpc_subnet_id: "{{ vpc_subnet_id }}"
           private_ip: 192.168.10.195
           assign_public_ip: yes
         register: DNS_CORONA2020
   ```

   In deze task gaan we een instance aanmaken, door deze taak uit te voeren creeëren we een t2.micro RedHat instance met de naam bravo op het account, in de security group en in de vpc dat we meegeven met de lokale variabelen. We moeten dit nog 2 maal doen aangezien we in totaal 3 servers hebben, enkel de Name, en private_ip moeten aangepast worden. Image is het type van de instance, hier dus een RedHat instance.Wait gaat ervoor zorgen dat de configuratie van de server niet doorgaat tot deze online gaat, dit is echter niet hetzelfde als wait_for_ssh. Exact count is het aantal instances we willen maken, hier dus 1. Name zijn de namen van de instances. Region staat hier ingesteld op Londen. Group is de security group. vpc_subnet_id is het VPC subnet waar we de server willen aan toevoegen. Private_ip is het private IP address die we aan de instance willen geven. Assign_public_ip, hiermee zorgen we ervoor dat de instance ook nog een public IP address krijgt zodanig dat deze kan communiceren met de rest van het internet. Ten slotte register, dit zal een lijst van de instances opslaan als een lokale variabele.

4. task 3: De ec2 instance in een group steken

   ```
   #Instance DNS in een groep steken om te kunnen provisionen
       - name: De DNS instance public IP to host group
         add_host: 
           hostname="{{ item.public_ip }}" groups=dns
         loop: "{{DNS_CORONA2020.instances}}"
   ```

   De hosts moeten in een group gestoken worden zodanig dat we de hosts kunnen provisionen en de juiste roles kunnen toe kennen. Hier kennen we de ec2 instance bravo toe aan de dns group. Deze code moeten we opnieuw nog 2 keer doen aangezien we nog 2 andere instances aanmaken.

5. task 4: Wait for ssh

   ```
   #Wachten tot er een ssh verbinding gemaakt kan worden met de DNS instance
       - name: Wait for ssh
         delegate_to: "{{ item.public_ip }}"
         remote_user: ec2-user
         wait_for_connection:
           delay: 30
           timeout: 120
         loop: "{{DNS_CORONA2020.instances}}"
   ```

   Deze code zorgt ervoor dat de ec2 instance alle status checks kan doen en dat we zeker in de instance kunnen ssh'en. Opnieuw gaan we dit nog 2 keer herhalen.

6. task 5: Roles toekennen aan instances

   ```
   #De rol rhbase aan alle instances geven
   - hosts: all
     name: add rhbase role
     become: true
     gather_facts: true
     remote_user: ec2-user
     roles:
       - bertvv.rh-base
   
   #De BIND-rol provisionen op de dns-server
   - hosts: dns
     name: Add bind role
     gather_facts: yes
     remote_user: ec2-user
     roles:
       - bertvv.bind
   ```

   hosts: all zorgt ervoor dat we de rh-base role gaan installeren op alle servers. Hosts: dns zorgt ervoor dat we de role bind toekenen aan de dns server bravo, verdere provisioning gebeurt in de group_vars folder. Gather facts zorgt ervoor dat alle fact modules seriëel worden uitgevoerd. Become: true omdat we root rechten moeten hebben op de server en remote_user: ec2-user omdat AWS automatisch met deze user probeert in te loggen.

7. Volledige site.yml

   ```
   # site.yml
   # dit kan allemaal enkel in een linux omgeving gemaakt worden met ansible instalatie (misschien ook een mac)
   ---
   - hosts: localhost
     vars:
       #owen vars
       aws_access_key: AKIAJJH4TRBB7TJMGBOQ
       aws_secret_key: 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
       key_name: awdtest
       group: CORONA2020
       vpc_subnet_id: subnet-00302bce90c97dd61
       #jochen keys
       # aws_access_key: AKIAIHGSA4GHRVEZ4JPQ
       # aws_secret_key: 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
       # key_name: testkey
       # group: testgroup
       # vpc_subnet_id: subnet-04a4d350660b7c28e
     tasks:
       - name: install boto
         pip: 
           name: 
             - boto3
             - boto
           state: latest
           
   #Instance DNS aanmaken
       - name: Provision DNS instance
         ec2:
           aws_access_key: "{{ aws_access_key }}"
           aws_secret_key: "{{ aws_secret_key }}"
           key_name: "{{ key_name }}"
           instance_type: t2.micro
           image: ami-0fc841be1f929d7d1
           wait: true
           exact_count: 1
           count_tag:
             Name: bravo
           instance_tags:
             Name: bravo
           region: eu-west-2
           group: "{{ group }}"
           vpc_subnet_id: "{{ vpc_subnet_id }}"
           private_ip: 192.168.10.195
           assign_public_ip: yes
         register: DNS_CORONA2020
   #Instance DNS in een groep steken om te kunnen provisionen
       - name: De DNS instance public IP to host group
         add_host: 
           hostname="{{ item.public_ip }}" groups=dns
         loop: "{{DNS_CORONA2020.instances}}"
   #Wachten tot er een ssh verbinding gemaakt kan worden met de DNS instance
       - name: Wait for ssh
         delegate_to: "{{ item.public_ip }}"
         remote_user: ec2-user
         wait_for_connection:
           delay: 30
           timeout: 120
         loop: "{{DNS_CORONA2020.instances}}"
   
   #Instance MAIl aanmaken
       - name: Provision MAIL instance
         ec2:
           aws_access_key: "{{ aws_access_key }}"
           aws_secret_key: "{{ aws_secret_key }}"
           key_name: "{{ key_name }}"
           instance_type: t2.micro
           image: ami-0fc841be1f929d7d1
           wait: true
           exact_count: 1
           count_tag:
             Name: delta
           instance_tags:
             Name: delta
           region: eu-west-2
           group: "{{ group }}"
           vpc_subnet_id: "{{ vpc_subnet_id }}"
           private_ip: 192.168.10.197
           assign_public_ip: yes
         register: MAIL_CORONA2020
   #Instance MAIL in een groep steken om te kunnen provisionen
       - name: De MAIL instance public IP to host group
         add_host: 
           hostname="{{ item.public_ip }}" groups=mail
         loop: "{{ MAIL_CORONA2020.instances }}"
   #Wachten tot er een ssh verbinding gemaakt kan worden met de MAIL instance
       - name: Wait for ssh mail
         delegate_to: "{{ item.public_ip }}"
         become: true
         remote_user: ec2-user
         wait_for_connection:
           delay: 30
           timeout: 120
         loop: "{{ MAIL_CORONA2020.instances }}"
   
   #Instance WEB aanmaken
       - name: Provision WEB instance
         ec2:
           aws_access_key: "{{ aws_access_key }}"
           aws_secret_key: "{{ aws_secret_key }}"
           key_name: "{{ key_name }}"
           instance_type: t2.micro
           image: ami-0fc841be1f929d7d1
           wait: true
           exact_count: 1
           count_tag:
             Name: charlie
           instance_tags:
             Name: charlie
           region: eu-west-2
           group: "{{ group }}"
           vpc_subnet_id: "{{ vpc_subnet_id }}"
           private_ip: 192.168.10.196
           assign_public_ip: yes
         register: WEB_CORONA2020
   #Instance WEB aan een groep toevoegen om te kunnen provisionen
       - name: De WEB instance public IP to host group
         add_host: 
           hostname="{{ item.public_ip }}" groups=web
         loop: "{{ WEB_CORONA2020.instances }}"
   #Wachten tot er een ssh verbinding gemaakt kan worden met de WEB instance
       - name: Wait for ssh web
         delegate_to: "{{ item.public_ip }}"
         become: true
         remote_user: ec2-user
         wait_for_connection:
           delay: 30
           timeout: 120
         loop: "{{ WEB_CORONA2020.instances }}"
   
   #De rol rhbase aan alle instances geven
   - hosts: all
     name: add rhbase role
     become: true
     gather_facts: true
     remote_user: ec2-user
     roles:
       - bertvv.rh-base
   
   #De BIND-rol provisionen op de dns-server
   - hosts: dns
     name: Add bind role
     gather_facts: yes
     remote_user: ec2-user
     roles:
       - bertvv.bind
   
   #De MAIL-rol provisionen op de mail-server  
   - hosts: mail
     name: add mail role
     become: true
     gather_facts: yes
     remote_user: ec2-user
     roles: 
       - mailserver
   
   #De WEB-rollen provisionen op de web-server
   - hosts: web
     name: addroles
     become: true
     gather_facts: yes
     remote_user: ec2-user
     pre_tasks:
       - name: copy ssl key
         copy:
           src: "{{ssl_key}}"
           dest: "/etc/pki/tls/certs/{{ssl_key}}"
           
       - name: copy ssl cert
         copy: 
           src: "{{ssl_cert}}"
           dest: "/etc/pki/tls/certs/{{ssl_cert}}"
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
       
     post_tasks:
       - name: Change file ownership, group and permissions
         file:
           path: "{{drupal_composer_install_dir}}"
           state: directory
           recurse: yes
           owner: nginx
           group: nginx
       - name: Update SeLinux premisions on drupal
         command: "sudo chcon -t httpd_sys_content_rw_t {{drupal_composer_install_dir}}"
         #when: rhbase_selinux_state == 'enforcing' or rhbase_selinux_state == 'permissive'
       - name: Update SeLinux premisions on drupal default
         command: "sudo chcon -t httpd_sys_content_rw_t {{drupal_composer_install_dir}}/web/sites/default/"
         #when: rhbase_selinux_state == 'enforcing' or rhbase_selinux_state == 'permissive'
       - name: Update SeLinux premisions on drupal files
         command: "sudo chcon -t httpd_sys_content_rw_t {{drupal_composer_install_dir}}/web/sites/default/files/"
         #when: rhbase_selinux_state == 'enforcing' or rhbase_selinux_state == 'permissive'
       - name: Update SeLinux premisions on drupal settings.php
         command: "sudo chcon -t httpd_sys_content_rw_t {{drupal_composer_install_dir}}/web/sites/default/settings.php"
         #when: rhbase_selinux_state == 'enforcing' or rhbase_selinux_state == 'permissive'
       - name: drupal reset cache
         command: "{{ drush_path }} cr"
         #when: rhbase_selinux_state == 'enforcing' or rhbase_selinux_state == 'permissive'
   ```

   Code niet beschreven hierboven maar die toch in de site.yml staat is code die bij een specifieke server behoord en niets te maken heeft met AWS. Voor verdere informatie over deze code moet u de configuratie bestanden bekijken van die specifieke server.

### inventory.txt

```
localhost ansible_connection=local
[dns]
[dns:vars]
ansible_ssh_private_key_file=testkey.pem
ansible_ssh_private_key_file=awstest.pem
[mail]
[mail:vars]
ansible_ssh_private_key_file=testkey.pem
ansible_ssh_private_key_file=awstest.pem
[web]
[web:vars]
ansible_ssh_private_key_file=testkey.pem
ansible_ssh_private_key_file=awstest.pem
```

In de inventory.txt zorgen we ervoor dat alle code van de localhost ook lokaal worden uitgevoerd en dat hiervoor niet een andere server word aangemaakt. Voor de rest overlopen we alle groups om de key mee te geven als variabele zodanig da we in elke server in kunnen tijdens het automatisch provisionen. Hier plaatst u dus opnieuw de naam van de key die u aangemaakt en gedownload heeft.

### group_vars

In de group_vars folder maken we alle .yml bestanden aan met de namen die we gegeven hebben aan de groups in de site.yml. De code in deze .yml bestanden is hetzelfde als de code van de servers appart. Als u meer wilt weten over deze code moet u de configuratie bestanden van de specifieke servers bekijken.

### roles

Hier worden alle gedownloade en gebruikte roles geplaatst.

## Uitvoeren ansible playbook

Om dit ansible playbook uit te voeren moet u in uw geprefereerde CLI naar het ansible directory navigeren en volgend commando uitvoeren:

```
$ ansible-playbook -i inventory.txt site.yml
```

## Research, Testplan, Testrapport

[Reasearch and testing](/doc/AWS/Reasearch_and_testing.md)

[TestPlan](/doc/AWS/TestPlan.md)

[TestRapport](/doc/AWS/TestRapport.md)

## Extra

### VPC automatisatie

In dit document/project maken we geen gebruik van deze code omdat het uiteindelijk geen deel bleek te zijn van de opdracht, maar aangezien we er tijd hebben in gestoken willen we het sowieso in dit document plaatsen.

Voor we de VPC met behulp van ansible kunnen aanmaken moeten we een module installeren. Om dit te doen moet u in een CLI volgend commando uitvoeren:

```
$ ansible-galaxy collection install amazon.aws
```

Nadat dit gedaan is kan u een vpc maken door in de site.yml volgende code te zetten:

```
# Een vpc aanmaken
    - name: create a VPC
      amazon.aws.ec2_vpc_net:
        aws_access_key: "{{ aws_access_key }}"
        aws_secret_key: "{{ aws_secret_key }}"
        key_name: "{{ key_name }}"
        cidr_block: 192.168.10.0/24
        region: eu-west-2
      register: vpc
# VPC subnets een id geven
    - name: vpc id
      set_fact: 
        vpc_id: "{{ item.id }}"
      loop: "{{ vpc.instances }}"
```

