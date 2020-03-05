DROP TYPE IF EXISTS _targetdoc CASCADE;
CREATE TYPE _targetdoc AS (target_docass_id INTEGER,
                           target_source_id INTEGER,
                           target_doc_number TEXT,
                           target_doc_name TEXT,
                           target_doc_descrip TEXT);
