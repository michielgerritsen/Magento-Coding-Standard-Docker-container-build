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
    composer show magento/magento-coding-standard

FROM php:8.3-cli-alpine
WORKDIR /app
COPY --from=vendor /app/vendor vendor

RUN vendor/bin/phpcs -i && \
    mkdir -p /app/workdir && \
    ln -s /app/data /app/workdir/data

ENTRYPOINT ["/app/vendor/bin/phpcs", "--ignore-annotations", "--extensions=php,phtml", "-p", "/app/workdir"]
CMD ["--standard=Magento2", "--severity=6"]
