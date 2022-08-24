#!/bin/bash

echo "From frontend"
kubectl exec frontend-c74c5646c-c4tbz -- curl -s -m 1 http://curl.org
kubectl exec frontend-c74c5646c-c4tbz -- curl -s -m 1 backend

echo "From backend"
kubectl exec backend-869fd89bdc-dppgm -- curl -s -m 1 frontend
kubectl exec backend-869fd89bdc-dppgm -- curl -s -m 1 http://curl.org
