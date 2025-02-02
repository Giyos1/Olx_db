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

































