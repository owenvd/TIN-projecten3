# TEST PLAN: CLOUD SERVERS - AWS

| **auteur testplan** | Owen Van Damme |
| ------------------- | -------------- |
| **uitvoerder test** | Jochen Dewachter|

## Requirements

- Na het uitvoeren van  het commando "ansible-playbook -i inventory.txt site.yml" zouden er 3 servers op de AWS cloud moeten aangemaakt worden met namen bravo, charlie en delta met privé IP adressen 192.168.10.195, 192.168.10.196 en 192.168.10.197 respectievelijk.
- Bravo zal als een DNS server geconfigureerd worden met de juiste records.
- Charlie zal als een webserver geconfigureerd worden.
- Delta zal als een mailserver geconfigureerd worden.

## Opmerkingen

- We doen dit allemaal van een Linux systeem en werken rechtstreeks met Ansible, de tester moet dit ook doen.
- De uitvoerder van de test moet een AWS account hebben.
- Hoe alles nu zal ingesteld staan zullen alle servers aangemaakt worden in Londen.
- Alle preperation steps moeten goed gedaan worden, anders kan dit leiden tot errors en failures.

## Stap 1: Preperation

### Alle keys

**Opmerking: Al deze keys kan u slechts 1 malig downloaden, wanneer u deze niet op uw pc opslaat zal u deze stappen moeten herhalen.**

- Wanneer u bent ingelogd op de AWS console klik op uw naam rechtsbovenaan de pagina en dan op My Security Credentials

  ![screenshot 1](/doc/AWS/img/Screenshot_1.png)

- Klik op Create New Access Key, download deze file en sla ze ergens veilig op

  ![screenshot 2](/doc/AWS/img/Screenshot_2.png)

- klik nu op Services en zoek naar EC2

  ![screenshot 3](/doc/AWS/img/Screenshot_3.png)

- Navigeer in de linker balk naar Key Pairs

  ![screenshot 4](/doc/AWS/img/Screenshot_4.png)

- Create key pair

  ![screenshot 5](/doc/AWS/img/Screenshot_5.png)

- Geef een gepaste naam en duid pem aan

  ![screenshot 6](/doc/AWS/img/Screenshot_6.png)

- Nu heeft u alle nodige keys voor het aanmaken van de servers in AWS

### VPC, Subnet, IGW, Security Groups

- Klik op Services, zoek vpc en klik op VPC

  ![screenshot 7](/doc/AWS/img/Screenshot_7.png)

- Navigeer op de linke balk naar Your VPCs en klik op Create VPC

  ![screenshot 8](/doc/AWS/img/Screenshot_8.png)

- Geef de VPC een naam en het netwerk waarin u wilt dat de prive IP adressen zitten en klik op create VPC

  ![screenshot 9](/doc/AWS/img/Screenshot_9.png)

- navigeer op de linker balk naar Subnets en klik Create subnet

  ![screenshot 10](/doc/AWS/img/Screenshot_10.png)

- Selecteer de VPC die u juist heeft aangemaakt, geef het subnet een naam een IPv4 CIDR block en klik op Create subnet

  ![screenshot 11](/doc/AWS/img/Screenshot_11.png)

- Navigeer op de linker balk naar Internet Gateways en klik op Create internet gateway

  ![screenshot 12](/doc/AWS/img/Screenshot_12.png)

- Geef een gepaste naam en klik op Create internet gateway

  ![screenshot 13](/doc/AWS/img/Screenshot_13.png)

- Klik op Actions > Attach to VPC of u kan ook gewoon op Atach to a VPC klikken bovenaan de pagina

  ![screenshot 14](/doc/AWS/img/Screenshot_14.png)

- Selecteer de VPC die we eerder gemaakt hebben en klik op Attach internet gateway

  ![screenshot 15](/doc/AWS/img/Screenshot_15.png)

- Navigeer op de linker balk naar Network ACLs > selecteer de acl van uw VPC (staat onder VPC) > selecteer inbound rules > Edit inbound rules

  ![screenshot 16](/doc/AWS/img/Screenshot_16.png)

- Voeg 2 regels toe zoals in onderstaande afbeelding en klik op save

  ![screenshot 17](/doc/AWS/img/Screenshot_17.png)

- Navigeer op de linker balk naar Security Groups en klik op Create new security group

  ![screenshot 18](/doc/AWS/img/Screenshot_18.png)

- Geef een gepaste naam en omschrijving, selecteer de VPC van die we eerder hebben aangemaakt

  ![screenshot 19](/doc/AWS/img/Screenshot_19.png)

- Voeg 2 inbound regels toe zoals onderstaande afbeelding en klik op create security group

  ![screenshot 20](/doc/AWS/img/Screenshot_20.png)
  
- Navigeer nu naar Route Tables in de linker kolom en klik op de Route Table ID die bij de VPC hoort die u heeft aangemaakt, klik dan op Routes en Edit routes

  ![screenshot 21](/doc/AWS/img/Screenshot_21.png)

- Klik op Add route > zet de Destination gelijk aan 0.0.0.0/0 en Target is de Internet Gateway die u hiervoor gemaakt hebt > Save routes en op het volgende scherm klik gewoon close

  ![screenshot 22](/doc/AWS/img/Screenshot_22.png)

## Stap 2: uitvoeren van de playbook

### Variabelen juist zetten

- Vooraleer u de playbook mag runnen moet u ervoor zorgen dat de juiste keys, group en subnet worden gebruikt. Dit kan door deze bovenaan het site.yml-document aan te passen zoals op de foto. Hierbij zijn de access en secret key de keys dat u hebt aangemaakt als eerste stap en is key_name de naam van de key_pair dat u hebt aangemaakt. De group is de naam van de securitygroup en subnet_id is het subnet_id waarin deze group zich bevind.

  ![Variabelen instellen](/doc/AWS/img/Variabelen.jpg)

- Naast het juistzetten van de variabelen in het site.yml-document moeten er ook nog aanpassingen gedaan worden in het inventory.txt-document. Hierin moet de waarde bij "ansible_ssh_private_key_file" aangepast worden naar uw .pem-bestand. Sla dan ook het .pem-bestand op in de map waarin de inventory.txt-file staat. Dit kunt u zien op onderstaande foto's.

  ![inventory.txt aanpassen](/doc/AWS/img/inv.jpg)
  ![pemfile](/doc/AWS/img/pem.jpg)

- Het laatste dat moet gebeuren om de playbook te kunnen doen runnen is het wijzigen van de permissies van het .pem-bestand. Zoals deze zijn zijn ze te laag voor AWS en omdat ze niet beveiligd genoeg zijn zal het SSH'en naar de servers mislukken. Daarom voert u de volgende commando's uit in een terminal.

  ```
  $ cd 'plaats waar het .pem-bestand staant'
      bvb. cd p3ops-2021-g01-master/src/aws-ansible
  
  $ chmod 600 'naam'.pem
  ```

### het runnen van de playbook

- Nu alles juist staat kunt u de playbook laten runnen. Om dit te doen voer volgende commando's uit in de terminal:

  ```
  $ cd 'plaats waar de inventory en site.yml staat'
      bvb. cd p3ops-2021-g01-master/src/aws-ansible  
  
  $ ansible-playbook -i inventorty.txt site.yml
  ```

- Tijdens het runnen van de playbook zal er 3 maal gewacht worden voor een ssh-verbinding met e servers vooraleer het programma verder gaat. Als de ssh-verbinding lukt zal u het woord 'yes' moeten ingeven als u de melding krijgt zoals op onderstaande foto.

  ![ssh-verbinding](/doc/AWS/img/ssh.jpg)

- Het verwachtte resultaat is dat bij de play-recap voor de 3 servers er 0 failed tasks zijn en bij de localhost maximum 1. Dit komt doordat de gathering van de facts niet altijd werkt.

  ![Play-recap](/doc/AWS/img/playrecap.jpg)

## Stap 3: controle

### De console

- Om te controleren of alles gelukt is in de vorige stappen kunt u in de AWS-console kijken bij EC2-instances en daar zijn de 3 servers in de running state: bravo, charlie en delta. Het belangrijke hierbij is dat de 'instance-state' running is en dat de 'status check' bij alle 3 2/2 checks is. Dit kunt u zien op onderstaande foto.

  ![AWS-console](/doc/AWS/img/console.jpg)

- Als u dan op de 'instance-id' van alle 3 de servers klikt om meer gegevens te zien dan kunt u zien dat het private ipv4-adres gewijzigd is naar 192.168.10.195 voor bravo, 192.168.10.196 voor charlie en 192.168.10.197 voor delta. Ook zullen bij alle drie de servers het VPC-ID en Subnet-ID gewijzigd zijn naar de opgegeven waardes. Dit kunt u zien op onderstaande foto.

  ![serverwijzigingen](/doc/AWS/img/wijzigingen.jpg)

### De servers

- Nu u zeker bent dat de servers runnen, kunt u ook kijken of deze correct geprovisioned zijn. Om dit te doen klikt u in de AWS-console op een server en klikt u rechtsboven op connect. Dit opent een nieuw scherm met 3 opties: EC2 instance connect, session manager en ssh client. Kies voor het laatste: de ssh client. Daar ziet u onderaan het commando om te ssh'en naar de server. Kopier dit en voer dit uit in de terminal waar u de playbook heeft gerunt.

- Nu u met de server geconnecteerd bent kunt u het testplan van de 3 servers uitvoeren op deze servers. De testplannen kunt u hier vinden:

  [Testplan_Bravo](/doc/bravo/testplan-bravo.md)
  [Testplan_Charlie](/doc/charlie/Testplan.md)
  [Testplan_Delta](/doc/delta/Testplan.md)

