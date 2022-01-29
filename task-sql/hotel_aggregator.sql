create table type_of_hotel(
    id serial primary key,
    name varchar,
    constraint name_check check ( name ~ 'hotel|whole apartment|boarding house' ),
    description text
);

create table building_size(
     id serial primary key,
     number_of_apartments int default 0,
     number_of_floors int default 0
     constraint positive_num_of_apartments check (number_of_apartments > 0),
     constraint positive_num_of_floors check (number_of_floors > 0)
);

create table interior_design(
    id serial primary key,
    name varchar,
    main_color varchar(100),
    description text
);

create table country(
    id serial primary key,
    name varchar,
    currency varchar
);

create table price(
    id serial primary key,
    value int not null,
    category varchar,
    constraint positive_price check (value > 0)
);

create table discount_from_to(
    id serial primary key,
    percent float default 0,
    price_id int not null,
    border_from timestamp,
    border_to timestamp,
    constraint price_id_fk foreign key (price_id)
        references price(id) on update cascade on delete cascade,
    constraint discount_from_uk unique (price_id, border_from),
    constraint discount_to_uk unique (price_id, border_to),
    constraint check_boundaries check (border_from < border_to),
    constraint correct_percentage check (percent >= 0 and percent <= 100)
);

create table area(
     id serial primary key,
     name varchar,
     time_zone smallint
);

create table address(
      id serial primary key,
      country_id int not null,
      area_id int,
      city varchar,
      district varchar,
      street varchar,
      number int,
      constraint country_id_fk foreign key (country_id)
          references country(id) on update cascade on delete cascade,
      constraint area_id_fk foreign key (area_id)
          references area(id) on update cascade on delete cascade
);

create table location(
    id serial primary key,
    address_id int not null,
    landmark varchar,
    distance_to_landmark int,
    constraint address_id_fk foreign key (address_id)
        references address(id) on update cascade on delete cascade,
    constraint positive_distance_to_landmark check ( distance_to_landmark >= 0 )
);

create table hotel(
    id serial primary key,
    name varchar,
    constraint name_check check ( name ~ '[A-Z].+'),
    type_id int,
    constraint type_id_fk foreign key (type_id)
        references type_of_hotel(id) on update cascade on delete cascade,
    size_id int,
    constraint size_id_fk foreign key (size_id)
        references building_size(id) on update cascade on delete cascade,
    rating int,
    link_to_website varchar,
    path_to_photo varchar,
    location_id int,
    constraint location_id_fk foreign key (location_id)
        references location(id) on update cascade on delete cascade,
    number_of_guests int,
    number_of_stars int,
    description text,
    free_cancellation bool,
    wi_fi bool,
    wheelchair_access bool,
    free_breakfast bool,
    parking_space bool,
    pets bool,
    payment_on_spot bool,
    spa bool
);

create table flat(
    id serial primary key,
    hotel_id int,
    constraint hotel_id_fk foreign key (hotel_id)
        references hotel(id) on update cascade on delete cascade,
    price_id int,
    constraint price_id_fk foreign key (price_id)
        references price(id) on update cascade on delete cascade,
    interior_design_id int,
    constraint interior_design_fk foreign key (interior_design_id)
        references interior_design(id) on update cascade on delete cascade,
    number_of_people int,
    for_family_with_child bool
);

create table room(
    id serial primary key,
    type varchar,
    constraint type_check check ( type ~ 'kitchen|bathroom|bedroom|playroom|hall|other' ),
    path_to_photo varchar,
    flat_id int,
    constraint flat_fk foreign key (flat_id)
        references flat(id) on update cascade on delete cascade
);

create table booking_for_flat(
     id serial primary key,
     flat_id int,
     border_from timestamp,
     border_to timestamp,
     constraint flat_id_fk foreign key (flat_id)
         references flat(id) on update cascade on delete cascade,
     constraint booking_from_uk unique (flat_id, border_from),
     constraint booking_to_uk unique (flat_id, border_to),
     constraint check_boundaries check (border_from < border_to)
);

create table feedback(
    id serial primary key,
    title varchar(255),
    date timestamp with time zone,
    content text,
    estimation smallint,
    name_of_user varchar,
    hotel_id int,
    constraint hotel_id_fk foreign key (hotel_id)
        references hotel(id) on update cascade on delete cascade
);

with cte_hotels as (
        select hotel.id as hotel_id from hotel
            inner join type_of_hotel toh on hotel.type_id = toh.id
        where toh.name = 'hotel'
    ),
     cte_paris_hotels as(
         select hotel.id as hotel_id from cte_hotels
             inner join hotel on cte_hotels.hotel_id = hotel.id
             inner join location l on hotel.location_id = l.id
             inner join address a on a.id = l.address_id
         where a.city = 'Paris' and hotel.number_of_stars = 4
     ),
     cte_hotels_near_eiffel_tower as (
         select hotel.id as hotel_id from cte_paris_hotels
            inner join hotel on cte_paris_hotels.hotel_id = hotel.id
            inner join location l on hotel.location_id = l.id
         where distance_to_landmark < 6 and landmark = 'eiffel tower'
     ),

     cte_near_eiffel_tower_flats_with_high_tech as(
         select f.id as flat_id from cte_hotels_near_eiffel_tower
               inner join hotel on cte_hotels_near_eiffel_tower.hotel_id = hotel.id
               inner join flat f on hotel.id = f.hotel_id
               inner join interior_design i on f.interior_design_id = i.id
         where main_color = 'white' and i.name = 'high-tech'and for_family_with_child is true
     ),

     cte_free_from_booking_paris_flats as(
         select flat.id as flat_id, price.value as price from cte_near_eiffel_tower_flats_with_high_tech
            inner join flat on cte_near_eiffel_tower_flats_with_high_tech.flat_id = flat.id
            inner join price on flat.price_id = price.id
            inner join booking_for_flat bff on flat.id = bff.flat_id
         where border_to < timestamp '2021-07-16 00:00:00' and border_from > timestamp '2021-09-16 00:00:00'
     ),

     cte_paris_hotels_flat as(
         select flat.id as flat_id, price.value as price from cte_paris_hotels
                inner join hotel on cte_paris_hotels.hotel_id = hotel.id
                inner join flat on hotel.id = flat.hotel_id
                inner join price on flat.price_id = price.id
     )
select name and link_to_website
from hotel
    inner join cte_hotels_near_eiffel_tower on cte_hotels_near_eiffel_tower.hotel_id = hotel.id
    inner join flat on hotel.id = flat.hotel_id
    inner join cte_free_from_booking_paris_flats on flat.id = cte_free_from_booking_paris_flats.flat_id
    where price < (select avg(price) from cte_paris_hotels_flat);
