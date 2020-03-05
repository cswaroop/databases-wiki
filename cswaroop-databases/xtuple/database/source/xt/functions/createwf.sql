DROP FUNCTION IF EXISTS xt.createwf(text, anyelement);

CREATE OR REPLACE FUNCTION xt.createwf(
    text,
    anyelement)
  RETURNS record AS
$BODY$
/* Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
   See www.xm.ple.com/CPAL for the full text of the software license. */
DECLARE
tg_table_name ALIAS FOR $1;
tg_table_row  ALIAS FOR $2;
_wftypecode   TEXT      := '';
_source_model TEXT      := '';
_workflow_class TEXT    := '';
_default_hold_type CHARACTER(1);
_item_uuid    UUID;
_parent_id    INTEGER   := 0;
_order_id     INTEGER   := 0;
_poparent     RECORD;
_saletypeextExists BOOLEAN := false;

BEGIN

   IF (fetchmetricbool('TriggerWorkflow')) THEN

      -- Get data by type
      IF (tg_table_name = 'cohead') THEN
        _wftypecode := 'SO';
        _workflow_class  := 'XM.SalesOrderWorkflow';
        _item_uuid := tg_table_row.obj_uuid;
        _parent_id := tg_table_row.cohead_saletype_id;
        _order_id := tg_table_row.cohead_id;

        -- Copy SaleType char to Sales Order.
        PERFORM xt.copychars('ST', _parent_id, 'S', _order_id);

        -- Switch `cohead_holdtype` to the `saletypeext_default_hold_type`.
        SELECT EXISTS (
          SELECT 1
          FROM   pg_catalog.pg_class c
          JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
          WHERE  n.nspname = 'xt'
          AND    c.relname = 'saletypeext'
          AND    c.relkind = 'r' -- table
        ) INTO _saletypeextExists;

        IF (_saletypeextExists) THEN
          SELECT
            saletypeext_default_hold_type INTO _default_hold_type
          FROM xt.saletypeext
          WHERE saletypeext_id = _parent_id;

          IF ((_default_hold_type IS NOT NULL) AND (_order_id > 0)) THEN
            UPDATE cohead SET
              cohead_holdtype = _default_hold_type
            WHERE cohead_id = _order_id;
          END IF;
        END IF;

      ELSIF (tg_table_name = 'prj') THEN
         _wftypecode := 'PRJ';
         _workflow_class  := 'XM.ProjectWorkflow';
         _item_uuid := tg_table_row.obj_uuid;
         _parent_id := tg_table_row.prj_prjtype_id;
         _order_id := tg_table_row.prj_id;

      ELSIF (tg_table_name = 'pohead') THEN
         _wftypecode := 'PO';
         _workflow_class  := 'XM.PurchaseOrderWorkflow';
         SELECT poheadext_potype_id AS parent_id, pohead_id,
           pohead.obj_uuid AS pohead_uuid,
           pohead_status INTO _poparent
           FROM pohead JOIN xt.poheadext ON poheadext_id = pohead_id
           WHERE pohead_id = tg_table_row.pohead_id;
         IF (NOT FOUND) THEN
           RAISE WARNING 'Missing parentId needed to generate workflow!';
         END IF;
         IF (_poparent.pohead_status <> 'O') THEN
           RETURN tg_table_row;
         END IF;
         _item_uuid    := _poparent.pohead_uuid;
         _parent_id    := _poparent.parent_id;
         _order_id     := _poparent.pohead_id;

      ELSIF (tg_table_name = 'poheadext') THEN
         _wftypecode := 'PO';
         _workflow_class  := 'XM.PurchaseOrderWorkflow';
         SELECT poheadext_potype_id AS parent_id, pohead_id, 
           pohead.obj_uuid AS pohead_uuid, 
           pohead_status INTO _poparent
           FROM pohead JOIN xt.poheadext ON poheadext_id = pohead_id 
           WHERE pohead_id = tg_table_row.poheadext_id;
         IF (NOT FOUND) THEN
           RAISE WARNING 'Missing parentId needed to generate workflow!';
         END IF;
         IF (_poparent.pohead_status <> 'O') THEN 
           RETURN tg_table_row;
         END IF;
         _item_uuid    := _poparent.pohead_uuid;
         _parent_id    := _poparent.parent_id;
         _order_id     := _poparent.pohead_id;

      ELSIF (tg_table_name = 'tohead') THEN
         _wftypecode := 'TO';
         _workflow_class  := 'XM.TransferOrderWorkflow';
         _item_uuid := tg_table_row.obj_uuid;
         SELECT warehous_sitetype_id AS parent_id INTO _parent_id FROM warehous WHERE warehous_id = tg_table_row.tohead_src_warehous_id;
         IF (NOT FOUND) THEN
           RAISE WARNING 'Missing parentId needed to generate workflow!';
         END IF;
         _order_id     := tg_table_row.tohead_id;

      ELSIF (tg_table_name = 'wo') THEN
         _wftypecode := 'WO';
         _workflow_class  := 'XM.WorkOrderWorkflow';
         _item_uuid := tg_table_row.obj_uuid;
         SELECT itemsite_plancode_id INTO _parent_id
           FROM itemsite
	  WHERE itemsite_id = tg_table_row.wo_itemsite_id;
         IF (NOT FOUND) THEN
           RAISE WARNING 'Missing parentId needed to generate workflow! tg_table_row.wo_itemsite_id is %', tg_table_row.wo_itemsite_id;
         END IF;
         _order_id = tg_table_row.wo_id;
         IF ((SELECT wo_status FROM wo WHERE wo_id = _order_id) <> 'R') THEN
           RETURN tg_table_row;
         END IF;
      ELSE
        RAISE WARNING 'No table name supplied to createwf function';
      END IF;

      -- Get _source_model
      SELECT wftype_src_tblname AS srctblname FROM xt.wftype WHERE wftype_code = _wftypecode INTO _source_model;
      IF (NOT FOUND) THEN
        RAISE WARNING 'Missing sourceModel needed to generate workflow!';
      END IF;

      -- Generate workflow
      PERFORM xt.workflow_inheritsource('xt.' || _source_model, _workflow_class, _item_uuid, _parent_id, _order_id);

  END IF;

RETURN tg_table_row;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION xt.createwf(text, anyelement)
  OWNER TO admin;
