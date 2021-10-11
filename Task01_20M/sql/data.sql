insert into mobile_phone
select generate_series(0, 20000000) as id,
       floor(random()*(select count(*) from model) + 1) as model_id;
