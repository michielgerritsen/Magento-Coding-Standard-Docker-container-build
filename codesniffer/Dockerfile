FROM composer:latest

RUN composer require squizlabs/php_codesniffer magento-ecg/coding-standard && \
    vendor/bin/phpcs --config-set installed_paths /app/vendor/magento-ecg/coding-standard
