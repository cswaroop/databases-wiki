do $$
begin
if (NOT EXISTS(SELECT taxauth_id FROM taxauth WHERE taxauth_code='1099')) then

INSERT INTO taxauth (taxauth_code, taxauth_name)
             VALUES ('1099', 'Used for 1099 reporting');

end if;
end$$;