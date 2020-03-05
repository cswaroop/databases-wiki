CREATE TABLE jira (
         id char(40) NOT NULL PRIMARY KEY
       , jira_type text
       , jira_org_id text
       , country_code text
       , version_number integer
       , dfe_status text
       , dealer_id text
       , sales_person text
       , assigned_sales_person text
       , is_missing_docs_attached boolean
       , is_withdrawal_request boolean
 );
 
