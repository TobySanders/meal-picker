-- Create table units
CREATE TABLE units (
  unit_id serial2 PRIMARY KEY,

  symbol char(3) NOT NULL,
  CONSTRAINT uk_units_symbol UNIQUE (symbol),

  cname varchar(24),
  CONSTRAINT uk_units_cname UNIQUE (cname)

  display_name varchar(24) NOT NULL,
  is_division boolean DEFAULT FALSE,
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
CREATE TRIGGER set_unit_cname
BEFORE INSERT ON units
FOR EACH ROW
EXECUTE FUNCTION generate_cname();