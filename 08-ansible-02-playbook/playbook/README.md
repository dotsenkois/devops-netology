# Описание playbook

playbook устанавливает: java, Elasticsearch, kibana 

##  Окружение
1. Подняты 2 виртуальных машины в YC с помощью terraform
2. Параметры подключения описаны в inventory
  
### tags: 
- java - установка JDK-17 на всех хостах
- elasticsearch - установка elasticsearch на указанном хосте 
- kibana - установка elasticsearch на указанном хосте
