# TEST PLAN: DNS SERVER - BRAVO

| **auteur testplan** | Owen Van Damme |
| ------------------- | -------------- |
| **uitvoerder test** | Jochen Dewachter|

## Requirements

- Na het gebruiken van de "vagrant up bravo" en eventueel "vagrant provision bravo" moet de DNS server automatisch geïnstalleerd en correct geconfigureerd zijn.
- Alle juist records moeten aanwezig zijn
- Alle servers moeten berijkbaar zijn met hun naam en hun ip adres

## Opmerkingen

- Een tweede server (maakt niet uit de functie van de server), met CentOS 8, bind-utils en een teksteditor is nodig om de test te kunnen vervoledigen (in ons project is normaal gezien dat elke server die aangemaakt word al deze packages heeft, maar voor de zekerheid is het eventueel handig om voor de test srv001 te gebruiken).
- Eventueel kan het ip adres in "sudo vim /etc/resolv.conf" aangepast worden naar **192.168.10.195** dan moet dit ip adress niet in elk commando dat deze voorkomt getypt worden. 

## Stap 1: Is de DNS server active and running

1. Log in op de DNS server bravo.

2. Controlleer of bravo active and running is
   Commando:

   ```
   systemctl status named
   ```

   Verwachte resultaat:

   ```
   ● named.service - Berkeley Internet Name Domain (DNS)
      Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor prese>
      Active: active (running) since Sun 2020-10-25 16:23:48 UTC; 36min ago
     Process: 19326 ExecReload=/bin/sh -c if /usr/sbin/rndc null > /dev/null 2>&1;>
     Process: 8145 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (co>
     Process: 8142 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "y>
    Main PID: 8147 (named)
       Tasks: 4 (limit: 5025)
      Memory: 104.9M
      CGroup: /system.slice/named.service
              └─8147 /usr/sbin/named -u named -c /etc/named.conf
   ```

   Controlleer voornaamlijk de derde lijn: "Active: ..."
   Resultaat:

   ```
   
   ```

   

## Stap 2: configuratie bestanden controlleren

1. Log in op de DNS server bravo.

2. Controlleer de SOA record

   Commando:

   ```
   sudo vim /var/named/CORONA2020.local
   ```

   Verwachte resultaat:

   ```
   ; Hash: eb17bd4a369c2f487faeff28a4e9c93f 1603643019
   ; Zone file for CORONA2020.local
   ;
   ; Ansible managed
   ;
   
   $ORIGIN CORONA2020.local.
   $TTL 1W
   
   @ IN SOA bravo.CORONA2020.local. hostmaster.CORONA2020.local. (
     1603643019
     1D
     1H
     1W
     2D )
   
                              IN  NS     bravo.CORONA2020.local.
   
   @                          IN  MX     10  delta.CORONA2020.local.
   
   
   bravo                      IN  A      192.168.10.195
   ns                         IN  CNAME  bravo
   alfa                       IN  A      192.168.10.194
   dc                         IN  CNAME  alfa
   charlie                    IN  A      192.168.10.196
   www                        IN  CNAME  charlie
   delta                      IN  A      192.168.10.197
   mail                       IN  CNAME  delta
   echo                       IN  A      192.168.10.198
   sccm                       IN  CNAME  echo
   ```

   Hier staan alle servers die moeten worden opgenomen in de DNS server, zo kan men de NS, MX, A en CNAME records zien van alle servers.

   Resultaat:

   ```
   
   ```

3. Controlleer de SOA record reverse lookup

   Commando:

   ```
   sudo vim /var/named/10.168.192.in-addr.arpa
   ```

   Verwachte resultaat:

   ```
   ; Hash: 6a5b63a7761af7e80e22c5d6719a9c25 1603643019
   ; Reverse zone file for CORONA2020.local
   ;
   ; Ansible managed
   ;
   
   $TTL 1W
   $ORIGIN 10.168.192.in-addr.arpa.
   
   @ IN SOA bravo.CORONA2020.local. hostmaster.CORONA2020.local. (
     1603643019
     1D
     1H
     1W
     1D )
   
                          IN  NS   bravo.CORONA2020.local.
   
   195                    IN  PTR  bravo.CORONA2020.local.
   194                    IN  PTR  alfa.CORONA2020.local.
   196                    IN  PTR  charlie.CORONA2020.local.
   197                    IN  PTR  delta.CORONA2020.local.
   198                    IN  PTR  echo.CORONA2020.local.
   
   ```

   Hier staan alle servers die moeten worden opgenomen in de reverse lookup zone van de DNS server, zo kan men de PTR records zien van alle servers.

   Resultaat:

   ```
   
   ```

4. Controlleer de SOA record reverse lookup

   Commando:

   ```
   sudo vim /etc/named.conf
   ```

   Verwachte resultaat:

   ```
   //
   // named.conf
   //
   //
   // Ansible managed
   //
   //
   options {
     listen-on port 53 { any; };
     listen-on-v6 port 53 { ::1; };
     directory   "/var/named";
     dump-file   "/var/named/data/cache_dump.db";
     statistics-file "/var/named/data/named_stats.txt";
     memstatistics-file "/var/named/data/named_mem_stats.txt";
     allow-query     { any; };
   
     recursion yes;
     allow-recursion { any; };
     forwarders { 8.8.8.8; 8.8.4.4; };
     rrset-order { order random; };
   
     dnssec-enable True;
     dnssec-validation True;
   
     /* Path to ISC DLV key */
     bindkeys-file "/etc/named.iscdlv.key";
   
     managed-keys-directory "/var/named/dynamic";
   
     pid-file "/run/named/named.pid";
     session-keyfile "/run/named/session.key";
   };
   
   
   logging {
     channel default_debug {
       file "data/named.run";
       severity dynamic;
       print-time yes;
     };
   };
   
   include "/etc/named.root.key";
   include "/etc/named.rfc1912.zones";
   
   zone "CORONA2020.local" IN {
     type master;
     file "/var/named/CORONA2020.local";
     notify yes;
     allow-update { none; };
   };
   
   zone "10.168.192.in-addr.arpa" IN {
     type master;
     file "/var/named/10.168.192.in-addr.arpa";
     notify yes;
     allow-update { none; };
   };
   ```

   Hier zijn dan nog eens de forward en reverse lookup zone van CORONA2020.local te zien met bijhorden ip adressen.

   Resultaat:

   ```
   
   ```

   

## Stap 3: DNS query versturen

1. Log in op srv001, of een enig andere server met de bind-utils

2. Controlleer of bravo nog online is
   Commando:

   ```
   ping 192.168.10.195
   ```

   Verwachte resultaat:

   ```
   PING 192.168.10.195 (192.168.10.195) 56(84) bytes of data.
   64 bytes from 192.168.10.195: icmp_seq=1 ttl=64 time=0.363 ms
   64 bytes from 192.168.10.195: icmp_seq=2 ttl=64 time=1.25 ms
   64 bytes from 192.168.10.195: icmp_seq=3 ttl=64 time=0.431 ms
   64 bytes from 192.168.10.195: icmp_seq=4 ttl=64 time=0.438 ms
   64 bytes from 192.168.10.195: icmp_seq=5 ttl=64 time=1.16 ms
   ```

   Resultaat:

   ```
   
   ```

3. Controleer forward zones interne netwerk met nslookup

   Commando:

   ```
    nslookup alfa.corona2020.local 192.168.10.195
   ```

   Verwachte resultaat:

   ```
   Server:         192.168.10.195
   Address:        192.168.10.195#53
   
   Name:   alfa.CORONA2020.local
   Address: 192.168.10.194
   ```

   Voor de volledigheid moet dit gedaan worden met alfa, bravo, charlie, delta en echo

   Resultaat:

   ```
   
   ```

4. Controleer reverse zones interne netwerk met nslookup

   Commando:

   ```
    nslookup 192.168.10.194 192.168.10.195
   ```

   Verwachte resultaat:

   ```
   194.10.168.192.in-addr.arpa     name = alfa.CORONA2020.local.
   ```

   Voor de volledigheid moet dit gedaan worden met alle ip adressen van alfa, bravo, charlie, delta en echo

   Resultaat:

   ```
   
   ```

5. Controleer forward zones extern netwerk met nslookup

   Commando:

   ```
   nslookup hogent.be 192.168.10.195
   ```

   Verwachte resultaat:

   ```
   Server:         192.168.10.195
   Address:        192.168.10.195#53
   
   Non-authoritative answer:
   Name:   hogent.be
   Address: 193.190.173.132
   ```

   Dit kan herhaald worden met elke website die je maar kan bedenken

   Resultaat:

   ```
   
   ```

6. Controleer forward zones intern netwerk met dig

   Commando:

   ```
    dig +short @192.168.10.195 alfa.corona2020.local
   ```

   Verwachte resultaat:

   ```
   192.168.10.194
   ```

   Voor de volledigheid moet dit opnieuw gedaan worden voor alle server namen

   Resultaat:

   ```
   
   ```

7. Controleer forward zones externe netwerk met dig

   Commando:

   ```
   dig +short @192.168.10.195 hogent.be
   ```

   Verwachte resultaat:

   ```
   192.190.173.132
   ```

   Kan opnieuw met elke website die je kan bedenken

   Resultaat:

   ```
   
   ```

   

8. Controleer NS record met dig

   Commando:

   ```
   dig +short @192.168.10.195 NS corona2020.local
   ```

   Verwachte resultaat:

   ```
   bravo.CORONA2020.local.
   ```

   ns staat voor name server en in ons project is dit bravo.corona2020.local

   Resultaat:

   ```
   
   ```

   

9. Controleer MX record met dig

   Commando:

   ```
   dig +short @192.168.10.195 mx corona2020.local
   ```

   Verwachte resultaat:

   ```
   10 delta.CORONA2020.local.
   ```

   mx record is de record die de mailserver bijhoud, in ons geval is dit delta.corona2020.local. De 10 is een preference en enkel belangrijk in het geval er meerdere mail servers zijn.

   Resultaat:

   ```
   
   ```

   





