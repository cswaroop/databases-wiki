
select xt.add_column('itemsite', 'itemsite_created',      'TIMESTAMP WITH TIME ZONE', NULL, 'public');
select xt.add_column('itemsite', 'itemsite_lastupdated',  'TIMESTAMP WITH TIME ZONE', NULL, 'public');

-- incident 23507:change how qoh, qoh available, and qoh netable are determined
do $$
begin
if (compareVersion(fetchMetricText('ServerVersion'), '4.7.0') = -1) then
  update itemsite set itemsite_qtyonhand=(itemsite_qtyonhand + itemsite_nnqoh);
  alter table itemsite drop column itemsite_nnqoh cascade;
end if;
end$$;
