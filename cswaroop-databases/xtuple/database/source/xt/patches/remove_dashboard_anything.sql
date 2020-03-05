-- Remove xtuple-dashboard-anything extension that was installed the old way with ext_location = 'npm'.
DELETE FROM xt.grpext
WHERE grpext_ext_id = (
  SELECT
    ext_id
  FROM xt.ext
  WHERE ext_name = 'xtuple-dashboard-anything'
    AND ext_location = 'npm'
);

DELETE FROM xt.usrext
WHERE usrext_ext_id = (
  SELECT
    ext_id
  FROM xt.ext
  WHERE ext_name = 'xtuple-dashboard-anything'
    AND ext_location = 'npm'
);

DELETE FROM xt.ext
WHERE ext_name = 'xtuple-dashboard-anything'
  AND ext_location = 'npm';
