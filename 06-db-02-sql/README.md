# Домашнее задание к занятию "6.2. SQL"

## Задача 1
docker-compose манифест

```YAML
version: '3.1'
services:
  db:
    image: postgres:12
    restart: always
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: neto_pgdb
      PGDATA: "/var/lib/postgresql/data/pgdata"
    volumes:
      - .PG/data:/var/lib/postgresql/data
      - .PG/bkp:/var/lib/postgresql
    ports:
      - "5432:5432"


```

## Задача 2

[файл запросов](02.sql) <br>

Приведите:

- итоговый список БД после выполнения пунктов выше
- описание таблиц (describe)
<p align="center">
  <img src="./02_0.png">
</p>
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
select * from information_schema.table_privileges where table_name in ('clients','orders') and grantee not in (user);
```

- список пользователей с правами над таблицами test_db
<p align="center">
  <img src="./02_1.png">
</p>

## Задача 3

```sql
INSERT INTO orders (наименование, цена) VALUES ('Шоколад', 10);
INSERT INTO orders (наименование, цена) VALUES ('Принтер', 3000);
INSERT INTO orders (наименование, цена) VALUES ('Книга', 500);
INSERT INTO orders (наименование, цена) VALUES ('Монитор', 7000);
INSERT INTO orders (наименование, цена) VALUES ('Гитара', 4000);
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Иванов Иван Иванович', 'USA');
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Петров Петр Петрович', 'Canada');
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Иоганн Себастьян Бах', 'Japan');
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Ронни Джеймс Дио', 'Russia');
INSERT INTO clients (фамилия, "страна проживания") VALUES ('Ritchie Blackmore', 'Russia');

select count(*) from clients;
select count(*) from orders;
```

<p align="center">
  <img src="./03.png">
</p>


## Задача 4

Приведите SQL-запросы для выполнения данных операций.
```sql
UPDATE clients SET заказ = 3 WHERE фамилия = 'Иванов Иван Иванович';
UPDATE clients SET заказ = 4 WHERE фамилия = 'Петров Петр Петрович';
UPDATE clients SET заказ = 5 WHERE фамилия = 'Иоганн Себастьян Бах';
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sql
select фамилия from clients WHERE заказ is not null;
```

<p align="center">
  <img src="./04.png">
</p>


## Задача 5

<p align="center">
  <img src="./05.png">
</p>

- QUERY PLAN - *план запрса*
- Seq Scan on public.clients  - *поиск производится в объекте таблица public.clients*
- cost=0.00..15.30
- rows=527 width=32  - *предположительно высота и ширина выводимой таблицы в пикселях*
- Output: "фамилия" - *возвращаются значчения колонки "фамилия"*
Filter: (clients."заказ" IS NOT NULL)  - *фильтр поиска (WHERE)*


## Задача 6

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

instance 1:
- pg_dump -U user > /var/lib/postgresql/test_db.dump
instance 2:
- [манифест](docker-compose_06.yml)
- psql -U user -d neto_pgdb
- CREATE DATABASE "test_db";
- psql -U user test_db < /var/lib/postgresql/test_db.dump

<p align="center">
  <img src="./06.png">
</p>