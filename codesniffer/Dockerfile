FROM php:8.3-fpm-alpine
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apk add --no-cache libzip-dev zip && \
    docker-php-ext-install zip

COPY composer.json composer.json

RUN /usr/local/bin/composer install && \
    vendor/bin/phpcs --config-set installed_paths vendor/magento/magento-coding-standard,vendor/phpcompatibility/php-compatibility && \
    vendor/bin/phpcs -i && \
    mkdir -p /app/workdir && \
    ln -s /app/data /app/workdir

ENTRYPOINT ["vendor/bin/phpcs", "--standard=Magento2", "--extensions=php,phtml", "-p", "/app/workdir"]
CMD ["--severity=6"]
