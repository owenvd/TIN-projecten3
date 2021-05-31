# TEST PLAN: DOMEINCONTROLLER - ALFA

| **auteur testplan** | Jari Van de Cappelle |
| ------------------- | -------------- |
| **uitvoerder test** |     Kelvin Vermeulen |

## Requirements

- Het opzetplan is volledig doorlopen en de virtuele machine draait
- De DNS server in het netwerk draait
- Om de beleidsregels te testen moet een werkstation-machine worden opgesteld met Windows 10

## Stap 1: test de basisconfiguratie

Controleer of de basisinstellingen correct zijn geconfigureerd. Gebruik hiervoor PowerShell.

- Controleer of de computernaam is ingesteld op ALFA. Gebruik hiervoor het commando `$env:computername`

- Controleer of de IPv4-adressen juist zijn ingesteld. Gebruik hiervoor het commando `Get-NetIPAddress - AddressFamily IPv4`
Dit is de verwachte uitvoer: 
```
IPAddress         : 192.168.10.194
InterfaceIndex    : 6
InterfaceAlias    : Ethernet 2
AddressFamily     : IPv4
Type              : Unicast
PrefixLength      : 29
PrefixOrigin      : Manual
SuffixOrigin      : Manual
AddressState      : Preferred
ValidLifetime     : Infinite ([TimeSpan]::MaxValue)
PreferredLifetime : Infinite ([TimeSpan]::MaxValue)
SkipAsSource      : False
PolicyStore       : ActiveStore

IPAddress         : 10.0.2.15
InterfaceIndex    : 4
InterfaceAlias    : Ethernet
AddressFamily     : IPv4
Type              : Unicast
PrefixLength      : 24
PrefixOrigin      : Dhcp
SuffixOrigin      : Dhcp
AddressState      : Preferred
ValidLifetime     : 23:52:27
PreferredLifetime : 23:52:27
SkipAsSource      : False
PolicyStore       : ActiveStore

IPAddress         : 127.0.0.1
InterfaceIndex    : 1
InterfaceAlias    : Loopback Pseudo-Interface 1
AddressFamily     : IPv4
Type              : Unicast
PrefixLength      : 8
PrefixOrigin      : WellKnown
SuffixOrigin      : WellKnown
AddressState      : Preferred
ValidLifetime     : Infinite ([TimeSpan]::MaxValue)
PreferredLifetime : Infinite ([TimeSpan]::MaxValue)
SkipAsSource      : False
PolicyStore       : ActiveStore
```

- Controleer of het IP-adres van de DNS server juist is ingesteld. Gebruik hiervoor het commando `Get-DnsClientServerAddress -AddressFamily IPv4`
De verwachte uitvoor voor de Ethernet 2-interface (het interne netwerk) is 192.168.10.195, het IP-adres van server bravo 

- Controleer of het automatisch inloggen correct werkt. Om dit te testen kun je de machine opnieuw opstarten. Wanneer er bij het opstarten geen gebruikersnaam en wachtwoord gevraagd wordt, is dit juist geconfigureerd.

## Stap 2: test de domeincontroller-configuratie

- Aan de hand van het commando `Get-ADDomainController` krijg je alle nodige info over de configuratie van het domein en de domeincontroller.
Dit is de verwachte uitvoer: 
```
ComputerObjectDN           : CN=ALFA,OU=Domain Controllers,DC=CORONA2020,DC=local
DefaultPartition           : DC=CORONA2020,DC=local
Domain                     : CORONA2020.local
Enabled                    : True
Forest                     : CORONA2020.local
HostName                   : alfa.CORONA2020.local
InvocationId               : 3848f365-b6fb-4141-94bc-44049f84a379
IPv4Address                : 192.168.10.194
IPv6Address                : 
IsGlobalCatalog            : True
IsReadOnly                 : False
LdapPort                   : 389
Name                       : ALFA
NTDSSettingsObjectDN       : CN=NTDS Settings,CN=ALFA,CN=Servers,CN=Default-First-Site-Name,CN=Sites,CN=Configuration
                             ,DC=CORONA2020,DC=local
OperatingSystem            : Windows Server 2019 Datacenter Evaluation
OperatingSystemHotfix      : 
OperatingSystemServicePack : 
OperatingSystemVersion     : 10.0 (17763)
OperationMasterRoles       : {SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster...}
Partitions                 : {CN=Schema,CN=Configuration,DC=CORONA2020,DC=local, CN=Configuration,DC=CORONA2020,DC=lo
                             cal, DC=CORONA2020,DC=local}
ServerObjectDN             : CN=ALFA,CN=Servers,CN=Default-First-Site-Name,CN=Sites,CN=Configuration,DC=CORONA2020,DC
                             =local
ServerObjectGuid           : 32b3d49c-3698-4896-9682-31330c74be86
Site                       : Default-First-Site-Name
SslPort                    : 636
```

## Stap 3: test de DHCP-configuratie

- Controleer of de huidige machine functioneert als DHCP server in het domein. Gebruik hiervoor het commando `Get-DhcpServerInDC`
Dit is de verwachte uitvoer:
```
IPAddress            DnsName                                                                         
---------            -------                                                                         
192.168.10.194       alfa.corona2020.local    
```

- Controleer vervolgens of de DHCP-scopes correct zijn ingesteld. Dit doe je met het commando `Get-DhcpServerv4Scope`
Dit is de verwachte uitvoer:
```
ScopeId         SubnetMask      Name           State    StartRange      EndRange        LeaseDuration                
-------         ----------      ----           -----    ----------      --------        -------------                
192.168.10.0    255.255.255.128 Gastnetwerk    Active   192.168.10.2    192.168.10.126  8.00:00:00                   
192.168.10.128  255.255.255.192 Personeel      Active   192.168.10.130  192.168.10.190  8.00:00:00   
```

- Controleer vervolgens of de scopes de juiste IP-adressen meegeven voor DNS en default gateway.
Dit zijn de gebruikte commando's, met hun verwachte uitvoer:
```
PS C:\Users\Administrator> Get-DhcpServerv4OptionValue -ScopeId 192.168.10.0

OptionId   Name            Type       Value                VendorClass     UserClass       PolicyName     
--------   ----            ----       -----                -----------     ---------       ----------     
3          Router          IPv4Add... {192.168.10.1}                                                      
6          DNS Servers     IPv4Add... {192.168.10.195}                                                    
51         Lease           DWord      {691200}                                                            



PS C:\Users\Administrator> Get-DhcpServerv4OptionValue -ScopeId 192.168.10.128

OptionId   Name            Type       Value                VendorClass     UserClass       PolicyName     
--------   ----            ----       -----                -----------     ---------       ----------     
3          Router          IPv4Add... {192.168.10.129}                                                    
6          DNS Servers     IPv4Add... {192.168.10.195}                                                    
51         Lease           DWord      {691200}                                                            

```

## Stap 4: test de active directory users en computers

- Controleer of alle afdelingen juist werden aangemaakt met het commando `Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A`
Dit is de verwachte uitvoer:
```
Name               DistinguishedName                           
----               -----------------                           
Domain Controllers OU=Domain Controllers,DC=CORONA2020,DC=local
IT-Administratie   OU=IT-Administratie,DC=CORONA2020,DC=local  
Verkoop            OU=Verkoop,DC=CORONA2020,DC=local           
Administratie      OU=Administratie,DC=CORONA2020,DC=local     
Ontwikkeling       OU=Ontwikkeling,DC=CORONA2020,DC=local      
Directie           OU=Directie,DC=CORONA2020,DC=local          
```

- Controleer of alle werkstations juist werden aangemaakt en zich in de juiste afdeling bevinden. Gebruik hiervoor het commando `Get-ADComputer -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A`
Dit is de verwachte uitvoer:
```
Name                DistinguishedName                                                
----                -----------------                                                
ALFA                CN=ALFA,OU=Domain Controllers,DC=CORONA2020,DC=local             
ITADMIN-werkstation CN=ITADMIN-werkstation,OU=IT-Administratie,DC=CORONA2020,DC=local
VERKOOP-werkstation CN=VERKOOP-werkstation,OU=Verkoop,DC=CORONA2020,DC=local         
ADMIN-werkstation   CN=ADMIN-werkstation,OU=Administratie,DC=CORONA2020,DC=local     
ONTWIK-werkstation  CN=ONTWIK-werkstation,OU=Ontwikkeling,DC=CORONA2020,DC=local     
DIREC-werkstation   CN=DIREC-werkstation,OU=Directie,DC=CORONA2020,DC=local  
```

- Controleer of alle gebruikers juist werden aangemaakt en in de juiste afdeling werden toegevoegd. Gebruik hiervoor het commando `Get-ADUser -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName, SamAccountName, UserPrincipalName -A`
Dit is de verwachte uitvoer:
```
Name             DistinguishedName                                              SamAccountName UserPrincipalName         
----             -----------------                                              -------------- -----------------         
Administrator    CN=Administrator,CN=Users,DC=CORONA2020,DC=local               Administrator                            
Guest            CN=Guest,CN=Users,DC=CORONA2020,DC=local                       Guest                                    
krbtgt           CN=krbtgt,CN=Users,DC=CORONA2020,DC=local                      krbtgt                                   
Test1 Gebruiker1 CN=Test1 Gebruiker1,OU=IT-Administratie,DC=CORONA2020,DC=local tgebruiker1    tgebruiker1@corona2020.com
Test2 Gebruiker2 CN=Test2 Gebruiker2,OU=Verkoop,DC=CORONA2020,DC=local          tgebruiker2    tgebruiker2@corona2020.com
Test3 Gebruiker3 CN=Test3 Gebruiker3,OU=Administratie,DC=CORONA2020,DC=local    tgebruiker3    tgebruiker3@corona2020.com
Test4 Gebruiker4 CN=Test4 Gebruiker4,OU=Ontwikkeling,DC=CORONA2020,DC=local     tgebruiker4    tgebruiker4@corona2020.com
Test5 Gebruiker5 CN=Test5 Gebruiker5,OU=Directie,DC=CORONA2020,DC=local         tgebruiker5    tgebruiker5@corona2020.com
```

## Stap 5: test de beleidsregels

Om de beleidsregels te testen moet je ingelogd zijn als user in het netwerk. Maak dus een Windows 10-machine aan in het netwerk (zonder NAT-interface). Het IP-adres wordt via DHCP verkregen van de domeincontroller. Ga naar Settings -> About en kies voor Join a domain. Geef de domeinnaam CORONA2020.local in en log je daarna in als de gebruiker in de Verkoop-afdeling, met de volgende logingegevens:
gebruikersnaam: tgebruiker2
wachtwoord: Pa$$w0rd
Ten slotte herstart je de computer, waarna je in het domein kan inloggen. Bij de eerste login moet je een nieuw wachtwoord (naar keuze) instellen. 

- Als gebruiker in de Verkoop-afdeling heb je geen toegang tot het control panel. Ga op zoek naar het control panel en probeer dit te openen.

- Het games link menu is voor alle afdelingen verwijderd uit het startmenu. Controleer of dit gebeurd is.

- Als gebruiker in de Verkoop-afdeling heb je geen toegang tot de eigenschappen van de netwerkadapters. Controleer of dit klopt.

- Er is voor de gebruikers een filesysteem voorzien via DFS. Ga naar de verkenner en kies voor netwerklocaties. Geef bovenaan de locatie '\\CORONA2020.local\files\' in en zoek. Controleer of je voor elke afdeling een map te zien krijgt, waaraan je bestanden kunt toevoegen. Voeg een nieuw bestand toe in de map Verkoop, bijvoorbeeld test.txt.
![DFS](/doc/alfa/images/dfs.png)

- Log terug in op de domeincontroller en ga ook hier naar de verkenner. Open de netwerklocaties en kies voor ALFA. De bestanden van het domein worden op deze machine opgeslagen in de gelijknamige mappen. Controleer of deze mappen correct zijn aangemaakt. Controleer ook of het test.txt-bestand in de map Verkoop terug te vinden is. 
![DFS ALFA](/doc/alfa/images/dfs_alfa.png)

