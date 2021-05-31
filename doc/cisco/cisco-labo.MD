# Cisco Labo Voorbereiding

opmerking: alle instructies die vet gedrukt zijn waren Jochen en ik (Owen) niet zeker over of ze juist waren of werkten niet op packet tracer.

## Deel 1

opstelling maken

## Deel 2

### Stap 1: ipv6 op alle pc's



### Stap 2: *configureer de switchen*

a. Maak DNS lookup ongedaan.

​      No ip domain lookup

b. Configureer een hostname.

​      Hostname x

c. Wijs volgende domeinnaam toe: **ccna-lab.com**.

​      ip domain-name x

d. Encrypteer de plain-text paswoorden.

​      Service password-encryption

e. Maak een MOTD banner die de gebruikers waarschuwt : “Toegang voor onbevoegden is verboden”.

​      Banner motd #x#

f. Maak een lokale user database met een gebruikersnaam **admin** en paswoord **classadm**.

​      Username x priv y password z

g. Configureer **class** als het privileged EXEC geëncrypteerd paswoord.

​      Enable secret x

h. Configureer **cisco** als het console paswoord en maak login mogelijk.

​      Line console 0

​      Password x

​      login

i. Maak login op de VTY lijnen mogelijk door gebruik te maken van de lokale database.

​      Line vty 0 15

​      Login local

j. Genereer een crypto rsa key voor ssh, gebruik makend van een modulus grootte van 1024 bits.

​      Crypto key generate rsa 

​      1024

k. Verander de transport input  op alle VTY lijnen  naar alleen SSH en Telnet.

​      Line vty 0 15

**Transport input ssh telnet/all --> dit werkt enkel als je all ingeeft, maar dan voeg je meer dingen toe dan enkel ssh en telnet**

**l. Wijs een IPv6 adres toe aan VLAN 1 overeenkomstig de adrestabel.**

​      **Interface vlan 1**

​      **Ipv6 address x**

​      no shutdown

****

**Voeg hier tussen de runningconfiguration file van S1.**

### Stap 3: *configureer de basisinstellingen op alle routers*

a. Maak DNS lookup ongedaan.

​      no ip domain-lookup

b. Configureer een hostname.

​      Hostname R1

c. Wijs volgende domeinnaam toe: **ccna-lab.com**.

​      ip domain-name ccna-lab.com

d. Encrypteer de plain-text paswoorden.

​      service password-encryption

e. Maak een MOTD banner die de gebruikers waarschuwt : “Toegang voor onbevoegden is verboden”.

​      banner motd #...#

f. Maak een lokale user database met een gebruikersnaam **admin** en paswoord **classadm**.

​      username admin privilige 15 secret classadm

g. Configureer **class** als het privileged EXEC geëncrypteerd paswoord.

​      enable secret class

h. Configureer **cisco** als het console paswoord en maak login mogelijk.

​      line console 0

​      password cisco

​      login

**i. Maak login op de VTY lijnen mogelijk door gebruik te maken van de lokale database.**

​      **line  vty 0 15**

​      **login local**

j. Genereer een crypto rsa key voor ssh, gebruik makend van een modulus grootte van 1024 bits.

​      crypto key generate rsa 

​      1024

**k. Verander de transport input  op alle VTY lijnen  naar alleen SSH en Telnet.**

​      **transport input telnet ssh**

### Stap 4: *configureer IPv6 instellingen op R1*

a. Configureer de IPv6 unicast adressen op de volgende interfaces: G0/0, G0/1, S0/0/0 en S0/0/1.

​      Int x

​      Ipv6 address x

      no shutdown

b. Configureer de IPv6 link-local adressen op de volgende interfaces: G0/0, G0/1, S0/0/0 en S0/0/1. Gebruik **FE80::1** voor de link-local adressen op alle vier interfaces.

​    Int x

​    Ipv6 address x link-local

​	   No shutdown

c. Zet de clock rate op S0/0/0 op 128000.

​    Clock rate x

d. Zorg ervoor dat de interfaces IPv6-pakketten kunnen versturen.

​	   Ipv6 enable

e. Maak IPv6 unicast routing mogelijk.

​     Ipv6 unicast-routing

**f. Configureer OSPFv3 op R1 en zorg dat de LAN-interfaces passieve interfaces zijn.**

​      Ipv6 router ospf 1

​		router-id 1.1.1.1

​	 interface ...

​		ipv6 ospf 1 area 0

​      **passive-interface gigabitEthernet0/0**

​      **passive-interface gigabitEthernet0/1**

**Voeg hier tussen de runningconfiguration file van R1.**

### Stap 5*: configureer IPv6 instellingen op R2*

idem als stap 4, behalve andere waarden en:

**f. Maak een default route die gebruik maakt van de loopback interface Lo1 (deze dient ter simulatie van een internetconnectie).**

​	**ipv6 route ::/0 2001:DB8:AAAA:4::1**

### Stap 6*: configureer IPv6 instellingen op R3*

idem als stap 4

### Stap 7: *Controleer de connectiviteit*

was niet mogelijk door een probleem met het configureren van ipv6 op de switches.

## Deel 3

### *Stap 1: Configureer en controleer VTY beperkingen op R1:*



**a. Maak een (extended) ACL genaamd RESTRICT-VTY zodat alleen hosts van het 2001:db8:acad:a::/64 netwerk kunnen telnetten naar R1. Alle andere hosts kunnen alleen gebruik maken van SSH om te connecteren met R1.**

**Voeg hier de configuratie van de ACL in:**

****

**R1(config)# ………………………………………………………………………………..**

**ipv6 access-list RESTRICT-VTY**

****

**R1(config-ipv6-acl)# ………………………………………………………………………**

​	permit tcp 2001:db8:acad:a::/64 eq telnet host 2001:db8:aaaa:1::1

****

**R1(config-ipv6-acl)# ………………………………………………………………………**

****

**b. Pas de  RESTRICT-VTY ACL toe op de VTY lijnen van R1.**

****

**Geef de gebruikte commando’s**

****

**R1(config-ipv6-acl)# ………………………………………………………………………**

​      **line vty 0 15**

****

**R1(config-line)# ……………………………………………………………………………**

​	**ipv6 access-class RESTRICT-VTY in**

c. Toon de nieuwe ACL. 

Geef het commando: 

​	R1#show ip access-lists [RESTRICT-VTY]

 Geef de uitvoer van bovenstaand commando :

​	IPv6 access list RESTRICT-VTY

​	permit tcp 2001:DB8:ACAD:A::/64 eq telnet host 2001:DB8:AAAA:1::1

d. Controleer dat de RESTRICT-VTY ACL alleen Telnet verkeer toelaat van het 2001:db8:acad:A::/64 netwerk.

### *Stap 2: Beperk de Telnet-toegang tot het* *2001:db8:acad:a::/64 netwerk**:*

a. Maak een (extended) ACL genaamd **RESTRICTED-LAN**  dat alle Telnet-toegang tot het 2001:db8:acad:a::/64 netwerk blokkeert.

 Voeg hier de configuratie van de ACL in:

​	R1(config)# ip access-list extended x

​	R1(config-ipv6-acl)# permit tcp 2001:db8:acad:a::/64 any

​	R1(config-ipv6-acl)# deny tcp 2001:db8:acad:a::/64 any eq telnet

​	R1(config-ipv6-acl)# ………………………………………………………………………



b. Pas de  RESTRICTED-LAN ACL toe op de G0/1 interface van R1 voor al het uitgaande verkeer. 

 Geef de gebruikte commando’s 

 	R1(config)# **int g0/1**

 	R1(config-if)# **ipv6 traffic-filter RESTRICTED-LAN ACL out**

c. Telnet naar S1 van PC-B en PC-C om te controleren dat Telnet inderdaad geblokkeerd wordt. Gebruik vervolgens SSH van PC-C naar S1 om te controleren dat je via SSH wel nog S1 kan bereiken. Troubleshoot indien nodig.

 

d. Toon de nieuwe ACL. 

Geef het commando:

 	R1# show ip access-lists 



Merk op dat in elke lijn het aantal hits of matches staat die zijn opgetreden sinds de ACL was toegepast op de interface

e. Gebruik het **clear ipv6 access-list**-commando om de match-tellers te resetten voor de RESRICTED-LAN ACL

​	R1# **clear ipv6 access-list RESTRICTED-LAN** 

 

f. Toon opnieuw de ACL om te controleren dat de tellers inderdaad terug op nul staan.

Geef het commando: 

​	R1# ………………………………………………… 

Geef de uitvoer van bovenstaand commando :

## **DEEL 4: Aanpassingen aan een IPv6 ACL** 

Voordat je met de aanpassingen begint in de *RESTRICTED-LAN ACL*, verwijder je best eerst de ACL van de interface.

### *Stap 1: Verwijder de* *RESTRICTED-LAN ACL van de interface*

Geef de gebruikte commando’s  

​	R1(config)# **show access-list RESTRICTED config (kijken)**

​	R1(config-if)#**ipv6 access-list RESTRICTED**

​	**R1(config-if)# no x**

### *Stap 2: Toon alle ACL*

Geef het commando:

 	R1# ………………………………………………… 

Geef de uitvoer van bovenstaand commando :



### *Stap 3: Voeg een nieuw ACL-statement toe door gebruik te maken van een volgnummer*

​	R1(config)# **ipv6 access-list RESTRICTED-LAN** 

​	R1(config-ipv6-acl)# **permit tcp 2001:db8:acad:b::/64 host 2001:db8:acad:a::a eq 23 sequence 15**  

Wat is het gevolg van deze nieuwe statement?  

……………………………………………………………………………………………………………….

 

### *Stap 4: Voeg een nieuw ACL-statement toe aan het einde van de* *RESTRICTED-LAN ACL*

​	R1(config-ipv6-acl)# **permit tcp any host 2001:db8:acad:a::3 eq www** 

 **Opmerking**: Eigenlijk is deze statement overbodig. Deze wordt enkel gebruikt om te tonen hoe een statement wordt toegevoegd aan het einde van een ACL. 

 

### *Stap 5: Toon opnieuw de ACLs om de veranderingen te controleren*

Geef de uitvoer van het commando:



### *Stap 6: Verwijder de laatst toegevoegde lijn in de* *RESTRICTED-LAN ACL*

Geef het gebruikte commando:

​	R1(config-ipv6-acl)# no x

 

### *Stap 7: Toon opnieuw de* *RESTRICTED-LAN ACL* *om de veranderingen te controleren*

Geef het gebruikte commando:

​	R1(config-ipv6-acl)# **show access-list RESTRICTED**

Geef de uitvoer van het commando:



### *Stap 8: Pas opnieuw de* *RESTRICTED-LAN ACL* *toe op de interface G0/1*

Geef de gebruikte commando’s:

​	R1(config)# **……………………………………………………………………………………**
      interface g0/1

​	R1(config-if)# **………………………………………………………………………………….**
      ipv6 traffic-filter x
 

### *Stap 9: Test de veranderingen van de ACL.* 

Telnet naar S1 vanuit PC-B. Troubleshoot indien nodig.
