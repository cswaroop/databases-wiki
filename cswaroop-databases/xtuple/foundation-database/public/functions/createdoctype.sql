drop function if exists createdoctype(integer, text, text, text, text, text, text, text, text, text, text, text, text, text, text);
drop function if exists createDoctype(integer, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text);

create or replace function createDoctype(pDocAssNum integer, pType text, pDocAss text,
                                         pCharAss text, pFull   text, pTable  text,
                                         pKey     text, pNumber text, pName   text,
                                         pDesc    text,
                                         pWidget  text = '', pJoin   text = '',
                                         pParam   text = '', pUi     text = '',
                                         pPriv    text = '', pModule text = 'System',
                                         pActive  text = '')
  returns integer as $$
/* Copyright (c) 1999-2016 by OpenMFG LLC, d/b/a xTuple.
   See www.xtuple.com/CPAL for the full text of the software license.

   Create a record in the "source" table corresponding to this document type
   or update existing records. The pDocAssNum MUST match the corresponding
   Documents::DocumentSources (qt-client/widgets/documents.h) if the record
   type is there. Otherwise pass NULL or 0 and let the `source` table trigger
   set a value.
   See the source table comments for a description of the other arguments.
 */
declare
  _id integer := -1;
begin

  update source
     set source_docass_num   = coalesce(pDocAssNum, 0),
         source_module       = pModule,
         source_docass       = pDocAss,
         source_charass      = pCharass,
         source_descrip      = pFull,
         source_table        = pTable,
         source_key_field    = pKey,
         source_number_field = pNumber,
         source_name_field   = pName,
         source_desc_field   = pDesc,
         source_joins        = pJoin,
         source_widget       = pWidget,
         source_key_param    = pParam,
         source_uiform_name  = pUi,
         source_create_priv  = pPriv,
         source_active_field = pActive
   where source_name = pType
   returning source_id into _id;

  if _id is null then
    insert into source (source_docass_num, source_module,
        source_name,      source_descrip,      source_table,
        source_docass,    source_charass,
        source_key_field, source_number_field, source_name_field,
        source_desc_field, source_joins,       source_widget,
        source_key_param, source_uiform_name,  source_create_priv,
        source_active_field
      ) values (coalesce(pDocAssNum, 0), pModule,
         pType,   pFull,   pTable,
         pDocAss, pCharAss,
         pKey,    pNumber, pName,
         pDesc,   pJoin,   pWidget,
         pParam,  pUi,     pPriv,
         pActive
      ) returning source_id into _id;
  end if;

  return _id;
end;
$$ language plpgsql;
