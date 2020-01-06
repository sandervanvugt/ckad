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

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl

echo downloading minikube, check version
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

chmod +x minikube
chmod +x kubectl
cp minikube /usr/local/bin
cp kubectl /usr/bin/

echo at this point, reboot your Fedora Server. After reboot, manually run:
echo vboxconfig
echo minikube start
