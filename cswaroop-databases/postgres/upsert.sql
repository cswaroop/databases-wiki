-- UPSERT

INSERT INTO distributors (did, dname)
VALUES (5, 'Gizo gtransglobal'),
	   (6, 'Associated Computing Inc')
ON CONFLICT (did)
DO UPDATE SET dname = EXCLUDED.dname
;


-- UPSERT IGNORE

INSERT INTO distributors (did, dname)
VALUES (7, 'Redline')
ON CONFLICT (did)
DO NOTHING
;

-- UPSERT with WHERE

INSERT INTO distributors (did, dname)
VALUES (5, 'Gizo gtransglobal'),
	   (6, 'Associated Computing Inc')
ON CONFLICT (did)
DO UPDATE SET dname = EXCLUDED.dname
WHERE d.zipcode != '2121'
;
