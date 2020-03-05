do $$
declare
  _b    boolean;
  _i    integer := 1;
  _ins  text;
  _pair text[] = array[ /* should be 2D array */
    'C',       'char_customers',
    'CT',      'char_customers',
    'I',       'char_items',
    'CNTCT',   'char_contacts',
    'ADDR',    'char_addresses',
    'CRMACCT', 'char_crmaccounts',
    'LS',      'char_lotserial',
    'LSR',     'char_lotserial',
    'OPP',     'char_opportunity',
    'EMP',     'char_employees',
    'INCDT',   'char_incidents',
    'PROJ',    'char_projects',
    'TASK',    'char_tasks',
    'QU',      'char_quotes',
    'SO',      'char_salesorders',
    'INV',     'char_invoices',
    'V',       'char_vendors',
    'PO',      'char_purchaseorders',
    'VCH',     'char_vouchers'
  ];

  begin
    /* bug 26266 - must precede the for loop { */
    update public.charuse
       set charuse_target_type = 'CRMACCT'
     where charuse_target_type = 'CRMA';

    for _i in 1..array_length(_pair, 1) by 2 loop
      _ins := format($f$insert into public.charuse (
                         charuse_char_id, charuse_target_type
                       ) select char_id, '%s' from "char"
                          where %I
                            and not exists(select 1 from charuse
                                            where charuse_char_id = char_id
                                              and charuse_target_type = '%s');$f$,
                     _pair[_i], _pair[_i + 1], _pair[_i]);
      execute _ins;
    end loop;
  end
$$ language plpgsql;

