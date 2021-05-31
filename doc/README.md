# Overzicht documentatie

## IP adrestabel

| Naam  | IPv4|IPv6
|--|--|--|
|Alfa|192.168.10.194|::ffff:c0a8:ac2
|Bravo|192.168.10.195|::ffff:c0a8:ac3
|Charlie|192.168.10.196|::ffff:c0a8:ac4
|Delta|192.168.10.197|::ffff:c0a8:ac5
|Echo|192.168.10.198|::ffff:c0a8:ac6

## Inhoud documentatie

### Algemene documentatie over de verschillende servers

| Onderwerp                             |  Locatie                     | Maker                 |
|---------------------------------------|------------------------------|-----------------------|
| Domeincontroller                      | [Domeincontroller](/doc/alfa)| Van de Cappelle Jari  |
| Domain name system                    | [DNS](/doc/bravo)            | Van Damme Owen        |
| Webserver                             | [Web](/doc/charlie)          | Robyn Moreno          |
| Emailserver                           | [mail](/doc/delta)           | Dewachter Jochen      |
| System Center Configuration Manager   | [SCCM](/doc/echo)            | Vermeulen Kelvin      |
| GNS3                                  | [GNS3](/doc/GNS3)            | Jari, Kelvin en Moreno|  
| Netwerk                               | [Netwerk](/doc/netwerk)      | Jari en Moreno        |
| Amazon web services                   | [AWS](/doc/AWS)              | Jochen en Owen        |
| Labo                                  | [Labo](/doc/cisco)           | Iedereen              |
| Vagrant                               | [Vagrant](/doc/vagrant)      | /                     |
| Varia                                 | [Varia](/doc/varia)          | /                     |

### Testplannen en rapporten

| Server    | Soort     | Testplan                          | Testrapport                               | Tester                |
| Alfa      | DC        | [DC](/doc/alfa/TestPlan.md)       | [DC](/doc/alfa/TestRapport2-met-DNS.md)   | Kelvin                |
| Bravo     | DNS       | [DNS](/doc/bravo/TestPlan.md)     | [DNS](/doc/bravo/TestRapport.md)          | Jochen                |
| Charlie   | Web       | [WEB](/doc/charlie/TestPlan.md)   | [WEB](/doc/charlie/TestRapport4.md)       | Owen                  |
| Delta     | Mail      | [MAIL](/doc/delta/TestPlan.md)    | [MAIL](/doc/delta/TestRapport.md)         | Moreno                |
| Echo      | SCCM      | [SCCM](/doc/echo/TestPlan.md)     | [SCCM](/doc/echo/TestRapport.md)          | Jari                  |
| GNS3      | Netwerk   | [GSN3](/doc/GNS3/TestPlan.md)     | [GNS3](/doc/GNS3/TestRapport.md)          | Jari, Kelvin en Moreno|
| AWS       | Cloud     | [AWS](/doc/AWS/TestPlan.md)       | [AWS](/doc/AWS/TestRapport.md)            | Jochen en Owen        |

### Requirements

#### Domeincontroller - ALFA

    - OS: Windows Server 2019
    - Geen DNS
    - authenticatie van gebruikers via DC in 5 afdelingen:
        - IT administratie
        - Verkoop
        - Administratie
        - Ontwikkeling
        - Directie
    - Duidelijk onderscheid tussen gebruiker, computer en groep
    - Voeg gebruikers en 5 werkstations(1 in elke afdeling)
    - Beleidsregels:
        - Control panel enkel voor IT
        - Geen games
        - Netwerkadapters kunnen niet door verkoop en administratie aangepast worden
        - Gebruikers krijgen  DFS filesystem

#### DNS-server - BRAVO

    - OS: CentOS8
    - authoratieve DNS
    - domein: corona2020.local
    - queries worden geforward naar juiste dns
    - elke host in domein heeft A, AAAA, en PRT records in juiste zonebestanden
    - hostnamen zijn generiek en heben Cname-records
    - eventueel andere records

#### Webserver - CHARLIE

    - OS: CentOS8
    - nginx als webserver met HTTPS en HTTP/2
    - postgreSQL als database toevoegen
    - installeer een content management system
    - kan op elk station surven naar de site: https://www.corona2002.local/enhttps://corona2002.local/

#### Mailserver - DELTA

    - OS: CentOS8
    - Postfix als MTA
    - Dovecot als MDA
    - Elke gebruiker eigen mailbox
    - Spamfilter en antivirus toevoegen

#### System Center Configuration Manager - ECHO

    - OS: Windows Server 2019
    - combineer sccm met MDT voor snelle image-uitrolling
    - MDT werkt via PXE boot
    - via PXE clean server install mogelijk
    - gebruikersauthenticatie via dc

### Lastenboek

    Voor de onderverdeling van alle deeltaken en hoeveel tijd we dachten hiervoor nodig was en we werkelijk nodig hadden zie trello.

    [Trellobord](https://trello.com/b/IzDaIA42/p3sb2021g01)