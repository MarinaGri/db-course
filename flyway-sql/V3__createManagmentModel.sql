create table employee(
    id serial primary key,
    surname varchar,
    name varchar,
    second_name varchar,
    email varchar,
    tel varchar,
    report_card varchar
);

create table  control(
     subordinate_id integer,
     foreign key (subordinate_id) references employee(id),
     manager_id integer,
     foreign key (manager_id) references employee(id)
);

insert into employee (surname, name, second_name, email, tel, report_card)
values ('Иванов', 'Петр', 'Сергеевич', 'petr@gmail.com', '+79273454878', 'G76254fby'),
       ('Сидоров', 'Анатолий', 'Александрович', 'tolic@gmail.com', '+79898984878', 'G76hbdh6'),
       ('Гиразов', 'Марат', 'Мирзаевич', 'marat76@yandex.ru', '89273154878', 'MUmumu99'),
       ('Юсупов', 'Владимир', 'Сергеевич', '@mail.ru', '89273450000', '8462tvcgG'),
       ('Астахов', 'Петр', 'Николаевич', 'apn@yandex.ru', '+79278375865', 'Gvhrb44'),
       ('Арбузов', 'Иван', 'Петрович', 'ivan2002@gmail.com', '+79273653356', 'rbvhrUU8'),
       ('Иваньшин', 'Роман', 'Дмитриевич', 'roma@yandex.ru', '+73657365376', 'cycyeb34'),
       ('Маркина', 'Мария', 'Владимировна', 'masha007@yandex.ru', '+79173454878', 'aXJCNCK7'),
       ('Попова', 'Анна', 'Ростиславовна', 'anna@gmail.com', '+79173459078', 'vbhyvb99'),
       ('Иванова', 'Светлана', 'Алексеевна', 'sveta@gmail.com', '+79277454878', 'G7ecbe45');

insert into control(subordinate_id, manager_id)
values (1, 10),
       (1, 9),
       (9, 10),
       (2, 4),
       (3, 9),
       (10, 5),
       (6, 7),
       (8, 9),
       (7, 1),
       (8, 2);
