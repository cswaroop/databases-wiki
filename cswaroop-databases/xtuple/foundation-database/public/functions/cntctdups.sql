CREATE OR REPLACE FUNCTION cntctdups(pSearchText        text,
                                     pSearchContactName boolean,
                                     pSearchPhone       boolean,
                                     pSearchEmail       boolean,
                                     pSearchNumber      boolean,
                                     pSearchName        boolean,
                                     pShowInactive      boolean,
                                     pIgnoreBlanks      boolean,
                                     pIndentedDups      boolean,
                                     pCheckHnfc         boolean,
                                     pCheckFirst        boolean,
                                     pCheckMiddle       boolean,
                                     pCheckLast         boolean,
                                     pCheckSuffix       boolean,
                                     pCheckPhone        boolean,
                                     pCheckEmail        boolean)
  RETURNS SETOF cntctdup AS $$
-- Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  _cntct    cntctdup%ROWTYPE;
  _cntctdup cntctdup%ROWTYPE;
  _qry        TEXT := '';
  _debug   BOOLEAN := false;
  _baseSelect TEXT := 'SELECT cntct_id,
                              cntct_crmacct_id,
                              cntct_addr_id,
                              UPPER(cntct_first_name) AS cntct_first_name,
                              UPPER(cntct_last_name) AS cntct_last_name,
                              UPPER(cntct_honorific) AS cntct_honorific,
                              cntct_initials,
                              cntct_active,
                              cntct_phone,
                              cntct_phone2,
                              cntct_fax,
                              UPPER(cntct_email) AS cntct_email,
                              cntct_webaddr,
                              cntct_notes,
                              cntct_title,
                              cntct_number,
                              UPPER(cntct_middle) AS cntct_middle,
                              UPPER(cntct_suffix) AS cntct_suffix,
                              cntct_owner_username,
                              cntct_name,
                              crmacct_number,
                              crmacct_name,
                              addr_id,
                              addr_active,
                              addr_line1,
                              addr_line2,
                              addr_line3,
                              addr_city,
                              addr_state,
                              addr_postalcode,
                              addr_country,
                              addr_notes,
                              addr_number,
                              0 AS cntctdup_level
                  FROM cntct()
                  LEFT OUTER JOIN crmacct ON cntct_crmacct_id = crmacct_id
                  LEFT OUTER JOIN addr    ON cntct_addr_id    = addr_id';
  _paramsary  TEXT[] := ARRAY[ '"pSearchText": "' || pSearchText || '"' ];
  _paramStr   TEXT;
  _dupStr     TEXT;

BEGIN
  IF (pIndentedDups AND NOT pCheckHnfc AND NOT pCheckFirst AND NOT pCheckMiddle AND
      NOT pCheckLast AND NOT pCheckSuffix AND NOT pCheckEmail AND NOT pCheckPhone) THEN
    RETURN;
  END IF;

  IF pSearchContactName THEN _paramsary := array_append(_paramsary, '"pSearchContactName": true'); END IF;
  IF pSearchPhone       THEN _paramsary := array_append(_paramsary, '"pSearchPhone":       true'); END IF;
  IF pSearchEmail       THEN _paramsary := array_append(_paramsary, '"pSearchEmail":       true'); END IF;
  IF pSearchNumber      THEN _paramsary := array_append(_paramsary, '"pSearchNumber":      true'); END IF;
  IF pSearchName        THEN _paramsary := array_append(_paramsary, '"pSearchName":        true'); END IF;
  IF pShowInactive      THEN _paramsary := array_append(_paramsary, '"pShowInactive":      true'); END IF;
  IF pIgnoreBlanks      THEN _paramsary := array_append(_paramsary, '"pIgnoreBlanks":      true'); END IF;
  IF pIndentedDups      THEN _paramsary := array_append(_paramsary, '"pIndentedDups":      true'); END IF;
  IF pCheckHnfc         THEN _paramsary := array_append(_paramsary, '"pCheckHnfc":         true'); END IF;
  IF pCheckFirst        THEN _paramsary := array_append(_paramsary, '"pCheckFirst":        true'); END IF;
  IF pCheckMiddle       THEN _paramsary := array_append(_paramsary, '"pCheckMiddle":       true'); END IF;
  IF pCheckLast         THEN _paramsary := array_append(_paramsary, '"pCheckLast":         true'); END IF;
  IF pCheckSuffix       THEN _paramsary := array_append(_paramsary, '"pCheckSuffix":       true'); END IF;
  IF pCheckPhone        THEN _paramsary := array_append(_paramsary, '"pCheckPhone":        true'); END IF;
  IF pCheckEmail        THEN _paramsary := array_append(_paramsary, '"pCheckEmail":        true'); END IF;

  _paramStr := '{ "params": {' || array_to_string(_paramsary, ',') || '}}';

  _qry := xt.parsemetasql($m$
<? if exists("pIndentedDups") ?>
   SELECT -1 AS cntct_id,
          -1 AS cntct_crmacct_id,
          -1 AS cntct_addr_id,
          <? if not exists("pCheckFirst") ?>'' AS<? endif ?> cntct_first_name,
          <? if not exists("pCheckLast") ?> '' AS<? endif ?> cntct_last_name,
          <? if not exists("pCheckHnfc") ?> '' AS<? endif ?> cntct_honorific,
          '' AS cntct_initials,
          NULL AS cntct_active,
          <? if not exists("pCheckPhone") ?>'' AS<? endif ?> cntct_phone,
          <? if not exists("pCheckPhone") ?>'' AS<? endif ?> cntct_phone2,
          '' AS cntct_fax,
          <? if not exists("pCheckEmail") ?>'' AS<? endif ?> cntct_email,
          '' AS cntct_webaddr,
          '' AS cntct_notes,
          '' AS cntct_title,
          '' AS cntct_number,
          <? if not exists("pCheckMiddle") ?>'' AS<? endif ?> cntct_middle,
          <? if not exists("pCheckSuffix") ?>'' AS<? endif ?> cntct_suffix,
          '' AS cntct_owner_username,
          '' AS cntct_name,
          '' AS crmacct_number,
          '' AS crmacct_name,
          NULL AS addr_id,
          NULL AS addr_active,
          '' AS addr_line1,
          '' AS addr_line2,
          '' AS addr_line3,
          '' AS addr_city,
          '' AS addr_state,
          '' AS addr_postalcode,
          '' AS addr_country,
          '' AS addr_notes,
          '' AS addr_number,
          cntctdup_level FROM (
<? endif ?>
$m$
|| _baseSelect
|| $m$
    WHERE <? if not exists("pShowInactive") ?> cntct_active AND <? endif ?>
          <? if exists("pIgnoreBlanks") ?>
            (length(cntct_first_name) > 0 OR length(cntct_last_name) > 0) AND
          <? endif ?>
          (false
            <? if exists("pSearchNumber") ?>
              OR crmacct_number ~* <? value("pSearchText") ?>
            <? endif ?>
            <? if exists("pSearchName") ?>
              OR crmacct_name ~* <? value("pSearchText") ?>
            <? endif ?>
            <? if exists("pSearchContactName") ?>
              OR (cntct_first_name || ' ' || cntct_last_name) ~* <? value("pSearchText") ?>
            <? endif ?>
            <? if exists("pSearchPhone") ?>
              OR (cntct_phone || ' ' || cntct_phone2 || ' ' || cntct_fax) ~* <? value("pSearchText") ?>
            <? endif ?>
            <? if exists("pSearchEmail") ?>
              OR cntct_email ~* <? value("pSearchText") ?>
            <? endif ?>
        )
<? if exists("pIndentedDups") ?>
    ) data

   GROUP BY cntctdup_level
            <? if exists("pCheckHnfc") ?>   , cntct_honorific  <? endif ?>
            <? if exists("pCheckFirst") ?>  , cntct_first_name <? endif ?>
            <? if exists("pCheckMiddle") ?> , cntct_middle     <? endif ?>
            <? if exists("pCheckLast") ?>   , cntct_last_name  <? endif ?>
            <? if exists("pCheckSuffix") ?> , cntct_suffix     <? endif ?>
            <? if exists("pCheckEmail") ?>  , cntct_email      <? endif ?>
            <? if exists("pCheckPhone") ?>  , cntct_phone
                                            , cntct_phone2     <? endif ?>
   HAVING (false
     <? if exists("pCheckHnfc") ?>   OR COUNT(cntct_honorific)  > 1 <? endif ?>
     <? if exists("pCheckFirst") ?>  OR COUNT(cntct_first_name) > 1 <? endif ?>
     <? if exists("pCheckMiddle") ?> OR COUNT(cntct_middle)     > 1 <? endif ?>
     <? if exists("pCheckLast") ?>   OR COUNT(cntct_last_name)  > 1 <? endif ?>
     <? if exists("pCheckSuffix") ?> OR COUNT(cntct_suffix)     > 1 <? endif ?>
     <? if exists("pCheckEmail") ?>  OR COUNT(cntct_email)      > 1 <? endif ?>
     <? if exists("pCheckPhone") ?>
      OR (COUNT(cntct_phone)  > 1 AND LENGTH(cntct_phone)  > 0)
      OR (COUNT(cntct_phone2) > 1 AND LENGTH(cntct_phone2) > 0)
    <? endif ?>
   )

   <? if exists("pCheckHnfc") ?>   AND LENGTH(cntct_honorific)  > 0 <? endif ?>
   <? if exists("pCheckFirst") ?>  AND LENGTH(cntct_first_name) > 0 <? endif ?>
   <? if exists("pCheckMiddle") ?> AND LENGTH(cntct_middle)     > 0 <? endif ?>
   <? if exists("pCheckLast") ?>   AND LENGTH(cntct_last_name)  > 0 <? endif ?>
   <? if exists("pCheckSuffix") ?> AND LENGTH(cntct_suffix)     > 0 <? endif ?>
   <? if exists("pCheckEmail") ?>  AND LENGTH(cntct_email)      > 0 <? endif ?>
<? endif ?>
 ORDER BY cntct_last_name, cntct_first_name;
$m$, _paramStr);

  IF (NOT pIndentedDups) THEN
    _qry := regexp_replace(_qry, 'UPPER', '', 'g');
  END IF;

  _dupStr := replace(_baseSelect, '0 AS cntctdup_level', '1 AS cntctdup_level') || $m$
              WHERE true
              <? if exists("pCheckHnfc") ?>   AND UPPER(cntct_honorific) = $1<? endif ?>
              <? if exists("pCheckFirst") ?>  AND UPPER(cntct_first_name)= $2<? endif ?>
              <? if exists("pCheckMiddle") ?> AND UPPER(cntct_middle)    = $3<? endif ?>
              <? if exists("pCheckLast") ?>   AND UPPER(cntct_last_name) = $4<? endif ?>
              <? if exists("pCheckSuffix") ?> AND UPPER(cntct_suffix)    = $5<? endif ?>
              <? if exists("pCheckEmail") ?>  AND UPPER(cntct_email)     = $6<? endif ?>
              <? if exists("pCheckPhone") ?>  AND cntct_phone            = $7<? endif ?>
          ;$m$;

  IF _debug THEN RAISE NOTICE $r$
_qry: %
_dupStr: %
_paramStr: %$r$, _qry, _dupstr, _paramStr;
  END IF;

  FOR _cntct IN EXECUTE _qry LOOP
    RETURN NEXT _cntct;

    IF (pIndentedDups) THEN
      _qry := xt.parsemetasql(_dupStr, _paramStr);
      IF _debug THEN RAISE NOTICE 'dup query: %', _qry; END IF;

      FOR _cntctdup IN EXECUTE _qry USING
                         _cntct.cntct_honorific, _cntct.cntct_first_name, _cntct.cntct_middle,
                         _cntct.cntct_last_name, _cntct.cntct_suffix,     _cntct.cntct_email,
                         _cntct.cntct_phone
      LOOP
        RETURN NEXT _cntctdup;
      END LOOP;

    END IF;

  END LOOP;

  RETURN;
END;
$$ LANGUAGE plpgsql;
