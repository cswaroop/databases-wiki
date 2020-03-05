update source set source_charass = '', source_docass = '';

-- TATC for Time Attendance?

select createDoctype(1, --pDocAssNum
                     'ADDR', --pType
                     'ADDR', --pDocAss
                     'ADDR', --pCharAss
                     'Address', --pFull
                     'addr', --pTable
                     'addr_id', --pKey
                     'addr_number', --pNumber
                     'addr_line1', --pName
                     'addr_line2', --pDesc
                     '', --pWidget
                     '', --pJoin
                     'addr_id', --pParam
                     '', --pUi
                     '', --pPriv
                     'CRM',             -- pModule
                     'addr_active'      -- pActive
);
select createDoctype(2, --pDocAssNum
                     'BBH', --pType
                     'BBH', --pDocAss
                     '', --pCharAss
                     'Breeder BOM Head', --pFull
                     'bbomhead', --pTable
                     'bbomhead_id', --pKey
                     'bbomhead_docnum', --pNumber
                     'item_number', --pName --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget
                     'join item on bomhead_item_id = item_id', --pJoin
                     'bomhead_id', --pParam
                     'bom', --pUi
                     '', --pPriv
                     'Products' --pModule
);
select createDoctype(3, --pDocAssNum
                     'BBI', --pType
                     'BBI', --pDocAss
                     '', --pCharAss
                     'Breeder BOM Item', --pFull
                     'bbomitem', --pTable
                     'bbomitem_id', --pKey
                     'bbomitem_seqnumber::text', --pNumber
                     'item_number', --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget --pWidget
                     'join item on bbomitem_item_id = item_id', --pJoin
                     'bbomitem_id', --pParam
                     'bbom', --pUi
                     '', --pPriv
                     'Products' --pModule
);
select createDoctype(4, --pDocAssNum
                     'BMH', --pType
                     'BMH', --pDocAss
                     '', --pCharAss
                     'BOM Head', --pFull
                     'bomhead', --pTable
                     'bomhead_id', --pKey
                     'bomhead_docnum', --pNumber
                     'item_number', --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget
                     'join item on bomhead_item_id = item_id', --pJoin
                     'bomhead_id', --pParam
                     'bom', --pUi
                     '', --pPriv
                     'Products' --pModule
);
select createDoctype(5, --pDocAssNum
                     'BMI', --pType
                     'BMI', --pDocAss
                     '', --pCharAss
                     'BOM Item', --pFull
                     'bomitem', --pTable
                     'bomitem_id', --pKey
                     'p.item_number', --pNumber
                     'c.item_number', --pName
                     'firstline(c.item_descrip1)', --pDesc
                     '', --pWidget
                     'join item p on bomitem_parent_item_id = p.item_id join item c on bomitem_item_id = c.item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Products' --pModule
);
select createDoctype(6, --pDocAssNum
                     'BOH', --pType
                     'BOH', --pDocAss
                     '', --pCharAss
                     'Routing Head', --pFull
                     'boohead', --pTable
                     'boohead_id', --pKey
                     'boohead_docnum', --pNumber
                     'item_number', --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget
                     'join item on boohead_item_id = item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Products' --pModule
);
select createDoctype(7, --pDocAssNum
                     'BOI', --pType
                     'BOI', --pDocAss
                     '', --pCharAss
                     'Routing Item', --pFull
                     'booitem', --pTable
                     'booitem_id', --pKey
                     'booitem_seqnumber::text', --pNumber
                     'item_number', --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget
                     'join item on booitem_item_id = item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Products' --pModule
);
select createDoctype(8, --pDocAssNum
                     'CRMA', --pType
                     'CRMA', --pDocAss
                     'CRMACCT', --pCharAss
                     'Account', --pFull
                     'crmacct', --pTable
                     'crmacct_id', --pKey
                     'crmacct_number', --pNumber
                     'crmacct_name', --pName
                     'firstline(crmacct_notes)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'crmacct_id', --pParam
                     'crmaccount', --pUi
                     '', --pPriv
                     'CRM',             -- pModule
                     'crmacct_active'   -- pActive
);
select createDoctype(9, --pDocAssNum
                     'T', --pType
                     'T', --pDocAss
                     'CNTCT', --pCharAss
                     'Contact', --pFull
                     'cntct', --pTable
                     'cntct_id', --pKey
                     'cntct_number', --pNumber
                     'cntct_name', --pName
                     'cntct_title', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'cntct_id', --pParam
                     'contact', --pUi
                     '', --pPriv
                     'CRM',             -- pModule
                     'cntct_active'     -- pActive
);
select createDoctype(10, --pDocAssNum
                     'CNTR', --pType
                     'CNTR', --pDocAss
                     '', --pCharAss
                     'Contract', --pFull
                     'cntrct', --pTable
                     'cntrct_id', --pKey
                     'cntrct_number', --pNumber
                     'vend_name', --pName
                     'cntrct_descrip', --pDesc
                     '', --pWidget
                     'join vendinfo on cntrct_vend_id = vendid', --pJoin
                     'cntrct_id', --pParam
                     'contrct', --pUi
                     '', --pPriv
                     'System' --pModule
);
select createDoctype(11, --pDocAssNum
                     'CM', --pType
                     'CM', --pDocAss
                     '', --pCharAss
                     'Return', --pFull
                     'cmhead', --pTable
                     'cmhead_id', --pKey
                     'cmhead_number', --pNumber
                     'cust_name', --pName
                     'firstline(cmhead_comments)', --pDesc
                     '', --pWidget
                     'join custinfo on cmhead_cust_id = cust_id', --pJoin
                     'cmhead_id', --pParam
                     'creditMemo', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(12, --pDocAssNum
                     'CMI', --pType
                     'CMI', --pDocAss
                     '', --pCharAss
                     'Return Item', --pFull
                     'cmitem', --pTable
                     'cmitem_id', --pKey
                     'cmhead_number', --pNumber
                     'cust_name', --pName
                     'item_number', --pDesc
                     '', --pWidget
                     'join cmhead on cmitem_cmhead_id=cmhead_id join custinfo on cmhead_cust_id=cust_id ' ||
                        'join itemsite on cmitem_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(13, --pDocAssNum
                     'C', --pType
                     'C', --pDocAss
                     'C', --pCharAss
                     'Customer', --pFull
                     'custinfo', --pTable
                     'cust_id', --pKey
                     'cust_number', --pNumber
                     'cust_name', --pName
                     'firstline(cust_comments)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'cust_id', --pParam
                     'customer', --pUi
                     '', --pPriv
                     'Sales',           -- pModule
                     'cust_active'      -- pActive
);
select createDoctype(14, --pDocAssNum
                     'EMP', --pType
                     'EMP', --pDocAss
                     'EMP', --pCharAss
                     'Employee', --pFull
                     'emp', --pTable
                     'emp_id', --pKey
                     'emp_number', --pNumber
                     'cntct_name', --pName
                     'cntct_title', --pDesc
                     'core', --pWidget
                     'left outer join cntct on emp_cntct_id = cntct_id', --pJoin
                     'emp_id', --pParam
                     'employee', --pUi
                     '', --pPriv
                     'System',          -- pModule
                     'emp_active'       -- pActive
);
select createDoctype(15, --pDocAssNum
                     'INCDT', --pType
                     'INCDT', --pDocAss
                     'INCDT', --pCharAss
                     'Incident', --pFull
                     'incdt', --pTable
                     'incdt_id', --pKey
                     'incdt_number::text', --pNumber
                     'incdt_summary', --pName
                     'firstline(incdt_descrip)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'incdt_id', --pParam
                     'incident', --pUi
                     'MaintainPersonalIncidents MaintainAllIncidents', --pPriv
                     'CRM' --pModule
);
select createDoctype(16, --pDocAssNum
                     'INV', --pType
                     'INV', --pDocAss
                     'INV', --pCharAss
                     'Invoice', --pFull
                     'invchead', --pTable
                     'invchead_id', --pKey
                     'invchead_invcnumber', --pNumber
                     'cust_name', --pName
                     'firstline(invchead_notes)', --pDesc
                     'core', --pWidget
                     'join custinfo on invchead_cust_id = cust_id', --pJoin
                     'invchead_id', --pParam
                     'invoice', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(17, --pDocAssNum
                     'INVI', --pType
                     'INVI', --pDocAss
                     'INVI', --pCharAss
                     'Invoice Item', --pFull
                     'invcitem', --pTable
                     'invcitem_id', --pKey
                     'invchead_invcnumber', --pNumber
                     'cust_name', --pName
                     'item_number', --pDesc
                     '', --pWidget
                     'join invchead on invcitem_invchead_id = invchead_id ' ||
                        'join custinfo on invchead_cust_id = cust_id join item on invcitem_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(18, --pDocAssNum
                     'I', --pType
                     'I', --pDocAss
                     'I', --pCharAss
                     'Item', --pFull
                     'item', --pTable
                     'item_id', --pKey
                     'item_number', --pNumber
                     'firstline(item_descrip1)', --pName
                     'firstline(item_descrip2)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'item_id', --pParam
                     'item', --pUi
                     '', --pPriv
                     'Products',        -- pModule
                     'item_active'      -- pActive
);
select createDoctype(19, --pDocAssNum
                     'IS', --pType
                     'IS', --pDocAss
                     '', --pCharAss
                     'Item Site', --pFull
                     'itemsite', --pTable
                     'itemsite_id', --pKey
                     'item_number', --pNumber
                     'warehous_code', --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget
                     'join item on itemsite_item_id = item_id join whsinfo on itemsite_item_id = warehous_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Inventory',       -- pModule
                     'itemsite_active'  -- pActive
);
select createDoctype(20, --pDocAssNum
                     'IR', --pType
                     'IR', --pDocAss
                     '', --pCharAss
                     'Item Source', --pFull
                     'itemsrc', --pTable
                     'itemsrc_id', --pKey
                     'item_number', --pNumber
                     'vend_name', --pName
                     'firstline(item_descrip1)', --pDesc
                     '', --pWidget
                     'join item on itemsrc_item_id = item_id join vendinfo on itemsrc_vend_id = vend_id', --pJoin
                     'itemsrc_id', --pParam
                     'itemSource', --pUi
                     '', --pPriv
                     'Purchase',        -- pModule
                     'itemsrc_active'   -- pActive
);
select createDoctype(21, --pDocAssNum
                     'L', --pType
                     'L', --pDocAss
                     '', --pCharAss
                     'Location', --pFull
                     'location', --pTable
                     'location_id', --pKey
                     'location_formatname', --pNumber
                     'warehous_code', --pName
                     'NULL', --pDesc
                     '', --pWidget
                     'join whsinfo on location_warehous_id = warehous_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Inventory',       -- pModule
                     'location_active'  -- pActive
);
select createDoctype(22, --pDocAssNum
                     'LS', --pType
                     'LS', --pDocAss
                     'LS', --pCharAss
                     'Lot/Serial', --pFull
                     'ls', --pTable
                     'ls_id', --pKey
                     'ls_number', --pNumber
                     'item_number', --pName
                     'firstline(ls_notes)', --pDesc
                     '', --pWidget
                     'join item on ls_item_id = item_id', --pJoin
                     'ls_id', --pParam
                     'lotSerial', --pUi
                     '', --pPriv
                     'Inventory' --pModule
);
select createDoctype(23, --pDocAssNum
                     'OPP', --pType
                     'OPP', --pDocAss
                     'OPP', --pCharAss
                     'Opportunity', --pFull
                     'ophead', --pTable
                     'ophead_id', --pKey
                     'ophead_id::text', --pNumber
                     'ophead_name', --pName
                     'firstline(ophead_notes)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'ophead_id', --pParam
                     'opportunity', --pUi
                     'MaintainPersonalOpportunities MaintainAllOpportunities', --pPriv
                     'CRM',             -- pModule
                     'ophead_active'    -- pActive
);
select createDoctype(24, --pDocAssNum
                     'J', --pType
                     'J', --pDocAss
                     'PROJ', --pCharAss
                     'Project', --pFull
                     'prj', --pTable
                     'prj_id', --pKey
                     'prj_number', --pNumber
                     'prj_name', --pName
                     'firstline(prj_descrip)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'prj_id', --pParam
                     'project', --pUi
                     'MaintainPersonalProjects MaintainAllProjects', --pPriv
                     'CRM' --pModule
);
select createDoctype(25, --pDocAssNum
                     'P', --pType
                     'P', --pDocAss
                     'PO', --pCharAss
                     'Purchase Order', --pFull
                     'pohead', --pTable
                     'pohead_id', --pKey
                     'pohead_number', --pNumber
                     'vend_name', --pName
                     'firstline(pohead_comments)', --pDesc
                     'core', --pWidget
                     'join vendinfo on pohead_vend_id = vend_id', --pJoin
                     'pohead_id', --pParam
                     'purchaseOrder', --pUi
                     '', --pPriv
                     'Purchase' --pModule
);
select createDoctype(26, --pDocAssNum
                     'PI', --pType
                     'PI', --pDocAss
                     'PI', --pCharAss
                     'Purchase Order Item', --pFull
                     'poitem', --pTable
                     'poitem_id', --pKey
                     'pohead_number', --pNumber
                     'vend_name', --pName
                     'item_number', --pDesc
                     '', --pWidget
                     'join pohead on poitem_pohead_id=pohead_id join vendinfo on pohead_vend_id=vend_id ' ||
                        'join itemsite on poitem_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Purchase' --pModule
);
select createDoctype(27, --pDocAssNum
                     'RA', --pType
                     'RA', --pDocAss
                     '', --pCharAss
                     'Return Authorization', --pFull
                     'rahead', --pTable
                     'rahead_id', --pKey
                     'rahead_number', --pNumber
                     'cust_name', --pName
                     'firstline(rahead_notes)', --pDesc
                     '', --pWidget
                     'join custinfo on rahead_cust_id = cust_id', --pJoin
                     'rahead_id', --pParam
                     'returnAuthorization', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(28, --pDocAssNum
                     'RI', --pType
                     'RI', --pDocAss
                     '', --pCharAss
                     'Return Authorization Item', --pFull
                     'raitem', --pTable
                     'raitem_id', --pKey
                     'rahead_number', --pNumber
                     'cust_name', --pName
                     'item_number', --pDesc
                     '', --pWidget
                     'join rahead on raitem_rahead_id=rahead_id join custinfo on rahead_cust_id=cust_id ' ||
                        'join itemsite on raitem_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(29, --pDocAssNum
                     'Q', --pType
                     'Q', --pDocAss
                     'QU', --pCharAss
                     'Quote', --pFull
                     'quhead', --pTable
                     'quhead_id', --pKey
                     'quhead_number', --pNumber
                     'cust_name', --pName
                     'firstline(quhead_ordercomments)', --pDesc
                     '', --pWidget
                     'join custinfo on quhead_cust_id = cust_id', --pJoin
                     'quhead_id', --pParam
                     'salesOrder', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(30, --pDocAssNum
                     'QI', --pType
                     'QI', --pDocAss
                     'QI', --pCharAss
                     'Quote Item', --pFull
                     'quitem', --pTable
                     'quitem_id', --pKey
                     'quhead_number', --pNumber
                     'cust_name', --pName
                     'item_number', --pDesc
                     '', --pWidget
                     'join quhead on quitem_quhead_id=quhead_id join custinfo on quhead_cust_id=cust_id ' ||
                        'join itemsite on quitem_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(31, --pDocAssNum
                     'S', --pType
                     'S', --pDocAss
                     'SO', --pCharAss
                     'Sales Order', --pFull
                     'cohead', --pTable
                     'cohead_id', --pKey
                     'cohead_number', --pNumber
                     'cust_name', --pName
                     'firstline(cohead_ordercomments)', --pDesc
                     'core', --pWidget
                     'join custinfo on cohead_cust_id = cust_id', --pJoin
                     'sohead_id', --pParam
                     'salesOrder', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(32, --pDocAssNum
                     'SI', --pType
                     'SI', --pDocAss
                     'SI', --pCharAss
                     'Sales Order Item', --pFull
                     'coitem', --pTable
                     'coitem_id', --pKey
                     'cohead_number', --pNumber
                     'cust_name', --pName
                     'item_number', --pDesc
                     '', --pWidget
                     'join cohead on coitem_cohead_id=cohead_id join custinfo on cohead_cust_id=cust_id ' ||
                        'join itemsite on coitem_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(33, --pDocAssNum
                     'SHP', --pType
                     'SHP', --pDocAss
                     '', --pCharAss
                     'Ship To', --pFull
                     'shiptoinfo', --pTable
                     'shipto_id', --pKey
                     'shipto_num', --pNumber
                     'cust_name', --pName
                     'shipto_name', --pDesc
                     '', --pWidget
                     'join custinfo on shipto_cust_id=cust_id', --pJoin
                     'shipto_id', --pParam
                     'shipTo', --pUi
                     '', --pPriv
                     'Sales',           --pModule
                     'shipto_active'
);
select createDoctype(34, --pDocAssNum
                     'TE', --pType
                     'TE', --pDocAss
                     '', --pCharAss
                     'Time Expense', --pFull
                     'tehead', --pTable
                     'tehead_id', --pKey
                     'tehead_number', --pNumber
                     'emp_number', --pName
                     'formatDate(tehead_weekending)', --pDesc
                     '', --pWidget
                     'join emp on tehead_emp_id = emp_id', --pJoin
                     'tehead_id', --pParam
                     'timeExpenseSheet', --pUi
                     '', --pPriv
                     'TE' --pModule
);
select createDoctype(35, --pDocAssNum
                     'TD', --pType
                     'TODO', --pDocAss
                     '', --pCharAss
                     'To-Do', --pFull
                     'todoitem', --pTable
                     'todoitem_id', --pKey
                     'todoitem_id::text', --pNumber
                     'todoitem_name', --pName
                     'firstline(todoitem_description)', --pDesc
                     '', --pWidget
                     '', --pJoin
                     'todoitem_id', --pParam
                     'todoItem', --pUi
                     'MaintainPersonalToDoItems MaintainAllToDoItems', --pPriv
                     'CRM',             -- pModule
                     'todoitem_active'  -- pActive
);
select createDoctype(36, --pDocAssNum
                     'TO', --pType
                     'TO', --pDocAss
                     '', --pCharAss
                     'Transfer Order', --pFull
                     'tohead', --pTable
                     'tohead_id', --pKey
                     'tohead_number', --pNumber
                     's.warehous_code', --pName
                     'd.warehous_code', --pDesc
                     '', --pWidget
                     'join whsinfo s on tohead_src_warehous_id = s.warehous_id join whsinfo d on tohead_dest_warehous_id = d.warehous_id', --pJoin
                     'tohead_id', --pParam
                     'transferOrder', --pUi
                     '', --pPriv
                     'Inventory' --pModule
);
select createDoctype(37, --pDocAssNum
                     'TI', --pType
                     'TI', --pDocAss
                     '', --pCharAss
                     'Transfer Order Item', --pFull
                     'toitem', --pTable
                     'toitem_id', --pKey
                     'tohead_number', --pNumber
                     'item_number', --pName
                     'warehous_code', --pDesc
                     '', --pWidget
                     'join tohead on toitem_tohead_id=tohead_id join whsinfo on tohead_dest_warehous_id=warehous_id join item on toitem_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Inventory' --pModule
);
select createDoctype(38, --pDocAssNum
                     'V', --pType
                     'V', --pDocAss
                     'V', --pCharAss
                     'Vendor', --pFull
                     'vendinfo', --pTable
                     'vend_id', --pKey
                     'vend_number', --pNumber
                     'vend_name', --pName
                     'firstline(vend_comments)', --pDesc
                     'core', --pWidget
                     '', --pJoin
                     'vend_id', --pParam
                     'vendor', --pUi
                     '', --pPriv
                     'Purchase',        -- pModule
                     'vend_active'      -- pActive
);
select createDoctype(39, --pDocAssNum
                     'VCH', --pType
                     'VCH', --pDocAss
                     'VCH', --pCharAss
                     'Voucher', --pFull
                     'vohead', --pTable
                     'vohead_id', --pKey
                     'vohead_number', --pNumber
                     'vend_name', --pName
                     'firstline(vohead_notes)', --pDesc
                     '', --pWidget
                     'join vendinfo on vohead_vend_id=vend_id', --pJoin
                     'vohead_id', --pParam
                     '', --pUi
                     '', --pPriv
                     'Purchase' --pModule
);
select createDoctype(40, --pDocAssNum
                     'WH', --pType
                     'WH', --pDocAss
                     '', --pCharAss
                     'Site', --pFull
                     'whsinfo', --pTable
                     'warehous_id', --pKey
                     'warehous_code', --pNumber
                     'warehous_descrip', --pName
                     'NULL', --pDesc
                     '', --pWidget
                     '', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Inventory',       -- pModule
                     'warehous_active'  -- pActive
);
select createDoctype(41, --pDocAssNum
                     'W', --pType
                     'W', --pDocAss
                     'W', --pCharAss
                     'Work Order', --pFull
                     'wo', --pTable
                     'wo_id', --pKey
                     'formatWonumber(wo_id)', --pNumber
                     'item_descrip1', --pName
                     'item_descrip2', --pDesc
                     'core', --pWidget
                     'join itemsite on wo_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Manufacture' --pModule
);
select createDoctype(42, --pDocAssNum
                     'TA', --pType
                     'TASK', --pDocAss
                     'TASK', --pCharAss
                     'Project Task', --pFull
                     'prjtask', --pTable
                     'prjtask_id', --pKey
                     'prjtask_number', --pNumber
                     'prjtask_name', --pName
                     'firstline(prjtask_descrip)', --pDesc
                     '', --pWidget
                     '', --pJoin
                     'prjtask_id', --pParam
                     'task', --pUi
                     '', --pPriv
                     'CRM' --pModule
);
select createDoctype(NULL, --pDocAssNum
                     'PSPCT', --pType
                     'PSPCT', --pDocAss
                     '', --pCharAss
                     'Prospect', --pFull
                     'prospect', --pTable
                     'prospect_id', --pKey
                     'prospect_number', --pNumber
                     'prospect_name', --pName
                     'firstline(prospect_comments)', --pDesc
                     '', --pWidget
                     '', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'CRM',             -- pModule
                     'prospect_active'  -- pActive
);
select createDoctype(NULL, --pDocAssNum
                     'SR', --pType
                     'SR', --pDocAss
                     '', --pCharAss
                     'Sales Rep', --pFull
                     'salesrep', --pTable
                     'salesrep_id', --pKey
                     'salesrep_number', --pNumber
                     'salesrep_name', --pName
                     'NULL', --pDesc
                     '', --pWidget
                     '', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Sales',           -- pModule
                     'salesrep_active'  -- pActive
);
select createDoctype(NULL, --pDocAssNum
                     'TAXAUTH', --pType
                     'TAXAUTH', --pDocAss
                     '', --pCharAss
                     'Tax Authority', --pFull
                     'taxauth', --pTable
                     'taxauth_id', --pKey
                     'taxauth_code', --pNumber
                     'taxauth_name', --pName
                     'taxauth_extref', --pDesc
                     '', --pWidget
                     '', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'Accounting' --pModule
);
select createDoctype(NULL, --pDocAssNum
                     'USR', --pType
                     'USR', --pDocAss
                     '', --pCharAss
                     'User', --pFull
                     'usr', --pTable
                     'usr_id', --pKey
                     'usr_username', --pNumber
                     'usr_propername', --pName
                     'usr_email', --pDesc
                     '', --pWidget
                     '', --pJoin
                     '', --pParam
                     '', --pUi
                     '', --pPriv
                     'System',          -- pModule
                     'usr_active'       -- pActive
);
select createDoctype(NULL, --pDocAssNum
                     'CT', --pType
                     'CT', --pDocAss
                     'CT', --pCharAss
                     'Customer Type', --pFull
                     'custtype', --pTable
                     'custtype_id', --pKey
                     'custtype_code', --pNumber
                     'custtype_code', --pName
                     'custtype_descrip', --pDesc
                     '', --pWidget
                     '', --pJoin
                     'custtype_id', --pParam
                     'customerType', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
select createDoctype(NULL, --pDocAssNum
                     'LSR', --pType
                     'LSR', --pDocAss
                     '', --pCharAss
                     'Lot/Serial Registration', --pFull
                     'lsreg', --pTable
                     'lsreg_id', --pKey
                     'lsreg_number', --pNumber
                     'crmacct_number', --pName
                     'firstline(lsreg_notes)', --pDesc
                     '', --pWidget
                     'left outer join crmacct on lsreg_crmacct_id=crmacct_id', --pJoin
                     'lsreg_id', --pParam
                     'lotSerialRegistration', --pUi
                     '', --pPriv
                     'Sales' --pModule
);

SELECT createDoctype(NULL, --pDocAssNum
                     'PR', --pType
                     '', --pDocAss
                     'PR', --pCharAss
                     'Purchase Request', --pFull
                     'pr', --pTable
                     'pr_id', --pKey
                     'pr_number::text', --pNumber
                     'pr_subnumber::text', --pName
                     'pr_releasenote', --pDesc
                     '', --pWidget
                     '', --pJoin
                     'pr_id', --pParam
                     'purchaseRequest', --pUi
                     'MaintainPurchaseRequests ViewPurchaseRequests', --pPriv
                     'Purchase' --pModule
);

-- Exchange Rate Comment Type & Source
SELECT xt.add_comment_type('System', 'FX', 'Exchange Rates');

SELECT createDoctype(97, --pDocAssNum
                     'RNTI', --pType
                     'RNTI', --pDocAss
                     'RNTI', --pCharAss
                     'Rental Item', --pFull
                     'rentline', --pTable
                     'rentline_id', --pKey
                     'rentline_linenumber', --pNumber
                     'item_number', --pName
                     'item_descrip1', --pDesc
                     '', --pWidget
                     'join cohead on rentline_cohead_id=cohead_id join itemsite on coitem_itemsite_id=itemsite_id join item on itemsite_item_id=item_id', --pJoin
                     'rentine_id', --pParam
                     'rentalItem', --pUi
                     '', --pPriv
                     'Sales' --pModule
);
