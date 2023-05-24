-- create procedure add_unit
CREATE OR UPDATE PROCEDURE add_unit(
    IN symbol char(3),
    IN display_name varchar(24),
    IN is_division boolean,
    OUT unit_id integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO units (symbol, display_name, is_division)
    VALUES (symbol, display_name, is_division)
    RETURNING unit_id INTO unit_id;
END;
$$;
