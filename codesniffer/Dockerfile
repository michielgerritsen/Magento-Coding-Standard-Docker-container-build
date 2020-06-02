FROM composer:latest

RUN composer create-project magento/magento-coding-standard --stability=dev magento-coding-standard && \
    magento-coding-standard/vendor/bin/phpcs --config-set installed_paths /app/magento-coding-standard

ENTRYPOINT ["magento-coding-standard/vendor/bin/phpcs", "--standard=Magento2", "/app/data", "-p"]
CMD ["--severity=6"]