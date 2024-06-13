#!/bin/bash

# check if there is an application with the name lab12deploy and assume it's running enough replicas
if kubectl get deploy | grep "lab12deploy" >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t The deployment lab12deploy is running"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t The deployment lab12deploy is not running. Did you use \033[1mkubectl create deploy lab12deploy --replicas=3 --image=nginx:1.23\033[0m to start it?" && exit 3
fi

# check if there is a service resource running
if kubectl get services | grep "lab12svc" >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t The service lab12svc is available"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a Service with the name lab12svc. Did you use \033[1mkubectl expose deploy lab12deploy --name lab12svc --port=80\033[0m to start it?" && exit 4
fi


# check if the service is of the NodePort type
if kubectl get services lab12svc | grep -i 'nodeport' &> /dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Good! The Service is set as a NodePort type"
else
	echo -e "\033[31m[FAIL]\033[0m\t\t I did find the Service, but it is using the wrong type. Use \033[1mkubectl edit svc lab12svc\033[0m to open the default editor, and change the type line to read \033[1mtype: NodePort\033[0m. Also make sure to include \033[1mnodePort: 32000\033[0m to set the exposed port on nodes to 32000." && exit 4
fi


# check if the service is accessible on nodeport 32000
if kubectl get services lab12svc | grep -i '32000' &> /dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Good! The Service is accessible through port 32000 on the Kubernetes nodes"
else
        echo -e "\033[31m[FAIL]\033[0m\t\t You did correctly set the NodePort Service type, but forgot to specify the nodePort setting. Use \033[1mkubectl edit svc lab12svc\033[0m to open the default editor, and change the nodePort line to read \033[1mnodePort: 32000\033[0m" && exit 4
fi

echo
echo -e "\033[32m[CONGRATS]\033[0m\t you have succesfully completed this lab, please move on to the next lesson"
echo
