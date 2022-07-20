# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"

## Решение

## 1

[чарт](./chart/)

## 2

```console
root@control-plane-node-01:~/devops-netology/13-kubernetes-config-04-helm# helm install chart --set namespace=app1 --generate-name
NAME: chart-1658242060
LAST DEPLOYED: Tue Jul 19 14:47:40 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None

root@control-plane-node-01:~/devops-netology/13-kubernetes-config-04-helm# helm upgrade chart-1658242060 --set namespace=app1  chart
Release "chart-1658242060" has been upgraded. Happy Helming!
NAME: chart-1658242060
LAST DEPLOYED: Tue Jul 19 14:59:22 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 4
TEST SUITE: None

root@control-plane-node-01:~/devops-netology/13-kubernetes-config-04-helm# helm install app0.1.2  chart
Error: INSTALLATION FAILED: Service "frontend" is invalid: spec.ports[0].nodePort: Invalid value: 32080: provided port is already allocated

root@control-plane-node-01:~/devops-netology/13-kubernetes-config-04-helm# helm install app0.1.3 chart --set namespace=app2
NAME: app0.1.3
LAST DEPLOYED: Tue Jul 19 15:03:26 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
root@control-plane-node-01:~/devops-netology/13-kubernetes-config-04-helm# helm list
NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
app0.1.2                app1            1               2022-07-19 15:01:05.264514292 +0000 UTC failed          chart-0.1.1     1.16.0
app0.1.3                app1            1               2022-07-19 15:03:26.847319363 +0000 UTC deployed        chart-0.1.1     1.16.0
chart-1658242060        app1            4               2022-07-19 14:59:22.424300214 +0000 UTC deployed        chart-0.1.1     1.16.0

```
## 3
[helm template chart > chart.yml](chart.yml)

[converted to json chart.yml](chart.json)

[chart1.jsonnet](./chart1.jsonnet)

[jsonnet chart1.jsonnet > output1.json](./output1.json)


## Задания
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

## Задание 3 (*): повторить упаковку на jsonnet
Для изучения другого инструмента стоит попробовать повторить опыт упаковки из задания 1, только теперь с помощью инструмента jsonnet.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
