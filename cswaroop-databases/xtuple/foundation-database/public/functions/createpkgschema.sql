CREATE OR REPLACE FUNCTION createPkgSchema(TEXT, TEXT) RETURNS INTEGER AS $$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pname         ALIAS FOR $1;
  pcomment      ALIAS FOR $2;
  _namespaceoid INTEGER := -1;
  _tabs         TEXT[] := ARRAY['cmd',  'cmdarg', 'image',  'metasql',
                                'priv', 'report', 'script', 'uiform'] ;
  _pkgtab       TEXT;

BEGIN
  IF (LENGTH(COALESCE(pname, '')) <= 0) THEN
    RAISE EXCEPTION 'Cannot create a schema for this package without a name.';
  END IF;

  SELECT oid INTO _namespaceoid
  FROM pg_namespace
  WHERE (LOWER(nspname)=LOWER(pname));
  IF (NOT FOUND) THEN
    EXECUTE format('CREATE SCHEMA %s;', LOWER(pname));
    EXECUTE format('GRANT ALL ON SCHEMA %s TO GROUP xtrole;', LOWER(pname));

    SELECT oid INTO _namespaceoid
    FROM pg_namespace
    WHERE (LOWER(nspname)=LOWER(pname));
  END IF;

  FOR i IN ARRAY_LOWER(_tabs,1)..ARRAY_UPPER(_tabs,1) LOOP
    _pkgtab := 'pkg' || _tabs[i];

    IF NOT EXISTS(SELECT oid
                  FROM pg_class
                  WHERE ((relname=_pkgtab)
                     AND (relnamespace=_namespaceoid))) THEN
      EXECUTE format('CREATE TABLE %s.%s () INHERITS (%s);',
                     pname, _pkgtab, _tabs[i]);

      EXECUTE format($f$ALTER TABLE %s.%s ALTER %s_id SET NOT NULL,
                         ADD PRIMARY KEY (%s_id),
                         ALTER %s_id SET DEFAULT NEXTVAL('%s_%s_id_seq');$f$,
                     pname, _pkgtab, _tabs[i], _tabs[i], _tabs[i], _tabs[i], _tabs[i]);

      EXECUTE format('REVOKE ALL ON %s.%s FROM PUBLIC;',     pname, _pkgtab);
      EXECUTE format('GRANT  ALL ON %s.%s TO GROUP xtrole;', pname, _pkgtab);

      IF (_tabs[i] = 'cmdarg') THEN
        EXECUTE format($f$ALTER TABLE %s.%s ADD FOREIGN KEY (cmdarg_cmd_id)
                          REFERENCES %s.pkgcmd(cmd_id);$f$,
                       pname, _pkgtab, pname);
      END IF;

      EXECUTE format('DROP TRIGGER IF EXISTS %sbeforetrigger ON %s.%s;',
                     _pkgtab, pname, _pkgtab);
      EXECUTE format('CREATE TRIGGER %sbeforetrigger' ||
                     ' BEFORE INSERT OR UPDATE OR DELETE ON %s.%s' ||
                     ' FOR EACH ROW EXECUTE PROCEDURE _%sbeforetrigger();',
                      _pkgtab, pname, _pkgtab, _pkgtab);

      EXECUTE format('DROP TRIGGER IF EXISTS %saltertrigger ON %s.%s;',
                      _pkgtab, pname, _pkgtab);
      EXECUTE format('CREATE TRIGGER %saltertrigger' ||
                     ' BEFORE INSERT OR UPDATE OR DELETE ON %s.%s' ||
                     ' FOR EACH ROW EXECUTE PROCEDURE _%saltertrigger();',
                     _pkgtab, pname, _pkgtab, _pkgtab);

      EXECUTE format('DROP TRIGGER IF EXISTS %saftertrigger ON %s.%s;',
                     _pkgtab, pname, _pkgtab);
      EXECUTE format('CREATE TRIGGER %saftertrigger' ||
                     ' AFTER INSERT OR UPDATE OR DELETE ON %s.%s' ||
                     ' FOR EACH ROW EXECUTE PROCEDURE _%saftertrigger();',
                     _pkgtab, pname, _pkgtab, _pkgtab);

    END IF;
  END LOOP;

  EXECUTE 'COMMENT ON SCHEMA ' || quote_ident(pname) || ' IS ' ||
           quote_literal(pcomment) || ';';

  RETURN _namespaceoid;
END;
$$
LANGUAGE 'plpgsql';
