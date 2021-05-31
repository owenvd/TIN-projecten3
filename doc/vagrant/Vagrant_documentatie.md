# Overzicht documentatie - Vagrant

## Inhoud documentatie

Voeg hier een tabel of inhoudstafel toe met links naar de juiste documenten. Maak een duidelijke directorystructuur met bv. een map per component/deelopdracht.

Wat verwachten we qua documentatie?

- Lastenboek per component/deelopdracht
    - Specificaties en requirements
    - Wat zijn de deeltaken? Dit worden tickets in Trello
    - Wie is verantwoordelijk voor realisatie en testen?
    - Hoe lang schat je voor elke deeltaak nodig te hebben?
- Technische documentatie
    - Achtergrondinfo, neerslag opzoekingswerk
    - Procedurebeschrijvingen
    - Functionele testplannen en -rapporten
    - Integratietestplannen en -rapporten

## Leren werken met Vagrant

Het leek mij belangrijk om eerst met Vagrant te leren werken alvorens te beginnen de DNS server op te zetten om uiteindelijk vlotter te leren werken met Vagrant en de DNS server beter te kunnen opzetten. Hiervoor heb ik een Youtube tutorial gevolgd maar ben ik op problemen gebotst en zal in dit document alles proberen te omschrijven.

### Youtube tutorial

- https://www.youtube.com/watch?v=vBreXjkizgo&t=132s

In deze tutorial is het de bedoeling om een LAMP stack box te maken. Maar dit is echter enkel om vertrouwt te geraken met Vagrant. De [ubuntu/trusty64](https://app.vagrantup.com/ubuntu/boxes/trusty64) box word gebruikt als start om dan daarin de rest van de LAMP stack te configureren (ik weet dat dit opzich niets te maken heeft met de opdracht of het opzetten van een dns server, maar ik wil ervaring en vertrouwen opdoen in de omgeving die ik moet gebruiken om de opdracht te kunnen vervolledigen)

### Problemen

Tijdens het volgen van de tutorial had ik echter een probleem, telkens als ik de box wou reloaden (omdat ik iets had aangepast in de vagrantfile) zat ik vast in een ssh authentication loop (een foto hiervan is hieronder te vinden).

![Reload output vagrant](/doc/vagrant/Images-Vagrant/reload-output.JPG)

Dit probleem was op te lossen door eerst het vagrant destroy en dan het vagrant up commando toe te passen maar daardoor werkte het commando vagrant reload nog altijd niet. Om mijn probleem op te lossen heb ik volgende bronnen geraadpleegd:

- https://github.com/hashicorp/vagrant/issues/7431
- https://github.com/hashicorp/vagrant/issues/9834
- https://github.com/hashicorp/vagrant/issues/9017

Echter vond ik hierin geen oplossing voor mijn probleem dus was het meevolgen van de tutorial een stuk moeilijker.