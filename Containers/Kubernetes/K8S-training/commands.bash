#
# Kubernetes Training
#

#######################
# Minikube Installation
#######################
## Linux installation
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
## OS X installation
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

## First steps with Minikube
minikube start
minikube status
minikube ssh
minikube dashboard

######################
# Kubectl Installation
######################
## Linux installation
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv kubectl /usr/local/bin/
## OS X installation
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl && chmod +x ./kubectl && sudo mv kubectl /usr/local/bin/

###################################
# Configure Kubectl to use Minikube
###################################
## Get contexts
kubectl config get-contexts
## Use minikube context
kubectl config use-context minikube
kubectl config current-context
kubectl cluster-info

#######################
# Browse around K8s API
#######################
kubectl proxy --port 8080 &
curl http://127.0.0.1:8080/api

######
# Pods
######
kubectl create -f resources/mongo-pod.yaml
kubectl get pods
## Labels
kubectl label pods mongo foo=bar
kubectl get pods --show-labels
kubectl get pods -l foo=bar
kubectl get pods -Lfoo

#############
# ReplicaSets
#############
kubectl create -f resources/nginx-rs.yaml
kubectl scale rs nginx --replicas=5
kubectl get pods --watch
# Delete a pod and observe
kubectl get pods
kubectl delete pod $(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}') && kubectl get pods --watch
kubectl delete rs nginx

#############
# Deployments
#############
kubectl create -f resources/nginx-deployment.yaml
kubectl scale deployment nginx --replicas=4
kubectl get pods --watch
kubectl set image deployment nginx nginx=bitnami/nginx:1.14.0-r49 --all
kubectl get rs --watch
kubectl get pods --watch
kubectl edit deployment nginx
# Rollbacks
kubectl run dokuwiki --image=bitnami/dokuwiki --record
kubectl get deployments dokuwiki -o yaml
kubectl set image deployment/dokuwiki dokuwiki=bitnami/dokuwiki:09 --all
kubectl rollout history deployment/dokuwiki
kubectl get pods
kubectl rollout undo deployment/dokuwiki
kubectl rollout history deployment/dokuwiki
kubectl delete deploy dokuwiki

##########
# Services
##########
kubectl create -f resources/nginx-svc.yaml
kubectl get svc
kubectl delete -f resources/nginx-svc.yaml
kubectl expose deployment/nginx --port=8080 --name=http --type=NodePort
kubectl get svc
curl http://$(minikube ip):$(kubectl get svc nginx -o jsonpath='{.spec.ports[0].nodePort}')

# DNS
kubectl create -f resources/busybox.yaml
kubectl exec -it busybox -- nslookup nginx
kubectl get svc
kubectl exec -ti busybox -- wget -O- http://nginx:80

#########
# Ingress
#########
## Installation
minikube addons list
minikube addons enable ingress
kubectl get deployments -n kube-system
kubectl get deployment nginx-ingress-controller -n kube-system -o yaml
## Use
kubectl create -f resources/ingress.yaml
echo "$(minikube ip)   foo.bar.com" | sudo tee -a /etc/hosts
curl http://foo.bar.com

###################
# App Configuration
###################
kubectl create -f resources/mysql.yaml
kubectl exec -it mysql -- mysql -h 127.0.0.1
# ConfigMap
kubectl delete pod mysql
kubectl create configmap mysql --from-literal=replication-mode=master \
--from-literal=replication-user=master
kubectl create -f resources/mysql-with-cm.yaml
kubectl logs -f mysql
# Secrets
kubectl delete pod mysql
kubectl create secret generic mysql --from-literal=password=root
kubectl create -f resources/mysql-with-secrets.yaml
kubectl exec -it mysql -- mysql -h 127.0.0.1 -u root -proot


############
# namespaces
############
kubectl get ns
kubectl create ns myns
kubectl get ns/myns -o yaml
cat << 'EOF' >> mongo.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mongo
  namespace: myns
spec:
  containers:
  - image: bitnami/mongodb
    name: mongo
EOF
kubectl delete ns/myns

#########
# volumes
#########
# Sharing Volumes
kubectl create -f resources/share-volume.yaml
kubectl logs -f share-volume box
kubectl delete pod share-volume
# MariaDB with persistence
kubectl create -f resources/mariadb-pvc.yaml
kubectl get pvc
kubectl create -f resources/mariadb-persitence.yaml
kubectl exec -it $(kubectl get pods -l app=mariadb -o jsonpath='{.items[0].metadata.name}') bash
mysql
show databases;
create database intel_database;
kubectl delete pod $(kubectl get pods -l app=mariadb -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $(kubectl get pods -l app=mariadb -o jsonpath='{.items[0].metadata.name}') bash
mysql
show databases;
kubectl delete pvc mariadb-data
kubectl delete deploy mariadb
