-- Create table suppliers
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id serial4 PRIMARY KEY,
    cname varchar(50) UNIQUE,
    display_name varchar(50) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$')
);

-- Create a trigger to generate cname from display_name
CREATE OR REPLACE FUNCTION generate_cname()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.cname := LOWER(REPLACE(NEW.display_name, ' ', '_'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger on suppliers table
CREATE TRIGGER set_supplier_cname
BEFORE INSERT ON suppliers
FOR EACH ROW
EXECUTE FUNCTION generate_cname();