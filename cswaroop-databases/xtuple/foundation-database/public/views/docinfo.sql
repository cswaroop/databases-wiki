DROP VIEW IF EXISTS docinfo;
CREATE OR REPLACE VIEW docinfo AS
    SELECT (_docinfo).id,
           (_docinfo).target_number,
           (_docinfo).target_type,
           (_docinfo).target_id,
           (_docinfo).source_type,
           (_docinfo).source_id,
           (_docinfo).name,
           (_docinfo).description,
           (_docinfo).purpose
      FROM (SELECT DISTINCT _docinfo(id, type)
              FROM (
                  SELECT docass_source_id AS id,   docass_source_type AS type
                    FROM docass
                  UNION
                  SELECT docass_target_id AS id,   docass_target_type AS type
                    FROM docass
                  UNION
                  SELECT imageass_source_id AS id, imageass_source AS type
                    FROM imageass
                  UNION
                  SELECT url_source_id AS id,      url_source AS type
                    FROM url
                  ) inner_docinfo
           ) outer_docinfo;

