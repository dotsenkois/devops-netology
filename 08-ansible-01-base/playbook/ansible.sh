#!/bin/bash 
images_list_base=( "fedora:latest" "ubuntu:latest" "centos:7" )

for image in ${images_list_base[@]}
    do
        if [[ "$(docker images -q $image 2> /dev/null)" == "" ]]; then
            docker pull $image
        fi
    done
if [[ "$(docker images -q my_ubuntu:latest 2> /dev/null)" == "" ]]; then
           docker build . --tag my_ubuntu
        fi

containers_list=( fedora ubuntu centos7 )
images_list_local=( fedora:latest my_ubuntu:latest centos:7 )

for (( i = 0; i < ${#images_list_local[@]}; i++ ))
do
    docker run --name ${containers_list[$i]} -d ${images_list_local[$i]} sleep 60000
done

sleep 10
ansible-playbook -i inventory/prod.yml site.yml --vault-pass-file credentials 

for container in ${containers_list[@]}
    do
        docker stop $container && docker rm $container
    done
