# Hernoem de server naar alfa
Rename-Computer -NewName "alfa" -force

# Statisch IP-adres instellen 
netsh interface ipv4 set address name="Ethernet 2" source=static address=192.168.10.194 mask=255.255.255.248 gateway=192.168.10.193
# IP-adres DNS-Server instellen
netsh interface ipv4 add dnsserver name="Ethernet 2" address=192.168.10.195 index=1 

# Automatisch inloggen bij herstarten
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = "Administrator"
$DefaultPassword = "Admin1"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
# De server herstarten om de configuratie door te voeren
shutdown -r -t 5
