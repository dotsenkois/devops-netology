#!/bin/bash
kubectl apply -f namespaces.yml
kubectl config set-context --current --namespace stage
kubectl apply -f manifests/stage/deployment.yml
kubectl apply -f manifests/stage/statefulset.yml
sleep 180
kubectl get po
kubectl get svc
kubectl get deployments.apps
kubectl get statefulsets.apps

kubectl config set-context --current --namespace prod
kubectl apply -f manifests/prod/deployment.yml
kubectl apply -f manifests/prod/statefulset.yml
sleep 180
kubectl get po
kubectl get svc
kubectl get deployments.apps
kubectl get statefulsets.apps
kubectl apply -f manifests/prod/endpoint.yml
kubectl describe service frontend


