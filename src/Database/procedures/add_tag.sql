-- create procedure add_tag
CREATE OR REPLACE PROCEDURE add_tag(
        IN cname varchar(30),
        IN type smallint,
        IN display_name varchar(100),
        INOUT p_tag_id bigint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO tags (cname, type, display_name)
VALUES (cname, type, display_name)
RETURNING tag_id INTO p_tag_id;
END;
$$;