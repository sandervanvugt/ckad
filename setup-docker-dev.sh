#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtimes

# setting MYOS variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }') 
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }') 

if [ $MYOS = "CentOS" ]
then
	if [ $OSVERSION = 8 ]
	then
		echo CentOS 8 is not currently supported
		exit 9
	fi

	sudo yum install -y vim yum-utils device-mapper-persistent-data lvm2
	sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

	# notice that only verified versions of Docker may be installed
	# verify the documentation to check if a more recent version is available

	sudo yum install -y docker-ce
	[ ! -d /etc/docker ] && mkdir /etc/docker
fi

if [ $MYOS = "Ubuntu" ]
then
	sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update && sudo apt-get install -y containerd.io=1.2.13-2 docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) 
fi

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

sudo systemctl disable --now firewalld
