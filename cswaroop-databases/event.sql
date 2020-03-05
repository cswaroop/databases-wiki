CREATE TABLE events (
	user_id bigint,
	account_id bigint,
	session_id text,
	occured_at timestamptz,
	category text,
	action text,
	label text,
	attributes jsonb
);

\echo simple index
CREATE INDEX ON users (name);
SELECT * FROM accounts WHERE email LIKE 'Peter%';

\echo suffix lookup
CREATE INDEX backsearch ON users (reverse(email));
SELECT * FROM accounts WHERE reverse(email) LIKE reverse('%doe.com');

CREATE INDEX ON products USING gin(tsv);

SELECT * FROM users WHERE name ~ '(John|Jave)\s+Doe';

\echo always use timestamptz not timestamp

\echo date-time

SELECT date_trunc ('week', now())::date;

\echo When was a year ago?

SELECT now() - '1 year'::interval;

\echo generate all the days of last month (good for joining)

SELECT generate_series(date_trunc('month', now() - '1 month'::interval))
SELECT generate_series(date_trunc('month', now() - '1 day'::interval))

\echo bytea
SELECT md5(binary_data) FROM table


\echo arrays

SELECT ('{one, two, three}'::text[])[1];

CREATE INDEX ON table USING gin(tags);
SELECT * FROM table WHERE tags @> array['sometag'];

\echo jsonb

ALTER TABLE users ADD COLUMN attributes jsonb;
CREATE INDEX ON users USING gin(attributes);


\echo materialized-views

CREATE MATERIALIZED VIEW mv_daily_counts AS 
SELECT  
	created_at::date AS created_date,
	count(*)
FROM
	table
GROUP BY
	created_date
;

CREATE UNIQUE INDEX ON mv_daily_counts (created_date);

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_counts;


\echo cached aggregates

-- aggregate table
CREATE TABLE daily_counts_cached (
	created_date date PRIMARY KEY,
	value int
);

-- aggregate table update manually

INSERT INTO  daily_counts_cached
SELECT created_at::date AS created_date,
	   count(*)
FROM source_table
GROUP BY created_date;

-- aggregate table update automatically

CREATE OR REPLACE FUNCTION f_upsert_daily_counts ()
RETURNS TRIGGER LANGUAGE plpgsql AS 
$$
BEGIN
	LOOP
		UPDATE daily_counts_cached SET value = value +1
		WHERE created_date = NEW.created_at::date;
		IF found THEN
			RETURN NULL;
		END IF;
		BEGIN
			INSERT INTO daily_counts_cached VALUES (NEW.created_at::date, 1);
			RETURN NULL;
		EXCEPTION WHEN unique_violation THEN
			-- retry
		END;
	END LOOP;
END;
$$

CREATE TRIGGER daily_counts_change
AFTER INSERT ON source_table
FOR EACHE ROW
EXECUTE PROCEDURE f_upsert_daily_counts();

