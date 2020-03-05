CREATE OR REPLACE FUNCTION log_trigger()
RETURNS TRIGGER AS $$
    args = tuple(TD["args"])
    if not SD.has_key(args):
        protocol = args[0]
        if protocol == 'udp':
            import socket
            sock = socket.socket( socket.AF_INET,
                                  socket.SOCK_DGRAM )
            def logfunc(msg, addr=args[1],
                             port=int(args[2]), sock=sock):
                sock.sendto(msg, (addr, port))
        elif protocol == 'file':
            f = open(args[1], 'a+')
            def logfunc(msg,f=f):
                f.write(msg+'\n')
                f.flush()
        else:
            raise ValueError, 'bad logdest in CREATE TRIGGER'
        SD[args] = logfunc
        SD['env_plan'] = plpy.prepare("""
             select clock_timestamp(),
                    txid_current(),
                    current_user,
                    current_database()""", [])
    logfunc = SD[args]
    env_info_row = plpy.execute(SD['env_plan'])[0]
    import json
    log_msg = json.dumps(
        {'txid' : env_info_row['txid_current'],
         'time' : env_info_row['clock_timestamp'],
         'user' : env_info_row['current_user'],
         'db'   : env_info_row['current_database'],
         'table' : '%s.%s' % (TD['table_name'],
                              TD['table_schema']),
         'event' : TD['event'],
         'old' : TD['old'],
         'new' : TD['new'],
        }
    )
    logfunc(log_msg)
$$ LANGUAGE plpythonu;

CREATE TRIGGER test_audit_trigger
 AFTER INSERT OR UPDATE OR DELETE ON test
   FOR EACH ROW
EXECUTE PROCEDURE log_trigger('file', '/tmp/test.json.log');

CREATE TRIGGER test_audit_trigger_udp
 AFTER INSERT OR UPDATE OR DELETE ON test
   FOR EACH ROW
EXECUTE PROCEDURE log_trigger('udp', 'localhost', 9999);

