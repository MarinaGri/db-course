create table employee(
                         id serial primary key,
                         surname varchar,
                         name varchar,
                         second_name varchar,
                         email varchar,
                         tel varchar,
                         report_card varchar
);

create table  control(
                         subordinate_id integer,
                         foreign key (subordinate_id) references employee(id),
                         manager_id integer,
                         foreign key (manager_id) references employee(id)
);

insert into employee (surname, name, second_name, email, tel, report_card)
values ('Иванов', 'Петр', 'Сергеевич', 'petr@gmail.com', '+79273454878', 'G76254fby'),
       ('Сидоров', 'Анатолий', 'Александрович', 'tolic@gmail.com', '+79898984878', 'G76hbdh6'),
       ('Гиразов', 'Марат', 'Мирзаевич', 'marat76@yandex.ru', '89273154878', 'MUmumu99'),
       ('Юсупов', 'Владимир', 'Сергеевич', '@mail.ru', '89273450000', '8462tvcgG'),
       ('Астахов', 'Петр', 'Николаевич', 'apn@yandex.ru', '+79278375865', 'Gvhrb44'),
       ('Арбузов', 'Иван', 'Петрович', 'ivan2002@gmail.com', '+79273653356', 'rbvhrUU8'),
       ('Иваньшин', 'Роман', 'Дмитриевич', 'roma@yandex.ru', '+73657365376', 'cycyeb34'),
       ('Маркина', 'Мария', 'Владимировна', 'masha007@yandex.ru', '+79173454878', 'aXJCNCK7'),
       ('Попова', 'Анна', 'Ростиславовна', 'anna@gmail.com', '+79173459078', 'vbhyvb99'),
       ('Иванова', 'Светлана', 'Алексеевна', 'sveta@gmail.com', '+79277454878', 'G7ecbe45');

insert into control(subordinate_id, manager_id)
values (1, 10),
       (1, 9),
       (9, 10),
       (2, 4),
       (3, 9),
       (10, 5),
       (6, 7),
       (8, 9),
       (7, 1),
       (8, 2);

alter table control add id serial primary key;

insert into control(subordinate_id, manager_id) VALUES (5, null);

with recursive  _employee as
         (select name || ' ' || surname
           from employee
                    inner join control c on employee.id = c.subordinate_id
           where manager_id is null),
     _sub as
         (select distinct control.subordinate_id, name || ' ' || surname as sub
            from control
                inner join employee e on control.subordinate_id = e.id),
    _man as
        (select distinct control.manager_id, name || ' ' || surname as man
            from control
                inner join employee e on control.manager_id = e.id),

    _control as
        (select sub, man
            from _sub
                inner join control on control.subordinate_id = _sub.subordinate_id
                inner join _man on _man.manager_id = control.manager_id
        ),

  _graph as
       (select (select * from _employee)  as employee,
               1 as level,
               ARRAY[(select * from _employee)] as path,
               false as cycle
        from control
        where manager_id is null
           UNION
        select _control.sub as employee,
               (_graph.level + 1) as level,
               _graph.path || _control.sub as path,
               _control.sub = ANY(path)  as cycle
           from _control inner join _graph on _control.man  = _graph.employee AND NOT cycle
       )
select *
from _graph;


with recursive _graph as
      (select subordinate_id as employee,
           1 as level,
           ARRAY[subordinate_id] as path,
           false as cycle
           from control
           where manager_id is null
      UNION
      select control.subordinate_id as employee,
           (_graph.level + 1) as level,
           _graph.path || control.subordinate_id as path,
           control.subordinate_id = ANY(path)  as cycle
           from control inner join _graph on control.manager_id = _graph.employee AND NOT cycle)
select *
from _graph;

update employee set email='us@gmail.com' where id = 4;



alter table employee
    add constraint emailTest check ( email ~* '^([\w!#$%&*+\/=?^_`\-{|}~]+|"[\w!#$%&*+\/=?^_`\s{|}~.(),:;<>@\\\[\]]*")+[\w!#$%&*+\/=?^_`{|}~.]*@\w+(\w-)*\.([A-Za-z]+)$' );

alter table employee
    add constraint telTest check ( tel ~* '^\+?[0-9]{11}$' );

alter table employee
    add constraint nameTest check ( surname ~* '[A-ZА-Я].+' and name ~* '[A-ZА-Я].+' and second_name ~* '[A-ZА-Я].+');


select  count(*) from employee
where tel ~* '^\+?[0-9]{11}$';

create table salary(
    employee_id int,
    foreign key (employee_id) references employee(id),
    salary int
);

insert into salary(employee_id, salary)
VALUES (1, 80000),
       (2, 50000),
       (3, 90000),
       (4, 30000),
       (5, 100000),
       (6, 90000),
       (7, 30000);

create materialized view mv_salary as
    select salary.salary, count(*) as count
    from salary
        left join employee on employee.id = salary.employee_id
    group by salary;

create unique index on mv_salary (salary);

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_salary;

drop materialized view mv_salary;


insert into salary(employee_id, salary)
VALUES (10, 90000);
