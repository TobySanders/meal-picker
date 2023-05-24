-- create table meal_plans
CREATE TABLE IF NOT EXISTS meal_plans(
    meal_plan_id bigserial PRIMARY KEY
);

-- create table meal_plan_recipes
CREATE TABLE IF NOT EXISTS meal_plan_recipes(
    meal_plan_id bigint NOT NULL,
    recipe_id bigint NOT NULL,
    PRIMARY KEY (meal_plan_id, recipe_id),
    FOREIGN KEY (meal_plan_id) REFERENCES meal_plans(meal_plan_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

-- create function to find recipes in a meal plan
CREATE OR REPLACE FUNCTION get_meal_plan_recipes(meal_plan_id bigint)
RETURNS TABLE (recipe_id bigint) AS $$
BEGIN
    RETURN QUERY
    SELECT recipe_id FROM meal_plan_recipes WHERE meal_plan_recipes.meal_plan_id = meal_plan_id;
END;
$$ LANGUAGE plpgsql;
