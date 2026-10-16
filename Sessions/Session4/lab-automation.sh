#!/usr/bin/env bash
# Disposable Linux lab only. Run as lab root, never on your personal host.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session4
s4(){ cd /root/rebuild/Sessions/Session4; ip addr; ip route; ss -tuln; ping -c 2 127.0.0.1; getent hosts github.com; curl -I --max-time 15 https://github.com; cat /etc/resolv.conf; command -v dig && dig github.com; }
s4
