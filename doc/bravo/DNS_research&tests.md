# Overzicht documentatie

## Technische Documentatie

### Achtergrondinfo

Om de taak van een DNS server uit te leggen word veel de vergelijking gemaakt met een telefoon boek. In een telefoon boek gaat een persoon een naam opzoeken van wie men het nummer wilt weten, naast hun naam staat hun nummer, dan toetsen ze het nummer in en bellen ze naar de persoon. DNS is vergelijkbaar, een persoon wilt een website bezoeken dus typt die de naam van de website in en een DNS server zoekt het overeenkomen IP adres en geeft deze dan aan de persoon en die ziet dan de website.

DNS lookup:

1. Gebruiker typt de naam van een website in de browser en deze word ontvangen door de DNS resolver.
2. De resolver stuurt een request naar DNS root nameserver.
3. Root server geeft het adress van de Top Level Domain (TLD) server aan de DNS resolver.
4. Resolver vraagt TLD server naar het IP adres van de website (kan .com, .org,... zijn want deze hebben verschillende TLD servers).
5. TLD server antwoord met het IP adres van de Authoritative Name Server.
6. Resolver vraagt de Authoritative Name Server voor het IP adres.
7. Authoritative Name Server antwoord met het ip adres van de gewenste website.
8. DNS resolver stuurt het ip adres door naar de gebruiker.
9. DNS resolver slaat het ip adres op in zijn cache geheugen voor een vlottere vertaling de volgende keer.

### bronnen

- https://www.youtube.com/watch?v=mpQZVYPuDGU
- https://umbrella.cisco.com/blog/what-is-the-difference-between-authoritative-and-recursive-dns-nameservers
- https://www.cloudflare.com/learning/dns/what-is-dns/#:~:text=DNS%20translates%20domain%20names%20to,IP%20addresses%20such%20as%20192.168.
- https://en.wikipedia.org/wiki/Domain_Name_System
- https://www.cloudflare.com/learning/dns/what-is-a-dns-server/

### Manueel DNS-server maken

Om dit te verwezenlijken heb ik een guide gevolgd (die hieronder gelinkt staat). Dit heb ik gedaan om te leren wat er juist allemaal aangepast moet worden en hoe een DNS server juist in mekaar zit. Hieruit heb ik geleerd dat de configuratie plaats vind in /etc/named.conf en de /var/named/CORONA2020.local directories dus kunnen we na het instellen van de BIND DNS server met ansible controlleren of daar alle bestanden die aangevuld moeten worden ook aangevuld zijn.

- https://www.linuxtechi.com/setup-bind-server-centos-8-rhel-8/

### Werken met Ansible

Om te leren werken met Ansible op een windows host heb ik gebruik gemaakt van de bertvv/ansible-skeleton github repository, een aantal roles en andere websites (alles staat hieronder gelinkt). Mijn uiteindelijk doel was om een LAMP server te kunnen provisionen en de ansible-skeleton volledig onder de knie te krijgen en heb het volgende geleerd. Een server aan de skeleton toevoegen gebeurd in de vagrant-hosts.yml file en daar voeg je de naam en alle andere specifiecaties toe die de server nodig heeft (een voorbeeld hiervan staat in de vagrant-hosts.yml file). Daarna maak je in de map ansible een roles directory, in deze map plaats je alle roles die nodig zijn voor de provisioning, deze kan ge downloaden van github op ansible galaxy. Dan moet je deze roles toevoegen in de site.yml. Wanneer verdere configuratie nodig is kan dit in site.yml maar er kan ook een host_vars map aangemaakt worden met daarin *hostnaam*.yml, dit is ook overzichtelijker wanneer er meerdere servers aanwezig zijn in het ansible skeleton.

Een fout die ik gemaakt heb en waar ik lang heb op moeten zoeken is de filestructuur. Ik had niet ansible>roles>rolenaam>en dan de role maar ik had ansible>roles>rolenaam>2de-rolenaam> en dan pas de rol. Op deze fout heb ik een lange tijd moeten zoeken maar deze heeft mij geleerd altijd de structuur te respecteren en controleren en altijd de syntax te volgen die in de documentatie staat.

- https://github.com/bertvv/ansible-skeleton
- https://github.com/bertvv/ansible-role-rh-base
- https://github.com/bertvv/ansible-role-mariadb
- https://github.com/bertvv/ansible-role-wordpress
- https://github.com/bertvv/ansible-role-httpd
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
- https://docs.ansible.com/ansible/2.3/playbooks_roles.html

### Ansible role BIND

Deze readme.md lezen is nodig om te begrijpen hoe een DNS server geconfigureerd moet worden a.d.h.v. een BIND role.

- https://github.com/bertvv/ansible-role-bind

### Authoritative Name Server Configureren met BIND op CentOS

- https://devops.ionos.com/tutorials/configure-authoritative-name-server-using-bind-on-centos-7/?fbclid=IwAR3zyHILD5K4zR8syKkCKiC6_D53pAHIv6iSb3PlpZXzZvHw6-25zLtdrD8

### Linux BIND DNS Server met Windows DC
- [serverlab](https://www.serverlab.ca/tutorials/linux/network-services/using-linux-bind-dns-servers-for-active-directory-domains/)
