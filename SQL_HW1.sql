
--Таблица employees.
--Создать таблицу employees
-- - id. serial,  primary key,
-- - employee_name. Varchar(50), not null
--Наполнить таблицу employee 70 строками


create table employees (
	employee_id serial primary key,
	employee_name varchar(50) not null
);


INSERT INTO employees (employee_name)
SELECT CONCAT(first_name, ' ', last_name)
FROM (
  SELECT first_names.first_name, last_names.last_name
  FROM (
    SELECT 'Matwey' AS first_name UNION ALL SELECT 'Varvara' UNION ALL SELECT 'Aleksandr' UNION ALL SELECT 'Melissa' UNION ALL SELECT 'Dmitry' UNION ALL SELECT 'Polina' UNION ALL SELECT 'Ivan' UNION ALL SELECT 'Alisa' UNION ALL SELECT 'Lev' UNION ALL SELECT 'Vasilisa'
  ) AS first_names
  CROSS JOIN (
    SELECT 'Chernyh' AS last_name UNION ALL SELECT 'Kovalenko' UNION ALL SELECT 'Meye' UNION ALL SELECT 'Eria' UNION ALL SELECT 'Paganini' UNION ALL SELECT 'Boyko' UNION ALL SELECT 'Nushko' UNION ALL SELECT 'Zayka' UNION ALL SELECT 'Malik' UNION ALL SELECT 'Shpak'
  ) AS last_names
) AS names
LIMIT 70;


select * from employees;


--Таблица salary.
--Создать таблицу salary
-- - id. Serial  primary key,
-- - monthly_salary. Int, not null
--Наполнить таблицу salary 15 строками:
-- - 1000
-- - 1100
-- - 1200
-- - 1300
-- - 1400
-- - 1500
-- - 1600
-- - 1700
-- - 1800
-- - 1900
-- - 2000
-- - 2100
-- - 2200
-- - 2300
-- - 2400
-- - 2500


create table salary (
	id serial primary key,
	monthly_salary int not null
);


insert into salary(id, monthly_salary)
values (1, 1000),(2, 1100),(3, 1200),(4, 1300),(5, 1400),(6, 1500),(7, 1600),(8, 1700),(9, 1800),(10, 1900),(11, 2000),(12, 2100),(13, 2200),(14, 2300),(15, 2400),(16, 2500);


select * from salary;


alter table salary 
rename column id to salary_id;


--Таблица employee_salary
--Создать таблицу employee_salary
-- - id. Serial  primary key,
-- - employee_id. Int, not null, unique
-- - salary_id. Int, not null
--Наполнить таблицу employee_salary 40 строками:
-- - в 10 строк из 40 вставить несуществующие employee_id


create table employee_salary (
	employee_salary_id serial primary key,
	employee_id int unique not null,
	salary_id int not null
);


do $$
	declare
		n int;
		e int;
		s int;
		e2 int;
		s2 int;
	begin	
		for n in 1..30
		loop
			e := FLOOR(random()*40)+1;
			s := FLOOR(random()*16)+1;
			while e in (select employee_id from employee_salary)
			loop e := FLOOR(random()*40)+1;
			end loop;
			insert into employee_salary (employee_id, salary_id)
			values (e,s);
		end loop;
		for n in 1..10
		loop
			e2 := FLOOR(random()*60)+41;
			s2 := FLOOR(random()*16)+1;
			while e2 in (select employee_id from employee_salary)
			loop e2 := FLOOR(random()*70)+1;
			end loop;
		
			insert into employee_salary (employee_id, salary_id)
			values (e2,s2);
		end loop;
	end;
$$;


select * from employee_salary;


--Другой вариант:

--INSERT INTO employee_salary (employee_id, salary_id)
--select employee_id, salary_id
--FROM (
--	(select employee_id
--	from employees
--	ORDER BY random()
--	limit 30)
--	union
--	SELECT generate_series((SELECT MAX(employee_id) FROM employees)+1, (SELECT MAX(employee_id) FROM employees)+10)
--) a, (
--	select salary_id 
--	from salary) b 
--ORDER BY random()
--ON CONFLICT (employee_id) DO NOTHING




--Таблица roles.
--Создать таблицу roles:
-- - id. Serial  primary key,
-- - role_name. int, not null, unique
--Поменять тип столба role_name с int на varchar(30)
--Наполнить таблицу roles 20 строками:

--id role_name
--1 Junior Python developer
--2 Middle Python developer
--3 Senior Python developer
--4 Junior Java developer
--5 Middle Java developer
--6 Senior Java developer
--7 Junior JavaScript developer
--8 Middle JavaScript developer
--9 Senior JavaScript developer
--10 Junior Manual QA engineer
--11 Middle Manual QA engineer
--12 Senior Manual QA engineer
--13 Project Manager
--14 Designer
--15 HR
--16 CEO
--17 Sales manager
--18 Junior Automation QA engineer
--19 Middle Automation QA engineer
--20 Senior Automation QA engineer
		

create table roles (
	role_id serial primary key,
	role_name int unique not null)
	
	
alter table roles 
alter column role_name type varchar(30);


INSERT INTO roles (role_id, role_name)
VALUES (1,'Junior Python developer'),(2,'Middle Python developer'),(3,'Senior Python developer'),(4,'Junior Java developer'),
(5,'Middle Java developer'),(6,'Senior Java developer'),(7,'Junior JavaScript developer'),(8,'Middle JavaScript developer'),
(9,'Senior JavaScript developer'),(10,'Junior Manual QA engineer'),(11,'Middle Manual QA engineer'),(12,'Senior Manual QA engineer'),
(13,'Project Manager'),(14,'Designer'),(15,'HR'),(16,'CEO'),(17,'Sales manager'),(18,'Junior Automation QA engineer'),
(19,'Middle Automation QA engineer'),(20,'Senior Automation QA engineer');  


select * from roles;


--Таблица roles_employee.
--Создать таблицу roles_employee
-- - id. Serial  primary key,
-- - employee_id. Int, not null, unique (внешний ключ для таблицы employees, поле id)
-- - role_id. Int, not null (внешний ключ для таблицы roles, поле id)
--Наполнить таблицу roles_employee 40 строками


create table roles_employee (
	id serial primary key,
	employee_id int unique not null,
	role_id int not null,
	foreign key (employee_id) references employees (employee_id),
	foreign key (role_id) references roles (role_id)
);


do $$
	declare
		n int;
		e int;
		r int;
	begin	
		for n in 1..40
		loop
			e := FLOOR(random()*70)+1;
			r := FLOOR(random()*20)+1;
			while e in (select employee_id from roles_employee)
			loop e := FLOOR(random()*70)+1;
			end loop;
		
			insert into roles_employee (employee_id, role_id)
			values (e,r);
		end loop;
	end;
$$;


select * from roles_employee


--Другой вариант:

--insert into roles_employee (employee_id, role_id)
--select e.employee_id, r.role_id
--from employees e, roles r
--order by random()
--limit 40
--on conflict do nothing
