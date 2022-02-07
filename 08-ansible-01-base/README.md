# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```
ok: [localhost] => {
    "msg": 12
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```
ok: [localhost] => {
    "msg": "all default fact"
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
```
dotsenkois@netology-ubuntu:~/repository/devops-netology-ansible/08-ansible-01-base/playbook$ docker run --name centos7 -d centos:7 sleep 60000
f06de88654dddb47de59ed4cdc5aa3692d6c217fa9f8424839988d0c1f5b2c92
dotsenkois@netology-ubuntu:~/repository/devops-netology-ansible/08-ansible-01-base/playbook$ docker run --name ubuntu -d my_ubuntu  sleep 60000
75623906b36ab4079bd69654c0f17334c66e005d60e2ec27a1ae6a5dbcc289a9
```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```
TASK [Print fact] *********************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb"
}
ok: [centos7] => {
    "msg": "el"

```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```
TASK [Print fact] *********************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```
dotsenkois@netology-ubuntu:~/repository/devops-netology-ansible/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml  site.yml  --vault-pass-file credentials

PLAY [Print os facts] ***********************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ***************************************************************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP **********************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```
Я не понимаю этого вопроса. В качестве control node я использую ВМ ubuntu. 
Я вывел список плагинов ansible-doc -l, увидел их великое множество, но не понял по какому принципу я должен выбрать
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```
ansible-playbook site.yml -i inventory/prod.yml  --vault-pass-file credentials

PLAY [Print os facts] ****************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **********************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ********************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP ***************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```
dotsenkois@netology-ubuntu:~/repository/devops-netology-ansible/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/el/examp.yml --vault-pass-file credentials 
Decryption successful
dotsenkois@netology-ubuntu:~/repository/devops-netology-ansible/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/deb/examp.yml --vault-pass-file credentials 
Decryption successful
```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
```
ansible-vault  encrypt_string --vault-pass-file credentials 
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd    
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          66333734386639643832366331323964356665646536613762346138623863376135343838363734
          6164646634356232363066623533653062313437653563620a363238613566386536326239356530
          64653334333034663437393566343363306561376337666161623230393834376362366234303639
          3335383066633932640a363866636130653237326330363238613434616538313562333934343133
          6363
Encryption successful
```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```
ansible-playbook -i inventory/prod.yml site.yml --vault-pass-file credentials 

PLAY [Print os facts] ***************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *********************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *******************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP **************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

```
ansible-playbook -i inventory/prod.yml site.yml --vault-pass-file credentials 

PLAY [Print os facts] ***************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]
ok: [fedora]

TASK [Print OS] *********************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] *******************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}

PLAY RECAP **************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```bash
#!/bin/bash 
images_list_base=( "fedora:latest" "ubuntu:latest" "centos:7" )

for image in ${images_list_base[@]}
    do
        if [[ "$(docker images -q $image 2> /dev/null)" == "" ]]; then
            docker pull $image
        fi
    done
if [[ "$(docker images -q my_ubuntu:latest 2> /dev/null)" == "" ]]; then
           docker build . --tag my_ubuntu
        fi

containers_list=( fedora ubuntu centos7 )
images_list_local=( fedora:latest my_ubuntu:latest centos:7 )

for (( i = 0; i < ${#images_list_local[@]}; i++ ))
do
    docker run --name ${containers_list[$i]} -d ${images_list_local[$i]} sleep 60000
done

sleep 10
ansible-playbook -i inventory/prod.yml site.yml --vault-pass-file credentials 

for container in ${containers_list[@]}
    do
        docker stop $container && docker rm $container
    done

```
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.
