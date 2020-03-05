\echo csv file generation

COPY (SELECT * FROM tbl) TO '/tmp/export.csv' (
	FORMAT CSV,
	DELIMITER '|',
	HEADER
)
;

\echo between

SELECT uuid 
FROM tbl 
WHERE now() BETWEEN valid_from AND valid_thru;

\echo job_queue in postgres

CREATE TABLE job (
	id bigserial NOT NULL PRIMARY KEY,
	name text,
	args jsonb,
	is_running boolean not null default false,
	is_finished boolean not null default false,
	has_error boolean not null default false,
	error text
);

INSERT INTO job (name, args) VALUES (
	'fib', 
	'{"class": "CalfFib", "number": "123"}'
);


