BEGIN;
select film_id, SUM(salary) as sum
from actor a left join fee on a.id = fee.actor_id
    where film_id is not null
    group by (film_id)
    order by sum desc
    limit 10;
END;
