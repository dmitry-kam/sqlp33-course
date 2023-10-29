-- Домашнее задание по 1 теме
--Выполняется на Windows

-- Задание 1

-- в cmd:
cd "C:\Program Files\PostgreSQL\16\bin"
createdb -h localhost -p 5432 -U postgres -W sqlp33_homework1
curl.exe --output "D:\Soft\SQLP\hr.sql" --insecure --url https://letsdocode.ru/sql-pro/hr.sql
psql -h localhost -p 5432 -U postgres -W sqlp33_homework1 < "D:\Soft\SQLP\hr.sql"

-- в интерактивном режиме:

\! chcp 1251
set client_encoding='win1251'
GRANT ALL PRIVILEGES ON DATABASE "sqlp33_homework1" to postgres;
\c sqlp33_homework1
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO postgres;
SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'hr';
SELECT * FROM hr.city LIMIT 5;
SELECT column_name FROM information_schema.columns WHERE table_schema='hr' AND table_name='city';

-- Задание 2

