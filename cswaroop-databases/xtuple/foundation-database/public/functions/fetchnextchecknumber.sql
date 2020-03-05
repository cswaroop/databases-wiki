
CREATE OR REPLACE FUNCTION fetchNextCheckNumber(pBankaccntid INTEGER) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _nextChkNumber INTEGER;
  _maxUsed       INTEGER;

BEGIN

  SELECT bankaccnt_nextchknum INTO _nextChkNumber
    FROM bankaccnt
   WHERE (bankaccnt_id=pBankaccntid);

  SELECT MAX(checkhead_number) INTO _maxUsed
    FROM checkhead
   WHERE checkhead_bankaccnt_id=pBankaccntid;

  IF COALESCE(_maxUsed, 0) >= _nextChkNumber
     AND NOT fetchmetricbool('ReprintPaymentNumbers') THEN
    SELECT MIN(generate_series) INTO _nextChkNumber
      FROM generate_series(_nextChkNumber, _maxUsed + 1)
      LEFT OUTER JOIN checkhead ON checkhead_number=generate_series
                               AND checkhead_bankaccnt_id=pBankaccntid
     WHERE COALESCE(checkhead_number, -1) < 0;
  END IF;

  UPDATE bankaccnt
  SET bankaccnt_nextchknum = (_nextChkNumber + 1)
  WHERE (bankaccnt_id=pBankaccntid);

  RETURN _nextChkNumber;

END;
$$ LANGUAGE plpgsql;

