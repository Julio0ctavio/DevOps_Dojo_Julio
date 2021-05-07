##Install kubectl command line interface 
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

##Install docker 
apt install docker.io -y 

##assign the user ubuntu to the same docker group
usermod -aG docker ubuntu 

##Minikube installation 
apt-get update
apt-get install apt-transport-https -y 
#apt install virtualbox virtualbox-ext-pack -y 
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
mv minikube-linux-amd64 /usr/local/bin/
cd /usr/local/bin/
mv minikube-linux-amd64 minikube
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/
su ubuntu
minikube start

#Initialize minikube cluster 
minikube start --vm-driver=docker
