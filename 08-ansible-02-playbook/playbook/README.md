# Описание playbook

playbook устанавливает: java, Elasticsearch, kibana 

##  Окружение
1. Подняты 2 виртуальных машины в YC с помощью terraform
- [main.tf](https://github.com/dotsenkois/devops-netology/blob/main/08-ansible-02-playbook/terraform/main.tf)
- [versions.tf](https://github.com/dotsenkois/devops-netology/blob/main/08-ansible-02-playbook/terraform/varisons.tf)

2. Параметры подключения описаны в inventory
  
### tags: 
- java - установка JDK-17 на всех хостах
- elasticsearch - установка elasticsearch на указанном хосте 
- kibana - установка elasticsearch на указанном хосте
