
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на [dotsenkois/nginx_netology](https://hub.docker.com/repository/docker/dotsenkois/nginx_netology).
```
vagrant@server1:~/share$ sudo docker run --tty --detach --name nginx_netology --volume ${HOME}/share:/usr/share/nginx/html --publish=80:80 nginx
c4c79bd56a1f88253f4e5d50c5a27fc573d6e42f067d14a58ce21b3dac3cd092
vagrant@server1:~/share$ curl localhost
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- *Высоконагруженное монолитное java веб-приложение;* Виртаулка. 
- *Nodejs веб-приложение;* Контейнер. Образ node.js есть на hub.docker.com
- *Мобильное приложение c версиями для Android и iOS;* Контейнер. Без разницы, для чего предназначено приложение. 
- *Шина данных на базе Apache Kafka;* "Окей, Гугл, что такое Шина данных на базе Apache Kafka"
- *Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;* <br> Рискну предположить, что все вышеперечисленное можно запихать в контейнеры. Две ноды могут превраиться в три, а три в четыре, а контейнеры наиболее простой сопособ масштабирования систем. А вообще не знаком с указанным программным обеспечением.
- Мониторинг-стек на базе Prometheus и Grafana;
- *MongoDB, как основное хранилище данных для java-приложения;* Для бытродействия БД желательно ее  эксплуатация на железе, либо виртуалка, если нагрузка не велика.
- *Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.* При условии, что версионироваться будут тектовые файлы, большой нагрузки на сервер скорее всего не будет, по этому считаю, что будет достаточно контейнера.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```
root@server1:/data# docker run --tty --detach --name deb_neto --volume /data:/data debian
134ea25fdb8d0a554b57def840e6fe04a82de3b70f5ee30c821e273a19397f0d
root@server1:/data# docker run --tty --detach --name cent_neto --volume /data:/data centos
102ec8b3c4df17a9e49a10bd2bbb327766a5d22e2b911c6a7959d258696d6340
root@server1:/data# docker exec -it cent_neto bash
[root@102ec8b3c4df /]# cd /data/
[root@102ec8b3c4df data]# ls
[root@102ec8b3c4df data]# touch some_file_form_cent
[root@102ec8b3c4df data]# exit
exit
root@server1:/data# touch /data/some_file_from_host
root@server1:/data# docker exec -it deb_neto bash
root@134ea25fdb8d:/# ls /data/
some_file_form_cent  some_file_from_host
root@134ea25fdb8d:/#
exit
root@server1:/data#
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

[dotsenkois/ansible](https://hub.docker.com/repository/docker/dotsenkois/ansible)