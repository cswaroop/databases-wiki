CREATE OR REPLACE FUNCTION saveAddr(pAddrId int4, pNumber text,
                                    pAddr1 text, pAddr2 text, pAddr3 text,
                                    pCity text, pState text, pPostalCode text,
                                    pCountry text, pActive boolean, pNotes text, pFlag text)
  RETURNS integer AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _addr   addr%ROWTYPE;
  _flag TEXT;
  _p RECORD;
  _cnt INTEGER;

BEGIN
  --Validate
  IF ((pFlag IS NULL) OR (pFlag = '') OR (pFlag = 'CHECK') OR (pFlag = 'CHANGEONE') OR (pFlag = 'CHANGEALL')) THEN
    IF (pFlag='') THEN
      _flag := 'CHECK';
    ELSE
      _flag := COALESCE(pFlag,'CHECK');
    END IF;
  ELSE
    RAISE EXCEPTION 'Invalid Flag (%). Valid flags are CHECK, CHANGEONE or CHANGEALL [xtuple: saveAddr, -1, %]',
                    pFlag, pFlag;
  END IF;

  _addr.addr_id         := COALESCE(pAddrId,     -1);
  _addr.addr_number     := COALESCE(pNumber,     '');
  _addr.addr_line1      := COALESCE(pAddr1,      '');
  _addr.addr_line2      := COALESCE(pAddr2,      '');
  _addr.addr_line3      := COALESCE(pAddr3,      '');
  _addr.addr_city       := COALESCE(pCity,       '');
  _addr.addr_state      := COALESCE(pState,      '');
  _addr.addr_postalcode := COALESCE(pPostalCode, '');
  _addr.addr_country    := COALESCE(pCountry,    '');
  _addr.addr_active     := COALESCE(pActive,     true);
  _addr.addr_notes      := COALESCE(pNotes,      '');

  --If there is nothing here, get out
  IF (_addr.addr_number = ''
      AND _addr.addr_line1 = ''
      AND _addr.addr_line2 = ''
      AND _addr.addr_line3 = ''
      AND _addr.addr_city  = ''
      AND _addr.addr_state = ''
      AND _addr.addr_postalcode = ''
      AND _addr.addr_country    = '') THEN
    RETURN NULL;
  END IF;

  --If we have an ID see if anything has changed, if not get out
  IF _addr.addr_id >= 0
      AND EXISTS(SELECT 1 FROM addr
                  WHERE _addr.addr_id         = addr_id
                    AND _addr.addr_number     = addr_number
                    AND _addr.addr_line1      = addr_line1
                    AND _addr.addr_line2      = addr_line2
                    AND _addr.addr_line3      = addr_line3
                    AND _addr.addr_city       = addr_city
                    AND _addr.addr_state      = addr_state
                    AND _addr.addr_postalcode = addr_postalcode
                    AND _addr.addr_country    = addr_country
                    AND _addr.addr_active     = addr_active
                    AND _addr.addr_notes      = COALESCE(addr_notes, '')) THEN
    RETURN _addr.addr_id;
  END IF;

  --Check to see if duplicate address exists
  SELECT * INTO _p
    FROM addr
   WHERE addr_id != _addr.addr_id
     AND UPPER(addr_line1)      = UPPER(_addr.addr_line1)
     AND UPPER(addr_line2)      = UPPER(_addr.addr_line2)
     AND UPPER(addr_line3)      = UPPER(_addr.addr_line3)
     AND UPPER(addr_city)       = UPPER(_addr.addr_city)
     AND UPPER(addr_state)      = UPPER(_addr.addr_state)
     AND UPPER(addr_postalcode) = UPPER(_addr.addr_postalcode)
     AND UPPER(addr_country)    = UPPER(_addr.addr_country);
  IF (FOUND) THEN
    --Note:  To prevent overwriting of existing notes, the application
    --needs to load any existing notes for a matching address before altering them.
    IF (_addr.addr_notes <> _p.addr_notes) THEN
      UPDATE addr
         SET addr_notes=addr_notes || '
' || _addr.addr_notes
       WHERE addr_id=_p.addr_id;
    END IF;
    RETURN _p.addr_id;  --A matching address exists
  END IF;

  IF (_addr.addr_id < 0) THEN
    _flag := 'CHANGEONE';
  END IF;

  IF (_flag = 'CHECK') THEN
    IF addrUseCount(_addr.addr_id) > 1 THEN
      RETURN -2;        /* do NOT raise exception here */
    ELSIF NOT EXISTS (SELECT 1 FROM addr WHERE addr_id = _addr.addr_id) THEN
      _flag := 'CHANGEONE';
    ELSE
      _flag := 'CHANGEALL';
    END IF;
  END IF;

  IF (_flag = 'CHANGEALL') THEN
    IF (_addr.addr_number = '') THEN
      SELECT addr_number INTO _addr.addr_number
        FROM addr
       WHERE(addr_id = _addr.addr_id);
      IF (_addr.addr_number = '') THEN
        _addr.addr_number := fetchNextNumber('AddressNumber');
      END IF;
    END IF;

    UPDATE addr SET
      addr_line1 = _addr.addr_line1, addr_line2 = _addr.addr_line2, addr_line3 = _addr.addr_line3,
      addr_city = _addr.addr_city, addr_state = _addr.addr_state,
      addr_postalcode = _addr.addr_postalcode, addr_country = _addr.addr_country,
      addr_active = _addr.addr_active, addr_notes = _addr.addr_notes
    WHERE addr_id = _addr.addr_id;

  ELSE
    IF (_flag = 'CHANGEONE' OR _addr.addr_number = '') THEN
      _addr.addr_number := fetchNextNumber('AddressNumber');
    END IF;

    INSERT INTO addr (addr_number,
                      addr_line1, addr_line2, addr_line3,
                      addr_city, addr_state, addr_postalcode, addr_country,
                      addr_active, addr_notes
      ) VALUES (_addr.addr_number,
                _addr.addr_line1, _addr.addr_line2, _addr.addr_line3,
                _addr.addr_city, _addr.addr_state,
                _addr.addr_postalcode, _addr.addr_country,
                _addr.addr_active, _addr.addr_notes
      ) RETURNING addr_id INTO _addr.addr_id;
  END IF;

  RETURN _addr.addr_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION saveAddr(int4, text, text, text, text, text, text, text, text, text)
  RETURNS integer AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pAddrId ALIAS FOR $1;
  pNumber ALIAS FOR $2;
  pAddr1 ALIAS FOR $3;
  pAddr2 ALIAS FOR $4;
  pAddr3 ALIAS FOR $5;
  pCity ALIAS FOR $6;
  pState ALIAS FOR $7;
  pPostalCode ALIAS FOR $8;
  pCountry ALIAS FOR $9;
  pFlag ALIAS FOR $10;
  _returnVal INTEGER;

BEGIN

  SELECT saveAddr(pAddrId,pNumber, pAddr1,pAddr2,pAddr3,pCity,pState,pPostalCode,pCountry,true,'',pFlag) INTO _returnVal;

  RETURN _returnVal;

END;
$$ LANGUAGE plpgsql;
