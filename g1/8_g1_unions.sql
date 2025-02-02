CREATE TABLE Students
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age  INT
);


CREATE TABLE Staff
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(50),
    age     INT,
    address VARCHAR(100),
    salary  INT
);
drop table staff;
CREATE TABLE Teacher
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age  INT
);

insert into students (name, age)
values ('Ali', 22),
       ('Vali', 20),
       ('Soli', 34);

insert into staff (name, age, address, salary)
values ('Soli', 34, 'Tashkent', 2000),
       ('Zafar', 51, 'Tashkent', 3000);

insert into teacher (name, age)
values ('Gani', 43),
       ('Ali', 22),
       ('Temur', 43);

SELECT name, age, 'students' as role
from students
UNION
SELECT name, age, 'staff' as role
from staff
UNION
SELECT name, age, 'teacher' as role
from teacher;

SELECT name
from Staff
group by name;
SELECT *
FROM Staff
WHERE ID IN (SELECT ID
             FROM Staff
             WHERE SALARY > 3000);

-- SET enable_seqscan = ON;
-- EXPLAIN ANALYSE SELECT * from Staff where salary=3000;
--
-- CREATE index staff_salary_index on Staff(salary);