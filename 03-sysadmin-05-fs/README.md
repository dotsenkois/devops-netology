# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
- Почитал. Разредженный файл - это файл, в котором последовательность нулей заменяется на отметку о этой последовательности.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
- Файлы, являющиеся жесткой ссылкой не могут иметь различные права доступа и владельца, так как ссылаются на одну и ту же область в файловой системе, к которой и применяются права доступа.
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
- Поднял новую тачку.
 
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

```
Разбил в интерактивном режиме *sudo fdisk /dev/sdb*:
>Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x762d19d9

>Device     Boot   Start     End Sectors   Size Id Type
/dev/sdb1          2048 4000000 3997953   1.9G 83 Linux
/dev/sdb2       4000001 5242879 1242879 606.9M 83 Linux


>Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```
делал дамп диска sdb и перенес его на sdc:
>sudo sfdisk --dump /dev/sdb >sdb.dump
sudo sfdisk /dev/sdc < sdb.dump
Checking that no-one is using this disk right now ... OK

>Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

> Script header accepted.
> Script header accepted.
> Script header accepted.
> Script header accepted.
> Created a new DOS disklabel with disk identifier 0x762d19d9.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 1.9 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 606.9 MiB.
/dev/sdc3: Done.

>New situation:
Disklabel type: dos
Disk identifier: 0x762d19d9

>Device     Boot   Start     End Sectors   Size Id Type
/dev/sdc1          2048 4000000 3997953   1.9G 83 Linux
/dev/sdc2       4000001 5242879 1242879 606.9M 83 Linux

>The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```

>mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1 
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 1996928K
Continue creating array?
Continue creating array? (y/n) y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@vagrant:~# fdisk -l
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x3f94c461

>Device     Boot   Start       End   Sectors  Size Id Type
/dev/sda1  *       2048   1050623   1048576  512M  b W95 FAT32
/dev/sda2       1052670 134215679 133163010 63.5G  5 Extended
/dev/sda5       1052672 134215679 133163008 63.5G 8e Linux LVM


>Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x762d19d9

>Device     Boot   Start     End Sectors   Size Id Type
/dev/sdb1          2048 4000000 3997953   1.9G 83 Linux
/dev/sdb2       4000001 5242879 1242879 606.9M 83 Linux


>Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x762d19d9

>Device     Boot   Start     End Sectors   Size Id Type
/dev/sdc1          2048 4000000 3997953   1.9G 83 Linux
/dev/sdc2       4000001 5242879 1242879 606.9M 83 Linux


>Disk /dev/mapper/vgvagrant-root: 62.55 GiB, 67150807040 bytes, 131153920 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


>Disk /dev/mapper/vgvagrant-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


>Disk /dev/md0: 1.93 GiB, 2044854272 bytes, 3993856 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
```
>root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/s
db2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

8. Создайте 2 независимых PV на получившихся md-устройствах.
```
Создал PV:
>root@vagrant:\~# pvcreate /dev/md0
>Physical volume "/dev/md0" successfully created.
>root@vagrant:\~# pvcreate /dev/md1 
>Physical volume "/dev/md1" successfully created.
>root@vagrant:~# pvs
>  PV         VG        Fmt  Attr PSize   PFree
>  /dev/md0             lvm2 ---    1.90g 1.90g
>  /dev/md1             lvm2 ---    1.18g 1.18g
>  /dev/sda5  vgvagrant lvm2 a--  <63.50g    0
```
9.  Создайте общую volume-group на этих двух PV.
```
 Создал общуюю VG
> root@vagrant:\~# vgcreate vlo_gr /dev/md0 /dev/md1
  Volume group "vlo_gr" successfully created
root@vagrant:\~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vgvagrant   1   2   0 wz--n- <63.50g    0
  vlo_gr      2   0   0 wz--n-   3.08g 3.08g

```
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```
Создал lv
>lvcreate -L 100 -n lv1_RAID0 vlo_gr /dev/md1
  Logical volume "lv1_RAID0" created.
```
11. Создайте `mkfs.ext4` ФС на получившемся LV.
```
Создал ФС:
>root@vagrant:\~# mkfs.ext4 -t ext4 -L VOL_RAID0 /dev/vlo_gr/lv1_RAID0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

>Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
```
создал директорию и смонтировал в нее фс:
>root@vagrant:\~# mkdir /tmp/new && mount /dev/vlo_gr/lv1_RAID0 /tmp/new/
```
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
```
Скачал файл:
>root@vagrant:/tmp/new# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-09-20 15:05:36--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 21005816 (20M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

>/tmp/new/test.gz       100%[============================>]  20.03M  5.16MB/s    in 4.6s

>2021-09-20 15:05:41 (4.34 MB/s) - ‘/tmp/new/test.gz’ saved [21005816/21005816]
```
14. Прикрепите вывод `lsblk`.
```
Вывод lsblk:
>root@vagrant:/tmp/new# lsblk
NAME                   MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                      8:0    0    64G  0 disk
├─sda1                   8:1    0   512M  0 part  /boot/efi
├─sda2                   8:2    0     1K  0 part
└─sda5                   8:5    0  63.5G  0 part
  ├─vgvagrant-root     253:0    0  62.6G  0 lvm   /
  └─vgvagrant-swap_1   253:1    0   980M  0 lvm   [SWAP]
sdb                      8:16   0   2.5G  0 disk
├─sdb1                   8:17   0   1.9G  0 part
│ └─md0                  9:0    0   1.9G  0 raid1
└─sdb2                   8:18   0 606.9M  0 part
  └─md1                  9:1    0   1.2G  0 raid0
    └─vlo_gr-lv1_RAID0 253:2    0   100M  0 lvm   /tmp/new
sdc                      8:32   0   2.5G  0 disk
├─sdc1                   8:33   0   1.9G  0 part
│ └─md0                  9:0    0   1.9G  0 raid1
└─sdc2                   8:34   0 606.9M  0 part
  └─md1                  9:1    0   1.2G  0 raid0
    └─vlo_gr-lv1_RAID0 253:2    0   100M  0 lvm   /tmp/new
```
15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    ```
    Тестирование содержимого:
>root@vagrant:/tmp/new# gzip -t /tmp/new/test.gz
root@vagrant:/tmp/new# echo $?
    ```

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```
Перемещение содержимого:
>root@vagrant:/tmp/new# pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 8.00%
  /dev/md1: Moved: 100.00%
```
17. Сделайте `--fail` на устройство в вашем RAID1 md.
```
--fail:
>root@vagrant:/tmp/new# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```
18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```
dmesg:
>[41529.633974] md/raid1:md0: Disk failure on sdb1, disabling device.
md/raid1:md0: Operation continuing on 1 devices.
```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```

```
 Тестирование:
>root@vagrant:/tmp/new# gzip -t /tmp/new/test.gz
root@vagrant:/tmp/new# echo $?
0
```
20. Погасите тестовый хост, `vagrant destroy`.

 


 

#Домашнее задание к занятию "3.5. Файловые системы"

1. Почитал. Разредженный файл - это файл, в котором последовательность нулей заменяется на отметку о этой последовательности.
2. Файлы, являющиеся жесткой ссылкой не могут иметь различные права доступа и владельца, так как ссылаются на одну и ту же область в файловой системе, к которой и применяются права доступа.
3. Поднял новую тачку.
4. Разбил в интерактивном режиме *sudo fdisk /dev/sdb*:
>Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x762d19d9

>Device     Boot   Start     End Sectors   Size Id Type
/dev/sdb1          2048 4000000 3997953   1.9G 83 Linux
/dev/sdb2       4000001 5242879 1242879 606.9M 83 Linux


>Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

5. сделал дамп диска sdb и перенес его на sdc:
>sudo sfdisk --dump /dev/sdb >sdb.dump
sudo sfdisk /dev/sdc < sdb.dump
Checking that no-one is using this disk right now ... OK

>Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

> Script header accepted.
> Script header accepted.
> Script header accepted.
> Script header accepted.
> Created a new DOS disklabel with disk identifier 0x762d19d9.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 1.9 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 606.9 MiB.
/dev/sdc3: Done.

>New situation:
Disklabel type: dos
Disk identifier: 0x762d19d9

>Device     Boot   Start     End Sectors   Size Id Type
/dev/sdc1          2048 4000000 3997953   1.9G 83 Linux
/dev/sdc2       4000001 5242879 1242879 606.9M 83 Linux

>The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
6. Создал RAID1:
7. Создал RAID 0:
>root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/s
db2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
8. Создал PV:
>root@vagrant:\~# pvcreate /dev/md0
>Physical volume "/dev/md0" successfully created.
>root@vagrant:\~# pvcreate /dev/md1 
>Physical volume "/dev/md1" successfully created.
>root@vagrant:~# pvs 
>  PV         VG        Fmt  Attr PSize   PFree
>  /dev/md0             lvm2 ---    1.90g 1.90g
>  /dev/md1             lvm2 ---    1.18g 1.18g
>  /dev/sda5  vgvagrant lvm2 a--  <63.50g    0
9. Создал общуюю VG
> root@vagrant:\~# vgcreate vlo_gr /dev/md0 /dev/md1
  Volume group "vlo_gr" successfully created
root@vagrant:\~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vgvagrant   1   2   0 wz--n- <63.50g    0
  vlo_gr      2   0   0 wz--n-   3.08g 3.08g
10. Создал lv
>lvcreate -L 100 -n lv1_RAID0 vlo_gr /dev/md1
  Logical volume "lv1_RAID0" created.
11. Создал ФС:
>root@vagrant:\~# mkfs.ext4 -t ext4 -L VOL_RAID0 /dev/vlo_gr/lv1_RAID0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

>Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
12. создал директорию и смонтировал в нее фс:
>root@vagrant:\~# mkdir /tmp/new && mount /dev/vlo_gr/lv1_RAID0 /tmp/new/
13. Скачал файл:
>root@vagrant:/tmp/new# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-09-20 15:05:36--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 21005816 (20M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

>/tmp/new/test.gz       100%[============================>]  20.03M  5.16MB/s    in 4.6s

>2021-09-20 15:05:41 (4.34 MB/s) - ‘/tmp/new/test.gz’ saved [21005816/21005816]
14. Вывод lsblk:
>root@vagrant:/tmp/new# lsblk
NAME                   MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                      8:0    0    64G  0 disk
├─sda1                   8:1    0   512M  0 part  /boot/efi
├─sda2                   8:2    0     1K  0 part
└─sda5                   8:5    0  63.5G  0 part
  ├─vgvagrant-root     253:0    0  62.6G  0 lvm   /
  └─vgvagrant-swap_1   253:1    0   980M  0 lvm   [SWAP]
sdb                      8:16   0   2.5G  0 disk
├─sdb1                   8:17   0   1.9G  0 part
│ └─md0                  9:0    0   1.9G  0 raid1
└─sdb2                   8:18   0 606.9M  0 part
  └─md1                  9:1    0   1.2G  0 raid0
    └─vlo_gr-lv1_RAID0 253:2    0   100M  0 lvm   /tmp/new
sdc                      8:32   0   2.5G  0 disk
├─sdc1                   8:33   0   1.9G  0 part
│ └─md0                  9:0    0   1.9G  0 raid1
└─sdc2                   8:34   0 606.9M  0 part
  └─md1                  9:1    0   1.2G  0 raid0
    └─vlo_gr-lv1_RAID0 253:2    0   100M  0 lvm   /tmp/new
15. Тестирование содержимого:
>root@vagrant:/tmp/new# gzip -t /tmp/new/test.gz
root@vagrant:/tmp/new# echo $?
0
16. Перемещение содержимого:
>root@vagrant:/tmp/new# pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 8.00%
  /dev/md1: Moved: 100.00%
17. --fail:
>root@vagrant:/tmp/new# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
18. dmesg:
>[41529.633974] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
19. Тестирование:
>root@vagrant:/tmp/new# gzip -t /tmp/new/test.gz
root@vagrant:/tmp/new# echo $?
0