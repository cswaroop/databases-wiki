SELECT dropIfExists('TYPE', 'creditcheck', 'public', true);

CREATE TYPE creditcheck AS
   (creditcheck_cust_id   INTEGER,
    creditcheck_limit     NUMERIC,
    creditcheck_bookings  NUMERIC,
    creditcheck_aropen      NUMERIC
   );


