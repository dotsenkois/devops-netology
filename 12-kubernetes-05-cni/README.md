# Домашнее задание к занятию "12.5 Сетевые решения CNI"
## Решение
# 1.
1. Класре настроен при помощи kuberspray
2. Проверка работы политик (sh.sh):


```shell
#!/bin/bash

echo "From frontend"
kubectl exec frontend-c74c5646c-dmxfh -- curl -s -m 1 frontend
kubectl exec frontend-c74c5646c-dmxfh -- curl -s -m 1 cache
kubectl exec frontend-c74c5646c-dmxfh -- curl -s -m 1 backend

echo "From backend"
kubectl exec backend-869fd89bdc-fwck8 -- curl -s -m 1 frontend
kubectl exec backend-869fd89bdc-fwck8 -- curl -s -m 1 cache
kubectl exec backend-869fd89bdc-fwck8 -- curl -s -m 1 backend

echo "From cache"
kubectl exec cache-b7cbd9f8f-95mt4 -- curl -s -m 1 frontend
kubectl exec cache-b7cbd9f8f-95mt4 -- curl -s -m 1 cache
kubectl exec cache-b7cbd9f8f-95mt4 -- curl -s -m 1 backend
   ```

 - Политика по умолчанию:
```console
root@control-plane-node-01:~# ./sh.sh
From frontend
Praqma Network MultiTool (with NGINX) - frontend-c74c5646c-dmxfh - 10.233.78.14
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
From backend
Praqma Network MultiTool (with NGINX) - frontend-c74c5646c-dmxfh - 10.233.78.14
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
From cache
Praqma Network MultiTool (with NGINX) - frontend-c74c5646c-dmxfh - 10.233.78.14
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
```
 - 00-default.yaml:
```console
root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/network-policy# kubectl apply -f 00-default.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created

root@control-plane-node-01:~# ./sh.sh
From frontend
command terminated with exit code 28
command terminated with exit code 28
command terminated with exit code 28
From backend
command terminated with exit code 28
command terminated with exit code 28
command terminated with exit code 28
From cache
command terminated with exit code 28
command terminated with exit code 28
command terminated with exit code 28
```
 - 10-frontend.yaml:
```console
root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/network-policy# kubectl delete -f 00-default.yaml
networkpolicy.networking.k8s.io "default-deny-ingress" deleted

root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/network-policy# kubectl apply -f 10-frontend.yaml
networkpolicy.networking.k8s.io/frontend created

root@control-plane-node-01:~# ./sh.sh
From frontend
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
From backend
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
From cache
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
```
 - 20-backend.yaml:
```console
root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/network-policy# kubectl apply -f 20-backend.yaml
networkpolicy.networking.k8s.io/backend created

root@control-plane-node-01:~# ./sh.sh
From frontend
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
From backend
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
command terminated with exit code 28
From cache
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
command terminated with exit code 28

```
 - 30-cache.yaml:
```console
root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/network-policy# kubectl apply -f 30-cache.yaml
networkpolicy.networking.k8s.io/cache created

root@control-plane-node-01:~# ./sh.sh
From frontend
command terminated with exit code 28
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-fwck8 - 10.233.78.15
From backend
command terminated with exit code 28
Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-95mt4 - 10.233.78.16
command terminated with exit code 28
From cache
command terminated with exit code 28
command terminated with exit code 28
command terminated with exit code 28
```


# 2.
- Утилита установлена в рамках подготовки кластера
```console
root@control-plane-node-01:~# kubectl get pod --all-namespaces |grep calico
kube-system   calico-node-2pjrh                               1/1     Running   0             5d
kube-system   calico-node-4dx4b                               1/1     Running   3 (29m ago)   5d
kube-system   calico-node-7mdn4                               1/1     Running   0             5d
kube-system   calico-node-b6khz                               1/1     Running   3 (29m ago)   5d
kube-system   calico-node-tnvqg                               1/1     Running   0             5d
```

- Вывод консоли
```console
root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/main# calicoctl get ipPool
NAME           CIDR             SELECTOR
default-pool   10.233.64.0/18   all()

root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/main# calicoctl get nodes
NAME
control-plane-node-01
worker-node-01
worker-node-02
worker-node-03
worker-node-04

root@control-plane-node-01:~/kubernetes-for-beginners/16-networking/20-network-policy/manifests/main# calicoctl get profile
NAME
projectcalico-default-allow
kns.default
kns.kube-node-lease
kns.kube-public
kns.kube-system
ksa.default.default
ksa.kube-node-lease.default
ksa.kube-public.default
ksa.kube-system.attachdetach-controller
ksa.kube-system.bootstrap-signer
ksa.kube-system.calico-node
ksa.kube-system.certificate-controller
ksa.kube-system.clusterrole-aggregation-controller
ksa.kube-system.coredns
ksa.kube-system.cronjob-controller
ksa.kube-system.daemon-set-controller
ksa.kube-system.default
ksa.kube-system.deployment-controller
ksa.kube-system.disruption-controller
ksa.kube-system.dns-autoscaler
ksa.kube-system.endpoint-controller
ksa.kube-system.endpointslice-controller
ksa.kube-system.endpointslicemirroring-controller
ksa.kube-system.ephemeral-volume-controller
ksa.kube-system.expand-controller
ksa.kube-system.generic-garbage-collector
ksa.kube-system.horizontal-pod-autoscaler
ksa.kube-system.job-controller
ksa.kube-system.kube-proxy
ksa.kube-system.namespace-controller
ksa.kube-system.node-controller
ksa.kube-system.nodelocaldns
ksa.kube-system.persistent-volume-binder
ksa.kube-system.pod-garbage-collector
ksa.kube-system.pv-protection-controller
ksa.kube-system.pvc-protection-controller
ksa.kube-system.replicaset-controller
ksa.kube-system.replication-controller
ksa.kube-system.resourcequota-controller
ksa.kube-system.root-ca-cert-publisher
ksa.kube-system.service-account-controller
ksa.kube-system.service-controller
ksa.kube-system.statefulset-controller
ksa.kube-system.token-cleaner
ksa.kube-system.ttl-after-finished-controller
ksa.kube-system.ttl-controller
```

## Задание
После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.
## Задание 1: установить в кластер CNI плагин Calico
Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)

## Задание 2: изучить, что запущено по умолчанию
Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
Требования: 
* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
