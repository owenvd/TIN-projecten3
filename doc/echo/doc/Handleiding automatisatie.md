# Handleiding automatisatie SCCM

Voor de opdracht van Projecten III, kregen we de opdarcht om onderandere een SCCM server op te zetten en dit zoveel mogelijk te automatiseren. Door de verschillende stappen in deze handleiding te volgen, zou dit moeten lukken. Men kan altijd de virtualbox stappen uit `alfa` volgen. We wezen 4GB RAM toe, 2 CPU-cores en een harde schijf van 150 GB.


***TIPS OM SNELLER TE WERKEN***

We hebben enkele bestanden nodig, deze staan op google drive: https://drive.google.com/drive/u/0/folders/1ZWmeQTrk4ardc1FxP2u4-_BZyV4kXtWx. Als je bovenaan in de VM `Devices > Shared Clipboard > Bidirectionaal` en `Devices > Drag and Drop > Bidirectionaal` doet, zal het makkelijker zijn om deze bestanden van je host machine naar de VM te droppen (en eventuele commando's te kopiëren). Je kan ook eventueel alle files van google drive downloaden op je lokale machine, en dan zoals bij `alfa` gebruik maken van een shared folder. Ook voegen we hier de Guest Additions toe, zoals bij `alfa`.

## Stappenplan

***OPMERKING:*** Controleer eerst in VirtualBox welke adapter NAT is en welke host-only is. Zorg ervoor dat de `NAT`-adapter naam `Ethernet` heeft, en de `host-only`-adapter de naam `Ethernet 2` heeft. Indien dit niet zo is kan je de namen in het script veranderen, of de namen van de adapters veranderen in Windows zelf. Ook maak je best een folder `Scripts` aan op de C-schijf ( `C:\Scripts\`) waar je alle scripts naartoe verplaatst. Er zal voor ieder script afzonderlijk gezegd worden op welke locatie je wat moet zetten, maar de meeste scripts (en bijbehorende config-files) kan je hiernaar verplaatsen. Nu kunnen we aan de slag.

1. Allereerst gaan we de naam van de server aanpassen naar "echo", alsook de server toevoegen aan het juiste domein "CORONA2020.local" (Domein credentials nodig). Verder worden ook de juiste toetsenbordinstellingen en de juiste tijdszone ingesteld. Ook wordt het juiste IP-adres, de DNS-server en de Default Gateway geconfigureerd.  Dit doen we in "script1.ps1", waarna de server uit zichzelf herstart.

2. Vervolgens moeten we op onze Domein Controller de System Configuration Container creëren. Dit doen we met het script "Create system management container.ps1". Dit moet op de ***DC uitgevoerd worden als domein admin***.

3. Hierna moeten we Permissions configureren, dit doen we met het script "Delegate permission.ps1" ***OP DE DC***. Vergeet niet $ConfigMgrSrv = "echo" te controleren (of aan te passen indien de deployment server van naam verandert).

4. Hierna moeten we de rollen en features op onze Deployment server installeren (alsook SQL server, waarover later meer). ***Let bij installatie op dat de Windows Server 2019-iso gemount is in drive D:\!*** Het zou kunnen dat de VirtualBox guest-Additions in de D:\ drive te vinden zijn. Indien de installatie-iso ergens staat, vergeet dit dan niet aan te passen in het script "roles_features.ps1" bij *$SourceFiles = "D:\Sources\sxs"*. Ook moet je op "echo" de scripts en bijbehorende files (`DeploymentConfigTemplate.xml` en `DeploymentConfigTemplate_WSUS.xml`) verplaatsen naar "C:\Scripts\". Indien de scripts en bestanden hier niet staan maar ergens anders, gelieve dan de locatie aan te passen in het script bij *$XMLPath = "C:\Scripts\DeploymentConfigTemplate.xml"*.

5. We hebben zoals reeds vernoemd ook SQL server nodig, met de bijbehorende Management Studio. Dit doen we met het script "Install SQL Server 2017". Hier wordt ook de Cumulative Update gedownload en geïnstalleerd, samen met SSMS17. Indien je versie 18 wil, kan je script "sql_choc.ps1" installeren. Let in het SQL script erop dat de juiste username werd ingevuld bij $yourusername. Ook moet de SQL-iso gemount zijn, deze staat in het script in Drive D:\. Indien dit niet het geval is, pas dit aan. Aangezien sommige bestanden (1GB+) gedownload moeten worden, kan dit script wel even in beslag nemen. Er kan een memory error getoond worden, maar deze mogen we negeren.

6. ADK en de WinPE Addon moeten ook geïnstalleerd worden. Deze installaties zijn vrij groot (ong. 4GB en 5GB), dus kunnen lang duren. Zet de setup.exe bestanden (bv door ze te downloaden op je host systeem en te drag&droppen naar de VM) onder C:\ADK\ en run het script "setup ADK and WDS.ps1". Hierna wordt de server opnieuw opgestart.

7. Nu is de WSUS role aan de beurt. Deze zal geïnstalleerd worden met het script "wsus_role_install.ps1". Hiervoor moet je opletten dat de Windows Server 2019 ISO in drive D:\ te vinden is (en niet de SQL server iso). Controleer of de juiste servernaam is ingevuld bij $servername, alsook de locatie van de scripts correct zijn "C:\Scripts". *GEEN BACKSLASH* Er wordt een WSUS folder aangemaakt op de C:-schijf. Het script zal geen error geven, maar de `post-configuration` moet nog starten. Dit doen we door in `Server Manager` bovenaan op het oranje driehoekje te klikken, en de post configuration te starten. Na enkele minuten zal ook dit slagen.

8. Hierna moeten we SCCM installeren. Eerst moeten we het bestand "SC_Configmgr_SCEP_1606" uitpakken [dubbelklikken op het bestand en uitpakken naar C:]. Daarna gaan we enkele prereqs downloaden. Dit kan je doen met het script "prereqs_sccm.ps1". Hier is het van belang dat je de ConfigMgrISO (of extracted files van SC_Configmgr_SCEP_1606) op een makkelijke plaats opslaat. Het script gebruikt `$SCCMPath = "C:\SC_Configmgr_SCEP_1606"`. Indien je de folder een andere plaats of naam geeft, moet je dit veranderen. De prereqs worden opgeslaan naar `"C:\Source\SCCM_Prerequisites\"`. Dit moet je 'onthouden' voor straks zodat je het tijdens de installatie niet meer moet zoeken.

9.  Om SCCM te kunnen gebruiken, moeten we het AD schema extenden. Dit doen we met het script "Extend the Schema in AD.ps1". Ook hier is het belangrijk dat de juiste locatie van SCCM ingevuld staat onder $SCCMPath = "C:\SC_Configmgr_SCEP_1606". Er worden Admin rechten van het domein gevraagd, vul hier dus als gebruikersnaam `CORONA2020\Administrator` in, en het wachtwoord van het domein `Admin1`. Indien het schema al uitgebreid is, moet dit uiteraard niet uitgevoerd worden (dubbel uitvoeren mag trouwens ook).

10. Er is ook een script geschreven om Configuration Manager te installeren. Het script is te vinden onder de naam "sccm_install.ps1" en wordt best uitgevoerd als domein administrator (`CORONA2020\Administrator`). Het betreft één commando: `Set-Location -Path "C:\"
.\SC_Configmgr_SCEP_1606\SMSSETUP\BIN\X64\setup.exe /script "C:\Scripts\Config.ini" /passive /norestart /silent`
. Hiervoor moet je het bestand "Config.ini" plaatsen onder "C:\Scripts\". Controleer de variabelen die in het .ini bestand te vinden zijn (naam van de SQL server etc). Indien je op foutmeldingen komt kan je proberen eerst alles van Configuration Manager terug te verwijderen, en daarna handmatig de installatie uit te voeren. De variabelen uit de Config.ini file kunnen hiervoor gebruikt worden. De installatiewizard is te vinden onder: "C:\SC_Configmgr_SCEP_1606\SMSSETUP\BIN\X64\setup.exe".

11. SCCM (Configuration Manager) is nu volledig geïnstalleerd. Nu gaan we MDT installeren, alsook WDS configureren om Windows 10 Pro images te kunnen deployen.

12. Om WDS te kunnen configureren, plaats je het bestand "WIN10.7z" op "C:", waarna je het uitpakt. Dit zijn alle installatie bestanden voor een Windows 10 Pro image. Deze zullen we nodig hebben om te PXE-booten.

13. Voer het script "WDS_config.ps1" uit. Zorg ervoor dat de folder "WIN10" op de C: schijf staat. We zullen een image group aanmaken voor Desktops die "Desktops" heet, alsook een install image aanmaken. er wordt ook overlopen of de prereqs wel correct geïnstalleerd zijn (dubbel check, mag verwijderd worden).

13. MDT wordt geïnstalleerd via de setup-wizard (bestand `MicrosoftDeploymentToolkit_x64`). Je kan de screenshots volgen (7-16 in de imgs folder).

![MDT](../imgs/7.mdt.PNG)
![MDT](../imgs/8.mdt.PNG)
![MDT](../imgs/9.mdt.PNG)
![MDT](../imgs/10.mdt.PNG)
![MDT](../imgs/11.mdt-vinkjes-uit.PNG)
![MDT](../imgs/12.mdt-win10-iso.PNG)
![MDT](../imgs/13.mdt-app.PNG)
![MDT](../imgs/14.mdt-app.PNG)
![MDT](../imgs/15.mdt-app.PNG)
![MDT](../imgs/16.mdt-app.PNG)


14. MDT configuraties worden gedaan adhv scripts, in deze volgorde: "share_aanmaken.ps1", "import_os.ps1", "application.ps1", "task-sequence.ps1".

15. MDT is nu volledig geconfigureerd. We moeten enkel nog in onze DHCP-role op de DC enkele dingen aanpassen. Zo moeten we wanneer we onze scope uitklappen, rechtermuisklik op server options > "configure options" nog twee dingen aanpassen. We vinken opties 066 en 067 aan, en vullen het volgende in:

![DHCP](../imgs/17.dhcp.PNG)
![DHCP](../imgs/18.dhcp.PNG)

16. Indien de SCCM server 2 NICs heeft, is het aangeraden de NAT NIC uit te schakelen. Dit kan voor storingen zorgen bij virtualbox wanener we willen PXE booten.

17. In virtualbox maken we een nieuwe VM aan, "MDT-Client". Deze heeft 1 netwerkadapter (indien je host-only gebruikte voor DC/SCCM ook host-only, anders bridged -ik heb bridged gebruikt). We vinken ook bij de system settings "network" aan, en verplaatsen het naar de eerste prioriteit. (Zie screenshot).

![Client PXE](../imgs/19.client.PNG)
![Client PXE](../imgs/20.client.PNG)
![Client PXE](../imgs/21.client.PNG)
![Client PXE](../imgs/22.PNG)
![Client PXE](../imgs/23.PNG)
![Client PXE](../imgs/24.PNG)
![Client PXE](../imgs/25.PNG)

18. We starten de VM op en zien dat er een IP-adres door DHCP werd uitgedeeld. Hierna moet je snel op F12 duwen, waarna je het soort image kan kiezen. Wij gaan voor Microsoft Windows Setup, en zien dat de juiste files worden gedownload. Hierna kunnen we de taal kiezen en onze toetsebord instellingen. Vervolgens wordt er gevraagd om met een gemachtigd account in te loggen, dit doen we met "CORONA2020\Administrator". Hierna kiezen we Windows 10 Pro en volgt een standaard windows installatie. Het kan zijn dat er soms nog eens herstart wordt, en dat je het scherm van het PXE-booten nogmaals ziet (waar men vraagt om op F12 te drukken, DOE DIT NIET). Je hoeft echter niets te doen. Na installatie is de Windows 10 Pro desktop lid van het juiste domein.


### Resources

- []()
