CREATE OR REPLACE FUNCTION xt.parseediprofile(ediprofile text, options text default '{}')
  RETURNS text AS
$BODY$

  var editext = '';

  /**
   * Call the parser with this functions parameters.
   */
  try {
    editext += XT.EDIProfile.parser.parse(ediprofile, JSON.parse(options));
  } catch (err) {
    plv8.elog(ERROR, 'Cannot parse EDI Profile Tokens. ERROR: ', err);
  }

  return editext;
$BODY$
  LANGUAGE plv8;
