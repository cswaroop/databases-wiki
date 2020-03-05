DELETE FROM xt.wftype WHERE wftype_tblname = 'prjwf';

INSERT INTO xt.wftype (wftype_tblname, wftype_code, wftype_src_tblname) 
VALUES ('prjwf', 'PRJ', 'prjtypewf');
