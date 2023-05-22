-- Create table tag_types
CREATE IF NOT EXISTS TABLE tag_types (
    tag_type_id serial2 PRIMARY KEY,
    cname varchar(30) UNIQUE,
    display_name varchar(30) NOT NULL,
    CONSTRAINT display_name CHECK (display_name ~ '^^(?!.*\s$)(?!^\s)(?!.*[^a-zA-Z\s])[a-zA-Z\s]+$')
    description varchar(60) NOT NULL,
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
CREATE TRIGGER set_tag_type_cname
BEFORE INSERT ON tag_types
FOR EACH ROW
EXECUTE FUNCTION generate_cname();
