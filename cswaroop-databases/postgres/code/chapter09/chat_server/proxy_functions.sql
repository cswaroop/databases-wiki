CREATE OR REPLACE FUNCTION login(
    IN i_username text, IN i_pwdhash text,
    OUT status int, OUT message text ) 
AS $$
    CONNECT 'dbname=chap9 host=10.10.10.1';
$$ LANGUAGE plproxy SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.get_user_email(i_username text) RETURNS SETOF text AS $$
    CLUSTER 'messaging';
    RUN ON hashtext(i_username);
    TARGET local.get_user_email;
$$ LANGUAGE plproxy SECURITY DEFINER;

CREATE or REPLACE FUNCTION create_new_users(
    IN i_username text[], IN i_pwdhash text[], IN i_email text[],
    OUT status int, OUT message text )  RETURNS SETOF RECORD
AS $$
  CLUSTER 'messaging';
  RUN ON hashtext(i_username);
  SPLIT  i_username,  i_pwdhash,  i_email;
$$ LANGUAGE plproxy SECURITY DEFINER;

CREATE OR REPLACE FUNCTION plproxy.get_cluster_partitions(cluster_name text) 
RETURNS SETOF text AS $$ 
BEGIN 
    IF cluster_name = 'messaging' THEN 
        RETURN NEXT 'dbname=p0'; 
        RETURN NEXT 'dbname=p1'; 
        RETURN NEXT 'dbname=p2'; 
        RETURN NEXT 'dbname=p3'; 
    ELSE
        RAISE EXCEPTION 'Unknown cluster'; 
    END IF; 
END; 
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION plproxy.get_cluster_version(cluster_name text) 
RETURNS int4 AS $$ 
BEGIN 
    IF cluster_name = 'messaging' THEN 
        RETURN 1; 
    ELSE
        RAISE EXCEPTION 'Unknown cluster'; 
    END IF; 
END; 
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION plproxy.get_cluster_config( 
    in cluster_name text, 
    out key text, 
    out val text) 
RETURNS SETOF record AS $$ 
BEGIN 
    -- lets use same config for all clusters 
    key := 'connection_lifetime'; 
    val := 10*60; 
    RETURN NEXT; 
    RETURN; 
END; 
$$ LANGUAGE plpgsql; 


