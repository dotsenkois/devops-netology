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
root@control-plane-node-01:~# curl localhost:9000/api/news/
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]root@control-plane-node-01:~/devops-netology/13-kube

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
- frontend
```console
root@control-plane-node-01:~# kubectl exec pods/frontend-c6dbbc9c-9qkr4 -c frontend -- curl localhost:80
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
</html>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   448  100   448    0     0   437k      0 --:--:-- --:--:-- --:--:--  437k
```

- backend

```console
root@control-plane-node-01:~# kubectl exec pods/backend-67b6d7c4bd-q9f98 -c backend -- curl localhost:9000/api/news/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  5182  100  5182    0     0   194k      0 --:--:-- --:--:-- --:--:--  194k
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
```

- db
```console
root@control-plane-node-01:~# kubectl exec -it pods/db-0 -c db -- psql --username=postgres  -d test
psql (13.7)
Type "help" for help.

test=#


```

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
