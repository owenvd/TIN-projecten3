# Intervisiegesprek

|                     |                   |
| ------------------: | :---------------- |
|            **Week** | 5                 |
|           **Datum** | 2020-10-20, 09:00 |
|        **Aanwezig** |                   |
| **Verontschuldigd** |                   |
|         **Afwezig** |                   |
|    **Verslaggever** |                   |

## Agenda

- voorbereiding cisco labo
- verdere uitwerking DNS server

## Realisaties vorige periode

### Algemeen

![trello board week 5](/rapportering/images/Intervisie-w5-Trello.JPG)

![burndown week 5](/rapportering/images/Intervisie-w5-Burndown.JPG)

![Spent by users week 5](/rapportering/images/Intervisie-w5-SpentUsers.JPG)



### Vermeulen Kelvin

- Lokale SCCM server opgesteld
- SQL script gemaakt
- ADK, SCCM script geschreven
- XML file voor init config opgesteld

### Van de Cappelle Jari

- Voorbereiding cisco labo
- OU's instellen op Domeincontroller
### Robyn Moreno
- automatiseren webserver deployment
- automatiseren postgresql deployment
- testen playbooks drupal install
### Dewachter Jochen

- cisco labo voorbereiden + bespreking hierover
- proberen uitvinde hoe het ansible skeleton werkt

### Van Damme Owen

- host aan dns toegevoegd
- mx record toegevoegd
- forwarders
- recursion
- cisco labo voorbereid (configuratie alle routers en switches)
- bespreking cisco labo met Jochen



## Problemen

- mx record nodig voor DNS server?
- recursion op true is niet correct maar anders werkte de forwarders niet, hoe oplossen?
- standaard staat nslookup op 10.0.2.3, hoe kan ik deze op 127.0.0.1 zetten?
- Wat moet er nog gebeuren voor DNS server?
- IPv6 op switches in packet tracer werkt niet?
- drupal instalatie is extreem traag

## Planning komende periode

- cisco labo uitvoeren
- DNS server lokaal afwerken
- SCCM met juiste IP-instellingen configureren
- SCCM scripts samenvoegen in één hoofdscript (zonder fouten)
- DC script en init file opstellen
