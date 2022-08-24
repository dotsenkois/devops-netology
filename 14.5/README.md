# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

## Решение

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
root@control-plane-node-01:~/devops-netology/14.5# kubectl apply -f example
-security-context.yml
pod/security-context-demo created
```

Проверьте установленные настройки внутри контейнера

```
root@control-plane-node-01:~/devops-netology/14.5# kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

```bash
#!/bin/bash

echo "From frontend"
kubectl exec frontend-c74c5646c-77w4t -- curl -s -m 1 http://curl.org | grep title
kubectl exec frontend-c74c5646c-77w4t -- curl -s -m 1 backend

echo "From backend"
kubectl exec backend-869fd89bdc-qfjbr -- curl -s -m 1 frontend
kubectl exec backend-869fd89bdc-qfjbr -- curl -s -m 1 http://curl.org | grep title

```

2 приложения:

- [frontend](./manifests/10-frontend.yaml)
- [backend](./manifests/20-backend.yaml)

3 политки:

- [dns](./53.yaml)
- [frontend](./frontend-np.yml)
- [backend](./backend-np.yml)

```Console
root@control-plane-node-01:~/devops-netology/14.5# ./manifests/sh.sh 
From frontend
<title>301 Moved Permanently</title>
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-qfjbr - 10.233.78.105
From backend
Praqma Network MultiTool (with NGINX) - frontend-c74c5646c-77w4t - 10.233.78.104
command terminated with exit code 28
```

## Задание

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---
