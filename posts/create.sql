
create or replace function create_post(user_id_f int, title_f text, description_f text, price_f numeric, category_f int,
                                       location_f text) returns record as
$$
declare
    new_user_id    int;
    new_listing_id int;

begin
    insert into listings (user_id, title, description, price, category, location)
    VALUES (user_id_f, title_f, description_f,
            price_f, category_f, location_f)
    returning user_id_f, id into new_user_id, new_listing_id;
    return (new_user_id, new_listing_id);
end;

$$ language plpgsql;


SELECT create_post(
               1,
               'Golden Retriever Puppy',
               'Friendly, well-trained, and great with kids.',
               150.0,
               2,
               'Tashkent, UZB'
       );