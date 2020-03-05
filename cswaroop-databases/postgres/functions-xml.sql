--

\echo xmlagg()

CREATE TABLE test (id int, x xml);
INSERT INTO test VALUES (1, '<foo>abc</foo>');
INSERT INTO test VALUES (2, '<bar/>');
SELECT xmlagg(x) FROM test;
SELECT xmlagg(x ORDER BY id DESC) FROM test;
SELECT xmlagg(x ORDER BY id DESC) FROM test;
SELECT xmlagg(x) FROM (SELECT * FROM test ORDER BY id DESC) AS tab;

\echo xmlexists()

SELECT xmlexists('//town[text() = ''Toronto'']' PASSING BY REF '<towns><town>Toronto</town><town>Ottawa</town></towns>');


\echo xpath_exists()
SELECT xpath_exists('/my:a/text()', '<my:a xmlns:my="http://example.com">test</my:a>',
                     ARRAY[ARRAY['my', 'http://example.com']]);

\echo xpath()

SELECT xpath('/my:a/text()', '<my:a xmlns:my="http://example.com">test</my:a>',
             ARRAY[ARRAY['my', 'http://example.com']]);

SELECT xpath('//mydefns:b/text()', '<a xmlns="http://example.com"><b>test</b></a>',
             ARRAY[ARRAY['mydefns', 'http://example.com']]);

\echo mapping Tables to XML

table_to_xml(tbl regclass, nulls boolean, tableforest boolean, targetns text)
query_to_xml(query text, nulls boolean, tableforest boolean, targetns text)
cursor_to_xml(cursor refcursor, count int, nulls boolean,
              tableforest boolean, targetns text)
	      
schema_to_xml(schema name, nulls boolean, tableforest boolean, targetns text)
schema_to_xmlschema(schema name, nulls boolean, tableforest boolean, targetns text)
schema_to_xml_and_xmlschema(schema name, nulls boolean, tableforest boolean, targetns text)

database_to_xml(nulls boolean, tableforest boolean, targetns text)
database_to_xmlschema(nulls boolean, tableforest boolean, targetns text)
database_to_xml_and_xmlschema(nulls boolean, tableforest boolean, targetns text)


\echo XML data type

XMLPARSE ( DOCUMENT|CONTENT value ) --> xml
XMLSERIALIZE ( DOCUMENT|CONTENT xmlvalue AS varchar ) --> varchar

\echo XML support functions

xmlcomment
xmlconcat
xmlelement
xmlforest
xmlpi
xmlroot
xmlagg
IS DOCUMENT, IS NOT DOCUMENT

XMLROOT (
  XMLELEMENT (
    NAME gazonk,
    XMLATTRIBUTES (
      ’val’ AS name,
      1 + 1 AS num
    ),
    XMLELEMENT (
      NAME qux,
      ’foo’
    )
  ),
  VERSION ’1.0’,
  STANDALONE YES
)

SELECT xmlforest (
  "FirstName" as "FName",
  "LastName" as "LName",
  ’string’ as "str",
  "Title",
  "Region" )
FROM emp;


SELECT xmlelement (’Emp’,
   xmlattributes (’Sales Representative’ as "Title"),
   xmlagg (xmlelement (’Name’, "FirstName", ’ ’, "LastName")))
FROM emp
WHERE "Title" = ’Sales Representative’;



