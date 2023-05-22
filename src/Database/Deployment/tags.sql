-- Create table tags
CREATE TABLE IF NOT EXISTS tags (
    tag_id serial8 PRIMARY KEY,
    cname varchar(30) UNIQUE,
    type integer NOT NULL,
    display_name varchar(100) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$'),
    FOREIGN KEY (type) REFERENCES tag_types(tag_type_id)
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
CREATE OR REPLACE TRIGGER set_tag_cname
BEFORE INSERT ON tags
FOR EACH ROW
EXECUTE FUNCTION generate_cname();
