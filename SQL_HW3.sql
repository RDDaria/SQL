--Homework 1 (повторение файла SQL_HW1, Homework 3 - см. ниже):



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








--Homework 3:

 
 --1. Вывести всех работников, чьи зарплаты есть в базе, вместе с зарплатами
 
 select employee_name, monthly_salary
 from employees join employee_salary on employees.employee_id = employee_salary.employee_id 
 				join salary on employee_salary.salary_id = salary.salary_id 
 
 --2. Вывести всех работников, у которых ЗП меньше 2000
 
 select employee_name, monthly_salary
 from employees join employee_salary on employees.employee_id = employee_salary.employee_id 
 				join salary on employee_salary.salary_id = salary.salary_id
 where monthly_salary < 2000;
 
 --3. Вывести все зарплатные позиции, работник по которым не назначен (ЗП есть, но не понятно, кто её получает)
 
 select monthly_salary
 from salary left join employee_salary on employee_salary.salary_id = salary.salary_id 
 where employee_salary.salary_id is null;
 
 --4. Вывести все зарплатные позиции  меньше 2000, работник по которым не назначен (ЗП есть, но не понятно кто её получает)
 
  select monthly_salary
 from salary left join employee_salary on employee_salary.salary_id = salary.salary_id 
 where employee_salary.salary_id is null and monthly_salary < 2000;
 
 --5. Найти всех работников кому не начислена ЗП
 
 select employee_name
 from employees left join employee_salary on employees.employee_id = employee_salary.employee_id
 where employee_salary.employee_id is null;
 
 --6. Вывести всех работников с названиями их должности
 
 select employee_name, role_name
 from employees join roles_employee on employees.employee_id = roles_employee.employee_id 
 				join roles on roles_employee.role_id = roles.role_id ;
 
 --7. Вывести имена и должность только Java разработчиков
 
 select employee_name, role_name
 from employees join roles_employee on employees.employee_id = roles_employee.employee_id 
 				join roles on roles_employee.role_id = roles.role_id 
 where role_name like '%Java %';
 
 --8. Вывести имена и должность только Python разработчиков
 
 select employee_name, role_name
 from employees join roles_employee on employees.employee_id = roles_employee.employee_id 
 				join roles on roles_employee.role_id = roles.role_id 
 where role_name like '%Python%';
 
 --9. Вывести имена и должность всех QA инженеров
 
 select employee_name, role_name
 from employees join roles_employee on employees.employee_id = roles_employee.employee_id 
 				join roles on roles_employee.role_id = roles.role_id 
 where role_name like '%QA%';
 
 --10. Вывести имена и должность ручных QA инженеров
 
 select employee_name, role_name
 from employees join roles_employee on employees.employee_id = roles_employee.employee_id 
 				join roles on roles_employee.role_id = roles.role_id 
 where role_name like '%Manual QA%';
 
 --11. Вывести имена и должность автоматизаторов QA
 
 select employee_name, role_name
 from employees join roles_employee on employees.employee_id = roles_employee.employee_id 
 				join roles on roles_employee.role_id = roles.role_id 
 where role_name like '%Automation QA%';
 
 --12. Вывести имена и зарплаты Junior специалистов
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Junior%';
 
 --13. Вывести имена и зарплаты Middle специалистов
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Middle%';
 
 --14. Вывести имена и зарплаты Senior специалистов
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Senior%';
 
 --15. Вывести зарплаты Java разработчиков
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Java %';
 
 --16. Вывести зарплаты Python разработчиков
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Python%';
 
 --17. Вывести имена и зарплаты Junior Python разработчиков
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Junior Python%';
 
 --18. Вывести имена и зарплаты Middle JS разработчиков
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Middle JavaScript%';
 
 --19. Вывести имена и зарплаты Senior Java разработчиков
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Senior Java %';
 
 --20. Вывести зарплаты Junior QA инженеров
 
 select employee_name, role_name, monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Junior % QA%';
 
 --21. Вывести среднюю зарплату всех Junior специалистов
 
 select avg(monthly_salary)
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%Junior%';
 
 --22. Вывести сумму зарплат JS разработчиков
 
 select sum(monthly_salary)
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%JavaScript%';
 
 --23. Вывести минимальную ЗП QA инженеров
 
 select min(monthly_salary)
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%QA%';
 
 --24. Вывести максимальную ЗП QA инженеров
 
 select max(monthly_salary)
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id 
 where role_name like '%QA%';
 
 --25. Вывести количество QA инженеров
 
 select count(re.role_id)
 from roles r join roles_employee re on r.role_id = re.role_id
 where role_name like '%QA%';
 
 --26. Вывести количество Middle специалистов
 
 select count(re.role_id)
 from roles r join roles_employee re on r.role_id = re.role_id
 where role_name like '%Middle%';
 
 --27. Вывести количество разработчиков
 
 select count(re.role_id)
 from roles r join roles_employee re on r.role_id = re.role_id
 where role_name like '%developer%';
 
 --28. Вывести фонд (сумму) зарплаты разработчиков
 
 select sum(monthly_salary)
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id
 where role_name like '%developer%';
 
 --29. Вывести имена, должности и ЗП всех специалистов по возрастанию
 
 select e.employee_name, r.role_name, s.monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id
 order by employee_name, role_name, monthly_salary
 
 --30. Вывести имена, должности и ЗП всех специалистов по возрастанию у специалистов у которых ЗП от 1700 до 2300
 
 select e.employee_name, r.role_name, s.monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id
 where monthly_salary between 1700 and 2300
 order by employee_name, role_name, monthly_salary
 
 --31. Вывести имена, должности и ЗП всех специалистов по возрастанию у специалистов у которых ЗП меньше 2300
 
 select e.employee_name, r.role_name, s.monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id
 where monthly_salary between 1700 and 2300
 order by employee_name, role_name, monthly_salary
 
 --32. Вывести имена, должности и ЗП всех специалистов по возрастанию у специалистов у которых ЗП равна 1100, 1500, 2000
 
 select e.employee_name, r.role_name, s.monthly_salary
 from employees e join employee_salary es on e.employee_id = es.employee_id 
 				  join salary s on es.salary_id = s.salary_id 
 				  join roles_employee re on e.employee_id = re.employee_id 
 				  join roles r on re.role_id = r.role_id
 where monthly_salary in (1100, 1500, 2000)
 order by employee_name, role_name, monthly_salary
 

