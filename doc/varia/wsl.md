## Onderzoek WSL
 Windows Subsysteem for Linux is een compatibele laag voor het runnen van Linux applicaties natively op windows 10 en server 2019

**Hoe installeren**
 - run het volgende commando in PowerShell als Admin
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

```
 - Download en installeer de laatste Linux kernel voor wsl 2 https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
 - zet WSL 2 als default door het volgende PowerShell commando te runnen
 ```
wsl --set-default-version 2

```
- open de Microsoft store en download u keuze van Linux distro
-  nu kan u gebruik gemakken van de Linux kernel

## Hoe gebruiken met vagrant en anisble

 - installeer volgende packages op windows en linux
	 - Virtualbox
	 - Vagrant
- installeer de volgende op linux kernel
	 - python 2
	 - Ansible

zorg dat er voor de beide versie nummer tussen windows en linux gelijk zijn
(note bug met vagrant 2.2.10 voor vagrant gebruik versie 2.2.9)

Nu kan u gebruik maken Vagrant via de linux kernel en vm opstarten op u windows VirtualBox met volgende commando's

**`vagrant init [name [url]]`**
**`vagrant up [name|id]`**
