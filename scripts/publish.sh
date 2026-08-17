#!/usr/bin/env bash
# Idempotent add/commit/push helper for the brand's public image-CDN repo.
# Safe to run any time: commits only when there are changes, pushes with
# rebase-retry, exits nonzero on any git failure (fail loud for cron).
#
# CO-TENANCY: every producer lane (ad previews, email renders, social visuals)
# publishes through this script while holding the shared flock
# (${ADIMAGES_LOCK:-~/.hermes/tmp/adimages-git.lock}). Note `git add -A` is
# repo-wide — any lane's publish sweeps other lanes' pending files along; that
# is by design (a stranded file is worse than a co-committed one).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

git add -A

if [ -z "$(git status --porcelain)" ]; then
  echo "publish: nothing to commit"
else
  n="$(git diff --cached --name-only | wc -l | tr -d ' ')"
  git commit -m "publish: ${n} file(s) updated ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
fi

# Push even when there was nothing to commit (heals a previously failed push).
for attempt in 1 2 3; do
  if git push -u origin main; then
    echo "publish: push ok"
    exit 0
  fi
  echo "publish: WARN push attempt ${attempt} failed" >&2
  git pull --rebase origin main || true
  sleep 5
done

echo "publish: ERROR push failed after 3 attempts" >&2
exit 1
