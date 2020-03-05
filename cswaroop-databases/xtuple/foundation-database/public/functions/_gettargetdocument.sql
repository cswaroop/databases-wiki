DROP FUNCTION IF EXISTS _gettargetdocument(INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION _gettargetdocument(pDocAssId INTEGER,
                                              pSourceId INTEGER,
                                              pSourceDocId INTEGER = -1)
  RETURNS SETOF _targetdoc AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _targetId INTEGER;
  _baseq    TEXT := NULL;
  _query    TEXT := NULL;
  _src      RECORD;
  _row      _targetdoc%ROWTYPE;

BEGIN

  SELECT * INTO _src FROM source WHERE source_id = pSourceId;
  IF NOT FOUND OR _src.source_docass = '' THEN
    RAISE EXCEPTION 'Invalid source_id [xtuple: _gettargetdocument, -2, %]',
                    pSourceId;
  END IF;

  SELECT CASE WHEN docass_source_id != pSourceDocId THEN docass_source_id
         ELSE docass_target_id
         END INTO _targetId
    FROM docass
   WHERE docass_id = pDocAssId;
  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'Invalid docass_id [xtuple: _gettargetdocument, -1, %]',
                    pDocAssId;
  END IF;

  _baseq = $Q$
           SELECT %s AS target_docass_id,
                  %s AS target_source_id,
                  %s AS target_doc_number,
                  %s AS target_doc_name,
                  %s AS target_doc_descrip
             FROM %s
             %s
            WHERE %s = %s;
           $Q$;

  _query = format(_baseq, pDocAssId, pSourceId,
                  _src.source_number_field, _src.source_name_field,
                  _src.source_desc_field, _src.source_table,
                  coalesce(_src.source_joins, ''), _src.source_key_field,
                  _targetId);
  RAISE DEBUG '%', _query;

  FOR _row IN EXECUTE(_query)
  LOOP
    RETURN NEXT _row;
  END LOOP;

END;
$$
LANGUAGE plpgsql;
