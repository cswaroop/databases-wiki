drop function if exists xt.register_extension(text, text, text, text, integer);

create or replace function xt.register_extension(name text, descrip text, location text,
    notes text, load_order integer) returns boolean volatile as $$

  var sqlCount = "select count(*) as count from xt.ext where ext_name = $1;",
    sqlInsert = "insert into xt.ext (ext_name, ext_descrip, ext_location, ext_notes, ext_load_order) values ($1, $2, $3, $4, $5)",
    sqlUpdate = "update xt.ext set ext_descrip = $2, ext_location = $3, ext_notes = $4, ext_load_order = $5 where ext_name = $1;",
    count = plv8.execute(sqlCount, [ name ])[0].count;

    if(count > 0) {
      plv8.execute(sqlUpdate, [name, descrip, location, notes, load_order]);
      return false;
    }

    plv8.execute(sqlInsert, [name, descrip, location, notes, load_order]);
    return true;

$$ language plv8;
