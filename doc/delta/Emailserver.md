# Overzicht documentatie

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


## Hoe werkt email

Om te begrijpen hoe we een email server gaan opstellen is het misschien best dat we eerst kijken naar hoe een email wordt verstuurd. Het lijkt een simpel proces waar de verzender een document opstelt waaraan de ontvanger en data van de mail geplakt wordt, maar niets is minder waar. Om een email te versturen zijn er verschillende stappen. Er zijn 3 grote rollen bij het verzenden/ontvangen van een mail: mail user agent MUA, mail transfer agent MTA en de mail delivery agent MDA. Het start allemaal bij de MUA, dit is de applicatie die men gebruikt om de mail op te stellen bv. Outlook. Eenmaal dat er op de knop verzenden wordt geklikt geeft de MUA de mail door naar de MDA. Als de mail niet via het internet moet passeren ( doordat 2 locale werkstations naar elkaar sturen bijvoorbeeld) dan levert de MDA deze mail af aan het juiste werkstation. Als de mail naar een ander domein moet gaan dan levert de MDA de mail af aan de MTA van de verzender en staat de mail in een queue om verzonder te worden op het internet. Eenmaal het de beurt is van de mail om verzonden te worden dan levert de MTA van de zender de mail af aan de MTA van de ontvanger via het internet. Het kan ook zijn dat de email niet aanvaard wordt door de MTA van de ontvanger omdat het emailadres niet gevonden werd of het domein van het emailadres bestaat niet of dergelijke. Als de mail gestuurd kan worden naar de ontvanger, dan wordt de mail eerst nog getest door de mail submission agent MSA ofdat het geen spam/virussen bevat voordat het in het ontvangende domein mag. De MTA vand eonvanger zal dan de mail doorsturen naar de MDA van de ontvanger die het on zijn beurt aflevert aan de MUA van de ontvanger.

![Hoe werkt mail](/doc/delta/images/Email.PNG)
[RHCE Training - Postfix Mail Server Configuration](https://www.youtube.com/watch?v=HmG6g0ujhJc&ab_channel=networknutsdotnet)

## Postfix

Als mail transfer agent zullen wij postfix gebruiken. Dit is een open-source mailserver die de mails zal versturen. Dit blijkt een betere optie te zijn dan de verscheidene varianten die er bestaan doordat hij ontworpen is om veel email te verwerken en ontworpen is om weinig tot geen security-breaches te hebben. Postfix werd ontworden in IMB en wordt standaard gelever op linuxtoestellen. Het is vrij simpel om op te stellen doordat er enkel een paar variabelen aangepast moeten worden in het configuratiebestand. Om meer veiligheid aan de mails toe te voegen kan er ingesteld worden dat er gebruik wordt gemaakt van Transport Layer Security TLS.

[Postfix](https://wiki.archlinux.org/index.php/Postfix)

## postfix installeren

Een gedetailleerde uitwerking was online te vinden hoe je makkelijk postfix installeert. Ookal is deze geschreven voor centOs7, het werkt ook op centOs8.

[How to Install Postfix on CentOS/RHEL 7/6/5](https://tecadmin.net/install-and-configure-postfix-on-centos-redhat/)

## Dovecot

Naast het opstellen van een MTA hebben we oom een mail delivery agent nodig. Hier kiezen we voor dovecot. Dovecot is voornamelijk geoptimaliseerd voor IMAP, maar kan ook andere protocollen aan zoals POP3, LMTP ... Het belangrijkste aan Dovecot is dat het gevchreven werd met de gedacht van een hoge securiteit te hebben en een hoge performance. Ook wou hij dat alles makkelijk in te stellen was zodat Dovecot in zo goed als iedere omstandigheid gebruitk kan worden(verschillende databanken die gebruikt worden om de mail in op te slaan enzo).

[Dovecot: The better IMAP-server](https://www.youtube.com/watch?v=DedX-brYW1M&ab_channel=peerheinlein)
[Dovecot](https://www.dovecot.org/)

## dovecot installeren

Ook voor dovecot vond ik een installatiegids op het internet, die ook weer voor centOs7 is gemaakt maar toch werkt bij centOs8.

[How to Install Dovecot on CentOS 7](https://tecadmin.net/install-dovecot-centos-7/)

## SpamAssassin

Om wat meer veiligheid te creëren in onze mailserver installeren we 2 zaken: een spamfilter en een antivirus. Als spamfilter gebruiken we SpamAssassin.
Dit is een open-source spamfiler gemaakt door Apache Software Foundation. En gebruikt verscheidene technieken op emails te controlleren op het al dan niet bevatten van spam zoals: analyse van de text, Bayesian filteren(gebaseerd op de Bayes regel die de waarschijnlijkheid van een evenement geeft), DNS blocklist en filter databanken.

[SpamAssassin](https://spamassassin.apache.org/)
[Explained: Bayesian spam filtering](https://blog.malwarebytes.com/security-world/2017/02/explained-bayesian-spam-filtering/)

## SpamAssassin installeren

De installatie en configuratie van SpamAssassin was online uitgebreid te vinden. Tijdens deze installatie wordt SpamAssassin ook geïntegreerd met postfix.
[Set Up SpamAssassin on CentOS/RHEL to Block Email Spam](https://www.linuxbabe.com/redhat/spamassassin-centos-rhel-block-email-spam)

## ClamAv

Naast een spamfilter willen we ook een antivirus hebben zodat kwaadaardige mails die toch doorgeraakt zijn geen schade aan ons systeem kunne brengen. ClamAV is een opensource software dat de mail gateways scant op virussen.

[ClamAV](https://www.clamav.net/)

## ClamAv installeren

Ook van ClamAV was er een online guide te vinden van hoe we deze moet installeren en configureren.
[How to install the Clamav antivirus on CentOS 8](https://www.adminbyaccident.com/security/how-to-install-the-clamav-antivirus-on-centos-8/)
