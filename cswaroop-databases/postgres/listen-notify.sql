CREATE EXTENSION tcn;

CREATE TABLE IF NOT EXISTS txns
(
	id int not null,
	created_at date not null,
	payload text,
	PRIMARY KEY (id, created_at)
);

CREATE TRIGGER txns_tcn_trigger
AFTER INSERT OR UPDATE OR DELETE ON txns
FOR EACH ROW EXECUTE PROCEDURE triggered_change_notification();

LISTEN tcn;

INSERT INTO txns VALUES (1, date '2017-09-18', 'Big order');
INSERT INTO txns VALUES (1, date '2017-09-19',  'Medium order');
INSERT INTO txns VALUES (1, date '2017-09-20',  'Small order');

UPDATE txns SET payload = 'Size Uknown' WHERE id = 1;

DELETE FROM txns WHERE id=1;