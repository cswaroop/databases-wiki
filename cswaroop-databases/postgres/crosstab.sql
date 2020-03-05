
CREATE EXTENSION tablefunc;

CREATE TABLE IF NOT EXISTS eav (
	e text,
	a text,
	v text
);


INSERT INTO eav VALUES ('entity-1', 'attr-1', 'X');
INSERT INTO eav VALUES ('entity-1', 'attr-2', 'X');
INSERT INTO eav VALUES ('entity-1', 'attr-3', 'X');
INSERT INTO eav VALUES ('entity-2', 'attr-1', 'Y');
INSERT INTO eav VALUES ('entity-2', 'attr-1', 'Y');

SELECT * 
FROM crosstab 
('
	SELECT e, a, v FROM eav ORDER BY 1,2
') AS ct 
(
	entity_name text,
	attr_1 text,
	attr_2 text,
	attr_3 text
);


