-- create procedure add_tagtype
CREATE OR REPLACE PROCEDURE add_tagtype(
        IN display_name varchar(30),
        IN description varchar(60),
        INOUT p_tag_type_id smallint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO tag_types (display_name, description)
VALUES (display_name, description)
RETURNING tag_type_id INTO p_tag_type_id;
END;
$$;