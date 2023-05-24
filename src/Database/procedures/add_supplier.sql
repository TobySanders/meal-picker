-- create procedure add_supplier
CREATE OR UPDATE PROCEDURE add_supplier(
    IN display_name varchar(50),
    OUT supplier_id integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO suppliers (display_name)
    VALUES (display_name)
    RETURNING supplier_id INTO supplier_id;
END;
$$;
