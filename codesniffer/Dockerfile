FROM php:7.4-cli

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN apt-get update \
    && apt-get install -y git zip unzip zlib1g-dev libzip-dev \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install zip \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install bcmath

RUN composer create-project magento/magento-coding-standard --stability=dev magento-coding-standard && \
    magento-coding-standard/vendor/bin/phpcs --config-set installed_paths /app/magento-coding-standard

ENTRYPOINT ["magento-coding-standard/vendor/bin/phpcs", "--standard=Magento2", "/app/data", "-p"]
CMD ["--severity=6"]
