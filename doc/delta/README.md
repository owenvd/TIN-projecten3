# Configuratie Emailserver - DELTA

Hierin staat beschreven hoe de mailserver geconfigureerd is, welke stappen ondernomen zijn om tot deze configuratie te komen en verdere uitleg.

## Wat doet een emailserver

De emailserver kan op 2 manieren werken. Je kan deze gebruiken puur als relay en dan zend hij mails gewoon door naar de juiste mailadressen. Je kan de emailserver ook zo instellen dat de mails opgeslagen worden op de server en dat de hosts via POP of IMAP hun mails hierop terugvinden. Hoe email op zicht werkt staat uitgelegd in [het emailserverbestand](/doc/delta/Emailserver.md).

## Requirements

Aangezien we deze server automatisch willen laten opstarten en provisionen (en we op een windows machine werken) maken we gebruik van de [anisble-skeleton](https://github.com/bertvv/ansible-skeleton) voorzien door [Bert Van Vreckem](https://github.com/bertvv) en moeten dus eerst nog wat voorbereiden werk doen.

1. De naam en het IP adres van de server moet toegevoegd worden aan de vagrant-hosts.yml file (Subnet moet niet gespecifieerd worden aangezien deze standaard op /24 gezet word in deze ansible-skeleton)

   ```
   - name: delta
     ip: 192.168.10.197
   ```

2. Deze server moet dan worden toegevoegd als host in site.yml en voegen direct ook de juiste role toe

   ```
   - hosts: delta
     become: true
     roles:
       - mailserver
   ```

   We hebben besloten om op deze server gebruik te maken van Mailserver. Meer bepaald de [mailserver role](https://github.com/bertvv/ansible-role-mailserver) uitgeschreven door [Bert Van Vreckem](https://github.com/bertvv). Wanneer hier iets onduidelijk is of wenst meer uitbereiding/vind u niet wat u zoekt, kan u altijd op de GitHub van deze role gaan.

3. Nu moeten enkel nog maar een 'roles' en een 'host_vars' directory gemaakt worden in de ansible directory. In host_vars maken we nog een file genaamd bravo.yml en in die file gebeurt alle configuratie. In de roles directory word de gedownloade role geplaatst.

   ```
   .
   ├───files
   ├───group_vars
   ├───host_vars
   ├───roles
   │   ├───mailserver
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
| roles    | roles nodig om server te provisionen   

## Provisioning van de mailserver

In de map tasks bij de rol 'mailserver' vinden we de taken terug die uitgevoerd moeten worden. Het hoofdbestand hier is main.yml: hierin staan de specifieke tasks die uitgevoerd zullen worden:

    ```
    - include_tasks: sendmail.yml
    - include_tasks: postfix.yml
    - include_tasks: dovecot.yml
    - include_tasks: spamassassin.yml
    - include_tasks: clamav.yml
    ```

1. sendmail.yml

    Hierin wordt maar 1 iets gedaan, namelijk het sendmail-package verwijderen. Dit doen we omdat sendmail standaard op CentOS staat, maar dit kan voor conflicten zorgen met postfix.

    ```
    - name: uninstall Sendmail
    yum:
        name: sendmail
        state: removed
    tags:
        - mailserver
        - sendmail
    ```

2. postfix.yml

    Om postfix op een correcte manier te doen werken worden een verschillende tasks uitgevoerd.

    1. Eerst installeren we de postfix package. Hierna zorgen we er ook voor dat deze postfix-service zeker gestart is

        ```
        - name: Install Postfix
          yum:
            name: postfix
            state: latest
          tags:
            - mailserver
            - postfix

        - name: Ensure Postfix is started
          service:
            name: postfix
            state: started
            enabled: true
          tags:
            - mailserver
            - postfix
        ```

    2. Vervolgens willen ook wat veiligheid in de mailserver steken. Dit doen we aan de hand van SSL, dit is een securitylaag die tussen  de server en het internet staat waardoor de gegevens beveiligd worden. Hiervoor doen we 2 dingen: het eerste is in de postfixdirecory maken we een map aan waarin we onze SSL-certificate willen opslaan en in de tweede stap gaan we ze kopieren vanop de lokale host uit de filesfolder in de rol naar de server.

        ```
        - name: Make SSL directory
          file:
            path: /etc/postfix/ssl
            state: directory
            mode: 0755
          tags:
            - mailserver
            - ssl

        - name: Copy SSL key to directory
          copy:
            src: files/
            dest: /etc/postfix/ssl
          tags:
            - mailserver
            - ssl
        ```

    3. In de volgende stap gaan we postfix configureren. DIt gebeurd in 2 bestanden: /etc/postfix/main.cf en /etc/postfix/master.cf. In het main.cf-bestand gaan we variabelen configureren en het master.cf -bestand dient om de daemonprocessen op te starten. Beide bestanden configureren we aan de hand van templates, deze zijn te vinden in de templatesfolder in de role. Nadat de configuratie doorgevoerd is spreken we een handler aan die de postfixservice opnieuw opstart zodat de configuratie kan doorgevoerd worden.

        ```
        - name: Install postfix main configuration1
          template:
            src: postfix_main.cf.j2
            dest: /etc/postfix/main.cf
          tags:
            - postfix
            - mailserver
          notify: restart postfix

        - name: Install postfix master configuration1
          template:
            src: postfix_master.cf.j2
            dest: /etc/postfix/master.cf
          tags:
            - postfix
            - mailserver
          notify: restart postfix
        ```

    4. De laatste verplichte stap is degene waarin we een file aanmaken waarin we onze local-host-names zetten. Zo kent de server deze. Ook na deze stap moet postfix opnieuw gestart worden met de handler om te configuratie door te voeren.

        ```
        - name: Create file local-host-names
          copy:
            dest: /etc/postfix/local-host-names
            content: "{{ postfix_mydomain }}"
          tags:
            - postfix
            - mailserver
          notify: restart postfix
        ```

    5. De laatste stap in optioneel. Hierin configureren we LDAP in postfix. LDAP of leightweight directory access protol is een protocol dat beschrijft hoe de gegevens gevonden kunnen worden op de server. Aangezien wij een Active directory hebben is dit hier niet nodig. Deze stappen worden enkel uitgevoerd als we in de variablen ldap op true zetten.

        ```
        - name: Link ldap files with postfix's main configuration
          blockinfile:
            dest: /etc/postfix/main.cf
            block: |
                alias_maps = hash:/etc/postfix/aliases
                virtual_alias_maps = ldap:/etc/postfix/ldap-aliases.cf
                local_recipient_maps = $alias_maps, ldap:/etc/postfix/ldap-users.cf
          when: postfix_ldap == true

        - name: Create ldap aliases
          template:
            src: ldap-aliases.cf.j2
            dest: /etc/postfix/ldap-aliases.cf
          when: postfix_ldap == true

        - name: Create ldap users file
          template:
            src: ldap-users.cf.j2
            dest: /etc/postfix/ldap-userss.cf
          when: postfix_ldap == true
        ```

3. dovecot.yml

    In dit yamalbestand staan alle taken om dovecot juist te configureren.

    1. De eerste taak die we zullen uitvoeren is het installeren van de dovecotpackage. We zorgen er dan ook voor dat na de installatie de dovecotservice gestart is.

        ```
        - name: Install Dovecot
          yum:
            name: dovecot
            state: latest
          tags:
            - mailserver
            - dovecot

        - name: Ensure Dovecot is started
          service:
            name: dovecot
            state: started
            enabled: true
          tags:
            - mailserver
            - dovecot
        ```
    
    2. Nu gaan we dovecot configureren. In de eerste taak zeggen we waar de maildirectory staat zodat dovecot deze terug kan vinden. In de tweede stap configureren we SASL een authenticatieprotocol zodat een gebruiker de juiste gegevens kan zien. En in de laatste stap gaan we de authenticatie mechanismes in. Deze bestanden configurerenwe ook via templates die gevonden kunnen worden in de templatesfolder.

        ```
        - name: Setting dovecot mail location
          template:
            src: 10-mail.conf.j2
            dest: /etc/dovecot/conf.d/10-mail.conf
          notify: restart dovecot
          tags:
            - mailserver
            - dovecot

        - name: Now configure Dovecot SASL for SMTP Auth
          template:
            src: 10-master.conf.j2
            dest: /etc/dovecot/conf.d/10-master.conf
          notify: restart dovecot
          tags:
            - mailserver
            - dovecot

        - name: Setting dovecot authentication mechanisms
          template:
            src: 10-auth.conf.j2
            dest: /etc/dovecot/conf.d/10-auth.conf
          notify: restart dovecot
          tags:
            - mailserver
            - dovecot
        ```

4. spamassassin.yml

    Hierin configureren we spamassassin zodanig dat spam tegen gehouden wordt en er een nieuwe emailheader aan teogevoegd word.

    1. Ook hier starten we et de package te installeren

        ```
        - name: Install SpamAssassin
          yum:
            name: spamassassin
            state: latest
          tags:
            - mailserver
            - spamassassin
        ```

    2. Hierna configureren we spamassassin deze keer doen we dit niet via een template maar voegen we een kleine lijn code toe aan het local.cf-bestand.

        ```
        - name: Configuring SpamAssassin
          copy:
            content: 'report_safe 0 required_score 8.0 rewrite_header Subject [SPAM]'
            dest: '/etc/mail/spamassassin/local.cf'
          tags:
            - mailserver
            - spamassassin
        ```

    3. De volgende taak zorgt ervoor dat spamassassin gestart is en we maken ook dat spamassassin gestart wordt als de server word geboot.

        ```
        - name: Making sure SpamAssassin has been started.
          service:
            name: spamassassin
            state: started
          tags:
            - mailserver
            - spamassassin

        - name: Making sure SpamAssassin will start on boot
          service:
            name: spamassassin
            enabled: yes
          tags:
            - mailserver
            - spamassassin
        ```

    4. In de laatste stap maken we een user aan voor spamassassin.

        ```
        - name: Creating user for SpamAssassin
          user:
            name: spamd
            state: present
            shell: /bin/false
          tags:
            - mailserver
            - spamassassin
5. clamav.yml
