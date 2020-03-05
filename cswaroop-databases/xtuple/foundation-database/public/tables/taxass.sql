select xt.add_column('taxass','taxass_reverse_tax', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');
select xt.add_column('taxass','taxass_memo_apply', 'BOOLEAN', 'NOT NULL DEFAULT FALSE', 'public');

COMMENT ON COLUMN taxass.taxass_reverse_tax    IS 'Tax Assignment Reverse Charge Tax applicable';
COMMENT ON COLUMN taxass.taxass_memo_apply     IS 'Tax Assignment Automatically apply to AR/AP memos';

