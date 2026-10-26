#!/bin/sh
set -eu

if [ -d /app/data ]; then
    ROOT=/app/data
else
    ROOT=/app/workdir
fi

has_target() {
    for argument in "$@"; do
        case "${argument}" in
            -*) ;;
            *) return 0 ;;
        esac
    done
    return 1
}

if ! has_target "$@"; then
    set -- "$@" .
fi

if [ "${IGNORE_ANNOTATIONS:-1}" = "1" ]; then
    set -- --ignore-annotations "$@"
fi

cd "${ROOT}"
exec php -d memory_limit=-1 /app/vendor/bin/phpcs --basepath="${ROOT}" --extensions=php,phtml -p "$@"
