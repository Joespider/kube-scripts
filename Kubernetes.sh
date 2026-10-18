#!/bin/bash

Action="${1}"
shift
case ${Action} in
	--install)
		#Install Docker
		sudo apt install -y docker.io docker-ce docker-ce-cli containerd.io
		#Add user to docker user group
		sudo groupadd docker
		sudo usermod -aG docker $USER
		#Donwload and install
		curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
		sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
		#Start Minikube...first time run intall and setup kubernetes and k8s
		minikube start
		#Install Ingress
		minikube addons enable ingress
		#Install kubectl
		sudo apt install -y kubectl
		;;
	--start)
		#Start Minikube
		minikube start
		;;
	--stop)
		#Start Minikube
		minikube stop
		;;
	"--pods-"*)
		case ${Action} in
			"--pods-names")
				kubectl get pods -o json | jq -r '.items[].metadata.name'
				;;
			"--pods-ips")
				kubectl get pods -o json | jq -r '.items[].status.hostIP'
				;;
			*)
				;;
		esac
		;;
	"--service-"*)
		Service="${1}"
		if [ ! -z "${Service}" ]; then
			case ${Action} in
				"--service-ip")
					kubectl get service/${Service} -o json | jq -r '.spec.clusterIP'
					;;
				"--service-port"*)
					case ${Action} in
						"--service-port")
							kubectl get service/${Service} -o json | jq -r '.spec.ports[].targetPort'
							;;
						"--service-ports")
							kubectl get service/${Service} -o json | jq -r '.spec.ports'
							;;
						*)
							;;
					esac
					;;
				*)
					;;
			esac
		else
			kubectl get service -o json | jq -r '.items[].metadata.name' 2> /dev/null
		fi
		;;
	"--"*)
		Action="${Action##*--}"
		case ${Action} in
			nodes|pods|ingress|service)
				kubectl get ${Action} 2> /dev/null
				;;
			logs)
				kubectl ${Action} ${@} 2> /dev/null
				;;
			*)
				;;
		esac
		;;
	*)
		;;
esac
