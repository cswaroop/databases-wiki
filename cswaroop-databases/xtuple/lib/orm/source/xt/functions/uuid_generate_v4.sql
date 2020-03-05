/**
    Generate a universally unique identifier.

    @returns {text}
*/
create or replace function xt.uuid_generate_v4() returns uuid as $$
BEGIN
  /*
   * Uses the `uuid-ossp` Postgres extension to create a UUID.
   * @See: http://www.postgresql.org/docs/9.1/static/uuid-ossp.html
   */

  RETURN public.uuid_generate_v4();
END;
$$ language plpgsql VOLATILE;
