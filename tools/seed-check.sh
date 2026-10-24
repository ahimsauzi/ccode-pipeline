#!/usr/bin/env bash
# Headless invocation of /seed-check for the daily cron.
# Appends a timestamped report to .seed-check.log at the repo root.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="${REPO_DIR}/.seed-check.log"

cd "${REPO_DIR}"

{
  echo "--- $(date -Iseconds) ---"
  claude -p "/seed-check report"
  echo
} >> "${LOG_FILE}" 2>&1
