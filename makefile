install-kind:
	sh install_kinD.sh

cluster:
	kind create cluster --name=livek8s

build:
	rm ./bin/server && go build -o ./bin/server ./src/*

run:
	./bin/server

dockerbuild:
	docker build -t igorferreira/fullcycle:latest .

dockerrun:
	docker run -p 3000:3000 -t igorferreira/fullcycle:latest

call:
	curl localhost:3000

deploy:
	kubectl apply -f ./deployment.yml

deploy-pull-secret:
	kubectl apply -f ./deployment-pull-secret.yml

scale-zero:
	kubectl scale deployment $(app) --replicas=0

# references: 
# https://code-examples.net/en/q/21caaf
# https://makefiletutorial.com/
.PHONY: scale
scale:
	kubectl scale deployment $(app) --replicas=$(qtd) && kubectl get pods

pods:
	kubectl get pods

secret-docker:
	docker login && \
	kubectl create secret generic dockerhub \
    --from-file=.dockerconfigjson=/home/igorferreira/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

secret-docker-login:
	kubectl create secret docker-registry dockerhub \
	 --docker-server=docker.io \
	 --docker-username=igorferreira \
	 --docker-password=<your-password> \
	 --docker-email=igorferreirabr@gmail.com

service-deploy:
	kubectl apply -f service.yml

# https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/#forward-a-local-port-to-a-port-on-the-pod
port-forward:
	kubectl port-forward service/fullcycle-service 3000:3000 & \
	jobs -p > .port-forward.pid

delete-port-forward:
	echo "kill `cat ./.port-forward.pid`" && kill -9 `cat ./.port-forward.pid`

get-pid-port-forward:
	cat ./.port-forward.pid && \
	ps -edf | grep `cat ./.port-forward.pid`