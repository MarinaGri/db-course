create table  model(
    id serial primary key,
    name varchar default 'unknown'
);

create table mobile_phone(
    id serial primary key,
    model_id integer,
    foreign key (model_id) references model(id),
    created_at timestamp default to_timestamp(1388534400 + random()*63071999*5)
);
