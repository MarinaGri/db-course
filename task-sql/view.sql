create table t1(
    id serial primary key,
    name varchar(50)
);

insert into t1
select generate_series(1, 20000) as id,
        md5(random()::text) as name;

create view v1 as select * from t1
