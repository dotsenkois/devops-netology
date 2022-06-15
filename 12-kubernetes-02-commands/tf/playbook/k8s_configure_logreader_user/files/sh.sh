#!/bin/bash
source <(kubectl completion bash)
kubectl create namespace app-namespace
kubectl get namespace
kubectl config set-context app-namespace --namespace=app-namespace

#1
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4  --replicas=2 --namespace=app-namespace

sleep 5
kubectl get deployment --namespace=app-namespace
kubectl get pods --namespace=app-namespace

#2
sudo useradd -m logreader -p password
cd /home/logreader
sudo openssl genrsa -out logreader.key 4096
###
# https://habr.com/ru/company/vk/blog/539984/

###
# csr.cnf

# [ req ]
# default_bits = 2048
# prompt = no
# default_md = sha256
# distinguished_name = dn

# [ dn ]
# CN = logreader
# O = dev

# [ v3_ext ]
# authorityKeyIdentifier=keyid,issuer:always
# basicConstraints=CA:FALSE
# keyUsage=keyEncipherment,dataEncipherment
# extendedKeyUsage=clientAuth
kubectl config --kubeconfig=config set-credentials logreader --client-certificate=fake-cert-file --client-key=fake-key-seefile

sudo openssl req -new -key logreader.key -out logreader.csr -subj "/CN=logreader/O=logreader"
# csr.yaml

# apiVersion: certificates.k8s.io/v1
# kind: CertificateSigningRequest
# metadata:
#   name: logreader
# spec:
#   signerName: kubernetes.io/kube-apiserver-client
#   request: ${BASE64_CSR}
#   usages:
#   - digital signature
#   - key encipherment
#   - client auth

export BASE64_CSR=$(cat ./logreader.csr | base64 | tr -d '\n')
cat csr.yaml | envsubst | kubectl apply -f -
kubectl get csr
kubectl certificate approve logreader
kubectl get csr
kubectl get csr logreader -o jsonpath='{.status.certificate}' | base64 --decode
mkdir .certs && mv logreader.crt logreader.key .certs
kubectl config set-credentials logreader --client-certificate=/home/logreader/.certs/logreader.crt --client-key=/home/logreader/.certs/logreader.key
kubectl config set-context logreader-context --cluster=kubernetes --user=logreader
kubectl apply -f ./logreader_role.yml
kubectl apply -f ./logreader_user.yml
kubectl get deployment
kubectl get pods

# Config

# apiVersion: v1
# clusters:
# - cluster:
#     certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM>    server: https://10.130.0.20:6443
#   name: kubernetes
# contexts:
# - context:
#     cluster: kubernetes
#     user: logreader
#   name: logreader-context
# current-context: app-namespace
# kind: Config
# preferences: {}
# users:
# - name: logreader
#   user:
#     client-certificate: /home/logreader/.certs/logreader.crt
#     client-key: /home/logreader/.certs/logreader.key



#3

kubectl scale deployment hello-node --replicas 5 --namespace=app-namespace
sleep 5
kubectl get deployment
kubectl get podsd