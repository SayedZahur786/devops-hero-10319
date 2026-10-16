#!/usr/bin/env bash
set -euo pipefail
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
