# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Описание репозитория
1. [terrafrom](./terraform/variables.tf) поднимает в yndex cloud 4 вм c статическими внутренними ip:
- "es-node01"  = "10.130.0.10"
- "kib-node01" = "10.130.0.11"
- "app-node01" = "10.130.0.20"
- "app-node02" = "10.130.0.21"

2. [get-data-compute-yc.sh](./terraform/get-data-compute-yc.sh) экспортирует в файл output.txt вывод команды yc compute instance list
3. [parser.py](./terraform/parser.py) преобразует данные из предыдущего пункта в hosts.yml
4. [ansible](./playbook/site.yml) проивзодит установку на указанных хостах elasticsearch, kibana и filebeat.

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
4. Приготовьте свой собственный inventory файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Проделайте шаги с 1 до 8 для создания ещё одного play, который устанавливает и настраивает filebeat.
10. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
11. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.