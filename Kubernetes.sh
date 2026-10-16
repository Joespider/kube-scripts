#!/bin/bash

Action="${1}"
case ${Action} in
	--install)
		#Donwload and install
		curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
		sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
		#Start Minikube...first time run intall and setup kubernetes and k8s
		minikube start
		#Install Ingress
		minikube addons enable ingress
		#Install kubectl
		sudo apt install kubectl
		;;
	--add-docker)
		#Add user to docker user group
		sudo groupadd docker
		sudo usermod -aG docker $USER
		;;
	--start)
		#Start Minikube
		minikube start
		;;
	--stop)
		#Start Minikube
		minikube stop
		;;
	"--"*)
		Action="${Action##*--}"
		case ${Action} in
			pods|ingress|service)
				kubectl get ${Action}
				;;
			*)
				;;
		esac
		;;
	*)
		;;
esac
