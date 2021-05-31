
## Laag 3 switch instellingen

 - log in op de switch (c3600)  via console 
 - maak de vlans als volgt aan
	
	````◙
    vlan database
    vlan 20 name servers
    vlan 30 name personeel
    vlan 40 name gast
    vlan 50 name router
	exit
   ```` 

 - zet de vtp server aan
	 ````
    ESW1(vlan)#vtp server
    ESW1(vlan)#vtp domain corona2020.local
    ESW1(vlan)#vtp password corona
    ESW1(vlan)#exit
	 ````
 - configureer inter-vlan routing
	````
    ESW1#conf t
    ESW1(config)#int vlan 20
    ESW1(config-if)#ip address 192.168.10.193 255.255.255.248
    ESW1(config-if)#no shutdown
    ESW1(config-if)#int vlan 30
    ESW1(config-if)#ip address 192.168.10.129 255.255.255.192
    ESW1(config-if)#no shutdown
    ESW1(config-if)#int vlan 40
    ESW1(config-if)#ip address 192.168.10.1 255.255.255.128
    ESW1(config-if)#no shutdown
    ESW1(config-if)#int vlan 50
    ESW1(config-if)#ip address 192.168.10.201 255.255.255.252
    ESW1(config-if)#no shutdown
    ````
 - configureer de default route
	 ````
	 ESW1(config)#ip route 0.0.0.0 0.0.0.0 192.168.10.202
	 ````
 - configureer de Trunk verbindingen
	 ````
    ESW1(config)#int f0/0
    ESW1(config-if)#switchport mode trunk
    ESW1(config-if)#switchport trunk allowed vlan 1-2,20,1002-1005
    ESW1(config-if)#int f0/1
    ESW1(config-if)#switchport mode trunk
    ESW1(config-if)#switchport trunk allowed vlan 1-2,30,1002-1005
    ESW1(config-if)#int f0/2
    ESW1(config-if)#switchport mode trunk
    ESW1(config-if)#switchport trunk allowed vlan 1-2,30,1002-1005
    *Mar  1 01:50:56.479: %DTP-5-TRUNKPORTON: Port Fa0/2 has become dot1q trunk
    ESW1(config-if)#switchport trunk allowed vlan 1-2,40,1002-1005
	  ````

## Laag 2 switch instellingen
- Verander alle switches naar vtp clients
	 ````
	 ````
