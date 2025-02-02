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
VALUES (2, 'Used Laptop for Sale', 'A gently used laptop in good condition', 450.00, 2, 'New York, NY', 'active'),
       (3, 'Vintage Smartphone', 'Classic smartphone in working order', 150.00, 3, 'San Francisco, CA', 'in_review'),
       (2, 'Ergonomic Office Chair', 'Comfortable office chair with adjustable settings', 85.50, 5, 'Chicago, IL',
        'active');

-- Insert sample data into the "Notifications" table
-- (Ensure the user_id exists in the Users table)
INSERT INTO Notifications (user_id, message, is_read)
VALUES (2, 'Your listing "Used Laptop for Sale" has been approved.', true),
       (3, 'Your listing "Vintage Smartphone" is under review.', false),
       (2, 'Reminder: Update your listing details for "Ergonomic Office Chair".', false);

-- Insert sample data into the "MyFavorites" table
-- (Ensure both user_id and listing_id reference valid records)
INSERT INTO MyFavorites (user_id, listing_id)
VALUES (3, 1), -- Jane favorites the first listing
       (2, 2), -- John favorites Jane's listing
       (3, 3); -- Jane favorites John's second listing


CREATE OR REPLACE FUNCTION update_at_table() returns trigger as
$$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;
CREATE or replace TRIGGER users_update_at
    before UPDATE or INSERT
    ON users
    FOR EACH ROW
EXECUTE FUNCTION update_at_table();

-- categori tigeri

CREATE or replace TRIGGER Listings_update_at
    before UPDATE or INSERT
    ON Categories
    FOR EACH ROW
EXECUTE FUNCTION update_at_table();

-- lsisting  trigeri

CREATE or replace TRIGGER Listings_update_at
    before UPDATE or INSERT
    ON listings
    FOR EACH ROW
EXECUTE FUNCTION update_at_table();


-- notifycation trigeri

CREATE or replace TRIGGER Listings_update_at
    before UPDATE or INSERT
    ON Notifications
    FOR EACH ROW
EXECUTE FUNCTION update_at_table();


-- my favorite trigeri
CREATE or replace TRIGGER Listings_update_at
    before UPDATE or INSERT
    ON Myfavorites
    FOR EACH ROW
EXECUTE FUNCTION update_at_table();



UPDATE Notifications
SET message = 'salom bolakaylar '
WHERE id = 1;

































