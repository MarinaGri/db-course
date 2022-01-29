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
