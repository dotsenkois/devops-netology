# Домашнее задание к занятию "13.2 разделы и монтирование"
## Решение
## 1
Создан манифест [deployment.yml](./manifests/stage/deployment.yml)

Выполнены комманды:
```console
kubectl exec frontend-backend-bb67897ff-g8hjm -c backend -- touch /static/{1..10}
kubectl exec frontend-backend-bb67897ff-g8hjm -c backend -- ls -la /static
kubectl exec frontend-backend-bb67897ff-g8hjm -c frontend -- ls -la /static
```

```console
root@control-plane-node-01:~# kubectl exec frontend-backend-bb67897ff-g8hjm -c backend -- touch /static/{1..10}
8hjm -c frontend -- ls -la /staticroot@control-plane-node-01:~# kubectl exec frontend-backend-bb67897ff-g8hjm -c backend -- ls -la /static
total 8
drwxrwxrwx 2 root root 4096 Jul  3 14:54 .
drwxr-xr-x 1 root root 4096 Jul  3 14:43 ..
-rw-r--r-- 1 root root    0 Jul  3 14:54 1
-rw-r--r-- 1 root root    0 Jul  3 14:54 10
-rw-r--r-- 1 root root    0 Jul  3 14:54 2
-rw-r--r-- 1 root root    0 Jul  3 14:54 3
-rw-r--r-- 1 root root    0 Jul  3 14:54 4
-rw-r--r-- 1 root root    0 Jul  3 14:54 5
-rw-r--r-- 1 root root    0 Jul  3 14:54 6
-rw-r--r-- 1 root root    0 Jul  3 14:54 7
-rw-r--r-- 1 root root    0 Jul  3 14:54 8
-rw-r--r-- 1 root root    0 Jul  3 14:54 9
root@control-plane-node-01:~# kubectl exec frontend-backend-bb67897ff-g8hjm -c frontend -- ls -la /static
total 8
drwxrwxrwx 2 root root 4096 Jul  3 14:54 .
drwxr-xr-x 1 root root 4096 Jul  3 14:43 ..
-rw-r--r-- 1 root root    0 Jul  3 14:54 1
-rw-r--r-- 1 root root    0 Jul  3 14:54 10
-rw-r--r-- 1 root root    0 Jul  3 14:54 2
-rw-r--r-- 1 root root    0 Jul  3 14:54 3
-rw-r--r-- 1 root root    0 Jul  3 14:54 4
-rw-r--r-- 1 root root    0 Jul  3 14:54 5
-rw-r--r-- 1 root root    0 Jul  3 14:54 6
-rw-r--r-- 1 root root    0 Jul  3 14:54 7
-rw-r--r-- 1 root root    0 Jul  3 14:54 8
-rw-r--r-- 1 root root    0 Jul  3 14:54 9
```
## 2

Установлен helm.

Установлен nfs-server через helm.

созданы манифесты [deployment](./manifests/prod/deployment.yml) и [persistent volume clain](./manifests/prod/pvc.yml)

Выполнены комманды:

```console
kubectl exec backend-7f4d8975d-fb7nq -c  backend -- touch /static/{1..10}
kubectl exec backend-7f4d8975d-fb7nq -c  backend -- ls -la /static
kubectl exec frontend-85f8f64576-f76bc -c frontend -- ls -la /static
```

```console
root@control-plane-node-01:~# kubectl get pvc
NAME                        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc                         Bound    pvc-61784fa7-cad4-4c7e-8513-b190a4c40293   2Gi        RWX            nfs            8m20s
test-dynamic-volume-claim   Bound    pvc-91e8076f-ebde-4941-a526-251b05ca11fe   100Mi      RWO            nfs            42m
root@control-plane-node-01:~/manifests/prod# k
NAME                        READY   STATUS    RESTARTS   AGE
backend-7f4d8975d-fb7nq     1/1     Running   0          3m22s
frontend-85f8f64576-f76bc   1/1     Running   0          3m22s
root@control-plane-node-01:~/manifests/prod# kubectl exec backend-7f4d8975d-fb7nq -c  backend -- touch /static/{1..10}
root@control-plane-node-01:~/manifests/prod# kubectl exec backend-7f4d8975d-fb7nq -c  backend -- ls -la /static
total 8
drwxrwsrwx 2 root root 4096 Jul  3 16:27 .
drwxr-xr-x 1 root root 4096 Jul  3 16:26 ..
-rw-r--r-- 1 root root    0 Jul  3 16:27 1
-rw-r--r-- 1 root root    0 Jul  3 16:27 10
-rw-r--r-- 1 root root    0 Jul  3 16:27 2
-rw-r--r-- 1 root root    0 Jul  3 16:27 3
-rw-r--r-- 1 root root    0 Jul  3 16:27 4
-rw-r--r-- 1 root root    0 Jul  3 16:27 5
-rw-r--r-- 1 root root    0 Jul  3 16:27 6
-rw-r--r-- 1 root root    0 Jul  3 16:27 7
-rw-r--r-- 1 root root    0 Jul  3 16:27 8
-rw-r--r-- 1 root root    0 Jul  3 16:27 9
root@control-plane-node-01:~/manifests/prod# kubectl exec frontend-85f8f64576-f76bc -c frontend -- ls -la /static
total 8
drwxrwsrwx 2 root root 4096 Jul  3 16:27 .
drwxr-xr-x 1 root root 4096 Jul  3 16:26 ..
-rw-r--r-- 1 root root    0 Jul  3 16:27 1
-rw-r--r-- 1 root root    0 Jul  3 16:27 10
-rw-r--r-- 1 root root    0 Jul  3 16:27 2
-rw-r--r-- 1 root root    0 Jul  3 16:27 3
-rw-r--r-- 1 root root    0 Jul  3 16:27 4
-rw-r--r-- 1 root root    0 Jul  3 16:27 5
-rw-r--r-- 1 root root    0 Jul  3 16:27 6
-rw-r--r-- 1 root root    0 Jul  3 16:27 7
-rw-r--r-- 1 root root    0 Jul  3 16:27 8
-rw-r--r-- 1 root root    0 Jul  3 16:27 9
```

## Задние
Приложение запущено и работает, но время от времени появляется необходимость передавать между бекендами данные. А сам бекенд генерирует статику для фронта. Нужно оптимизировать это.
Для настройки NFS сервера можно воспользоваться следующей инструкцией (производить под пользователем на сервере, у которого есть доступ до kubectl):
* установить helm: curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
* добавить репозиторий чартов: helm repo add stable https://charts.helm.sh/stable && helm repo update
* установить nfs-server через helm: helm install nfs-server stable/nfs-server-provisioner

В конце установки будет выдан пример создания PVC для этого сервера.

## Задание 1: подключить для тестового конфига общую папку
В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это через общую папку. Требования:
* в поде подключена общая папка между контейнерами (например, /static);
* после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

## Задание 2: подключить общую папку для прода
Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:
* все бекенды подключаются к одному PV в режиме ReadWriteMany;
* фронтенды тоже подключаются к этому же PV с таким же режимом;
* файлы, созданные бекендом, должны быть доступны фронту.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
