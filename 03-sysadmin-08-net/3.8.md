# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
route-views>show ip route 213.110.253.125
Routing entry for 213.110.224.0/19, supernet
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 1w1d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 1w1d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
``` 
     
[show ip route 213.110.253.125](bgp.md)<br>

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

```
root@vagrant:~# ip route list
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.0/24 dev eth_dummy proto kernel scope link src 10.0.2.20
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
192.168.0.0/24 dev eth_dummy scope link
192.168.1.0/24 dev eth_dummy proto kernel scope link src 192.168.1.150
```

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

```
vagrant@vagrant:~$ sudo ss -l -t -p
State           Recv-Q          Send-Q                   Local Address:Port                     Peer Address:Port          Process
LISTEN          0               4096                           0.0.0.0:sunrpc                        0.0.0.0:*              users:(("rpcbind",pid=743,fd=4),("systemd",pid=1,fd=35))
LISTEN          0               4096                     127.0.0.53%lo:domain                        0.0.0.0:*              users:(("systemd-resolve",pid=3707,fd=13))
LISTEN          0               128                            0.0.0.0:ssh                           0.0.0.0:*              users:(("sshd",pid=2303,fd=3))
LISTEN          0               4096                                 *:9100                                *:*              users:(("node_exporter",pid=2281,fd=3))
LISTEN          0               4096                              [::]:sunrpc                           [::]:*              users:(("rpcbind",pid=743,fd=6),("systemd",pid=1,fd=37))
LISTEN          0               128                               [::]:ssh                              [::]:*              users:(("sshd",pid=2303,fd=4))
```

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```
vagrant@vagrant:~$ sudo ss -lup
State           Recv-Q          Send-Q                    Local Address:Port                     Peer Address:Port         Process
UNCONN          0               0                         127.0.0.53%lo:domain                        0.0.0.0:*             users:(("systemd-resolve",pid=3707,fd=12))
UNCONN          0               0                               0.0.0.0:bootpc                        0.0.0.0:*             users:(("dhclient",pid=3571,fd=9))
UNCONN          0               0                        10.0.2.15%eth0:bootpc                        0.0.0.0:*             users:(("systemd-network",pid=443,fd=19))
UNCONN          0               0                               0.0.0.0:sunrpc                        0.0.0.0:*             users:(("rpcbind",pid=743,fd=5),("systemd",pid=1,fd=36))
UNCONN          0               0                                  [::]:sunrpc                           [::]:*             users:(("rpcbind",pid=743,fd=7),("systemd",pid=1,fd=38))

```
 
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
<br> [Схема сети](Схема_сети.drawio.png)

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6. Установите Nginx, настройте в режиме балансировщика TCP или UDP.<br>
[nginx](nginx.md)<br>
7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.
