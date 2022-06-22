#!/bin/python3

import json
import datetime
import subprocess

today = datetime.datetime.today()

log_file_name = f'/var/log/{today.strftime("%Y-%m-%d-awesome-monitoring.log")}'
timestamp = today.strftime("%H-%M-%S")

print(log_file_name)
with open ('/proc/loadavg','r', encoding = 'utf-8') as info:
    info_dict = info.read().split(' ')
    loadavg =  {'Load 1 m':info_dict[0],
                'Load 5 m':info_dict[1],
                'Load 15 m':info_dict[2],
                }


with open ('/proc/meminfo','r', encoding = 'utf-8') as info:
    info_dict = info.read().split('\n')
    MemAvailable = info_dict[2].split('     ')
    SwapFree = info_dict[15].split('     ')
    meminfo = { MemAvailable[0][:-1]:MemAvailable[1].strip(),
                SwapFree[0][:-1]:SwapFree[1].strip()
            }


inodes = {}
useless_cat_call = subprocess.Popen(["df","-li"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
df = useless_cat_call.communicate()
df1 = str(df).split('\\n')
for inodes_parameter in df1:
    if inodes_parameter[0] == "/":
        params = inodes_parameter.split(' ')
        disk_name = inodes_parameter.split(' ')[0]
        for index in range(len(params)):
            if params[index] != '' and params[index][0] != '/':
                free_inodes = params[index+2]
                inodes.setdefault(disk_name,free_inodes) 
                break


awesome_monitoring = {  'timestamp':timestamp,
                        'loadavg':loadavg,
                        'meminfo':meminfo,
                        'free inodes':inodes
                        }

with open (log_file_name,'a', encoding = 'utf-8') as log:
    json.dump(awesome_monitoring, log)
