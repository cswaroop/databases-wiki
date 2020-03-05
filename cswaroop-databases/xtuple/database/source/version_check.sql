do $$
  DECLARE
    _result BOOLEAN := compareVersion(fetchMetricText('ServerVersion'), '4.2.0') <= 0;
  BEGIN
    IF _result THEN
      RAISE EXCEPTION 'Database version must be 4.2.0 or higher';
    END IF;
  END
$$ language plpgsql;
