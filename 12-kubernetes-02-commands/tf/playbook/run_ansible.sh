#!/bin/bash
#ansible-galaxy role install -r requirements.yml -f && ansible-playbook -i inventory/prod/hosts.yml site.yml
ansible-playbook -i inventory/prod/hosts.yml site.yml -vv
