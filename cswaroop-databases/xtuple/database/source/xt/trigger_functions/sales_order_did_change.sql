create or replace function xt.sales_order_did_change() returns trigger as $$
/* Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
   See www.xm.ple.com/CPAL for the full text of the software license. */

return (function () {

   var data = Object.create(XT.Data),
     sqlUpdate = "update quhead set quhead_status = 'C' where quhead_id=$1",
     sqlDelete = "select deletequote($1);",
     sql,
     orm,
     id,
     showQuotes;

   /* Handle quote disposition if this is a new sales order converted from a quote */
   if (TG_OP === 'INSERT' &&
       NEW.cohead_wasquote &&
       NEW.cohead_quote_number) {
    orm = data.fetchOrm("XM", "Quote");
    id = data.getId(orm, NEW.cohead_quote_number);
    showQuotes = plv8.execute("SELECT fetchmetricbool('ShowQuotesAfterSO') AS metric")[0].metric;
    sql = showQuotes ? sqlUpdate : sqlDelete;
    plv8.execute(sql, [id]);
    return NEW;
   }

}());

$$ language plv8;
