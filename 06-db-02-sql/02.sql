CREATE USER "test-admin-user";
CREATE DATABASE "test_db";
CREATE TABLE orders (
    id              serial primary key,
    наименование    TEXT,
    цена            integer
    );
CREATE TABLE clients (
    id                  serial primary key,
    "страна проживания" CHAR(20),
    заказ               integer,
    foreign key (заказ) REFERENCES orders (id)
    );
GRANT ALL PRIVILEGES ON orders, clients TO "test-admin-user";
CREATE USER "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE clients, orders TO "test-simple-user";

--Приведите:
-- итоговый список БД после выполнения пунктов выше,
\l 
-- описание таблиц (describe)
\d "orders"
\d "clients"
-- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
SELECT * FROM pg_catalog.pg_user;

-- список пользователей с правами над таблицами test_db
