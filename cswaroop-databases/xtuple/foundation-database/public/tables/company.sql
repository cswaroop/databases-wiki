/* Add Unassigned G/L Account to Company table */
SELECT xt.add_column('company', 'company_unassigned_accnt_id', 'INTEGER', '', 'public', '');
