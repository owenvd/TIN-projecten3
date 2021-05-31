```bash
vIOS-L2-01#show run
Building configuration...

Current configuration : 6225 bytes
!
! Last configuration change at 23:38:25 UTC Sat Dec 5 2020
!
version 15.0
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
service compress-config
!
hostname vIOS-L2-01
!
boot-start-marker
boot-end-marker
!
!
!
no aaa new-model
!
!
!
!
!
vtp domain CISCO-vIOS
vtp mode transparent
!
!
!
ip cef
no ipv6 cef
!
!
spanning-tree mode pvst
spanning-tree extend system-id
!
vlan internal allocation policy ascending
!
vlan 20
 name servers
!
vlan 100
 name VLAN100
!
vlan 200,300
!
!
!
!
!
!
!
!
!
!
!
!
!
interface GigabitEthernet0/0
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 20
 switchport mode trunk
 media-type rj45
 negotiation auto
!
interface GigabitEthernet0/1
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet0/2
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet0/3
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet1/0
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet1/1
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet1/2
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet1/3
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet2/0
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet2/1
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet2/2
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet2/3
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet3/0
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet3/1
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet3/2
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
interface GigabitEthernet3/3
 switchport access vlan 20
 media-type rj45
 negotiation auto
!
ip forward-protocol nd
!
no ip http server
no ip http secure-server
!
!
!
!
!
!
control-plane
!
banner exec ^C
**************************************************************************
* IOSv - Cisco Systems Confidential                                      *
*                                                                        *
* This software is provided as is without warranty for internal          *
* development and testing purposes only under the terms of the Cisco     *
* Early Field Trial agreement.  Under no circumstances may this software *
* be used for production purposes or deployed in a production            *
* environment.                                                           *
*                                                                        *
* By using the software, you agree to abide by the terms and conditions  *
* of the Cisco Early Field Trial Agreement as well as the terms and      *
* conditions of the Cisco End User License Agreement at                  *
* http://www.cisco.com/go/eula                                           *
*                                                                        *
* Unauthorized use or distribution of this software is expressly         *
* Prohibited.                                                            *
**************************************************************************^C
banner incoming ^C
**************************************************************************
* IOSv - Cisco Systems Confidential                                      *
*                                                                        *
* This software is provided as is without warranty for internal          *
* development and testing purposes only under the terms of the Cisco     *
* Early Field Trial agreement.  Under no circumstances may this software *
* be used for production purposes or deployed in a production            *
* environment.                                                           *
*                                                                        *
* By using the software, you agree to abide by the terms and conditions  *
* of the Cisco Early Field Trial Agreement as well as the terms and      *
* conditions of the Cisco End User License Agreement at                  *
* http://www.cisco.com/go/eula                                           *
*                                                                        *
* Unauthorized use or distribution of this software is expressly         *
* Prohibited.                                                            *
**************************************************************************^C
banner login ^C
**************************************************************************
* IOSv - Cisco Systems Confidential                                      *
*                                                                        *
* This software is provided as is without warranty for internal          *
* development and testing purposes only under the terms of the Cisco     *
* Early Field Trial agreement.  Under no circumstances may this software *
* be used for production purposes or deployed in a production            *
* environment.                                                           *
*                                                                        *
* By using the software, you agree to abide by the terms and conditions  *
* of the Cisco Early Field Trial Agreement as well as the terms and      *
* conditions of the Cisco End User License Agreement at                  *
* http://www.cisco.com/go/eula                                           *
*                                                                        *
* Unauthorized use or distribution of this software is expressly         *
* Prohibited.                                                            *
**************************************************************************^C
!
line con 0
 logging synchronous
line aux 0
line vty 0 4
 logging synchronous
 login
line vty 5 15
 logging synchronous
 login
!
!
end

```
