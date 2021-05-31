
## Laag 2 switches
````bash
vIOS-L2-01>en
vIOS-L2-01#conf t
vIOS-L2-01(config)#vlan 20
vIOS-L2-01(config-vlan)#name servers
vIOS-L2-01(config-vlan)#int range g0/1-3,g1/0-3,g2/0-3,g3/0-3
vIOS-L2-01(config-if-range)#switchport mode access
vIOS-L2-01(config-if-range)#switchport access vlan 20
vIOS-L2-01(config-if-range)#no shut
vIOS-L2-01(config)#int g0/0
vIOS-L2-01(config-if)#switchport trunk encapsulation dot1q
vIOS-L2-01(config-if)#switchport mode trunk
vIOS-L2-01(config-if)#switchport trunk allowed vlan 20
````

````bash
vIOS-L2-01>en
vIOS-L2-01#conf t
vIOS-L2-01(config)#vlan 30
vIOS-L2-01(config-vlan)#name personeel
vIOS-L2-01(config-vlan)#int range g0/1-3,g1/0-3,g2/0-3,g3/0-3
vIOS-L2-01(config-if-range)#switchport mode access
vIOS-L2-01(config-if-range)#switchport access vlan 30
vIOS-L2-01(config-if-range)#no shut
vIOS-L2-01(config)#int g0/0
vIOS-L2-01(config-if)#switchport trunk encapsulation dot1q
vIOS-L2-01(config-if)#switchport mode trunk
vIOS-L2-01(config-if)#switchport trunk allowed vlan 30
````

```bash
vIOS-L2-01>en
vIOS-L2-01#conf t
vIOS-L2-01(config)#vlan 40
vIOS-L2-01(config-vlan)#name gast
vIOS-L2-01(config-vlan)#int range g0/1-3,g1/0-3,g2/0-3,g3/0-3
vIOS-L2-01(config-if-range)#switchport mode access
vIOS-L2-01(config-if-range)#switchport access vlan 40
vIOS-L2-01(config-if-range)#no shut
vIOS-L2-01(config)#int g0/0
vIOS-L2-01(config-if)#switchport trunk encapsulation dot1q
vIOS-L2-01(config-if)#switchport mode trunk
vIOS-L2-01(config-if)#switchport trunk allowed vlan 40
```
## Multilayer switch
```bash
cumulus@cumulus:mgmt:~$ net add bridge bridge ports swp1-4
cumulus@cumulus:mgmt:~$ net add bridge bridge vids 20,30,40,50
cumulus@cumulus:mgmt:~$ net add bridge bridge pvid 1
cumulus@cumulus:mgmt:~$ net pending
cumulus@cumulus:mgmt:~$ net commit

cumulus@cumulus:mgmt:~$ net add vlan 20 ip address 192.168.10.193/29
cumulus@cumulus:mgmt:~$ net add vlan 30 ip address 192.168.10.129/26
cumulus@cumulus:mgmt:~$ net add vlan 40 ip address 192.168.10.1/25
cumulus@cumulus:mgmt:~$ net add vlan 50 ip address 192.168.10.201/30
cumulus@cumulus:mgmt:~$ net pending
cumulus@cumulus:mgmt:~$ net commit

cumulus@switch:~$ net add routing route 0.0.0.0/0 192.168.10.202
cumulus@switch:~$ net pending
cumulus@switch:~$ net commit

cumulus@cumulus:mgmt:~$ net add acl ipv4 DENYGAST drop source-ip 192.168.10.0/25 dest-ip any 
cumulus@cumulus:mgmt:~$ net commit
cumulus@cumulus:mgmt:~$ net add vlan 20 acl ipv4 DENYGAST outbound
cumulus@cumulus:mgmt:~$ net commit

cumulus@cumulus:mgmt:~$ net add dhcp relay interface vlan30
cumulus@cumulus:mgmt:~$ net add dhcp relay interface vlan40
cumulus@cumulus:mgmt:~$ net add dhcp relay server 192.168.10.194
cumulus@cumulus:mgmt:~$ net pending
cumulus@cumulus:mgmt:~$ net commit

cumulus@cumulus:mgmt:~$ sudo systemctl enable dhcrelay.service
cumulus@cumulus:mgmt:~$ sudo systemctl restart dhcrelay.service

cumulus@cumulus:mgmt:~$ net add vlan 20 ipv6-addrgen off
cumulus@cumulus:mgmt:~$ net add vlan 30 ipv6-addrgen off
cumulus@cumulus:mgmt:~$ net add vlan 40 ipv6-addrgen off
cumulus@cumulus:mgmt:~$ net add vlan 50 ipv6-addrgen off
cumulus@cumulus:mgmt:~$ net pending
cumulus@cumulus:mgmt:~$ net commit

```
## Router
````bash
R1(config)#int f0/0.50
R1(config-subif)#encapsulation dot1q 50
R1(config-subif)#ip address 192.168.10.202 255.255.255.252
R1(config-subif)#ip nat inside
R1(config-subif)#no shut
R1(config-subif)#int f0/1
R1(config-if)#ip address dhcp
R1(config-if)#ip nat outside
R1(config-if)#no shut
R1(config)#int f0/0
R1(config-if)#no shut

R1(config)#ip route 0.0.0.0 0.0.0.0 dhCP
R1(config)#ip route 192.168.10.192 255.255.255.248 192.168.10.201
R1(config)#ip route 192.168.10.128 255.255.255.192 192.168.10.201
R1(config)#ip route 192.168.10.0 255.255.255.128 192.168.10.201
R1(config)#ip route 192.168.10.200 255.255.255.252 192.168.10.201

R1(config)#access-list 1 permit 192.168.0.0 0.0.255.255
R1(config)#ip nat inside source list 1 interface f0/1 overload
````
