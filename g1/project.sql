create TYPE role as ENUM ('admin', 'user');

create table users
(
    id         serial primary key,
    username   varchar(50) not null unique,
    password   varchar(50) not null,
    email      varchar(50) not null unique,
    role       role      default 'user'::role,
    is_deleted boolean   default false,
    is_active  boolean   default true,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp
);

create type status as ENUM ('in_review','reject','active', 'inactive', 'sold');

CREATE table Categories
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    parent_id  INT references Categories (id) on delete RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Listings
(
    id          SERIAL PRIMARY KEY,
    user_id     INT,
    title       VARCHAR(255),
    description TEXT,
    price       DECIMAL(10, 2),
    category    INT references Categories (id) on delete RESTRICT,
    location    VARCHAR(255),
    status      status    default 'in_review'::status,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id) on delete cascade
);

create table Notifications
(
    id         SERIAL PRIMARY KEY,
    user_id    INT references Users (id) on delete cascade,
    message    TEXT,
    is_read    BOOLEAN   default false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table MyFavorites
(
    id         SERIAL PRIMARY KEY,
    user_id    INT references Users (id) on delete cascade,
    listing_id INT references Listings (id) on delete cascade,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

insert into users (username, password, email)
values ('giyos1', '12', 'giyos1@gmail.com');

insert into Categories (name)
values ('Electronics'),
       ('Cars'),
       ('Books');

insert into Listings (user_id, title, description, price, category, location)
values (1, 'Macbook Pro 2020', 'Brand new macbook pro 2020', 2000.00, 1, 'Tashkent'),
       (1, 'Toyota Camry 2015', 'Toyota Camry 2015 in good condition', 15000.00, 2, 'Tashkent');

insert into myfavorites (user_id, listing_id)
values (1, 1),
       (1, 2);

create or replace function notify_user()
    returns trigger as
$$
BEGIN
    insert into notifications (user_id, message)
    values (new.user_id, 'Your listing ' || new.title || ' has been created');
    return new;
end;
$$
    language plpgsql;

create trigger notify_user
    after insert
    on listings
    for each row
execute function notify_user();



create view my_favorite_listings as
select C.name, l.title, l.price, l.location, l.status, mf.created_at as added_at
from myfavorites mf
         inner join listings l on mf.listing_id = l.id
         inner join Categories C on l.category = C.id
where mf.user_id = 1;

-- insert data

-- Insert sample data into the "Users" table
INSERT INTO Users (username, password, email, role)
VALUES ('admin_user', 'securePassword1', 'admin@example.com', 'admin'),
       ('john_doe', 'password123', 'john@example.com', 'user'),
       ('jane_smith', 'pass456', 'jane@example.com', 'user');

-- Insert sample data into the "Categories" table
-- (Note: for parent-child relationships, insert the parent first)
INSERT INTO Categories (name, parent_id)
VALUES ('Electronics', NULL),
       ('Computers', 1),   -- Computers is a subcategory of Electronics (assuming id 1)
       ('Smartphones', 1), -- Smartphones is a subcategory of Electronics
       ('Furniture', NULL),
       ('Chairs', 4);
-- Chairs is a subcategory of Furniture (assuming id 4)

-- Insert sample data into the "Listings" table
-- (Make sure the user_id and category values refer to valid records)
INSERT INTO Listings (user_id, title, description, price, category, location, status)
VALUES (8, 'Used Laptop for Sale', 'A gently used laptop in good condition', 450.00, 2, 'New York, NY', 'active'),
       (9, 'Vintage Smartphone', 'Classic smartphone in working order', 150.00, 3, 'San Francisco, CA', 'in_review'),
       (10, 'Ergonomic Office Chair', 'Comfortable office chair with adjustable settings', 85.50, 5, 'Chicago, IL',
        'active');

-- Insert sample data into the "Notifications" table
-- (Ensure the user_id exists in the Users table)
INSERT INTO Notifications (user_id, message, is_read)
VALUES (8, 'Your listing "Used Laptop for Sale" has been approved.', true),
       (9, 'Your listing "Vintage Smartphone" is under review.', false),
       (10, 'Reminder: Update your listing details for "Ergonomic Office Chair".', false);

-- Insert sample data into the "MyFavorites" table
-- (Ensure both user_id and listing_id reference valid records)
INSERT INTO MyFavorites (user_id, listing_id)
VALUES (8, 9), -- Jane favorites the first listing
       (9, 10), -- John favorites Jane's listing
       (10, 11); -- Jane favorites John's second listing
