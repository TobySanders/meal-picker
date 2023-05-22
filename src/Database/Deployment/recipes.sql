-- create table recipes
CREATE IF NOT EXISTS TABLE recipes (
  recipe_id serial8 PRIMARY KEY,
  title varchar(50) NOT NULL UNIQUE CHECK valid_name (title ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
  description varchar(255),
  instructions json NOT NULL
);

-- create table recipe_ingredients
CREATE IF NOT EXISTS TABLE recipe_ingredients (
  recipe_id bigint NOT NULL,
  ingredient_id bigint NOT NULL,
  unit_id smallint NOT NULL,
  quantity_left smallint NOT NULL CHECK gt_zero (quantity_left > 0),
  quantity_right smallint CHECK null_or_gt_zero (quantity_right IS NULL OR quantity_right > 0),
  required boolean DEFAULT true,
  PRIMARY KEY (recipe_id, ingredient_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredient_entry(ingredient_id),
  FOREIGN KEY (unit_id) REFERENCES units(unit_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

-- create function to get recipe ingredients
CREATE OR REPLACE FUNCTION get_recipe_ingredients(recipe_id bigint)
RETURNS TABLE (ingredient_id bigint) AS $$
BEGIN
    RETURN QUERY
    SELECT ingredient_id FROM recipe_ingredients WHERE recipe_ingredients.recipe_id = recipe_id;
END;

-- create table recipe_tags
CREATE IF NOT EXISTS TABLE recipe_tags (
  recipe_id bigint NOT NULL,
  tag_id bigint NOT NULL,
  PRIMARY KEY (recipe_id, tag_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
  FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

-- create function to get recipe tags
CREATE OR REPLACE FUNCTION get_recipe_tags(recipe_id bigint)
RETURNS TABLE (tag_id bigint) AS $$
BEGIN
    RETURN QUERY
    SELECT tag_id FROM recipe_tags WHERE recipe_tags.recipe_id = recipe_id;
END;
