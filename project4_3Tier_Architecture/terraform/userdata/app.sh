#!/bin/bash

yum update -y

yum install -y java-17-amazon-corretto

cat <<EOF > /home/ec2-user/app.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Application Tier Running")

HTTPServer(('0.0.0.0',8080),Handler).serve_forever()
EOF

python3 /home/ec2-user/app.py &