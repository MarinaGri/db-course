create table milk(
    id serial primary key,
    manufacturer varchar default 'unknown',
    created_at timestamp default current_timestamp
)