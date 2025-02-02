create function register(
    p_username varchar,
    p_password varchar,
    p_email varchar
) returns text as
$$
declare
    user_id int;
begin
    insert into users(username, password, email)
    VALUES(p_username, p_password, p_email)
    returning id into user_id;

    return 'User Registered Successfully: ' || user_id;
end;
$$ language plpgsql;

create function login(
    p_username varchar,
    p_password varchar
) returns text as
$$
declare
    stored_password varchar;
    user_role role;
    user_id int;

begin
    select id, password, role into user_id, stored_password, user_role from users
    where username = p_username;

    if not FOUND then
        return 'Invalid password or username';
    end if;

    if stored_password = p_password then
        return 'Login successfully, User_id' || user_id || 'Role' || user_role;
    else
        return 'Invalid username or password';
    end if;
end;
$$ language plpgsql;

create function check_admin(
    user_id int
) returns text as
$$
declare
    user_role role;
begin
    select role into user_role from users;

    if user_role = 'admin' then
        return True;
    else
        return FALSE;
    end if;
end;
$$ language plpgsql;