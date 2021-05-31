# GNS3 - manual

## Toevoegen GNS3 VM
- download de GNS3 vm [hier](https://github.com/GNS3/gns3-gui/releases/download/v2.2.17/GNS3.VM.VirtualBox.2.2.17.zip)
- unzip de zip file en open het ova bestand
- importeer de vm in virtual box *(dit kan even duren)*
	- zorg er voor dat GNS3 vm een host only en nat netwerkadapter heeft
- na het importeren open gns3
- klik op edit in de navigatie bar
- klik op preferences
- ga naar het tab GNS3 vm
- geef de gns3 vm het gewenste aantal vCPU en RAM (Zie voorbeeld)
	-  voor optimaal gebruik geef de gns3 VM min 8gb aan ram - 16gb is recommend
	 
![Image from Gyazo](https://i.gyazo.com/e9992ddd8951626eb557e071d65ab993.png)
- druk op finish
## Toevoegen router - c7200
**Image terug te vinden bij gns3 in src**
- open gns3
- klik op edit in de navigatie bar
- klik op preferences
- navigeer naar Dynamips > IOS routers en klik op new
- select run this IOS router on my local computer
- select new image en selecteer de gekozen image in onze geval c7200-adventerprisek9-mz.124-24.T5.image
- druk op next tot en met Network Adapters
- selecteer hier C7200-IO-2FE
- als er geen idle-pc is druk dan op idle-pc finder
- druk op finish

[How to add a router to GNS3](https://www.youtube.com/watch?v=yRZNVHoIF1A)

## Toevoegen laag 3 switch - NVIDIA cumulus
*Cumulus VX is gratis te downloaden via* [nvidia](https://cumulusnetworks.com/try-for-free/) *na het aanmaken van een account*
- download [Cumulus VX](https://gns3.com/marketplace/appliances/cumulus-vx) van de GNS3 marketplace 
- open gns3
- klik op new template
- selecteer import an appliance file
- selecteer de Cumulus VX appliance 
- druk op next tot en met Required files
- importeer u versie van Cumulus VX 
![Image from Gyazo](https://i.gyazo.com/d12c195437b10788d9cca42bfd9fcc29.png)
- druk op next en daarna op yes en dan op finish
## Toevoegen laag 2 switch
- download [Cisco IOSvL2](https://gns3.com/marketplace/appliances/cisco-iosvl2) van de GNS3 marketplace 
- klik op new template
- selecteer import an appliance file
- selecteer de Cisco IOSvL2
- druk op next tot en met Required files
-  importeer u versie van Cisco IOSvL2
- druk op next en daarna op yes en dan op finish
## Toevoegen virtuele machine
- open gns3
- klik op edit in de navigatie bar
- klik op preferences
- navigeer naar Virtualbox > Virtualbox VM's
- druk op new
-  selecteer run this vm on my local computer
- druk op next
- selecteer de gewenste vm
- druk op finish
