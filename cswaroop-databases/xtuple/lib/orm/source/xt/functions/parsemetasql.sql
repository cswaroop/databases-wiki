CREATE OR REPLACE FUNCTION xt.parsemetasql(
    metasql text,
    options text default '{}')
  RETURNS text AS
$BODY$
  /**
   * xt.parsemetasql(text, text)
   * ===========================
   *
   * Wrapper function for the plv8 MetaSQL PEG parser:
   *                         - XT.MetaSQL.parser.parse(metasql, options);
   *
   * @param {string} metasql - The MetaSQL query text string.
   * @param {string} options - A JSON string of options in the format of:
   *                           '{"params":{"your-metasql-parameter-here":"your-value-here","Pn":"Vn"}}'
   * @returns {string}       - Returns a query text string with the MetaSQL
   *                         - parameters replaced with your values
   *
   * Example Usage:
   *   SELECT xt.parsemetasql(
   *     'SELECT <? value("foo") ?> AS baz;',
   *     '{"params":{"foo":"bar"}}'
   *   );
   *
   *   Returns: "SELECT 'bar' AS baz;"
   */
  var sql = '';

  /*
   * Call the parser with this functions parameters.
   */
  try {
    sql += XT.MetaSQL.parser.parse(metasql, JSON.parse(options));
  } catch (err) {
    plv8.elog(ERROR, 'Cannot parse MetaSQL. ERROR: ', err);
  }

  return sql;
$BODY$
  LANGUAGE plv8;

CREATE OR REPLACE FUNCTION xt.parsemetasql(
    pGroup text,
    pName text,
    pOptions text)
  RETURNS text AS
$BODY$
DECLARE
  qry TEXT;
BEGIN
  -- Overload for xt.parsemetasql(text, text) that loads the MetaSQL from the
  -- metasql table based on pGroup and pName then passes it to the parser along
  -- with pOptions.

  SELECT metasql_query INTO qry
  FROM metasql
  WHERE metasql_name = pName
    AND metasql_group = pGroup
  ORDER BY metasql_grade DESC
  LIMIT 1;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'MetaSQL Query %-% was not found.', pGroup, pName;
  END IF;

  RETURN xt.parsemetasql(qry, pOptions);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION xt.parsemetasql(text, text, text)
  OWNER TO admin;
