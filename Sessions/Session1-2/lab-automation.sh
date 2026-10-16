#!/usr/bin/env bash
# Disposable Linux lab only. Run as lab root, never on your personal host.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session1-2
s12(){ cd /root/rebuild/Sessions/Session1-2; echo lab-rebuild > original; ln original hard; ln -s original soft; ls -li original hard soft; rm original; cat hard; cat soft || true; rm hard soft; adduser --disabled-password --gecos 'Demo User' labdemo; id labdemo; journalctl -u ssh --no-pager -n 8; pwd; ls -la; date; whoami; uname -a; df -h /; free -h; ps -ef | head -8; grep -n 'labdemo' /etc/passwd; userdel -r labdemo; }
s12
