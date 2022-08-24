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