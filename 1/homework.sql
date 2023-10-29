-- Домашнее задание по 1 теме
--Выполняется на Windows

-- Задание 1

-- в cmd:
-- cd "C:\Program Files\PostgreSQL\16\bin"
-- createdb -h localhost -p 5432 -U postgres -W sqlp33_homework1
-- curl.exe --output "D:\Soft\SQLP\hr.sql" --insecure --url https://letsdocode.ru/sql-pro/hr.sql
-- psql -h localhost -p 5432 -U postgres -W sqlp33_homework1 < "D:\Soft\SQLP\hr.sql"

-- в интерактивном режиме:

-- \! chcp 1251
-- set client_encoding='win1251'
GRANT ALL PRIVILEGES ON DATABASE "sqlp33_homework1" to postgres;
-- \c sqlp33_homework1
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA hr TO postgres;
SELECT * FROM pg_catalog.pg_tables WHERE schemaname = 'hr';
SELECT * FROM hr.city LIMIT 5;
SELECT column_name FROM information_schema.columns WHERE table_schema='hr' AND table_name='city';

-- Задание 2

create role MyUser with login;

SELECT date_trunc('month', NOW()) + interval '1 month -1 day' AS lastDayOfTheMonth;
--   lastdayofthemonth
------------------------
-- 2023-10-31 00:00:00+03

alter role MyUser with password '1234' valid until '2023-10-31';
grant usage on schema hr to MyUser;
grant select on table hr.city, hr.address to MyUser;
revoke usage on schema hr from MyUser;
revoke select on table hr.city, hr.address from MyUser;
drop role MyUser;

SELECT rolname FROM pg_roles;

-- Задание 3

BEGIN;
--DECLARE lastId int;
INSERT INTO hr.projects
(project_id, "name", employees_id, amount,
assigned_id, created_at)
VALUES(
(select max(project_id) + 1 from hr.projects)::int,
'test 1', '{390,2551}', 100000, 390, NOW())
RETURNING project_id; --into lastId;

SAVEPOINT first;

delete from hr.projects
where project_id = (select max(project_id) from hr.projects)::int;

ROLLBACK TO SAVEPOINT first;

--select NOW(), lastId;
COMMIT;