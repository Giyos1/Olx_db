-- Hisobvaraqlar jadvali
CREATE TABLE accounts
(
    account_id SERIAL PRIMARY KEY,
    username   VARCHAR(50) NOT NULL,
    balance    DECIMAL(15, 2) check ( balance >= 0.00 )
);

-- Tranzaksiyalar jadvali
CREATE TABLE transactions
(
    transaction_id   SERIAL PRIMARY KEY,
    from_account_id  INT REFERENCES accounts (account_id),
    to_account_id    INT REFERENCES accounts (account_id),
    amount           DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Hisobvaraqlarga dastlabki ma'lumotlarni kiritish
-- INSERT INTO accounts (username, balance)
-- VALUES ('Alice', 1000.00);
-- INSERT INTO accounts (username, balance)
-- VALUES ('Bob', 500.00);

start transaction;
insert into transactions(from_account_id, to_account_id, amount)
values (1, 2, 500.00);

update accounts
set balance = balance - 500.00
where account_id = 1;

update accounts
set balance = balance + 500.00
where account_id = (Select account_id from accounts where username = 'Bob' limit 1);

commit;

TRUNCATE TABLE city;

