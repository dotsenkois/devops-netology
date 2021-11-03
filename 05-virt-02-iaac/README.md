
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?
- Инфрастукрутура как код позволяет применять изменения конфигураций программного обеспечения быстро, контролируемо и масово. При использовании IaaC заранее известно к чему приведет одно и тоже действеи выполненояемое раз от раза. 

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
- 
- Ansible работат с методом распростронения конифгураций Push. Для его работы не требуется установкаа дополнительного ПО, достаточно иметь права локального администратора.
- Более надежный метод - Push. Применение конфигурации распростроняемой данным методом уменьшает количество вероятных точек отказа.

## Задача 3

Установить на личный компьютер:

- VirtualBox
```bash
dotsenkois@aspire-sw5-171:~$ virtualbox --help
Oracle VM VirtualBox VM Selector v6.1.26_Ubuntu
(C) 2005-2021 Oracle Corporation
All rights reserved.

No special options.

If you are looking for --startvm and related options, you need to use VirtualBoxVM.

```
- Vagrant
```bash
dotsenkois@aspire-sw5-171:~$ vagrant --version
Vagrant 2.2.18

```
- Ansible
```bash
dotsenkois@aspire-sw5-171:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/dotsenkois/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Sep 28 2021, 16:10:42) [GCC 9.3.0]

```
*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```
