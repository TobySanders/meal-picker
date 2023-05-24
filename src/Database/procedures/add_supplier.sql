-- create procedure add_supplier
CREATE OR REPLACE PROCEDURE add_supplier(
        IN display_name varchar(50),
        INOUT p_supplier_id smallint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO suppliers (display_name)
VALUES (display_name)
RETURNING supplier_id INTO p_supplier_id;
END;
$$;