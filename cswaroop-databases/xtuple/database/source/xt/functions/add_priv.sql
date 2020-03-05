drop function if exists xt.add_priv(text, text, text, text);

create or replace function xt.add_priv(name text, descrip text, module text, groop text, schema text default null) returns boolean volatile as $$

  var privTable,
    privSchema,
    sqlCount = "select count(*) as count from public.priv where priv_name = $1;",
    sqlInsert = "insert into %1$I.%2$I (priv_name, priv_module, priv_descrip) values ($1, $2, $3)",
    sqlGrantToAdmin = "select xt.grant_role_priv('ADMIN', $1, $2)",
    count = plv8.execute(sqlCount, [ name ])[0].count;

  if (schema && schema !== "public") {
    privSchema = schema;
    privTable = "pkgpriv";
  } else {
    privSchema = "public";
    privTable = "priv";
  }

  if(count > 0) {
    /* Grant this priv to the 'ADMIN' role by default. */
    plv8.execute(sqlGrantToAdmin, [module, name]);

    return false;
  }

  /* groop is a placeholder until we add a group column in xt.privinfo */
  /* groop is used to segment the assignment box */
  /* module is the name of the extension. was used to filter the assignment box, but doesn't do that any more */
  sqlInsert = XT.format(sqlInsert, [privSchema, privTable]);
  plv8.execute(sqlInsert, [name, module, descrip]);

  /* Grant this priv to the 'ADMIN' role by default. */
  plv8.execute(sqlGrantToAdmin, [module, name]);

  return true;

$$ language plv8;
