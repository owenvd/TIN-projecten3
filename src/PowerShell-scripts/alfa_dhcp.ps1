# Installeer DHCP met Management Tools
Install-WindowsFeature DHCP -IncludeManagementTools

# Voeg de DHCP-server toe aan de Active Directory
Add-DhcpServerInDC -DnsName alfa.CORONA2020.local -IPAddress 192.168.10.194


# Maak een ipv4 scope
Add-DhcpServerv4Scope -Name "Gast- en Personeelsnetwerk" -StartRange 192.168.10.2 -EndRange 192.168.10.190 -SubnetMask 255.255.255.0 -State Active
# Maak een exclusion range voor het broadcastadres, netwerkadres en gateway
Add-Dhcpserverv4ExclusionRange -ScopeId 192.168.10.2 -StartRange 192.168.10.127 -EndRange 192.168.10.129
# Geef DNS en default gateway mee via DHCP
Set-DhcpServerV4OptionValue -ComputerName alfa.CORONA2020.local -ScopeID 192.168.10.2 -DNSServer 192.168.10.195 -Router 192.168.10.1


# Maak een ipv6 scope voor het personeelsnetwerk
Add-DhcpServerv6Scope -Prefix 0000:ffff:c0a8:a00:: -Name "Personeel" -State Active
# Maak een ipv6 scope voor het gastnetwerk
Add-DhcpServerv6Scope -Prefix 0000:ffff:c0a8:a01:: -Name "Gastnetwerk" -State Active

# Geef DNS en default gateway mee via ipv6 DHCP (Personeel)
Set-DhcpServerV6OptionValue -ComputerName alfa.CORONA2020.local -Prefix 0000:ffff:c0a8:a00:: -DnsServer ::ffff:c0a8:ac3
# Geef DNS en default gateway mee via ipv6 DHCP (Gastnetwerk)
Set-DhcpServerV6OptionValue -ComputerName alfa.CORONA2020.local -Prefix 0000:ffff:c0a8:a01:: -DnsServer ::ffff:c0a8:ac3

