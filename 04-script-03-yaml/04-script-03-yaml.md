# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
	```json
    { "info" : "Sample JSON output from our service/\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
    }

```
  <br>Нужно найти и исправить все ошибки, которые допускает наш сервис

2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.
```python3
import socket
import json
import yaml

def overwrite(host, o_ip, n_ip):
    print(f'[ERROR] {host} IP mismatch: old IP - {o_ip} new IP- {n_ip}')
    want_overwrite = input("Хотите перезаписать ip адрес хоста? y/n")
    if want_overwrite == "y":
        return n_ip
    elif want_overwrite == "n":
        return o_ip
    else:
        overwrite(host, o_ip, n_ip)

def main():
    host_names = ["drive.google.com", "mail.google.com", "google.com"]
    hosts = {}
    j=0
    while j < 10000:
        for host in host_names:
            ip_address = socket.gethostbyname(host)
            if host in hosts.keys():
                if hosts[host] == ip_address:
                    print(f'{host} - {ip_address}')
                else:
                    hosts[host] = overwrite(host, hosts[host], ip_address)
            else:
                hosts[host] = ip_address
                print(f'{host} - {ip_address}')
        with open("hosts.json", "w") as js:
            json.dump(hosts,js)
        with open("hosts.yaml", "w") as yam:
            yaml.dump(hosts, yam)

        j+=1

if __name__== "__main__":
  main()
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов
```python3
import sys
import json
import yaml
from yaml.loader import SafeLoader


def json_parse(file_name):
    try:
        with open(file_name, "r") as js:
            j = json.load(js)
            with open("export.yaml", "w") as ex:
                yaml.dump(j, ex)
    except ValueError:
        yaml_parse(file_name)


def yaml_parse(file_name):
    try:
        with open(file_name, "r") as yam:
            y = yaml.load(yam, Loader=SafeLoader)
            if type(y) is dict:
                with open('export.json', "w") as ex:
                    json.dump(y, ex)
            else:
                print('Файл не является JSON или YAML')
    except ValueError:
        print('Файл не является JSON или YAML')


def main():
    file_name = sys.argv[1].replace(".\\", '')
    json_parse(file_name)


if __name__ == "__main__":
    main()
    
```
---
