FROM composer:latest AS vendor
WORKDIR /app
COPY composer.json composer.json

ARG CACHEBUST=1
RUN for attempt in 1 2 3; do \
        composer install --no-interaction --no-progress --no-cache && break; \
        if [ "${attempt}" = "3" ]; then \
            echo "Dist downloads keep failing, falling back to source installs" && \
            composer install --no-interaction --no-progress --no-cache --prefer-source; \
        else \
            echo "Composer install failed, retrying in 15 seconds" && sleep 15; \
        fi; \
    done && \
    find vendor -type d -name .git -prune -exec rm -rf {} + && \
    composer outdated --direct --strict --ignore-platform-reqs magento/magento-coding-standard

FROM php:8.4-cli-alpine
WORKDIR /app

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    docker-php-ext-install pcntl && \
    apk del .build-deps

COPY --from=vendor /app/vendor vendor
COPY entrypoint.sh /usr/local/bin/phpcs-entrypoint

RUN vendor/bin/phpcs -i && \
    mkdir -p /app/workdir

ENTRYPOINT ["/usr/local/bin/phpcs-entrypoint"]
CMD ["--standard=Magento2", "--severity=6"]
