#!/bin/bash

# check if the file index.html exists and contains the text lab15
if grep "lab15" index.html &>/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t Found the file index.html containing the text lab15"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t Cannot find the file index.html with the content \"Welcome to lab15\". Did you use \033[1mecho \"Welcome to lab15\" > index.html\033[0m to create it?" && exit 3
fi

# check that the configmap webcontent exists
if kubectl get cm | grep "webcontent" >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t ConfigMap \033[1mwebcontent\033[0m was found"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a ConfigMap with the name webcontent. Did you use \033[1mkubectl create cm webcontent --from-file=index.html\033[0m to create it?" && exit 4
fi

# check that the deployment lab15 exists
if kubectl get deploy | grep "lab15" >/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t Deployment lab15 was found"
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find a Deployment with the name lab15. Did you use \033[1mkubectl create deploy lab15 --image=nginx\033[0m to start it?" && exit 4
fi

# check that the index.html file is mounted on the deployment pod index.html location
PODNAME=$(kubectl get pods -l app=lab15 --no-headers -o custom-columns=":metadata.name")

if kubectl exec $PODNAME --  grep lab15 /usr/share/nginx/html/index.html &>/dev/null
then 
	echo -e "\033[32m[OK]\033[0m\t\t Found the Pod $PODNAME with an index.html that contains the text \"Welcome to lab15\" "
else 
	echo -e "\033[31m[FAIL]\033[0m\t\t I cannot find the text \"Welcome to lab15\" in the index.html file from the ConfigMap. Did you mount the ConfigMap in the Deployment? There is no easy way to do this from the command line, but you can check the file \033[1mtestdeploy.yaml\033[0m in the course git repository and tweak it to mount your configmap to create it. If you have earlier succesfully created the Deployment, you might want to run \033[1mkubectl delete deploy lab15\033[0m to delete the old Deployment and use \033[1mkubectl apply lab15.yaml\033[0m to create the new deployment." && exit 4
fi

echo
echo -e "\033[32m[CONGRATS]\033[0m\t you have succesfully completed this lab, please move on to the next lesson"
echo
