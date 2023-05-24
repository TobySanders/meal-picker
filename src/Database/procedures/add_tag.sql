-- create procedure add_tag
CREATE OR UPDATE PROCEDURE add_tag(
    IN cname varchar(30),
    IN type integer,
    IN display_name varchar(100),
    OUT tag_id integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO tags (cname, type, display_name)
    VALUES (cname, type, display_name)
    RETURNING tag_id INTO tag_id;
END;
$$;