# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"

[terrafrom](./tf/terraform/)

[ansible](./tf/playbook/)

[Скрипт для начала развертывания инфраструктуры в YC](./run_tf.sh)

Заготовки для ролей ansible:

- [Установка софта](./tf/playbook/k8s_setup/)

- [подготовка controle-plane](./tf/playbook/k8s_control_plane.)

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
[Последовательность выполненных команд](./tf/playbook/k8s_configure_logreader_user/files/sh.sh)

```console
logreader@control-plane-node-01:~$ kubectl describe pod hello-node-6d5f754cc9-pmjr7
Name:         hello-node-6d5f754cc9-pmjr7
Namespace:    default
Priority:     0
Node:         worker-node-02/10.130.0.52
Start Time:   Mon, 13 Jun 2022 02:41:35 +0000
Labels:       app=hello-node
              pod-template-hash=6d5f754cc9
Annotations:  <none>
Status:       Running
IP:           10.244.2.2
IPs:
  IP:           10.244.2.2
Controlled By:  ReplicaSet/hello-node-6d5f754cc9
Containers:
  echoserver:
    Container ID:   containerd://db3df9ae4869ea415023860cd613d6d32e0271fed80d24b8401352a697c5f140
    Image:          k8s.gcr.io/echoserver:1.4
    Image ID:       sha256:523cad1a4df732d41406c9de49f932cd60d56ffd50619158a2977fd1066028f9
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Mon, 13 Jun 2022 02:41:44 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mhw9d (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-mhw9d:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  32m   default-scheduler  Successfully assigned default/hello-node-6d5f754cc9-pmjr7 to worker-node-02
  Normal  Pulling    32m   kubelet            Pulling image "k8s.gcr.io/echoserver:1.4"
  Normal  Pulled     32m   kubelet            Successfully pulled image "k8s.gcr.io/echoserver:1.4" in 5.993787051s
  Normal  Created    32m   kubelet            Created container echoserver
  Normal  Started    32m   kubelet            Started container echoserver
```

```console
logreader@control-plane-node-01:~$ cat .kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EWXhNekF5TVRJek5Wb1hEVE15TURZeE1EQXlNVEl6TlZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTC8vCkk0R0NhMlNyUmlpY1I0amk0RFNidlJLZ3h1VkNvVDI0WGpvS1RDK3BpNFcrZ1hadmpqNXQwbkNIem9QTUViNW8KWFplelVQVXZHRzhzcy9hS0tGRHRoS09QdHV1K2hRVEcyRUxxcnAyMDRKcEllRUVndjJ5VjBISmxIYmxDclRReApFSlVjbytHS2s3ZFFjOGYyR212VGVDTVE4dGZhbWgxUCtkcTVvWWVFUHlmRWNGL3h3djhWSVZXd1QzczVIaVFpCkZxWG5uRlpia2VaMG5QWlJBcnRPVHcrZEsvNGNJWE1XQUJGMW1zdGMrelBWV3NDclhBSmVkZDkwdWwxVVVhd3AKY2JWeVF3N0NyeW5pYk1DOXRZU1NDK2hTamw2WlBvSDJRaDMxd24zVU1OWmwrVCtBbERrcFZoM1ZSNUFTR2hjZgpvaGp0elF2bHNkL3Y4eWsxUi9VQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZHbTEvcXNGUUdUS1c4YnFZeGlhMXNJNGpsZ0ZNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBR2tPRFRlTWEwVFRFa1ZKK29rcwo3OFhPclZJbENlajBpc1huSEVaM2tIbUI0SUZ4a0pDa2ZJQW03Z0pCMC9oa1dtd1BRYU56S05RbUdpSzVZMGZsCnNkNmhNUU45M3lZeTNPWWsyOEQ2ajE0Y0Zscnl6MTExV3RWc2U4L2tDQnB5WlFqU1h2cVNEQ0hORGQvbWI5V3MKK0hlSXlMWDFTUXZXNVlLL2c4VWxPWTNUd2VlamtqWko2NFljckNmSWYrQkRXeEs0b3lndStNYldRMFE2d2NPTAp5T0RYY0xDamt3dzE4VnVndE5FcGhDUW9UOEJMQ0dudnF3V0hHNmEvWElsYUd2Ymo0MWdQeHd6V25VcmcwcmVkCnNNd3R4cHBPMDdQdUZnelVtZHJWSzgvNUpGeFFqZkw0ZDB1QXh5MFZMZHVGZDB3N3Q5Nm9qVlV6NHNxa0FDaE8KenJFPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.130.0.20:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
- context:
    cluster: kubernetes
    user: logreader
  name: logreader-context
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: logreader
  user:
    client-certificate: /home/logreader/.certs/logreader.crt
    client-key: /home/logreader/.certs/logreader.key
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
