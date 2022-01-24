FROM composer:latest

COPY composer.json composer.json

RUN composer install && \
    vendor/bin/phpcs --config-set installed_paths vendor/magento/magento-coding-standard,vendor/phpcompatibility/php-compatibility && \
    vendor/bin/phpcs -i

ENTRYPOINT ["vendor/bin/phpcs", "--standard=Magento2", "/app/data", "-p"]
CMD ["--severity=6"]
