# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"

[terrafrom](./tf/terraform/)

[ansible](./tf/playbook/)

[Скрипт для начала развертывания инфраструктуры в YC](./run_tf.sh)

Заготовки для ролей ansible:

- [Установка софта](./tf/playbook/k8s_setup/)

- [подготовка controle-plane](./tf/playbook/k8s_control_plane/)

- [подготовка workers](./tf/playbook/k8s_workers/)

- [выполнение заданий(в основном второго))](./tf/playbook/k8s_configure_logreader_user)

## Ответ на задание 1

```console
dotsenkois@control-plane-node-01:~$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4  --replicas=2
deployment.apps/hello-node created
dotsenkois@control-plane-node-01:~$ kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           18s
dotsenkois@control-plane-node-01:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6d5f754cc9-485c7   1/1     Running   0          53s
hello-node-6d5f754cc9-qx9bq   1/1     Running   0          53s
```

## Ответ на задание 2

файл ролей и привязки. и вывод из косоли, того, что может делать пользователь после применения

```yml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: logreader-role
  namespace: app-namespace
rules:
  - apiGroups: [ "" ]
    resources: [ "pods" ]
    verbs: [ "get", "list", "describe", "watch" ]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: logreader-clusterrole
  namespace: app-namespace
rules:
  - apiGroups: [ "" ]
    resources: [ "pods" ]
    verbs: [ "get", "list", "describe", "watch" ]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: logreader
  namespace: app-namespace
subjects:
- kind: User
  name: logreader
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: logreader-role
  apiGroup: rbac.authorization.k8s.io

```
```console
logreader@control-plane-node-01:~$ kubectl auth can-i get pods -n app-namespace
yes
logreader@control-plane-node-01:~$ kubectl auth can-i list pods -n app-namespace
yes
logreader@control-plane-node-01:~$ kubectl auth can-i watch pods -n app-namespace
yes
logreader@control-plane-node-01:~$ kubectl auth can-i delete pods -n app-namespace
no
logreader@control-plane-node-01:~$ kubectl auth can-i create pods -n app-namespace
no
logreader@control-plane-node-01:~$ kubectl auth can-i get pods
no
```


## Ответ на задание 3

```console
dotsenkois@control-plane-node-01:~$ kubectl scale deployment hello-node  --replicas=5
deployment.apps/hello-node scaled
dotsenkois@control-plane-node-01:~$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   5/5     5            5           3m1s
dotsenkois@control-plane-node-01:~$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6d5f754cc9-5cpzj   1/1     Running   0          3m4s
hello-node-6d5f754cc9-7cqdp   1/1     Running   0          98s
hello-node-6d5f754cc9-dvpps   1/1     Running   0          6s
hello-node-6d5f754cc9-mqf26   1/1     Running   0          3m4s
hello-node-6d5f754cc9-pmjkn   1/1     Running   0          98s
```

```

```
## Использованные материалы

https://github.com/aak74/kubernetes-for-beginners/
https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/
https://kubernetes.io/docs/reference/access-authn-authz/rbac/
https://habr.com/ru/company/flant/blog/333956/



## Задания


Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods


## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)


## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
