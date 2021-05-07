# Part I

## Create frontend deployment
kubectl create -f part-i/frontend-deployment.yaml
## Get Pod Name & Port-Forwarding
kubectl port-forward $(kubectl get pods -l app=guestbook,tier=frontend -o jsonpath="{.items[0].metadata.name}") 3000:3000 &
curl 127.0.0.1:3000
## Acces via browser to 127.0.0.1:3000

## Create backend deployment
kubectl create -f part-i/redis-master-deployment.yaml
kubectl create -f part-i/redis-slave-deployment.yaml

# Part II

## Create backend services
kubectl create -f part-ii/redis-master-service.yaml
kubectl create -f part-ii/redis-slave-service.yaml
## Create frontend services
kubectl create -f part-ii/frontend-service.yaml
## Get NODE_PORT and access frontend
curl $(minikube ip):$(kubectl get svc frontend -o jsonpath="{.spec.ports[0].nodePort}")
## Acces via browser to: 
echo "$(minikube ip):$(kubectl get svc frontend -o jsonpath="{.spec.ports[0].nodePort}")"

# Part III

## Remove old frontend service
kubectl delete svc frontend
## Create frontend service
kubectl create -f part-iii/frontend-service.yaml
kubectl create -f part-iii/ingress.yaml
## Edit hosts
## Windows Users: https://blog.kowalczyk.info/article/10c/local-dns-modifications-on-windows-etchosts-equivalent.html
echo "$(minikube ip)   guestbook-site.com" | sudo tee -a /etc/hosts
## Acces via browser to guestbook-site.com