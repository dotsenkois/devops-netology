# Домашнее задание к занятию "13.3 работа с kubectl"
## Решение

# 1
1.  port-forward
- frontend


```shell
kubectl port-forward services/frontend 8080:80
curl localhost:8080
```
```console
kubectl port-forward services/frontend 8080:80
root@control-plane-node-01:~# curl localhost:8080
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```

- backend

```shell
kubectl port-forward services/backend 9000:9000
curl localhost:9000
```
```console
root@control-plane-node-01:~# curl localhost:9000
curl: (52) Empty reply from server

```

- DB
```shell
kubectl port-forward services/db 5432:db
psql --host=localhost \
--port=5432 \
--username=postgres \
--password password
```
```console
root@control-plane-node-01:~# psql --host=localhost --port=5432 --username=postgres --password password -d test
psql: warning: extra command-line argument "password" ignored
Password:
psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7)
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
Type "help" for help.

test=#
```




1.  exec

# 2
```console
root@control-plane-node-01:~# kubectl get po -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP            NODE             NOMINATED NODE   READINESS GATES
backend-db8cf8d59-kq45m   1/1     Running   0          30m   10.233.78.1   worker-node-01   <none>           <none>
db-0                      1/1     Running   0          30m   10.233.69.2   worker-node-03   <none>           <none>
frontend-c6dbbc9c-9qkr4   1/1     Running   0          30m   10.233.69.1   worker-node-03   <none>           <none>
root@control-plane-node-01:~# kubectl scale
--replicas             deployment             replicaset             replicationcontroller  statefulset
root@control-plane-node-01:~# kubectl scale --replicas 3 deployment
backend   frontend
root@control-plane-node-01:~# kubectl scale --replicas 3 deployment backend
deployment.apps/backend scaled
root@control-plane-node-01:~# kubectl scale --replicas 3 deployment frontend
deployment.apps/frontend scaled
root@control-plane-node-01:~# kubectl get po -o wide
NAME                      READY   STATUS              RESTARTS   AGE   IP            NODE             NOMINATED NODE   READINESS GATES
backend-db8cf8d59-jspj7   0/1     ContainerCreating   0          7s    <none>        worker-node-02   <none>           <none>
backend-db8cf8d59-kq45m   1/1     Running             0          31m   10.233.78.1   worker-node-01   <none>           <none>
backend-db8cf8d59-zccjd   0/1     ContainerCreating   0          7s    <none>        worker-node-03   <none>           <none>
db-0                      1/1     Running             0          31m   10.233.69.2   worker-node-03   <none>           <none>
frontend-c6dbbc9c-7jbdc   0/1     ContainerCreating   0          4s    <none>        worker-node-01   <none>           <none>
frontend-c6dbbc9c-9qkr4   1/1     Running             0          31m   10.233.69.1   worker-node-03   <none>           <none>
frontend-c6dbbc9c-jzmp9   0/1     ContainerCreating   0          4s    <none>        worker-node-02   <none>           <none>
root@control-plane-node-01:~# kubectl scale --replicas 1 deployment frontend
deployment.apps/frontend scaled
root@control-plane-node-01:~# kubectl scale --replicas 1 deployment backend
deployment.apps/backend scaled
root@control-plane-node-01:~# kubectl get po -o wide
NAME                      READY   STATUS        RESTARTS   AGE   IP            NODE             NOMINATED NODE   READINESS GATES
backend-db8cf8d59-jspj7   1/1     Terminating   0          43s   10.233.84.4   worker-node-02   <none>           <none>
backend-db8cf8d59-kq45m   1/1     Running       0          32m   10.233.78.1   worker-node-01   <none>           <none>
backend-db8cf8d59-zccjd   1/1     Terminating   0          43s   10.233.69.4   worker-node-03   <none>           <none>
db-0                      1/1     Running       0          32m   10.233.69.2   worker-node-03   <none>           <none>
frontend-c6dbbc9c-9qkr4   1/1     Running       0          32m   10.233.69.1   worker-node-03   <none>           <none>
frontend-c6dbbc9c-jzmp9   1/1     Terminating   0          40s   10.233.84.5   worker-node-02   <none>           <none>
root@control-plane-node-01:~#
```

## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
