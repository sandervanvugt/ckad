#!/bin/bash
# added 23 Feb. 2022
# currently only supported on WSL2 - Ubuntu

sudo apt-get update
sudo apt-get upgrade -y

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
####
echo the script is now ready
echo manually run "minikube start --vm-driver=docker" to start minikube

sudo usermod -aG docker $USER
newgrp docker

minikube start --vm-driver=docker --cni=calico
