
/* RUN sample1.sql FIRST TO CREATE NEEDED TABLE AND DATA */

/*
Unlike basic SQL, PL/pgSQL includes procedural elements, like the ability to use if/then/else statements and loops. You can easily execute SQL statements, or even loop over the result of a SQL statement, in the language too.
The integrity checks needed for the application can be done in a PL/pgSQL function which takes 3 arguments: names of payer and recipient and the amount to pay.  This sample also returns the status of the payment:
*/

CREATE OR REPLACE FUNCTION transfer( 
              i_payer text, 
              i_recipient text, 
              i_amount numeric(15,2))
RETURNS text 
AS
$$
DECLARE
  payer_bal numeric;
BEGIN
  SELECT balance INTO payer_bal 
     FROM accounts 
  WHERE owner = i_payer FOR UPDATE;
  
  IF NOT FOUND THEN
    RETURN 'Payer account not found';
  END IF;
  
  IF payer_bal < i_amount THEN
    RETURN 'Not enough funds';
  END IF;

  UPDATE accounts 
        SET balance = balance + i_amount 
    WHERE owner = i_recipient;
  IF NOT FOUND THEN
    RETURN 'Recipient does not exist';
  END IF;

  UPDATE accounts 
         SET balance = balance - i_amount 
   WHERE owner = i_payer;
   
  RETURN 'OK';
  
END;
$$ LANGUAGE plpgsql;

/*
Here are a few examples of using this function, assuming you haven't executed the previous proposed UPDATE statements yet:
postgres=# SELECT * FROM accounts;
 owner | balance 
-------+---------
 Bob   |     100
 Mary  |     200
(2 rows)

postgres=# SELECT * FROM transfer('Bob','Mary',14.00);
 transfer 
----------
 OK
(1 row)

postgres=# SELECT * FROM accounts;
 owner | balance 
-------+---------
 Mary  |  214.00
 Bob   |   86.00
(2 rows)
Your application would need to check the return code and decide how to handle these errors. As long as it was written to reject any unexpected value, you could extend this function to do more checking, such as a minimum transfer amount, and be sure it would be prevented. There are three errors this can return:
postgres=# SELECT * FROM transfer('Fred','Mary',14.00);
        transfer         
-------------------------
 Payer account not found
(1 row)

postgres=# SELECT * FROM transfer('Bob','Fred',14.00);
         transfer         
--------------------------
 Recipient does not exist
(1 row)

postgres=# SELECT * FROM transfer('Bob','Mary',500.00);
     transfer     
------------------
 Not enough funds
(1 row)
For these checks to always work, you would need to make all transfer operations go through the function, rather than manually changing the values with SQL statements.
*/