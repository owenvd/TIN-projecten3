# TEST PLAN: DEPLOYMENT SERVER - ECHO

| **auteur testplan** | Kelvin Vermeulen |
| ------------------- | -------------- |
| **uitvoerder test** | Jari Van de Cappelle | 

## Requirements

- Het opzetplan is volledig doorlopen en de virtuele machine draait met de juiste naam
- De DNS server in het netwerk draait
- De server is toegevoegd aan het domein
- SCCM (Configuration Manager) is correct geïnstalleerd
- SQL Server is correct geïnstalleerd en er kan verbinding gemaakt worden in SSMS
- Men kan PXE booten (een client deployen via het netwerk), via WDS/MDT

## STAP 1

Na alle scripts te laten runnen en de installaties te voltooien, controleren we of de server toegevoegd is aan het juiste domein en of de naam correct is ingesteld. Dit doen we met de commando's `$env:computername` in PowerShell en het commando `set user` in Command Prompt.

```console
PS C:\Users\Administrator.CORONA2020> $env:computername
ECHO
```

Dit is de verwachte output:
```console
C:\Users\Administrator.CORONA2020>set user
USERDNSDOMAIN=CORONA2020.LOCAL
USERDOMAIN=CORONA2020
USERDOMAIN_ROAMINGPROFILE=CORONA2020
USERNAME=Administrator
USERPROFILE=C:\Users\Administrator.CORONA2020
```

## STAP 2
We controleren of de juiste instellingen (DNS, IP...) zijn ingesteld. Dit doen we met `Get-NetIPAddress -AddressFamily IPv4` en `Get-DnsClientServerAddress -AddressFamily IPv4`. We verwachten volgende instellingen (naam van interface kan verschillen):

```console
IPAddress         : 192.168.10.198
InterfaceIndex    : 14
InterfaceAlias    : LAN
AddressFamily     : IPv4
Type              : Unicast
PrefixLength      : 24
PrefixOrigin      : Manual
SuffixOrigin      : Manual
AddressState      : Preferred
ValidLifetime     : Infinite ([TimeSpan]::MaxValue)
PreferredLifetime : Infinite ([TimeSpan]::MaxValue)
SkipAsSource      : False
PolicyStore       : ActiveStore
```

```console
InterfaceAlias               Interface Address ServerAddresses                       
                             Index     Family                                        
--------------               --------- ------- ---------------                       
LAN                                 14 IPv4    {192.168.10.195}                      
Loopback Pseudo-Interface 1          1 IPv4    {}                                    
```

## STAP 3
Hierna mogen we PowerShell verlaten en kunnen we handmatig controleren of alle nodige software correct geïnstalleerd is. We beginnen in het Start menu, en typen `SSMS`. `Microsoft SQL Server Management Studio 18` zal verschijnen, waarna we het programma openen. In het programma gaan we een verbinding maken met een `Database Engine` met `Windows Authentication`. We kunnen bij `Server name` een `.` zetten of `localhost`, maar het is eigenlijk beter om de FQDN te gebruiken. Hierdoor kunnen we meteen testen of DNS goed werkt, en of er op het domein geen fouten te bespeuren zijn. We vullen dus `echo.CORONA2020.local` in en clicken op Connect. Indien er verbinding gemaakt wordt, is SQL correct geïnstalleerd en kan je het programma terug afsluiten.

## STAP 4
We gaan controleren of Configuration Manager correct is geïnstalleerd. We typen in Start 'Configuration Manager' en openen `Configuration Manager Console`. Er zal verbinding gemaakt worden met de reeds geteste SQL server uit Stap 3, waarna we in het startscherm komen. Eigenlijk is de installatie reeds geslaagd, maar om te dubbelchecken kan je steeds Naar 'Devices' > 'All Systems' gaan, waarna je o.a. 'ECHO' zal zien staan. Indien je reeds een cliënt hebt ge PXE-boot, kan je deze hier ook zien (bv. x64 Unknown Computer).

## STAP 5
Hierna kunnen we de configuratie van MDT en WDS controleren. We openen WDS (Windows Deployment Services) en klappen servers > echo.CORONA2020.local open. Hier kunnen we de install en boot images nogmaals controleren. Onder Boot images zie je 'Microsoft Windows Setup', onder install images de groep 'desktops' en daarna 'Windows 10 Pro' (en andere images eventueel). WDS is ook compleet.

## STAP 6
We openen Deployment Workbench, waar we eerst en vooral de share zullen controleren. Ga naar Deployment Shares > MDT Deployment Share. Deze share is correct aangemaakt. We hadden ook Adobe Reader mee geïnstalleerd, wat we kunnen controleren onder Applications. Ook onder Operating Systems zal je Windows 10 Pro kunnen zien staan.

## STAP 7
De laatste stap, is het effectief testen of er gePXE-boot kan worden. Dit zou moeten lukken als je de stappen uit de Handleiding volgt. Zo weten we zeker dat de server volledig correct geïnstalleerd is.