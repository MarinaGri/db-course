insert into mobile_phone
select i, random() * (cast((select count(*) from model) as int)-1) + 1
from generate_series(1, 20000000) s(i);
