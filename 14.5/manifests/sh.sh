#!/bin/bash

echo "From frontend"
kubectl exec frontend-c74c5646c-77w4t -- curl -s -m 1 http://curl.org | grep title
kubectl exec frontend-c74c5646c-77w4t -- curl -s -m 1 backend

echo "From backend"
kubectl exec backend-869fd89bdc-qfjbr -- curl -s -m 1 frontend
kubectl exec backend-869fd89bdc-qfjbr -- curl -s -m 1 http://curl.org | grep title
