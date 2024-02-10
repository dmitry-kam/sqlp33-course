select *
from employee_salary es

create view ... as 
	получать текущий оклад сотрудника
	emp_id - уникальны
	
select distinct emp_id
salary - lag(salary) / salary - 100

select distinct emp_id
effective_from - lag(effective_from) - interval

select *
from employee e

select *
from employee_salary es
join hours h on es.emp_id = h.emp_id

select distinct emp_id
effective_from - lag(effective_from) 
join hours emp_id = emp_id and date between effective_from - lag(effective_from)

Необходимо нормализовать исходную таблицу.
Получившиеся отношения должны быть не ниже 3 Нормальной Формы.
В результате должна быть диаграмма из не менее чем 5 нормализованных отношений и 1 таблицы с историчностью, соответствующей требованиям SCD4.
Контролировать целостность данных в таблице с историчными данными необходимо с помощью триггерной функции.
Результат работы должен быть в виде одного скриншота ER-диаграммы и sql запроса с триггером и функцией.

emp_id PK | fio | boss_id 
1		   ИИИ

dep_id | dep_name | boss_fio

1. update / delete - > старые гоним в историю

2.

some_table 
id primary key	| val

1

insert into some_table (id)
values (1) 

on conflict primary key some_table_pkey do update 
	set val = sdfgsdf 
	where id = new.id

drop table a

drop table b

create table a (
  a_id int primary key,
  a_val_new text)
  
create table b (
  b_id serial primary key,
  a_val_old text)
  
create or replace function foo_a_b() returns trigger as $$
begin 
  if tg_op = 'INSERT' and new.a_id in (select a_id from a) then 
    insert into b (a_val_old)
    values ((select a_val_new from a where a_id = new.a_id));  
      set session_replication_role = replica; --отключаем для нашей сессии работу триггеров
    update a
    set a_val_new = new.a_val_new
    where a_id = new.a_id;
      set session_replication_role = default; --включаем для нашей сессии работу триггеров
    return null;
  elseif tg_op = 'UPDATE' then
    insert into b (a_val_old)
    values (old.a_val_new);
    return null;
  else 
    return new;
  end if;
  
end;
$$ language plpgsql

create trigger a_in_b 
before insert or update on a 
for each row execute function foo_a_b()

with cte as (
	delete from a 
	where id a_id = new.a_id
	returning *) 
insert into история
return new

insert into a (a_id, a_val_new)
values (1, 'a'), (2, 'b')

select * from a

select * from b 

insert into a (a_id, a_val_new)
values (1, 'x')