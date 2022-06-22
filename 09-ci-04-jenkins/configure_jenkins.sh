#!/bin/bash
if test -e ./terraform/.terraform; then
    cd ./terraform
    terraform apply --auto-approve
else
  mkdir terraform && cd terraform
  terraform init
fi