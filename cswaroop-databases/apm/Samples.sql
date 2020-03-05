SET search_path=junk,public;

-- Some samples of Postgres XML capabilities

SELECT xmlcomment('hello');
SELECT xmlconcat('<abc/>', '<bar>foo</bar>');
SELECT xmlconcat('<abc/>', '<bar>foo</bar>', '<blah>Blah</blah>');

SELECT xmlelement(name foo);

SELECT xmlelement(name foo, xmlattributes('xyz' as bar));

SELECT xmlelement(name foo, xmlattributes(current_date as bar), 'cont', 'ent');

SELECT xmlforest('abc' AS foo, 123 AS bar);

SELECT xmlroot(xmlparse(document '<?xml version="1.1"?><content>abc</content>'),
               version '1.0', standalone yes);

select xmlagg (code::xml) from nationality;

SELECT xmlagg(code::xml ORDER BY code DESC) FROM nationality;

SELECT xmlexists('//town[text() = ''Toronto'']' PASSING BY REF '<towns><town>Toronto</town><town>Ottawa</town></towns>');

SELECT xpath('/my:a/text()', 
		     '<my:a xmlns:my="http://example.com">test</my:a>',
             ARRAY[ARRAY['my', 'http://example.com']]
             );

SELECT xpath('//mydefns:b/text()', 
			 '<a xmlns="http://example.com"><b>test</b></a>',
             ARRAY[ARRAY['mydefns', 'http://example.com']]
             );

SELECT xpath_exists('/my:a/text()', 
				    '<my:a xmlns:my="http://example.com">test</my:a>',
                     ARRAY[ARRAY['my', 'http://example.com']]
                   );

select query_to_xml('select * from nationality', true, false, '');
select table_to_xml('nationality', true, false, '');
select schema_to_xml('junk', true, false,'');
select schema_to_xml_and_xmlschema('junk', true, false, '');
select database_to_xml(true, false, '');
select database_to_xml_and_xmlschema(true, false, '')
