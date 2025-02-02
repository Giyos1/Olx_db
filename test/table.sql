CREATE database test;

CREATE schema test;

CREATE table test.users
(
    name  text not null,
    email text not null
);

create table professions
(
    name text not null
);


create table interests
(
    name text not null
);

create table interests_users
(
    user_id     int references test.users (id),
    interest_id int references test.interests (id)
);

create table if not exists salary
(
    amount   int  not null,
    currency text not null,
    user_id  int unique references test.users (id)
);
DO
$$
    DECLARE
        i integer := 0;
    BEGIN
        FOR i IN 1..1000
            LOOP
                INSERT INTO test.users (name, email)
                VALUES ('User ' || i, 'user' || i || '@example.com');
            END LOOP;
    END
$$;

DO
$$
    declare
        i integer := 0;
    begin
        for i in 1..1000
            loop
                insert into test.interests (name)
                values ('interest ' || i);
            end loop;
    end;
$$;

DO
$$
    declare
        i integer := 0;
    begin
        for i in (SELECT id FROM test.users)
            loop
                insert into test.interests_users (user_id, interest_id)
                values (i, (select id from test.interests order by random() limit 1));
            end loop;
    end;
$$;

-- SELECT u.name AS user_name, i.name AS interest_name
-- FROM users u
-- JOIN interests_users iu ON u.id = iu.user_id
-- JOIN interests i ON iu.interest_id = i.id;

-- insert into professions (name)
-- values ('developer'), ('manager'), ('designer');

do
$$
    declare
        i integer := 0;
    begin
        for i in 1..1000
            loop
                update test.users
                set profession_id = (select id from professions order by random() limit 1)
                where id = i;
            end loop;
    end;
$$;


SELECT u.name as username, u.email as email, p.name as profession
from users u
         inner join professions p on u.profession_id = p.id;
