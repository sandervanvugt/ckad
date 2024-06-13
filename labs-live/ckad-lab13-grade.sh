#!/bin/bash

# check if there is an application with the name salesweb and assume it's running enough replicas
if kubectl get deploy | grep "salesweb" >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t The deployment salesweb is running"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t The deployment salesweb is not running. Did you use \033[1mkubectl create deploy salesweb --replicas=3 --image=nginx:1.23\033[0m to start it?" && exit 3
fi

# check if there is a service resource running
if kubectl get services | grep "salesweb" >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t The service salesweb is available"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a Service with the name salesweb. Did you use \033[1mkubectl expose deploy salesweb --port=80\033[0m to start it?" && exit 4
fi

# check if the minikube ingress is on
if [[ $(minikube addons list | awk '/ingress / { print $6 }') == 'enabled' ]] >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t The minikube ingress addon is enabled"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t the minikube ingress addon is disabled. Did you use \033[1mminikube addons enable ingress\033[0m to start it?" && exit 4
fi

# check if there is host name resolving to salesweb.example.com
if nslookup salesweb.example.com &> /dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t I can find salesweb.example.com."
else
        echo -e "\033[31m[FAIL]\033[0m\t\t I cannot resolve the hostname salesweb.example.com. It should resolve to the minikube IP address. Did you use \033[1mminikube ip\033[0m to find the minikube IP address and add a line to your local Linux /etc/hosts file that resolves salesweb.example.com to that IP address? It should look like \033[1m192.168.49.2  salesweb.example.com\033[0m" 
	exit 6
fi

# check if curl salesweb.example.com is giving a result
if curl -s salesweb.example.com | grep -i 'welcome' &> /dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Succesfully contacted the name based virtual host provided by Ingress"
else
	echo -e "\033[31m[FAIL]\033[0m\t\t The kubernetes ingress resource isn't doing it's work (yet). Give it a few seconds and then try again. If it still doesn't work, check if you used \033[1mkubectl create ingress salesweb --rule=\"salesweb.example.com/=salesweb:80\"\033[0m to create it?" && exit 4
fi


# succesfull completion
echo
echo -e "\033[32m[CONGRATS]\033[0m\t you have succesfully completed this lab, please move on to the next lesson"
echo
