create table comments
(
    comment_id SERIAL PRIMARY KEY,
    content    TEXT NOT NULL,
    user_id    int,
    post_id    int,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign key (user_id) references users (user_id),
    foreign key (post_id) references posts (post_id)
);

create table users
(
    user_id  SERIAL PRIMARY KEY,
    username VARCHAR(50)  NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email    VARCHAR(100) NOT NULL UNIQUE
);

create table posts
(
    post_id     SERIAL PRIMARY KEY,
    title       VARCHAR(50) NOT NULL,
    description TEXT,
    views       int       default 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id     INT,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);


INSERT INTO users (username, password, email)
VALUES ('john_doe', 'hashedpassword1', 'john.doe@example.com'),
       ('jane_smith', 'hashedpassword2', 'jane.smith@example.com'),
       ('sam_adams', 'hashedpassword3', 'sam.adams@example.com');

INSERT INTO posts (title, description, user_id)
VALUES ('First Post', 'This is the description of the first post', 1),
       ('Second Post', 'This post talks about something interesting', 2),
       ('Third Post', 'An amazing story to share', 3);


INSERT INTO comments (content, user_id, post_id)
VALUES ('Great post!', 2, 1),
       ('I found this very helpful, thanks!', 3, 1),
       ('Interesting perspective!', 1, 2),
       ('Thanks for sharing!', 3, 3);

select *
from posts
         join comments on posts.post_id = comments.post_id;

DO
$$
    DECLARE
        x integer := 12;
        y integer := 15;
    BEGIN
        raise notice 'The sum of % and % is %',x,y, x + y;
        raise notice 'x+y = %', x::bool and y::bool;
        raise notice 'sozlar %' , 'a' || 'b' || 'c';
    END
$$ language plpgsql;

create table city
(
    id         bigserial primary key,
    name       varchar(50) not null,
    population int         not null,
    country    varchar(50) not null,
    size       varchar(50) not null
);

select name,
       case
           when population > 1000000 then 'big city'
           when population > 500000 then 'medium city'
           else 'small city' end as size
from city;

DO
$$
    DECLARE
        city_size RECORD;

    BEGIN
        FOR city_size IN
            SELECT name,
                   case
                       when population > 1000000 then 'big city'
                       when population > 500000 then 'medium city'
                       else 'small city' end as size
            FROM city
            LOOP
                raise notice 'The city % is a %', city_size.name, city_size.size;
            END LOOP;
    END
$$ language plpgsql;

DO
$$
    DECLARE
        i integer;
    BEGIN
        FOR i IN 1..10
            LOOP
                IF i % 2 = 0 THEN
                    raise notice 'The value of i is %', i;
                ELSE
                    IF i = 1 THEN
                        raise notice 'The value of i is %', i;
                    END IF;
                END IF;
            end loop;
    end;
$$;


DO
$$
    DECLARE
        city_ RECORD;
    BEGIN
        FOR city_ IN SELECT id, name, population
                     FROM city
            LOOP
                UPDATE city
                SET size = CASE
                               WHEN city_.population > 4000000 THEN 'big'
                               ELSE 'Small' END
                WHERE id = city_.id;
            END LOOP;
    END
$$ language plpgsql;

DO
$$
    DECLARE
        x       bool    := true;
        counter integer := 0;
    begin
        while x
            loop
                raise notice 'The value of x is %', counter;
                IF counter = 5 THEN
                    EXIT;
                END IF;
                counter := counter + 1;
            end loop;
    end;
$$;


-- CREATE OR REPLACE PROCEDURE find_min(a integer, b integer, out min integer) AS
-- $$
-- BEGIN
--     IF a < b THEN
--         min := a;
--     ELSE
--         min := b;
--     END IF;
-- END
-- $$ LANGUAGE plpgsql;

-- CALL find_min(-10, 20);

CREATE or replace FUNCTION find_min_func(a integer, b integer) RETURNS integer AS
$$
BEGIN
    IF a < b THEN
        RETURN a;
    ELSE
        RETURN b;
    END IF;
END
$$ language plpgsql;

SELeCT find_min_func(10, 20);