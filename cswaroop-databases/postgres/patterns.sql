-- some sql patterns to represent common modelling challenges

-- Users, Roles, Groups, Permissions, Organizations, Tenants  OMG..

-- Party, Roles

-- Cases,Workflows, statues



-- History, Audit tracking

-- Enumerations


-- Denormalized auto-populating table for an entity

-- Asynchronous notification outside db

-- make a registration:

LISTEN virtual;
NOTIFY virtual;

--Asynchronous notification "virtual" received from server process with PID 8448.
-- Once UNLISTEN has been executed, further NOTIFY messages will be ignored:

UNLISTEN virtual;
NOTIFY virtual;
-- no NOTIFY event is received
