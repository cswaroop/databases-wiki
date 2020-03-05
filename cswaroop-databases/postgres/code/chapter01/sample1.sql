/*
Let's start with a simple example.  
Many applications include a list of customers who have 
a balance in their account.  We'll use this sample schema and data:
*/

CREATE TABLE accounts(owner text, balance numeric);
INSERT INTO accounts VALUES ('Bob',100);
INSERT INTO accounts VALUES ('Mary',200);

/*
When using a database, the most common way to interact with it
is to use SQL queries. If you want to move 14 dollars from Bob's 
account to Mary's account, with simple SQL it would look like this:
*/

UPDATE accounts SET balance = balance - 14.00 WHERE owner = 'Bob';
UPDATE accounts SET balance = balance + 14.00 WHERE owner = 'Mary';

/*
But you have to also make sure that Bob actually has enough money 
(or credit) on his account. It's also important that if anything fails 
then none of the transactions happen. In an application program, 
the above might become:
*/

BEGIN;
SELECT amount FROM accounts WHERE owner = 'Bob' FOR UPDATE;
-- now in the application check that the amount is actually bigger than 14
UPDATE accounts SET amount = amount - 14.00 WHERE owner = 'Bob';
UPDATE accounts SET amount = amount + 14.00 WHERE owner = 'Mary';
COMMIT;