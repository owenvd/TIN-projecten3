# TEST PLAN: DNS SERVER - BRAVO
| **auteur testplan** | Jochen Dewachter |
| ------------------- | -------------- |
| **uitvoerder test** |                |

## Requirements

- Door het commando 'vagrant up delta' te gebruiken wordt de email-server automatisch geïnstalleerd en geconfigureerd.
- Alle 4 de services moeten runnen.
- Accounts moeten naar elkaar en naar andere mailadressen kunnen sturen.

## Opmerkingen

- Om de tests te vervolledigen hebben we natuurlijk hosts nodig die mails kunnen sturen naar elkaar.

## Stap 1: Is de server active and running

1. Log in op de delta server.

      vagrant ssh delta

2. Kijk of de server up and running is.

      systemctl status

   Verwachte resultaat:

   ```
   delta
   State: running
    Jobs: 0 queued
  Failed: 0 units
   Since: Mon 2020-11-02 09:25:56 UTC; 18min ago
  CGroup: (hierin staat een boomstructuur)
   ```
   Door de state: running zijn we zeker dat de server werkt.

## Stap 2: configuratie bestanden controlleren

1. Voor postfix zijn de volgende bestanden aangepast.

    - om een bestand te bekijekn dient het volgende commando in gegeven te worden:

          vim 'bestandpad'

    - /etc/postfix/ssl
      - Dit is een nieuwe directory en heebt de volgende 4 bestanden:
          - server.crt
          - server.csr
          - server.key
          - server.key.secure

      - Bekijk dit door volgende commando's uit te voeren
          - cd /etc/postfix/ssl
          - ls

      - Dit dient om de SSL-certificaten toe te voegen. Zo worden de gegevens beveiligd.

    - /etc/postfix/main.cf
      - Hierin zou het volgende moeten toegevoegd zijn aan het einde van het bestand:
        ```
          myhostname= {{ postfix_myhostname }}
          mydomain = {{ postfix_mydomain }}
          myorigin = $mydomain
          home_mailbox = {{ postfix_home_mailbox }}
          mynetworks = {{ postfix_mynetwork }} 127.0.0.0/8
          inet_interfaces = all
          mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
          smtpd_sasl_type = dovecot
          smtpd_sasl_path = private/auth
          smtpd_sasl_local_domain =
          smtpd_sasl_security_options = noanonymous
          broken_sasl_auth_clients = yes
          smtpd_sasl_auth_enable = yes
          smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination
          smtp_tls_security_level = may
          smtpd_tls_security_level = may
          smtp_tls_note_starttls_offer = yes
          smtpd_tls_loglevel = 1
          smtpd_tls_key_file = /etc/postfix/ssl/server.key
          smtpd_tls_cert_file = /etc/postfix/ssl/server.crt
          smtpd_tls_received_header = yes
          smtpd_tls_session_cache_timeout = 3600s
          tls_random_source = dev:/dev/urandom
        ```

    - /etc/postfix/master.cf
      - In dit bestand staan de volgende regels code NIET in comments(tekst voorafgaand door #):
        ```
        smtp      inet  n       -       n       -       -       -o content_filter=spamassassin
        submission     inet  n       -       n       -       -       smtpd
          -o syslog_name=postfix/submission
          -o smtpd_sasl_auth_enable=yes
          -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
          -o milter_macro_daemon_name=ORIGINATING
        smtps     inet  n       -       n       -       -       smtpd
          -o syslog_name=postfix/smtps
          -o smtpd_sasl_auth_enable=yes
          -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
          -o milter_macro_daemon_name=ORIGINATING
          pickup    unix  n       -       n       60      1       pickup
          cleanup   unix  n       -       n       -       0       cleanup
          qmgr      unix  n       -       n       300     1       qmgr
          #qmgr     unix  n       -       n       300     1       oqmgr
          tlsmgr    unix  -       -       n       1000?   1       tlsmgr
          rewrite   unix  -       -       n       -       -       trivial-rewrite
          bounce    unix  -       -       n       -       0       bounce
          defer     unix  -       -       n       -       0       bounce
          trace     unix  -       -       n       -       0       bounce
          verify    unix  -       -       n       -       1       verify
          flush     unix  n       -       n       1000?   0       flush
          proxymap  unix  -       -       n       -       -       proxymap
          proxywrite unix -       -       n       -       1       proxymap
          smtp      unix  -       -       n       -       -       smtp
          relay     unix  -       -       n       -       -       smtp
          showq     unix  n       -       n       -       -       showq
          error     unix  -       -       n       -       -       error
          retry     unix  -       -       n       -       -       error
          discard   unix  -       -       n       -       -       discard
          local     unix  -       n       n       -       -       local
          virtual   unix  -       n       n       -       -       virtual
          lmtp      unix  -       -       n       -       -       lmtp
          anvil     unix  -       -       n       -       1       anvil
          scache    unix  -       -       n       -       1       scache
          spamassassin unix - n n - - pipe flags=R user=spamd argv=/usr/bin/spamc -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}
      ```

      - Deze bestanden dienen als configuratie van postfix.

    - /etc/postfix/local-host-names
      - In dit bestand zou er maar 1 lijn mogen staan namelijk die met de local hsot name:
        ```
          CORONA2020.local
        ```
      - Dit bestand zet de local host name naar wat er in het bestand weggeschreven is

    - /etc/postfix/ldap-aliases.cf en /etc/postfix/ldap-userss.cf
      - Dit is het configuratiebestand voor de LDAP, waarin het volgende zou moeten staan:
        ```
        bind = no    
        version = 3    
        timeout = 20    
        ## set the size_limit to 1 since we only    
        ## want to find one email address match    
        size_limit = 1    
        expansion_limit = 0    
        start_tls = yes    
        tls_require_cert = no    
        server_host = ldap://{{ ldap_fqdn1 }}
        search_base = ou={{ ldap_ou }},dc={{ ldap_dcname }},dc={{ ldap_domainname }},dc={{ ldap_root_domain }}    
        scope = sub    
        query_filter = (mail=%s)    
        result_attribute = mgrpDeliverTo    
        special_result_filter = %s@%d
      ```

  2. Voor Dovecot zijn volgende bestanden aangepast:

    - /etc/dovecot/conf.d/10-mail.conf
      - Hierin is het volgende aangepast:
        ```
        mail_location = maildir:~/{{ postfix_home_mailbox }}
        ```

      - Dit zet de directory van de mailbox.

    - /etc/dovecot/conf.d/10-master.conf
      - Dit zou het volgende moeten weergeven
        ```
        unix_listener /var/spool/postfix/private/auth {
          mode = 0660
          user = postfix
          group = postfix
        }
        ```
      - dit configureert de SASL voor SMPT

    - /etc/dovecot/conf.d/10-auth.conf
      - Alles in dit bestand zou in commentaar moeten staan.

  3. Bij spamassissin is het volgende bestand aangepast:

    - '/etc/mail/spamassassin/local.cf'
      - Hierin zou het volgende moeten staan:
        ```
        report_safe 0 required_score 8.0 rewrite_header Subject [SPAM]
        ```

      - Dit zou ervoor moeten zorgen dat de header van een email veranderd indien het spam is.

  4. Voor ClamAv is het volgende bestand gewijzigd:

    - /etc/clamd.d/scan.conf
     - Dit zou de volgende wijziging moeten hebben:
      ```
      LogSyslog yes
      User clamscan
      LocalSocket /var/run/clamd.scan/clamd.sock
      ```

## Stap 3: Kijken of de services al dan niet runnen

  - Door volgende commando's uit te voeren kunnen we zien ofdat
    1. sendmail verwijderd is
    2. postfix werkt
    3. dovecot werkt
    4. spamassassin werkt

  - ClamAv is geen lopende service en wordt enkel opgeropen wanneer nodig dus dit testen os niet mogelijk.

  - Voer volgende commando's uit:

    - sudo service sendmail status
      - resultaat: service sendmail is niet gevonden.
    - sudo service postfix status
      - resultaat: Bij 'state' staat er running.
    - sudo service dovecot status
      - resultaat: Bij 'state' staat er running.
    - sudo service spamassassin status
      - resultaat: Bij 'state' staat er running.

## Stap 4: Kijken of we mails kunnen versturen

  1. Log je aan op een host

  2. Ga naar de mailapp en probeer een mail te sturen naar 'naamhost2@CORORNA2020.local'

  3. Log je aan op host2

  4. Ga naar de maildirectory 'mail/' hierin zou de mail terug te vinden moeten zijn.
