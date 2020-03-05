#!/usr/bin/env python

# almost exactly the sample SocketServer.UDPServer Example from
# http://docs.python.org/library/socketserver.html with minor modifications -
# the "send data back" part is omitted and missing 0 added to format string

# just run ./udp_log_listener.py from commandline and watch as log is printed 

import SocketServer

class UDPLogHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        data = self.request[0].strip()
        print "{0} logged:".format(self.client_address[0])
        print data

if __name__ == "__main__":
    HOST, PORT = "localhost", 9999
    server = SocketServer.UDPServer((HOST, PORT), UDPLogHandler)
    server.serve_forever()