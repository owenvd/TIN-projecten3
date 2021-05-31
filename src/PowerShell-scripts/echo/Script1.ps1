Clear-Host;
Import-Module ServerManager;
Import-Module PackageManagement;

$ip = [IPAddress] "192.168.10.198"
$dns = [IPAddress] "192.168.10.195"
$gw = [IPAddress] "192.168.10.193"
$snm = 29
$name = "echo"

#Instellen regio en toetsenbord
Write-host("Het toetsenbord wordt ingesteld op AZERTY.");
Set-WinUserLanguageList -LanguageList NL-BE -Force;
Write-host("De tijdzone wordt ingesteld op Brussel");
Set-TimeZone "Romance Standard Time";

#Het systeem krijgt de naam: $name.
Write-Host("Server krijgt nieuwe naam: $name")
Rename-Computer -NewName $name

#Ethernet adapter krijgt juiste naam en IP-adres. Hierdoor kunnen we verbinding maken met het internet.
Write-host("Veranderen naam Ethernet naar LAN.");
Rename-NetAdapter -Name "Ethernet" -NewName "LAN";
Write-host("IP-adres, subnetmask, Default Gateway en DNS van LAN-adapter worden geconfigureerd. ")
New-NetIPAddress -InterfaceAlias LAN -AddressFamily IPv4 -IPAddress $ip -PrefixLength $snm -DefaultGateway $gw
Write-host("DNS adres wordt geconfigureerd.")
Set-DnsClientServerAddress -InterfaceAlias LAN -ServerAddresses $dns

#Het systeem wordt toegevoegd aan het domein.
Write-Host("Server wordt toegevoegd aan het domein CORONA2020.local")
Add-Computer -DomainName "CORONA2020.local" -Credential (Get-Credential CORONA2020\Administrator)

#Systeem herstarten.
Write-Host("Server wordt herstart.")
shutdown -r -t 10