CREATE TABLE user_info (
     username text primary key,
     pwdhash text not null,  -- base64 encoded md5 hash of password
     email text,
     friend_list text[], -- list of buddies usernames
     friends_only boolean not null default false
);

CREATE TABLE message (
    from_user text not null references user_info(username),
    sent_at timestamp not null default current_timestamp, 
    to_user text not null references user_info(username),
    read_at timestamp, -- when was this retrieved by to_user
    msg_body text not null,
    delivery_status text not null default 'outgoing' --  ('sent', “failed”)
)

