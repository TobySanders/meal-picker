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
-- create procedure to add meal plan
CREATE OR REPLACE PROCEDURE add_meal_plan(INOUT p_meal_plan_id bigint) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO meal_plans DEFAULT
VALUES
RETURNING meal_plan_id INTO p_meal_plan_id;
END;
$$;
-- create procedure to add recipe to meal plan
CREATE OR REPLACE PROCEDURE add_meal_plan_recipe(
        IN meal_plan_id bigint,
        IN recipe_id bigint
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO meal_plan_recipes (meal_plan_id, recipe_id)
VALUES (meal_plan_id, recipe_id);
END;
$$;
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
CREATE OR REPLACE PROCEDURE add_unit(
        IN symbol char(3),
        IN display_name varchar(24),
        IN is_division boolean,
        INOUT p_unit_id int
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO units (symbol, display_name, is_division)
VALUES (symbol, display_name, is_division)
RETURNING unit_id INTO p_unit_id;
END;
$$;