select *
from pg_catalog.pg_roles pr

create role test_user with login password '123'

alter role test_user valid until '31/12/2023'

ddl не любит подзапросы.

create database "sqlfree-4"

revoke all privileges on database "sqlfree-4" from test_user

revoke all privileges on database "sqlfree-4" from public

grant connect on database "sqlfree-4" to test_user

grant create on database "sqlfree-4" to test_user

revoke all privileges on schema public from test_user

revoke all privileges on schema pg_catalog from test_user

revoke all privileges on schema information_schema from test_user

revoke all privileges on schema public from public

revoke all privileges on schema pg_catalog from public

revoke all privileges on schema information_schema from public

grant usage on schema public to test_user

grant usage on schema pg_catalog to test_user

grant usage on schema information_schema to test_user

revoke all on all tables in schema public from test_user

revoke all on all tables in schema pg_catalog from test_user

revoke all on all tables in schema information_schema from test_user

revoke all on all tables in schema public from public

revoke all on all tables in schema pg_catalog from public

revoke all on all tables in schema information_schema from public

grant select on all tables in schema public to test_user

grant select on all tables in schema pg_catalog to test_user

grant select on all tables in schema information_schema to test_user

create schema test_schema

grant usage on schema test_schema to test_user

grant all on all tables in schema public to test_user

grant all on table test_schema.a, test_schema.b, test_schema.c to test_user

drop role test_user

select * 
from information_schema.role_table_grants 
where grantee = 'test_user' and privilege_type in ('SELECT', 'INSERT', 'UPDATE', 'DELETE') 

select * 
from information_schema.role_table_grants 
where grantor = 'test_user'

drop owned by test_user

