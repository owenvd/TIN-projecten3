


# TEST PLAN: WEBSERVER - CHARLIE

| **auteur testplan** | Moreno Robyn |
| ------------------- | -------------- |
| **uitvoerder test** |                |

## Requirements

- Na het gebruiken van de "vagrant up charlie" en eventueel "vagrant up charlie --provision" moet de webserver automatisch geïnstalleerd en correct geconfigureerd zijn.
- Nginx is geïnstalleerd als webserver met ondersteuning voor HTTPS en HTTP
- PostgreSQL is geïnstalleerd 
- Drupal is geïnstalleerd als CMS
- De site is bereikbaar als HTTP en HTTPS
- De site is bereikbaar met of zonder de WWW prefix
## melding
- De dns server bravo moet aangemaakt en ingesteld zijn op u als primary dns server. de dns server moet records WWW hebben voor deze om het correct te kunnen navigeren naar de website mogelijk te maken

## Stap 1: Is de webserver active and running

1. Log in op de webserver charlie.

2. Controlleer of nginx active and running is
   Commando:

   ```
   systemctl status nginx
   ```

   Verwachte resultaat:

   ```
   ● nginx.service - The nginx HTTP and reverse proxy server
	  Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
	  Drop-In: /usr/lib/systemd/system/nginx.service.d
           └─php-fpm.conf
	   Active: active (running) since Thu 2020-11-19 16:52:55 UTC; 2h 54min ago
	  Process: 34260 ExecReload=/bin/kill -s HUP $MAINPID (code=exited, status=0/SUCCESS)
	  Process: 34381 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
	  Process: 34379 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
	  Process: 34378 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, 	status=0/SUCCESS)
	 Main PID: 34383 (nginx)
    Tasks: 2 (limit: 5046)
   Memory: 3.5M
   CGroup: /system.slice/nginx.service
           ├─34383 nginx: master process /usr/sbin/nginx
           └─34384 nginx: worker process
   ```


   Resultaat:

   ```
   
   ```
   3. Controlleer of php 7.4 en zijn packages zijn geïnstalleerd
      Commando:

   ```
   php -i
   ```

   Verwachte resultaat:

   ```

    phpinfo()
    PHP Version => 7.4.12
    
    System => Linux charlie 4.18.0-193.19.1.el8_2.x86_64 #1 SMP Mon Sep 14 14:37:00 UTC 2020 x86_64
    Build Date => Oct 27 2020 15:01:52
    Build System => Red Hat Enterprise Linux release 8.2 (Ootpa)
    Build Provider => Remi's RPM repository <https://rpms.remirepo.net/>
    Server API => Command Line Interface
    Virtual Directory Support => disabled
    Configuration File (php.ini) Path => /etc
    Loaded Configuration File => /etc/php.ini
    Scan this dir for additional .ini files => /etc/php.d
    Additional .ini files parsed => /etc/php.d/10-opcache.ini,
    /etc/php.d/20-bz2.ini,
    /etc/php.d/20-calendar.ini,
    /etc/php.d/20-ctype.ini,
    /etc/php.d/20-curl.ini,
    /etc/php.d/20-dom.ini,
    /etc/php.d/20-exif.ini,
    /etc/php.d/20-fileinfo.ini,
    /etc/php.d/20-ftp.ini,
    /etc/php.d/20-gd.ini,
    /etc/php.d/20-gettext.ini,
    /etc/php.d/20-iconv.ini,
    /etc/php.d/20-imap.ini,
    /etc/php.d/20-json.ini,
    /etc/php.d/20-ldap.ini,
    /etc/php.d/20-mbstring.ini,
    /etc/php.d/20-pdo.ini,
    /etc/php.d/20-pgsql.ini,
    /etc/php.d/20-phar.ini,
    /etc/php.d/20-posix.ini,
    /etc/php.d/20-shmop.ini,
    /etc/php.d/20-simplexml.ini,
    /etc/php.d/20-sockets.ini,
    /etc/php.d/20-sodium.ini,
    /etc/php.d/20-sqlite3.ini,
    /etc/php.d/20-sysvmsg.ini,
    /etc/php.d/20-sysvsem.ini,
    /etc/php.d/20-sysvshm.ini,
    /etc/php.d/20-tokenizer.ini,
    /etc/php.d/20-xml.ini,
    /etc/php.d/20-xmlwriter.ini,
    /etc/php.d/20-xsl.ini,
    /etc/php.d/30-mcrypt.ini,
    /etc/php.d/30-pdo_pgsql.ini,
    /etc/php.d/30-pdo_sqlite.ini,
    /etc/php.d/30-xmlreader.ini,
    /etc/php.d/30-xmlrpc.ini,
    /etc/php.d/40-yaml.ini,
    /etc/php.d/50-apc.ini
    
    PHP API => 20190902
    PHP Extension => 20190902
    Zend Extension => 320190902
    Zend Extension Build => API320190902,NTS
    PHP Extension Build => API20190902,NTS
    Debug Build => no
    Thread Safety => disabled
    Zend Signal Handling => enabled
    Zend Memory Manager => enabled
    Zend Multibyte Support => provided by mbstring
    IPv6 Support => enabled
    DTrace Support => available, disabled
    
    Registered PHP Streams => https, ftps, compress.zlib, php, file, glob, data, http, ftp, compress.bzip2, phar
    Registered Stream Socket Transports => tcp, udp, unix, udg, ssl, tls, tlsv1.0, tlsv1.1, tlsv1.2, tlsv1.3
    Registered Stream Filters => zlib.*, string.rot13, string.toupper, string.tolower, string.strip_tags, convert.*, consumed, dechunk, bzip2.*, convert.iconv.*, mcrypt.*, mdecrypt.*        
    
    This program makes use of the Zend Scripting Language Engine:
    Zend Engine v3.4.0, Copyright (c) Zend Technologies
        with Zend OPcache v7.4.12, Copyright (c), by Zend Technologies
    
    
     _______________________________________________________________________
    
    
    Configuration
    
    apcu
    
    APCu Support => Disabled
    Version => 5.1.19
    APCu Debugging => Disabled
    MMAP Support => Enabled
    MMAP File Mask =>
    Serialization Support => Disabled
    Build Date => Oct  5 2020 11:39:35
    
    Directive => Local Value => Master Value
    apc.coredump_unmap => Off => Off
    apc.enable_cli => Off => Off
    apc.enabled => On => On
    apc.entries_hint => 4096 => 4096
    apc.gc_ttl => 3600 => 3600
    apc.mmap_file_mask => no value => no value
    apc.preload_path => no value => no value
    apc.serializer => php => php
    apc.shm_segments => 1 => 1
    apc.shm_size => 96M => 96M
    apc.slam_defense => Off => Off
    apc.smart => 0 => 0
    apc.ttl => 0 => 0
    apc.use_request_time => Off => Off
    
    bz2
    
    BZip2 Support => Enabled
    Stream Wrapper support => compress.bzip2://
    Stream Filter support => bzip2.decompress, bzip2.compress
    BZip2 Version => 1.0.6, 6-Sept-2010
    
    calendar
    
    Calendar support => enabled
    
    Core
    
    PHP Version => 7.4.12
    
    Directive => Local Value => Master Value
    allow_url_fopen => On => On
    allow_url_include => Off => Off
    arg_separator.input => & => &
    arg_separator.output => & => &
    auto_append_file => no value => no value
    auto_globals_jit => On => On
    auto_prepend_file => no value => no value
    browscap => no value => no value
    default_charset => UTF-8 => UTF-8
    default_mimetype => text/html => text/html
    disable_classes => no value => no value
    disable_functions => no value => no value
    display_errors => Off => Off
    display_startup_errors => Off => Off
    doc_root => no value => no value
    docref_ext => no value => no value
    docref_root => no value => no value
    enable_dl => Off => Off
    enable_post_data_reading => On => On
    error_append_string => no value => no value
    error_log => no value => no value
    error_prepend_string => no value => no value
    error_reporting => 22527 => 22527
    expose_php => On => On
    extension_dir => /usr/lib64/php/modules => /usr/lib64/php/modules
    file_uploads => On => On
    hard_timeout => 2 => 2
    highlight.comment => <font style="color: #FF8000">#FF8000</font> => <font style="color: #FF8000">#FF8000</font>
    highlight.default => <font style="color: #0000BB">#0000BB</font> => <font style="color: #0000BB">#0000BB</font>
    highlight.html => <font style="color: #000000">#000000</font> => <font style="color: #000000">#000000</font>
    highlight.keyword => <font style="color: #007700">#007700</font> => <font style="color: #007700">#007700</font>
    highlight.string => <font style="color: #DD0000">#DD0000</font> => <font style="color: #DD0000">#DD0000</font>
    html_errors => Off => Off
    ignore_repeated_errors => Off => Off
    ignore_repeated_source => Off => Off
    ignore_user_abort => Off => Off
    implicit_flush => On => On
    include_path => .:/usr/share/pear:/usr/share/php => .:/usr/share/pear:/usr/share/php
    input_encoding => no value => no value
    internal_encoding => no value => no value
    log_errors => On => On
    log_errors_max_len => 1024 => 1024
    mail.add_x_header => On => On
    mail.force_extra_parameters => no value => no value
    mail.log => no value => no value
    max_execution_time => 0 => 0
    max_file_uploads => 20 => 20
    max_input_nesting_level => 64 => 64
    max_input_time => -1 => -1
    max_input_vars => 1000 => 1000
    memory_limit => 256M => 256M
    open_basedir => no value => no value
    output_buffering => 0 => 0
    output_encoding => no value => no value
    output_handler => no value => no value
    post_max_size => 32M => 32M
    precision => 14 => 14
    realpath_cache_size => 32K => 32K
    realpath_cache_ttl => 120 => 120
    register_argc_argv => On => On
    report_memleaks => On => On
    report_zend_debug => Off => Off
    request_order => GP => GP
    sendmail_from => no value => no value
    sendmail_path => /usr/sbin/sendmail -t -i => /usr/sbin/sendmail -t -i
    serialize_precision => -1 => -1
    short_open_tag => Off => Off
    SMTP => localhost => localhost
    smtp_port => 25 => 25
    sys_temp_dir => no value => no value
    syslog.facility => LOG_USER => LOG_USER
    syslog.filter => no-ctrl => no-ctrl
    syslog.ident => php => php
    track_errors => Off => Off
    unserialize_callback_func => no value => no value
    upload_max_filesize => 64M => 64M
    upload_tmp_dir => no value => no value
    user_dir => no value => no value
    user_ini.cache_ttl => 300 => 300
    user_ini.filename => .user.ini => .user.ini
    variables_order => GPCS => GPCS
    xmlrpc_error_number => 0 => 0
    xmlrpc_errors => Off => Off
    zend.assertions => 1 => 1
    zend.detect_unicode => On => On
    zend.enable_gc => On => On
    zend.exception_ignore_args => Off => Off
    zend.multibyte => Off => Off
    zend.script_encoding => no value => no value
    zend.signal_check => Off => Off
    
    ctype
    
    ctype functions => enabled
    
    curl
    
    cURL support => enabled
    cURL Information => 7.61.1
    Age => 4
    Features
    AsynchDNS => Yes
    CharConv => No
    Debug => No
    GSS-Negotiate => No
    IDN => Yes
    IPv6 => Yes
    krb4 => No
    Largefile => Yes
    libz => Yes
    NTLM => Yes
    NTLMWB => Yes
    SPNEGO => Yes
    SSL => Yes
    SSPI => No
    TLS-SRP => Yes
    HTTP2 => Yes
    GSSAPI => Yes
    KERBEROS5 => Yes
    UNIX_SOCKETS => Yes
    PSL => Yes
    HTTPS_PROXY => Yes
    MULTI_SSL => No
    BROTLI => Yes
    Protocols => dict, file, ftp, ftps, gopher, http, https, imap, imaps, ldap, ldaps, pop3, pop3s, rtsp, scp, sftp, smb, smbs, smtp, smtps, telnet, tftp
    Host => x86_64-redhat-linux-gnu
    SSL Version => OpenSSL/1.1.1c
    ZLib Version => 1.2.11
    libSSH Version => libssh/0.9.0/openssl/zlib
    
    Directive => Local Value => Master Value
    curl.cainfo => no value => no value
    
    date
    
    date/time support => enabled
    timelib version => 2018.04
    "Olson" Timezone Database Version => 0.system
    Timezone Database => internal
    Default timezone => America/Chicago
    
    Directive => Local Value => Master Value
    date.default_latitude => 31.7667 => 31.7667
    date.default_longitude => 35.2333 => 35.2333
    date.sunrise_zenith => 90.583333 => 90.583333
    date.sunset_zenith => 90.583333 => 90.583333
    date.timezone => America/Chicago => America/Chicago
    
    dom
    
    DOM/XML => enabled
    DOM/XML API Version => 20031129
    libxml Version => 2.9.7
    HTML Support => enabled
    XPath Support => enabled
    XPointer Support => enabled
    Schema Support => enabled
    RelaxNG Support => enabled
    
    exif
    
    EXIF Support => enabled
    Supported EXIF Version => 0220
    Supported filetypes => JPEG, TIFF
    Multibyte decoding support using mbstring => enabled
    Extended EXIF tag formats => Canon, Casio, Fujifilm, Nikon, Olympus, Samsung, Panasonic, DJI, Sony, Pentax, Minolta, Sigma, Foveon, Kyocera, Ricoh, AGFA, Epson
    
    Directive => Local Value => Master Value
    exif.decode_jis_intel => JIS => JIS
    exif.decode_jis_motorola => JIS => JIS
    exif.decode_unicode_intel => UCS-2LE => UCS-2LE
    exif.decode_unicode_motorola => UCS-2BE => UCS-2BE
    exif.encode_jis => no value => no value
    exif.encode_unicode => ISO-8859-15 => ISO-8859-15
    
    fileinfo
    
    fileinfo support => enabled
    libmagic => 537
    
    filter
    
    Input Validation and Filtering => enabled
    
    Directive => Local Value => Master Value
    filter.default => unsafe_raw => unsafe_raw
    filter.default_flags => no value => no value
    
    ftp
    
    FTP support => enabled
    FTPS support => enabled
    
    gd
    
    GD Support => enabled
    GD headers Version => 2.2.5
    GD library Version => 2.2.5
    FreeType Support => enabled
    FreeType Linkage => with freetype
    GIF Read Support => enabled
    GIF Create Support => enabled
    JPEG Support => enabled
    PNG Support => enabled
    WBMP Support => enabled
    XPM Support => enabled
    XBM Support => enabled
    WebP Support => enabled
    BMP Support => enabled
    TGA Read Support => enabled
    
    Directive => Local Value => Master Value
    gd.jpeg_ignore_warning => 1 => 1
    
    gettext
    
    GetText Support => enabled
    
    hash
    
    hash support => enabled
    Hashing Engines => md2 md4 md5 sha1 sha224 sha256 sha384 sha512/224 sha512/256 sha512 sha3-224 sha3-256 sha3-384 sha3-512 ripemd128 ripemd160 ripemd256 ripemd320 whirlpool tiger128,3 tiger160,3 tiger192,3 tiger128,4 tiger160,4 tiger192,4 snefru snefru256 gost gost-crypto adler32 crc32 crc32b crc32c fnv132 fnv1a32 fnv164 fnv1a64 joaat haval128,3 haval160,3 haval192,3 haval224,3 haval256,3 haval128,4 haval160,4 haval192,4 haval224,4 haval256,4 haval128,5 haval160,5 haval192,5 haval224,5 haval256,5
    
    MHASH support => Enabled
    MHASH API Version => Emulated Support
    
    iconv
    
    iconv support => enabled
    iconv implementation => glibc
    iconv library version => 2.28
    
    Directive => Local Value => Master Value
    iconv.input_encoding => no value => no value
    iconv.internal_encoding => no value => no value
    iconv.output_encoding => no value => no value
    
    imap
    
    IMAP c-Client Version => 2007f
    SSL Support => enabled
    Kerberos Support => enabled
    
    Directive => Local Value => Master Value
    imap.enable_insecure_rsh => Off => Off
    
    json
    
    json support => enabled
    
    ldap
    
    LDAP Support => enabled
    Total Links => 0/unlimited
    API Version => 3001
    Vendor Name => OpenLDAP
    Vendor Version => 20446
    SASL Support => Enabled
    
    Directive => Local Value => Master Value
    ldap.max_links => Unlimited => Unlimited
    
    libxml
    
    libXML support => active
    libXML Compiled Version => 2.9.7
    libXML Loaded Version => 20907
    libXML streams => enabled
    
    mbstring
    
    Multibyte Support => enabled
    Multibyte string engine => libmbfl
    HTTP input encoding translation => disabled
    libmbfl version => 1.3.2
    
    mbstring extension makes use of "streamable kanji code filter and converter", which is distributed under the GNU Lesser General Public License version 2.1.
    
    Multibyte (japanese) regex support => enabled
    Multibyte regex (oniguruma) version => 6.9.5
    
    Directive => Local Value => Master Value
    mbstring.detect_order => no value => no value
    mbstring.encoding_translation => Off => Off
    mbstring.func_overload => 0 => 0
    mbstring.http_input => no value => no value
    mbstring.http_output => no value => no value
    mbstring.http_output_conv_mimetypes => ^(text/|application/xhtml\+xml) => ^(text/|application/xhtml\+xml)
    mbstring.internal_encoding => no value => no value
    mbstring.language => neutral => neutral
    mbstring.regex_retry_limit => 1000000 => 1000000
    mbstring.regex_stack_limit => 100000 => 100000
    mbstring.strict_detection => Off => Off
    mbstring.substitute_character => no value => no value
    
    mcrypt
    
    mcrypt support => enabled
    mcrypt_filter support => enabled
    Version => 2.5.8
    Api No => 20021217
    Supported ciphers => cast-128 gost rijndael-128 twofish arcfour cast-256 loki97 rijndael-192 saferplus wake blowfish-compat des rijndael-256 serpent xtea blowfish enigma rc2 tripledes   
    Supported modes => cbc cfb ctr ecb ncfb nofb ofb stream
    
    Directive => Local Value => Master Value
    mcrypt.algorithms_dir => no value => no value
    mcrypt.modes_dir => no value => no value
    
    openssl
    
    OpenSSL support => enabled
    OpenSSL Library Version => OpenSSL 1.1.1c FIPS  28 May 2019
    OpenSSL Header Version => OpenSSL 1.1.1c FIPS  28 May 2019
    Openssl default config => /etc/pki/tls/openssl.cnf
    
    Directive => Local Value => Master Value
    openssl.cafile => no value => no value
    openssl.capath => no value => no value
    
    pcntl
    
    pcntl support => enabled
    
    pcre
    
    PCRE (Perl Compatible Regular Expressions) Support => enabled
    PCRE Library Version => 10.32 2018-09-10
    PCRE Unicode Version => 11.0.0
    PCRE JIT Support => enabled
    PCRE JIT Target => x86 64bit (little endian + unaligned)
    
    Directive => Local Value => Master Value
    pcre.backtrack_limit => 1000000 => 1000000
    pcre.jit => 1 => 1
    pcre.recursion_limit => 100000 => 100000
    
    PDO
    
    PDO support => enabled
    PDO drivers => pgsql, sqlite
    
    pdo_pgsql
    
    PDO Driver for PostgreSQL => enabled
    PostgreSQL(libpq) Version => 12.1
    
    pdo_sqlite
    
    PDO Driver for SQLite 3.x => enabled
    SQLite Library => 3.26.0
    
    pgsql
    
    PostgreSQL Support => enabled
    PostgreSQL(libpq) Version => 12.1
    PostgreSQL(libpq)  => PostgreSQL 12.1 on x86_64-redhat-linux-gnu, compiled by gcc (GCC) 8.3.1 20190507 (Red Hat 8.3.1-4), 64-bit
    Multibyte character support => enabled
    SSL support => enabled
    Active Persistent Links => 0
    Active Links => 0
    
    Directive => Local Value => Master Value
    pgsql.allow_persistent => On => On
    pgsql.auto_reset_persistent => Off => Off
    pgsql.ignore_notice => Off => Off
    pgsql.log_notice => Off => Off
    pgsql.max_links => Unlimited => Unlimited
    pgsql.max_persistent => Unlimited => Unlimited
    
    Phar
    
    Phar: PHP Archive support => enabled
    Phar API version => 1.1.1
    Phar-based phar archives => enabled
    Tar-based phar archives => enabled
    ZIP-based phar archives => enabled
    gzip compression => enabled
    bzip2 compression => enabled
    Native OpenSSL support => enabled
    
    
    Phar based on pear/PHP_Archive, original concept by Davey Shafik.
    Phar fully realized by Gregory Beaver and Marcus Boerger.
    Portions of tar implementation Copyright (c) 2003-2009 Tim Kientzle.
    Directive => Local Value => Master Value
    phar.cache_list => no value => no value
    phar.readonly => On => On
    phar.require_hash => On => On
    
    posix
    
    POSIX support => enabled
    
    readline
    
    Readline Support => enabled
    Readline library => EditLine wrapper
    
    Directive => Local Value => Master Value
    cli.pager => no value => no value
    cli.prompt => \b \>  => \b \>
    
    Reflection
    
    Reflection => enabled
    
    session
    
    Session Support => enabled
    Registered save handlers => files user
    Registered serializer handlers => php_serialize php php_binary
    
    Directive => Local Value => Master Value
    session.auto_start => Off => Off
    session.cache_expire => 180 => 180
    session.cache_limiter => nocache => nocache
    session.cookie_domain => no value => no value
    session.cookie_httponly => no value => no value
    session.cookie_lifetime => 0 => 0
    session.cookie_path => / => /
    session.cookie_samesite => no value => no value
    session.cookie_secure => 0 => 0
    session.gc_divisor => 1000 => 1000
    session.gc_maxlifetime => 1440 => 1440
    session.gc_probability => 1 => 1
    session.lazy_write => On => On
    session.name => PHPSESSID => PHPSESSID
    session.referer_check => no value => no value
    session.save_handler => files => files
    session.save_path => no value => no value
    session.serialize_handler => php => php
    session.sid_bits_per_character => 4 => 4
    session.sid_length => 32 => 32
    session.upload_progress.cleanup => On => On
    session.upload_progress.enabled => On => On
    session.upload_progress.freq => 1% => 1%
    session.upload_progress.min_freq => 1 => 1
    session.upload_progress.name => PHP_SESSION_UPLOAD_PROGRESS => PHP_SESSION_UPLOAD_PROGRESS
    session.upload_progress.prefix => upload_progress_ => upload_progress_
    session.use_cookies => 1 => 1
    session.use_only_cookies => 1 => 1
    session.use_strict_mode => 0 => 0
    session.use_trans_sid => 0 => 0
    
    shmop
    
    shmop support => enabled
    
    SimpleXML
    
    SimpleXML support => enabled
    Schema support => enabled
    
    sockets
    
    Sockets Support => enabled
    
    sodium
    
    sodium support => enabled
    libsodium headers version => 1.0.18
    libsodium library version => 1.0.18
    
    SPL
    
    SPL support => enabled
    Interfaces => OuterIterator, RecursiveIterator, SeekableIterator, SplObserver, SplSubject
    Classes => AppendIterator, ArrayIterator, ArrayObject, BadFunctionCallException, BadMethodCallException, CachingIterator, CallbackFilterIterator, DirectoryIterator, DomainException, EmptyIterator, FilesystemIterator, FilterIterator, GlobIterator, InfiniteIterator, InvalidArgumentException, IteratorIterator, LengthException, LimitIterator, LogicException, MultipleIterator, NoRewindIterator, OutOfBoundsException, OutOfRangeException, OverflowException, ParentIterator, RangeException, RecursiveArrayIterator, RecursiveCachingIterator, RecursiveCallbackFilterIterator, RecursiveDirectoryIterator, RecursiveFilterIterator, RecursiveIteratorIterator, RecursiveRegexIterator, RecursiveTreeIterator, RegexIterator, RuntimeException, SplDoublyLinkedList, SplFileInfo, SplFileObject, SplFixedArray, SplHeap, SplMinHeap, SplMaxHeap, SplObjectStorage, SplPriorityQueue, SplQueue, SplStack, SplTempFileObject, UnderflowException, UnexpectedValueException
    
    sqlite3
    
    SQLite3 support => enabled
    SQLite Library => 3.26.0
    
    Directive => Local Value => Master Value
    sqlite3.defensive => 1 => 1
    sqlite3.extension_dir => no value => no value
    
    standard
    
    Dynamic Library Support => enabled
    Path to sendmail => /usr/sbin/sendmail -t -i
    
    Directive => Local Value => Master Value
    assert.active => 1 => 1
    assert.bail => 0 => 0
    assert.callback => no value => no value
    assert.exception => 0 => 0
    assert.quiet_eval => 0 => 0
    assert.warning => 1 => 1
    auto_detect_line_endings => 0 => 0
    default_socket_timeout => 60 => 60
    from => no value => no value
    session.trans_sid_hosts => no value => no value
    session.trans_sid_tags => a=href,area=href,frame=src,form= => a=href,area=href,frame=src,form=
    unserialize_max_depth => 4096 => 4096
    url_rewriter.hosts => no value => no value
    url_rewriter.tags => a=href,area=href,frame=src,input=src,form=fakeentry => a=href,area=href,frame=src,input=src,form=fakeentry
    user_agent => no value => no value
    
    sysvmsg
    
    sysvmsg support => enabled
    
    sysvsem
    
    sysvsem support => enabled
    
    sysvshm
    
    sysvshm support => enabled
    
    tokenizer
    
    Tokenizer Support => enabled
    
    xml
    
    XML Support => active
    XML Namespace Support => active
    libxml2 Version => 2.9.7
    
    xmlreader
    
    XMLReader => enabled
    
    xmlrpc
    
    core library version => xmlrpc-epi v. 0.51
    author => Dan Libby
    homepage => http://xmlrpc-epi.sourceforge.net
    open sourced by => Epinions.com
    
    xmlwriter
    
    XMLWriter => enabled
    
    xsl
    
    XSL => enabled
    libxslt Version => 1.1.32
    libxslt compiled against libxml Version => 2.9.7
    EXSLT => enabled
    libexslt Version => 1.1.32
    
    yaml
    
    LibYAML Support => enabled
    Module Version => 2.1.0
    LibYAML Version => 0.1.7
    
    Directive => Local Value => Master Value
    yaml.decode_binary => 0 => 0
    yaml.decode_php => 0 => 0
    yaml.decode_timestamp => 0 => 0
    yaml.output_canonical => 0 => 0
    yaml.output_indent => 2 => 2
    yaml.output_width => 80 => 80
    
    Zend OPcache
    
    Opcode Caching => Disabled
    Optimization => Disabled
    SHM Cache => Enabled
    File Cache => Disabled
    Startup Failed => Opcode Caching is disabled for CLI
    
    Directive => Local Value => Master Value
    opcache.blacklist_filename => no value => no value
    opcache.consistency_checks => 0 => 0
    opcache.dups_fix => Off => Off
    opcache.enable => On => On
    opcache.enable_cli => Off => Off
    opcache.enable_file_override => Off => Off
    opcache.error_log => no value => no value
    opcache.file_cache => no value => no value
    opcache.file_cache_consistency_checks => On => On
    opcache.file_cache_only => Off => Off
    opcache.file_update_protection => 2 => 2
    opcache.force_restart_timeout => 180 => 180
    opcache.huge_code_pages => Off => Off
    opcache.interned_strings_buffer => 16 => 16
    opcache.lockfile_path => /tmp => /tmp
    opcache.log_verbosity_level => 1 => 1
    opcache.max_accelerated_files => 4096 => 4096
    opcache.max_file_size => 0 => 0
    opcache.max_wasted_percentage => 5 => 5
    opcache.memory_consumption => 96 => 96
    opcache.opt_debug_level => 0 => 0
    opcache.optimization_level => 0x7FFEBFFF => 0x7FFEBFFF
    opcache.preferred_memory_model => no value => no value
    opcache.preload => no value => no value
    opcache.preload_user => no value => no value
    opcache.protect_memory => Off => Off
    opcache.restrict_api => no value => no value
    opcache.revalidate_freq => 2 => 2
    opcache.revalidate_path => Off => Off
    opcache.save_comments => On => On
    opcache.use_cwd => On => On
    opcache.validate_permission => Off => Off
    opcache.validate_root => Off => Off
    opcache.validate_timestamps => On => On
    
    zlib
    
    ZLib Support => enabled
    Stream Wrapper => compress.zlib://
    Stream Filter => zlib.inflate, zlib.deflate
    Compiled Version => 1.2.11
    Linked Version => 1.2.11
    
    Directive => Local Value => Master Value
    zlib.output_compression => Off => Off
    zlib.output_compression_level => -1 => -1
    zlib.output_handler => no value => no value
    
    Additional Modules
    
    Module Name
    
    Environment
    
    Variable => Value
    LS_COLORS => rs=0:di=38;5;33:ln=38;5;51:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=01;05;37;41:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;40:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.zst=38;5;9:*.tzst=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.wim=38;5;9:*.swm=38;5;9:*.dwm=38;5;9:*.esd=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.mjpg=38;5;13:*.mjpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.m4a=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.oga=38;5;45:*.opus=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:
    LC_MEASUREMENT => de_BE.UTF-8
    SSH_CONNECTION => 10.0.2.2 57308 10.0.2.15 22
    LC_PAPER => de_BE.UTF-8
    LC_MONETARY => de_BE.UTF-8
    LANG => en_US.UTF-8
    TZ => :/etc/localtime
    HISTCONTROL => ignoredups
    HOSTNAME => charlie
    LC_NAME => de_BE.UTF-8
    XDG_SESSION_ID => 9
    USER => vagrant
    SELINUX_ROLE_REQUESTED =>
    PWD => /home/vagrant
    HOME => /home/vagrant
    SSH_CLIENT => 10.0.2.2 57308 22
    SELINUX_LEVEL_REQUESTED =>
    PGDATA => /var/lib/pgsql/data
    LC_ADDRESS => de_BE.UTF-8
    LC_NUMERIC => de_BE.UTF-8
    SSH_TTY => /dev/pts/0
    MAIL => /var/spool/mail/vagrant
    TERM => xterm-256color
    SHELL => /bin/bash
    SELINUX_USE_CURRENT_RANGE =>
    SHLVL => 1
    LC_TELEPHONE => de_BE.UTF-8
    LOGNAME => vagrant
    DBUS_SESSION_BUS_ADDRESS => unix:path=/run/user/1000/bus
    XDG_RUNTIME_DIR => /run/user/1000
    PATH => /home/vagrant/.local/bin:/home/vagrant/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/bin
    LC_IDENTIFICATION => de_BE.UTF-8
    HISTSIZE => 1000
    LESSOPEN => ||/usr/bin/lesspipe.sh %s
    LC_TIME => de_BE.UTF-8
    _ => /usr/bin/php
    
    PHP Variables
    
    Variable => Value
    $_SERVER['LS_COLORS'] => rs=0:di=38;5;33:ln=38;5;51:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=01;05;37;41:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;40:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.zst=38;5;9:*.tzst=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.wim=38;5;9:*.swm=38;5;9:*.dwm=38;5;9:*.esd=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.mjpg=38;5;13:*.mjpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.m4a=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.oga=38;5;45:*.opus=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:
    $_SERVER['LC_MEASUREMENT'] => de_BE.UTF-8
    $_SERVER['SSH_CONNECTION'] => 10.0.2.2 57308 10.0.2.15 22
    $_SERVER['LC_PAPER'] => de_BE.UTF-8
    $_SERVER['LC_MONETARY'] => de_BE.UTF-8
    $_SERVER['LANG'] => en_US.UTF-8
    $_SERVER['TZ'] => :/etc/localtime
    $_SERVER['HISTCONTROL'] => ignoredups
    $_SERVER['HOSTNAME'] => charlie
    $_SERVER['LC_NAME'] => de_BE.UTF-8
    $_SERVER['XDG_SESSION_ID'] => 9
    $_SERVER['USER'] => vagrant
    $_SERVER['SELINUX_ROLE_REQUESTED'] =>
    $_SERVER['PWD'] => /home/vagrant
    $_SERVER['HOME'] => /home/vagrant
    $_SERVER['SSH_CLIENT'] => 10.0.2.2 57308 22
    $_SERVER['SELINUX_LEVEL_REQUESTED'] =>
    $_SERVER['PGDATA'] => /var/lib/pgsql/data
    $_SERVER['LC_ADDRESS'] => de_BE.UTF-8
    $_SERVER['LC_NUMERIC'] => de_BE.UTF-8
    $_SERVER['SSH_TTY'] => /dev/pts/0
    $_SERVER['MAIL'] => /var/spool/mail/vagrant
    $_SERVER['TERM'] => xterm-256color
    $_SERVER['SHELL'] => /bin/bash
    $_SERVER['SELINUX_USE_CURRENT_RANGE'] =>
    $_SERVER['SHLVL'] => 1
    $_SERVER['LC_TELEPHONE'] => de_BE.UTF-8
    $_SERVER['LOGNAME'] => vagrant
    $_SERVER['DBUS_SESSION_BUS_ADDRESS'] => unix:path=/run/user/1000/bus
    $_SERVER['XDG_RUNTIME_DIR'] => /run/user/1000
    $_SERVER['PATH'] => /home/vagrant/.local/bin:/home/vagrant/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/bin
    $_SERVER['LC_IDENTIFICATION'] => de_BE.UTF-8
    $_SERVER['HISTSIZE'] => 1000
    $_SERVER['LESSOPEN'] => ||/usr/bin/lesspipe.sh %s
    $_SERVER['LC_TIME'] => de_BE.UTF-8
    $_SERVER['_'] => /usr/bin/php
    $_SERVER['PHP_SELF'] =>
    $_SERVER['SCRIPT_NAME'] =>
    $_SERVER['SCRIPT_FILENAME'] =>
    $_SERVER['PATH_TRANSLATED'] =>
    $_SERVER['DOCUMENT_ROOT'] =>
    $_SERVER['REQUEST_TIME_FLOAT'] => 1605462662.9173
    $_SERVER['REQUEST_TIME'] => 1605462662
    $_SERVER['argv'] => Array
    (
    )
    
    $_SERVER['argc'] => 0
    
    PHP License
    This program is free software; you can redistribute it and/or modify
    it under the terms of the PHP License as published by the PHP Group
    and included in the distribution in the file:  LICENSE
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    
    If you did not receive a copy of the PHP license, or have any
    questions about PHP licensing, please contact license@php.net.

   ```


   Resultaat:

   ```
   
   ```
   4. Controlleer of PostgreSQL active and running is
      Commando:

   ```
   systemctl status postgresql
   ```

   Verwachte resultaat:
   *Kijk hier vooral of de service online, afwijkingen vooral op nummers is mogelijk door de status van u systeem*

   ```bash
   ● postgresql.service - PostgreSQL database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-11-29 00:56:32 UTC; 1min 2s ago
   Process: 753 ExecStartPre=/usr/libexec/postgresql-check-db-dir postgresql (code=exited, status=0/SUCCESS)
   Main PID: 784 (postmaster)
    Tasks: 8 (limit: 5046)
   Memory: 26.6M
   CGroup: /system.slice/postgresql.service
           ├─784 /usr/bin/postmaster -D /var/lib/pgsql/data
           ├─843 postgres: logger process
           ├─857 postgres: checkpointer process
           ├─858 postgres: writer process
           ├─859 postgres: wal writer process
           ├─860 postgres: autovacuum launcher process
           ├─861 postgres: stats collector process
           └─862 postgres: bgworker: logical replication launcher
   ```


   Resultaat:

   ```
   
   ```
   5. Controlleer of php-fpm active and running is
      Commando:

   ```
   systemctl status php-fpm
   ```

   Verwachte resultaat:

   ```
   php-fpm.service - The PHP FastCGI Process Manager
   Loaded: loaded (/usr/lib/systemd/system/php-fpm.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-11-15 15:51:44 UTC; 1h 57min ago
   Main PID: 27986 (php-fpm)
   Status: "Processes active: 0, idle: 5, Requests: 0, slow: 0, Traffic: 0req/sec"
    Tasks: 6 (limit: 5046)
   Memory: 32.2M
   CGroup: /system.slice/php-fpm.service
           ├─27986 php-fpm: master process (/etc/php-fpm.conf)
           ├─27988 php-fpm: pool www
           ├─27989 php-fpm: pool www
           ├─27990 php-fpm: pool www
           ├─27991 php-fpm: pool www
           └─27992 php-fpm: pool www
   
   ```


   Resultaat:

   ```
   
   ```
   6. Controlleer of Drupal is geïnstalleerd is
      Commando's:

   ```
	ls -al /var/www/html/drupal
   ```

                 total 340
        drwxrwxr-x.  4 nginx nginx    116 Nov 19 16:49 .
    	drwxr-xr-x.  4 root  root      36 Nov 19 16:52 ..
    	-rw-rw-r--.  1 nginx nginx    357 Nov 19 16:49 .editorconfig
        -rw-rw-r--.  1 nginx nginx   3858 Nov 19 16:49 .gitattributes
        -rw-rw-r--.  1 nginx nginx   2910 Nov 19 16:50 composer.json
        -rw-rw-r--.  1 nginx nginx 327598 Nov 19 16:50 composer.lock
        drwxrwxr-x. 48 nginx nginx   4096 Nov 19 16:51 vendor
        drwxrwxr-x.  7 nginx nginx   4096 Nov 19 16:49 web
      ```
   ls -al /var/www/html/drupal/web
   ```

   ```

    total 72
    drwxrwxr-x.  7 nginx nginx 4096 Nov 19 16:49 .
    drwxrwxr-x.  4 nginx nginx  116 Nov 19 16:49 ..
    -rw-rw-r--.  1 nginx nginx 1025 Nov 19 16:49 .csslintrc
    -rw-rw-r--.  1 nginx nginx  151 Nov 19 16:49 .eslintignore
    -rw-rw-r--.  1 nginx nginx   41 Nov 19 16:49 .eslintrc.json
    -rw-rw-r--.  1 nginx nginx 2314 Nov 19 16:49 .ht.router.php
    -rw-rw-r--.  1 nginx nginx 7572 Nov 19 16:49 .htaccess
    -rw-rw-r--.  1 nginx nginx   94 Nov 19 16:49 INSTALL.txt
    -rw-rw-r--.  1 nginx nginx 5971 Nov 19 16:49 README.txt
    -rw-rw-r--.  1 nginx nginx  315 Nov 19 16:51 autoload.php
    drwxrwxr-x. 13 nginx nginx 4096 Nov 19 16:49 core
    -rw-rw-r--.  1 nginx nginx 1507 Nov 19 16:49 example.gitignore
    -rw-rw-r--.  1 nginx nginx  549 Nov 19 16:49 index.php
    drwxrwxr-x.  2 nginx nginx   24 Nov 19 16:49 modules
    drwxrwxr-x.  2 nginx nginx   24 Nov 19 16:49 profiles
    -rw-rw-r--.  1 nginx nginx 1586 Nov 19 16:49 robots.txt
    drwxrwxr-x.  3 nginx nginx  130 Nov 19 16:49 sites
    drwxrwxr-x.  2 nginx nginx   24 Nov 19 16:49 themes
    -rw-rw-r--.  1 nginx nginx  804 Nov 19 16:49 update.php
    -rw-rw-r--.  1 nginx nginx 4566 Nov 19 16:49 web.config

   ```
   Resultaat
   ```
    ```

   


## Stap 2: configuratie bestanden controleren

1. Log in op de webserver charlie.

2. Controlleer de php-fpm configuratie

   Commando:

   ```
   sudo cat /etc/php-fpm.d/www.conf
   ```

   Verwachte resultaat:

   ```

    ; Start a new pool named 'www'.
    ; the variable $pool can be used in any directive and will be replaced by the
    ; pool name ('www' here)
    [www]
    
    ; Per pool prefix
    ; It only applies on the following directives:
    ; - 'access.log'
    ; - 'slowlog'
    ; - 'listen' (unixsocket)
    ; - 'chroot'
    ; - 'chdir'
    ; - 'php_values'
    ; - 'php_admin_values'
    ; When not set, the global prefix (or @php_fpm_prefix@) applies instead.
    ; Note: This directive can also be relative to the global prefix.
    ; Default Value: none
    ;prefix = /path/to/pools/$pool
    
    ; Unix user/group of processes
    ; Note: The user is mandatory. If the group is not set, the default user's group
    ;       will be used.
    ; RPM: apache user chosen to provide access to the same directories as httpd
    user = nginx
    ; RPM: Keep a group allowed to write in log dir.
    group = nginx
    
    ; The address on which to accept FastCGI requests.
    ; Valid syntaxes are:
    ;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific IPv4 address on
    ;                            a specific port;
    ;   '[ip:6:addr:ess]:port' - to listen on a TCP socket to a specific IPv6 address on
    ;                            a specific port;
    ;   'port'                 - to listen on a TCP socket to all addresses
    ;                            (IPv6 and IPv4-mapped) on a specific port;
    ;   '/path/to/unix/socket' - to listen on a unix socket.
    ; Note: This value is mandatory.
    listen = 127.0.0.1:9000
    
    ; Set listen(2) backlog.
    ; Default Value: 511
    ;listen.backlog = 511
    
    ; Set permissions for unix socket, if one is used. In Linux, read/write
    ; permissions must be set in order to allow connections from a web server.
    ; Default Values: user and group are set as the running user
    ;                 mode is set to 0660
    ;listen.owner = nobody
    ;listen.group = nobody
    ;listen.mode = 0660
    
    ; When POSIX Access Control Lists are supported you can set them using
    ; these options, value is a comma separated list of user/group names.
    ; When set, listen.owner and listen.group are ignored
    listen.acl_users = apache,nginx
    ;listen.acl_groups =
    
    ; List of addresses (IPv4/IPv6) of FastCGI clients which are allowed to connect.
    ; Equivalent to the FCGI_WEB_SERVER_ADDRS environment variable in the original
    ; PHP FCGI (5.2.2+). Makes sense only with a tcp listening socket. Each address
    ; must be separated by a comma. If this value is left blank, connections will be
    ; accepted from any ip address.
    ; Default Value: any
    listen.allowed_clients = 127.0.0.1
    
    ; Specify the nice(2) priority to apply to the pool processes (only if set)
    ; The value can vary from -19 (highest priority) to 20 (lower priority)
    ; Note: - It will only work if the FPM master process is launched as root
    ;       - The pool processes will inherit the master process priority
    ;         unless it specified otherwise
    ; Default Value: no set
    ; process.priority = -19
    
    ; Set the process dumpable flag (PR_SET_DUMPABLE prctl) even if the process user
    ; or group is differrent than the master process user. It allows to create process
    ; core dump and ptrace the process for the pool user.
    ; Default Value: no
    ; process.dumpable = yes
    
    ; Choose how the process manager will control the number of child processes.
    ; Possible Values:
    ;   static  - a fixed number (pm.max_children) of child processes;
    ;   dynamic - the number of child processes are set dynamically based on the
    ;             following directives. With this process management, there will be
    ;             always at least 1 children.
    ;             pm.max_children      - the maximum number of children that can
    ;                                    be alive at the same time.
    ;             pm.start_servers     - the number of children created on startup.
    ;             pm.min_spare_servers - the minimum number of children in 'idle'
    ;                                    state (waiting to process). If the number
    ;                                    of 'idle' processes is less than this
    ;                                    number then some children will be created.
    ;             pm.max_spare_servers - the maximum number of children in 'idle'
    ;                                    state (waiting to process). If the number
    ;                                    of 'idle' processes is greater than this
    ;                                    number then some children will be killed.
    ;  ondemand - no children are created at startup. Children will be forked when
    ;             new requests will connect. The following parameter are used:
    ;             pm.max_children           - the maximum number of children that
    ;                                         can be alive at the same time.
    ;             pm.process_idle_timeout   - The number of seconds after which
    ;                                         an idle process will be killed.
    ; Note: This value is mandatory.
    pm = dynamic
    
    ; The number of child processes to be created when pm is set to 'static' and the
    ; maximum number of child processes when pm is set to 'dynamic' or 'ondemand'.
    ; This value sets the limit on the number of simultaneous requests that will be
    ; served. Equivalent to the ApacheMaxClients directive with mpm_prefork.
    ; Equivalent to the PHP_FCGI_CHILDREN environment variable in the original PHP
    ; CGI. The below defaults are based on a server without much resources. Don't
    ; forget to tweak pm.* to fit your needs.
    ; Note: Used when pm is set to 'static', 'dynamic' or 'ondemand'
    ; Note: This value is mandatory.
    pm.max_children = 50
    
    ; The number of child processes created on startup.
    ; Note: Used only when pm is set to 'dynamic'
    ; Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2
    pm.start_servers = 5
    
    ; The desired minimum number of idle server processes.
    ; Note: Used only when pm is set to 'dynamic'
    ; Note: Mandatory when pm is set to 'dynamic'
    pm.min_spare_servers = 5
    
    ; The desired maximum number of idle server processes.
    ; Note: Used only when pm is set to 'dynamic'
    ; Note: Mandatory when pm is set to 'dynamic'
    pm.max_spare_servers = 5
    
    ; The number of seconds after which an idle process will be killed.
    ; Note: Used only when pm is set to 'ondemand'
    ; Default Value: 10s
    ;pm.process_idle_timeout = 10s;
    
    ; The number of requests each child process should execute before respawning.
    ; This can be useful to work around memory leaks in 3rd party libraries. For
    ; endless request processing specify '0'. Equivalent to PHP_FCGI_MAX_REQUESTS.
    ; Default Value: 0
    ;pm.max_requests = 500
    
    ; The URI to view the FPM status page. If this value is not set, no URI will be
    ; recognized as a status page. It shows the following informations:
    ;   pool                 - the name of the pool;
    ;   process manager      - static, dynamic or ondemand;
    ;   start time           - the date and time FPM has started;
    ;   start since          - number of seconds since FPM has started;
    ;   accepted conn        - the number of request accepted by the pool;
    ;   listen queue         - the number of request in the queue of pending
    ;                          connections (see backlog in listen(2));
    ;   max listen queue     - the maximum number of requests in the queue
    ;                          of pending connections since FPM has started;
    ;   listen queue len     - the size of the socket queue of pending connections;
    ;   idle processes       - the number of idle processes;
    ;   active processes     - the number of active processes;
    ;   total processes      - the number of idle + active processes;
    ;   max active processes - the maximum number of active processes since FPM
    ;                          has started;
    ;   max children reached - number of times, the process limit has been reached,
    ;                          when pm tries to start more children (works only for
    ;                          pm 'dynamic' and 'ondemand');
    ; Value are updated in real time.
    ; Example output:
    ;   pool:                 www
    ;   process manager:      static
    ;   start time:           01/Jul/2011:17:53:49 +0200
    ;   start since:          62636
    ;   accepted conn:        190460
    ;   listen queue:         0
    ;   max listen queue:     1
    ;   listen queue len:     42
    ;   idle processes:       4
    ;   active processes:     11
    ;   total processes:      15
    ;   max active processes: 12
    ;   max children reached: 0
    ;
    ; By default the status page output is formatted as text/plain. Passing either
    ; 'html', 'xml' or 'json' in the query string will return the corresponding
    ; output syntax. Example:
    ;   http://www.foo.bar/status
    ;   http://www.foo.bar/status?json
    ;   http://www.foo.bar/status?html
    ;   http://www.foo.bar/status?xml
    ;
    ; By default the status page only outputs short status. Passing 'full' in the
    ; query string will also return status for each pool process.
    ; Example:
    ;   http://www.foo.bar/status?full
    ;   http://www.foo.bar/status?json&full
    ;   http://www.foo.bar/status?html&full
    ;   http://www.foo.bar/status?xml&full
    ; The Full status returns for each process:
    ;   pid                  - the PID of the process;
    ;   state                - the state of the process (Idle, Running, ...);
    ;   start time           - the date and time the process has started;
    ;   start since          - the number of seconds since the process has started;
    ;   requests             - the number of requests the process has served;
    ;   request duration     - the duration in µs of the requests;
    ;   request method       - the request method (GET, POST, ...);
    ;   request URI          - the request URI with the query string;
    ;   content length       - the content length of the request (only with POST);
    ;   user                 - the user (PHP_AUTH_USER) (or '-' if not set);
    ;   script               - the main script called (or '-' if not set);
    ;   last request cpu     - the %cpu the last request consumed
    ;                          it's always 0 if the process is not in Idle state
    ;                          because CPU calculation is done when the request
    ;                          processing has terminated;
    ;   last request memory  - the max amount of memory the last request consumed
    ;                          it's always 0 if the process is not in Idle state
    ;                          because memory calculation is done when the request
    ;                          processing has terminated;
    ; If the process is in Idle state, then informations are related to the
    ; last request the process has served. Otherwise informations are related to
    ; the current request being served.
    ; Example output:
    ;   ************************
    ;   pid:                  31330
    ;   state:                Running
    ;   start time:           01/Jul/2011:17:53:49 +0200
    ;   start since:          63087
    ;   requests:             12808
    ;   request duration:     1250261
    ;   request method:       GET
    ;   request URI:          /test_mem.php?N=10000
    ;   content length:       0
    ;   user:                 -
    ;   script:               /home/fat/web/docs/php/test_mem.php
    ;   last request cpu:     0.00
    ;   last request memory:  0
    ;
    ; Note: There is a real-time FPM status monitoring sample web page available
    ;       It's available in: @EXPANDED_DATADIR@/fpm/status.html
    ;
    ; Note: The value must start with a leading slash (/). The value can be
    ;       anything, but it may not be a good idea to use the .php extension or it
    ;       may conflict with a real PHP file.
    ; Default Value: not set
    ;pm.status_path = /status
    
    ; The ping URI to call the monitoring page of FPM. If this value is not set, no
    ; URI will be recognized as a ping page. This could be used to test from outside
    ; that FPM is alive and responding, or to
    ; - create a graph of FPM availability (rrd or such);
    ; - remove a server from a group if it is not responding (load balancing);
    ; - trigger alerts for the operating team (24/7).
    ; Note: The value must start with a leading slash (/). The value can be
    ;       anything, but it may not be a good idea to use the .php extension or it
    ;       may conflict with a real PHP file.
    ; Default Value: not set
    ;ping.path = /ping
    
    ; This directive may be used to customize the response of a ping request. The
    ; response is formatted as text/plain with a 200 response code.
    ; Default Value: pong
    ;ping.response = pong
    
    ; The access log file
    ; Default: not set
    ;access.log = log/$pool.access.log
    
    ; The access log format.
    ; The following syntax is allowed
    ;  %%: the '%' character
    ;  %C: %CPU used by the request
    ;      it can accept the following format:
    ;      - %{user}C for user CPU only
    ;      - %{system}C for system CPU only
    ;      - %{total}C  for user + system CPU (default)
    ;  %d: time taken to serve the request
    ;      it can accept the following format:
    ;      - %{seconds}d (default)
    ;      - %{miliseconds}d
    ;      - %{mili}d
    ;      - %{microseconds}d
    ;      - %{micro}d
    ;  %e: an environment variable (same as $_ENV or $_SERVER)
    ;      it must be associated with embraces to specify the name of the env
    ;      variable. Some exemples:
    ;      - server specifics like: %{REQUEST_METHOD}e or %{SERVER_PROTOCOL}e
    ;      - HTTP headers like: %{HTTP_HOST}e or %{HTTP_USER_AGENT}e
    ;  %f: script filename
    ;  %l: content-length of the request (for POST request only)
    ;  %m: request method
    ;  %M: peak of memory allocated by PHP
    ;      it can accept the following format:
    ;      - %{bytes}M (default)
    ;      - %{kilobytes}M
    ;      - %{kilo}M
    ;      - %{megabytes}M
    ;      - %{mega}M
    ;  %n: pool name
    ;  %o: output header
    ;      it must be associated with embraces to specify the name of the header:
    ;      - %{Content-Type}o
    ;      - %{X-Powered-By}o
    ;      - %{Transfert-Encoding}o
    ;      - ....
    ;  %p: PID of the child that serviced the request
    ;  %P: PID of the parent of the child that serviced the request
    ;  %q: the query string
    ;  %Q: the '?' character if query string exists
    ;  %r: the request URI (without the query string, see %q and %Q)
    ;  %R: remote IP address
    ;  %s: status (response code)
    ;  %t: server time the request was received
    ;      it can accept a strftime(3) format:
    ;      %d/%b/%Y:%H:%M:%S %z (default)
    ;      The strftime(3) format must be encapsuled in a %{<strftime_format>}t tag
    ;      e.g. for a ISO8601 formatted timestring, use: %{%Y-%m-%dT%H:%M:%S%z}t
    ;  %T: time the log has been written (the request has finished)
    ;      it can accept a strftime(3) format:
    ;      %d/%b/%Y:%H:%M:%S %z (default)
    ;      The strftime(3) format must be encapsuled in a %{<strftime_format>}t tag
    ;      e.g. for a ISO8601 formatted timestring, use: %{%Y-%m-%dT%H:%M:%S%z}t
    ;  %u: remote user
    ;
    ; Default: "%R - %u %t \"%m %r\" %s"
    ;access.format = "%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"
    
    ; The log file for slow requests
    ; Default Value: not set
    ; Note: slowlog is mandatory if request_slowlog_timeout is set
    slowlog = /var/log/php-fpm/www-slow.log
    
    ; The timeout for serving a single request after which a PHP backtrace will be
    ; dumped to the 'slowlog' file. A value of '0s' means 'off'.
    ; Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
    ; Default Value: 0
    ;request_slowlog_timeout = 0
    
    ; Depth of slow log stack trace.
    ; Default Value: 20
    ;request_slowlog_trace_depth = 20
    
    ; The timeout for serving a single request after which the worker process will
    ; be killed. This option should be used when the 'max_execution_time' ini option
    ; does not stop script execution for some reason. A value of '0' means 'off'.
    ; Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
    ; Default Value: 0
    ;request_terminate_timeout = 0
    
    ; Set open file descriptor rlimit.
    ; Default Value: system defined value
    ;rlimit_files = 1024
    
    ; Set max core size rlimit.
    ; Possible Values: 'unlimited' or an integer greater or equal to 0
    ; Default Value: system defined value
    ;rlimit_core = 0
    
    ; Chroot to this directory at the start. This value must be defined as an
    ; absolute path. When this value is not set, chroot is not used.
    ; Note: you can prefix with '$prefix' to chroot to the pool prefix or one
    ; of its subdirectories. If the pool prefix is not set, the global prefix
    ; will be used instead.
    ; Note: chrooting is a great security feature and should be used whenever
    ;       possible. However, all PHP paths will be relative to the chroot
    ;       (error_log, sessions.save_path, ...).
    ; Default Value: not set
    ;chroot =
    
    ; Chdir to this directory at the start.
    ; Note: relative path can be used.
    ; Default Value: current directory or / when chroot
    ;chdir = /var/www
    
    ; Redirect worker stdout and stderr into main error log. If not set, stdout and
    ; stderr will be redirected to /dev/null according to FastCGI specs.
    ; Note: on highloaded environement, this can cause some delay in the page
    ; process time (several ms).
    ; Default Value: no
    ;catch_workers_output = yes
    
    ; Clear environment in FPM workers
    ; Prevents arbitrary environment variables from reaching FPM worker processes
    ; by clearing the environment in workers before env vars specified in this
    ; pool configuration are added.
    ; Setting to "no" will make all environment variables available to PHP code
    ; via getenv(), $_ENV and $_SERVER.
    ; Default Value: yes
    ;clear_env = no
    
    ; Limits the extensions of the main script FPM will allow to parse. This can
    ; prevent configuration mistakes on the web server side. You should only limit
    ; FPM to .php extensions to prevent malicious users to use other extensions to
    ; execute php code.
    ; Note: set an empty value to allow all extensions.
    ; Default Value: .php
    ;security.limit_extensions = .php .php3 .php4 .php5 .php7
    
    ; Pass environment variables like LD_LIBRARY_PATH. All $VARIABLEs are taken from
    ; the current environment.
    ; Default Value: clean env
    ;env[HOSTNAME] = $HOSTNAME
    ;env[PATH] = /usr/local/bin:/usr/bin:/bin
    ;env[TMP] = /tmp
    ;env[TMPDIR] = /tmp
    ;env[TEMP] = /tmp
    
    ; Additional php.ini defines, specific to this pool of workers. These settings
    ; overwrite the values previously defined in the php.ini. The directives are the
    ; same as the PHP SAPI:
    ;   php_value/php_flag             - you can set classic ini defines which can
    ;                                    be overwritten from PHP call 'ini_set'.
    ;   php_admin_value/php_admin_flag - these directives won't be overwritten by
    ;                                     PHP call 'ini_set'
    ; For php_*flag, valid values are on, off, 1, 0, true, false, yes or no.
    
    ; Defining 'extension' will load the corresponding shared extension from
    ; extension_dir. Defining 'disable_functions' or 'disable_classes' will not
    ; overwrite previously defined php.ini values, but will append the new value
    ; instead.
    
    ; Note: path INI options can be relative and will be expanded with the prefix
    ; (pool, global or @prefix@)
    
    ; Default Value: nothing is defined by default except the values in php.ini and
    ;                specified at startup with the -d argument
    ;php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f www@my.domain.com
    ;php_flag[display_errors] = off
    php_admin_value[error_log] = /var/log/php-fpm/www-error.log
    php_admin_flag[log_errors] = on
    ;php_admin_value[memory_limit] = 128M
    
    ; Set the following data paths to directories owned by the FPM process user.
    ;
    ; Do not change the ownership of existing system directories, if the process
    ; user does not have write permission, create dedicated directories for this
    ; purpose.
    ;
    ; See warning about choosing the location of these directories on your system
    ; at http://php.net/session.save-path
    php_value[session.save_handler] = files
    php_value[session.save_path]    = /var/lib/php/session
    php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache
    ;php_value[opcache.file_cache]  = /var/lib/php/opcache

   ```

  

   Resultaat:

   ```
   
   ```
   3. Controlleer de nginx configuratie

   Commando:

   ```
   sudo cat /etc/nginx/conf.d/corona2020.local.conf
   ```

   Verwachte resultaat:

   ```
  

	server {

    listen 80;
    server_name corona2020.local www.corona2020.local;
    root /var/www/html/drupal/web;
    index index.php index.html index.htm;

    error_log /var/log/nginx/error.log info;

    location / {
        # Don't touch PHP for static content.
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Don't allow direct access to PHP files in the vendor directory.
    location ~ /vendor/.*\.php$ {
        deny all;
        return 404;
    }
    # Allow "Well-Known URIs" as per RFC 5785
    location ~* ^/.well-known/ {
        allow all;
    }
    location ~ (^|/)\. {
        return 403;
    }

    # Redirect common PHP files to their new locations.
    location ~ ^((?!.*(?:core)).*)/(install.php|rebuild.php) {
         return 301 $scheme://$host$1/core/$2$is_args$args;
    }

    # Use fastcgi for all php files.
    location ~ \.php$|^/update.php {
        fastcgi_split_path_info ^(.+?\.php)(|/.*)$;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
        fastcgi_intercept_errors on;
        fastcgi_read_timeout 60;
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
    }

    location @rewrite {
        rewrite ^ /index.php;
    }

    location ~ ^/sites/.*/files/styles/ {
        try_files $uri @rewrite;
    }
    location ~ ^(/[a-z\-]+)?/system/files/ {
        try_files $uri /index.php?$query_string;
    }

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }

    gzip on;
    gzip_proxied any;
    gzip_static on;
    gzip_http_version 1.0;
    gzip_disable "MSIE [1-6]\.";
    gzip_vary on;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/xml+rss
        application/xhtml+xml
        application/x-font-ttf
        application/x-font-opentype
        image/svg+xml
        image/x-icon;
    gzip_buffers 16 8k;
    gzip_min_length 512;


	listen 443 ssl;
    ssl_certificate     /etc/pki/tls/certs/corona2020.crt;
    ssl_certificate_key /etc/pki/tls/certs/corona2020.key;
    ssl_protocols       TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
	}
   ```

  

   Resultaat:

   ```
   
   ```




## Stap 3: PostgreSQL Databank controle
*Extra databases/gebruiker kunnen bestaan als er uitbreiding zijn gedaan op de basis config
     voor dit testplan is het de bedoeling om aleen te kijken naar de drupal geralteerde gebruikers/databases*	
 1. Log in op Charlie
 2. Log in op PSQL account
      Commando:

   ```
  

     sudo -u postgres psql

   ```
 3. Controleer of er een database genaamd drupal bestaat.
    

   Commando:

   ```

      \l

   ```


   voorbeeld resultaat:

   ```

                                        List of databases
       Name    |  Owner   | Encoding  |   Collate   |    Ctype    |   Access privileges
    -----------+----------+-----------+-------------+-------------+-----------------------
     drupal    | drupal   | UTF8      | en_US.UTF-8 | en_US.UTF-8 |
     postgres  | postgres | SQL_ASCII | C           | C           |
     template0 | postgres | SQL_ASCII | C           | C           | =c/postgres          +
               |          |           |             |             | postgres=CTc/postgres
     template1 | postgres | SQL_ASCII | C           | C           | =c/postgres          +
               |          |           |             |             | postgres=CTc/postgres
    (4 rows)

   ```

   Resultaat:

   ```
   
   ```

 4. Controleer of de gebruiker drupal aanwezig is
      Commando:

   ```
 

     \du

   ```


   voorbeeld resultaat:

   ```

                                       List of roles
     Role name |                         Attributes                         | Member of
    -----------+------------------------------------------------------------+-----------
     drupal    |                                                            | {}
     postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

   ```

   Resultaat:

   ```
   
   ```
 5. Controleer of de drupal database is aangemaakt
      Commando:

   ```
  \c drupal
  \dt
   ```

   Verwachte resultaat:
   *Indien u aanpassingen heeft gedaan in drupal config kunnen er afwijkingen zijn op het aantal tabelen*

   ```

                     List of relations
 Schema |               Name               | Type  | Owner
--------+----------------------------------+-------+--------
 public | block_content                    | table | drupal
 public | block_content__body              | table | drupal
 public | block_content_field_data         | table | drupal
 public | block_content_field_revision     | table | drupal
 public | block_content_revision           | table | drupal
 public | block_content_revision__body     | table | drupal
 public | cache_bootstrap                  | table | drupal
 public | cache_config                     | table | drupal
 public | cache_container                  | table | drupal
 public | cache_data                       | table | drupal
 public | cache_default                    | table | drupal
 public | cache_discovery                  | table | drupal
 public | cache_dynamic_page_cache         | table | drupal
 public | cache_entity                     | table | drupal
 public | cache_menu                       | table | drupal
 public | cache_page                       | table | drupal
 public | cache_render                     | table | drupal
 public | cache_toolbar                    | table | drupal
 public | cachetags                        | table | drupal
 public | comment                          | table | drupal
 public | comment__comment_body            | table | drupal
 public | comment_entity_statistics        | table | drupal
 public | comment_field_data               | table | drupal
 public | config                           | table | drupal
 public | file_managed                     | table | drupal
 public | file_usage                       | table | drupal
 public | history                          | table | drupal
 public | key_value                        | table | drupal
 public | menu_link_content                | table | drupal
 public | menu_link_content_data           | table | drupal
 public | menu_link_content_field_revision | table | drupal
 public | menu_link_content_revision       | table | drupal
 public | menu_tree                        | table | drupal
 public | node                             | table | drupal
 public | node__body                       | table | drupal
 public | node__comment                    | table | drupal
 public | node__field_image                | table | drupal
 public | node__field_tags                 | table | drupal
 public | node_access                      | table | drupal
 public | node_field_data                  | table | drupal
 public | node_field_revision              | table | drupal
 public | node_revision                    | table | drupal
 public | node_revision__body              | table | drupal
 public | node_revision__comment           | table | drupal
 public | node_revision__field_image       | table | drupal
 public | node_revision__field_tags        | table | drupal
 public | path_alias                       | table | drupal
 public | path_alias_revision              | table | drupal
 public | router                           | table | drupal
 public | search_dataset                   | table | drupal
 public | search_index                     | table | drupal
 public | search_total                     | table | drupal
 public | semaphore                        | table | drupal
 public | sequences                        | table | drupal
 public | sessions                         | table | drupal
 public | shortcut                         | table | drupal
 public | shortcut_field_data              | table | drupal
 public | shortcut_set_users               | table | drupal
 public | taxonomy_index                   | table | drupal
 public | taxonomy_term__parent            | table | drupal
 public | taxonomy_term_data               | table | drupal
 public | taxonomy_term_field_data         | table | drupal
 public | taxonomy_term_field_revision     | table | drupal
 public | taxonomy_term_revision           | table | drupal
 public | taxonomy_term_revision__parent   | table | drupal
 public | user__roles                      | table | drupal
 public | user__user_picture               | table | drupal
 public | users                            | table | drupal
 public | users_data                       | table | drupal
 public | users_field_data                 | table | drupal
 public | watchdog                         | table | drupal
(71 rows)

   ```

   Resultaat:



## Stap 4: Site controle
*Voor deze stap dient u gebruik te maken van host op het zelfde netwerk(met passende config van dns en ip) als waar de webserver zicht bevindt indien u host machine op windows draait, voor linux gebruikers kan up de host zelf de nameserver aanpassen*

 1. surf in een webbrowser naar http://www.corona2020.local
 2. surf in een webbrowser naar http:/corona2020.local
 3. herhaal stap 1 & 2 met Https *(Door het gebruik van zelfsigned cretificates kan u browers een veiligheids waarschuwing geven deze kan u negeren of u kan de creficaten instaleren op u host systeem https://community.spiceworks.com/how_to/1839-installing-self-signed-ca-certificate-in-windows)*
 4. login met op de site als admin met het wachtwoord admin

Verwachte resultaat:

[![Fcvnmg.md.png](https://iili.io/Fcvnmg.md.png)](https://freeimage.host/i/Fcvnmg)

[![FcvRrN.md.png](https://iili.io/FcvRrN.md.png)](https://freeimage.host/i/FcvRrN)



