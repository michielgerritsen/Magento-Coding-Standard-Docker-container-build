FROM php:8.3-fpm-alpine
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apk add --no-cache libzip-dev zip && \
    docker-php-ext-install zip

COPY composer.json composer.json

RUN /usr/local/bin/composer install && \
    vendor/bin/phpcs -i && \
    mkdir -p /app/workdir && \
    ln -s /app/data /app/workdir

ENTRYPOINT ["vendor/bin/phpcs", "--ignore-annotations", "--extensions=php,phtml", "-p", "/app/workdir"]
CMD ["--standard=Magento2", "--severity=6"]
