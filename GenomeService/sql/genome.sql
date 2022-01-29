create table genome_first_2(
    id serial primary key,
    genome varchar
);

create table genome_second_2(
     id serial primary key,
     genome varchar
);

create table genome_first_5(
      id serial primary key,
      genome varchar
);

create table genome_second_5(
     id serial primary key,
     genome varchar
);

create table genome_first_9(
     id serial primary key,
     genome varchar
);

create table genome_second_9(
     id serial primary key,
     genome varchar
);
with cte_intersect2 as (select genome from genome_first_2
                        intersect
                        select genome from genome_second_2),
     cte_union2 as (select genome from genome_first_2
                    union
                    select genome from genome_second_2),
     cte_intersect5 as (select genome from genome_first_5
                        intersect
                        select genome from genome_second_5),
     cte_union5 as (select genome from genome_first_5
                    union
                    select genome from genome_second_5),
     cte_intersect9 as (select genome from genome_first_9
                        intersect
                        select genome from genome_second_9),
     cte_union9 as (select genome from genome_first_9
                    union
                    select genome from genome_second_9)
select
        (select count(*) from cte_intersect2 as count)
        /
        (select count(*) from cte_union2 as count)::float8 as j
union all
select
        (select count(*) from cte_intersect5 as count)
        /
        (select count(*) from cte_union5 as count)::float8
union all
select
        (select count(*) from cte_intersect9 as count)
        /
        (select count(*) from cte_union9 as count)::float8;

create view v_genome_first_5 as
    select * from genome_first_5;

select * from genome_first_5
