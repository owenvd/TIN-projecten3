## Netwerk - IPv4
| Naam  |Netwerk Address  |broadcast| range | mask |wildcard|Hosts|Gateway
|---|---|---|---|---|---|---|---|
|Vlan 20  | 192.168.10.192 |192.168.10.199|192.168.10.193 - 192.168.10.198|255.255.255.248|0.0.0.7|6|192.168.10.193
|Vlan 30  | 192.168.10.128 |192.168.10.191|192.168.10.129 - 192.168.10.190|255.255.255.192|0.0.0.63|62|192.168.10.129
|Vlan 40  | 192.168.10.0 |192.168.10.127|192.168.10.1 - 192.168.10.126|255.255.255.128|0.0.0.127|126|192.168.10.1
|Vlan 50  | 192.168.10.200 |192.168.10.203|192.168.10.201 - 192.168.10.202|255.255.255.252|0.0.0.3|2|192.168.10.201
|Vlan 99  | 192.168.10.224 |192.168.10.239|192.168.10.225 - 192.168.10.238|255.255.255.240|0.0.0.15|14|192.168.10.225

## Netwerk - IPv6

| Naam  |Netwerk Address| range | mask |wildcard|Hosts|Gateway
|---|---|---|---|---|---|---|
|Vlan 20  | ::ffff:c0a8:ac0 |::ffff:c0a8:ac1 - ::ffff:c0a8:ac6|/125|/3|6|::ffff:c0a8:ac1
|Vlan 30  | 0000:ffff:c0a8:a00:: |0000:ffff:c0a8:a00::1 - 0000:ffff:c0a8:a00:ffff:ffff:ffff:ffff|/64|/64| |0000:ffff:c0a8:a00::1
|Vlan 40  | 0000:ffff:c0a8:a01:: |0000:ffff:c0a8:a01::1 - 0000:ffff:c0a8:a01:ffff:ffff:ffff:ffff|/64|/64| |0000:ffff:c0a8:a01::1
|Vlan 50  | ::ffff:c0a8:ac8 |::ffff:c0a8:ac9 - ::ffff:c0a8:aca|/126|/2|2|::ffff:c0a8:ac9
|Vlan 99  | ::ffff:c0a8:ae0 |::ffff:c0a8:ae1 - ::ffff:c0a8:aee|/124|/4|14|::ffff:c0a8:ae1

## Servers

| Naam  | IPv4|IPv6  |Fully Qualified Domain Name|DNS | rol|OS
|--|--|--|--|--|--|--|
|Alfa|192.168.10.194|::ffff:c0a8:ac2|alfa.CORONA2020.local|alfa|DC|Windows server 2019
|Bravo|192.168.10.195|::ffff:c0a8:ac3|bravo.CORONA2020.local|bravo|DNS|CentOS 8
|Charlie|192.168.10.196|::ffff:c0a8:ac4|Charlie.CORONA2020.local|charlie|Web-server|CentOS 8
|Delta|192.168.10.197|::ffff:c0a8:ac5|delta.CORONA2020.local|delta|Mail-server|CentOS 8
|Echo|192.168.10.198|::ffff:c0a8:ac6|echo.CORONA2020.local|echo|SCCM|Windows server 2019


## Documentatie

1. Omzetten van IPv4 adressen naar IPv6 adressen met tool:
https://dnschecker.org/ipv4-to-ipv6.php 

2. Probleem: DHCPv6 scopes geven foutmelding DHCP 20091:
https://docs.microsoft.com/en-us/previous-versions/windows/desktop/dhcp/dhcp-server-management-api-error-codes 
```
ERROR_DHCP_INVALID_SUBNET_PREFIX

20091

Windows 7 or later: The given subnet prefix is invalid. It represents either a non-unicast or link local address range.
```
- Na handmatig proberen toevoegen van DHCPv6 scope blijkt dat deze een /64 suffix vereist. We passen dus Vlan 30 en 40 aan om hieraan te voldoen.