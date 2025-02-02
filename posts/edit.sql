CREATE OR REPLACE FUNCTION delete_listing(p_listing_id INT)
RETURNS VOID as $$
    BEGIN
        UPDATE Listings
        SET status = 'inactive'
        WHERE id = p_listing_id;
    end;
    $$LANGUAGE plpgsql;

select delete_listing(8);



CREATE OR REPLACE FUNCTION update_listing(
    p_listing_id INT,
    p_title VARCHAR(255),
    p_description TEXT,
    p_price DECIMAL(10, 2),
    p_category INT,
    p_location VARCHAR(255)
)
RETURNS VOID as $$
    BEGIN
        UPDATE Listings
        SET
            title = p_title,
            description = p_description,
            price = p_price,
            category = p_category,
            location = p_location,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_listing_id;
    end;
$$LANGUAGE plpgsql;

SELECT update_listing(1, 'New Laptop Title', 'Updated description', 500.00, 2, 'Los Angeles, CA');
SELECT * FROM Listings;
