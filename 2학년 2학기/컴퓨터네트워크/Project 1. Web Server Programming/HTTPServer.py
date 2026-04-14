from http.server import HTTPServer, BaseHTTPRequestHandler
import os.path

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        print(self.path)
        if 'HTTP/1.0' in self.request_version:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"400 Bad Request")
            return
        elif self.path == "/2022057110.html":
            try:
                f = open("2022057110.html", "r")
                self.send_response(200)
                self.send_header('Content-Type', 'text/html')
                self.send_header('Content-Length', '1024')
                self.end_headers()
                self.wfile.write(bytes(f.read()))
                f.close()
            except:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"404 Not Found")
        elif self.path.endswith(".jpg"):
            try:
                f = open('image.jpg', 'rb')
                self.send_response(200)
                self.send_header('Content-Type', 'image/jpg')
                self.send_header('Content-Length', '1024')
                self.end_headers()
                self.wfile.write(f.read())
                f.close()
                return
            except:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"404 Not Found")
        else:
            self.send_response(404)
            self.send_header('Content-Type', 'text/html')
            self.end_headers()
            self.wfile.write(b"404 Not Found")
        return
    
    def do_POST(self):
        length = int(self.headers["Content-Length"])
        path = self.path
        if os.path.exists(path):
            self.send_response(500)
        else:
            with open('.'+path, 'wb') as f:
                f.write(self.rfile.read(length) if length > 0 else b'')
            self.send_response(201)
        self.end_headers()
        return
    
if __name__ == '__main__':
    server = HTTPServer(('', 8888), MyHandler)
    print('Started WebServer on port 8888')
    print('Press Ctrl + c to quit webserver')
    server.serve_forever()
