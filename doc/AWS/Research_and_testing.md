# A brief research and testing to Amazon Web Services

Hierin volgt een kleine handleiding over hoe je met AWS moet werken. Alles dat gevonden werd dat nuttig kan zijn voor het project wordt hierin gezet en dan verder uitgewerkt.

## Automatisatie
Om ons project te automatiseren in aws maken we gebruik van deze code. hierbij wordt aws als plugin gebruikt in vagrant en kan je eig hetzelfde doen met je servers als wat je normaal zou doen in vagrant met locale bestanden van servers.
[AWS in vagrant](https://github.com/mitchellh/vagrant-aws)

Ook is er blijkbaar een ook een [role voor ansible en AWS](https://github.com/memiah/ansible-role-aws-ec2). Deze zouden we ook kunnen onderzoeken voor het opstellen van de servers in de cloud.

[Ansible heeft AWS ook al geïntegreerd](https://www.ansible.com/integrations/cloud/amazon-web-services) dus kan het interessant zijn om te kijken of we misschien gewoon geen linux omgeving kunnen opzetten, daarin Ansible installeren en zo alles op de cloud proberen krijgen.

### Eerst poging automatisatie

Gebruik makend van een [Ansible documentatie](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html) is er een eerste poging ondernomen. Uiteindelijk heb ik eerst geprobeerd om deze letterlijk over te nemen als een test, maar dit is volledig gefaald.

![site.yml](/doc/AWS/img/eerste_poging_1.JPG)

Hier was het doel om alles gewoon te kopiëren in de site.yml file in de ansible skeleton om meer te weten te komen en te leren.

![output](/doc/AWS/img/eerste_poging_2.JPG)

Na het installeren van boto en boto3 en na een hele hoop troubleshooting hebben we de code gevonden die we moeten gebruiken om 5 redhat servers aan te maken op het profiel van Jochen.

![code automatisatie](/doc/AWS/img/eerste_poging_3.JPG)

Output:

![output](/doc/AWS/img/eerste_poging_4.png)

**Belangrijke info: gelieven deze code niet zomaar uit te voeren aangezien het servers gaat aanmaken op Jochen zijn persoonlijke AWS Console en dit zou hem uiteindelijk geld kunnen kosten!!!**

Wat we hieruit geleerd hebben:

- we kunnen perfect 5 servers opstarten in AWS automatisch
- we moeten boto en boto3 packages installeren op de server
- voor elke region heeft een image een verschillend id

Moeilijkheden:

- ssh key pairs maken om in de servers in te ssh'en
- deze manier kan enkel met een normaal account, niet met een student account
- we hebben enkel nog maar redhat servers en nog geen centOS servers

Na verdere troubleshooting hebben we echter gevonden dat gewoon de .pem bij de keyname weg moest.

Gebruikte links

- https://crunchify.com/how-to-install-boto3-and-set-amazon-keys-a-python-interface-to-amazon-web-services/
- https://www.google.com/search?q=aws+ssh+without+pem&oq=aws+ssh+withou&aqs=chrome.0.0i457j0j69i57j0j0i22i30l4.6674j0j7&sourceid=chrome&ie=UTF-8
- https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html

### Provisioning van een AWS server

**Deze provisioning werkt niet volledig, De manier van een instance launchen is wel correct maar de role kan niet worden toegevoegd worden aan de server. We vermoeden dat dit een probleem is met hoe Vagrant de hosts aanmaakt en provisioned. Om deze reden hebben we besloten om in een verder hoofdstuk over te schakelen naar een linux omgeving en zo me Ansible te werken. Zie "Opzetten AWS cloud server met Ansible"**

Nu we met relatief succes de servers kunnen aanmaken met Vagrant/Ansible moeten we bekijken hoe we deze kunnen provisionen.

Na wat opzoekingswerk en wat trial and error ben ik op de volgende site.yml gekomen:

```
# site.yml
---
- hosts: localhost
  tasks:
    - name: install boto
      pip: 
        name: 
          - boto3
          - boto
        state: latest
    - name: Provision a set of instances
      ec2:
        aws_access_key: AKIAIX5X6W3EGGI4OVCQ
        aws_secret_key: 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
        key_name: test123
        # group: test
        instance_type: t2.micro
        image: ami-0fc841be1f929d7d1
        wait: true
        exact_count: 1
        count_tag:
          Name: bravo
        instance_tags:
          Name: bravo
        region: eu-west-2
        
      register: CORONA2020
    - name: De instance public IP to host group
      add_host: 
        hostname: "{{ item.public_ip }}" 
        groups: 
          - dns
          - all_aws_servers
      with_items: CORONA2020.instances

- hosts: all_aws_servers
  become: true
  remote_user: root
  roles:
    - bertvv.rh-base
- hosts: dns
  become: true
  remote_user: root
  roles:
    - bertvv.bind
```

Hier is het uiteindelijk de bedoeling dat instances worden toegevoegd aan 2 groups. De group doe zorgt voor een basis configuratie en dan de groep die hier van de AWS server een DNS server maakt.

In group_vars/dns.yml staat volgende code:

```
bind_allow_query:
  - 192.168.10.0/24
bind_listen_ipv4:
  - any
bind_zones:
  - name: CORONA2020.local
    primaries:
      - 192.168.10.195
    name_servers:
      - bravo.CORONA2020.local. #bravo. is hier genoeg
    mail_servers:
      - name: delta
        preference: 10
    hosts:
      - name: bravo
        ip: 192.168.10.195
        aliases:
          - ns
      - name: alfa
        ip: 192.168.10.194
        aliases:
          - dc
      - name: charlie
        ip: 192.168.10.196
        aliases:
          - www
      - name: delta
        ip: 192.168.10.197
        aliases:
          - mail
      - name: echo
        ip: 192.168.10.198
        aliases:
          - sccm
    networks:
      - '192.168.10'
bind_forwarders:
  - '8.8.8.8'
  - '8.8.4.4'
bind_recursion: true

rhbase_firewall_allow_services:
  - dns

ansible_ssh_private_key_file: "/opt/test123.pem"
```

en in group_vars/all_aws_servers.yml staat:

```
# group_vars/all.yml
# Variables visible to all nodes
---

rhbase_install_packages:
  - bash-completion
  - bind-utils
  - git
  - nano
  - tree
  - vim-enhanced
  - wget
ansible_ssh_private_key_file: "/opt/test123.pem"
```

**Opmerking:** tijdens het testen kreeg ik dit maal de foutmelding dat pip packages moesten geïnstalleerd worden, het kan dus zijn dat aan localhost een extra task moet toegevoegd worden.

```
- name: Install pip
      yum:
        name: python-pip
        update_cache: yes
        state: present
```

Uiteindelijk moet de key voor in de AWS servers te kunnen ssh'en ook op de localhost terecht kunnen komen. Hiervoor moeten we een nieuwe folder in ansible maken en daarin onze .pem key in plaatsen (ansible/key_name/test123.pem) en in de vagrant-hosts.yml volgende code hebben:

```
- name: localhost
  synced_folders:
    - src: ansible/key_name
      dest: /opt/test123.pem
```

Tijdens het uitvoeren van deze playbook krijg ik echter een probleem met ssh waardoor de VM direct afsluit en verwijders. Soms is dit probleem op te lossen door vagrant destroy en vagrant up te doen en denk dat dit gewoon een probleem is met Vagrant en niet het playbook.

Wanneer ssh correct werkt krijg ik echter te zien dat het provisionen van beide groups geskipped word, maar de rest  van de code word correct uitgevoerd.

gebruikte links:

- https://stackoverflow.com/questions/28211030/vagrant-up-and-reload-default-warning-connection-timeout-retrying
- https://stackoverflow.com/questions/51997637/ansible-pip-not-found
- https://medium.com/datadriveninvestor/devops-using-ansible-to-provision-aws-ec2-instances-3d70a1cb155f
- https://github.com/ansible/ansible/issues/13871
- https://github.com/ansible/ansible/issues/14517

## cli

 [Aws-CLI](https://aws.amazon.com/cli/)
 Hier kan je de cli voor aws downloaden zodat je commando's kan runnen die je nodig hebt voor bepaalde tokens.


## config van de CLI

  1. open een prompt
  2. run aws configure
  3. geef daar de gewenste config in

## get tokens om in de automatisatie te gebruiken

  run het commando:
  ```
    aws sts get-session-token
  ```

  dit geeft acces key ,secret acces key en de session token die we nodig hebben in de files voor vagrant

## de aws-plugin op vagrant installeren

  Om aws instanties aan te maken kan je dit doen via vagrant maar dien je eerst een plugin te installeren. Doe dit met het volgende commando:
  ```
    vagrant plugin install vagrant-AWS
  ```

  Normaal gezien zou dit een gekende foutmelding moeten geven. Blijkbaar is er in de windows 10 update een wijziging gebracht aan het document 'libxml2' waardoor deze niet meer gevonden word door de installer. Hierdoor kan die library niet geïnstalleerd worden en krijg je de foutmelding.

  ! [Foutmelding aws-plugin](/doc/AWS/img/Foutmelding_plugin.JPG)

  Om dit probleem op te lossen kan je de 'libxml2.dll' file online downloaden, deze kan je op de volgende link vinden:

  [libxml2.dll-file](https://www.dll-files.com/libxml2.dll.html#:~:text=Reinstalling%20the%20program%20may%20fix,the%20software%20vender%20for%20support.)

## Opzetten AWS cloud server met Ansible

In deze handleiding gaan we een AWS ec2 instance maken, ze de role [bertvv.rh-base](https://github.com/bertvv/ansible-role-rh-base) toekennen en er nano op installeren.

### Opzetten Linux omgeving

Wanneer u beschikt over een pc waar reeds Linux als OS op staat kan u deze stap overslaan.

### Installeren Git, Ansible, Visual Studio Code

Afhankelijk van de Linux distribution moet dit op een iets andere manier:

-  Voor Arch Linux:

```
$ sudo pacman -S git
$ sudo pacman -S ansible
$ sudo pacman -S code
```

- Voor Ubuntu Linux:

```
$ sudo apt-get install git
$ sudo apt install ansible
$ sudo apt install code
```

- Voor Redhat Linux:

```
$ sudo yum install git
$ sudo yum install ansible
$ sudo yum install code
```

### Voorbereidingen in AWS Console

- acces key/secret key
- key pair
- security group inbound rules

### Aanmaken Ansible repository

Maak (op een plaats die je terug vind) een directory (naam maakt niet uit). Pas de permissions ervoor aan. Verander je current directory naar deze map en open deze map met visual studio code:

```
$ sudo mkdir dir_naam
$ sudo chmod 777 dir_naam
$ cd dir_naam
$ code .
```

Hier maak je dan het inventory.txt bestand (uitleg hierover volgt later), het playbook bestand (een .yml bestand), plaats je het Key Pair .pem bestand die je gedownload hebt van AWS en maak je een 2 folders genaamd group_vars en roles.

**Note: het zou kunnen dat het aanmaken van de files en folders niet lukt, dit is omdat de permissions van de folder dan nog moeten aangepast worden.**

**Note: De permissions van het .pem bestand moeten op 600 gezet worden.**

```
$ sudo chmod 600 awdtest.pem
```

De repository zou er voorlopig als volgt moeten uitzien.

```
.
├── awdtest.pem
├── group_vars
├── inventory.txt
├── roles
└── site.yml	
```

### Uitschrijven playbook

Eerst moeten we de code in site.yml plaatsen die verantwoordelijk is voor het aanmaken van een ec2 instance (dit is een server in de AWS cloud omgeving).

```
# site.yml
---
- hosts: localhost
  tasks:
    - name: install boto
      pip: 
        name: 
          - boto3
          - boto
        state: latest
    - name: create ec2 instance
      ec2:
        aws_access_key: **eigen access_key**
        aws_secret_key: **eigen secret_key**
        key_name: awdtest
        instance_type: t2.micro
        image: ami-0fc841be1f929d7d1
        wait: true
        exact_count: 1
        count_tag:
          Name: test
        instance_tags:
          Name: test
        region: eu-west-2
      register: CORONA2020
```

We maken dus een host met als eerste taak het installeren van boto en boto3, dit is een requirement en is nodig om de verdere code te kunnen uitvoeren op localhost. Daarna word ec2 uitgevoerd. aws_acces_key en aws_secret_key kunnen gevonden/aangemaakt worden in de AWS Console (zie uitleg hierboven).  key_name is de naam van de key de reeds in het bestand staat. Instance_type is het type server, dus welke resources het word toegekend, wij kiezen hier nu altijd voort2.micro aangezien deze meer dan voldoende is en deel uitmaakt van de gratis te gebruiken instances. De image is een ID die bij de software voor de server hoort, let op, elke regio heeft voor dezelfde image een andere ID. Door wait op true te zetten zorgen we ervoor dat de instance volledig up and running is vooraleer we verder gaan. Exact_count bepaald het aantal instances er aangemaakt worden. Beide name tags is ter verduidelijking. Region is de plaats waar je wilt dat de instance terecht komt. Register is de variabele waar alle data van de instance inkomt.

Na het maken van de instance moeten we deze toevoegen aan een group, zodanig dat we deze een role kunnen toekennen en provisionen.

```
# site.yml
---
- hosts: localhost
  tasks:
  
    - name: install boto
    	#as above 
    - name: create ec2 instance
    	#as above 
    	
    - name: De test instance toevoegen aan de demo groep
      add_host: 
        hostname="{{ item.public_ip }}" groups=demo
      loop: "{{CORONA2020.instances}}
```

Er word hier gelooped over alle instances maar dit staat er enkel ter volledigheid in, aangezien wij hier maar 1 instance gemaakt hebben.

We voegen nog een taak toe om zeker te zijn dat de ec2 instance volledig opgestart en bereikbaar is.

```
# site.yml
---
- hosts: localhost
  tasks:
  
    - name: install boto
    	#as above 
    - name: create ec2 instance
    	#as above 
    - name: De test instance toevoegen aan de demo groep
    	#as above
    	
    - name: Wait for ssh
      delegate_to: "{{ item.public_ip }}"
      remote_user: ec2-user
      wait_for_connection:
        delay: 30
        timeout: 120
      loop: "{{CORONA2020.instances}}"
```

Tot slote moeten we de role toevoegen aan de groep

```
# site.yml
---
- hosts: localhost
  tasks:
  
    - name: install boto
    	#as above 
    - name: create ec2 instance
    	#as above 
    - name: De test instance toevoegen aan de demo groep
    	#as above 	
    - name: Wait for ssh
    	#as above
    	
- hosts: demo
  name: Add bind role
  gather_facts: yes
  become: true
  remote_user: ec2-user
  roles:
  	- bertvv.rh-base    
```

Gather_facts staat op yes zodanig dat de role correct kan worden toegevoegd aan de group en instance. Become staat op true aangezien we root capaciteiten moeten hebben om de rh-base role correct te kunnen uitvoeren. Remote_user is hier ec2-user omdat dit de standaard user is om met ssh te kunnen inloggen op een server, anders werkt de gather_facts niet.

**Note: hosts naam is hetzelfde als de naam van de groep waar de instance word aan toegevoegd**

### Provisioning group_vars

Eerst moet je aan de folder group_vars een demo.yml bestand toevoegen (dit .yml bestand moet dezelfde naam hebben als de hosts in het playbook hierboven). Nu ziet de repository er als volgt uit:

```
.
├── awdtest.pem
├── group_vars
│   └── demo.yml
├── inventory.txt
├── roles
└── site.yml

```

voeg volgende code toe aan demo.yml om nano te installeren op de server (meer details, functies en syntaxen kunnen gevonden worden op de [github van de role](https://github.com/bertvv/ansible-role-rh-base))

```
# group_vars/demo.yml
---

rhbase_install_packages:
  - nano
```

### Ansible inventory uitschrijven

In inventory.txt moet volgende code worden toegevoegd:

```
localhost ansible_connection=local
[demo]
[demo:vars]
ansible_ssh_private_key_file=awdtest.pem
```

Deze code zorgt ervoor dat Ansible de host locaal gaat aanmaken. Daarna de code in de group_vars > demo zal uitvoeren. de key word daar nog eens meegeven zodanig dat alles goed en correct werkt en in alle instancens kan ingelogd worden.

### Role instellingen

Download de role van github > pak deze uit > hernoem ze naar bertvv.rh-base > zet ze in de map onder roles. De repository zou er als volgt moeten uitzien

```
.
├── awdtest.pem
├── group_vars
│   └── demo.yml
├── inventory.txt
├── roles
│   └── bertvv.rh-base
│       ├── CHANGELOG.md
│       ├── defaults
│       │   └── main.yml
│       ├── files
│       │   └── dynamic-motd.sh
│       ├── handlers
│       │   └── main.yml
│       ├── LICENSE.md
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       ├── tasks
│       │   ├── admin.yml
│       │   ├── auto-updates.yml
│       │   ├── config.yml
│       │   ├── install.yml
│       │   ├── main.yml
│       │   ├── security.yml
│       │   ├── services.yml
│       │   └── users.yml
│       ├── templates
│       │   ├── etc_dnf_automatic.conf.j2
│       │   ├── etc_dnf.conf.j2
│       │   ├── etc_profile.d_localtime.j2
│       │   ├── etc_yum.conf.j2
│       │   ├── etc_yum_yum-cron.conf.j2
│       │   └── etc_yum_yum-cron-hourly.conf.j2
│       └── vars
│           ├── Fedora.yml
│           ├── RedHat-8.yml
│           └── RedHat.yml
└── site.yml
```

**Note: bij deze role moet in tasks > security 4 keer "ansible.posix." verwijderd worden, anders krijg je een fout bij het runnen van deze role**

### Ansible inventory en playbook runnen

Om nu de playbook te laten runnen moet je zeker zijn dat je in de map staat waar de inventory en playbook instaan en typ je het volgende commando:

```
$ ansible-playbook -i inventory.txt site.yml
```

verwachte PLAY RECAP:

```
PLAY RECAP *******************************************************************************************************************************************
3.9.115.232                : ok=34   changed=16   unreachable=0    failed=0    skipped=18   rescued=0    ignored=0   
localhost                  : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

**Note: Het ip adres hier en die u heeft zal verschillen.**

Nu kan je in de server ssh'en en controlleren of nano wel echt correct geïnstalleerd is

```
$ ssh -i "awdtest.pem" ec2-user@ec2-3-9-115-232.eu-west-2.compute.amazonaws.com
[ec2-user@ip-172-31-25-179 ~]$ nano --version
```

**Note: Het ip adres hier en die u heeft zal verschillen.**

Verwachtte output

```
 GNU nano, version 2.9.8
 (C) 1999-2011, 2013-2018 Free Software Foundation, Inc.
 (C) 2014-2018 the contributors to nano
 Email: nano@nano-editor.org	Web: https://nano-editor.org/
 Compiled options: --enable-utf8
```

Wanneer u dit resultaat te zien krijgt heeft u succesvol een een instance op AWS cloud omgeving aangemaakt, deze een role toegekend en deze geprovisioned en dit allemaal automatisch.

### Sources

- https://linuxconfig.org/how-to-install-a-package-from-aur-on-manjaro-linux

- https://www.atlassian.com/git/tutorials/install-git

- https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_module.html
- https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html

## Aanmaken VPC in AWS met Ansible

VPC of Virtual Private Cloud zal ons toelaten meer controle te hebben over ons netwerk. Hier kunnen we de IP-adressen zelf kiezen, hebben we controle over de subnets, de routeringstabel en veel meer. Ook laat de VPC ons toe om ermee te verbinden via een VPN (alhoewel dit een kost met zich meebrengt). Tevens laat het ons toe om wat meer/betere security toe te voegen moesten we dit wensen.

We kunnen dit op vele manieren realiseren, hier kiezen we ervoor om met een module te werken. 

**Note: opnieuw werken we vanuit een Linux omgeving waar Ansible reeds op geïnstalleerd is.**

### Module installeren

In uw geprefereerde CLI omgeving moet je het volgende commando runnen:

```
$ ansible-galaxy collection install amazon.aws
```

Dit is het enige wat je moet doen om een module te installeren.

### Aanmaken Ansible repository

Maak een nieuwe directory (die je terug kan vinden) op je Linux systeem. Pas de permissions aan, verander je current directory en open Visual Studio Code

```
$ sudo mkdir dir_naam
$ sudo chmod 777 dir_naam
$ cd dir_naam
$ code .
```

Maak hier 3 nieuwe files: inventory.txt, je keypair van AWS (hier awdtest.pem) en dan je playbook site.yml. De repository zou er als volgt moeten uitzien

```
.
├── awdtest.pem
├── inventory.txt
└── site.yml
```

Opnieuw zal hier de permissions van het key pair aangepast moeten worden om een correct uitvoeren te garandere.

```
$ sudo chmod 600 awdtest.pem
```

### VPC maken - Playbook aanvullen

Om de module te gebruiken die we reeds geinstalleerd hebben gaan we gebruik maken van 

```
amazon.aws.ec2_vpc_net
```

in het playbook.

```
# site.yml
---

- hosts: localhost
  tasks:
    - name: install boto
      pip: 
        name: 
          - boto3
          - boto
        state: latest
# eerst onderstaande code in cli uitvoeren
# $ ansible-galaxy collection install amazon.aws
    - name: create a VPC
      amazon.aws.ec2_vpc_net:
        aws_access_key: **your access_key**
        aws_secret_key: **your secret_key**
        name: CORONA2020
        cidr_block: 192.168.10.0/24
        region: eu-west-2
```

In dit playbook maken we een localhost aan die eerst boto en boto3 zal installeren. Dit is een requirement om de rest correct te laten uitvoeren. Dan zal deze playbook een VPC maken op het account van de meegegeven user met de naam CORONA2020, cidr block 192.168.10.0/24 in region eu-west-2 (wat overeen komt met Londen). Uiteindelijk is er beslist geweest op de vpc niet via de playbook aan te maken(dit wegens een grote complexiteit), maar deze gewoonweg op voorhand online aan te maken. Om dit online te doen voer de volgende stappen uit:

  1. Ga naar aws.amazon.com en log je in de console in.
  2. Bij services linksboven zoek je naar de service VPC.
  3. 

### Ansible inventory aanmaken/aanvullen

In het inventory.txt bestand moet maar 1 lijn code komen.

```
localhost ansible_connection=local
```

### Ansible inventory en playbook runnen

Om nu de playbook te laten runnen moet je zeker zijn dat je in de map staat waar de inventory en playbook instaan en typ je het volgende commando:

```
$ ansible-playbook -i inventory.txt site.yml
```

verwachte PLAY RECAP:

```
PLAY RECAP *****************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

U kan ook altijd in de AWS console controleren of u de CORONA2020 VPC terug vindt en als dit het geval is dan klopt alles.

### Sources

- https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_vpc_net_module.html
- https://aws.amazon.com/vpc/faqs/
- https://aws.amazon.com/vpc/
- https://docs.ansible.com/ansible/latest/dev_guide/developing_locally.html
- https://docs.ansible.com/ansible/latest/user_guide/modules.html
- https://docs.ansible.com/ansible/2.3/ec2_vpc_module.html