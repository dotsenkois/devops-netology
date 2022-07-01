# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"

## Решение
Для хранения базы данных поднята дополнительная машина: ubuntu, hn:storage, IP local:10.130.0.24.
Настроен [сервер nfs](https://ubuntu.com/server/docs/service-nfs)

server-side:
```console
apt install nfs-kernel-server
systemctl start nfs-kernel-server.service
mkdir /pg_data
echo '/pg_data *(rw,sync,no_subtree_check,no_root_squash)' >> /etc/exports
exportfs -a
```
client-side:
```console
apt install nfs-common
mkdir /opt/pg_data
mount 10.130.0.24:/pg_data /opt/pg_data
```

порядок выполнения операций описан в файле [runme.sh](./manifests/runme.sh)

created [2 namespaces](manifests/namespaces.yml)

1. stage:
   - [deployment](./manifests/stage/deployment.yml)
   - [statefulset](./manifests/stage/statefulset.yml)
```console
root@control-plane-node-01:~# ./13-1.sh
NAME                      READY   STATUS    RESTARTS   AGE
backend-db8cf8d59-rhhkp   1/1     Running   0          68m
db-0                      1/1     Running   0          66m
frontend-c6dbbc9c-87h7v   1/1     Running   0          68m
NAME       TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
backend    ClusterIP      10.233.22.180   <none>        9000/TCP       133m
db         ClusterIP      10.233.61.7     <none>        5432/TCP       66m
frontend   LoadBalancer   10.233.28.95    <pending>     80:32563/TCP   133m
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    1/1     1            1           133m
frontend   1/1     1            1           133m
NAME   READY   AGE
db     1/1     66m
```
2. prod:
   - [deployment](./manifests/prod/deployment.yml)
   - [statefulset](./manifests/prod/statefulset.yml)
3. endpoint:
   - [endpoint](./manifests/prod/endpoint.yml)

```console
Name:                     frontend
Namespace:                prod
Labels:                   <none>
Annotations:              <none>
Selector:                 app=frontend
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.233.28.95
IPs:                      10.233.28.95
Port:                     web  80/TCP
TargetPort:               80/TCP
NodePort:                 web  32563/TCP
Endpoints:                10.233.78.53:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason  Age   From                Message
  ----    ------  ----  ----                -------
  Normal  Type    22m   service-controller  ClusterIP -> LoadBalancer
```
фронтенд доступен из вне (Правда, не по тому порту, по которому хотелось бы)
![Скриншот](./13-1-3.png)


## Задания
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.

## Задание 3 (*): добавить endpoint на внешний ресурс api
Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
* добавлен endpoint до внешнего api (например, геокодер).

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают.

---
