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
