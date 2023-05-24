-- Create table units
CREATE TABLE IF NOT EXISTS units (
  unit_id serial2 PRIMARY KEY,

  symbol char(3) NOT NULL,
  CONSTRAINT uk_units_symbol UNIQUE (symbol),

  cname varchar(24),
  CONSTRAINT uk_units_cname UNIQUE (cname),

  display_name varchar(24) NOT NULL,
  is_division boolean DEFAULT FALSE
);

-- Create a trigger to generate cname from display_name
CREATE OR REPLACE FUNCTION generate_cname()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.cname := LOWER(REPLACE(NEW.display_name, ' ', '_'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on units table
CREATE OR REPLACE TRIGGER set_unit_cname
BEFORE INSERT ON units
FOR EACH ROW
EXECUTE FUNCTION generate_cname();

-- Create table tag_types
CREATE TABLE IF NOT EXISTS tag_types (
    tag_type_id serial2 PRIMARY KEY,
    cname varchar(30) UNIQUE,
    display_name varchar(30) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
    description varchar(60) NOT NULL
);

-- Create the trigger on tag_types table
CREATE OR REPLACE TRIGGER set_tag_type_cname
BEFORE INSERT ON tag_types
FOR EACH ROW
EXECUTE FUNCTION generate_cname();

-- Create table tags
CREATE TABLE IF NOT EXISTS tags (
    tag_id serial8 PRIMARY KEY,
    cname varchar(30) UNIQUE,
    type integer NOT NULL,
    display_name varchar(100) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
    FOREIGN KEY (type) REFERENCES tag_types(tag_type_id)
);

-- Create the trigger on tags table
CREATE OR REPLACE TRIGGER set_tag_cname
BEFORE INSERT ON tags
FOR EACH ROW
EXECUTE FUNCTION generate_cname();

-- Create table suppliers
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id serial4 PRIMARY KEY,
    cname varchar(50) UNIQUE,
    display_name varchar(50) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$')
);

-- Create the trigger on suppliers table
CREATE TRIGGER set_supplier_cname
BEFORE INSERT ON suppliers
FOR EACH ROW
EXECUTE FUNCTION generate_cname();

-- Create table ingredients
CREATE TABLE IF NOT EXISTS ingredients (
    ingredient_id serial8 PRIMARY KEY,
    cname varchar(30) UNIQUE,
    display_name varchar(30) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
    is_allergen boolean DEFAULT FALSE
);

-- Create the trigger on ingredients table
CREATE OR REPLACE TRIGGER set_ingredient_cname
BEFORE INSERT ON ingredients
FOR EACH ROW
EXECUTE FUNCTION generate_cname();

-- create ingredient supplier table
CREATE TABLE IF NOT EXISTS ingredient_suppliers (
  ingredient_id bigint NOT NULL,
  supplier_id int NOT NULL,
  PRIMARY KEY (ingredient_id, supplier_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients (ingredient_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
);

-- create function to get ingredient suppliers
CREATE OR REPLACE FUNCTION get_ingredient_suppliers(p_ingredient_id bigint)
RETURNS TABLE (supplier_id int) AS $$
BEGIN
  RETURN QUERY
  SELECT supplier_id
  FROM ingredient_suppliers WHERE ingredient_id = p_ingredient_id;
END;
$$ LANGUAGE plpgsql;

-- create ingredient tag table
CREATE TABLE IF NOT EXISTS ingredient_tags (
  ingredient_id bigint NOT NULL,
  tag_id bigint NOT NULL,
  PRIMARY KEY (ingredient_id, tag_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients (ingredient_id),
  FOREIGN KEY (tag_id) REFERENCES tags (tag_id)
);

-- create function to get ingredient tags
CREATE OR REPLACE FUNCTION get_ingredient_tags(p_ingredient_id bigint)
RETURNS TABLE (tag_id bigint) AS $$
BEGIN
  RETURN QUERY
  SELECT tag_id
  FROM ingredient_tags WHERE ingredient_id = p_ingredient_id;
END;
$$ LANGUAGE plpgsql;

-- create table recipes
CREATE TABLE IF NOT EXISTS recipes (
  recipe_id serial8 PRIMARY KEY,
  title varchar(50) NOT NULL UNIQUE CHECK (title ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
  description varchar(255),
  instructions json NOT NULL
);

-- create table recipe_ingredients
CREATE TABLE IF NOT EXISTS recipe_ingredients (
  recipe_id bigint NOT NULL,
  ingredient_id bigint NOT NULL,
  unit_id smallint NOT NULL,
  quantity_left smallint NOT NULL CHECK (quantity_left > 0),
  quantity_right smallint CHECK (quantity_right IS NULL OR quantity_right > 0),
  required boolean DEFAULT true,
  PRIMARY KEY (recipe_id, ingredient_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
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
$$ LANGUAGE plpgsql;

-- create table recipe_tags
CREATE TABLE IF NOT EXISTS recipe_tags (
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
$$ LANGUAGE plpgsql;

-- create table meal_plans
CREATE TABLE IF NOT EXISTS meal_plans(
    meal_plan_id UUID PRIMARY KEY
);

-- create table meal_plan_recipes
CREATE TABLE IF NOT EXISTS meal_plan_recipes(
    meal_plan_id UUID NOT NULL,
    recipe_id bigint NOT NULL,
    PRIMARY KEY (meal_plan_id, recipe_id),
    FOREIGN KEY (meal_plan_id) REFERENCES meal_plans(meal_plan_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

-- create function to find recipes in a meal plan
CREATE OR REPLACE FUNCTION get_meal_plan_recipes(meal_plan_id UUID)
RETURNS TABLE (recipe_id bigint) AS $$
BEGIN
    RETURN QUERY
    SELECT recipe_id FROM meal_plan_recipes WHERE meal_plan_recipes.meal_plan_id = meal_plan_id;
END;
$$ LANGUAGE plpgsql;
