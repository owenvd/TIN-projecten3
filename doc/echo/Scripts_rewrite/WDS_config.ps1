Clear-Host;
Import-Module ServerManager;
Import-Module PackageManagement;

#De prerequisities worden geïnstalleerd op de server.
Write-host("De De prerequisities worden geïnstalleerd op de server. Dit kan even duren.")
Get-Module servermanager
Install-WindowsFeature Web-Windows-Auth
Install-WindowsFeature Web-Asp-Net
Install-WindowsFeature Web-ISAPI-Ext
Install-WindowsFeature Web-WMI
Install-WindowsFeature Web-Metabase
Install-WindowsFeature Web-Asp-Net45
Install-WindowsFeature BITS
Install-WindowsFeature RDC
Install-WindowsFeature NET-HTTP-Activation
Install-WindowsFeature NET-Non-HTTP-Activ
Install-WindowsFeature NET-Framework-Features

#Configureren van WDS (Windows Deployment Service). WDS laat ons toe om via één gecentraliseerde server (dit apparaat)
#ontelbaar andere toestellen (andere servers, clients, programma's voor die clients...) te voorzien.
Write-Host("WDS wordt geconfigureerd.")
Import-WdsBootImage -Path "C:\WIN10\sources\boot.wim"
New-WdsInstallImageGroup -Name "desktops"
Import-WdsInstallImage -ImageGroup "desktops" -Path "C:\WIN10\sources\install.wim" -ImageName "Windows 10 Pro"
