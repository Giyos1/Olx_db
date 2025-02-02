create or replace function view_listings()
RETURNS TABLE(
    user_id int,
    username character varying(50),  -- Change to match the actual type
    email character varying(50),
    user_created_at timestamp,
    post_id int,
    title character varying(255),
    description text,
    price text,
    category character varying(255),
    location character varying(255),
    listing_created_at timestamp,
    updated_at timestamp,
    status text
) as $$
begin
    return query
    select u.id as user_id, u.username, u.email, u.created_at, l.id as post_id,
           l.title, l.description, l.price || '$' as price, C.name as category, l.location,
           l.created_at as created_at, l.updated_at, l.status::text
    from Listings l
    join Categories C on l.category = C.id
    join users u on u.id = l.user_id
    where l.status in ('in_review');
end;
    $$ language plpgsql;



create or replace function decide_listing(list_id int, status varchar(20))
returns boolean as $$
begin
    update Listings set status=$2 where id = $1;
end;
    $$ language plpgsql;