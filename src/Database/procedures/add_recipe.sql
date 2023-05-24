-- create procedure to add recipe
CREATE OR REPLACE PROCEDURE add_recipe(
        IN title varchar(50),
        IN description varchar(255),
        IN instructions json,
        INOUT p_recipe_id bigint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO recipes (title, description, instructions)
VALUES (title, description, instructions)
RETURNING recipe_id INTO p_recipe_id;
END;
$$;
-- create procedure to add recipe ingredient
CREATE OR REPLACE PROCEDURE add_recipe_ingredient(
        IN recipe_id bigint,
        IN ingredient_id bigint,
        IN unit_id smallint,
        IN quantity_left smallint,
        IN quantity_right smallint,
        IN required boolean
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO recipe_ingredients (
        recipe_id,
        ingredient_id,
        unit_id,
        quantity_left,
        quantity_right,
        required
    )
VALUES (
        recipe_id,
        ingredient_id,
        unit_id,
        quantity_left,
        quantity_right,
        required
    );
END;
$$;