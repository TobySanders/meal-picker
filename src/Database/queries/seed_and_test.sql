DO $$
DECLARE v_unit_id smallint;
DECLARE v_tag_type_id smallint;
DECLARE v_tag_id bigint;
DECLARE v_tag_id_1 bigint;
DECLARE v_tag_id_2 bigint;
DECLARE v_supplier_id smallint;
DECLARE v_ingredient_id bigint;
DECLARE v_ingredient_id_1 bigint;
DECLARE v_recipe_id bigint;
DECLARE v_meal_plan_id bigint;
BEGIN
DELETE FROM meal_plan_recipes;
DELETE FROM meal_plans;
DELETE FROM recipe_ingredients;
DELETE FROM recipe_tags;
DELETE FROM recipes;
DELETE FROM ingredient_suppliers;
DELETE FROM ingredient_tags;
DELETE FROM ingredients;
DELETE FROM suppliers;
DELETE FROM units;
DELETE FROM tags;
DELETE FROM tag_types;
CALL add_unit('g', 'gram', false, v_unit_id);
CALL add_tagtype(
    'flavour',
    'Tags to describe the meals flavour',
    v_tag_type_id
);
CALL add_tag(
    'sweet',
    v_tag_type_id,
    'Sweet',
    v_tag_id
);
call add_tag(
    'savoury',
    v_tag_type_id,
    'Savoury',
    v_tag_id_1
);
call add_tag(
    'spicy',
    v_tag_type_id,
    'Spicy',
    v_tag_id_2
);
CALL add_supplier('Woolworths', v_supplier_id);
CALL add_ingredient(
    'Sugar',
    false,
    v_ingredient_id
);
CALL add_ingredient(
    'Soy Sauce',
    false,
    v_ingredient_id_1
);
INSERT INTO ingredient_suppliers (ingredient_id, supplier_id)
VALUES (v_ingredient_id, v_supplier_id);
INSERT INTO ingredient_suppliers (ingredient_id, supplier_id)
VALUES (v_ingredient_id_1, v_supplier_id);
INSERT into ingredient_tags (ingredient_id, tag_id)
VALUES (v_ingredient_id, v_tag_id);
INSERT into ingredient_tags (ingredient_id, tag_id)
VALUES (v_ingredient_id_1, v_tag_id_2);
CALL add_recipe(
    'Sugar Cookies',
    'A sweet cookie',
    '{
        "steps":[
            {
                "step": 1,
                "description": "Preheat oven to 190 degrees C. Line baking sheets with parchment paper."
            },
            {
                "step": 2,
                "description": "In a medium bowl, stir together the flour, baking soda, and baking powder. Set aside."
            },
            {
                "step": 3,
                "description": "In a large bowl, cream together the butter and sugar until smooth. Beat in egg and vanilla. Gradually blend in the dry ingredients. Roll rounded teaspoonfuls of dough into balls, and place onto ungreased cookie sheets."
            },
            {
                "step": 4,
                "description": "Bake 8 to 10 minutes in the preheated oven, or until golden. Let stand on cookie sheet two minutes before removing to cool on wire racks."
            }
    ]}',
    v_recipe_id
);
CALL add_recipe_ingredient(
    v_recipe_id,
    v_ingredient_id,
    v_unit_id,
    100::smallint,
    null::smallint,
    true
);
INSERT into recipe_tags (recipe_id, tag_id)
VALUES (v_recipe_id, v_tag_id);
INSERT into recipe_tags (recipe_id, tag_id)
VALUES (v_recipe_id, v_tag_id_1);
INSERT into recipe_tags (recipe_id, tag_id)
VALUES (v_recipe_id, v_tag_id_2);
CALL add_meal_plan(v_meal_plan_id);
CALL add_meal_plan_recipe(v_meal_plan_id, v_recipe_id);
END;
$$;
SELECT meal_plan_id,
    recipes.title,
    recipetags.display_name AS recipe_tag_display_name,
    recipetags.cname AS recipe_tag_cname,
    ingredients.cname,
    ingredients.display_name,
    ingredienttags.display_name AS ingredient_display_name,
    ingredienttags.cname AS ingredient_cname
FROM meal_plans
    FULL JOIN meal_plan_recipes USING (meal_plan_id)
    FULL JOIN recipes ON meal_plan_recipes.recipe_id = recipes.recipe_id
    FULL JOIN recipe_tags ON recipes.recipe_id = recipe_tags.recipe_id
    FULL JOIN tags recipetags ON recipe_tags.tag_id = recipetags.tag_id
    FULL JOIN recipe_ingredients ON recipes.recipe_id = recipe_ingredients.recipe_id
    FULL JOIN ingredients ON recipe_ingredients.ingredient_id = ingredients.ingredient_id
    FULL JOIN ingredient_tags ON ingredients.ingredient_id = ingredient_tags.ingredient_id
    FULL JOIN tags ingredienttags ON ingredient_tags.tag_id = ingredienttags.tag_id
    FULL JOIN ingredient_suppliers ON ingredients.ingredient_id = ingredient_suppliers.ingredient_id;