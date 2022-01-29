create table actor(
    id serial primary key,
    first_name varchar,
    last_name varchar,
    age int
);

insert into actor
select generate_series(0, 1000000) as id,
       md5(random()::text) as first_name,
       md5(random()::text) as last_name,
       random() * 120 as age;

create table film(
    id serial primary key,
    name varchar,
    date timestamp
);

insert into film
select generate_series(0, 100000) as id,
       md5(random()::text) as name,
       current_timestamp as date;


create table fee(
    id serial primary key,
    actor_id int,
    foreign key (actor_id) references actor(id),
    film_id int,
    foreign key (film_id) references film(id),
    salary int
);

insert into fee
select generate_series(0, 1000000) as id,
       random() * 1000000 as actor_id,
       random() * 100000 as film_id,
       random() * 10000000 as salary;

create index actor_id_ind on fee (actor_id);
create index film_id_ind on fee (film_id);
create index salary_ind on fee (salary);
create index actor_film_ind on fee (actor_id, film_id);
create index film_actor_ind on fee (film_id, actor_id);
create index actor_salary_ind on fee (actor_id, salary);
create index salary_actor_ind on fee (salary, actor_id);
create index salary_film_ind on fee (salary, film_id);
create index film_salary_ind on fee (film_id, salary);
create index film_salary_actor_ind on fee (film_id, salary, actor_id);
create index film_actor_salary_ind on fee (film_id, actor_id, salary);
create index actor_salary_film_ind on fee (actor_id, salary, film_id);
create index actor_film_salary_ind on fee (actor_id, film_id, salary);
create index salary_actor_film_ind on fee (salary, actor_id, film_id);
create index salary_film_actor_ind on fee (salary, film_id, actor_id);

select name, SUM(salary) as sum
    from film f left join fee on f.id = fee.film_id
    where salary is not null
    group by (f.id)
    order by sum desc
limit 10;


select *
from pg_stat_user_indexes
where relname = 'fee';

drop index actor_id_ind;
drop index film_id_ind;
drop index salary_ind;
drop index actor_film_ind;
drop index film_actor_ind;
drop index actor_salary_ind;
drop index salary_actor_ind;
drop index salary_film_ind;

drop index film_salary_actor_ind;
drop index film_actor_salary_ind;
drop index actor_salary_film_ind;
drop index actor_film_salary_ind;
drop index salary_actor_film_ind;
drop index salary_film_actor_ind;

create materialized view mv_top_films as
select name, SUM(salary) as sum
    from film f left join fee on f.id = fee.film_id
    where salary is not null
    group by (f.id)
    order by sum desc
limit 10;

create unique index un_name_sum on mv_top_films (name, sum);
