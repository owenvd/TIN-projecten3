# TEST PLAN: DNS SERVER - BRAVO
| **auteur testplan** | Jochen Dewachter |
| ------------------- | -------------- |
| **uitvoerder test** |   moreno robyn   |

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
   
   ```bash
    ● delta
    State: degraded
     Jobs: 0 queued
   Failed: 1 units
    Since: Mon 2020-12-14 00:16:56 UTC; 35min ago
   CGroup: /
           ├─user.slice
           │ └─user-1000.slice
           │   ├─user@1000.service
           │   │ └─init.scope
           │   │   ├─19497 /usr/lib/systemd/systemd --user
           │   │   └─19501 (sd-pam)
           │   └─session-7.scope
           │     ├─19493 sshd: vagrant [priv]
           │     ├─19507 sshd: vagrant@pts/0
           │     ├─19508 -bash
           │     ├─19533 systemctl status
           │     └─19534 (pager) status
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 17
           └─system.slice
             ├─rngd.service
             │ └─694 /sbin/rngd -f --fill-watermark=0
             ├─vboxadd-service.service
             │ └─1831 /usr/sbin/VBoxService --pidfile /var/run/vboxadd-service.sh
             ├─systemd-udevd.service
             │ └─584 /usr/lib/systemd/systemd-udevd
             ├─polkit.service
             │ └─688 /usr/lib/polkit-1/polkitd --no-debug
             ├─chronyd.service
             │ └─696 /usr/sbin/chronyd
             ├─auditd.service
             │ └─616 /sbin/auditd
             ├─tuned.service
             │ └─746 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
             ├─systemd-journald.service
             │ └─554 /usr/lib/systemd/systemd-journald
             ├─sshd.service
             │ └─745 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc,aes128-gcm@openssh.com,aes128-ctr,aes128-cbc -oMACs=hmac-sha2-256-etm@openssh.com,hmac-sha1-e>             ├─crond.service
             │ └─15133 /usr/sbin/crond -n
             ├─spamassassin.service
             │ ├─13698 /usr/bin/perl -T -w /usr/bin/spamd -c -m5 -H --razor-home-dir=/var/lib/razor/ --razor-log-file=sys-syslog
             │ ├─14744 spamd child                                                                                                                                                                                       >             │ └─14745 spamd child                                                                                                                                                                                       >             ├─NetworkManager.service
             │ └─3539 /usr/sbin/NetworkManager --no-daemon
             ├─gssproxy.service
             │ └─705 /usr/sbin/gssproxy -D
             ├─firewalld.service
             │ └─8539 /usr/libexec/platform-python -s /usr/sbin/firewalld --nofork --nopid
             ├─rpcbind.service
             │ └─602 /usr/bin/rpcbind -w -f
             ├─zabbix-agent.service
             │ ├─11357 /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf
             │ ├─11358 /usr/sbin/zabbix_agentd: collector [idle 1 sec]
             │ ├─11359 /usr/sbin/zabbix_agentd: listener #1 [waiting for connection]
             │ ├─11360 /usr/sbin/zabbix_agentd: listener #2 [waiting for connection]
             │ ├─11361 /usr/sbin/zabbix_agentd: listener #3 [waiting for connection]
             │ └─11362 /usr/sbin/zabbix_agentd: active checks #1 [idle 1 sec]
             ├─sssd.service
             │ ├─687 /usr/sbin/sssd -i --logger=files
             │ ├─758 /usr/libexec/sssd/sssd_be --domain implicit_files --uid 0 --gid 0 --logger=files
             │ └─761 /usr/libexec/sssd/sssd_nss --uid 0 --gid 0 --logger=files
             ├─postfix.service
             │ ├─19435 /usr/libexec/postfix/master -w
             │ ├─19436 pickup -l -t unix -u
             │ └─19437 qmgr -l -t unix -u
             ├─dovecot.service
             │ ├─19472 /usr/sbin/dovecot -F
             │ ├─19477 dovecot/anvil
             │ ├─19478 dovecot/log
             │ └─19479 dovecot/config
             ├─systemd-resolved.service
             │ └─774 /usr/lib/systemd/systemd-resolved
             ├─dbus.service
             │ └─691 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
             ├─system-getty.slice
             │ └─getty@tty1.service
             │   └─772 /sbin/agetty -o -p -- \u --noclear tty1 linux
             └─systemd-logind.service
               └─766 /usr/lib/systemd/systemd-logind
  ```

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
      ```bash
      [vagrant@delta ~]$ ls /etc/postfix/ssl/
      server.crt  server.csr  server.key  server.key.secure
      ```

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
        ```
        myhostname= mail.CORONA2020.local
        mydomain = CORONA2020.local
        myorigin = $mydomain
        home_mailbox = MailDir/
        mynetworks = 192.168.10.0/24 127.0.0.0/8
        inet_interfaces = all
        mydestination = $myhostname localhost.$mydomain localhost $mydomain
        relayhost =
        relay_domains = $mydomain
        inet_protocols = all
        smtpd_sasl_auth_enable = yes
        broken_sasl_auth_clients = yes
        smtpd_sasl_type = dovecot
        smtpd_sals_path =private/auth
        smtpd_sasl_security_options = noanonymous
        smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated permit_inet_interfaces defer_unauth_destination
        # BEGIN ANSIBLE MANAGED BLOCK
        alias_maps = hash:/etc/postfix/aliases
        virtual_alias_maps = ldap:/etc/postfix/ldap-aliases.cf
        local_recipient_maps = $alias_maps, ldap:/etc/postfix/ldap-users.cf
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
      
```
      #
# Postfix master process configuration file.  For details on the format
# of the file, see the master(5) manual page (command: "man 5 master").
#
# Do not forget to execute "postfix reload" after editing this file.
#
# ==========================================================================
# service type  private unpriv  chroot  wakeup  maxproc command + args
#               (yes)   (yes)   (yes)   (never) (100)
# ==========================================================================
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
#smtp      inet  n       -       n       -       1       postscreen
#smtpd     pass  -       -       n       -       -       smtpd
#dnsblog   unix  -       -       n       -       0       dnsblog
#tlsproxy  unix  -       -       n       -       0       tlsproxy
#submission inet n       -       n       -       -       smtpd
#  -o syslog_name=postfix/submission
#  -o smtpd_tls_security_level=encrypt
#  -o smtpd_sasl_auth_enable=yes
#  -o smtpd_reject_unlisted_recipient=no
#  -o smtpd_client_restrictions=$mua_client_restrictions
#  -o smtpd_helo_restrictions=$mua_helo_restrictions
#  -o smtpd_sender_restrictions=$mua_sender_restrictions
#  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
#  -o milter_macro_daemon_name=ORIGINATING
#smtps     inet  n       -       n       -       -       smtpd
#  -o syslog_name=postfix/smtps
#  -o smtpd_tls_wrappermode=yes
#  -o smtpd_sasl_auth_enable=yes
#  -o smtpd_reject_unlisted_recipient=no
#  -o smtpd_client_restrictions=$mua_client_restrictions
#  -o smtpd_helo_restrictions=$mua_helo_restrictions
#  -o smtpd_sender_restrictions=$mua_sender_restrictions
#  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
#  -o milter_macro_daemon_name=ORIGINATING
#628       inet  n       -       n       -       -       qmqpd
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
#       -o smtp_helo_timeout=5 -o smtp_connect_timeout=5
showq     unix  n       -       n       -       -       showq
error     unix  -       -       n       -       -       error
retry     unix  -       -       n       -       -       error
discard   unix  -       -       n       -       -       discard
local     unix  -       n       n       -       -       local
virtual   unix  -       n       n       -       -       virtual
lmtp      unix  -       -       n       -       -       lmtp
anvil     unix  -       -       n       -       1       anvil
scache    unix  -       -       n       -       1       scache
#
# ====================================================================
# Interfaces to non-Postfix software. Be sure to examine the manual
# pages of the non-Postfix software to find out what options it wants.
#
# Many of the following services use the Postfix pipe(8) delivery
# agent.  See the pipe(8) man page for information about ${recipient}
# and other message envelope options.
# ====================================================================
#
# maildrop. See the Postfix MAILDROP_README file for details.
# Also specify in main.cf: maildrop_destination_recipient_limit=1
#
#maildrop  unix  -       n       n       -       -       pipe
#  flags=DRhu user=vmail argv=/usr/local/bin/maildrop -d ${recipient}
#
# ====================================================================
#
# Recent Cyrus versions can use the existing "lmtp" master.cf entry.
#
# Specify in cyrus.conf:
#   lmtp    cmd="lmtpd -a" listen="localhost:lmtp" proto=tcp4
#
# Specify in main.cf one or more of the following:
#  mailbox_transport = lmtp:inet:localhost
#  virtual_transport = lmtp:inet:localhost
#
# ====================================================================
#
# Cyrus 2.1.5 (Amos Gouaux)
# Also specify in main.cf: cyrus_destination_recipient_limit=1
#
#cyrus     unix  -       n       n       -       -       pipe
#  user=cyrus argv=/usr/lib/cyrus-imapd/deliver -e -r ${sender} -m ${extension} ${user}
#
# ====================================================================
#
# Old example of delivery via Cyrus.
#
#old-cyrus unix  -       n       n       -       -       pipe
#  flags=R user=cyrus argv=/usr/lib/cyrus-imapd/deliver -e -m ${extension} ${user}
#
# ====================================================================
#
# See the Postfix UUCP_README file for configuration details.
#
#uucp      unix  -       n       n       -       -       pipe
#  flags=Fqhu user=uucp argv=uux -r -n -z -a$sender - $nexthop!rmail ($recipient)
#
# ====================================================================
#
# Other external delivery methods.
#
#ifmail    unix  -       n       n       -       -       pipe
#  flags=F user=ftn argv=/usr/lib/ifmail/ifmail -r $nexthop ($recipient)
#
#bsmtp     unix  -       n       n       -       -       pipe
#  flags=Fq. user=bsmtp argv=/usr/local/sbin/bsmtp -f $sender $nexthop $recipient
#
#scalemail-backend unix -       n       n       -       2       pipe
#  flags=R user=scalemail argv=/usr/lib/scalemail/bin/scalemail-store
#  ${nexthop} ${user} ${extension}
#
#mailman   unix  -       n       n       -       -       pipe
#  flags=FR user=list argv=/usr/lib/mailman/bin/postfix-to-mailman.py
#  ${nexthop} ${user}
spamassassin unix - n n - - pipe flags=R user=spamd argv=/usr/bin/spamc -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}
```

      - Deze bestanden dienen als configuratie van postfix.

    - /etc/postfix/local-host-names
      - In dit bestand zou er maar 1 lijn mogen staan namelijk die met de local hsot name:
        ```
          CORONA2020.local
        ```
        ```
        [vagrant@delta ~]$ cat /etc/postfix/local-host-names
        CORONA2020.local[vagrant@delta ~]$ 
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
      
      ```
      CORONA2020.local[vagrant@delta ~]$ cat /etc/postfix/ldap-aliases.cf
      bind = no    
      version = 3
      timeout = 20
      ## set the size_limit to 1 since we only
      ## want to find one email address match
      size_limit = 1
      expansion_limit = 0
      start_tls = yes
      tls_require_cert = no
      server_host = ldap://alfa.CORONA2020.local
      search_base = dc=alfa,dc=CORONA2020,dc=local
      scope = sub
      query_filter = (mail=%s)
      result_attribute = mgrpDeliverTo
      ```

  2. Voor Dovecot zijn volgende bestanden aangepast:

    - /etc/dovecot/conf.d/10-mail.conf
      - Hierin is het volgende aangepast:
        ```
        mail_location = maildir:~/{{ postfix_home_mailbox }}
        ```

```
        ##
## Mailbox locations and namespaces
##

# Location for users' mailboxes. The default is empty, which means that Dovecot
# tries to find the mailboxes automatically. This won't work if the user
# doesn't yet have any mail, so you should explicitly tell Dovecot the full
# location.
#
# If you're using mbox, giving a path to the INBOX file (eg. /var/mail/%u)
# isn't enough. You'll also need to tell Dovecot where the other mailboxes are
# kept. This is called the "root mail directory", and it must be the first
# path given in the mail_location setting.
#
# There are a few special variables you can use, eg.:
#
#   %u - username
#   %n - user part in user@domain, same as %u if there's no domain
#   %d - domain part in user@domain, empty if there's no domain
#   %h - home directory
#
# See doc/wiki/Variables.txt for full list. Some examples:
#
#   mail_location = maildir:~/Maildir
#   mail_location = mbox:~/mail:INBOX=/var/mail/%u
#   mail_location = mbox:/var/mail/%d/%1n/%n:INDEX=/var/indexes/%d/%1n/%n
#
# <doc/wiki/MailLocation.txt>
#
mail_location = maildir:~/MailDir/

# If you need to set multiple mailbox locations or want to change default
# namespace settings, you can do it by defining namespace sections.
#
# You can have private, shared and public namespaces. Private namespaces
# are for user's personal mails. Shared namespaces are for accessing other
# users' mailboxes that have been shared. Public namespaces are for shared
# mailboxes that are managed by sysadmin. If you create any shared or public
# namespaces you'll typically want to enable ACL plugin also, otherwise all
# users can access all the shared mailboxes, assuming they have permissions
# on filesystem level to do so.
namespace inbox {
  # Namespace type: private, shared or public
  #type = private

  # Hierarchy separator to use. You should use the same separator for all
  # namespaces or some clients get confused. '/' is usually a good one.
  # The default however depends on the underlying mail storage format.
  #separator =

  # Prefix required to access this namespace. This needs to be different for
  # all namespaces. For example "Public/".
  #prefix =

  # Physical location of the mailbox. This is in same format as
  # mail_location, which is also the default for it.
  #location =

  # There can be only one INBOX, and this setting defines which namespace
  # has it.
  inbox = yes

  # If namespace is hidden, it's not advertised to clients via NAMESPACE
  # extension. You'll most likely also want to set list=no. This is mostly
  # useful when converting from another server with different namespaces which
  # you want to deprecate but still keep working. For example you can create
  # hidden namespaces with prefixes "~/mail/", "~%u/mail/" and "mail/".
  #hidden = no

  # Show the mailboxes under this namespace with LIST command. This makes the
  # namespace visible for clients that don't support NAMESPACE extension.
  # "children" value lists child mailboxes, but hides the namespace prefix.
  #list = yes

  # Namespace handles its own subscriptions. If set to "no", the parent
  # namespace handles them (empty prefix should always have this as "yes")
  #subscriptions = yes
}

# Example shared namespace configuration
#namespace {
  #type = shared
  #separator = /

  # Mailboxes are visible under "shared/user@domain/"
  # %%n, %%d and %%u are expanded to the destination user.
  #prefix = shared/%%u/

  # Mail location for other users' mailboxes. Note that %variables and ~/
  # expands to the logged in user's data. %%n, %%d, %%u and %%h expand to the
  # destination user's data.
  #location = maildir:%%h/Maildir:INDEX=~/Maildir/shared/%%u

  # Use the default namespace for saving subscriptions.
  #subscriptions = no

  # List the shared/ namespace only if there are visible shared mailboxes.
  #list = children
#}
# Should shared INBOX be visible as "shared/user" or "shared/user/INBOX"?
#mail_shared_explicit_inbox = no

# System user and group used to access mails. If you use multiple, userdb
# can override these by returning uid or gid fields. You can use either numbers
# or names. <doc/wiki/UserIds.txt>
#mail_uid =
#mail_gid =

# Group to enable temporarily for privileged operations. Currently this is
# used only with INBOX when either its initial creation or dotlocking fails.
# Typically this is set to "mail" to give access to /var/mail.
#mail_privileged_group =

# Grant access to these supplementary groups for mail processes. Typically
# these are used to set up access to shared mailboxes. Note that it may be
# dangerous to set these if users can create symlinks (e.g. if "mail" group is
# set here, ln -s /var/mail ~/mail/var could allow a user to delete others'
# mailboxes, or ln -s /secret/shared/box ~/mail/mybox would allow reading it).
#mail_access_groups =

# Allow full filesystem access to clients. There's no access checks other than
# what the operating system does for the active UID/GID. It works with both
# maildir and mboxes, allowing you to prefix mailboxes names with eg. /path/
# or ~user/.
#mail_full_filesystem_access = no

# Dictionary for key=value mailbox attributes. Currently used by URLAUTH, but
# soon intended to be used by METADATA as well.
#mail_attribute_dict =

##
## Mail processes
##

# Don't use mmap() at all. This is required if you store indexes to shared
# filesystems (NFS or clustered filesystem).
#mmap_disable = no

# Rely on O_EXCL to work when creating dotlock files. NFS supports O_EXCL
# since version 3, so this should be safe to use nowadays by default.
#dotlock_use_excl = yes

# When to use fsync() or fdatasync() calls:
#   optimized (default): Whenever necessary to avoid losing important data
#   always: Useful with e.g. NFS when write()s are delayed
#   never: Never use it (best performance, but crashes can lose data)
#mail_fsync = optimized

# Mail storage exists in NFS. Set this to yes to make Dovecot flush NFS caches
# whenever needed. If you're using only a single mail server this isn't needed.
#mail_nfs_storage = no
# Mail index files also exist in NFS. Setting this to yes requires
# mmap_disable=yes and fsync_disable=no.
#mail_nfs_index = no

# Locking method for index files. Alternatives are fcntl, flock and dotlock.
# Dotlocking uses some tricks which may create more disk I/O than other locking
# methods. NFS users: flock doesn't work, remember to change mmap_disable.
#lock_method = fcntl

# Directory in which LDA/LMTP temporarily stores incoming mails >128 kB.
#mail_temp_dir = /tmp

# Valid UID range for users, defaults to 500 and above. This is mostly
# to make sure that users can't log in as daemons or other system users.
# Note that denying root logins is hardcoded to dovecot binary and can't
# be done even if first_valid_uid is set to 0.
first_valid_uid = 1000
#last_valid_uid = 0

# Valid GID range for users, defaults to non-root/wheel. Users having
# non-valid GID as primary group ID aren't allowed to log in. If user
# belongs to supplementary groups with non-valid GIDs, those groups are
# not set.
#first_valid_gid = 1
#last_valid_gid = 0

# Maximum allowed length for mail keyword name. It's only forced when trying
# to create new keywords.
#mail_max_keyword_length = 50

# ':' separated list of directories under which chrooting is allowed for mail
# processes (ie. /var/mail will allow chrooting to /var/mail/foo/bar too).
# This setting doesn't affect login_chroot, mail_chroot or auth chroot
# settings. If this setting is empty, "/./" in home dirs are ignored.
# WARNING: Never add directories here which local users can modify, that
# may lead to root exploit. Usually this should be done only if you don't
# allow shell access for users. <doc/wiki/Chrooting.txt>
#valid_chroot_dirs =

# Default chroot directory for mail processes. This can be overridden for
# specific users in user database by giving /./ in user's home directory
# (eg. /home/./user chroots into /home). Note that usually there is no real
# need to do chrooting, Dovecot doesn't allow users to access files outside
# their mail directory anyway. If your home directories are prefixed with
# the chroot directory, append "/." to mail_chroot. <doc/wiki/Chrooting.txt>
#mail_chroot =

# UNIX socket path to master authentication server to find users.
# This is used by imap (for shared users) and lda.
#auth_socket_path = /var/run/dovecot/auth-userdb

# Directory where to look up mail plugins.
#mail_plugin_dir = /usr/lib/dovecot

# Space separated list of plugins to load for all services. Plugins specific to
# IMAP, LDA, etc. are added to this list in their own .conf files.
#mail_plugins =

##
## Mailbox handling optimizations
##

# Mailbox list indexes can be used to optimize IMAP STATUS commands. They are
# also required for IMAP NOTIFY extension to be enabled.
#mailbox_list_index = no

# The minimum number of mails in a mailbox before updates are done to cache
# file. This allows optimizing Dovecot's behavior to do less disk writes at
# the cost of more disk reads.
#mail_cache_min_mail_count = 0

# When IDLE command is running, mailbox is checked once in a while to see if
# there are any new mails or other changes. This setting defines the minimum
# time to wait between those checks. Dovecot can also use dnotify, inotify and
# kqueue to find out immediately when changes occur.
#mailbox_idle_check_interval = 30 secs

# Save mails with CR+LF instead of plain LF. This makes sending those mails
# take less CPU, especially with sendfile() syscall with Linux and FreeBSD.
# But it also creates a bit more disk I/O which may just make it slower.
# Also note that if other software reads the mboxes/maildirs, they may handle
# the extra CRs wrong and cause problems.
#mail_save_crlf = no

# Max number of mails to keep open and prefetch to memory. This only works with
# some mailbox formats and/or operating systems.
#mail_prefetch_count = 0

# How often to scan for stale temporary files and delete them (0 = never).
# These should exist only after Dovecot dies in the middle of saving mails.
#mail_temp_scan_interval = 1w

##
## Maildir-specific settings
##

# By default LIST command returns all entries in maildir beginning with a dot.
# Enabling this option makes Dovecot return only entries which are directories.
# This is done by stat()ing each entry, so it causes more disk I/O.
# (For systems setting struct dirent->d_type, this check is free and it's
# done always regardless of this setting)
#maildir_stat_dirs = no

# When copying a message, do it with hard links whenever possible. This makes
# the performance much better, and it's unlikely to have any side effects.
#maildir_copy_with_hardlinks = yes

# Assume Dovecot is the only MUA accessing Maildir: Scan cur/ directory only
# when its mtime changes unexpectedly or when we can't find the mail otherwise.
#maildir_very_dirty_syncs = no

# If enabled, Dovecot doesn't use the S=<size> in the Maildir filenames for
# getting the mail's physical size, except when recalculating Maildir++ quota.
# This can be useful in systems where a lot of the Maildir filenames have a
# broken size. The performance hit for enabling this is very small.
#maildir_broken_filename_sizes = no

##
## mbox-specific settings
##

# Which locking methods to use for locking mbox. There are four available:
#  dotlock: Create <mailbox>.lock file. This is the oldest and most NFS-safe
#           solution. If you want to use /var/mail/ like directory, the users
#           will need write access to that directory.
#  dotlock_try: Same as dotlock, but if it fails because of permissions or
#               because there isn't enough disk space, just skip it.
#  fcntl  : Use this if possible. Works with NFS too if lockd is used.
#  flock  : May not exist in all systems. Doesn't work with NFS.
#  lockf  : May not exist in all systems. Doesn't work with NFS.
#
# You can use multiple locking methods; if you do the order they're declared
# in is important to avoid deadlocks if other MTAs/MUAs are using multiple
# locking methods as well. Some operating systems don't allow using some of
# them simultaneously.
#mbox_read_locks = fcntl
#mbox_write_locks = dotlock fcntl
mbox_write_locks = fcntl

# Maximum time to wait for lock (all of them) before aborting.
#mbox_lock_timeout = 5 mins

# If dotlock exists but the mailbox isn't modified in any way, override the
# lock file after this much time.
#mbox_dotlock_change_timeout = 2 mins

# When mbox changes unexpectedly we have to fully read it to find out what
# changed. If the mbox is large this can take a long time. Since the change
# is usually just a newly appended mail, it'd be faster to simply read the
# new mails. If this setting is enabled, Dovecot does this but still safely
# fallbacks to re-reading the whole mbox file whenever something in mbox isn't
# how it's expected to be. The only real downside to this setting is that if
# some other MUA changes message flags, Dovecot doesn't notice it immediately.
# Note that a full sync is done with SELECT, EXAMINE, EXPUNGE and CHECK
# commands.
#mbox_dirty_syncs = yes

# Like mbox_dirty_syncs, but don't do full syncs even with SELECT, EXAMINE,
# EXPUNGE or CHECK commands. If this is set, mbox_dirty_syncs is ignored.
#mbox_very_dirty_syncs = no

# Delay writing mbox headers until doing a full write sync (EXPUNGE and CHECK
# commands and when closing the mailbox). This is especially useful for POP3
# where clients often delete all mails. The downside is that our changes
# aren't immediately visible to other MUAs.
#mbox_lazy_writes = yes

# If mbox size is smaller than this (e.g. 100k), don't write index files.
# If an index file already exists it's still read, just not updated.
#mbox_min_index_size = 0

# Mail header selection algorithm to use for MD5 POP3 UIDLs when
# pop3_uidl_format=%m. For backwards compatibility we use apop3d inspired
# algorithm, but it fails if the first Received: header isn't unique in all
# mails. An alternative algorithm is "all" that selects all headers.
#mbox_md5 = apop3d

##
## mdbox-specific settings
##

# Maximum dbox file size until it's rotated.
#mdbox_rotate_size = 2M

# Maximum dbox file age until it's rotated. Typically in days. Day begins
# from midnight, so 1d = today, 2d = yesterday, etc. 0 = check disabled.
#mdbox_rotate_interval = 0

# When creating new mdbox files, immediately preallocate their size to
# mdbox_rotate_size. This setting currently works only in Linux with some
# filesystems (ext4, xfs).
#mdbox_preallocate_space = no

##
## Mail attachments
##

# sdbox and mdbox support saving mail attachments to external files, which
# also allows single instance storage for them. Other backends don't support
# this for now.

# Directory root where to store mail attachments. Disabled, if empty.
#mail_attachment_dir =

# Attachments smaller than this aren't saved externally. It's also possible to
# write a plugin to disable saving specific attachments externally.
#mail_attachment_min_size = 128k

# Filesystem backend to use for saving attachments:
#  posix : No SiS done by Dovecot (but this might help FS's own deduplication)
#  sis posix : SiS with immediate byte-by-byte comparison during saving
#  sis-queue posix : SiS with delayed comparison and deduplication
#mail_attachment_fs = sis posix

# Hash format to use in attachment filenames. You can add any text and
# variables: %{md4}, %{md5}, %{sha1}, %{sha256}, %{sha512}, %{size}.
# Variables can be truncated, e.g. %{sha256:80} returns only first 80 bits
#mail_attachment_hash = %{sha1}
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
```
      ##
## Authentication processes
##

# Disable LOGIN command and all other plaintext authentications unless
# SSL/TLS is used (LOGINDISABLED capability). Note that if the remote IP
# matches the local IP (ie. you're connecting from the same computer), the
# connection is considered secure and plaintext authentication is allowed.
# See also ssl=required setting.
#disable_plaintext_auth = yes

# Authentication cache size (e.g. 10M). 0 means it's disabled. Note that
# bsdauth, PAM and vpopmail require cache_key to be set for caching to be used.
#auth_cache_size = 0
# Time to live for cached data. After TTL expires the cached record is no
# longer used, *except* if the main database lookup returns internal failure.
# We also try to handle password changes automatically: If user's previous
# authentication was successful, but this one wasn't, the cache isn't used.
# For now this works only with plaintext authentication.
#auth_cache_ttl = 1 hour
# TTL for negative hits (user not found, password mismatch).
# 0 disables caching them completely.
#auth_cache_negative_ttl = 1 hour

# Space separated list of realms for SASL authentication mechanisms that need
# them. You can leave it empty if you don't want to support multiple realms.
# Many clients simply use the first one listed here, so keep the default realm
# first.
#auth_realms =

# Default realm/domain to use if none was specified. This is used for both
# SASL realms and appending @domain to username in plaintext logins.
#auth_default_realm =

# List of allowed characters in username. If the user-given username contains
# a character not listed in here, the login automatically fails. This is just
# an extra check to make sure user can't exploit any potential quote escaping
# vulnerabilities with SQL/LDAP databases. If you want to allow all characters,
# set this value to empty.
#auth_username_chars = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_@

# Username character translations before it's looked up from databases. The
# value contains series of from -> to characters. For example "#@/@" means
# that '#' and '/' characters are translated to '@'.
#auth_username_translation =

# Username formatting before it's looked up from databases. You can use
# the standard variables here, eg. %Lu would lowercase the username, %n would
# drop away the domain if it was given, or "%n-AT-%d" would change the '@' into
# "-AT-". This translation is done after auth_username_translation changes.
#auth_username_format = %Lu

# If you want to allow master users to log in by specifying the master
# username within the normal username string (ie. not using SASL mechanism's
# support for it), you can specify the separator character here. The format
# is then <username><separator><master username>. UW-IMAP uses "*" as the
# separator, so that could be a good choice.
#auth_master_user_separator =

# Username to use for users logging in with ANONYMOUS SASL mechanism
#auth_anonymous_username = anonymous

# Maximum number of dovecot-auth worker processes. They're used to execute
# blocking passdb and userdb queries (eg. MySQL and PAM). They're
# automatically created and destroyed as needed.
#auth_worker_max_count = 30

# Host name to use in GSSAPI principal names. The default is to use the
# name returned by gethostname(). Use "$ALL" (with quotes) to allow all keytab
# entries.
#auth_gssapi_hostname =

# Kerberos keytab to use for the GSSAPI mechanism. Will use the system
# default (usually /etc/krb5.keytab) if not specified. You may need to change
# the auth service to run as root to be able to read this file.
#auth_krb5_keytab =

# Do NTLM and GSS-SPNEGO authentication using Samba's winbind daemon and
# ntlm_auth helper. <doc/wiki/Authentication/Mechanisms/Winbind.txt>
#auth_use_winbind = no

# Path for Samba's ntlm_auth helper binary.
#auth_winbind_helper_path = /usr/bin/ntlm_auth

# Time to delay before replying to failed authentications.
#auth_failure_delay = 2 secs

# Require a valid SSL client certificate or the authentication fails.
#auth_ssl_require_client_cert = no

# Take the username from client's SSL certificate, using
# X509_NAME_get_text_by_NID() which returns the subject's DN's
# CommonName.
#auth_ssl_username_from_cert = no

# Space separated list of wanted authentication mechanisms:
#   plain login digest-md5 cram-md5 ntlm rpa apop anonymous gssapi otp skey
#   gss-spnego
# NOTE: See also disable_plaintext_auth setting.
auth_mechanisms = plain login

##
## Password and user databases
##

#
# Password database is used to verify user's password (and nothing more).
# You can have multiple passdbs and userdbs. This is useful if you want to
# allow both system users (/etc/passwd) and virtual users to login without
# duplicating the system users into virtual database.
#
# <doc/wiki/PasswordDatabase.txt>
#
# User database specifies where mails are located and what user/group IDs
# own them. For single-UID configuration use "static" userdb.
#
# <doc/wiki/UserDatabase.txt>

#!include auth-deny.conf.ext
#!include auth-master.conf.ext

!include auth-system.conf.ext
#!include auth-sql.conf.ext
#!include auth-ldap.conf.ext
#!include auth-passwdfile.conf.ext
#!include auth-checkpassword.conf.ext
#!include auth-vpopmail.conf.ext
#!include auth-static.conf.ext
 ```
  3. Bij spamassissin is het volgende bestand aangepast:

    - '/etc/mail/spamassassin/local.cf'
      - Hierin zou het volgende moeten staan:
        ```
        report_safe 0 required_score 8.0 rewrite_header Subject [SPAM]
        ```
        ```
        [vagrant@delta ~]$ cat /etc/mail/spamassassin/local.cf
        report_safe 0 required_score 8.0 rewrite_header Subject
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
      ```
      [vagrant@delta ~]$ sudo service sendmail status
      Redirecting to /bin/systemctl status sendmail.service
      Unit sendmail.service could not be found.
      ```
    - sudo service postfix status
      - resultaat: Bij 'state' staat er running.
```
      ● postfix.service - Postfix Mail Transport Agent
   Loaded: loaded (/usr/lib/systemd/system/postfix.service; enabled; vendor preset: disabled)   
   Active: active (running) since Mon 2020-12-14 00:42:58 UTC; 24min ago
  Process: 18798 ExecStop=/usr/sbin/postfix stop (code=exited, status=0/SUCCESS)
  Process: 19367 ExecStart=/usr/sbin/postfix start (code=exited, status=0/SUCCESS)
  Process: 19365 ExecStartPre=/usr/libexec/postfix/chroot-update (code=exited, status=0/SUCCESS)
  Process: 19363 ExecStartPre=/usr/libexec/postfix/aliasesdb (code=exited, status=0/SUCCESS)
 Main PID: 19435 (master)
    Tasks: 3 (limit: 5046)
   Memory: 6.2M
   CGroup: /system.slice/postfix.service
           ├─19435 /usr/libexec/postfix/master -w
           ├─19436 pickup -l -t unix -u
           └─19437 qmgr -l -t unix -u

Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: ldap:/etc/postfix/ldap-aliases.cf: unused parameter: special_result_filter=%s@%d
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: /etc/postfix/main.cf: unused parameter: smtpd_sals_path=private/auth
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: open "ldap" configuration "/etc/postfix/ldap-users.cf": No such file or directory
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: ldap:/etc/postfix/ldap-aliases.cf: unused parameter: special_result_filter=%s@%d
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: /etc/postfix/main.cf: unused parameter: smtpd_sals_path=private/auth
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: open "ldap" configuration "/etc/postfix/ldap-users.cf": No such file or directory
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: ldap:/etc/postfix/ldap-aliases.cf: unused parameter: special_result_filter=%s@%d
Dec 14 00:42:58 delta postfix[19367]: /usr/sbin/postconf: warning: /etc/postfix/main.cf: unused parameter: smtpd_sals_path=private/auth
Dec 14 00:42:58 delta postfix/master[19435]: daemon started -- version 3.3.1, configuration /etc/postfix
Dec 14 00:42:58 delta systemd[1]: Started Postfix Mail Transport Agent.
```
    - sudo service dovecot status
      - resultaat: Bij 'state' staat er running
```
      ● dovecot.service - Dovecot IMAP/POP3 email server
   Loaded: loaded (/usr/lib/systemd/system/dovecot.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-12-14 00:43:00 UTC; 24min ago
     Docs: man:dovecot(1)
           http://wiki2.dovecot.org/
  Process: 19461 ExecStop=/usr/bin/doveadm stop (code=exited, status=0/SUCCESS)
  Process: 19466 ExecStartPre=/usr/libexec/dovecot/prestartscript (code=exited, status=0/SUCCESS)
 Main PID: 19472 (dovecot)
    Tasks: 4 (limit: 5046)
   Memory: 6.2M
   CGroup: /system.slice/dovecot.service
           ├─19472 /usr/sbin/dovecot -F
           ├─19477 dovecot/anvil
           ├─19478 dovecot/log
           └─19479 dovecot/config

Dec 14 00:43:00 delta systemd[1]: Stopped Dovecot IMAP/POP3 email server.
Dec 14 00:43:00 delta systemd[1]: Starting Dovecot IMAP/POP3 email server...
Dec 14 00:43:00 delta systemd[1]: Started Dovecot IMAP/POP3 email server.
Dec 14 00:43:01 delta dovecot[19472]: master: Dovecot v2.3.8 (9df20d2db) starting up for imap, pop3, lmtp
```
    - sudo service spamassassin status
      - resultaat: Bij 'state' staat er running.
```
      ● spamassassin.service - Spamassassin daemon
   Loaded: loaded (/usr/lib/systemd/system/spamassassin.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-12-14 00:39:18 UTC; 29min ago
 Main PID: 13698 (spamd)
    Tasks: 3 (limit: 5046)
   Memory: 84.5M
   CGroup: /system.slice/spamassassin.service
           ├─13698 /usr/bin/perl -T -w /usr/bin/spamd -c -m5 -H --razor-home-dir=/var/lib/razor/ --razor-log-file=sys-syslog
           ├─14744 spamd child                                                                                                                                                                                           >           └─14745 spamd child                                                                                                                                                                                           >
Dec 14 00:39:18 delta systemd[1]: Started Spamassassin daemon.
Dec 14 00:39:21 delta spamd[13698]: config: SpamAssassin failed to parse line, "0 required_score 8.0 rewrite_header Subject [SPAM]" is not valid for "report_safe", skipping: report_safe 0 required_score 8.0 rewrite_he>Dec 14 00:39:23 delta spamd[13698]: spamd: server started on IO::Socket::IP [::1]:783, IO::Socket::IP [127.0.0.1]:783 (running version 3.4.2)
Dec 14 00:39:23 delta spamd[13698]: spamd: server pid: 13698
Dec 14 00:39:23 delta spamd[13698]: spamd: server successfully spawned child process, pid 14744
Dec 14 00:39:23 delta spamd[13698]: spamd: server successfully spawned child process, pid 14745
Dec 14 00:39:23 delta spamd[13698]: prefork: child states: IS
Dec 14 00:39:23 delta spamd[13698]: prefork: child states: II
 ```

## Stap 4: Kijken of we mails kunnen versturen

  1. Log je aan op een host

  2. Ga naar de mailapp en probeer een mail te sturen naar 'naamhost2@CORORNA2020.local'

  3. Log je aan op host2

  4. Ga naar de maildirectory 'mail/' hierin zou de mail terug te vinden moeten zijn.
