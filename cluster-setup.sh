#!/bin/bash
# this script automatically sets up a one node all-in-one kubernetes cluster
# before running this script, make sure to use setup-docker.sh and setup-kubetools.sh 
# to take care of required software
sudo yum install -y wget vim curl bash-completion

sudo kubeadm init --pod-network-cidr=10.10.0.0/16
mkdir ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -un):$(id -un) .kube/config

kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
wget https://docs.projectcalico.org/manifests/custom-resources.yaml
sed -i -e s/192.168.0.0/10.10.0.0/g custom-resources.yaml
kubectl create -f custom-resources.yaml

echo waiting for calico pods to appear
sleep 120
kubectl get pods -n calico-system

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl get all
