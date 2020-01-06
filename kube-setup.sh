#!/bin/bash
#
# verified on Fedora 31 WS


# add vbox repo
rm -f /etc/yum.repos.d/vbox.repo

cat << REPO >> /etc/yum.repos.d/vbox.repo
[virtualbox]
name=Fedora $releasever - $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/\$releasever/\$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc
REPO

dnf clean all
dnf upgrade

# install vbox
echo installing virtualbox
dnf install make perl kernel-devel gcc elfutils-libelf-devel -y
dnf install VirtualBox-6.1 -y
echo installing kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/%60curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt%60/bin/linux/amd64/kubectl 

echo downloading minikube, check version
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

chmod +x minikube
chmod +x kubectl
cp minikube /usr/local/bin
cp kubectl /usr/bin/

echo at this point, reboot your Fedora Server. After reboot, manually run:
echo vboxconfig
echo minikube start
