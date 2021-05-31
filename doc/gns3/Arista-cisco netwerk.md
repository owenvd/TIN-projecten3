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
localhost login: admin
localhost>en
localhost#conf t
localhost(config)#zerotouch disable
localhost login: admin
localhost>en
localhost#conf t
localhost(config)#vlan 20
localhost(config-vlan-20)#name servers
localhost(config-vlan-20)#vlan 30
localhost(config-vlan-30)#name personeel
localhost(config-vlan-30)#vlan 40
localhost(config-vlan-40)#name gast
localhost(config-vlan-40)#vlan 50
localhost(config-vlan-50)#name routers

localhost(config)#int vlan 20
localhost(config-if-Vl20)#ip address 192.168.10.193 255.255.255.248
localhost(config-if-Vl20)#no shut
localhost(config-if-Vl20)#int vlan 30
localhost(config-if-Vl30)#ip address 192.168.10.129 255.255.255.192
localhost(config-if-Vl30)#int vlan 40
localhost(config-if-Vl40)#ip address 192.168.10.1 255.255.255.128
localhost(config-if-Vl40)#no shut
localhost(config-if-Vl40)#int vlan 50
localhost(config-if-Vl50)#ip address 192.168.10.201 255.255.255.252
localhost(config-if-Vl50)#no shut


localhost(config)#ip routing


localhost(config-if-Et4)#int e1
localhost(config-if-Et1)#switchport mode trunk
localhost(config-if-Et1)#switchport trunk allowed vlan 20
localhost(config-if-Et1)#int e3
localhost(config-if-Et3)#switchport mode trunk
localhost(config-if-Et3)#switchport trunk allowed vlan 40
localhost(config-if-Et3)#int e2
localhost(config-if-Et2)#switchport mode trunk
localhost(config-if-Et2)#switchport trunk allowed vlan 30
localhost(config-if-Et2)#int e4
localhost(config-if-Et4)#switchport mode trunk
localhost(config-if-Et4)#switchport trunk allowed vlan 50


```
## Router
````bash
R1(config)#int f0/0.50
R1(config-subif)#encapsulation dot1q 50
R1(config-subif)#ip address 192.168.10.202 255.255.255.252
R1(config-subif)#no shut
R1(config-subif)#int f0/1
R1(config-if)#ip address dhcp
R1(config-if)#no shut
R1(config)#int f0/0
R1(config-if)#no shut


R1(config)#ip route 0.0.0.0 0.0.0.0 dhCP
R1(config)#ip route 192.168.10.192 255.255.255.248 192.168.10.201
R1(config)#ip route 192.168.10.128 255.255.255.192 192.168.10.201
R1(config)#ip route 192.168.10.0 255.255.255.128 192.168.10.201
R1(config)#ip route 192.168.10.200 255.255.255.252 192.168.10.201

````
