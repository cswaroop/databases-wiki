CREATE TABLE IF NOT EXISTS employee (
	id uuid PRIMARY KEY NOT NULL default uuid_generate_v4(),
	title text not null,
	name text not null,
	department uuid not null
);

CREATE TABLE IF NOT EXISTS department (
	id uuid PRIMARY KEY NOT NULL default uuid_generate_v4(),
	name text not null,
	location text not null,
	manager_id uuid not null
);

CREATE OR REPLACE FUNCTION new_hire_notify() RETURNS trigger AS $$
	DECLARE
		payload varchar;
		mid uuid;
	BEGIN
		SELECT manager_id INTO mid FROM department
		WHERE id = NEW.department;
		payload = CAST(NEW.id AS text) || `, ` || CAST (mid AS text);
		PERFORM pg_notify ('new_hire', payload);
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER value_insert
AFTER INSERT ON (employee)
FOR EACH ROW EXECUTE PROCEDURE new_hire_notify();
