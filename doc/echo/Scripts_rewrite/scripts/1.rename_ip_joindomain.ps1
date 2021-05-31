$domain = "kelvin.periode3"
$password = "P@ssw0rd" | ConvertTo-SecureString -asPlainText -Force
$joindomainuser = "Administrator"
$ip = [IPAddress]"192.168.100.194".Trim()
$dns = [IPAddress]"192.168.10.195".Trim()
$gw = [IPAddress]"192.168.10.193".Trim()
$name = "echo"

Clear-Host;
Import-Module ServerManager;
Import-Module PackageManagement;

write-host ("---------------------------------------------------------------")

#Ethernet adapters worden aangepast met zijn juiste settings.
Write-host("Netwerkadapter Ethernet heeft nieuwe naamgeving,LAN.");
Rename-NetAdapter -Name "Ethernet" -NewName "LAN";
Write-host("Ip,subnet,default gateway, DNS van LAN adapter worden aangepast. ")
New-NetIPAddress -InterfaceAlias LAN -AddressFamily IPv4 -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
Write-host("DNS adres wordt ingesteld")
Set-DnsClientServerAddress -InterfaceAlias LAN -ServerAddresses $dns

write-host ("---------------------------------------------------------------")


  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] “Administrator”))

    {
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
        Break
    }


$username = "$domain\$joindomainuser" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

try{
     Add-Computer -DomainName $domain -Credential $credential -ErrorAction Stop
     Restart-Computer
}

catch{
    Write-Host "Oops, we couldn't join the Domain, here is the error:" -fore red
    $_   # error output
}

finally{
    Write-Host 'Finishing script...' -fore green
}

write-host ("---------------------------------------------------------------")

#Het systeem krijgt de naam: $name.
Write-Host("Server wordt hernoemd naar $name")
Rename-Computer -NewName $name
Start-Sleep -s 30

write-host ("---------------------------------------------------------------")

#Systeem herstarten.
Write-Host("Server wordt herstart.")
Restart-computer