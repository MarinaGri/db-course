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
