#!/usr/bin/env bash
# Disposable Linux lab only. Run as lab root, never on your personal host.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session3
s3(){ cd /root/rebuild/Sessions/Session3; cat > system-info.sh <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
mkdir -p /root/rebuild/Sessions/Session3
current_date=$(date)
host=$(hostname)
user=$(whoami)
read -p 'Enter output directory: ' output_dir
mkdir -p "$output_dir"
touch "$output_dir/processes.txt"
echo "Date: $current_date"
echo "Hostname: $host"
echo "Username: $user"
df -h /
ps -ef > "$output_dir/processes.txt"
cat "$output_dir/processes.txt"
SCRIPT
 printf 'system-report\n' | bash system-info.sh; }
s3
