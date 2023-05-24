-- create procedure add_tagtype
CREATE OR UPDATE PROCEDURE add_tagtype(
    IN display_name varchar(30),
    IN description varchar(60),
    OUT tag_type_id integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO tag_types (display_name, description)
    VALUES (display_name, description)
    RETURNING tag_type_id INTO tag_type_id;
END;
$$;