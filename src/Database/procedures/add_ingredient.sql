-- create procedure to add ingredient
CREATE OR REPLACE PROCEDURE add_ingredient(
        IN display_name varchar(30),
        IN is_allergen boolean,
        INOUT p_ingredient_id bigint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO ingredients (display_name, is_allergen)
VALUES (display_name, is_allergen)
RETURNING ingredient_id INTO p_ingredient_id;
END;
$$;