CREATE DATABASE "test_db";
\c test_db
CREATE USER "test-admin-user";
CREATE USER "test-simple-user";
CREATE TABLE orders (
    id              serial primary key,
    наименование    TEXT,
    цена            integer
    );
CREATE TABLE clients (
    id                  serial primary key,
    фамилия             TEXT,
    "страна проживания" CHAR(20),
    заказ               integer,
    foreign key (заказ) REFERENCES orders (id)
    );
GRANT ALL PRIVILEGES ON TABLE orders, clients TO "test-admin-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE clients, orders TO "test-simple-user";
-- итоговый список БД после выполнения пунктов выше,
\l 
-- описание таблиц (describe)
\d "orders"
\d "clients"
-- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
select * from information_schema.table_privileges where table_name in ('clients','orders') and grantee not in (user);
-- список пользователей с правами над таблицами test_db