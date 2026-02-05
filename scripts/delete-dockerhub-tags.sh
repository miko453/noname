#!/usr/bin/env bash
set -euo pipefail

REPO="${1:?usage: $0 <repo> <tag1> [tag2 ...]}"
shift

: "${DOCKERHUB_USERNAME:?DOCKERHUB_USERNAME is required}"
: "${DOCKERHUB_TOKEN:?DOCKERHUB_TOKEN is required}"

TOKEN=$(curl -fsSL -X POST https://hub.docker.com/v2/users/login/ \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"${DOCKERHUB_USERNAME}\",\"password\":\"${DOCKERHUB_TOKEN}\"}" | python -c 'import sys,json;print(json.load(sys.stdin)["token"])')

for tag in "$@"; do
  echo "Deleting ${REPO}:${tag}"
  curl -fsSL -X DELETE \
    -H "Authorization: JWT ${TOKEN}" \
    "https://hub.docker.com/v2/repositories/${REPO}/tags/${tag}/" || true
done
