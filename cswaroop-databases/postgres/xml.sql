DO $$
   DECLARE myxml xml;
BEGIN
myxml := XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('MyData.xml'), 'UTF8'));

DROP TABLE IF EXISTS mytable;
CREATE TEMP TABLE mytable AS

SELECT
     (xpath('//ID/text()', x))[1]::text AS id
    ,(xpath('//Name/text()', x))[1]::text AS Name
    ,(xpath('//RFC/text()', x))[1]::text AS RFC
    ,(xpath('//Text/text()', x))[1]::text AS Text
    ,(xpath('//Desc/text()', x))[1]::text AS Desc
FROM unnest(xpath('//record', myxml)) x
;
END$$;

SELECT * FROM mytable;


SELECT
     (xpath('//ID/text()', myTempTable.myXmlColumn))[1]::text AS id
    ,(xpath('//Name/text()', myTempTable.myXmlColumn))[1]::text AS Name
    ,(xpath('//RFC/text()', myTempTable.myXmlColumn))[1]::text AS RFC
    ,(xpath('//Text/text()', myTempTable.myXmlColumn))[1]::text AS Text
    ,(xpath('//Desc/text()', myTempTable.myXmlColumn))[1]::text AS Desc
    ,myTempTable.myXmlColumn as myXmlElement
FROM unnest(
     xpath
     (    '//record'
         ,XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('MyData.xml'), 'UTF8'))
     )
) AS myTempTable(myXmlColumn)
;


SELECT 
     (xpath('//ID/text()', myTempTable.myXmlColumn))[1]::text AS id
    ,(xpath('//Name/text()', myTempTable.myXmlColumn))[1]::text AS Name 
    ,(xpath('//RFC/text()', myTempTable.myXmlColumn))[1]::text AS RFC
    ,(xpath('//Text/text()', myTempTable.myXmlColumn))[1]::text AS Text
    ,(xpath('//Desc/text()', myTempTable.myXmlColumn))[1]::text AS Desc
    ,myTempTable.myXmlColumn as myXmlElement
FROM unnest(xpath('//record', 
 CAST(
'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<data-set>
    <record>
        <ID>1</ID>
        <Name>A</Name>
        <RFC>RFC 1035[1]</RFC>
        <Text>Address record</Text>
        <Desc>Returns a 32-bit IPv4 address, most commonly used to map hostnames to an IP address of the host, but it is also used for DNSBLs, storing subnet masks in RFC 1101, etc.</Desc>
    </record>
    <record>
        <ID>2</ID>
        <Name>NS</Name>
        <RFC>RFC 1035[1]</RFC>
        <Text>Name server record</Text>
        <Desc>Delegates a DNS zone to use the given authoritative name servers</Desc>
    </record>
</data-set>
' AS xml)   
)) AS myTempTable(myXmlColumn)
;

CREATE OR REPLACE FUNCTION xml_pretty(xml)
RETURNS xml AS $$
SELECT xslt_process($1,
'<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:strip-space elements="*" />
<xsl:output method="xml" indent="yes" />
<xsl:template match="node() | @*">
<xsl:copy>
<xsl:apply-templates select="node() | @*" />
</xsl:copy>
</xsl:template>
</xsl:stylesheet>')::xml
$$ language sql immutable strict;

select xml_pretty('<root><a><b>some text</b></a></root>');

\echo How to unnest an array with element indexes

CREATE OR REPLACE FUNCTION unnest_rownum(anyarray)
RETURNS TABLE (id int, element anyelement) AS $$
BEGIN
  id := 1;
  FOREACH element IN array $1
  LOOP
    RETURN NEXT;
    id := id + 1;
  END LOOP;
  RETURN;
END
$$ LANGUAGE plpgsql; 

select * from unnest_rownum(ARRAY['A','B','C']);

SELECT i, arraycol[i]
FROM tab,
     LATERAL generate_subscripts(arraycol, 1) as i;

SELECT * FROM unnest(ARRAY['A','D','C']) WITH ORDINALITY;

\echo Bytea to BLOB conversion

CREATE OR REPLACE FUNCTION make_lo(bytea)
RETURNS oid AS $$
DECLARE
  loid oid;
  fd integer;
  bytes integer;
BEGIN
  loid := lo_creat(-1);
  fd := lo_open(loid, 131072);
  bytes := lowrite(fd, $1);
  IF (bytes != LENGTH($1)) THEN
    RAISE EXCEPTION 'Not all data copied to blob';
  END IF;
  PERFORM lo_close(fd);
  RETURN loid;
END;
$$ LANGUAGE plpgsql STRICT;

\echo Read a file as superuser

CREATE TABLE xml_data(result xml);

CREATE OR REPLACE FUNCTION f_sync_from_xml()
  RETURNS boolean AS
$BODY$
DECLARE
    myxml    xml;
    datafile text := 'path/to/my_file.xml';
BEGIN

myxml := pg_read_file(datafile, 0, 100000000);  -- arbitrary 100 MB max.

CREATE TEMP TABLE tmp AS
SELECT (xpath('//some_id/text()', x))[1]::text AS id
FROM   unnest(xpath('/xml/path/to/datum', myxml)) x;