# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook. 
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. 

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
dotsenkois@netology-ubuntu:~/repository/devops-netology/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --check
[WARNING]: Found both group and host with same name: elasticsearch
[WARNING]: Found both group and host with same name: kibana

PLAY [Install Java] ****************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************
ok: [kibana]
ok: [elasticsearch]

TASK [download_java] ***************************************************************************************************************************************
changed: [elasticsearch]
changed: [kibana]

TASK [Ensure installation dir exists] **********************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Extract java in the installation directory] **********************************************************************************************************
skipping: [elasticsearch]
skipping: [kibana]

TASK [Export environment variables] ************************************************************************************************************************
ok: [kibana]
ok: [elasticsearch]

PLAY [Install Elasticsearch] *******************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************
changed: [elasticsearch]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************
ok: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************
skipping: [elasticsearch]

TASK [Set environment Elastic] *****************************************************************************************************************************
ok: [elasticsearch]

PLAY [Install Kibana] **************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [kibana]

TASK [Download tar.gz Kibana from remote URL] **************************************************************************************************************
changed: [kibana]

TASK [Create directrory for kibana] ************************************************************************************************************************
ok: [kibana]

TASK [Extract kibana in the installation directory] ********************************************************************************************************
skipping: [kibana]

TASK [Set environment Kibana] ******************************************************************************************************************************
ok: [kibana]

PLAY RECAP *************************************************************************************************************************************************
elasticsearch              : ok=9    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
kibana                     : ok=9    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
dotsenkois@netology-ubuntu:~/repository/devops-netology/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff
[WARNING]: Found both group and host with same name: elasticsearch
[WARNING]: Found both group and host with same name: kibana

PLAY [Install Java] ****************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [download_java] ***************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Ensure installation dir exists] **********************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Extract java in the installation directory] **********************************************************************************************************
skipping: [elasticsearch]
skipping: [kibana]

TASK [Export environment variables] ************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

PLAY [Install Elasticsearch] *******************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************
ok: [elasticsearch]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************
ok: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************
skipping: [elasticsearch]

TASK [Set environment Elastic] *****************************************************************************************************************************
ok: [elasticsearch]

PLAY [Install Kibana] **************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [kibana]

TASK [Download tar.gz Kibana from remote URL] **************************************************************************************************************
ok: [kibana]

TASK [Create directrory for kibana] ************************************************************************************************************************
ok: [kibana]

TASK [Extract kibana in the installation directory] ********************************************************************************************************
skipping: [kibana]

TASK [Set environment Kibana] ******************************************************************************************************************************
ok: [kibana]

PLAY RECAP *************************************************************************************************************************************************
elasticsearch              : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
kibana                     : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
dotsenkois@netology-ubuntu:~/repository/devops-netology/08-ansible-02-playbook/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff
[WARNING]: Found both group and host with same name: kibana
[WARNING]: Found both group and host with same name: elasticsearch

PLAY [Install Java] ****************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Set facts for Java 11 vars] **************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [download_java] ***************************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Ensure installation dir exists] **********************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

TASK [Extract java in the installation directory] **********************************************************************************************************
skipping: [elasticsearch]
skipping: [kibana]

TASK [Export environment variables] ************************************************************************************************************************
ok: [elasticsearch]
ok: [kibana]

PLAY [Install Elasticsearch] *******************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [elasticsearch]

TASK [Upload tar.gz Elasticsearch from remote URL] *********************************************************************************************************
ok: [elasticsearch]

TASK [Create directrory for Elasticsearch] *****************************************************************************************************************
ok: [elasticsearch]

TASK [Extract Elasticsearch in the installation directory] *************************************************************************************************
skipping: [elasticsearch]

TASK [Set environment Elastic] *****************************************************************************************************************************
ok: [elasticsearch]

PLAY [Install Kibana] **************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [kibana]

TASK [Download tar.gz Kibana from remote URL] **************************************************************************************************************
ok: [kibana]

TASK [Create directrory for kibana] ************************************************************************************************************************
ok: [kibana]

TASK [Extract kibana in the installation directory] ********************************************************************************************************
skipping: [kibana]

TASK [Set environment Kibana] ******************************************************************************************************************************
ok: [kibana]

PLAY RECAP *************************************************************************************************************************************************
elasticsearch              : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
kibana                     : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```
9.  Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
- [README.md](https://github.com/dotsenkois/devops-netology/blob/main/08-ansible-02-playbook/playbook/README.md)

10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.
