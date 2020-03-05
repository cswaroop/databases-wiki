CREATE TABLE user_base
(
	id text,
	username text,
	password_hash text
);

CREATE TABLE group_base
(
	group_id text,
	group_name text
);


CREATE TABLE project 
(
	id text,
	pname text,
	url text,
	lead text,
	description text,
	pkey text,
	pcounter int,
	assignee_type_id text,
	avatar_id text,
	original_key text,
	project_type_id text
);

CREATE TABLE project_category
(
	id text,
	cname text,
	description text
);

CREATE TABLE project_role
(
	id text,
	name text,
	description text
);

CREATE TABLE project_role_actor
(
	id text,
	pid text,
	project_role_id text,
	role_type_id text,
	role_type_parameter text
);

CREATE TABLE workflow_scheme
(
	id text,
	name text,
	description text
);

CREATE TABLE workflow_scheme_entity
(
	id text,
	scheme_id text,
	workflow_id text,
	issue_type_id text
);


CREATE TABLE issue 
(
	id text,
	pkey text,
	issue_num int,
	project_id text,
	reporter_id text,
	assignee_id text,
	creator_id text,
	issue_type_id text,
	summary text,
	description text,
	environment text,
	priority text,
	resolution text,
	issue_status_id text,
	created timestamptz,
	updated timestamptz,
	due_date timestamptz,
	resolution_date timestamptz,
	votes int,
	workflow_id text,
	component_id text,
	security_id text
);

CREATE TABLE issue_type 
(
	id text,
	sequence int,
	pname text,
	pstyle text,
	description text,
	icon_url text,
	avatar_id text
);

CREATE TABLE issue_status
(
	id text,
	sequence int,
	pname text,
	description text,
	icon_url text,
	status_category_id text
);

CREATE TABLE issue_type_screen_scheme
(
	id text,
	name text,
	description text
);

CREATE TABLE issue_type_screen_scheme_entity
(
	id text,
	issue_type_id text,
	issue_type_screen_scheme_id text,
	field_screen_scheme_id text
);

CREATE TABLE issue_action
(
	id text,
	issue_id text,
	author text,
	action_type text,
	action_level text,
	role_level text,
	action_body text,
	created timestamptz,
	updated timestamptz,
	updated_author text,
	action_num int
);

CREATE TABLE issue_event_type
(
	id text,
	template_id text,
	name text,
	description text,
	event_type text
);

CREATE TABLE permissions
(
	id text,
	permission_type text,
	project_id text,
	group_name text
);

CREATE TABLE permission_scheme
(
	id text,
	name text,
	description text
);


CREATE TABLE workflows
(
	id text,
	workflow_name text,
	creator_name text,
	descriptor text,
	is_locked boolean
);


CREATE TABLE workflow_statuses
(
	id text,
	status text,
	parent_name text
);


CREATE TABLE board
(
	id text,
	jql text
);

CREATE TABLE board_project 
(
	board_id text,
	project_id text
);





