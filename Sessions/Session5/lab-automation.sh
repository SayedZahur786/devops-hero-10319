#!/usr/bin/env bash
# Disposable Linux lab only. Run as lab root, never on your personal host.
set -uo pipefail
mkdir -p /root/rebuild/Sessions/Session5
s5(){ cd /root/rebuild/Sessions/Session5; mkdir demo; cd demo; git init -b main; git config user.name 'Lab Demo'; git config user.email 'lab@example.invalid'; echo one > tracked.txt; git add tracked.txt; git commit -m 'First tracked file'; echo two >> tracked.txt; echo untracked > new.txt; git commit -a -m 'Update tracked only'; git status --short; git commit -m 'No staged changes' || true; git add new.txt; git commit -m 'Add new file'; git switch -c feature; echo selected > selected.txt; git add selected.txt; git commit -m 'Feature to cherry-pick'; picked=$(git rev-parse HEAD); echo other > other.txt; git add other.txt; git commit -m 'Other feature'; git log --oneline; git switch main; git cherry-pick "$picked"; git log --oneline; cat selected.txt; test ! -f other.txt; }
s5
