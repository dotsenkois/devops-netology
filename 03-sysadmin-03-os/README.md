# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.

```
vagrant@vagrant:~/test$ strace /usr/bin/bash -c 'cd /tmp' 2>&1|grep chdir
>chdir("/tmp")
```

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

```
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3; openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

```
echo test.txt <br>vim test.txt <br>sudo rm .test.txt.swp<br>lsof | grep .test.txt.swp <br>vim     2342 vagrant    4u   REG  253,0    12288 131100 /home/vagrant/test/.test.txt.swp (deleted) <br>echo > /proc/2342/fd/4
```
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

```
Зомби-процессы не занимают ресурсы.
```
6. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

```
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
786    vminfo              6   0 /var/run/utmp
564    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
564    dbus-daemon        18   0 /usr/share/dbus-1/system-services
564    dbus-daemon        -1   2 /lib/dbus-1/system-services
564    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
1      systemd            12   0 /proc/381/cgroup
576    irqbalance          6   0 /proc/interrupts
576    irqbalance          6   0 /proc/stat
576    irqbalance          6   0 /proc/irq/20/smp_affinity
576    irqbalance          6   0 /proc/irq/0/smp_affinity
576    irqbalance          6   0 /proc/irq/1/smp_affinity
576    irqbalance          6   0 /proc/irq/8/smp_affinity
576    irqbalance          6   0 /proc/irq/12/smp_affinity
576    irqbalance          6   0 /proc/irq/14/smp_affinity
576    irqbalance          6   0 /proc/irq/15/smp_affinity
786    vminfo              6   0 /var/run/utmp
564    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
564    dbus-daemon        18   0 /usr/share/dbus-1/system-services
564    dbus-daemon        -1   2 /lib/dbus-1/system-services
564    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
```

7. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

```
uname({sysname="Linux", nodename="vagrant", ...}) = 0<
Part of the utsname information is also accessible via
       /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
```
8. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

```
символ ";" - означает конец команды. Команды разделенные этим символом выполнятся последовательно. <br>"&&" - логическое *И*. Команда **два** выполниться только в случае, если команда **один** вернет *true*<br>*set -e* сработает независимо от использования символа разделяющего команды.
```

9.  Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
```
-e  Exit immediately if a command exits with a non-zero status.-u  Treat unset variables as an error when substituting.
-x   Print commands and their arguments as they are executed.
 - o pipefail   the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero
 Мгновенный выход, в случае воврата не нулевого статуса, пусные перменные рассматриваются как ошибка, вывод команд и их аргументов в stdout(?); Возвращает значение конвейера как статус последней выполненной команды с не нулевым статусом или ноль, если ни одна команда в конвейере не вернула ноль.<br>Использование подобной комбинации ключей позволяет отследить ошибки на этапе отладки скрипта.  
```
10. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

```
vagrant@vagrant:\~$ ps ax -o stat |sort|grep 'S*' -o |grep '' -c
53
vagrant@vagrant:\~$ ps ax -o stat |sort|grep 'I*' -o |grep '' -c
47
```