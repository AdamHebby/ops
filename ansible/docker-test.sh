#!/bin/bash

DOCKER_CONTAINER_NAME="ansible-glimesh-web"

if [[ "$(docker images -q $DOCKER_CONTAINER_NAME 2> /dev/null)" == "" ]]; then
    cd docker && docker build -t ansible-glimesh-web . && cd ..
fi

if [[ "$(docker ps | grep -q $DOCKER_CONTAINER_NAME 2> /dev/null)" == "" ]]; then
    docker run -ti --privileged --name $DOCKER_CONTAINER_NAME -d -p 5000:22 $DOCKER_CONTAINER_NAME
fi

ansible-playbook -i hosts_docker docker/build-fake-deploys.yml

ansible-playbook -i hosts_docker playbook.yml --tags cleanup

docker stop $DOCKER_CONTAINER_NAME
docker rm $DOCKER_CONTAINER_NAME
