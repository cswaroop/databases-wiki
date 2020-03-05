CREATE OR REPLACE FUNCTION public.compareversion(pLeft text, pRight text DEFAULT split_part(version(), ' '::text, 2))
  RETURNS integer AS
$$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
-- Returns 1 if the left version is greater than the right version
-- -1 if the right is greater than the left
--  0 if the versions are equal.
-- parameter two defaults to current server version
DECLARE
  _left   SMALLINT[] := _normalizeVersion(pLeft);
  _right  SMALLINT[] := _normalizeVersion(pRight);
  _result SMALLINT   := 0;
  _major  SMALLINT   := 1;  -- 4
  _minor  SMALLINT   := 2;  -- .5
  _point  SMALLINT   := 3;  -- .6
  _qual   SMALLINT   := 4;  -- beta
  _qualn  SMALLINT   := 5;  -- 2
  _subq   SMALLINT   := 6;  -- A
BEGIN
  CASE WHEN _left[_major] > _right[_major] THEN _result :=  1;
       WHEN _left[_major] < _right[_major] THEN _result := -1;
       WHEN _left[_minor] > _right[_minor] THEN _result :=  1;
       WHEN _left[_minor] < _right[_minor] THEN _result := -1;
       WHEN _left[_point] > _right[_point] THEN _result :=  1;
       WHEN _left[_point] < _right[_point] THEN _result := -1;
       WHEN _left[_qual]  > _right[_qual]  THEN _result :=  1;
       WHEN _left[_qual]  < _right[_qual]  THEN _result := -1;
       WHEN _left[_qualn] > _right[_qualn] THEN _result :=  1;
       WHEN _left[_qualn] < _right[_qualn] THEN _result := -1;
       WHEN _left[_subq]  > _right[_subq]  THEN _result :=  1;
       WHEN _left[_subq]  < _right[_subq]  THEN _result := -1;
       WHEN _left[_subq]  = _right[_subq]  THEN _result :=  0;
  END CASE;

  RETURN _result;

END;
$$ LANGUAGE plpgsql STABLE;
ALTER FUNCTION public.compareversion(text, text) OWNER TO admin;
