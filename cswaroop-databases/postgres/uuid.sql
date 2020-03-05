CREATE EXTENSION "uuid-ossp";


CREATE TABLE orders
(
	sequence_id UUID PRIMARY KEY DEFAULT uuid_generate_v1mc(), -- time sequenced, slight chance of collision
	randon_id UUID DEFAULT uuid_generate_v4() -- random, less chance of collision 
	
)
;


CREATE EXTENSION pgcrypto;  

CREATE TABLE snw.contacts(  
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   name TEXT,
   email TEXT
);

