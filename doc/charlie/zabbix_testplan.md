## Testplan - rainloop

| **auteur testplan** | Moreno Robyn |
| ------------------- | -------------- |
| **uitvoerder test** |                |

## Requirements
- de zabbix agent is beschikbaar
- de zabbix server is beschikbaar 
- de gebruiker kan een remote systeem monitoren
- de webpagina is beschikbaar

## melding

Stappen van Charlie testplan moeten doorlopen zijn voordat men aan dit testplan begint

***Note*** : *bij stap 1 en 2 controleer of de service running is*

### stap 1 : is de zabbix server beschikbaar
commando
```bash

```
Verwacht resultaat
```bash
● zabbix-agent.service - Zabbix Agent
   Loaded: loaded (/usr/lib/systemd/system/zabbix-agent.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-12-13 23:39:14 UTC; 1h 8min ago
 Main PID: 11376 (zabbix_agentd)
    Tasks: 6 (limit: 5046)
   Memory: 3.0M
   CGroup: /system.slice/zabbix-agent.service
           ├─11376 /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf
           ├─11377 /usr/sbin/zabbix_agentd: collector [idle 1 sec]
           ├─11378 /usr/sbin/zabbix_agentd: listener #1 [waiting for connection]
           ├─11379 /usr/sbin/zabbix_agentd: listener #2 [waiting for connection]
           ├─11380 /usr/sbin/zabbix_agentd: listener #3 [waiting for connection]
           └─11381 /usr/sbin/zabbix_agentd: active checks #1 [idle 1 sec]

Dec 13 23:39:14 charlie systemd[1]: Stopped Zabbix Agent.
Dec 13 23:39:14 charlie systemd[1]: Starting Zabbix Agent...
Dec 13 23:39:14 charlie systemd[1]: zabbix-agent.service: Can't open PID file /run/zabbix/zabbix_agentd.pid (yet?) after start: No such file or directory
Dec 13 23:39:14 charlie systemd[1]: Started Zabbix Agent.
```
 resultaat
```bash
```
### stap 2 : is de zabbix agent beschikbaar
commando
```bash
 sudo systemctl status zabbix-server.service
```
Verwacht resultaat
```bash
● zabbix-server.service - Zabbix Server
   Loaded: loaded (/usr/lib/systemd/system/zabbix-server.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-12-14 00:15:02 UTC; 30min ago
  Process: 27347 ExecStop=/bin/kill -SIGTERM $MAINPID (code=exited, status=0/SUCCESS)
  Process: 27349 ExecStart=/usr/sbin/zabbix_server -c $CONFFILE (code=exited, status=0/SUCCESS)
 Main PID: 27352 (zabbix_server)
    Tasks: 38 (limit: 5046)
   Memory: 52.2M
   CGroup: /system.slice/zabbix-server.service
           ├─27352 /usr/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf
           ├─27383 /usr/sbin/zabbix_server: configuration syncer [synced configuration in 0.035819 sec, idle 60 sec]
           ├─27418 /usr/sbin/zabbix_server: housekeeper [deleted 0 hist/trends, 0 items/triggers, 0 events, 0 sessions, 0 alarms, 0 audit items, 0 records in 0.197226 sec, idle for 1 hour(s)]
           ├─27419 /usr/sbin/zabbix_server: timer #1 [updated 0 hosts, suppressed 0 events in 0.000613 sec, idle 59 sec]
           ├─27420 /usr/sbin/zabbix_server: http poller #1 [got 0 values in 0.000723 sec, getting values]
           ├─27421 /usr/sbin/zabbix_server: discoverer #1 [processed 0 rules in 0.000664 sec, idle 60 sec]
           ├─27422 /usr/sbin/zabbix_server: history syncer #1 [processed 0 values, 0 triggers in 0.000050 sec, idle 1 sec]
           ├─27423 /usr/sbin/zabbix_server: history syncer #2 [processed 0 values, 0 triggers in 0.000010 sec, idle 1 sec]
           ├─27424 /usr/sbin/zabbix_server: history syncer #3 [processed 0 values, 0 triggers in 0.000012 sec, idle 1 sec]
           ├─27425 /usr/sbin/zabbix_server: history syncer #4 [processed 2 values, 1 triggers in 0.002211 sec, idle 1 sec]
           ├─27426 /usr/sbin/zabbix_server: escalator #1 [processed 0 escalations in 0.001113 sec, idle 3 sec]
           ├─27427 /usr/sbin/zabbix_server: proxy poller #1 [exchanged data with 0 proxies in 0.000045 sec, idle 5 sec]
           ├─27428 /usr/sbin/zabbix_server: self-monitoring [processed data in 0.000051 sec, idle 1 sec]
           ├─27429 /usr/sbin/zabbix_server: task manager [processed 0 task(s) in 0.000506 sec, idle 5 sec]
           ├─27430 /usr/sbin/zabbix_server: poller #1 [got 0 values in 0.000048 sec, idle 1 sec]
           ├─27431 /usr/sbin/zabbix_server: poller #2 [got 0 values in 0.000050 sec, idle 1 sec]
           ├─27432 /usr/sbin/zabbix_server: poller #3 [got 1 values in 0.000355 sec, idle 1 sec]
           ├─27433 /usr/sbin/zabbix_server: poller #4 [got 0 values in 0.000055 sec, idle 1 sec]
           ├─27434 /usr/sbin/zabbix_server: poller #5 [got 0 values in 0.000010 sec, idle 1 sec]
           ├─27435 /usr/sbin/zabbix_server: unreachable poller #1 [got 0 values in 0.000057 sec, idle 5 sec]
           ├─27436 /usr/sbin/zabbix_server: trapper #1 [processed data in 0.000000 sec, waiting for connection]
           ├─27437 /usr/sbin/zabbix_server: trapper #2 [processed data in 0.000000 sec, waiting for connection]
           ├─27438 /usr/sbin/zabbix_server: trapper #3 [processed data in 0.000000 sec, waiting for connection]
           ├─27439 /usr/sbin/zabbix_server: trapper #4 [processing data]
           ├─27440 /usr/sbin/zabbix_server: trapper #5 [processed data in 0.000000 sec, waiting for connection]
           ├─27441 /usr/sbin/zabbix_server: icmp pinger #1 [got 0 values in 0.000053 sec, idle 5 sec]
           ├─27442 /usr/sbin/zabbix_server: alert manager #1 [sent 0, failed 0 alerts, idle 5.005981 sec during 5.006069 sec]
           ├─27443 /usr/sbin/zabbix_server: alerter #1 started
           ├─27444 /usr/sbin/zabbix_server: alerter #2 started
           ├─27445 /usr/sbin/zabbix_server: alerter #3 started
           ├─27447 /usr/sbin/zabbix_server: preprocessing manager #1 [queued 0, processed 4 values, idle 5.002667 sec during 5.002805 sec]
           ├─27448 /usr/sbin/zabbix_server: preprocessing worker #1 started
           ├─27449 /usr/sbin/zabbix_server: preprocessing worker #2 started
           ├─27450 /usr/sbin/zabbix_server: preprocessing worker #3 started
           ├─27451 /usr/sbin/zabbix_server: lld manager #1 [processed 0 LLD rules during 5.008140 sec]
           ├─27452 /usr/sbin/zabbix_server: lld worker #1 started
           ├─27453 /usr/sbin/zabbix_server: lld worker #2 started
           └─27454 /usr/sbin/zabbix_server: alert syncer [queued 0 alerts(s), flushed 0 result(s) in 0.000788 sec, idle 1 sec]

Dec 14 00:15:02 charlie systemd[1]: Stopped Zabbix Server.
Dec 14 00:15:02 charlie systemd[1]: Starting Zabbix Server...
Dec 14 00:15:02 charlie systemd[1]: zabbix-server.service: Can't open PID file /run/zabbix/zabbix_server.pid (yet?) after start: No such file or directory
Dec 14 00:15:02 charlie systemd[1]: Started Zabbix Server.
```
 resultaat
```bash
```
### stap 3 : is de zabbix web beschikbaar
- ga naar zabbix.corona2020.local in een webbrowser

Verwacht resultaat
![Image from Gyazo](https://i.gyazo.com/8c04cac0257c7da52ba8b813debc0fd1.png)
 
 resultaat


### stap 4 : kan men een remote systeem monitoren
***note*** : *voordat u hier aan begint volg de stappen in* [zabbix_config](/zabbix_config.md)

- log in op zabbix
- ga naar host in monitoring
- klik op een host naar keuze
- en selecteer graphs

Verwacht resultaat
![Image from Gyazo](https://i.gyazo.com/142b36bd555283b2700bd9517b3e13ed.png)

 resultaat
