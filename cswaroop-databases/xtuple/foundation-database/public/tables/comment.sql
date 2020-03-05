DROP INDEX IF EXISTS comment_date_idx;
CREATE INDEX comment_date_idx ON comment USING btree (comment_date );

DROP INDEX IF EXISTS comment_source_id_idx;
CREATE INDEX comment_source_id_idx ON comment USING btree (comment_source_id );

DROP INDEX IF EXISTS comment_user_idx;
CREATE INDEX comment_user_idx ON comment USING btree (comment_user COLLATE pg_catalog."default" );
