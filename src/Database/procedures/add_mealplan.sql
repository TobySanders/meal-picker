-- create procedure to add meal plan
CREATE OR REPLACE PROCEDURE add_meal_plan(OUT meal_plan_id bigint)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO meal_plans DEFAULT VALUES
    RETURNING meal_plan_id INTO meal_plan_id;
END;
$$;

-- create procedure to add recipe to meal plan
CREATE OR REPLACE PROCEDURE add_meal_plan_recipe(
    IN meal_plan_id bigint,
    IN recipe_id bigint
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO meal_plan_recipes (meal_plan_id, recipe_id)
    VALUES (meal_plan_id, recipe_id);
END;
$$;