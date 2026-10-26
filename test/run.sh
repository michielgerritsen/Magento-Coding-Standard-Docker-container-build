#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?Usage: run.sh <image>}"
FIXTURES="$(cd "$(dirname "$0")/fixtures" && pwd)"

assert_violations() {
    local output exit_code=0
    output=$(docker run --rm "$@" --standard=Magento2 --severity=6 --report=emacs -s 2>&1) || exit_code=$?
    if [ "${exit_code}" != "1" ] && [ "${exit_code}" != "2" ]; then
        echo "Expected phpcs to report violations (exit 1 or 2), got exit ${exit_code}: ${output}" >&2
        exit 1
    fi
    echo "${output}" | grep -q "Magento2.Security.Superglobal"
}

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
assert_violations --volume "${FIXTURES}/invalid:/app/data" "${IMAGE}"

echo "==> A module with violations fails when mounted on /app/workdir"
assert_violations --volume "${FIXTURES}/invalid:/app/workdir" "${IMAGE}"

echo "==> A custom ruleset from the mounted module is usable"
docker run --rm --volume "${FIXTURES}/valid:/app/workdir" "${IMAGE}" --severity=9 --standard=/app/workdir/phpcs.xml -s --ignore-annotations > /dev/null 2>&1

echo "==> A path argument is resolved relative to the mounted module"
docker run --rm --volume "${FIXTURES}/valid:/app/data" "${IMAGE}" --standard=Magento2 --severity=6 Example > /dev/null 2>&1

echo "==> Reported paths are relative to the mounted module"
for MOUNT in /app/data /app/workdir; do
    REPORT=$(docker run --rm --volume "${FIXTURES}/invalid:${MOUNT}" "${IMAGE}" --standard=Magento2 --severity=6 --report=emacs 2>&1 || true)
    echo "${REPORT}" | grep -q "^Example/Bad.php:"
    if echo "${REPORT}" | grep -q "/app/"; then
        echo "Expected relative paths for ${MOUNT}, got: ${REPORT}" >&2
        exit 1
    fi
done

echo "==> The pcntl extension is available for parallel runs"
MODULES=$(docker run --rm --entrypoint php "${IMAGE}" -m)
echo "${MODULES}" | grep -q "^pcntl$"
assert_violations --volume "${FIXTURES}/invalid:/app/data" "${IMAGE}" --parallel=2

echo "==> Annotations are ignored by default"
assert_violations --volume "${FIXTURES}/annotated:/app/data" "${IMAGE}"

echo "==> Annotations are respected when IGNORE_ANNOTATIONS=0"
docker run --rm --env IGNORE_ANNOTATIONS=0 --volume "${FIXTURES}/annotated:/app/data" "${IMAGE}" > /dev/null 2>&1

echo "All tests passed"
