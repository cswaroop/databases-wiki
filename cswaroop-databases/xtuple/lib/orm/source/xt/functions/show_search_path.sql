-- Cleanup old installs in xt schema.
DROP FUNCTION IF EXISTS xt.show_search_path();

create or replace function public.show_search_path() returns text as $$
declare
  path text;
  rec record;
begin
  -- This exists because show search_path command doesn't work in plv8
  for rec in execute 'show search_path'
  loop
      return rec.search_path::text;
  end loop;
end;
$$ language plpgsql;
