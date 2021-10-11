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

create table a(
    character varchar
);
create table b(
    character varchar
);
insert into a(character)
values ('a'),('a'),('b'),('c'),('d');

insert into b(character)
values ('c'),('c'),('d'),('b');

select
        (select count(*) from (select * from a
                               intersect
                               select * from b)as count)
        /
        (select count(*) from (select * from a
                               union all
                               select * from b) as count)::float8 as num;

with cte_a_intersect_b as(select * from a
                          intersect
                          select * from b),
     cte_a_union_all_b as(select * from a
                          union all
                          select * from b),
     cte_count_intersect as(select count(*)
                            from cte_a_intersect_b),
     cte_count_union as(select count(*)
                            from cte_a_union_all_b)
select ((select * from cte_count_intersect)
           /
        (select * from cte_count_union)::float8) as j;
