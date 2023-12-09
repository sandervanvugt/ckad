#!/bin/bash

if [ ! -f /tmp/ckad-lab5-check1 ]
then
	if kubectl get cronjobs | grep hellojob
	then 
		echo -e "\033[32m[OK]\033[0m\t\t A cronjob with the name hellojob was found"
	else 

		echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a cronjob with the name hellojob. Did you use \033[1mkubectl create cronjob\033[0m with the right options to create it?" 

		touch /tmp/ckad-lab5-check1
		exit 3
	fi
fi


if kubectl get cronjobs | grep hellojob
then 
	echo -e "\033[32m[OK]\033[0m\t\t A cronjob with the name hellojob was found"
else 

	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a cronjob with the name hellojob. Did you use \033[1mkubectl create cronjob hellojob --image busybox --schedule \"*/5 * * * *\" -- echo hello\033[0m to create it?" && exit 3
fi



## congratulations!
echo
echo -e "\033[32m[CONGRATS]\033[0m\t you have succesfully completed this lab\! Remember that it can take up to 5 minutes before the job runs for the first time. After confirming that,  please move on to the next lesson"
echo
