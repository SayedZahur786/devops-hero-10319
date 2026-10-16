#!/usr/bin/env bash
# Disposable Linux lab only. Run as lab root, never on your personal host.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session6
s6(){ cd /root/rebuild/Sessions/Session6; for a in nodejs-app python-app java-app Apache-app React-app nginx-app; do mkdir -p "$a"; done
 cat > nodejs-app/server.js <<'JS'
require('http').createServer((q,s)=>s.end('Hello World from Node.js\n')).listen(8080,'0.0.0.0');
JS
 printf 'FROM node:22-alpine\nWORKDIR /app\nCOPY server.js .\nEXPOSE 8080\nCMD ["node","server.js"]\n' > nodejs-app/Dockerfile
 printf 'Hello World from Python\n' > python-app/index.html
 printf 'FROM python:3.12-alpine\nWORKDIR /app\nCOPY index.html .\nEXPOSE 8080\nCMD ["python","-m","http.server","8080"]\n' > python-app/Dockerfile
 cat > java-app/Main.java <<'JAVA'
import com.sun.net.httpserver.HttpServer;import java.net.InetSocketAddress;public class Main {public static void main(String[] a)throws Exception{var s=HttpServer.create(new InetSocketAddress(8080),0);s.createContext("/",e->{byte[] b="Hello World from Java\n".getBytes();e.sendResponseHeaders(200,b.length);e.getResponseBody().write(b);e.close();});s.start();}}
JAVA
 printf 'FROM eclipse-temurin:21-jdk-alpine\nWORKDIR /app\nCOPY Main.java .\nRUN javac Main.java\nEXPOSE 8080\nCMD ["java","Main"]\n' > java-app/Dockerfile
 printf 'Hello World from Apache\n' > Apache-app/index.html
 printf 'FROM httpd:2.4-alpine\nCOPY index.html /usr/local/apache2/htdocs/index.html\n' > Apache-app/Dockerfile
 printf 'Hello World from Nginx\n' > nginx-app/index.html
 printf 'FROM nginx:1.27-alpine\nCOPY index.html /usr/share/nginx/html/index.html\n' > nginx-app/Dockerfile
 cat > React-app/index.html <<'HTML'
<!doctype html><html><body><div id="root"></div><script src="https://unpkg.com/react@18/umd/react.production.min.js"></script><script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script><script>ReactDOM.createRoot(document.getElementById('root')).render(React.createElement('h1',null,'Hello World from React'));</script></body></html>
HTML
 printf 'FROM nginx:1.27-alpine\nCOPY index.html /usr/share/nginx/html/index.html\n' > React-app/Dockerfile
 for a in nodejs-app python-app java-app Apache-app React-app nginx-app; do docker build -t rebuild-${a,,} "$a" && { case $a in *node*|*python*|*java*) p=8080;; *) p=80;; esac; docker run -d --name demo-${a,,} -p 18080:$p rebuild-${a,,}; for i in $(seq 1 20); do curl -f http://localhost:18080 && break; sleep 1; done; docker ps --filter name=demo-${a,,}; docker rm -f demo-${a,,}; }; done
 }
s6
