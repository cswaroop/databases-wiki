CREATE EXTENSION tablefunc;

DROP TABLE IF EXISTS org;
CREATE TABLE IF NOT EXISTS org (id text, parent_id text, pos int);

INSERT INTO org VALUES ('CORP', NULL, 0);
INSERT INTO org VALUES ('CORP-EMEA', 'CORP', 1);
INSERT INTO org VALUES ('CORP-LATAM', 'CORP', 1);
INSERT INTO org VALUES ('CORP-GB', 'CORP-EMEA', 2);
INSERT INTO org VALUES ('CORP-IT', 'CORP-EMEA', 2);
INSERT INTO org VALUES ('CORP-FR', 'CORP-EMEA', 2);
INSERT INTO org VALUES ('CORP-MX', 'CORP-LATAM', 2);
INSERT INTO org VALUES ('CORP-CL', 'CORP-LATAM', 2);
INSERT INTO org VALUES ('CORP-CO', 'CORP-LATAM', 2);
INSERT INTO org VALUES ('CORP-GB-BR1', 'CORP-GB', 3);
INSERT INTO org VALUES ('CORP-GB-BR2', 'CORP-GB', 3);


SELECT * FROM connectby('org', 'id', 'parent_id', 'CORP', 0, '/')
AS t(
	id text,
	parent_id text,
	level int, 
	branch text
);

SELECT * FROM connectby('org', 'id', 'parent_id', 'pos', 'CORP' ,0, '/')
AS t(
	id text,
	parent_id text,
	level int, 
	branch text,
	pos int
);
