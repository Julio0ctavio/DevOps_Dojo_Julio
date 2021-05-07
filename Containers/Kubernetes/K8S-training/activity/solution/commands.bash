#!/bin/bash

## Create ns and resource-quota
kubectl create namespace activity

## Create configmap & secrets
kubectl create -f cm.yaml
kubectl create secret generic wordpress-secret -n activity \
--from-literal=user=kubernetes \
--from-literal=password=training
kubectl create secret generic mariadb-secret -n activity \
--from-literal=root-password=mariadbRootPassword \
--from-literal=database-name=bitnami_wordrpess \
--from-literal=database-user=bn_wordpress \
--from-literal=database-password=mariadbPassword
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=wordpress.activity.com" -keyout wordpress.key -out wordpress.crt
kubectl create secret tls ingress-tls --key wordpress.key --cert wordpress.crt -n activity

## Create backend deployment and service
kubectl create -f mariadb-deployment.yaml
kubectl create -f mariadb-svc.yaml
## Create frontend deployment, service and ingress
kubectl create -f wordpress-canary-deployment.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml
kubectl create -f ingress.yaml

echo "X.X.X.X   wordpress.activity.com" | sudo tee -a /etc/hosts
