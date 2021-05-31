# Opzetten Domeincontroller

## Downloaden image Windows Server 2019

Ga naar het [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019) en kies voor Windows Server 2019. 
- Kies ISO en ga verder
- Geef vervolgens je gegevens in en ga verder
- Kies als taal English en klik op download

## Installatie Windows Server 2019

Wanneer we de server voor het eerst opstarten, krijgen we een configuratiewizard. 

1. Kies je taal, tijdsformaat en toetsenbordlay-out en ga verder. Klik daarna op Install Now
![Setup language and time](/doc/alfa/images/setup_language_time.png)

2. Bij het ingeven van de activatiecode kies je onderaan ‘I don’t have a product key’ (je krijgt deze pagina enkel bij Windows Server 2016)
![Activate Windows](/doc/alfa/images/activate_windows.png)

3. Vervolgens kies je de Datacenter versie met Desktop Experience. Dit is de meest uitgebreide versie. Op de volgende pagina accepteer je de licentievoorwaarden en ga je verder   
![Operating system type](/doc/alfa/images/os_type.png)

4. Je kiest bij het installatietype voor Custom: Install Windows only
![Installation type](/doc/alfa/images/installation_type.png)

5. Kies drive 0 om Windows op te installeren, en klik vervolgens op New om deze schijf in partities te verdelen. Klik daarna op Apply om de voorgestelde grootte goed te keuren. Wanneer er een waarschuwing tevoorschijn komt, kun je die gewoon accepteren. Nadat dit gebeurd is, is je drive in 2 partities verdeeld. Je klikt op partitie 2 en kiest Next 
![Install location](/doc/alfa/images/install_location.png)  
Hierna begint de installatie van Windows Server. Na de installatie zal het Windows-systeem opstarten. 

6. Kies als wachtwoord voor de Administrator ```Admin1``` en ga verder. Daarna kan je je in Windows aanmelden met het zopas gekozen wachtwoord. Wanneer het systeem vervolgens vraagt om zich zichtbaar te maken op het netwerk, kies je Yes.
![Set password](/doc/alfa/images/set_password.png)

## Mappen delen via VirtualBox

Met behulp van VirtualBox kan je mappen op het hostsysteem delen met de virtuele machine. We maken hier gebruik van om de PowerShell-scripts te kunnen uitvoeren. Om dit te laten werken, moeten we eerst VirtualBox Guest Additions installeren.

1. Klik in de menubalk bovenaan op Apparaten en kies voor 'Invoegen Guest Additions CD-image...'

2. Ga in de Explorer van de VM op zoek naar deze image, en open hem.

3. Doorloop de korte wizard en installeer de software.

4. Om de installatie te voltooien herstart je de VM.  
![VirtualBox Guest Additions](/doc/alfa/images/guest_additions.png)

Na het herstarten kunnen we gedeelde mappen toevoegen aan het systeem

1. Klik in de menubalk bovenaan op Apparaten. Kies voor 'Gedeelde mappen'-> 'Instellingen gedeelde mappen...'

2. Klik op het icoontje rechts bovenaan om een gedeelde map toe te voegen
![Gedeelde mappen](/doc/alfa/images/gedeelde_mappen.png)

3. Bij 'Pad naar map' kies je voor de src-map van dit project. Geef dus de locatie in waar je die map hebt opgeslagen op je hostsysteem. Klik vervolgens op OK om de map toe te voegen.
![Toevoegen gedeelde map](/doc/alfa/images/toevoegen_map.png)

4. Op de virtuele machine kun je de gedeelde map terugvinden in de Explorer. Ga naar Netwerklocaties en kies 'VBOXSVR' om de src-map weer te geven.

## Configuratiescripts uitvoeren

We zullen de benodigde componenten op de server installeren en configureren aan de hand van enkele PowerShell-scripts. Ga in de gedeelde src-map naar de map 'PowerShell-scripts'.

1. Om te beginnen voeren we een script uit dat enkele basisinstellingen configureert en daarna de server herstart om deze aanpassingen door te voeren. Klik rechts op 'alfa_base' en kies 'Run with PowerShell'. De security warning mag je negeren - we weten dat dit een veilig bestand is. Wanneer er wordt gevraagd of je de execution policy wil veranderen, kies je voor [A] Yes to All.

2. Na het herstarten keer je terug naar de scripts en klik je rechts op 'alfa_promotedc', waarna je opnieuw 'Run with PowerShell' kiest. Dit script maakt een active directory domein en promoveert de server tot domeincontroller. De server zal vervolgens opnieuw opstarten in het opgezette domein.

3. Je keert opnieuw terug naar de scripts en voert nu het script 'alfa_dhcp' uit op dezelfde manier als de voorgaande scripts. Dit script zorgt ervoor dat de server wordt geconfigureerd als dhcp server. Zorg ervoor dat de DNS server in het netwerk geconfigureerd is, anders kan dit script niet foutloos uitgevoerd worden.

4. Als laatste kies je voor het script 'alfa_adds' en voer je het uit met PowerShell. Dit script organiseert de afdelingen, computers en gebruikers in de Active Directory en voert enkele beleidsregels uit op gebruikersniveau. 
