#!/bin/env
import pprint, yaml, pathlib
vm_list  = {}
file = open("/home/dotsenkois/repository/ansible-secret/terraform/output.txt", "r")
while True:
    # считываем строку
    line = file.readline()
    splitedLine = line.split("|")
    if len(splitedLine) > 1:
        if splitedLine[0] == '' and splitedLine[1].strip() != 'ID' :
            vm = {'ID': splitedLine[1].strip(), 'NAME': splitedLine[2].strip(),'ZONE ID': splitedLine[3].strip(),'STATUS': splitedLine[4].strip(), 'EXTERNAL IP': splitedLine[5].strip(),'INTERNAL IP': splitedLine[6].strip(), }

            vm_list.setdefault(vm['NAME'],vm)
    if not line:
        break
# выводим строк
file.close()
hosts_all = {"hosts": {}, "vars":{"ansible_connection": "ssh", "ansible_user": "dotsenkois"}}
hosts_elasticsearch = {"hosts":{}}
hosts_kibana = {"hosts":{}}
hosts_app = {"hosts":{}}

for vm in vm_list.values():
    hosts_all["hosts"].setdefault(vm["NAME"],{"ansible_host":vm["EXTERNAL IP"]})
    if 'es' in vm["NAME"]:
        hosts_elasticsearch["hosts"].setdefault(vm["NAME"], {"ansible_host":vm["EXTERNAL IP"]})
    if 'kib' in vm["NAME"]:
        hosts_kibana["hosts"].setdefault(vm["NAME"], {"ansible_host":vm["EXTERNAL IP"]})
    if 'app' in vm["NAME"]:
        hosts_app["hosts"].setdefault(vm["NAME"], {"ansible_host":vm["EXTERNAL IP"]})


hosts = {"all":hosts_all,"elasticsearch":hosts_elasticsearch,"kibana":hosts_kibana,"app":hosts_app,}

with open("/home/dotsenkois/repository/ansible-secret/playbook/inventory/prod/hosts.yml", 'w') as f:
    yaml.dump(hosts, f, default_flow_style=False)

# pprint.pprint(hosts)
	