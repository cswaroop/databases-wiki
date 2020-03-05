\echo "create tables"

DROP TABLE IF EXISTS emp;
CREATE TABLE emp (doc xml);

\echo "insert data"

INSERT INTO emp(doc) VALUES (xml
$$
<dept bldg="101">
  <employee id="901">
    <name>
      <first>John</first>
      <last>Doe</last>
    </name>
    <office>344</office>
    <salary currency="USD">55000</salary>
  </employee>
  <employee id="902">
    <name>
      <first>Peter</first>
      <last>Pan</last>
    </name>
    <office>216</office>
    <phone>905-416-5004</phone>
  </employee>
</dept>
$$);

INSERT INTO emp(doc) VALUES (xml
$$
<dept bldg="114">
  <employee id="903">
      <name>
          <first>Mary</first>
          <last>Jones</last>
      </name>
      <office>415</office>
            <phone>905-403-6112</phone>
            <phone>647-504-4546</phone>
      <salary currency="USD">64000</salary>
 </employee>
</dept>
$$);					

/*
SELECT	warehouse_name warehouse,
        warehouse2."Water",
	warehouse2."Rail"
FROM warehouses,
     XMLTABLE('/Warehouse' PASSING warehouses.warehouse_spec
	       COLUMNS
		"Water" varchar2(6) PATH '/Warehouse/WaterAccess',
		"Rail" varchar2(6) PATH '/Warehouse/RailAccess') warehouse2;

*/

\echo "return one all phone numbers as xml"
SELECT X.*
  FROM emp,
       XMLTABLE ('/dept/employee' PASSING doc	
                 COLUMNS
                   firstname VARCHAR(20)  PATH 'name/first',
                   lastname  VARCHAR(25)  PATH 'name/last',
                   phone     xml  PATH 'phone') AS X;

\echo "return phone numbers one by one"
SELECT X.*
  FROM emp,
       XMLTABLE ('/dept/employee' PASSING doc	
                 COLUMNS
                   firstname VARCHAR(20)  PATH 'name/first',
                   lastname  VARCHAR(25)  PATH 'name/last',
                   phone     VARCHAR(12)  PATH 'phone[1]') AS X;

\echo Handling non-existentt path values

SELECT X.*
FROM emp,
         XMLTABLE ('/dept/employee/phone' PASSING doc
	           COLUMNS
		     firstname VARCHAR(20)  PATH '../name/first',
		     lastname  VARCHAR(25)  PATH '../name/last',
		     phone     VARCHAR(12)  PATH '.') AS X
UNION

SELECT Y.*, CAST(NULL AS VARCHAR(12))
FROM emp,
     XMLTABLE ('/dept/employee[not(phone)]' PASSING doc
              COLUMNS
                  firstname VARCHAR(20)  PATH 'name/first',
                  lastname  VARCHAR(25)  PATH 'name/last') AS Y;

INSERT INTO emp(doc) VALUES (xml
$$
<ibm:dept bldg="123" xmlns:ibm="http://www.ibm.com/xmltable">
  <ibm:employee id="144">
      <ibm:name>
            <ibm:first>James</ibm:first>
	          <ibm:last>Bond</ibm:last>
		      </ibm:name>
		          <ibm:office>007</ibm:office>
			      <ibm:phone>905-007-1007</ibm:phone>
			          <ibm:salary currency="USD">77007</ibm:salary>
				    </ibm:employee>
				    </ibm:dept>
$$);

\echo handling default namespace

SELECT X.*
FROM emp,
     XMLTABLE (XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmltable'),
              '/dept/employee' PASSING doc
              COLUMNS
                     empID     INTEGER     PATH '@id',
                     firstname VARCHAR(20) PATH 'name/first',
                     lastname  VARCHAR(25) PATH 'name/last') AS X;


\echo handling namespaces

SELECT X.*
FROM emp,
     XMLTABLE (XMLNAMESPACES('http://www.ibm.com/xmltable' AS ibm),
              '/ibm:dept/ibm:employee' PASSING doc
              COLUMNS
                     empID     INTEGER     PATH '@id',
                     firstname VARCHAR(20) PATH 'ibm:name/ibm:first',
                     lastname  VARCHAR(25) PATH 'ibm:name/ibm:last') AS X;

\echo Generating ordinal number

SELECT X.*
  FROM emp,
       XMLTABLE ('/dept/employee' PASSING doc
                 COLUMNS
                      seqno     FOR ORDINALITY,
                      empID     INTEGER     PATH '@id',
                      firstname VARCHAR(20) PATH 'name/first',
                      lastname  VARCHAR(25) PATH 'name/last') AS X
