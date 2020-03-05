/*Managing related data with triggers
Server programming can also mean setting up automated actions (TRIGGERS), so that some operations in the database cause some other things to happen as well.
For example, you can set up a process where making an offer on some items automatically reserved them in the stock table.
So let's create a fruit stock table  
*/

CREATE TABLE fruits_in_stock (
    name text PRIMARY KEY,
    in_stock integer NOT NULL,
    reserved integer NOT NULL DEFAULT 0,
    CHECK (in_stock between 0 and 1000 ),
    CHECK (reserved <= in_stock)
);

/*
The CHECK constraints make sure that some basic rules are followed - you can't have more than 1000 fruit in stock (they'll probably go bad), you can't have negative stock, and you can't reserve more than you have.
*/

CREATE TABLE fruit_offer (
    offer_id serial PRIMARY KEY,
    recipient_name text,
    offer_date timestamp default current_timestamp,
    fruit_name text REFERENCES fruits_in_stock,
    offered_amount integer
);

/*
The offer table has an ID for the offer (so you can distinguish between offers later), recipient, date, offered fruit name, and offered amount.
For automating the reservation management, you first need a trigger function, which implements the management logic:
*/

CREATE OR REPLACE FUNCTION reserve_stock_on_offer () RETURNS trigger AS $$
    BEGIN
        IF TG_OP = 'INSERT' THEN
            UPDATE fruits_in_stock
	       SET reserved = reserved + NEW.offered_amount
	     WHERE name = NEW.fruit_name;
	ELSIF TG_OP = 'UPDATE' THEN
	    UPDATE fruits_in_stock
	       SET reserved = reserved - OLD.offered_amount
                                     + NEW.offered_amount
	     WHERE name = NEW.fruit_name;
	ELSIF TG_OP = 'DELETE' THEN
	   UPDATE fruits_in_stock
	      SET reserved = reserved - OLD.offered_amount
	    WHERE name = OLD.fruit_name;
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

/*
You have to tell PostgreSQL to call this function each and every time the offer row is changed:
*/

CREATE TRIGGER manage_reserve_stock_on_offer_change
AFTER INSERT OR UPDATE OR DELETE ON fruit_offer
    FOR EACH ROW EXECUTE PROCEDURE reserve_stock_on_offer();
    
/*
After this we are ready to test the functionality.
First, we will add some fruit to our stock
*/

INSERT INTO fruits_in_stock(name,in_stock)

/*
And then check that stock (this is using the Extended display):
postgres=# \x
Expanded display is on.
postgres=# SELECT * FROM fruits_in_stock;
-[ RECORD 1 ]----
name     | APPLE
in_stock | 500
reserved | 0
-[ RECORD 2 ]----
name     | ORANGE
in_stock | 500
reserved | 0
And Next, let's make an offer of 100 apples to Bob:
*/

INSERT INTO fruit_offer(recipient_name,fruit_name,offered_amount) VALUES('Bob','APPLE',100);
/*
INSERT 0 1
postgres=# SELECT * FROM fruit_offer;
-[ RECORD 1 ]--+---------------------------
offer_id       | 1
recipient_name | Bob
offer_date     | 2013-01-25 15:21:15.281579
fruit_name     | APPLE
offered_amount | 100

postgres=# SELECT * FROM fruits_in_stock;
-[ RECORD 1 ]----
name     | ORANGE
in_stock | 500
reserved | 0
-[ RECORD 2 ]----
name     | APPLE
in_stock | 500
reserved | 100
Checking the stock we see that indeed 100 apples are reserved
postgres=# SELECT * FROM fruits_in_stock;
-[ RECORD 1 ]----
name     | ORANGE
in_stock | 500
reserved | 0
-[ RECORD 2 ]----
name     | APPLE
in_stock | 500
reserved | 100
If we change the offered amount, then the reservation follows:
*/

UPDATE fruit_offer SET offered_amount = 115 WHERE offer_id = 1;

/*
UPDATE 1
postgres=# SELECT * FROM fruits_in_stock;
-[ RECORD 1 ]----
name     | ORANGE
in_stock | 500
reserved | 0
-[ RECORD 2 ]----
name     | APPLE
in_stock | 500
reserved | 115
We also get some extra benefits.  First - because of the constraint on stock table, you can't sell the reserved apples:
postgres=# 
*/
UPDATE fruits_in_stock SET in_stock = 100 WHERE name = 'APPLE';

/*
ERROR:  new row for relation "fruits_in_stock" violates check constraint "fruits_in_stock_check"
DETAIL:  Failing row contains (APPLE, 100, 115).
More interestingly, you also can't reserve more than you have, even though the constraints are on another table:
postgres=# */
UPDATE fruit_offer SET offered_amount = 1100 WHERE offer_id = 1;
/*
ERROR:  new row for relation "fruits_in_stock" violates check constraint "fruits_in_stock_check"
DETAIL:  Failing row contains (APPLE, 500, 1100).
CONTEXT:  SQL statement "UPDATE fruits_in_stock
       SET reserved = reserved - OLD.offered_amount
                                     + NEW.offered_amount
     WHERE name = NEW.fruit_name"
PL/pgSQL function reserve_stock_on_offer() line 8 at SQL statement

When you finally delete the offer, the reservation is released 
postgres=# 
*/
DELETE FROM fruit_offer WHERE offer_id = 1;
/*
DELETE 1
postgres=# SELECT * FROM fruits_in_stock;
-[ RECORD 1 ]----
name     | ORANGE
in_stock | 500
reserved | 0
-[ RECORD 2 ]----
name     | APPLE
in_stock | 500
reserved | 0
*/
