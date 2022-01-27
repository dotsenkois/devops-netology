# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
## Ответ 1
- [Установка и запуск node_exporter. Вывод метрик.](1.md)
- [node_exporter.servise](node_exporter.servise.md) 

1. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

## Ответ 2
```
cpu	Exposes CPU statistics
cpufreq	Exposes CPU frequency statistics
diskstats	Exposes disk I/O statistics.
loadavg	Exposes load average.
netstat	Exposes network statistics from /proc/net/netstat. This is the same information as netstat -s.
meminfo	Exposes memory statistics.
```

2. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
## Ответ 3
<p align = center>
<img src = ./03.netdata_monitoring.png >
<p>
03.netdata_monitoring.png

1. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

## Ответ 4
```
vagrant@vagrant:~$ dmesg | grep Hyper
[    0.000000] Hypervisor detected: KVM
```
3. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

## Ответ 5
```
 sysctl fs.nr_open - ограничение одноврменно открытых файлов.sysctl fs.nr_open
*fs.nr_open = 1048576*Данное оганичение являе6тся жестким (аппаратным?) - hardlimitulimit -aH |grep files
*open files                      (-n) 1048576*Его не позволяет достичь мягкое ограничение (программное?) - softlimitulimit -aS |grep files
*open files                      (-n) 1024*
```

4. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

## Ответ 6
Запуск и проверка процесса в отдлельном неймспейсе:
```
tty1:root@vagrant:/home/vagrant# unshare -f --pid --mount-proc sleep 1h
tty2:root@vagrant:/home/vagrant# ps aux |grep sleep
root        2221  0.0  0.0   8076   528 ?        S    10:46   0:00 /bin sleep 1h
root        2250  0.0  0.0   8076   520 ?        S    10:47   0:00 /bin sleep 1h
root        2388  0.0  0.0   8076   596 ?        S    10:52   0:00 /bin sleep 1h
root        2513  0.0  0.0   8080   592 pts/3    T    11:00   0:00 unshare -f --pid --mount-proc sleep 1h
root        2514  0.0  0.0   8076   596 pts/3    S    11:00   0:00 slee  1h
root        2520  0.0  0.0   8080   592 pts/3    S+   11:01   0:00 unshare -f --pid --mount-proc sleep 1h
root        2521  0.0  0.0   8076   580 pts/3    S+   11:01   0:00 slee  1h
root        2591  0.0  0.0   8900   736 pts/5    S+   11:03   0:00 grep --color=auto sleep
root@vagrant:/home/vagrant# nsenter --target 2521 --pid --mount
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   8076   580 pts/3    S+   11:01   0:00 sleep
root           2  0.2  0.4   9836  4292 pts/5    S    11:03   0:00 -bash
root          12  0.0  0.3  11492  3488 pts/5    R+   11:03   0:00 ps au
```

5. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
   
## Ответ 
:(){ :|:& };: -Вызов функции с именем ':', аргументами (), телом { :|:& }, где происходит рекусривыный вызов функции дважды в конвейере. ';' - конец команды. ':' вызов функции еще раз При вызове этой функции проиходит зацикливание с выводом  *-bash: fork: retry: Resource temporarily unavailable*

6. [Установка и запуск node_exporter. Вывод метрик.](1.md) <br>[node_exporter.servise](node_exporter.servise.md) 

7. cpu	Exposes CPU statistics<br>
cpufreq	Exposes CPU frequency statistics<br>
diskstats	Exposes disk I/O statistics.<br>
loadavg	Exposes load average.<br>
netstat	Exposes network statistics from /proc/net/netstat. This is the same information as netstat -s.<br>
meminfo	Exposes memory statistics.<br>

3. [Сриншот](https://disk.yandex.ru/i/-oeJmyyhxJB6AA)
4. Вывод dmesg:
```
vagrant@vagrant:~$ dmesg | grep Hyper
[    0.000000] Hypervisor detected: KVM
```
5. sysctl fs.nr_open - ограничение одноврменно открытых файлов.sysctl fs.nr_open
*fs.nr_open = 1048576*Данное оганичение является жестким (аппаратным?) - hardlimitulimit -aH |grep files
*open files                      (-n) 1048576*Его не позволяет достичь мягкое ограничение (программное?) - softlimitulimit -aS |grep files
*open files                      (-n) 1024*
6. Запуск и проверка процесса в отдлельном неймспейсе:
```
tty1:root@vagrant:/home/vagrant# unshare -f --pid --mount-proc sleep 1h
tty2:root@vagrant:/home/vagrant# ps aux |grep sleep
root        2221  0.0  0.0   8076   528 ?        S    10:46   0:00 /bin sleep 1h
root        2250  0.0  0.0   8076   520 ?        S    10:47   0:00 /bin sleep 1h
root        2388  0.0  0.0   8076   596 ?        S    10:52   0:00 /bin sleep 1h
root        2513  0.0  0.0   8080   592 pts/3    T    11:00   0:00 unshare -f --pid --mount-proc sleep 1h
root        2514  0.0  0.0   8076   596 pts/3    S    11:00   0:00 slee  1h
root        2520  0.0  0.0   8080   592 pts/3    S+   11:01   0:00 unshare -f --pid --mount-proc sleep 1h
root        2521  0.0  0.0   8076   580 pts/3    S+   11:01   0:00 slee  1h
root        2591  0.0  0.0   8900   736 pts/5    S+   11:03   0:00 grep --color=auto sleep
root@vagrant:/home/vagrant# nsenter --target 2521 --pid --mount
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   8076   580 pts/3    S+   11:01   0:00 sleep
root           2  0.2  0.4   9836  4292 pts/5    S    11:03   0:00 -bash
root          12  0.0  0.3  11492  3488 pts/5    R+   11:03   0:00 ps au
```
7. :(){ :|:& };: -Вызов функции с именем ':', аргументами (), телом { :|:& }, где происходит рекусривыный вызов функции дважды в конвейере. ';' - конец команды. ':' вызов функции еще раз При вызове этой функции проиходит зацикливание с выводом  *-bash: fork: retry: Resource temporarily unavailable*<br>
вывод dmesg:
```
vagrant@vagrant:~$ dmesg| grep cgroup
[    0.308355] *** VALIDATE cgroup1 ***
[    0.308357] *** VALIDATE cgroup2 ***
[ 2653.742622] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope
```