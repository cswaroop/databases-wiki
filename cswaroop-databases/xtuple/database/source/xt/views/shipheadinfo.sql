select xt.create_view('xt.shipheadinfo', $$

  select
    shipheadunion.*,
    (
      select
        case
          when invchead.invchead_id is not null then true
          else false
        end as invoiced
      from invchead
      where invchead_id in (
        select invcitem_invchead_id
        from invcitem
        where invcitem_id in (
          select shipitem_invcitem_id
          from shipitem
          where shipitem_shiphead_id = shiphead_id
        )
      )
    ) as invoiced,
    (
      select
        coalesce(invchead.invchead_posted, FALSE) AS invchead_posted
      from invchead
      where invchead_id in (
        select invcitem_invchead_id
        from invcitem
        where invcitem_id in (
          select shipitem_invcitem_id
          from shipitem
          where shipitem_shiphead_id = shiphead_id
        )
      )
    ) as invchead_posted,
    xt.shipment_value(shiphead_id) AS shipment_value,
    shipheadunion.order_uuid as shiphead_order_uuid
  from (
    select
      shiphead.*,
      cohead.obj_uuid as order_uuid
    from shiphead
      join cohead on shiphead_order_id = cohead_id
    where shiphead.shiphead_order_type = 'SO'::text
  ) shipheadunion;

$$, false);


create or replace rule "_INSERT" as on insert to xt.shipheadinfo do instead nothing;

create or replace rule "_UPDATE" as on update to xt.shipheadinfo do instead

update shiphead set
  shiphead_order_id=new.shiphead_order_id,
  shiphead_order_type=new.shiphead_order_type,
  shiphead_number=new.shiphead_number,
  shiphead_shipvia=new.shiphead_shipvia,
  shiphead_freight=new.shiphead_freight,
  shiphead_freight_curr_id=new.shiphead_freight_curr_id,
  shiphead_notes=new.shiphead_notes,
  shiphead_shipped=new.shiphead_shipped,
  shiphead_shipdate=new.shiphead_shipdate,
  shiphead_shipchrg_id=new.shiphead_shipchrg_id,
  shiphead_shipform_id=new.shiphead_shipform_id,
  shiphead_sfstatus=new.shiphead_sfstatus,
  shiphead_tracknum=new.shiphead_tracknum
where shiphead_id = old.shiphead_id;

create or replace rule "_DELETE" as on delete to xt.shipheadinfo do instead nothing;
