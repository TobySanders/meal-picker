-- Create table ingredients
CREATE TABLE ingredients (
    ingredient_id serial8 PRIMARY KEY,
    cname varchar(30) UNIQUE,
    display_name varchar(30) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
    is_allergen boolean DEFAULT FALSE
);

-- Create a trigger to generate cname from display_name
CREATE OR REPLACE FUNCTION generate_cname()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.cname := LOWER(REPLACE(NEW.display_name, ' ', '_'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on tags table
CREATE TRIGGER set_ingredient_cname
BEFORE INSERT ON ingredients
FOR EACH ROW
EXECUTE FUNCTION generate_cname();

-- create ingredient supplier table
CREATE TABLE ingredient_suppliers (
  ingredient_id bigint NOT NULL,
  supplier_id int NOT NULL,
  PRIMARY KEY (ingredient_id, supplier_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients (ingredient_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
);

-- create function to get ingredient suppliers
CREATE OR REPLACE FUNCTION get_ingredient_suppliers(ingredient_id bigint)
RETURNS TABLE (supplier_id int) AS $$
BEGIN
  RETURN QUERY
  SELECT supplier_id
  FROM ingredient_suppliers WHERE ingredient_id = ingredient_id;
END;

-- create ingredient tag table
CREATE TABLE ingredient_tags (
  ingredient_id bigint NOT NULL,
  tag_id bigint NOT NULL,
  PRIMARY KEY (ingredient_id, tag_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients (ingredient_id),
  FOREIGN KEY (tag_id) REFERENCES tags (tag_id)
);

-- create function to get ingredient tags
CREATE OR REPLACE FUNCTION get_ingredient_tags(ingredient_id bigint)
RETURNS TABLE (tag_id bigint) AS $$
BEGIN
  RETURN QUERY
  SELECT tag_id
  FROM ingredient_tags WHERE ingredient_id = ingredient_id;
END;