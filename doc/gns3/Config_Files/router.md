```bash
R1#show run
Building configuration...

Current configuration : 1449 bytes
!
upgrade fpd auto
version 12.4
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
!
hostname R1
!
boot-start-marker
boot-end-marker
!
logging message-counter syslog
!
no aaa new-model
ip source-route
no ip icmp rate-limit unreachable
ip cef
!
!
!
!
no ip domain lookup
no ipv6 cef
!
multilink bundle-name authenticated
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
!
!
!
archive
 log config
  hidekeys
!
!
!
!
!
ip tcp synwait-time 5
!
!
!
!
interface FastEthernet0/0
 no ip address
 duplex auto
 speed auto
!
interface FastEthernet0/0.50
 encapsulation dot1Q 50
 ip address 192.168.10.202 255.255.255.252
 ip nat inside
 ip virtual-reassembly
!
interface FastEthernet0/1
 ip address dhcp
 ip nat outside
 ip virtual-reassembly
 duplex auto
 speed auto
!
ip forward-protocol nd
ip route 192.168.10.0 255.255.255.128 192.168.10.201
ip route 192.168.10.128 255.255.255.192 192.168.10.201
ip route 192.168.10.192 255.255.255.248 192.168.10.201
ip route 0.0.0.0 0.0.0.0 dhcp
no ip http server
no ip http secure-server
!
!
ip nat inside source list 1 interface FastEthernet0/1 overload
!
access-list 1 permit 192.168.0.0 0.0.255.255
no cdp log mismatch duplex
!
!
!
!
!
!
control-plane
!
!
!
!
!
!
!
gatekeeper
 shutdown
!
!
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line vty 0 4
 login
!
end

```
