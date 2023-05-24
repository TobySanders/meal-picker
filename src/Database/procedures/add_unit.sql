DROP PROCEDURE IF EXISTS add_unit;
CREATE OR REPLACE PROCEDURE add_unit(
        IN symbol char(3),
        IN display_name varchar(24),
        IN is_division boolean,
        INOUT p_unit_id smallint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO units (symbol, display_name, is_division)
VALUES (symbol, display_name, is_division)
RETURNING unit_id INTO p_unit_id;
END;
$$;