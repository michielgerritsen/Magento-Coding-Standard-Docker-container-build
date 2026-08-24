#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?Usage: run.sh <image>}"
FIXTURES="$(cd "$(dirname "$0")/fixtures" && pwd)"

echo "==> The Magento2 and EcgM2 standards are installed"
INSTALLED=$(docker run --rm --entrypoint /app/vendor/bin/phpcs "${IMAGE}" -i)
echo "${INSTALLED}"
echo "${INSTALLED}" | grep -q "Magento2"
echo "${INSTALLED}" | grep -q "EcgM2"

echo "==> A clean module passes when mounted on /app/data"
docker run --rm --volume "${FIXTURES}/valid:/app/data" "${IMAGE}" > /dev/null 2>&1

echo "==> A clean module passes when mounted on /app/workdir"
docker run --rm --volume "${FIXTURES}/valid:/app/workdir" "${IMAGE}" > /dev/null 2>&1

echo "==> A module with violations fails when mounted on /app/data"
if docker run --rm --volume "${FIXTURES}/invalid:/app/data" "${IMAGE}" > /dev/null 2>&1; then
    echo "Expected phpcs to report violations, but it exited successfully" >&2
    exit 1
fi

echo "==> A module with violations fails when mounted on /app/workdir"
if docker run --rm --volume "${FIXTURES}/invalid:/app/workdir" "${IMAGE}" > /dev/null 2>&1; then
    echo "Expected phpcs to report violations, but it exited successfully" >&2
    exit 1
fi

echo "==> A custom ruleset from the mounted module is usable"
docker run --rm --volume "${FIXTURES}/valid:/app/workdir" "${IMAGE}" --severity=9 --standard=/app/workdir/phpcs.xml -s --ignore-annotations > /dev/null 2>&1

echo "All tests passed"
