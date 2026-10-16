#!/usr/bin/env bash
# Disposable Linux lab only. Run as lab root, never on your personal host.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session7
s7(){ cd /root/rebuild/Sessions/Session7; cp -r /root/course/session6-7-docker/multi-stage-dockerfile .; docker build -t rebuild-multistage multi-stage-dockerfile; docker run -d --name multistage -p 8080:3000 rebuild-multistage; for i in $(seq 1 20); do curl -f http://localhost:8080 && break; sleep 1; done; docker ps --filter name=multistage; docker rm -f multistage; }
s7
