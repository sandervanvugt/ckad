#!/bin/bash

if kubectl get pods | grep lab6pod >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t The pod lab6pod is running"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a pod with the name lab6pod. Did you use \033[1mkubectl run lab6pod --image=nginx\033[0m to start it?" && exit 3
fi

if [ ! -f /tmp/ckad-lab6-check1 ]
then
	if kubectl get pods lab6pod -o yaml | grep '512Mi' >/dev/null
	then 
		echo -e "\033[32m[OK]\033[0m\t\t The pod lab6pod is restricted to using 512 MiB RAM"
	else 
		echo -e "\033[31m[FAIL]\033[0m\t\t I did find the pod with the name lab6pod, but it doesn't have the appropriate resource restrictions. Unfortunately, the \033[1mkubectl set resources \033[0mcommand doesn't work for Pods. To fix this, use \033[1mkubectl run lab6pod --image=nginx --dry-run=client -o yaml > lab6pod.yaml\0330m to generate the lab6pod.yaml file, and edit it with the appropriate resource restrictions. Remember, you can find many examples in the Kubernetes documentation at \033[1mhttps://kubernetes.io/docs\033[0m. Next, use \033[1mkubectl apply -f lab6pod.yaml\033[0m to create it."
	        touch /tmp/ckad-lab6-check1 	
		exit 4
	fi
fi

if kubectl get pods lab6pod -o yaml | grep '512Mi' >/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t The pod lab6pod is restricted to using 512 MiB RAM"
else
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a memory restriction of 512 MiB on the lab6pod. If you followed my previous instructions, you should now have a file with the name lab6pod.yaml. Make sure that within the \033[1mspec.containers\033[0m section it contains the following: \033[0m\r\n\r\ni    resources:\r\n      limits:\r\n        memory: "512Mi"\r\n\r\n\033[0mNext, use \033[1mkubectl apply -f lab6pod.yaml\033[0m to create it."
	exit 3
fi

echo
echo -e "\033[32m[CONGRATS]\033[0m you have succesfully completed this lab, please move on to the next lesson"
echo
