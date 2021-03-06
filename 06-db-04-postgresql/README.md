# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД <br>**\l[+]   [PATTERN]      list databases**
- подключения к БД <br>**\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo} connect to new database (currently neto_pgdb")**
- вывода списка таблиц <br>**\dt[S+] [PATTERN]      list tables**
- вывода описания содержимого таблиц <br>**\d[S+]  NAME           describe table, view, sequence, or index**
- выхода из psql <br>**Use \q to quit.**

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```sql

SELECT attname, avg_width FROM pg_stats
WHERE avg_width = (SELECT MAX(avg_width) FROM pg_stats where tablename = 'orders' ) ;
```

<p align="center">
  <img src="./screens/02.select.png">
</p>

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```sql
alter table orders rename to orders_old;
create table orders (like orders_old) partition by range (price);

CREATE TABLE orders_1
    PARTITION OF orders
    FOR VALUES FROM (499) TO (999999999);

CREATE TABLE orders_2
    PARTITION OF orders
    FOR VALUES FROM (0) TO (499);

insert into orders select * from orders_old;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
<br>
*** Исключить ручное разбиени было можно на этапе проектирвоаниея системы предусмотрев создание таблиц необходимых для шардирования***

## Задача 4

Используя утилиту `pg_dump` создайте [бекап](dump.sql) БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
    CONSTRAINT unique_title UNIQUE (title)
);
```