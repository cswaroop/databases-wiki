

-- Universal model?
CREATE TABLE entity_type (
  name text PRIMARY KEY,
  data jsonb
);

CREATE TABLE rltp_type (
  name text PRIMARY KEY,
  name text -- master-detail, parent-child
);

CREATE TABLE entity (
  id SERIAL PRIMARY KEY,
  uid varchar(255),
  entity_type int,
  name text,
  updated_at timestamptz,
  data jsonb
);

CREATE TABLE entity_rltp (
  id SERIAL PRIMARY KEY,
  uid varchar(255),
  rltp_type int,
  updated_at timestamptz,
  from_entity_id int,
  target_entity_Id int,
  data jsonb
);


-- Domain models :: Administration entities Users, Groups, Roles

INSERT INTO entity_type ('user', NULL);
INSERT INTO entity_type ('group', NULL);
INSERT INTO entity_type ('role', NULL); -- permissions
INSERT INTO rltp_type ('user_group', NULL);
INSERT INTO rltp_type ('group_role', NULL);

-- Sample Data

INSERT INTO entity(DEFAULT, DEFAULT, 'user', 'admin@example.com', NOW(), $${ "userid": "user-1"}$$);
INSERT INTO entity(DEFAULT, DEFAULT, 'group', 'AdministratorGroup', NOW(), $${ "groupid": "group-1", "isadmin": true}$$);
INSERT INTO entity(DEFAULT, DEFAULT, 'group', 'AuthenticatedUserGroup', NOW(), $${ "groupid": "group-1"}$$);
INSERT INTO entity(DEFAULT, DEFAULT, 'role', 'AdministratorRole', NOW(), $${ "roleid": "role-1"}$$);
INSERT INTO entity(DEFAULT, DEFAULT, 'role', 'AuthenticatedUserRole', NOW(), $${ "roleid": "role-1"}$$);

INSERT INTO entity_rltp(DEFAULT, DEFAULT, 'user_group', 'user1_group1@example.com', NOW(), 'user', 'group', $${ "groupid": "group-1"}$$);





		   
