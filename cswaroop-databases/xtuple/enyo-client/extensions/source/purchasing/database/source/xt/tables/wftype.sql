DELETE FROM xt.wftype WHERE wftype_tblname = 'powf';

INSERT INTO xt.wftype (wftype_tblname, wftype_code, wftype_src_tblname) 
VALUES ('powf', 'PO', 'potypewf');
