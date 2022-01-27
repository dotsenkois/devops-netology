# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?<br>

[Get-NetAdapter](Get-NetAdapter.md)<br>
[ipconfig](ipconfig.md)<br>
[ip address](ip_address.md)<br>
[ifconfig](ifconfig.md)<br>

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?<br>
```
Протокол LLDP. Пакет программ - lldpd

```
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.<br>
```
Технология VLAN. Пакет vlan. 
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

|mode						|Балансировка нагрузки	|
|---------------------------|-----------------------|
| balance-rr       или 0	|+|
| active-backup или 1  		||
| balance-xor    или 2 		|+|
| broadcast       или 3 	||
| 802.3ad           или 4 	||
| balance-tlb     или 5		|+|
| balance-alb    или 6		|+|

```
  GNU nano 4.8                                                     /etc/network/interfaces  # interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto bond0
iface bond0 inet dhcp
        bond-slaves eth0 eth1
        bond-mode 0
        bond-primary eth0 eth1

auto eth0
        iface eht0 inet manual
        bond master bond0
        bond-primary eth0 eth1

auto eth1
        iface eht0 inet manual
        bond master bond0
        bond-primary eth0 eth1
```

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
```
В сети с маской /29 8 ip адресов. Мжно получить 32 посдети /29 из сети /24.
```
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.<br>
```
Допустимо использовать сеть 100.64.0.0/26
```

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?<br>
```
windows:
arp -a				просмотр таблицы
arp -d *			очистка всей таблицы
arp -d ip_address	удалить одну пару ip-mac
linux:
ip neighbor				просмотр таблицы
ip neighbor	-d		очистка всей таблицы
arp -d ip_address	удалить одну пару ip-mac

```