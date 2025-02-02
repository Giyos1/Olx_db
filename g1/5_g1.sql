create table salary
(
    id           serial primary key,
    amount       int  not null,
    currency     text not null,
    from_company text not null,
    user_id      int unique references public.contacts (id)
);

insert into salary (amount, currency, from_company, user_id)
values ('2000', 'USD', 'PAYMENT', 1),
       ('3000', 'USD', 'PAYMENT', 2),
       ('4000', 'USD', 'PAYMENT', 3),
       ('5000', 'USD', 'PAYMENT', 4),
       ('6000', 'USD', 'PAYMENT', 5),
       ('7000', 'USD', 'PAYMENT', 6),
       ('8000', 'USD', 'PAYMENT', 7);

create table interests
(
    id   serial primary key,
    name varchar(50) not null unique
);

-- insert into interests (name)
-- values ('Reading'),
--        ('Swimming'),
--        ('Running'),
--        ('Cycling'),
--        ('Hiking'),
--        ('Cooking'),
--        ('Dancing'),
--        ('Singing');

create table interests_contacts
(
    contact_id  int references public.contacts (id),
    interest_id int references public.interests (id)
);

insert into interests_contacts (contact_id, interest_id)
values (1, 1),
       (1, 2),
       (1, 3),
       (2, 4),
       (2, 5),
       (2, 6),
       (3, 7),
       (3, 8);


select c.email, c.name, p.name as profession
from contacts c
         inner join profession p on c.profession_id = p.id;

select c.email, c.name, p.name as profession
from profession p
         left join contacts c on c.profession_id = p.id;

