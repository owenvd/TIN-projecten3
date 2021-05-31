```bash
cumulus@cumulus:mgmt:~$ net show configuration

dns

  nameserver
    10.0.2.3 # vrf mgmt

time

  zone
    Etc/UTC

snmp-server
  listening-address localhost

ptp

  global

    slaveOnly
      0

    priority1
      255

    priority2
      255

    domainNumber
      0

    logging_level
      5

    path_trace_enabled
      0

    use_syslog
      1

    verbose
      0

    summary_interval
      0

    time_stamping
      hardware

frr version 7.4+cl4u1

frr defaults datacenter

hostname cumulus

log syslog informational

zebra nexthop proto only

service integrated-vtysh-config

line vty

ip route 0.0.0.0/0 192.168.10.202
interface lo
  # The primary network interface

interface eth0
  address dhcp
  vrf mgmt

interface swp1

interface swp4
  

interface bridge
  bridge-ports swp2 swp3 swp4 swp1
  bridge-pvid 1
  bridge-vids 20 30 40 50
  bridge-vlan-aware yes

interface mgmt
  address 127.0.0.1/8
  address ::1/128
  vrf-table auto

interface vlan20
  address 192.168.10.193/29
  vlan-id 20
  vlan-raw-device bridge
  acl ipv4 DENYGAST outbound

interface vlan30
  address 192.168.10.129/26
  vlan-id 30
  vlan-raw-device bridge

interface vlan40
  address 192.168.10.1/25
  vlan-id 40
  vlan-raw-device bridge

interface vlan50
  address 192.168.10.201/30
  vlan-id 50
  vlan-raw-device bridge

acl ipv4 DENYGAST priority 10 drop source-ip 192.168.10.192/29 dest-ip 192.168.10.0/25
acl ipv4 DENYGAST priority 20 drop source-ip 192.168.10.0/25 dest-ip any

dot1x
  mab-activation-delay 30
  default-dacl-preauth-filename default_preauth_dacl.rules
  eap-reauth-period 0

  radius
    accounting-port 1813
    authentication-port 1812


# The above output is a summary of the configuration state of the switch.
# Do not cut and paste this output into /etc/network/interfaces or any other
# configuration file.  This output is intended to be used for troubleshooting
# when you need to see a summary of configuration settings.
#
# Please use "net show configuration commands" for a configuration that
# you can back up or copy and paste into a new device.
```
