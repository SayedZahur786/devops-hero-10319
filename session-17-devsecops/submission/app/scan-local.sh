#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python3 -m pytest --cov=app --cov-report=term-missing
bandit -r app
pip-audit -r requirements.txt
gitleaks dir . --no-banner

