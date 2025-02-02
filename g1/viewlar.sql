-- CREATE TABLE customers
-- (
--     id         SERIAL PRIMARY KEY,
--     name       VARCHAR(100),
--     email      VARCHAR(100) UNIQUE,
--     membership VARCHAR(50)
-- );
--
-- INSERT INTO customers (name, email, membership)
-- VALUES ('Ali', 'ali@example.com', 'VIP'),
--        ('Zuhra', 'zuhra@example.com', 'Regular'),
--        ('Bekzod', 'bekzod@example.com', 'VIP'),
--        ('Shahzod', 'shahzod@example.com', 'Regular'),
--        ('Dilorom', 'dilorom@example.com', 'VIP');
--
-- create view vip_customers as
-- select *
-- from customers
-- where membership = 'VIP';
--
-- select *
-- from vip_customers;
--
-- select p.name, Sum(sl.amount), avg(c.age)
-- from salary sl
--          INNER JOIN public.contacts c on c.id = sl.user_id
--          INNER JOIN public.profession p on p.id = c.profession_id
-- group by p.name;
--
-- CREATE VIEW salary_by_department AS
-- select count(c.*) as count, p.name as department_name, Sum(sl.amount) as total_salary, avg(c.age) as age_avg
-- from salary sl
--          INNER JOIN public.contacts c on c.id = sl.user_id
--          INNER JOIN public.profession p on p.id = c.profession_id
-- group by p.name;
--
-- select * from salary_by_department
-- ORDER BY age_avg DESC;

create table products
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    price       DECIMAL(10, 2),
    description TEXT
);

create table orders
(
    id          SERIAL PRIMARY KEY,
    order_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,
    product_id  INT references products (id),
    FOREIGN KEY (customer_id) REFERENCES customers (id)
);

insert into products(name, price, description)
values ('Mandanrin', '25000', 'Zo''r'),
       ('Gilos', '12344', 'Yaxshi'),
       ('Anor', '23444', 'Yomon');

insert into orders (order_date, customer_id, product_id)
values ('2021-01-01', 1, 1),
       ('2021-01-02', 2, 2),
       ('2021-01-03', 3, 3),
       ('2021-01-04', 4, 1),
       ('2021-01-05', 5, 2),
       ('2021-01-06', 1, 3),
       ('2021-01-07', 2, 1),
       ('2021-01-08', 3, 2),
       ('2021-01-09', 4, 3),
       ('2021-01-10', 5, 1);

select c.name, sum(p.price) as total_spent, count(o.*) as total_orders
from customers c
         inner join public.orders o on c.id = o.customer_id
         inner join public.products p on p.id = o.product_id
where order_date between '2021-01-01' and '2021-01-08'
group by c.name;

CREATE MATERIALIZED VIEW orders_in_january_01_08 AS
select c.name, sum(p.price) as total_spent, count(o.*) as total_orders
from customers c
         inner join public.orders o on c.id = o.customer_id
         inner join public.products p on p.id = o.product_id
where order_date between '2021-01-01' and '2021-01-08'
group by c.name;

REFRESH MATERIALIZED VIEW orders_in_january_01_08;

UPDATE vip_customers
SET membership = 'Regular'
WHERE name = 'Ali';