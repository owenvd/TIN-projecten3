# Configuratie DNS Server - BRAVO

Hierin staat beschreven hoe de DNS server geconfigureerd is, welke stappen ondernomen zijn om tot deze configuratie te komen en verdere uitleg.

Als u de server wilt volledig hetzelfde als in onze repository en wilt geen verdere uitleg moet u enkel deze repository clonen, in een CLI navigeren naar de Ansible-skeleton directory en vagrant up bravo typen.

```
$ git clone https://github.com/HoGentTIN/p3ops-2021-g01.git
$ cd 'naar de Ansible-skeleton directory'
$ vagrant up bravo
```

## Wat is een Authoritative DNS nameserver?

Alles wat is aangesloten aan het internet krijgt een IP adres. Dit is nodig zodat er met al deze toestellen gecommuniceerd kan worden. Het probleem daarmee echter is dat mensen niet goed gewoon cijfers kunnen onthouden en om alles gebruiksvriendelijker te maken zou een naam alles veel gemakkelijker maken. Dit is de functie van de DNS servers. 

Veel mensen beschrijven deze servers als een telefoonboek: mensen zoeken een naam op in een telefoonboek, kijken naar het overeenkomende telefoon nummer, tikken dit nummer in op hun telefoon en de persoon die ze wouden bereiken  neemt de telefoon aan de andere kant van de lijn op. De DNS-servers zijn in essentie hetzelfde: een mens typt de naam van een server (of enig andere toestel aangesloten op het netwerk) in en de server zal dit dan vertalen naar het overeenkomende IP adres zodanig dat alle communicatie tussen beide zonder fouten kan gebeuren.

## Requirements

Aangezien we deze server automatisch willen laten opstarten en provisionen (en we op een windows machine werken) maken we gebruik van de [anisble-skeleton](https://github.com/bertvv/ansible-skeleton) voorzien door [Bert Van Vreckem](https://github.com/bertvv) en moeten dus eerst nog wat voorbereiden werk doen.

1. De naam en het IP adres van de server moet toegevoegd worden aan de vagrant-hosts.yml file (Subnet moet niet gespecifieerd worden aangezien deze standaard op /24 gezet word in deze ansible-skeleton)

   ```
   - name: bravo
     ip: 192.168.10.195
   ```

2. Deze server moet dan worden toegevoegd als host in site.yml en voegen direct ook de juiste role toe

   ```
   - hosts: bravo
     become: true
     roles:
       - bertvv.bind
   ```

   We hebben besloten om op deze server gebruik te maken van BIND. Meer bepaald de [BIND role](https://github.com/bertvv/ansible-role-bind) uitgeschreven door [Bert Van Vreckem](https://github.com/bertvv). Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

3. Nu moeten enkel nog maar een 'roles' en een 'host_vars' directory gemaakt worden in de ansible directory. In host_vars maken we nog een file genaamd bravo.yml en in die file gebeurt alle configuratie. In de roles directory word de gedownloade role geplaatst.

   ```
   .
   ├───files
   ├───group_vars
   ├───host_vars
   ├───roles
   │   ├───bertvv.bind
   ```

   De naam van de role in de site.yml moet hetzelfde zijn als de naam van de role in de roles directory. Let er ook goed op dat de role niet in nog een direcotry staat (dus geen map in een map) anders vind dit ansible-skeleton de role niet.

4. In site.yml voegen we nog een host toe genaamd all, en voegen de role [rh-base role](https://github.com/bertvv/ansible-role-rh-base) toe in de roles directory

   ```
   - hosts: all
     become: true
     roles:
       - bertvv.rh-base
   ```

   We doen dit omdat we enkele dingen op alle servers in ons netwerk willen installeren. Deze manier is dan efficiënter om op elke server standaard de rh-base role te zetten.

### Gebruikte Variabelen

| Variable | Beschrijving                                          |
| :------- | ----------------------------------------------------- |
| name     | de naam van de server die aangemaakt moet worden      |
| ip       | het ip adres van de server die moet aangemaakt worden |

| Variable | Beschrijving                                                 |
| -------- | :----------------------------------------------------------- |
| hosts    | naam van de server die geconfigureerd moet worden (wanneer deze all is zullen alle aangemaakte servers die bewerkingen krijgen) |
| become   | Wanneer deze op true staat wilt dit zeggen dat we als root user inloggen op de server tijdens de provisioning dus krijgen we alle priveliges |
| roles    | roles nodig om server te provisionen                         |

## Provisioning DNS - BRAVO

Eerst gaan we stap voor stap door het configuratie bestand en onderaan dit deel staat dan het volledige bravo.yml bestand

1. Met deze code zeggen we dat alle hosts een querry mogen sturen naar de DNS server en dat ze op welke IPv4 interfaces de server luistert.  Hier staat alles open om te vermijden dat er compatibiliteits problemen zijn met de andere aangemaakte servers.

   ```
   bind_allow_query:
     - any
   bind_listen_ipv4:
     - any
   ```

2. Nu de opdracht is om een authoritative nameserver te maken maar ook om de queries die niet in het netwerk liggen door te sturen. Deze code zorgt ervoor dat de server technisch gezien geen authoritative nameserver meer is maar deze code is nodig om de queries te forwarden. 

   ```
   bind_forwarders:
     - '8.8.8.8'
     - '8.8.4.4'
   bind_recursion: true
   ```

3. Deze configuratie komt uit de rh-base role. Hierdoor laat de firewall DNS door.

   ```
   rhbase_firewall_allow_services:
     - dns
   ```

4. Hierin gaan we de verschillende zones definiëren zoals onderandere: NS records, MX records, A records, AAAA Records,... (zie onderstaande tabel voor verdere uitleg over de variabelen)

   ```
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
           ipv6: ::ffff:c0a8:ac3
           aliases:
             - ns
         - name: alfa
           ip: 192.168.10.194
           ipv6: ::ffff:c0a8:ac2
           aliases:
             - dc
             - 4a49c7fc-c9e8-4e7f-8055-67b4fcd5e804._msdcs
         - name: charlie
           ip: 192.168.10.196
           ipv6: ::ffff:c0a8:ac4
           aliases:
             - www
             - rainloop
             - zabbix
         - name: delta
           ip: 192.168.10.197
           ipv6: ::ffff:c0a8:ac5
           aliases:
             - mail
         - name: echo
           ip: 192.168.10.198
           ipv6: ::ffff:c0a8:ac6
           aliases:
             - sccm
       networks:
         - '192.168.10'
       services:
         - name: _ldap._tcp.dc._msdcs
           weight: 100
           port: 389
           target: alfa
         - name: _ldap._tcp
           weight: 100
           port: 389
           target: alfa
         - name: _kerberos._tcp.dc._msdcs
           weight: 100
           port: 88
           target: alfa
         - name: _kerberos._tcp
           weight: 100
           port: 88
           target: alfa
         - name: _kerberos._udp
           weight: 100
           port: 88
           target: alfa
         - name: _kpasswd._tcp
           weight: 100
           port: 464
           target: alfa
         - name: _kpasswd._udp
           weight: 100
           port: 464
           target: alfa
         - name: _ldap._tcp.Default-First-Site-Name._sites
           weight: 100
           port: 389
           target: alfa
         - name: _kerberos._tcp.Default-First-Site-Name._sites.dc._msdcs
           weight: 100
           port: 88
           target: alfa
         - name: _ldap._tcp.Default-First-Site-Name._sites.dc._msdcs
           weight: 100
           port: 389
           target: alfa
         - name: _kerberos._tcp.Default-First-Site-Name._sites
           weight: 100
           port: 88
           target: alfa
         - name: _ldap._tcp.gc._msdcs
           weight: 100
           port: 3268
           target: alfa
         - name: _gc._tcp.Default-First-Site-Name._sites
           weight: 100
           port: 3268
           target: alfa
         - name: _ldap._tcp.Default-First-Site-Name._sites.gc._msdcs
           weight: 100
           port: 3268
           target: alfa
         - name: _ldap._tcp.pdc._msdcs
           weight: 100
           port: 389
           target: alfa
         - name: _ldap._tcp.6b4bba80-b763-474a-adef-bffb8efbbc8a.domains._msdcs
           weight: 100
           port: 389
           target: alfa       
   ```

   We maken hier dus een forward lookup zone (en automisch ook een reverse lookup zone, PTR record) voor een totaal van 5 servers waarvan 1 server de DNS server is en 1 server de mail server. Dit wil uiteindelijk zeggen dat we met nslookup of dig > de naam (of alias) van een server gevolgd door CORONA2020.local kunnen opzoeken en deze server zal ervoor zorgen dat het juiste IP adres (dus server) zal worden aangesproken (wanneer deze DNS server word aangesproken natuurlijk).

   Alles services zijn nodig om een correcte werking van de domain controller en SCCM server te garanderen. 

5.  De volledige configuratie ziet er dus als volgt uit:

   ```
   bind_allow_query:
     - any
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
           ipv6: ::ffff:c0a8:ac3
           aliases:
             - ns
         - name: alfa
           ip: 192.168.10.194
           ipv6: ::ffff:c0a8:ac2
           aliases:
             - dc
             - 4a49c7fc-c9e8-4e7f-8055-67b4fcd5e804._msdcs
         - name: charlie
           ip: 192.168.10.196
           ipv6: ::ffff:c0a8:ac4
           aliases:
             - www
             - rainloop
             - zabbix
         - name: delta
           ip: 192.168.10.197
           ipv6: ::ffff:c0a8:ac5
           aliases:
             - mail
         - name: echo
           ip: 192.168.10.198
           ipv6: ::ffff:c0a8:ac6
           aliases:
             - sccm
       networks:
         - '192.168.10'
       services:
         - name: _ldap._tcp.dc._msdcs
           weight: 100
           port: 389
           target: alfa
         - name: _ldap._tcp
           weight: 100
           port: 389
           target: alfa
         - name: _kerberos._tcp.dc._msdcs
           weight: 100
           port: 88
           target: alfa
         - name: _kerberos._tcp
           weight: 100
           port: 88
           target: alfa
         - name: _kerberos._udp
           weight: 100
           port: 88
           target: alfa
         - name: _kpasswd._tcp
           weight: 100
           port: 464
           target: alfa
         - name: _kpasswd._udp
           weight: 100
           port: 464
           target: alfa
         - name: _ldap._tcp.Default-First-Site-Name._sites
           weight: 100
           port: 389
           target: alfa
         - name: _kerberos._tcp.Default-First-Site-Name._sites.dc._msdcs
           weight: 100
           port: 88
           target: alfa
         - name: _ldap._tcp.Default-First-Site-Name._sites.dc._msdcs
           weight: 100
           port: 389
           target: alfa
         - name: _kerberos._tcp.Default-First-Site-Name._sites
           weight: 100
           port: 88
           target: alfa
         - name: _ldap._tcp.gc._msdcs
           weight: 100
           port: 3268
           target: alfa
         - name: _gc._tcp.Default-First-Site-Name._sites
           weight: 100
           port: 3268
           target: alfa
         - name: _ldap._tcp.Default-First-Site-Name._sites.gc._msdcs
           weight: 100
           port: 3268
           target: alfa
         - name: _ldap._tcp.pdc._msdcs
           weight: 100
           port: 389
           target: alfa
         - name: _ldap._tcp.6b4bba80-b763-474a-adef-bffb8efbbc8a.domains._msdcs
           weight: 100
           port: 389
           target: alfa
   bind_forwarders:
     - '8.8.8.8'
     - '8.8.4.4'
   bind_recursion: true
   
   rhbase_firewall_allow_services:
     - dns
   ```

### Gebruikte Variabelen

| Variabele                      | Uitleg                                                       |
| ------------------------------ | ------------------------------------------------------------ |
| bind_allow_query               | een lijst met hosts die de DNS mag queriën                   |
| bind_listen_ipv4               | de IPv4 interfaces waarop geluisterd word                    |
| bind_zones                     | de te definiëren zones                                       |
| bind_forwarders                | DNS servers waarnaar requests doorgestuurd kunnen worden     |
| bind_recursion                 | bepaalt of de DNS server IP adressen buiten het domein mag queriën |
| rhbase_firewall_allow_services | lijst met services die door de firewall mogen gaan           |

| bind_zones  |                                                              |
| ----------- | ------------------------------------------------------------ |
| name        | de naam van het domein                                       |
| primaries   | alle DNS servers voor deze zone                              |
| name_server | alle DNS servers in het domein, NS record                    |
| mail_server | alle mail servers in dit domein (name is de naam van de server, preference is de prioriteit van de mail server), MX record |
| hosts       | hosts definities                                             |
| networks    | alle netwerken die deel zijn van het domein                  |
| services    | services die ge-adverteerd moeten worden door een SRV record |

| hosts   |                                           |
| ------- | ----------------------------------------- |
| name    | naam van de server, is een name record    |
| ip      | IP adres van de server, A record          |
| ipv6    | IPv6 adres van de server, AAAA record     |
| aliases | andere naam voor een server, CNAME record |

| services |                            |
| -------- | -------------------------- |
| name     | naam van de service        |
| weight   | standaard = 0              |
| port     | port van de service        |
| target   | host die de service levert |

## Provisioning ALL

1. maakt in de group_vars directory een all.yml bestand

2. volgende code installeerd enkele packages op alle servers die handig kunnen zijn

   ```
   rhbase_install_packages:
     - bash-completion
     - bind-utils
     - git
     - nano
     - tree
     - vim-enhanced
     - wget
   ```

## Uitvoering Provisioning DNS - BRAVO

1. Nu moet u in uw gewenste CLI navigeren naar de Ansible-skeleton directory

2. Enkel onderstaand commando is nodig om de server aan te maken en te configureren$

   ```
   $ vagrant up bravo
   ```

   Nu zal er een DNS server gemaakt worden met 1 forward lookup zone met daarin 5 servers, 1 daarvan is de DNS server zelf. De reverse lookup zone zal ook aangemaakt worden. Ook zullen alle nodige records aanwezig zijn.

3. Voor te testen of aanpassingen te maken op de server kan volgend commando gerbuikt worden

   ```
   $ vagrant ssh bravo
   ```

## Andere documentatie

[research and testing voor DNS servers](/doc/bravo/DNS_research&tests.md)

[Testplan bravo](/doc/bravo/TestPlan.md)

[TestRapport bravo](/doc/bravo/TestRapport.md)