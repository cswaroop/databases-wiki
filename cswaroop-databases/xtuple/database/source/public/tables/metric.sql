select setmetric('MobileWelcomePage', 'https://www.xtuple.com/welcome');
select setmetric('CCValidDays', '7');
select setmetric('TriggerWorkflow', 'f') where (select fetchmetricbool('TriggerWorkflow') != true);
