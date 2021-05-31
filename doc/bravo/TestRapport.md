# TESTRapport: DNS SERVER - BRAVO

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
    Commando:
        vagrant shh bravo
    Resultaat:
        Ingelogd op de server.

2. Controlleer of bravo active and running is
    Commando:
        systemctl status named
    Resultaat:
        Deze staat op active.


## Stap 2: configuratie bestanden controlleren

1. Log in op de DNS server bravo.
    Commando:
        vagrant ssh bravo
    Resultaat:
        Ingelogd op de server.

2. Controlleer de SOA record
    Commando:
        sudo vim /var/named/CORONA2020.local
    Resultaat:
        Dit levert het verwachtte resultaat op.

3. Controlleer de SOA record reverse lookup
    Commando:
        sudo vim /var/named/10.168.192.in-addr.arpa
    Resultaat:
        Dit levert het verwachtte resultaat op.

4. Controlleer de SOA record reverse lookup
    Commando:
        sudo vim /etc/named.conf
    Resultaat:
        Hier heeft de 'allowed-query' een andere waarde:
        Er wordt verwacht dat her resultaat {any;} is maar ik bekom {192.168.10.0/24;}.


## Stap 3: DNS query versturen

1. Log in op srv001, of een enig andere server met de bind-utils
    Commando:
        vagrant ssh srv001
    Resultaat;
        Ingelogd op de server.
2. Controlleer of bravo nog online is
    Commando:
        ping 192.168.10.195
    Resultaat:
        Er wordt een reply terug gegeven.
3. Controleer forward zones interne netwerk met nslookup
    Commando:
        nslookup alfa.corona2020.local 192.168.10.195
    Resultaat:
        Dit levert het verwachtte resultaat op.
4. Controleer reverse zones interne netwerk met nslookup
    Commando:
        nslookup 192.168.10.194 192.168.10.195
    Resultaat:
        Dit levert het verwachtte resultaat op.
5. Controleer forward zones extern netwerk met nslookup
    Commando:
        nslookup hogent.be 192.168.10.195
    Resultaat:
        Dit levert het verwachtte resultaat op.
6. Controleer forward zones intern netwerk met dig
    Commando:
        dig +short @192.168.10.195 alfa.corona2020.local
    Resultaat:
        Dit levert het verwachtte resultaat op.
7. Controleer forward zones externe netwerk met dig
    Commando:
        dig +short @192.168.10.195 hogent.be
    Resultaat:
        Dit levert het verwachtte resultaatop .
8. Controleer NS record met dig
    Commando:
        dig +short @192.168.10.195 NS corona2020.local
    Resultaat:
        Dit levert het verwachtte resultaat op.
9. Controleer MX record met dig
    Commando:
        dig +short @192.168.10.195 mx corona2020.local
    Resultaat:
        Dit levert het verwachtter resultaat op.