DELETE FROM xt.wftype WHERE wftype_tblname = 'sowf';

INSERT INTO xt.wftype (wftype_tblname, wftype_code, wftype_src_tblname) 
VALUES ('sowf', 'SO', 'saletypewf');
