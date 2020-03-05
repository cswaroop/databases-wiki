CREATE or REPLACE FUNCTION new_user(
    IN i_username text, IN i_pwdhash text, IN i_email text,
    OUT status int, OUT message text ) 
AS $$
BEGIN
    INSERT INTO user_info( username, pwdhash, email)
                VALUES ( i_username, i_pwdhash, i_email);
    status = 200;
    message = 'OK';
EXCEPTION WHEN unique_violation THEN 
    status = 500;
    message = 'USER EXISTS';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION login(
    IN i_username text, IN i_pwdhash text,
    OUT status int, OUT message text ) 
AS $$
BEGIN
    PERFORM 1 FROM user_info 
    WHERE ( username, pwdhash) = ( i_username, i_pwdhash);
    IF NOT FOUND THEN
        status = 500;
        message = 'NOT FOUND';
    END IF;
    PERFORM 1 FROM  message
    WHERE  to_user =  i_username
      AND  read_at IS NULL;
    IF FOUND THEN
        status = 201;
        message = 'OK. NEW MESSAGES';
    ELSE
        status = 200;
        message = 'OK. NO MESSAGES';
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; 

CREATE or REPLACE FUNCTION set_friends_list(
    IN i_username text, IN i_friends_list text[], 
    OUT status int, OUT message text ) 
AS $$
BEGIN
    UPDATE user_info 
       SET  friend_list =  i_friends_list
    WHERE  username =  i_username;
    status = 200;
    message = 'OK';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE or REPLACE FUNCTION msg_from_friends_only(
IN i_username text, IN i_friends_only boolean,
    OUT status int, OUT message text ) 
AS $$
BEGIN
    UPDATE user_info SET  friends_only =   i_friends_only
    WHERE  username =  i_username;
    status = 200;
    message = 'OK';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE or REPLACE FUNCTION send_message(
    IN i_from_user text, IN i_to_user text, IN i_message text, 
    OUT status int, OUT message text ) 
AS $$
BEGIN
    PERFORM 1 FROM  user_info
    WHERE  username = i_to_user
      AND (NOT friends_only OR friend_list @> ARRAY[i_from_user]);
    IF NOT FOUND THEN
        status = 400;
        message = 'SENDING FAILED';
        RETURN;
    END IF;
    INSERT INTO message(from_user, to_user, msg_body, delivery_status)
    VALUES (i_from_user, i_to_user, i_message, 'sent');
    status = 200;
    message = 'OK';
EXCEPTION
    WHEN foreign_key_violation THEN
        status = 500;
        message = 'FAILED';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE or REPLACE FUNCTION get_new_messages(
    IN i_username text,
    OUT o_status int, OUT o_message_text text, 
    OUT o_from_user text, OUT o_sent_at timestamp)
RETURNS SETOF RECORD
AS $$
BEGIN
    FOR o_status,  o_message_text, o_from_user,  o_sent_at IN
        UPDATE message 
        SET read_at = CURRENT_TIMESTAMP,
            delivery_status = 'read'
        WHERE to_user =  i_username AND read_at IS NULL
        RETURNING 200, msg_body, from_user , sent_at
    LOOP
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


