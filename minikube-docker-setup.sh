#!/bin/bash

ARCH=$(arch)

### installing Docker
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

if [ $ARCH = "x86_64" ]
then
	echo executing on $ARCH
	#sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
	#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	#sudo apt-get update -y
	#sudo apt-get install docker-ce docker-ce-cli containerd.io -y

	curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi

if [ $ARCH = "aarch64" ]
then
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
	sudo install minikube-linux-arm64 /usr/local/bin/minikube
	sudo snap install kubectl --classic	
fi

echo the script is now ready
echo manually run minikube start --memory=6g --cpus=4 --vm-driver=docker to start minikube

sudo usermod -aG docker $USER
newgrp docker
