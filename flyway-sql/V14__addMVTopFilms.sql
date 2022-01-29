create materialized view mv_top_films as
select name, SUM(salary) as sum
    from film f left join fee on f.id = fee.film_id
    where salary is not null
    group by (f.id)
    order by sum desc
limit 10;

create unique index un_name_sum on mv_top_films (name, sum);
