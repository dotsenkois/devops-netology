#!/bin/bash
cd ./terraform
terraform plan 
terraform apply --auto-approve
yc compute instance list --folder-id $YC_FOLDER_ID > output.txt
./parser.py
cd ../playbook
pwd
ssh -o "StrictHostKeyChecking no" dotsenkois@$
ansible-playbook -i inventory/prod/hosts.yml site.yml